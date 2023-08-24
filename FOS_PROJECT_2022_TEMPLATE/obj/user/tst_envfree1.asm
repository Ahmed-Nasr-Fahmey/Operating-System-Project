
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 76 01 00 00       	call   8001ac <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 e2 13 00 00       	call   801425 <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 7a 14 00 00       	call   8014c5 <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 c0 1c 80 00       	push   $0x801cc0
  800059:	e8 51 05 00 00       	call   8005af <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("ef_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 40 74             	mov    0x74(%eax),%eax
  800076:	6a 32                	push   $0x32
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	68 f3 1c 80 00       	push   $0x801cf3
  80007f:	e8 13 16 00 00       	call   801697 <sys_create_env>
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_fact", (myEnv->page_WS_max_size)-1,(myEnv->SecondListSize), 50);
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 40 74             	mov    0x74(%eax),%eax
  80009f:	48                   	dec    %eax
  8000a0:	6a 32                	push   $0x32
  8000a2:	52                   	push   %edx
  8000a3:	50                   	push   %eax
  8000a4:	68 fa 1c 80 00       	push   $0x801cfa
  8000a9:	e8 e9 15 00 00       	call   801697 <sys_create_env>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessC = sys_create_env("ef_fos_add",(myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b9:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8000bf:	89 c2                	mov    %eax,%edx
  8000c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c6:	8b 40 74             	mov    0x74(%eax),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	6a 32                	push   $0x32
  8000ce:	52                   	push   %edx
  8000cf:	50                   	push   %eax
  8000d0:	68 02 1d 80 00       	push   $0x801d02
  8000d5:	e8 bd 15 00 00       	call   801697 <sys_create_env>
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e6:	e8 ca 15 00 00       	call   8016b5 <sys_run_env>
  8000eb:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000f4:	e8 bc 15 00 00       	call   8016b5 <sys_run_env>
  8000f9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	e8 ae 15 00 00       	call   8016b5 <sys_run_env>
  800107:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 70 17 00 00       	push   $0x1770
  800112:	e8 80 18 00 00       	call   801997 <env_sleep>
  800117:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80011a:	e8 06 13 00 00       	call   801425 <sys_calculate_free_frames>
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	50                   	push   %eax
  800123:	68 10 1d 80 00       	push   $0x801d10
  800128:	e8 82 04 00 00       	call   8005af <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_destroy_env(envIdProcessA);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 ec             	pushl  -0x14(%ebp)
  800136:	e8 96 15 00 00       	call   8016d1 <sys_destroy_env>
  80013b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 e8             	pushl  -0x18(%ebp)
  800144:	e8 88 15 00 00       	call   8016d1 <sys_destroy_env>
  800149:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessC);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800152:	e8 7a 15 00 00       	call   8016d1 <sys_destroy_env>
  800157:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80015a:	e8 c6 12 00 00       	call   801425 <sys_calculate_free_frames>
  80015f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800162:	e8 5e 13 00 00       	call   8014c5 <sys_pf_calculate_allocated_pages>
  800167:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if((freeFrames_after - freeFrames_before) !=0)
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800170:	74 14                	je     800186 <_main+0x14e>
		panic("env_free() does not work correctly... check it again.") ;
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	68 44 1d 80 00       	push   $0x801d44
  80017a:	6a 26                	push   $0x26
  80017c:	68 7a 1d 80 00       	push   $0x801d7a
  800181:	e8 75 01 00 00       	call   8002fb <_panic>

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 e0             	pushl  -0x20(%ebp)
  80018c:	68 90 1d 80 00       	push   $0x801d90
  800191:	e8 19 04 00 00       	call   8005af <cprintf>
  800196:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 f0 1d 80 00       	push   $0x801df0
  8001a1:	e8 09 04 00 00       	call   8005af <cprintf>
  8001a6:	83 c4 10             	add    $0x10,%esp
	return;
  8001a9:	90                   	nop
}
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b2:	e8 4e 15 00 00       	call   801705 <sys_getenvindex>
  8001b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001ca:	01 c8                	add    %ecx,%eax
  8001cc:	c1 e0 02             	shl    $0x2,%eax
  8001cf:	01 d0                	add    %edx,%eax
  8001d1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001d8:	01 c8                	add    %ecx,%eax
  8001da:	c1 e0 02             	shl    $0x2,%eax
  8001dd:	01 d0                	add    %edx,%eax
  8001df:	c1 e0 02             	shl    $0x2,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ec:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8001fc:	84 c0                	test   %al,%al
  8001fe:	74 0f                	je     80020f <libmain+0x63>
		binaryname = myEnv->prog_name;
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	05 18 da 01 00       	add    $0x1da18,%eax
  80020a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800213:	7e 0a                	jle    80021f <libmain+0x73>
		binaryname = argv[0];
  800215:	8b 45 0c             	mov    0xc(%ebp),%eax
  800218:	8b 00                	mov    (%eax),%eax
  80021a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	ff 75 0c             	pushl  0xc(%ebp)
  800225:	ff 75 08             	pushl  0x8(%ebp)
  800228:	e8 0b fe ff ff       	call   800038 <_main>
  80022d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800230:	e8 dd 12 00 00       	call   801512 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 54 1e 80 00       	push   $0x801e54
  80023d:	e8 6d 03 00 00       	call   8005af <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800245:	a1 20 30 80 00       	mov    0x803020,%eax
  80024a:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800250:	a1 20 30 80 00       	mov    0x803020,%eax
  800255:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	52                   	push   %edx
  80025f:	50                   	push   %eax
  800260:	68 7c 1e 80 00       	push   $0x801e7c
  800265:	e8 45 03 00 00       	call   8005af <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80026d:	a1 20 30 80 00       	mov    0x803020,%eax
  800272:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800283:	a1 20 30 80 00       	mov    0x803020,%eax
  800288:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80028e:	51                   	push   %ecx
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	68 a4 1e 80 00       	push   $0x801ea4
  800296:	e8 14 03 00 00       	call   8005af <cprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029e:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a3:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	50                   	push   %eax
  8002ad:	68 fc 1e 80 00       	push   $0x801efc
  8002b2:	e8 f8 02 00 00       	call   8005af <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	68 54 1e 80 00       	push   $0x801e54
  8002c2:	e8 e8 02 00 00       	call   8005af <cprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002ca:	e8 5d 12 00 00       	call   80152c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002cf:	e8 19 00 00 00       	call   8002ed <exit>
}
  8002d4:	90                   	nop
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 00                	push   $0x0
  8002e2:	e8 ea 13 00 00       	call   8016d1 <sys_destroy_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
}
  8002ea:	90                   	nop
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <exit>:

void
exit(void)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f3:	e8 3f 14 00 00       	call   801737 <sys_exit_env>
}
  8002f8:	90                   	nop
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800301:	8d 45 10             	lea    0x10(%ebp),%eax
  800304:	83 c0 04             	add    $0x4,%eax
  800307:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030a:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80030f:	85 c0                	test   %eax,%eax
  800311:	74 16                	je     800329 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800313:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 10 1f 80 00       	push   $0x801f10
  800321:	e8 89 02 00 00       	call   8005af <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800329:	a1 00 30 80 00       	mov    0x803000,%eax
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	50                   	push   %eax
  800335:	68 15 1f 80 00       	push   $0x801f15
  80033a:	e8 70 02 00 00       	call   8005af <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	ff 75 f4             	pushl  -0xc(%ebp)
  80034b:	50                   	push   %eax
  80034c:	e8 f3 01 00 00       	call   800544 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	6a 00                	push   $0x0
  800359:	68 31 1f 80 00       	push   $0x801f31
  80035e:	e8 e1 01 00 00       	call   800544 <vcprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800366:	e8 82 ff ff ff       	call   8002ed <exit>

	// should not return here
	while (1) ;
  80036b:	eb fe                	jmp    80036b <_panic+0x70>

