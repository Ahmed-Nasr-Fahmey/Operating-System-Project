
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 43 01 00 00       	call   800179 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 af 13 00 00       	call   8013f2 <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 47 14 00 00       	call   801492 <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 80 1c 80 00       	push   $0x801c80
  800059:	e8 1e 05 00 00       	call   80057c <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("ef_ms1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 40 74             	mov    0x74(%eax),%eax
  800076:	6a 32                	push   $0x32
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	68 b3 1c 80 00       	push   $0x801cb3
  80007f:	e8 e0 15 00 00       	call   801664 <sys_create_env>
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_ms2", (myEnv->page_WS_max_size)-3,(myEnv->SecondListSize), 50);
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 40 74             	mov    0x74(%eax),%eax
  80009f:	83 e8 03             	sub    $0x3,%eax
  8000a2:	6a 32                	push   $0x32
  8000a4:	52                   	push   %edx
  8000a5:	50                   	push   %eax
  8000a6:	68 ba 1c 80 00       	push   $0x801cba
  8000ab:	e8 b4 15 00 00       	call   801664 <sys_create_env>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8000bc:	e8 c1 15 00 00       	call   801682 <sys_run_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 b3 15 00 00       	call   801682 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp

	env_sleep(30000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 30 75 00 00       	push   $0x7530
  8000da:	e8 85 18 00 00       	call   801964 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000e2:	e8 0b 13 00 00       	call   8013f2 <sys_calculate_free_frames>
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	50                   	push   %eax
  8000eb:	68 c4 1c 80 00       	push   $0x801cc4
  8000f0:	e8 87 04 00 00       	call   80057c <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_destroy_env(envIdProcessA);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000fe:	e8 9b 15 00 00       	call   80169e <sys_destroy_env>
  800103:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	ff 75 e8             	pushl  -0x18(%ebp)
  80010c:	e8 8d 15 00 00       	call   80169e <sys_destroy_env>
  800111:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800114:	e8 d9 12 00 00       	call   8013f2 <sys_calculate_free_frames>
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80011c:	e8 71 13 00 00       	call   801492 <sys_pf_calculate_allocated_pages>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80012a:	74 27                	je     800153 <_main+0x11b>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 f8 1c 80 00       	push   $0x801cf8
  800137:	e8 40 04 00 00       	call   80057c <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 48 1d 80 00       	push   $0x801d48
  800147:	6a 24                	push   $0x24
  800149:	68 7e 1d 80 00       	push   $0x801d7e
  80014e:	e8 75 01 00 00       	call   8002c8 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 e4             	pushl  -0x1c(%ebp)
  800159:	68 94 1d 80 00       	push   $0x801d94
  80015e:	e8 19 04 00 00       	call   80057c <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 f4 1d 80 00       	push   $0x801df4
  80016e:	e8 09 04 00 00       	call   80057c <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
	return;
  800176:	90                   	nop
}
  800177:	c9                   	leave  
  800178:	c3                   	ret    

00800179 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80017f:	e8 4e 15 00 00       	call   8016d2 <sys_getenvindex>
  800184:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018a:	89 d0                	mov    %edx,%eax
  80018c:	01 c0                	add    %eax,%eax
  80018e:	01 d0                	add    %edx,%eax
  800190:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800197:	01 c8                	add    %ecx,%eax
  800199:	c1 e0 02             	shl    $0x2,%eax
  80019c:	01 d0                	add    %edx,%eax
  80019e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001a5:	01 c8                	add    %ecx,%eax
  8001a7:	c1 e0 02             	shl    $0x2,%eax
  8001aa:	01 d0                	add    %edx,%eax
  8001ac:	c1 e0 02             	shl    $0x2,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	c1 e0 03             	shl    $0x3,%eax
  8001b4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8001c9:	84 c0                	test   %al,%al
  8001cb:	74 0f                	je     8001dc <libmain+0x63>
		binaryname = myEnv->prog_name;
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	05 18 da 01 00       	add    $0x1da18,%eax
  8001d7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e0:	7e 0a                	jle    8001ec <libmain+0x73>
		binaryname = argv[0];
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	8b 00                	mov    (%eax),%eax
  8001e7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	ff 75 0c             	pushl  0xc(%ebp)
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	e8 3e fe ff ff       	call   800038 <_main>
  8001fa:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001fd:	e8 dd 12 00 00       	call   8014df <sys_disable_interrupt>
	cprintf("**************************************\n");
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 58 1e 80 00       	push   $0x801e58
  80020a:	e8 6d 03 00 00       	call   80057c <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	52                   	push   %edx
  80022c:	50                   	push   %eax
  80022d:	68 80 1e 80 00       	push   $0x801e80
  800232:	e8 45 03 00 00       	call   80057c <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80023a:	a1 20 30 80 00       	mov    0x803020,%eax
  80023f:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800245:	a1 20 30 80 00       	mov    0x803020,%eax
  80024a:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800250:	a1 20 30 80 00       	mov    0x803020,%eax
  800255:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80025b:	51                   	push   %ecx
  80025c:	52                   	push   %edx
  80025d:	50                   	push   %eax
  80025e:	68 a8 1e 80 00       	push   $0x801ea8
  800263:	e8 14 03 00 00       	call   80057c <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80026b:	a1 20 30 80 00       	mov    0x803020,%eax
  800270:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	50                   	push   %eax
  80027a:	68 00 1f 80 00       	push   $0x801f00
  80027f:	e8 f8 02 00 00       	call   80057c <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	68 58 1e 80 00       	push   $0x801e58
  80028f:	e8 e8 02 00 00       	call   80057c <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800297:	e8 5d 12 00 00       	call   8014f9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80029c:	e8 19 00 00 00       	call   8002ba <exit>
}
  8002a1:	90                   	nop
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	6a 00                	push   $0x0
  8002af:	e8 ea 13 00 00       	call   80169e <sys_destroy_env>
  8002b4:	83 c4 10             	add    $0x10,%esp
}
  8002b7:	90                   	nop
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <exit>:

void
exit(void)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c0:	e8 3f 14 00 00       	call   801704 <sys_exit_env>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d1:	83 c0 04             	add    $0x4,%eax
  8002d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d7:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	74 16                	je     8002f6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e0:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	50                   	push   %eax
  8002e9:	68 14 1f 80 00       	push   $0x801f14
  8002ee:	e8 89 02 00 00       	call   80057c <cprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002f6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	50                   	push   %eax
  800302:	68 19 1f 80 00       	push   $0x801f19
  800307:	e8 70 02 00 00       	call   80057c <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 f4             	pushl  -0xc(%ebp)
  800318:	50                   	push   %eax
  800319:	e8 f3 01 00 00       	call   800511 <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	6a 00                	push   $0x0
  800326:	68 35 1f 80 00       	push   $0x801f35
  80032b:	e8 e1 01 00 00       	call   800511 <vcprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800333:	e8 82 ff ff ff       	call   8002ba <exit>

	// should not return here
	while (1) ;
  800338:	eb fe                	jmp    800338 <_panic+0x70>