0080036d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800373:	a1 20 30 80 00       	mov    0x803020,%eax
  800378:	8b 50 74             	mov    0x74(%eax),%edx
  80037b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037e:	39 c2                	cmp    %eax,%edx
  800380:	74 14                	je     800396 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 34 1f 80 00       	push   $0x801f34
  80038a:	6a 26                	push   $0x26
  80038c:	68 80 1f 80 00       	push   $0x801f80
  800391:	e8 65 ff ff ff       	call   8002fb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a4:	e9 c2 00 00 00       	jmp    80046b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	75 08                	jne    8003c6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c1:	e9 a2 00 00 00       	jmp    800468 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d4:	eb 69                	jmp    80043f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003db:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e4:	89 d0                	mov    %edx,%eax
  8003e6:	01 c0                	add    %eax,%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	c1 e0 03             	shl    $0x3,%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8a 40 04             	mov    0x4(%eax),%al
  8003f2:	84 c0                	test   %al,%al
  8003f4:	75 46                	jne    80043c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800401:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800404:	89 d0                	mov    %edx,%eax
  800406:	01 c0                	add    %eax,%eax
  800408:	01 d0                	add    %edx,%eax
  80040a:	c1 e0 03             	shl    $0x3,%eax
  80040d:	01 c8                	add    %ecx,%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800414:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800421:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	01 c8                	add    %ecx,%eax
  80042d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042f:	39 c2                	cmp    %eax,%edx
  800431:	75 09                	jne    80043c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800433:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043a:	eb 12                	jmp    80044e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	ff 45 e8             	incl   -0x18(%ebp)
  80043f:	a1 20 30 80 00       	mov    0x803020,%eax
  800444:	8b 50 74             	mov    0x74(%eax),%edx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	39 c2                	cmp    %eax,%edx
  80044c:	77 88                	ja     8003d6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80044e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800452:	75 14                	jne    800468 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 8c 1f 80 00       	push   $0x801f8c
  80045c:	6a 3a                	push   $0x3a
  80045e:	68 80 1f 80 00       	push   $0x801f80
  800463:	e8 93 fe ff ff       	call   8002fb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800468:	ff 45 f0             	incl   -0x10(%ebp)
  80046b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800471:	0f 8c 32 ff ff ff    	jl     8003a9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800477:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800485:	eb 26                	jmp    8004ad <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800487:	a1 20 30 80 00       	mov    0x803020,%eax
  80048c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800492:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800495:	89 d0                	mov    %edx,%eax
  800497:	01 c0                	add    %eax,%eax
  800499:	01 d0                	add    %edx,%eax
  80049b:	c1 e0 03             	shl    $0x3,%eax
  80049e:	01 c8                	add    %ecx,%eax
  8004a0:	8a 40 04             	mov    0x4(%eax),%al
  8004a3:	3c 01                	cmp    $0x1,%al
  8004a5:	75 03                	jne    8004aa <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004aa:	ff 45 e0             	incl   -0x20(%ebp)
  8004ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b2:	8b 50 74             	mov    0x74(%eax),%edx
  8004b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b8:	39 c2                	cmp    %eax,%edx
  8004ba:	77 cb                	ja     800487 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c2:	74 14                	je     8004d8 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004c4:	83 ec 04             	sub    $0x4,%esp
  8004c7:	68 e0 1f 80 00       	push   $0x801fe0
  8004cc:	6a 44                	push   $0x44
  8004ce:	68 80 1f 80 00       	push   $0x801f80
  8004d3:	e8 23 fe ff ff       	call   8002fb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	89 0a                	mov    %ecx,(%edx)
  8004ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f1:	88 d1                	mov    %dl,%cl
  8004f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800504:	75 2c                	jne    800532 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800506:	a0 24 30 80 00       	mov    0x803024,%al
  80050b:	0f b6 c0             	movzbl %al,%eax
  80050e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800511:	8b 12                	mov    (%edx),%edx
  800513:	89 d1                	mov    %edx,%ecx
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	83 c2 08             	add    $0x8,%edx
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	50                   	push   %eax
  80051f:	51                   	push   %ecx
  800520:	52                   	push   %edx
  800521:	e8 3e 0e 00 00       	call   801364 <sys_cputs>
  800526:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	8b 40 04             	mov    0x4(%eax),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800541:	90                   	nop
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80054d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800554:	00 00 00 
	b.cnt = 0;
  800557:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80055e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800561:	ff 75 0c             	pushl  0xc(%ebp)
  800564:	ff 75 08             	pushl  0x8(%ebp)
  800567:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056d:	50                   	push   %eax
  80056e:	68 db 04 80 00       	push   $0x8004db
  800573:	e8 11 02 00 00       	call   800789 <vprintfmt>
  800578:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80057b:	a0 24 30 80 00       	mov    0x803024,%al
  800580:	0f b6 c0             	movzbl %al,%eax
  800583:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800589:	83 ec 04             	sub    $0x4,%esp
  80058c:	50                   	push   %eax
  80058d:	52                   	push   %edx
  80058e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800594:	83 c0 08             	add    $0x8,%eax
  800597:	50                   	push   %eax
  800598:	e8 c7 0d 00 00       	call   801364 <sys_cputs>
  80059d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <cprintf>:

int cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	e8 73 ff ff ff       	call   800544 <vcprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005e2:	e8 2b 0f 00 00       	call   801512 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 48 ff ff ff       	call   800544 <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800602:	e8 25 0f 00 00       	call   80152c <sys_enable_interrupt>
	return cnt;
  800607:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060a:	c9                   	leave  
  80060b:	c3                   	ret    

0080060c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	53                   	push   %ebx
  800610:	83 ec 14             	sub    $0x14,%esp
  800613:	8b 45 10             	mov    0x10(%ebp),%eax
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80061f:	8b 45 18             	mov    0x18(%ebp),%eax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062a:	77 55                	ja     800681 <printnum+0x75>
  80062c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062f:	72 05                	jb     800636 <printnum+0x2a>
  800631:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800634:	77 4b                	ja     800681 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800636:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800639:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80063c:	8b 45 18             	mov    0x18(%ebp),%eax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	ff 75 f4             	pushl  -0xc(%ebp)
  800649:	ff 75 f0             	pushl  -0x10(%ebp)
  80064c:	e8 fb 13 00 00       	call   801a4c <__udivdi3>
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	ff 75 20             	pushl  0x20(%ebp)
  80065a:	53                   	push   %ebx
  80065b:	ff 75 18             	pushl  0x18(%ebp)
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 a1 ff ff ff       	call   80060c <printnum>
  80066b:	83 c4 20             	add    $0x20,%esp
  80066e:	eb 1a                	jmp    80068a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	ff 75 20             	pushl  0x20(%ebp)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800681:	ff 4d 1c             	decl   0x1c(%ebp)
  800684:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800688:	7f e6                	jg     800670 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80068d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800698:	53                   	push   %ebx
  800699:	51                   	push   %ecx
  80069a:	52                   	push   %edx
  80069b:	50                   	push   %eax
  80069c:	e8 bb 14 00 00       	call   801b5c <__umoddi3>
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	05 54 22 80 00       	add    $0x802254,%eax
  8006a9:	8a 00                	mov    (%eax),%al
  8006ab:	0f be c0             	movsbl %al,%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	50                   	push   %eax
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	ff d0                	call   *%eax
  8006ba:	83 c4 10             	add    $0x10,%esp
}
  8006bd:	90                   	nop
  8006be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c1:	c9                   	leave  
  8006c2:	c3                   	ret    

008006c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ca:	7e 1c                	jle    8006e8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	8d 50 08             	lea    0x8(%eax),%edx
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	89 10                	mov    %edx,(%eax)
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	83 e8 08             	sub    $0x8,%eax
  8006e1:	8b 50 04             	mov    0x4(%eax),%edx
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	eb 40                	jmp    800728 <getuint+0x65>
	else if (lflag)
  8006e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ec:	74 1e                	je     80070c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 04             	lea    0x4(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 04             	sub    $0x4,%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	ba 00 00 00 00       	mov    $0x0,%edx
  80070a:	eb 1c                	jmp    800728 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800728:	5d                   	pop    %ebp
  800729:	c3                   	ret    

0080072a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800731:	7e 1c                	jle    80074f <getint+0x25>
		return va_arg(*ap, long long);
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 10                	mov    %edx,(%eax)
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 e8 08             	sub    $0x8,%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	eb 38                	jmp    800787 <getint+0x5d>
	else if (lflag)
  80074f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800753:	74 1a                	je     80076f <getint+0x45>
		return va_arg(*ap, long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 04             	lea    0x4(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	99                   	cltd   
  80076d:	eb 18                	jmp    800787 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
}
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	56                   	push   %esi
  80078d:	53                   	push   %ebx
  80078e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800791:	eb 17                	jmp    8007aa <vprintfmt+0x21>
			if (ch == '\0')
  800793:	85 db                	test   %ebx,%ebx
  800795:	0f 84 af 03 00 00    	je     800b4a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	53                   	push   %ebx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	8d 50 01             	lea    0x1(%eax),%edx
  8007b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b3:	8a 00                	mov    (%eax),%al
  8007b5:	0f b6 d8             	movzbl %al,%ebx
  8007b8:	83 fb 25             	cmp    $0x25,%ebx
  8007bb:	75 d6                	jne    800793 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e0:	8d 50 01             	lea    0x1(%eax),%edx
  8007e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e6:	8a 00                	mov    (%eax),%al
  8007e8:	0f b6 d8             	movzbl %al,%ebx
  8007eb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007ee:	83 f8 55             	cmp    $0x55,%eax
  8007f1:	0f 87 2b 03 00 00    	ja     800b22 <vprintfmt+0x399>
  8007f7:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  8007fe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800800:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800804:	eb d7                	jmp    8007dd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800806:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80080a:	eb d1                	jmp    8007dd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800813:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800816:	89 d0                	mov    %edx,%eax
  800818:	c1 e0 02             	shl    $0x2,%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	01 c0                	add    %eax,%eax
  80081f:	01 d8                	add    %ebx,%eax
  800821:	83 e8 30             	sub    $0x30,%eax
  800824:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	8a 00                	mov    (%eax),%al
  80082c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80082f:	83 fb 2f             	cmp    $0x2f,%ebx
  800832:	7e 3e                	jle    800872 <vprintfmt+0xe9>
  800834:	83 fb 39             	cmp    $0x39,%ebx
  800837:	7f 39                	jg     800872 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800839:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80083c:	eb d5                	jmp    800813 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800852:	eb 1f                	jmp    800873 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800854:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800858:	79 83                	jns    8007dd <vprintfmt+0x54>
				width = 0;
  80085a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800861:	e9 77 ff ff ff       	jmp    8007dd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800866:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80086d:	e9 6b ff ff ff       	jmp    8007dd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800872:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800877:	0f 89 60 ff ff ff    	jns    8007dd <vprintfmt+0x54>
				width = precision, precision = -1;
  80087d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800883:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80088a:	e9 4e ff ff ff       	jmp    8007dd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80088f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800892:	e9 46 ff ff ff       	jmp    8007dd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	50                   	push   %eax
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
			break;
  8008b7:	e9 89 02 00 00       	jmp    800b45 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	83 c0 04             	add    $0x4,%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 e8 04             	sub    $0x4,%eax
  8008cb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008cd:	85 db                	test   %ebx,%ebx
  8008cf:	79 02                	jns    8008d3 <vprintfmt+0x14a>
				err = -err;
  8008d1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d3:	83 fb 64             	cmp    $0x64,%ebx
  8008d6:	7f 0b                	jg     8008e3 <vprintfmt+0x15a>
  8008d8:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 19                	jne    8008fc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e3:	53                   	push   %ebx
  8008e4:	68 65 22 80 00       	push   $0x802265
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	ff 75 08             	pushl  0x8(%ebp)
  8008ef:	e8 5e 02 00 00       	call   800b52 <printfmt>
  8008f4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008f7:	e9 49 02 00 00       	jmp    800b45 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008fc:	56                   	push   %esi
  8008fd:	68 6e 22 80 00       	push   $0x80226e
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 45 02 00 00       	call   800b52 <printfmt>
  80090d:	83 c4 10             	add    $0x10,%esp
			break;
  800910:	e9 30 02 00 00       	jmp    800b45 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 c0 04             	add    $0x4,%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	83 e8 04             	sub    $0x4,%eax
  800924:	8b 30                	mov    (%eax),%esi
  800926:	85 f6                	test   %esi,%esi
  800928:	75 05                	jne    80092f <vprintfmt+0x1a6>
				p = "(null)";
  80092a:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  80092f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800933:	7e 6d                	jle    8009a2 <vprintfmt+0x219>
  800935:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800939:	74 67                	je     8009a2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	50                   	push   %eax
  800942:	56                   	push   %esi
  800943:	e8 0c 03 00 00       	call   800c54 <strnlen>
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80094e:	eb 16                	jmp    800966 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800950:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800963:	ff 4d e4             	decl   -0x1c(%ebp)
  800966:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096a:	7f e4                	jg     800950 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096c:	eb 34                	jmp    8009a2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80096e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800972:	74 1c                	je     800990 <vprintfmt+0x207>
  800974:	83 fb 1f             	cmp    $0x1f,%ebx
  800977:	7e 05                	jle    80097e <vprintfmt+0x1f5>
  800979:	83 fb 7e             	cmp    $0x7e,%ebx
  80097c:	7e 12                	jle    800990 <vprintfmt+0x207>
					putch('?', putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	6a 3f                	push   $0x3f
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	eb 0f                	jmp    80099f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	ff d0                	call   *%eax
  80099c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099f:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a2:	89 f0                	mov    %esi,%eax
  8009a4:	8d 70 01             	lea    0x1(%eax),%esi
  8009a7:	8a 00                	mov    (%eax),%al
  8009a9:	0f be d8             	movsbl %al,%ebx
  8009ac:	85 db                	test   %ebx,%ebx
  8009ae:	74 24                	je     8009d4 <vprintfmt+0x24b>
  8009b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b4:	78 b8                	js     80096e <vprintfmt+0x1e5>
  8009b6:	ff 4d e0             	decl   -0x20(%ebp)
  8009b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009bd:	79 af                	jns    80096e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	eb 13                	jmp    8009d4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	6a 20                	push   $0x20
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d1:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d8:	7f e7                	jg     8009c1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009da:	e9 66 01 00 00       	jmp    800b45 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e8:	50                   	push   %eax
  8009e9:	e8 3c fd ff ff       	call   80072a <getint>
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009fd:	85 d2                	test   %edx,%edx
  8009ff:	79 23                	jns    800a24 <vprintfmt+0x29b>
				putch('-', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 2d                	push   $0x2d
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	f7 d8                	neg    %eax
  800a19:	83 d2 00             	adc    $0x0,%edx
  800a1c:	f7 da                	neg    %edx
  800a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a24:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2b:	e9 bc 00 00 00       	jmp    800aec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 e8             	pushl  -0x18(%ebp)
  800a36:	8d 45 14             	lea    0x14(%ebp),%eax
  800a39:	50                   	push   %eax
  800a3a:	e8 84 fc ff ff       	call   8006c3 <getuint>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4f:	e9 98 00 00 00       	jmp    800aec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 58                	push   $0x58
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	6a 58                	push   $0x58
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	ff d0                	call   *%eax
  800a71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 58                	push   $0x58
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
			break;
  800a84:	e9 bc 00 00 00       	jmp    800b45 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	6a 30                	push   $0x30
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	6a 78                	push   $0x78
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	ff d0                	call   *%eax
  800aa6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ac4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800acb:	eb 1f                	jmp    800aec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad6:	50                   	push   %eax
  800ad7:	e8 e7 fb ff ff       	call   8006c3 <getuint>
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ae5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	52                   	push   %edx
  800af7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800afa:	50                   	push   %eax
  800afb:	ff 75 f4             	pushl  -0xc(%ebp)
  800afe:	ff 75 f0             	pushl  -0x10(%ebp)
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	ff 75 08             	pushl  0x8(%ebp)
  800b07:	e8 00 fb ff ff       	call   80060c <printnum>
  800b0c:	83 c4 20             	add    $0x20,%esp
			break;
  800b0f:	eb 34                	jmp    800b45 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	53                   	push   %ebx
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			break;
  800b20:	eb 23                	jmp    800b45 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	6a 25                	push   $0x25
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	ff d0                	call   *%eax
  800b2f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b32:	ff 4d 10             	decl   0x10(%ebp)
  800b35:	eb 03                	jmp    800b3a <vprintfmt+0x3b1>
  800b37:	ff 4d 10             	decl   0x10(%ebp)
  800b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3d:	48                   	dec    %eax
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	3c 25                	cmp    $0x25,%al
  800b42:	75 f3                	jne    800b37 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b44:	90                   	nop
		}
	}
  800b45:	e9 47 fc ff ff       	jmp    800791 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b4a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b58:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5b:	83 c0 04             	add    $0x4,%eax
  800b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b61:	8b 45 10             	mov    0x10(%ebp),%eax
  800b64:	ff 75 f4             	pushl  -0xc(%ebp)
  800b67:	50                   	push   %eax
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 16 fc ff ff       	call   800789 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b76:	90                   	nop
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8b 40 08             	mov    0x8(%eax),%eax
  800b82:	8d 50 01             	lea    0x1(%eax),%edx
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 10                	mov    (%eax),%edx
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8b 40 04             	mov    0x4(%eax),%eax
  800b96:	39 c2                	cmp    %eax,%edx
  800b98:	73 12                	jae    800bac <sprintputch+0x33>
		*b->buf++ = ch;
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	89 0a                	mov    %ecx,(%edx)
  800ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  800baa:	88 10                	mov    %dl,(%eax)
}
  800bac:	90                   	nop
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	01 d0                	add    %edx,%eax
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bd4:	74 06                	je     800bdc <vsnprintf+0x2d>
  800bd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bda:	7f 07                	jg     800be3 <vsnprintf+0x34>
		return -E_INVAL;
  800bdc:	b8 03 00 00 00       	mov    $0x3,%eax
  800be1:	eb 20                	jmp    800c03 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be3:	ff 75 14             	pushl  0x14(%ebp)
  800be6:	ff 75 10             	pushl  0x10(%ebp)
  800be9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bec:	50                   	push   %eax
  800bed:	68 79 0b 80 00       	push   $0x800b79
  800bf2:	e8 92 fb ff ff       	call   800789 <vprintfmt>
  800bf7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0e:	83 c0 04             	add    $0x4,%eax
  800c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1a:	50                   	push   %eax
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 89 ff ff ff       	call   800baf <vsnprintf>
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3e:	eb 06                	jmp    800c46 <strlen+0x15>
		n++;
  800c40:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c43:	ff 45 08             	incl   0x8(%ebp)
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 f1                	jne    800c40 <strlen+0xf>
		n++;
	return n;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c61:	eb 09                	jmp    800c6c <strnlen+0x18>
		n++;
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c66:	ff 45 08             	incl   0x8(%ebp)
  800c69:	ff 4d 0c             	decl   0xc(%ebp)
  800c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c70:	74 09                	je     800c7b <strnlen+0x27>
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	84 c0                	test   %al,%al
  800c79:	75 e8                	jne    800c63 <strnlen+0xf>
		n++;
	return n;
  800c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c8c:	90                   	nop
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8d 50 01             	lea    0x1(%eax),%edx
  800c93:	89 55 08             	mov    %edx,0x8(%ebp)
  800c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9f:	8a 12                	mov    (%edx),%dl
  800ca1:	88 10                	mov    %dl,(%eax)
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	75 e4                	jne    800c8d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 1f                	jmp    800ce2 <strncpy+0x34>
		*dst++ = *src;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8d 50 01             	lea    0x1(%eax),%edx
  800cc9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccf:	8a 12                	mov    (%edx),%dl
  800cd1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	84 c0                	test   %al,%al
  800cda:	74 03                	je     800cdf <strncpy+0x31>
			src++;
  800cdc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cdf:	ff 45 fc             	incl   -0x4(%ebp)
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ce8:	72 d9                	jb     800cc3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 30                	je     800d31 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d01:	eb 16                	jmp    800d19 <strlcpy+0x2a>
			*dst++ = *src++;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8d 50 01             	lea    0x1(%eax),%edx
  800d09:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d15:	8a 12                	mov    (%edx),%dl
  800d17:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d19:	ff 4d 10             	decl   0x10(%ebp)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	74 09                	je     800d2b <strlcpy+0x3c>
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	84 c0                	test   %al,%al
  800d29:	75 d8                	jne    800d03 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d37:	29 c2                	sub    %eax,%edx
  800d39:	89 d0                	mov    %edx,%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d40:	eb 06                	jmp    800d48 <strcmp+0xb>
		p++, q++;
  800d42:	ff 45 08             	incl   0x8(%ebp)
  800d45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	74 0e                	je     800d5f <strcmp+0x22>
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 10                	mov    (%eax),%dl
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	38 c2                	cmp    %al,%dl
  800d5d:	74 e3                	je     800d42 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	0f b6 d0             	movzbl %al,%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f b6 c0             	movzbl %al,%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
}
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d78:	eb 09                	jmp    800d83 <strncmp+0xe>
		n--, p++, q++;
  800d7a:	ff 4d 10             	decl   0x10(%ebp)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 17                	je     800da0 <strncmp+0x2b>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	74 0e                	je     800da0 <strncmp+0x2b>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 10                	mov    (%eax),%dl
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	38 c2                	cmp    %al,%dl
  800d9e:	74 da                	je     800d7a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da4:	75 07                	jne    800dad <strncmp+0x38>
		return 0;
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	eb 14                	jmp    800dc1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	0f b6 d0             	movzbl %al,%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	0f b6 c0             	movzbl %al,%eax
  800dbd:	29 c2                	sub    %eax,%edx
  800dbf:	89 d0                	mov    %edx,%eax
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcf:	eb 12                	jmp    800de3 <strchr+0x20>
		if (*s == c)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd9:	75 05                	jne    800de0 <strchr+0x1d>
			return (char *) s;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	eb 11                	jmp    800df1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de0:	ff 45 08             	incl   0x8(%ebp)
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	84 c0                	test   %al,%al
  800dea:	75 e5                	jne    800dd1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dff:	eb 0d                	jmp    800e0e <strfind+0x1b>
		if (*s == c)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e09:	74 0e                	je     800e19 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 ea                	jne    800e01 <strfind+0xe>
  800e17:	eb 01                	jmp    800e1a <strfind+0x27>
		if (*s == c)
			break;
  800e19:	90                   	nop
	return (char *) s;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e31:	eb 0e                	jmp    800e41 <memset+0x22>
		*p++ = c;
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e41:	ff 4d f8             	decl   -0x8(%ebp)
  800e44:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e48:	79 e9                	jns    800e33 <memset+0x14>
		*p++ = c;

	return v;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e61:	eb 16                	jmp    800e79 <memcpy+0x2a>
		*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea3:	73 50                	jae    800ef5 <memmove+0x6a>
  800ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	01 d0                	add    %edx,%eax
  800ead:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eb0:	76 43                	jbe    800ef5 <memmove+0x6a>
		s += n;
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ebe:	eb 10                	jmp    800ed0 <memmove+0x45>
			*--d = *--s;
  800ec0:	ff 4d f8             	decl   -0x8(%ebp)
  800ec3:	ff 4d fc             	decl   -0x4(%ebp)
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	8a 10                	mov    (%eax),%dl
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ece:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	75 e3                	jne    800ec0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800edd:	eb 23                	jmp    800f02 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eeb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef1:	8a 12                	mov    (%edx),%dl
  800ef3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efb:	89 55 10             	mov    %edx,0x10(%ebp)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	75 dd                	jne    800edf <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f19:	eb 2a                	jmp    800f45 <memcmp+0x3e>
		if (*s1 != *s2)
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1e:	8a 10                	mov    (%eax),%dl
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	38 c2                	cmp    %al,%dl
  800f27:	74 16                	je     800f3f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f b6 d0             	movzbl %al,%edx
  800f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	0f b6 c0             	movzbl %al,%eax
  800f39:	29 c2                	sub    %eax,%edx
  800f3b:	89 d0                	mov    %edx,%eax
  800f3d:	eb 18                	jmp    800f57 <memcmp+0x50>
		s1++, s2++;
  800f3f:	ff 45 fc             	incl   -0x4(%ebp)
  800f42:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	75 c9                	jne    800f1b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 45 10             	mov    0x10(%ebp),%eax
  800f65:	01 d0                	add    %edx,%eax
  800f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f6a:	eb 15                	jmp    800f81 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	0f b6 d0             	movzbl %al,%edx
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	0f b6 c0             	movzbl %al,%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	74 0d                	je     800f8b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f87:	72 e3                	jb     800f6c <memfind+0x13>
  800f89:	eb 01                	jmp    800f8c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f8b:	90                   	nop
	return (void *) s;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f9e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa5:	eb 03                	jmp    800faa <strtol+0x19>
		s++;
  800fa7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 20                	cmp    $0x20,%al
  800fb1:	74 f4                	je     800fa7 <strtol+0x16>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 09                	cmp    $0x9,%al
  800fba:	74 eb                	je     800fa7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 2b                	cmp    $0x2b,%al
  800fc3:	75 05                	jne    800fca <strtol+0x39>
		s++;
  800fc5:	ff 45 08             	incl   0x8(%ebp)
  800fc8:	eb 13                	jmp    800fdd <strtol+0x4c>
	else if (*s == '-')
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 2d                	cmp    $0x2d,%al
  800fd1:	75 0a                	jne    800fdd <strtol+0x4c>
		s++, neg = 1;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe1:	74 06                	je     800fe9 <strtol+0x58>
  800fe3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fe7:	75 20                	jne    801009 <strtol+0x78>
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 30                	cmp    $0x30,%al
  800ff0:	75 17                	jne    801009 <strtol+0x78>
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	40                   	inc    %eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 78                	cmp    $0x78,%al
  800ffa:	75 0d                	jne    801009 <strtol+0x78>
		s += 2, base = 16;
  800ffc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801000:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801007:	eb 28                	jmp    801031 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	75 15                	jne    801024 <strtol+0x93>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 30                	cmp    $0x30,%al
  801016:	75 0c                	jne    801024 <strtol+0x93>
		s++, base = 8;
  801018:	ff 45 08             	incl   0x8(%ebp)
  80101b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801022:	eb 0d                	jmp    801031 <strtol+0xa0>
	else if (base == 0)
  801024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801028:	75 07                	jne    801031 <strtol+0xa0>
		base = 10;
  80102a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 2f                	cmp    $0x2f,%al
  801038:	7e 19                	jle    801053 <strtol+0xc2>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 39                	cmp    $0x39,%al
  801041:	7f 10                	jg     801053 <strtol+0xc2>
			dig = *s - '0';
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	0f be c0             	movsbl %al,%eax
  80104b:	83 e8 30             	sub    $0x30,%eax
  80104e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801051:	eb 42                	jmp    801095 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 60                	cmp    $0x60,%al
  80105a:	7e 19                	jle    801075 <strtol+0xe4>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 7a                	cmp    $0x7a,%al
  801063:	7f 10                	jg     801075 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f be c0             	movsbl %al,%eax
  80106d:	83 e8 57             	sub    $0x57,%eax
  801070:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801073:	eb 20                	jmp    801095 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 40                	cmp    $0x40,%al
  80107c:	7e 39                	jle    8010b7 <strtol+0x126>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 5a                	cmp    $0x5a,%al
  801085:	7f 30                	jg     8010b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	0f be c0             	movsbl %al,%eax
  80108f:	83 e8 37             	sub    $0x37,%eax
  801092:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801098:	3b 45 10             	cmp    0x10(%ebp),%eax
  80109b:	7d 19                	jge    8010b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80109d:	ff 45 08             	incl   0x8(%ebp)
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010a7:	89 c2                	mov    %eax,%edx
  8010a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ac:	01 d0                	add    %edx,%eax
  8010ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010b1:	e9 7b ff ff ff       	jmp    801031 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010bb:	74 08                	je     8010c5 <strtol+0x134>
		*endptr = (char *) s;
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c9:	74 07                	je     8010d2 <strtol+0x141>
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	f7 d8                	neg    %eax
  8010d0:	eb 03                	jmp    8010d5 <strtol+0x144>
  8010d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ef:	79 13                	jns    801104 <ltostr+0x2d>
	{
		neg = 1;
  8010f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801101:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80110c:	99                   	cltd   
  80110d:	f7 f9                	idiv   %ecx
  80110f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801112:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801115:	8d 50 01             	lea    0x1(%eax),%edx
  801118:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801125:	83 c2 30             	add    $0x30,%edx
  801128:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80112a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801132:	f7 e9                	imul   %ecx
  801134:	c1 fa 02             	sar    $0x2,%edx
  801137:	89 c8                	mov    %ecx,%eax
  801139:	c1 f8 1f             	sar    $0x1f,%eax
  80113c:	29 c2                	sub    %eax,%edx
  80113e:	89 d0                	mov    %edx,%eax
  801140:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801146:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114b:	f7 e9                	imul   %ecx
  80114d:	c1 fa 02             	sar    $0x2,%edx
  801150:	89 c8                	mov    %ecx,%eax
  801152:	c1 f8 1f             	sar    $0x1f,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
  801159:	c1 e0 02             	shl    $0x2,%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	01 c0                	add    %eax,%eax
  801160:	29 c1                	sub    %eax,%ecx
  801162:	89 ca                	mov    %ecx,%edx
  801164:	85 d2                	test   %edx,%edx
  801166:	75 9c                	jne    801104 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	48                   	dec    %eax
  801173:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801176:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117a:	74 3d                	je     8011b9 <ltostr+0xe2>
		start = 1 ;
  80117c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801183:	eb 34                	jmp    8011b9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 d0                	add    %edx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 c2                	add    %eax,%edx
  80119a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c8                	add    %ecx,%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 c2                	add    %eax,%edx
  8011ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8011b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011bf:	7c c4                	jl     801185 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	01 d0                	add    %edx,%eax
  8011c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011cc:	90                   	nop
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 54 fa ff ff       	call   800c31 <strlen>
  8011dd:	83 c4 04             	add    $0x4,%esp
  8011e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011e3:	ff 75 0c             	pushl  0xc(%ebp)
  8011e6:	e8 46 fa ff ff       	call   800c31 <strlen>
  8011eb:	83 c4 04             	add    $0x4,%esp
  8011ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ff:	eb 17                	jmp    801218 <strcconcat+0x49>
		final[s] = str1[s] ;
  801201:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801215:	ff 45 fc             	incl   -0x4(%ebp)
  801218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80121e:	7c e1                	jl     801201 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801220:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801227:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80122e:	eb 1f                	jmp    80124f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801239:	89 c2                	mov    %eax,%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 c2                	add    %eax,%edx
  801240:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	01 c8                	add    %ecx,%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80124c:	ff 45 f8             	incl   -0x8(%ebp)
  80124f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801252:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801255:	7c d9                	jl     801230 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801257:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	c6 00 00             	movb   $0x0,(%eax)
}
  801262:	90                   	nop
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801268:	8b 45 14             	mov    0x14(%ebp),%eax
  80126b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	8b 00                	mov    (%eax),%eax
  801276:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801288:	eb 0c                	jmp    801296 <strsplit+0x31>
			*string++ = 0;
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8d 50 01             	lea    0x1(%eax),%edx
  801290:	89 55 08             	mov    %edx,0x8(%ebp)
  801293:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 18                	je     8012b7 <strsplit+0x52>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	0f be c0             	movsbl %al,%eax
  8012a7:	50                   	push   %eax
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	e8 13 fb ff ff       	call   800dc3 <strchr>
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	75 d3                	jne    80128a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	84 c0                	test   %al,%al
  8012be:	74 5a                	je     80131a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c3:	8b 00                	mov    (%eax),%eax
  8012c5:	83 f8 0f             	cmp    $0xf,%eax
  8012c8:	75 07                	jne    8012d1 <strsplit+0x6c>
		{
			return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	eb 66                	jmp    801337 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d4:	8b 00                	mov    (%eax),%eax
  8012d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8012dc:	89 0a                	mov    %ecx,(%edx)
  8012de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e8:	01 c2                	add    %eax,%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ef:	eb 03                	jmp    8012f4 <strsplit+0x8f>
			string++;
  8012f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 8b                	je     801288 <strsplit+0x23>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f be c0             	movsbl %al,%eax
  801305:	50                   	push   %eax
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	e8 b5 fa ff ff       	call   800dc3 <strchr>
  80130e:	83 c4 08             	add    $0x8,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	74 dc                	je     8012f1 <strsplit+0x8c>
			string++;
	}
  801315:	e9 6e ff ff ff       	jmp    801288 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80131a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801332:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	57                   	push   %edi
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80134e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801351:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801354:	cd 30                	int    $0x30
  801356:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5f                   	pop    %edi
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    