0080033a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800340:	a1 20 30 80 00       	mov    0x803020,%eax
  800345:	8b 50 74             	mov    0x74(%eax),%edx
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034b:	39 c2                	cmp    %eax,%edx
  80034d:	74 14                	je     800363 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	68 38 1f 80 00       	push   $0x801f38
  800357:	6a 26                	push   $0x26
  800359:	68 84 1f 80 00       	push   $0x801f84
  80035e:	e8 65 ff ff ff       	call   8002c8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80036a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800371:	e9 c2 00 00 00       	jmp    800438 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	75 08                	jne    800393 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80038b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80038e:	e9 a2 00 00 00       	jmp    800435 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800393:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a1:	eb 69                	jmp    80040c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b1:	89 d0                	mov    %edx,%eax
  8003b3:	01 c0                	add    %eax,%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	c1 e0 03             	shl    $0x3,%eax
  8003ba:	01 c8                	add    %ecx,%eax
  8003bc:	8a 40 04             	mov    0x4(%eax),%al
  8003bf:	84 c0                	test   %al,%al
  8003c1:	75 46                	jne    800409 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	c1 e0 03             	shl    $0x3,%eax
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ee:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	01 c8                	add    %ecx,%eax
  8003fa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fc:	39 c2                	cmp    %eax,%edx
  8003fe:	75 09                	jne    800409 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800400:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800407:	eb 12                	jmp    80041b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800409:	ff 45 e8             	incl   -0x18(%ebp)
  80040c:	a1 20 30 80 00       	mov    0x803020,%eax
  800411:	8b 50 74             	mov    0x74(%eax),%edx
  800414:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800417:	39 c2                	cmp    %eax,%edx
  800419:	77 88                	ja     8003a3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80041b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80041f:	75 14                	jne    800435 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	68 90 1f 80 00       	push   $0x801f90
  800429:	6a 3a                	push   $0x3a
  80042b:	68 84 1f 80 00       	push   $0x801f84
  800430:	e8 93 fe ff ff       	call   8002c8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800435:	ff 45 f0             	incl   -0x10(%ebp)
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	0f 8c 32 ff ff ff    	jl     800376 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800444:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800452:	eb 26                	jmp    80047a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800454:	a1 20 30 80 00       	mov    0x803020,%eax
  800459:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80045f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800462:	89 d0                	mov    %edx,%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	01 d0                	add    %edx,%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	8a 40 04             	mov    0x4(%eax),%al
  800470:	3c 01                	cmp    $0x1,%al
  800472:	75 03                	jne    800477 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800474:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800477:	ff 45 e0             	incl   -0x20(%ebp)
  80047a:	a1 20 30 80 00       	mov    0x803020,%eax
  80047f:	8b 50 74             	mov    0x74(%eax),%edx
  800482:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800485:	39 c2                	cmp    %eax,%edx
  800487:	77 cb                	ja     800454 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80048f:	74 14                	je     8004a5 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	68 e4 1f 80 00       	push   $0x801fe4
  800499:	6a 44                	push   $0x44
  80049b:	68 84 1f 80 00       	push   $0x801f84
  8004a0:	e8 23 fe ff ff       	call   8002c8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004a5:	90                   	nop
  8004a6:	c9                   	leave  
  8004a7:	c3                   	ret    

008004a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
  8004ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8004b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b9:	89 0a                	mov    %ecx,(%edx)
  8004bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004be:	88 d1                	mov    %dl,%cl
  8004c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d1:	75 2c                	jne    8004ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d3:	a0 24 30 80 00       	mov    0x803024,%al
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004de:	8b 12                	mov    (%edx),%edx
  8004e0:	89 d1                	mov    %edx,%ecx
  8004e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e5:	83 c2 08             	add    $0x8,%edx
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	50                   	push   %eax
  8004ec:	51                   	push   %ecx
  8004ed:	52                   	push   %edx
  8004ee:	e8 3e 0e 00 00       	call   801331 <sys_cputs>
  8004f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	8b 40 04             	mov    0x4(%eax),%eax
  800505:	8d 50 01             	lea    0x1(%eax),%edx
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80050e:	90                   	nop
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80051a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800521:	00 00 00 
	b.cnt = 0;
  800524:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80052b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80052e:	ff 75 0c             	pushl  0xc(%ebp)
  800531:	ff 75 08             	pushl  0x8(%ebp)
  800534:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053a:	50                   	push   %eax
  80053b:	68 a8 04 80 00       	push   $0x8004a8
  800540:	e8 11 02 00 00       	call   800756 <vprintfmt>
  800545:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800548:	a0 24 30 80 00       	mov    0x803024,%al
  80054d:	0f b6 c0             	movzbl %al,%eax
  800550:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	50                   	push   %eax
  80055a:	52                   	push   %edx
  80055b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800561:	83 c0 08             	add    $0x8,%eax
  800564:	50                   	push   %eax
  800565:	e8 c7 0d 00 00       	call   801331 <sys_cputs>
  80056a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80056d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800574:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <cprintf>:

int cprintf(const char *fmt, ...) {
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800582:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800589:	8d 45 0c             	lea    0xc(%ebp),%eax
  80058c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	ff 75 f4             	pushl  -0xc(%ebp)
  800598:	50                   	push   %eax
  800599:	e8 73 ff ff ff       	call   800511 <vcprintf>
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a7:	c9                   	leave  
  8005a8:	c3                   	ret    

008005a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005a9:	55                   	push   %ebp
  8005aa:	89 e5                	mov    %esp,%ebp
  8005ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005af:	e8 2b 0f 00 00       	call   8014df <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c3:	50                   	push   %eax
  8005c4:	e8 48 ff ff ff       	call   800511 <vcprintf>
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005cf:	e8 25 0f 00 00       	call   8014f9 <sys_enable_interrupt>
	return cnt;
  8005d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	53                   	push   %ebx
  8005dd:	83 ec 14             	sub    $0x14,%esp
  8005e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f7:	77 55                	ja     80064e <printnum+0x75>
  8005f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fc:	72 05                	jb     800603 <printnum+0x2a>
  8005fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800601:	77 4b                	ja     80064e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800603:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800606:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800609:	8b 45 18             	mov    0x18(%ebp),%eax
  80060c:	ba 00 00 00 00       	mov    $0x0,%edx
  800611:	52                   	push   %edx
  800612:	50                   	push   %eax
  800613:	ff 75 f4             	pushl  -0xc(%ebp)
  800616:	ff 75 f0             	pushl  -0x10(%ebp)
  800619:	e8 fa 13 00 00       	call   801a18 <__udivdi3>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	83 ec 04             	sub    $0x4,%esp
  800624:	ff 75 20             	pushl  0x20(%ebp)
  800627:	53                   	push   %ebx
  800628:	ff 75 18             	pushl  0x18(%ebp)
  80062b:	52                   	push   %edx
  80062c:	50                   	push   %eax
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 08             	pushl  0x8(%ebp)
  800633:	e8 a1 ff ff ff       	call   8005d9 <printnum>
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	eb 1a                	jmp    800657 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	ff 75 20             	pushl  0x20(%ebp)
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	ff d0                	call   *%eax
  80064b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80064e:	ff 4d 1c             	decl   0x1c(%ebp)
  800651:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800655:	7f e6                	jg     80063d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800657:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80065a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800665:	53                   	push   %ebx
  800666:	51                   	push   %ecx
  800667:	52                   	push   %edx
  800668:	50                   	push   %eax
  800669:	e8 ba 14 00 00       	call   801b28 <__umoddi3>
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	05 54 22 80 00       	add    $0x802254,%eax
  800676:	8a 00                	mov    (%eax),%al
  800678:	0f be c0             	movsbl %al,%eax
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	50                   	push   %eax
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	ff d0                	call   *%eax
  800687:	83 c4 10             	add    $0x10,%esp
}
  80068a:	90                   	nop
  80068b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068e:	c9                   	leave  
  80068f:	c3                   	ret    

00800690 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800693:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800697:	7e 1c                	jle    8006b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8d 50 08             	lea    0x8(%eax),%edx
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	89 10                	mov    %edx,(%eax)
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	83 e8 08             	sub    $0x8,%eax
  8006ae:	8b 50 04             	mov    0x4(%eax),%edx
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	eb 40                	jmp    8006f5 <getuint+0x65>
	else if (lflag)
  8006b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b9:	74 1e                	je     8006d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	8d 50 04             	lea    0x4(%eax),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	89 10                	mov    %edx,(%eax)
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	eb 1c                	jmp    8006f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006f5:	5d                   	pop    %ebp
  8006f6:	c3                   	ret    

008006f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006fe:	7e 1c                	jle    80071c <getint+0x25>
		return va_arg(*ap, long long);
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	8d 50 08             	lea    0x8(%eax),%edx
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	89 10                	mov    %edx,(%eax)
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	83 e8 08             	sub    $0x8,%eax
  800715:	8b 50 04             	mov    0x4(%eax),%edx
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	eb 38                	jmp    800754 <getint+0x5d>
	else if (lflag)
  80071c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800720:	74 1a                	je     80073c <getint+0x45>
		return va_arg(*ap, long);
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	8d 50 04             	lea    0x4(%eax),%edx
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	89 10                	mov    %edx,(%eax)
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	83 e8 04             	sub    $0x4,%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	99                   	cltd   
  80073a:	eb 18                	jmp    800754 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	89 10                	mov    %edx,(%eax)
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	99                   	cltd   
}
  800754:	5d                   	pop    %ebp
  800755:	c3                   	ret    

00800756 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	56                   	push   %esi
  80075a:	53                   	push   %ebx
  80075b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075e:	eb 17                	jmp    800777 <vprintfmt+0x21>
			if (ch == '\0')
  800760:	85 db                	test   %ebx,%ebx
  800762:	0f 84 af 03 00 00    	je     800b17 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	53                   	push   %ebx
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800777:	8b 45 10             	mov    0x10(%ebp),%eax
  80077a:	8d 50 01             	lea    0x1(%eax),%edx
  80077d:	89 55 10             	mov    %edx,0x10(%ebp)
  800780:	8a 00                	mov    (%eax),%al
  800782:	0f b6 d8             	movzbl %al,%ebx
  800785:	83 fb 25             	cmp    $0x25,%ebx
  800788:	75 d6                	jne    800760 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80078a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80078e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800795:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80079c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	8d 50 01             	lea    0x1(%eax),%edx
  8007b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b3:	8a 00                	mov    (%eax),%al
  8007b5:	0f b6 d8             	movzbl %al,%ebx
  8007b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007bb:	83 f8 55             	cmp    $0x55,%eax
  8007be:	0f 87 2b 03 00 00    	ja     800aef <vprintfmt+0x399>
  8007c4:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  8007cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d1:	eb d7                	jmp    8007aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d1                	jmp    8007aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e3:	89 d0                	mov    %edx,%eax
  8007e5:	c1 e0 02             	shl    $0x2,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	01 c0                	add    %eax,%eax
  8007ec:	01 d8                	add    %ebx,%eax
  8007ee:	83 e8 30             	sub    $0x30,%eax
  8007f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f7:	8a 00                	mov    (%eax),%al
  8007f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ff:	7e 3e                	jle    80083f <vprintfmt+0xe9>
  800801:	83 fb 39             	cmp    $0x39,%ebx
  800804:	7f 39                	jg     80083f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800806:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800809:	eb d5                	jmp    8007e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 c0 04             	add    $0x4,%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80081f:	eb 1f                	jmp    800840 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800821:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800825:	79 83                	jns    8007aa <vprintfmt+0x54>
				width = 0;
  800827:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80082e:	e9 77 ff ff ff       	jmp    8007aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800833:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80083a:	e9 6b ff ff ff       	jmp    8007aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80083f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800840:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800844:	0f 89 60 ff ff ff    	jns    8007aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80084a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80084d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800850:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800857:	e9 4e ff ff ff       	jmp    8007aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80085c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80085f:	e9 46 ff ff ff       	jmp    8007aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	83 c0 04             	add    $0x4,%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 e8 04             	sub    $0x4,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	50                   	push   %eax
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
			break;
  800884:	e9 89 02 00 00       	jmp    800b12 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 c0 04             	add    $0x4,%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 e8 04             	sub    $0x4,%eax
  800898:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80089a:	85 db                	test   %ebx,%ebx
  80089c:	79 02                	jns    8008a0 <vprintfmt+0x14a>
				err = -err;
  80089e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a0:	83 fb 64             	cmp    $0x64,%ebx
  8008a3:	7f 0b                	jg     8008b0 <vprintfmt+0x15a>
  8008a5:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  8008ac:	85 f6                	test   %esi,%esi
  8008ae:	75 19                	jne    8008c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b0:	53                   	push   %ebx
  8008b1:	68 65 22 80 00       	push   $0x802265
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	ff 75 08             	pushl  0x8(%ebp)
  8008bc:	e8 5e 02 00 00       	call   800b1f <printfmt>
  8008c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c4:	e9 49 02 00 00       	jmp    800b12 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008c9:	56                   	push   %esi
  8008ca:	68 6e 22 80 00       	push   $0x80226e
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	ff 75 08             	pushl  0x8(%ebp)
  8008d5:	e8 45 02 00 00       	call   800b1f <printfmt>
  8008da:	83 c4 10             	add    $0x10,%esp
			break;
  8008dd:	e9 30 02 00 00       	jmp    800b12 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	83 c0 04             	add    $0x4,%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 30                	mov    (%eax),%esi
  8008f3:	85 f6                	test   %esi,%esi
  8008f5:	75 05                	jne    8008fc <vprintfmt+0x1a6>
				p = "(null)";
  8008f7:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  8008fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800900:	7e 6d                	jle    80096f <vprintfmt+0x219>
  800902:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800906:	74 67                	je     80096f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	50                   	push   %eax
  80090f:	56                   	push   %esi
  800910:	e8 0c 03 00 00       	call   800c21 <strnlen>
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80091b:	eb 16                	jmp    800933 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80091d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800930:	ff 4d e4             	decl   -0x1c(%ebp)
  800933:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800937:	7f e4                	jg     80091d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800939:	eb 34                	jmp    80096f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80093b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80093f:	74 1c                	je     80095d <vprintfmt+0x207>
  800941:	83 fb 1f             	cmp    $0x1f,%ebx
  800944:	7e 05                	jle    80094b <vprintfmt+0x1f5>
  800946:	83 fb 7e             	cmp    $0x7e,%ebx
  800949:	7e 12                	jle    80095d <vprintfmt+0x207>
					putch('?', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 3f                	push   $0x3f
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	eb 0f                	jmp    80096c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	53                   	push   %ebx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096c:	ff 4d e4             	decl   -0x1c(%ebp)
  80096f:	89 f0                	mov    %esi,%eax
  800971:	8d 70 01             	lea    0x1(%eax),%esi
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f be d8             	movsbl %al,%ebx
  800979:	85 db                	test   %ebx,%ebx
  80097b:	74 24                	je     8009a1 <vprintfmt+0x24b>
  80097d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800981:	78 b8                	js     80093b <vprintfmt+0x1e5>
  800983:	ff 4d e0             	decl   -0x20(%ebp)
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	79 af                	jns    80093b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	eb 13                	jmp    8009a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	6a 20                	push   $0x20
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	ff d0                	call   *%eax
  80099b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099e:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a5:	7f e7                	jg     80098e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a7:	e9 66 01 00 00       	jmp    800b12 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 3c fd ff ff       	call   8006f7 <getint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ca:	85 d2                	test   %edx,%edx
  8009cc:	79 23                	jns    8009f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	6a 2d                	push   $0x2d
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e4:	f7 d8                	neg    %eax
  8009e6:	83 d2 00             	adc    $0x0,%edx
  8009e9:	f7 da                	neg    %edx
  8009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f8:	e9 bc 00 00 00       	jmp    800ab9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 e8             	pushl  -0x18(%ebp)
  800a03:	8d 45 14             	lea    0x14(%ebp),%eax
  800a06:	50                   	push   %eax
  800a07:	e8 84 fc ff ff       	call   800690 <getuint>
  800a0c:	83 c4 10             	add    $0x10,%esp
  800a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a15:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a1c:	e9 98 00 00 00       	jmp    800ab9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	6a 58                	push   $0x58
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	6a 58                	push   $0x58
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	6a 58                	push   $0x58
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
			break;
  800a51:	e9 bc 00 00 00       	jmp    800b12 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 30                	push   $0x30
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	6a 78                	push   $0x78
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	ff d0                	call   *%eax
  800a73:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	83 c0 04             	add    $0x4,%eax
  800a7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 e8 04             	sub    $0x4,%eax
  800a85:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a98:	eb 1f                	jmp    800ab9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa0:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 e7 fb ff ff       	call   800690 <getuint>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac0:	83 ec 04             	sub    $0x4,%esp
  800ac3:	52                   	push   %edx
  800ac4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  800acb:	ff 75 f0             	pushl  -0x10(%ebp)
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	ff 75 08             	pushl  0x8(%ebp)
  800ad4:	e8 00 fb ff ff       	call   8005d9 <printnum>
  800ad9:	83 c4 20             	add    $0x20,%esp
			break;
  800adc:	eb 34                	jmp    800b12 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	53                   	push   %ebx
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			break;
  800aed:	eb 23                	jmp    800b12 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 25                	push   $0x25
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aff:	ff 4d 10             	decl   0x10(%ebp)
  800b02:	eb 03                	jmp    800b07 <vprintfmt+0x3b1>
  800b04:	ff 4d 10             	decl   0x10(%ebp)
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	48                   	dec    %eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	3c 25                	cmp    $0x25,%al
  800b0f:	75 f3                	jne    800b04 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b11:	90                   	nop
		}
	}
  800b12:	e9 47 fc ff ff       	jmp    80075e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b17:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b25:	8d 45 10             	lea    0x10(%ebp),%eax
  800b28:	83 c0 04             	add    $0x4,%eax
  800b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b31:	ff 75 f4             	pushl  -0xc(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	ff 75 08             	pushl  0x8(%ebp)
  800b3b:	e8 16 fc ff ff       	call   800756 <vprintfmt>
  800b40:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b43:	90                   	nop
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8b 40 08             	mov    0x8(%eax),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8b 10                	mov    (%eax),%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8b 40 04             	mov    0x4(%eax),%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	73 12                	jae    800b79 <sprintputch+0x33>
		*b->buf++ = ch;
  800b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 0a                	mov    %ecx,(%edx)
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	88 10                	mov    %dl,(%eax)
}
  800b79:	90                   	nop
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	01 d0                	add    %edx,%eax
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba1:	74 06                	je     800ba9 <vsnprintf+0x2d>
  800ba3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba7:	7f 07                	jg     800bb0 <vsnprintf+0x34>
		return -E_INVAL;
  800ba9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bae:	eb 20                	jmp    800bd0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb0:	ff 75 14             	pushl  0x14(%ebp)
  800bb3:	ff 75 10             	pushl  0x10(%ebp)
  800bb6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb9:	50                   	push   %eax
  800bba:	68 46 0b 80 00       	push   $0x800b46
  800bbf:	e8 92 fb ff ff       	call   800756 <vprintfmt>
  800bc4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bdb:	83 c0 04             	add    $0x4,%eax
  800bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be1:	8b 45 10             	mov    0x10(%ebp),%eax
  800be4:	ff 75 f4             	pushl  -0xc(%ebp)
  800be7:	50                   	push   %eax
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	ff 75 08             	pushl  0x8(%ebp)
  800bee:	e8 89 ff ff ff       	call   800b7c <vsnprintf>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfc:	c9                   	leave  
  800bfd:	c3                   	ret    