00801364 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801370:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	52                   	push   %edx
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	50                   	push   %eax
  801380:	6a 00                	push   $0x0
  801382:	e8 b2 ff ff ff       	call   801339 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	90                   	nop
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_cgetc>:

int
sys_cgetc(void)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 01                	push   $0x1
  80139c:	e8 98 ff ff ff       	call   801339 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	52                   	push   %edx
  8013b6:	50                   	push   %eax
  8013b7:	6a 05                	push   $0x5
  8013b9:	e8 7b ff ff ff       	call   801339 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8013cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	51                   	push   %ecx
  8013da:	52                   	push   %edx
  8013db:	50                   	push   %eax
  8013dc:	6a 06                	push   $0x6
  8013de:	e8 56 ff ff ff       	call   801339 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	52                   	push   %edx
  8013fd:	50                   	push   %eax
  8013fe:	6a 07                	push   $0x7
  801400:	e8 34 ff ff ff       	call   801339 <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	6a 08                	push   $0x8
  80141b:	e8 19 ff ff ff       	call   801339 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 09                	push   $0x9
  801434:	e8 00 ff ff ff       	call   801339 <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 0a                	push   $0xa
  80144d:	e8 e7 fe ff ff       	call   801339 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 0b                	push   $0xb
  801466:	e8 ce fe ff ff       	call   801339 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	ff 75 08             	pushl  0x8(%ebp)
  80147f:	6a 0f                	push   $0xf
  801481:	e8 b3 fe ff ff       	call   801339 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
	return;
  801489:	90                   	nop
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	ff 75 08             	pushl  0x8(%ebp)
  80149b:	6a 10                	push   $0x10
  80149d:	e8 97 fe ff ff       	call   801339 <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a5:	90                   	nop
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	ff 75 10             	pushl  0x10(%ebp)
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	ff 75 08             	pushl  0x8(%ebp)
  8014b8:	6a 11                	push   $0x11
  8014ba:	e8 7a fe ff ff       	call   801339 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c2:	90                   	nop
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 0c                	push   $0xc
  8014d4:	e8 60 fe ff ff       	call   801339 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	6a 0d                	push   $0xd
  8014ee:	e8 46 fe ff ff       	call   801339 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 0e                	push   $0xe
  801507:	e8 2d fe ff ff       	call   801339 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 13                	push   $0x13
  801521:	e8 13 fe ff ff       	call   801339 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 14                	push   $0x14
  80153b:	e8 f9 fd ff ff       	call   801339 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	90                   	nop
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_cputc>:


void
sys_cputc(const char c)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801552:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	50                   	push   %eax
  80155f:	6a 15                	push   $0x15
  801561:	e8 d3 fd ff ff       	call   801339 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 16                	push   $0x16
  80157b:	e8 b9 fd ff ff       	call   801339 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	ff 75 0c             	pushl  0xc(%ebp)
  801595:	50                   	push   %eax
  801596:	6a 17                	push   $0x17
  801598:	e8 9c fd ff ff       	call   801339 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	52                   	push   %edx
  8015b2:	50                   	push   %eax
  8015b3:	6a 1a                	push   $0x1a
  8015b5:	e8 7f fd ff ff       	call   801339 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	6a 18                	push   $0x18
  8015d2:	e8 62 fd ff ff       	call   801339 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	52                   	push   %edx
  8015ed:	50                   	push   %eax
  8015ee:	6a 19                	push   $0x19
  8015f0:	e8 44 fd ff ff       	call   801339 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	90                   	nop
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 45 10             	mov    0x10(%ebp),%eax
  801604:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801607:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80160a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	6a 00                	push   $0x0
  801613:	51                   	push   %ecx
  801614:	52                   	push   %edx
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	50                   	push   %eax
  801619:	6a 1b                	push   $0x1b
  80161b:	e8 19 fd ff ff       	call   801339 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	6a 1c                	push   $0x1c
  801638:	e8 fc fc ff ff       	call   801339 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801645:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	51                   	push   %ecx
  801653:	52                   	push   %edx
  801654:	50                   	push   %eax
  801655:	6a 1d                	push   $0x1d
  801657:	e8 dd fc ff ff       	call   801339 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801664:	8b 55 0c             	mov    0xc(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	6a 1e                	push   $0x1e
  801674:	e8 c0 fc ff ff       	call   801339 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 1f                	push   $0x1f
  80168d:	e8 a7 fc ff ff       	call   801339 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 14             	pushl  0x14(%ebp)
  8016a2:	ff 75 10             	pushl  0x10(%ebp)
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	50                   	push   %eax
  8016a9:	6a 20                	push   $0x20
  8016ab:	e8 89 fc ff ff       	call   801339 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	50                   	push   %eax
  8016c4:	6a 21                	push   $0x21
  8016c6:	e8 6e fc ff ff       	call   801339 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	90                   	nop
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	50                   	push   %eax
  8016e0:	6a 22                	push   $0x22
  8016e2:	e8 52 fc ff ff       	call   801339 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 02                	push   $0x2
  8016fb:	e8 39 fc ff ff       	call   801339 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 03                	push   $0x3
  801714:	e8 20 fc ff ff       	call   801339 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 04                	push   $0x4
  80172d:	e8 07 fc ff ff       	call   801339 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_exit_env>:


void sys_exit_env(void)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 23                	push   $0x23
  801746:	e8 ee fb ff ff       	call   801339 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801757:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80175a:	8d 50 04             	lea    0x4(%eax),%edx
  80175d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	52                   	push   %edx
  801767:	50                   	push   %eax
  801768:	6a 24                	push   $0x24
  80176a:	e8 ca fb ff ff       	call   801339 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return result;
  801772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801775:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801778:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80177b:	89 01                	mov    %eax,(%ecx)
  80177d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	c9                   	leave  
  801784:	c2 04 00             	ret    $0x4

00801787 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	ff 75 10             	pushl  0x10(%ebp)
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	ff 75 08             	pushl  0x8(%ebp)
  801797:	6a 12                	push   $0x12
  801799:	e8 9b fb ff ff       	call   801339 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a1:	90                   	nop
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 25                	push   $0x25
  8017b3:	e8 81 fb ff ff       	call   801339 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017c9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	50                   	push   %eax
  8017d6:	6a 26                	push   $0x26
  8017d8:	e8 5c fb ff ff       	call   801339 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e0:	90                   	nop
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <rsttst>:
void rsttst()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 28                	push   $0x28
  8017f2:	e8 42 fb ff ff       	call   801339 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fa:	90                   	nop
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	8b 45 14             	mov    0x14(%ebp),%eax
  801806:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801809:	8b 55 18             	mov    0x18(%ebp),%edx
  80180c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801810:	52                   	push   %edx
  801811:	50                   	push   %eax
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	6a 27                	push   $0x27
  80181d:	e8 17 fb ff ff       	call   801339 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
	return ;
  801825:	90                   	nop
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <chktst>:
void chktst(uint32 n)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 29                	push   $0x29
  801838:	e8 fc fa ff ff       	call   801339 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
	return ;
  801840:	90                   	nop
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <inctst>:

void inctst()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 2a                	push   $0x2a
  801852:	e8 e2 fa ff ff       	call   801339 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return ;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <gettst>:
uint32 gettst()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 2b                	push   $0x2b
  80186c:	e8 c8 fa ff ff       	call   801339 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 2c                	push   $0x2c
  801888:	e8 ac fa ff ff       	call   801339 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
  801890:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801893:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801897:	75 07                	jne    8018a0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801899:	b8 01 00 00 00       	mov    $0x1,%eax
  80189e:	eb 05                	jmp    8018a5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 2c                	push   $0x2c
  8018b9:	e8 7b fa ff ff       	call   801339 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018c4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018c8:	75 07                	jne    8018d1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cf:	eb 05                	jmp    8018d6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 2c                	push   $0x2c
  8018ea:	e8 4a fa ff ff       	call   801339 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
  8018f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018f5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018f9:	75 07                	jne    801902 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801900:	eb 05                	jmp    801907 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 2c                	push   $0x2c
  80191b:	e8 19 fa ff ff       	call   801339 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
  801923:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801926:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80192a:	75 07                	jne    801933 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80192c:	b8 01 00 00 00       	mov    $0x1,%eax
  801931:	eb 05                	jmp    801938 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 2d                	push   $0x2d
  80194a:	e8 ea f9 ff ff       	call   801339 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return ;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801959:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	53                   	push   %ebx
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 2e                	push   $0x2e
  80196d:	e8 c7 f9 ff ff       	call   801339 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 2f                	push   $0x2f
  80198d:	e8 a7 f9 ff ff       	call   801339 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80199d:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a0:	89 d0                	mov    %edx,%eax
  8019a2:	c1 e0 02             	shl    $0x2,%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b7:	01 d0                	add    %edx,%eax
  8019b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c0:	01 d0                	add    %edx,%eax
  8019c2:	c1 e0 04             	shl    $0x4,%eax
  8019c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019d2:	83 ec 0c             	sub    $0xc,%esp
  8019d5:	50                   	push   %eax
  8019d6:	e8 76 fd ff ff       	call   801751 <sys_get_virtual_time>
  8019db:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019de:	eb 41                	jmp    801a21 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	50                   	push   %eax
  8019e7:	e8 65 fd ff ff       	call   801751 <sys_get_virtual_time>
  8019ec:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f5:	29 c2                	sub    %eax,%edx
  8019f7:	89 d0                	mov    %edx,%eax
  8019f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a02:	89 d1                	mov    %edx,%ecx
  801a04:	29 c1                	sub    %eax,%ecx
  801a06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0c:	39 c2                	cmp    %eax,%edx
  801a0e:	0f 97 c0             	seta   %al
  801a11:	0f b6 c0             	movzbl %al,%eax
  801a14:	29 c1                	sub    %eax,%ecx
  801a16:	89 c8                	mov    %ecx,%eax
  801a18:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a27:	72 b7                	jb     8019e0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a39:	eb 03                	jmp    801a3e <busy_wait+0x12>
  801a3b:	ff 45 fc             	incl   -0x4(%ebp)
  801a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a41:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a44:	72 f5                	jb     801a3b <busy_wait+0xf>
	return i;
  801a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    
  801a4b:	90                   	nop

00801a4c <__udivdi3>:
  801a4c:	55                   	push   %ebp
  801a4d:	57                   	push   %edi
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 1c             	sub    $0x1c,%esp
  801a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a63:	89 ca                	mov    %ecx,%edx
  801a65:	89 f8                	mov    %edi,%eax
  801a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a6b:	85 f6                	test   %esi,%esi
  801a6d:	75 2d                	jne    801a9c <__udivdi3+0x50>
  801a6f:	39 cf                	cmp    %ecx,%edi
  801a71:	77 65                	ja     801ad8 <__udivdi3+0x8c>
  801a73:	89 fd                	mov    %edi,%ebp
  801a75:	85 ff                	test   %edi,%edi
  801a77:	75 0b                	jne    801a84 <__udivdi3+0x38>
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	31 d2                	xor    %edx,%edx
  801a80:	f7 f7                	div    %edi
  801a82:	89 c5                	mov    %eax,%ebp
  801a84:	31 d2                	xor    %edx,%edx
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	f7 f5                	div    %ebp
  801a8a:	89 c1                	mov    %eax,%ecx
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	f7 f5                	div    %ebp
  801a90:	89 cf                	mov    %ecx,%edi
  801a92:	89 fa                	mov    %edi,%edx
  801a94:	83 c4 1c             	add    $0x1c,%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5f                   	pop    %edi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	77 28                	ja     801ac8 <__udivdi3+0x7c>
  801aa0:	0f bd fe             	bsr    %esi,%edi
  801aa3:	83 f7 1f             	xor    $0x1f,%edi
  801aa6:	75 40                	jne    801ae8 <__udivdi3+0x9c>
  801aa8:	39 ce                	cmp    %ecx,%esi
  801aaa:	72 0a                	jb     801ab6 <__udivdi3+0x6a>
  801aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ab0:	0f 87 9e 00 00 00    	ja     801b54 <__udivdi3+0x108>
  801ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  801abb:	89 fa                	mov    %edi,%edx
  801abd:	83 c4 1c             	add    $0x1c,%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
  801ac5:	8d 76 00             	lea    0x0(%esi),%esi
  801ac8:	31 ff                	xor    %edi,%edi
  801aca:	31 c0                	xor    %eax,%eax
  801acc:	89 fa                	mov    %edi,%edx
  801ace:	83 c4 1c             	add    $0x1c,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5f                   	pop    %edi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    
  801ad6:	66 90                	xchg   %ax,%ax
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	f7 f7                	div    %edi
  801adc:	31 ff                	xor    %edi,%edi
  801ade:	89 fa                	mov    %edi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aed:	89 eb                	mov    %ebp,%ebx
  801aef:	29 fb                	sub    %edi,%ebx
  801af1:	89 f9                	mov    %edi,%ecx
  801af3:	d3 e6                	shl    %cl,%esi
  801af5:	89 c5                	mov    %eax,%ebp
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 ed                	shr    %cl,%ebp
  801afb:	89 e9                	mov    %ebp,%ecx
  801afd:	09 f1                	or     %esi,%ecx
  801aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e0                	shl    %cl,%eax
  801b07:	89 c5                	mov    %eax,%ebp
  801b09:	89 d6                	mov    %edx,%esi
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 ee                	shr    %cl,%esi
  801b0f:	89 f9                	mov    %edi,%ecx
  801b11:	d3 e2                	shl    %cl,%edx
  801b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b17:	88 d9                	mov    %bl,%cl
  801b19:	d3 e8                	shr    %cl,%eax
  801b1b:	09 c2                	or     %eax,%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	89 f2                	mov    %esi,%edx
  801b21:	f7 74 24 0c          	divl   0xc(%esp)
  801b25:	89 d6                	mov    %edx,%esi
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	f7 e5                	mul    %ebp
  801b2b:	39 d6                	cmp    %edx,%esi
  801b2d:	72 19                	jb     801b48 <__udivdi3+0xfc>
  801b2f:	74 0b                	je     801b3c <__udivdi3+0xf0>
  801b31:	89 d8                	mov    %ebx,%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 58 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b40:	89 f9                	mov    %edi,%ecx
  801b42:	d3 e2                	shl    %cl,%edx
  801b44:	39 c2                	cmp    %eax,%edx
  801b46:	73 e9                	jae    801b31 <__udivdi3+0xe5>
  801b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b4b:	31 ff                	xor    %edi,%edi
  801b4d:	e9 40 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	31 c0                	xor    %eax,%eax
  801b56:	e9 37 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b5b:	90                   	nop

00801b5c <__umoddi3>:
  801b5c:	55                   	push   %ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b7b:	89 f3                	mov    %esi,%ebx
  801b7d:	89 fa                	mov    %edi,%edx
  801b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b83:	89 34 24             	mov    %esi,(%esp)
  801b86:	85 c0                	test   %eax,%eax
  801b88:	75 1a                	jne    801ba4 <__umoddi3+0x48>
  801b8a:	39 f7                	cmp    %esi,%edi
  801b8c:	0f 86 a2 00 00 00    	jbe    801c34 <__umoddi3+0xd8>
  801b92:	89 c8                	mov    %ecx,%eax
  801b94:	89 f2                	mov    %esi,%edx
  801b96:	f7 f7                	div    %edi
  801b98:	89 d0                	mov    %edx,%eax
  801b9a:	31 d2                	xor    %edx,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	39 f0                	cmp    %esi,%eax
  801ba6:	0f 87 ac 00 00 00    	ja     801c58 <__umoddi3+0xfc>
  801bac:	0f bd e8             	bsr    %eax,%ebp
  801baf:	83 f5 1f             	xor    $0x1f,%ebp
  801bb2:	0f 84 ac 00 00 00    	je     801c64 <__umoddi3+0x108>
  801bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bbd:	29 ef                	sub    %ebp,%edi
  801bbf:	89 fe                	mov    %edi,%esi
  801bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e0                	shl    %cl,%eax
  801bc9:	89 d7                	mov    %edx,%edi
  801bcb:	89 f1                	mov    %esi,%ecx
  801bcd:	d3 ef                	shr    %cl,%edi
  801bcf:	09 c7                	or     %eax,%edi
  801bd1:	89 e9                	mov    %ebp,%ecx
  801bd3:	d3 e2                	shl    %cl,%edx
  801bd5:	89 14 24             	mov    %edx,(%esp)
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	d3 e0                	shl    %cl,%eax
  801bdc:	89 c2                	mov    %eax,%edx
  801bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be2:	d3 e0                	shl    %cl,%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bec:	89 f1                	mov    %esi,%ecx
  801bee:	d3 e8                	shr    %cl,%eax
  801bf0:	09 d0                	or     %edx,%eax
  801bf2:	d3 eb                	shr    %cl,%ebx
  801bf4:	89 da                	mov    %ebx,%edx
  801bf6:	f7 f7                	div    %edi
  801bf8:	89 d3                	mov    %edx,%ebx
  801bfa:	f7 24 24             	mull   (%esp)
  801bfd:	89 c6                	mov    %eax,%esi
  801bff:	89 d1                	mov    %edx,%ecx
  801c01:	39 d3                	cmp    %edx,%ebx
  801c03:	0f 82 87 00 00 00    	jb     801c90 <__umoddi3+0x134>
  801c09:	0f 84 91 00 00 00    	je     801ca0 <__umoddi3+0x144>
  801c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c13:	29 f2                	sub    %esi,%edx
  801c15:	19 cb                	sbb    %ecx,%ebx
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c1d:	d3 e0                	shl    %cl,%eax
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	d3 ea                	shr    %cl,%edx
  801c23:	09 d0                	or     %edx,%eax
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 eb                	shr    %cl,%ebx
  801c29:	89 da                	mov    %ebx,%edx
  801c2b:	83 c4 1c             	add    $0x1c,%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5f                   	pop    %edi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    
  801c33:	90                   	nop
  801c34:	89 fd                	mov    %edi,%ebp
  801c36:	85 ff                	test   %edi,%edi
  801c38:	75 0b                	jne    801c45 <__umoddi3+0xe9>
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	31 d2                	xor    %edx,%edx
  801c41:	f7 f7                	div    %edi
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 f0                	mov    %esi,%eax
  801c47:	31 d2                	xor    %edx,%edx
  801c49:	f7 f5                	div    %ebp
  801c4b:	89 c8                	mov    %ecx,%eax
  801c4d:	f7 f5                	div    %ebp
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	e9 44 ff ff ff       	jmp    801b9a <__umoddi3+0x3e>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	89 c8                	mov    %ecx,%eax
  801c5a:	89 f2                	mov    %esi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	3b 04 24             	cmp    (%esp),%eax
  801c67:	72 06                	jb     801c6f <__umoddi3+0x113>
  801c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c6d:	77 0f                	ja     801c7e <__umoddi3+0x122>
  801c6f:	89 f2                	mov    %esi,%edx
  801c71:	29 f9                	sub    %edi,%ecx
  801c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c77:	89 14 24             	mov    %edx,(%esp)
  801c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c82:	8b 14 24             	mov    (%esp),%edx
  801c85:	83 c4 1c             	add    $0x1c,%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
  801c8d:	8d 76 00             	lea    0x0(%esi),%esi
  801c90:	2b 04 24             	sub    (%esp),%eax
  801c93:	19 fa                	sbb    %edi,%edx
  801c95:	89 d1                	mov    %edx,%ecx
  801c97:	89 c6                	mov    %eax,%esi
  801c99:	e9 71 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ca4:	72 ea                	jb     801c90 <__umoddi3+0x134>
  801ca6:	89 d9                	mov    %ebx,%ecx
  801ca8:	e9 62 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