00800bfe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0b:	eb 06                	jmp    800c13 <strlen+0x15>
		n++;
  800c0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	75 f1                	jne    800c0d <strlen+0xf>
		n++;
	return n;
  800c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2e:	eb 09                	jmp    800c39 <strnlen+0x18>
		n++;
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c33:	ff 45 08             	incl   0x8(%ebp)
  800c36:	ff 4d 0c             	decl   0xc(%ebp)
  800c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3d:	74 09                	je     800c48 <strnlen+0x27>
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	84 c0                	test   %al,%al
  800c46:	75 e8                	jne    800c30 <strnlen+0xf>
		n++;
	return n;
  800c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c59:	90                   	nop
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8d 50 01             	lea    0x1(%eax),%edx
  800c60:	89 55 08             	mov    %edx,0x8(%ebp)
  800c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	75 e4                	jne    800c5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8e:	eb 1f                	jmp    800caf <strncpy+0x34>
		*dst++ = *src;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 08             	mov    %edx,0x8(%ebp)
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	74 03                	je     800cac <strncpy+0x31>
			src++;
  800ca9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cac:	ff 45 fc             	incl   -0x4(%ebp)
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb5:	72 d9                	jb     800c90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	74 30                	je     800cfe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cce:	eb 16                	jmp    800ce6 <strlcpy+0x2a>
			*dst++ = *src++;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8d 50 01             	lea    0x1(%eax),%edx
  800cd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce2:	8a 12                	mov    (%edx),%dl
  800ce4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce6:	ff 4d 10             	decl   0x10(%ebp)
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 09                	je     800cf8 <strlcpy+0x3c>
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	75 d8                	jne    800cd0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0d:	eb 06                	jmp    800d15 <strcmp+0xb>
		p++, q++;
  800d0f:	ff 45 08             	incl   0x8(%ebp)
  800d12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	74 0e                	je     800d2c <strcmp+0x22>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 10                	mov    (%eax),%dl
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	38 c2                	cmp    %al,%dl
  800d2a:	74 e3                	je     800d0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d0             	movzbl %al,%edx
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	29 c2                	sub    %eax,%edx
  800d3e:	89 d0                	mov    %edx,%eax
}
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d45:	eb 09                	jmp    800d50 <strncmp+0xe>
		n--, p++, q++;
  800d47:	ff 4d 10             	decl   0x10(%ebp)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	74 17                	je     800d6d <strncmp+0x2b>
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 0e                	je     800d6d <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 10                	mov    (%eax),%dl
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	38 c2                	cmp    %al,%dl
  800d6b:	74 da                	je     800d47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d71:	75 07                	jne    800d7a <strncmp+0x38>
		return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
  800d78:	eb 14                	jmp    800d8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	0f b6 d0             	movzbl %al,%edx
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 c0             	movzbl %al,%eax
  800d8a:	29 c2                	sub    %eax,%edx
  800d8c:	89 d0                	mov    %edx,%eax
}
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9c:	eb 12                	jmp    800db0 <strchr+0x20>
		if (*s == c)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da6:	75 05                	jne    800dad <strchr+0x1d>
			return (char *) s;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	eb 11                	jmp    800dbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	75 e5                	jne    800d9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 04             	sub    $0x4,%esp
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcc:	eb 0d                	jmp    800ddb <strfind+0x1b>
		if (*s == c)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd6:	74 0e                	je     800de6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd8:	ff 45 08             	incl   0x8(%ebp)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	84 c0                	test   %al,%al
  800de2:	75 ea                	jne    800dce <strfind+0xe>
  800de4:	eb 01                	jmp    800de7 <strfind+0x27>
		if (*s == c)
			break;
  800de6:	90                   	nop
	return (char *) s;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dfe:	eb 0e                	jmp    800e0e <memset+0x22>
		*p++ = c;
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	8d 50 01             	lea    0x1(%eax),%edx
  800e06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e0e:	ff 4d f8             	decl   -0x8(%ebp)
  800e11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e15:	79 e9                	jns    800e00 <memset+0x14>
		*p++ = c;

	return v;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

00800e1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e2e:	eb 16                	jmp    800e46 <memcpy+0x2a>
		*d++ = *s++;
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 dd                	jne    800e30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e70:	73 50                	jae    800ec2 <memmove+0x6a>
  800e72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e75:	8b 45 10             	mov    0x10(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e7d:	76 43                	jbe    800ec2 <memmove+0x6a>
		s += n;
  800e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e8b:	eb 10                	jmp    800e9d <memmove+0x45>
			*--d = *--s;
  800e8d:	ff 4d f8             	decl   -0x8(%ebp)
  800e90:	ff 4d fc             	decl   -0x4(%ebp)
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	75 e3                	jne    800e8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eaa:	eb 23                	jmp    800ecf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaf:	8d 50 01             	lea    0x1(%eax),%edx
  800eb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ebe:	8a 12                	mov    (%edx),%dl
  800ec0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	75 dd                	jne    800eac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ee6:	eb 2a                	jmp    800f12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	38 c2                	cmp    %al,%dl
  800ef4:	74 16                	je     800f0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f b6 d0             	movzbl %al,%edx
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
  800f0a:	eb 18                	jmp    800f24 <memcmp+0x50>
		s1++, s2++;
  800f0c:	ff 45 fc             	incl   -0x4(%ebp)
  800f0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f18:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	75 c9                	jne    800ee8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	01 d0                	add    %edx,%eax
  800f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f37:	eb 15                	jmp    800f4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	0f b6 d0             	movzbl %al,%edx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	0f b6 c0             	movzbl %al,%eax
  800f47:	39 c2                	cmp    %eax,%edx
  800f49:	74 0d                	je     800f58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f54:	72 e3                	jb     800f39 <memfind+0x13>
  800f56:	eb 01                	jmp    800f59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f58:	90                   	nop
	return (void *) s;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f72:	eb 03                	jmp    800f77 <strtol+0x19>
		s++;
  800f74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 20                	cmp    $0x20,%al
  800f7e:	74 f4                	je     800f74 <strtol+0x16>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 09                	cmp    $0x9,%al
  800f87:	74 eb                	je     800f74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 2b                	cmp    $0x2b,%al
  800f90:	75 05                	jne    800f97 <strtol+0x39>
		s++;
  800f92:	ff 45 08             	incl   0x8(%ebp)
  800f95:	eb 13                	jmp    800faa <strtol+0x4c>
	else if (*s == '-')
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3c 2d                	cmp    $0x2d,%al
  800f9e:	75 0a                	jne    800faa <strtol+0x4c>
		s++, neg = 1;
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800faa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fae:	74 06                	je     800fb6 <strtol+0x58>
  800fb0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fb4:	75 20                	jne    800fd6 <strtol+0x78>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 30                	cmp    $0x30,%al
  800fbd:	75 17                	jne    800fd6 <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	40                   	inc    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 78                	cmp    $0x78,%al
  800fc7:	75 0d                	jne    800fd6 <strtol+0x78>
		s += 2, base = 16;
  800fc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fd4:	eb 28                	jmp    800ffe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fda:	75 15                	jne    800ff1 <strtol+0x93>
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3c 30                	cmp    $0x30,%al
  800fe3:	75 0c                	jne    800ff1 <strtol+0x93>
		s++, base = 8;
  800fe5:	ff 45 08             	incl   0x8(%ebp)
  800fe8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fef:	eb 0d                	jmp    800ffe <strtol+0xa0>
	else if (base == 0)
  800ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff5:	75 07                	jne    800ffe <strtol+0xa0>
		base = 10;
  800ff7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3c 2f                	cmp    $0x2f,%al
  801005:	7e 19                	jle    801020 <strtol+0xc2>
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 39                	cmp    $0x39,%al
  80100e:	7f 10                	jg     801020 <strtol+0xc2>
			dig = *s - '0';
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f be c0             	movsbl %al,%eax
  801018:	83 e8 30             	sub    $0x30,%eax
  80101b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80101e:	eb 42                	jmp    801062 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 60                	cmp    $0x60,%al
  801027:	7e 19                	jle    801042 <strtol+0xe4>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 7a                	cmp    $0x7a,%al
  801030:	7f 10                	jg     801042 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 e8 57             	sub    $0x57,%eax
  80103d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801040:	eb 20                	jmp    801062 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 40                	cmp    $0x40,%al
  801049:	7e 39                	jle    801084 <strtol+0x126>
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 5a                	cmp    $0x5a,%al
  801052:	7f 30                	jg     801084 <strtol+0x126>
			dig = *s - 'A' + 10;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	0f be c0             	movsbl %al,%eax
  80105c:	83 e8 37             	sub    $0x37,%eax
  80105f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801065:	3b 45 10             	cmp    0x10(%ebp),%eax
  801068:	7d 19                	jge    801083 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	0f af 45 10          	imul   0x10(%ebp),%eax
  801074:	89 c2                	mov    %eax,%edx
  801076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80107e:	e9 7b ff ff ff       	jmp    800ffe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801083:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801084:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801088:	74 08                	je     801092 <strtol+0x134>
		*endptr = (char *) s;
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801092:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801096:	74 07                	je     80109f <strtol+0x141>
  801098:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109b:	f7 d8                	neg    %eax
  80109d:	eb 03                	jmp    8010a2 <strtol+0x144>
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <ltostr>:

void
ltostr(long value, char *str)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bc:	79 13                	jns    8010d1 <ltostr+0x2d>
	{
		neg = 1;
  8010be:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010cb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ce:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010d9:	99                   	cltd   
  8010da:	f7 f9                	idiv   %ecx
  8010dc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	01 d0                	add    %edx,%eax
  8010ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f2:	83 c2 30             	add    $0x30,%edx
  8010f5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ff:	f7 e9                	imul   %ecx
  801101:	c1 fa 02             	sar    $0x2,%edx
  801104:	89 c8                	mov    %ecx,%eax
  801106:	c1 f8 1f             	sar    $0x1f,%eax
  801109:	29 c2                	sub    %eax,%edx
  80110b:	89 d0                	mov    %edx,%eax
  80110d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801110:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801113:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801118:	f7 e9                	imul   %ecx
  80111a:	c1 fa 02             	sar    $0x2,%edx
  80111d:	89 c8                	mov    %ecx,%eax
  80111f:	c1 f8 1f             	sar    $0x1f,%eax
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	c1 e0 02             	shl    $0x2,%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	01 c0                	add    %eax,%eax
  80112d:	29 c1                	sub    %eax,%ecx
  80112f:	89 ca                	mov    %ecx,%edx
  801131:	85 d2                	test   %edx,%edx
  801133:	75 9c                	jne    8010d1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	48                   	dec    %eax
  801140:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801143:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801147:	74 3d                	je     801186 <ltostr+0xe2>
		start = 1 ;
  801149:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801150:	eb 34                	jmp    801186 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	01 c2                	add    %eax,%edx
  801167:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 c8                	add    %ecx,%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801173:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 c2                	add    %eax,%edx
  80117b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80117e:	88 02                	mov    %al,(%edx)
		start++ ;
  801180:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801183:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118c:	7c c4                	jl     801152 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80118e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	01 d0                	add    %edx,%eax
  801196:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801199:	90                   	nop
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a2:	ff 75 08             	pushl  0x8(%ebp)
  8011a5:	e8 54 fa ff ff       	call   800bfe <strlen>
  8011aa:	83 c4 04             	add    $0x4,%esp
  8011ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	e8 46 fa ff ff       	call   800bfe <strlen>
  8011b8:	83 c4 04             	add    $0x4,%esp
  8011bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011cc:	eb 17                	jmp    8011e5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	01 c2                	add    %eax,%edx
  8011d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	01 c8                	add    %ecx,%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e2:	ff 45 fc             	incl   -0x4(%ebp)
  8011e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011eb:	7c e1                	jl     8011ce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011fb:	eb 1f                	jmp    80121c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801206:	89 c2                	mov    %eax,%edx
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801219:	ff 45 f8             	incl   -0x8(%ebp)
  80121c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801222:	7c d9                	jl     8011fd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	c6 00 00             	movb   $0x0,(%eax)
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124a:	8b 45 10             	mov    0x10(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801255:	eb 0c                	jmp    801263 <strsplit+0x31>
			*string++ = 0;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8d 50 01             	lea    0x1(%eax),%edx
  80125d:	89 55 08             	mov    %edx,0x8(%ebp)
  801260:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	84 c0                	test   %al,%al
  80126a:	74 18                	je     801284 <strsplit+0x52>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	0f be c0             	movsbl %al,%eax
  801274:	50                   	push   %eax
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	e8 13 fb ff ff       	call   800d90 <strchr>
  80127d:	83 c4 08             	add    $0x8,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	75 d3                	jne    801257 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 5a                	je     8012e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80128d:	8b 45 14             	mov    0x14(%ebp),%eax
  801290:	8b 00                	mov    (%eax),%eax
  801292:	83 f8 0f             	cmp    $0xf,%eax
  801295:	75 07                	jne    80129e <strsplit+0x6c>
		{
			return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
  80129c:	eb 66                	jmp    801304 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80129e:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8012a9:	89 0a                	mov    %ecx,(%edx)
  8012ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	01 c2                	add    %eax,%edx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012bc:	eb 03                	jmp    8012c1 <strsplit+0x8f>
			string++;
  8012be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 8b                	je     801255 <strsplit+0x23>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 b5 fa ff ff       	call   800d90 <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	74 dc                	je     8012be <strsplit+0x8c>
			string++;
	}
  8012e2:	e9 6e ff ff ff       	jmp    801255 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012eb:	8b 00                	mov    (%eax),%eax
  8012ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	57                   	push   %edi
  80130a:	56                   	push   %esi
  80130b:	53                   	push   %ebx
  80130c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8b 55 0c             	mov    0xc(%ebp),%edx
  801315:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801318:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80131b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80131e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801321:	cd 30                	int    $0x30
  801323:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	5b                   	pop    %ebx
  80132d:	5e                   	pop    %esi
  80132e:	5f                   	pop    %edi
  80132f:	5d                   	pop    %ebp
  801330:	c3                   	ret    

00801331 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80133d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	52                   	push   %edx
  801349:	ff 75 0c             	pushl  0xc(%ebp)
  80134c:	50                   	push   %eax
  80134d:	6a 00                	push   $0x0
  80134f:	e8 b2 ff ff ff       	call   801306 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	90                   	nop
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_cgetc>:

int
sys_cgetc(void)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 01                	push   $0x1
  801369:	e8 98 ff ff ff       	call   801306 <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801376:	8b 55 0c             	mov    0xc(%ebp),%edx
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	52                   	push   %edx
  801383:	50                   	push   %eax
  801384:	6a 05                	push   $0x5
  801386:	e8 7b ff ff ff       	call   801306 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	56                   	push   %esi
  801394:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801395:	8b 75 18             	mov    0x18(%ebp),%esi
  801398:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80139b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80139e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	51                   	push   %ecx
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	6a 06                	push   $0x6
  8013ab:	e8 56 ff ff ff       	call   801306 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	52                   	push   %edx
  8013ca:	50                   	push   %eax
  8013cb:	6a 07                	push   $0x7
  8013cd:	e8 34 ff ff ff       	call   801306 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	6a 08                	push   $0x8
  8013e8:	e8 19 ff ff ff       	call   801306 <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 09                	push   $0x9
  801401:	e8 00 ff ff ff       	call   801306 <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 0a                	push   $0xa
  80141a:	e8 e7 fe ff ff       	call   801306 <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 0b                	push   $0xb
  801433:	e8 ce fe ff ff       	call   801306 <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	6a 0f                	push   $0xf
  80144e:	e8 b3 fe ff ff       	call   801306 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
	return;
  801456:	90                   	nop
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	6a 10                	push   $0x10
  80146a:	e8 97 fe ff ff       	call   801306 <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
	return ;
  801472:	90                   	nop
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	ff 75 10             	pushl  0x10(%ebp)
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	6a 11                	push   $0x11
  801487:	e8 7a fe ff ff       	call   801306 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
	return ;
  80148f:	90                   	nop
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 0c                	push   $0xc
  8014a1:	e8 60 fe ff ff       	call   801306 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	6a 0d                	push   $0xd
  8014bb:	e8 46 fe ff ff       	call   801306 <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 0e                	push   $0xe
  8014d4:	e8 2d fe ff ff       	call   801306 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	90                   	nop
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 13                	push   $0x13
  8014ee:	e8 13 fe ff ff       	call   801306 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 14                	push   $0x14
  801508:	e8 f9 fd ff ff       	call   801306 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	90                   	nop
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_cputc>:


void
sys_cputc(const char c)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80151f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	50                   	push   %eax
  80152c:	6a 15                	push   $0x15
  80152e:	e8 d3 fd ff ff       	call   801306 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	90                   	nop
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 16                	push   $0x16
  801548:	e8 b9 fd ff ff       	call   801306 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	90                   	nop
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	50                   	push   %eax
  801563:	6a 17                	push   $0x17
  801565:	e8 9c fd ff ff       	call   801306 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801572:	8b 55 0c             	mov    0xc(%ebp),%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	6a 1a                	push   $0x1a
  801582:	e8 7f fd ff ff       	call   801306 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	52                   	push   %edx
  80159c:	50                   	push   %eax
  80159d:	6a 18                	push   $0x18
  80159f:	e8 62 fd ff ff       	call   801306 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	52                   	push   %edx
  8015ba:	50                   	push   %eax
  8015bb:	6a 19                	push   $0x19
  8015bd:	e8 44 fd ff ff       	call   801306 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	90                   	nop
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	6a 00                	push   $0x0
  8015e0:	51                   	push   %ecx
  8015e1:	52                   	push   %edx
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	50                   	push   %eax
  8015e6:	6a 1b                	push   $0x1b
  8015e8:	e8 19 fd ff ff       	call   801306 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	52                   	push   %edx
  801602:	50                   	push   %eax
  801603:	6a 1c                	push   $0x1c
  801605:	e8 fc fc ff ff       	call   801306 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801612:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	51                   	push   %ecx
  801620:	52                   	push   %edx
  801621:	50                   	push   %eax
  801622:	6a 1d                	push   $0x1d
  801624:	e8 dd fc ff ff       	call   801306 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	52                   	push   %edx
  80163e:	50                   	push   %eax
  80163f:	6a 1e                	push   $0x1e
  801641:	e8 c0 fc ff ff       	call   801306 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 1f                	push   $0x1f
  80165a:	e8 a7 fc ff ff       	call   801306 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	ff 75 14             	pushl  0x14(%ebp)
  80166f:	ff 75 10             	pushl  0x10(%ebp)
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	50                   	push   %eax
  801676:	6a 20                	push   $0x20
  801678:	e8 89 fc ff ff       	call   801306 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	50                   	push   %eax
  801691:	6a 21                	push   $0x21
  801693:	e8 6e fc ff ff       	call   801306 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	50                   	push   %eax
  8016ad:	6a 22                	push   $0x22
  8016af:	e8 52 fc ff ff       	call   801306 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 02                	push   $0x2
  8016c8:	e8 39 fc ff ff       	call   801306 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 03                	push   $0x3
  8016e1:	e8 20 fc ff ff       	call   801306 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 04                	push   $0x4
  8016fa:	e8 07 fc ff ff       	call   801306 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_exit_env>:


void sys_exit_env(void)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 23                	push   $0x23
  801713:	e8 ee fb ff ff       	call   801306 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	90                   	nop
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801724:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801727:	8d 50 04             	lea    0x4(%eax),%edx
  80172a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 24                	push   $0x24
  801737:	e8 ca fb ff ff       	call   801306 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
	return result;
  80173f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801742:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801745:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801748:	89 01                	mov    %eax,(%ecx)
  80174a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	c9                   	leave  
  801751:	c2 04 00             	ret    $0x4

00801754 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	ff 75 10             	pushl  0x10(%ebp)
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	ff 75 08             	pushl  0x8(%ebp)
  801764:	6a 12                	push   $0x12
  801766:	e8 9b fb ff ff       	call   801306 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
	return ;
  80176e:	90                   	nop
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_rcr2>:
uint32 sys_rcr2()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 25                	push   $0x25
  801780:	e8 81 fb ff ff       	call   801306 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801796:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	50                   	push   %eax
  8017a3:	6a 26                	push   $0x26
  8017a5:	e8 5c fb ff ff       	call   801306 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <rsttst>:
void rsttst()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 28                	push   $0x28
  8017bf:	e8 42 fb ff ff       	call   801306 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c7:	90                   	nop
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017d6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017dd:	52                   	push   %edx
  8017de:	50                   	push   %eax
  8017df:	ff 75 10             	pushl  0x10(%ebp)
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 27                	push   $0x27
  8017ea:	e8 17 fb ff ff       	call   801306 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <chktst>:
void chktst(uint32 n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	6a 29                	push   $0x29
  801805:	e8 fc fa ff ff       	call   801306 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
	return ;
  80180d:	90                   	nop
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <inctst>:

void inctst()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 2a                	push   $0x2a
  80181f:	e8 e2 fa ff ff       	call   801306 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return ;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <gettst>:
uint32 gettst()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 2b                	push   $0x2b
  801839:	e8 c8 fa ff ff       	call   801306 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 2c                	push   $0x2c
  801855:	e8 ac fa ff ff       	call   801306 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
  80185d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801860:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801864:	75 07                	jne    80186d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801866:	b8 01 00 00 00       	mov    $0x1,%eax
  80186b:	eb 05                	jmp    801872 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 2c                	push   $0x2c
  801886:	e8 7b fa ff ff       	call   801306 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
  80188e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801891:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801895:	75 07                	jne    80189e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801897:	b8 01 00 00 00       	mov    $0x1,%eax
  80189c:	eb 05                	jmp    8018a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 2c                	push   $0x2c
  8018b7:	e8 4a fa ff ff       	call   801306 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018c2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018c6:	75 07                	jne    8018cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cd:	eb 05                	jmp    8018d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 2c                	push   $0x2c
  8018e8:	e8 19 fa ff ff       	call   801306 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
  8018f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018f3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018f7:	75 07                	jne    801900 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fe:	eb 05                	jmp    801905 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 2d                	push   $0x2d
  801917:	e8 ea f9 ff ff       	call   801306 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
	return ;
  80191f:	90                   	nop
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801926:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801929:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	53                   	push   %ebx
  801935:	51                   	push   %ecx
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 2e                	push   $0x2e
  80193a:	e8 c7 f9 ff ff       	call   801306 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 2f                	push   $0x2f
  80195a:	e8 a7 f9 ff ff       	call   801306 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80196a:	8b 55 08             	mov    0x8(%ebp),%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	c1 e0 02             	shl    $0x2,%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197b:	01 d0                	add    %edx,%eax
  80197d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801984:	01 d0                	add    %edx,%eax
  801986:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c1 e0 04             	shl    $0x4,%eax
  801992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80199c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80199f:	83 ec 0c             	sub    $0xc,%esp
  8019a2:	50                   	push   %eax
  8019a3:	e8 76 fd ff ff       	call   80171e <sys_get_virtual_time>
  8019a8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019ab:	eb 41                	jmp    8019ee <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	50                   	push   %eax
  8019b4:	e8 65 fd ff ff       	call   80171e <sys_get_virtual_time>
  8019b9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c2:	29 c2                	sub    %eax,%edx
  8019c4:	89 d0                	mov    %edx,%eax
  8019c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cf:	89 d1                	mov    %edx,%ecx
  8019d1:	29 c1                	sub    %eax,%ecx
  8019d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d9:	39 c2                	cmp    %eax,%edx
  8019db:	0f 97 c0             	seta   %al
  8019de:	0f b6 c0             	movzbl %al,%eax
  8019e1:	29 c1                	sub    %eax,%ecx
  8019e3:	89 c8                	mov    %ecx,%eax
  8019e5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f4:	72 b7                	jb     8019ad <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019f6:	90                   	nop
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a06:	eb 03                	jmp    801a0b <busy_wait+0x12>
  801a08:	ff 45 fc             	incl   -0x4(%ebp)
  801a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a11:	72 f5                	jb     801a08 <busy_wait+0xf>
	return i;
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <__udivdi3>:
  801a18:	55                   	push   %ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2f:	89 ca                	mov    %ecx,%edx
  801a31:	89 f8                	mov    %edi,%eax
  801a33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a37:	85 f6                	test   %esi,%esi
  801a39:	75 2d                	jne    801a68 <__udivdi3+0x50>
  801a3b:	39 cf                	cmp    %ecx,%edi
  801a3d:	77 65                	ja     801aa4 <__udivdi3+0x8c>
  801a3f:	89 fd                	mov    %edi,%ebp
  801a41:	85 ff                	test   %edi,%edi
  801a43:	75 0b                	jne    801a50 <__udivdi3+0x38>
  801a45:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4a:	31 d2                	xor    %edx,%edx
  801a4c:	f7 f7                	div    %edi
  801a4e:	89 c5                	mov    %eax,%ebp
  801a50:	31 d2                	xor    %edx,%edx
  801a52:	89 c8                	mov    %ecx,%eax
  801a54:	f7 f5                	div    %ebp
  801a56:	89 c1                	mov    %eax,%ecx
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	f7 f5                	div    %ebp
  801a5c:	89 cf                	mov    %ecx,%edi
  801a5e:	89 fa                	mov    %edi,%edx
  801a60:	83 c4 1c             	add    $0x1c,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	77 28                	ja     801a94 <__udivdi3+0x7c>
  801a6c:	0f bd fe             	bsr    %esi,%edi
  801a6f:	83 f7 1f             	xor    $0x1f,%edi
  801a72:	75 40                	jne    801ab4 <__udivdi3+0x9c>
  801a74:	39 ce                	cmp    %ecx,%esi
  801a76:	72 0a                	jb     801a82 <__udivdi3+0x6a>
  801a78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a7c:	0f 87 9e 00 00 00    	ja     801b20 <__udivdi3+0x108>
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
  801a87:	89 fa                	mov    %edi,%edx
  801a89:	83 c4 1c             	add    $0x1c,%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5f                   	pop    %edi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
  801a91:	8d 76 00             	lea    0x0(%esi),%esi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	31 c0                	xor    %eax,%eax
  801a98:	89 fa                	mov    %edi,%edx
  801a9a:	83 c4 1c             	add    $0x1c,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5f                   	pop    %edi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	f7 f7                	div    %edi
  801aa8:	31 ff                	xor    %edi,%edi
  801aaa:	89 fa                	mov    %edi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab9:	89 eb                	mov    %ebp,%ebx
  801abb:	29 fb                	sub    %edi,%ebx
  801abd:	89 f9                	mov    %edi,%ecx
  801abf:	d3 e6                	shl    %cl,%esi
  801ac1:	89 c5                	mov    %eax,%ebp
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ed                	shr    %cl,%ebp
  801ac7:	89 e9                	mov    %ebp,%ecx
  801ac9:	09 f1                	or     %esi,%ecx
  801acb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e0                	shl    %cl,%eax
  801ad3:	89 c5                	mov    %eax,%ebp
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 ee                	shr    %cl,%esi
  801adb:	89 f9                	mov    %edi,%ecx
  801add:	d3 e2                	shl    %cl,%edx
  801adf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 e8                	shr    %cl,%eax
  801ae7:	09 c2                	or     %eax,%edx
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	89 f2                	mov    %esi,%edx
  801aed:	f7 74 24 0c          	divl   0xc(%esp)
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	f7 e5                	mul    %ebp
  801af7:	39 d6                	cmp    %edx,%esi
  801af9:	72 19                	jb     801b14 <__udivdi3+0xfc>
  801afb:	74 0b                	je     801b08 <__udivdi3+0xf0>
  801afd:	89 d8                	mov    %ebx,%eax
  801aff:	31 ff                	xor    %edi,%edi
  801b01:	e9 58 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b0c:	89 f9                	mov    %edi,%ecx
  801b0e:	d3 e2                	shl    %cl,%edx
  801b10:	39 c2                	cmp    %eax,%edx
  801b12:	73 e9                	jae    801afd <__udivdi3+0xe5>
  801b14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b17:	31 ff                	xor    %edi,%edi
  801b19:	e9 40 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	31 c0                	xor    %eax,%eax
  801b22:	e9 37 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b27:	90                   	nop

00801b28 <__umoddi3>:
  801b28:	55                   	push   %ebp
  801b29:	57                   	push   %edi
  801b2a:	56                   	push   %esi
  801b2b:	53                   	push   %ebx
  801b2c:	83 ec 1c             	sub    $0x1c,%esp
  801b2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b47:	89 f3                	mov    %esi,%ebx
  801b49:	89 fa                	mov    %edi,%edx
  801b4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4f:	89 34 24             	mov    %esi,(%esp)
  801b52:	85 c0                	test   %eax,%eax
  801b54:	75 1a                	jne    801b70 <__umoddi3+0x48>
  801b56:	39 f7                	cmp    %esi,%edi
  801b58:	0f 86 a2 00 00 00    	jbe    801c00 <__umoddi3+0xd8>
  801b5e:	89 c8                	mov    %ecx,%eax
  801b60:	89 f2                	mov    %esi,%edx
  801b62:	f7 f7                	div    %edi
  801b64:	89 d0                	mov    %edx,%eax
  801b66:	31 d2                	xor    %edx,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	39 f0                	cmp    %esi,%eax
  801b72:	0f 87 ac 00 00 00    	ja     801c24 <__umoddi3+0xfc>
  801b78:	0f bd e8             	bsr    %eax,%ebp
  801b7b:	83 f5 1f             	xor    $0x1f,%ebp
  801b7e:	0f 84 ac 00 00 00    	je     801c30 <__umoddi3+0x108>
  801b84:	bf 20 00 00 00       	mov    $0x20,%edi
  801b89:	29 ef                	sub    %ebp,%edi
  801b8b:	89 fe                	mov    %edi,%esi
  801b8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e0                	shl    %cl,%eax
  801b95:	89 d7                	mov    %edx,%edi
  801b97:	89 f1                	mov    %esi,%ecx
  801b99:	d3 ef                	shr    %cl,%edi
  801b9b:	09 c7                	or     %eax,%edi
  801b9d:	89 e9                	mov    %ebp,%ecx
  801b9f:	d3 e2                	shl    %cl,%edx
  801ba1:	89 14 24             	mov    %edx,(%esp)
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	d3 e0                	shl    %cl,%eax
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb8:	89 f1                	mov    %esi,%ecx
  801bba:	d3 e8                	shr    %cl,%eax
  801bbc:	09 d0                	or     %edx,%eax
  801bbe:	d3 eb                	shr    %cl,%ebx
  801bc0:	89 da                	mov    %ebx,%edx
  801bc2:	f7 f7                	div    %edi
  801bc4:	89 d3                	mov    %edx,%ebx
  801bc6:	f7 24 24             	mull   (%esp)
  801bc9:	89 c6                	mov    %eax,%esi
  801bcb:	89 d1                	mov    %edx,%ecx
  801bcd:	39 d3                	cmp    %edx,%ebx
  801bcf:	0f 82 87 00 00 00    	jb     801c5c <__umoddi3+0x134>
  801bd5:	0f 84 91 00 00 00    	je     801c6c <__umoddi3+0x144>
  801bdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bdf:	29 f2                	sub    %esi,%edx
  801be1:	19 cb                	sbb    %ecx,%ebx
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be9:	d3 e0                	shl    %cl,%eax
  801beb:	89 e9                	mov    %ebp,%ecx
  801bed:	d3 ea                	shr    %cl,%edx
  801bef:	09 d0                	or     %edx,%eax
  801bf1:	89 e9                	mov    %ebp,%ecx
  801bf3:	d3 eb                	shr    %cl,%ebx
  801bf5:	89 da                	mov    %ebx,%edx
  801bf7:	83 c4 1c             	add    $0x1c,%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    
  801bff:	90                   	nop
  801c00:	89 fd                	mov    %edi,%ebp
  801c02:	85 ff                	test   %edi,%edi
  801c04:	75 0b                	jne    801c11 <__umoddi3+0xe9>
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f7                	div    %edi
  801c0f:	89 c5                	mov    %eax,%ebp
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f5                	div    %ebp
  801c17:	89 c8                	mov    %ecx,%eax
  801c19:	f7 f5                	div    %ebp
  801c1b:	89 d0                	mov    %edx,%eax
  801c1d:	e9 44 ff ff ff       	jmp    801b66 <__umoddi3+0x3e>
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	89 c8                	mov    %ecx,%eax
  801c26:	89 f2                	mov    %esi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	3b 04 24             	cmp    (%esp),%eax
  801c33:	72 06                	jb     801c3b <__umoddi3+0x113>
  801c35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c39:	77 0f                	ja     801c4a <__umoddi3+0x122>
  801c3b:	89 f2                	mov    %esi,%edx
  801c3d:	29 f9                	sub    %edi,%ecx
  801c3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c43:	89 14 24             	mov    %edx,(%esp)
  801c46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c4e:	8b 14 24             	mov    (%esp),%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d 76 00             	lea    0x0(%esi),%esi
  801c5c:	2b 04 24             	sub    (%esp),%eax
  801c5f:	19 fa                	sbb    %edi,%edx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	89 c6                	mov    %eax,%esi
  801c65:	e9 71 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c70:	72 ea                	jb     801c5c <__umoddi3+0x134>
  801c72:	89 d9                	mov    %ebx,%ecx
  801c74:	e9 62 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
