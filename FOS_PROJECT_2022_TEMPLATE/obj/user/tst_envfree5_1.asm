
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 1c 80 00       	push   $0x801ce0
  80004a:	e8 f9 12 00 00       	call   801348 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 99 14 00 00       	call   8014fc <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 31 15 00 00       	call   80159c <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 1c 80 00       	push   $0x801cf0
  800079:	e8 cb 04 00 00       	call   800549 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 23 1d 80 00       	push   $0x801d23
  800099:	e8 d0 16 00 00       	call   80176e <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 dd 16 00 00       	call   80178c <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 3a 14 00 00       	call   8014fc <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 2c 1d 80 00       	push   $0x801d2c
  8000cb:	e8 79 04 00 00       	call   800549 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 ca 16 00 00       	call   8017a8 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 16 14 00 00       	call   8014fc <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 ae 14 00 00       	call   80159c <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 60 1d 80 00       	push   $0x801d60
  800104:	e8 40 04 00 00       	call   800549 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 b0 1d 80 00       	push   $0x801db0
  800114:	6a 1e                	push   $0x1e
  800116:	68 e6 1d 80 00       	push   $0x801de6
  80011b:	e8 75 01 00 00       	call   800295 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 fc 1d 80 00       	push   $0x801dfc
  80012b:	e8 19 04 00 00       	call   800549 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 5c 1e 80 00       	push   $0x801e5c
  80013b:	e8 09 04 00 00       	call   800549 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 8b 16 00 00       	call   8017dc <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800164:	01 c8                	add    %ecx,%eax
  800166:	c1 e0 02             	shl    $0x2,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800172:	01 c8                	add    %ecx,%eax
  800174:	c1 e0 02             	shl    $0x2,%eax
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 02             	shl    $0x2,%eax
  80017c:	01 d0                	add    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800186:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018b:	a1 20 30 80 00       	mov    0x803020,%eax
  800190:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800196:	84 c0                	test   %al,%al
  800198:	74 0f                	je     8001a9 <libmain+0x63>
		binaryname = myEnv->prog_name;
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	05 18 da 01 00       	add    $0x1da18,%eax
  8001a4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ad:	7e 0a                	jle    8001b9 <libmain+0x73>
		binaryname = argv[0];
  8001af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001b9:	83 ec 08             	sub    $0x8,%esp
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 71 fe ff ff       	call   800038 <_main>
  8001c7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ca:	e8 1a 14 00 00       	call   8015e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 c0 1e 80 00       	push   $0x801ec0
  8001d7:	e8 6d 03 00 00       	call   800549 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8001ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ef:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	52                   	push   %edx
  8001f9:	50                   	push   %eax
  8001fa:	68 e8 1e 80 00       	push   $0x801ee8
  8001ff:	e8 45 03 00 00       	call   800549 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800207:	a1 20 30 80 00       	mov    0x803020,%eax
  80020c:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800228:	51                   	push   %ecx
  800229:	52                   	push   %edx
  80022a:	50                   	push   %eax
  80022b:	68 10 1f 80 00       	push   $0x801f10
  800230:	e8 14 03 00 00       	call   800549 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	50                   	push   %eax
  800247:	68 68 1f 80 00       	push   $0x801f68
  80024c:	e8 f8 02 00 00       	call   800549 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 c0 1e 80 00       	push   $0x801ec0
  80025c:	e8 e8 02 00 00       	call   800549 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800264:	e8 9a 13 00 00       	call   801603 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800269:	e8 19 00 00 00       	call   800287 <exit>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 00                	push   $0x0
  80027c:	e8 27 15 00 00       	call   8017a8 <sys_destroy_env>
  800281:	83 c4 10             	add    $0x10,%esp
}
  800284:	90                   	nop
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <exit>:

void
exit(void)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028d:	e8 7c 15 00 00       	call   80180e <sys_exit_env>
}
  800292:	90                   	nop
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80029b:	8d 45 10             	lea    0x10(%ebp),%eax
  80029e:	83 c0 04             	add    $0x4,%eax
  8002a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002a4:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002a9:	85 c0                	test   %eax,%eax
  8002ab:	74 16                	je     8002c3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ad:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	50                   	push   %eax
  8002b6:	68 7c 1f 80 00       	push   $0x801f7c
  8002bb:	e8 89 02 00 00       	call   800549 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002c3:	a1 00 30 80 00       	mov    0x803000,%eax
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	68 81 1f 80 00       	push   $0x801f81
  8002d4:	e8 70 02 00 00       	call   800549 <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e5:	50                   	push   %eax
  8002e6:	e8 f3 01 00 00       	call   8004de <vcprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	68 9d 1f 80 00       	push   $0x801f9d
  8002f8:	e8 e1 01 00 00       	call   8004de <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800300:	e8 82 ff ff ff       	call   800287 <exit>

	// should not return here
	while (1) ;
  800305:	eb fe                	jmp    800305 <_panic+0x70>

00800307 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8b 50 74             	mov    0x74(%eax),%edx
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
  800318:	39 c2                	cmp    %eax,%edx
  80031a:	74 14                	je     800330 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 a0 1f 80 00       	push   $0x801fa0
  800324:	6a 26                	push   $0x26
  800326:	68 ec 1f 80 00       	push   $0x801fec
  80032b:	e8 65 ff ff ff       	call   800295 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800330:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800337:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80033e:	e9 c2 00 00 00       	jmp    800405 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 d0                	add    %edx,%eax
  800352:	8b 00                	mov    (%eax),%eax
  800354:	85 c0                	test   %eax,%eax
  800356:	75 08                	jne    800360 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800358:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80035b:	e9 a2 00 00 00       	jmp    800402 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800360:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800367:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036e:	eb 69                	jmp    8003d9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80037b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037e:	89 d0                	mov    %edx,%eax
  800380:	01 c0                	add    %eax,%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	c1 e0 03             	shl    $0x3,%eax
  800387:	01 c8                	add    %ecx,%eax
  800389:	8a 40 04             	mov    0x4(%eax),%al
  80038c:	84 c0                	test   %al,%al
  80038e:	75 46                	jne    8003d6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80039b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039e:	89 d0                	mov    %edx,%eax
  8003a0:	01 c0                	add    %eax,%eax
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 03             	shl    $0x3,%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	75 09                	jne    8003d6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003d4:	eb 12                	jmp    8003e8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d6:	ff 45 e8             	incl   -0x18(%ebp)
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	8b 50 74             	mov    0x74(%eax),%edx
  8003e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003e4:	39 c2                	cmp    %eax,%edx
  8003e6:	77 88                	ja     800370 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ec:	75 14                	jne    800402 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	68 f8 1f 80 00       	push   $0x801ff8
  8003f6:	6a 3a                	push   $0x3a
  8003f8:	68 ec 1f 80 00       	push   $0x801fec
  8003fd:	e8 93 fe ff ff       	call   800295 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800402:	ff 45 f0             	incl   -0x10(%ebp)
  800405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	0f 8c 32 ff ff ff    	jl     800343 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800411:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800418:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041f:	eb 26                	jmp    800447 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800421:	a1 20 30 80 00       	mov    0x803020,%eax
  800426:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80042c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8a 40 04             	mov    0x4(%eax),%al
  80043d:	3c 01                	cmp    $0x1,%al
  80043f:	75 03                	jne    800444 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800441:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800444:	ff 45 e0             	incl   -0x20(%ebp)
  800447:	a1 20 30 80 00       	mov    0x803020,%eax
  80044c:	8b 50 74             	mov    0x74(%eax),%edx
  80044f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800452:	39 c2                	cmp    %eax,%edx
  800454:	77 cb                	ja     800421 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800459:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80045c:	74 14                	je     800472 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 4c 20 80 00       	push   $0x80204c
  800466:	6a 44                	push   $0x44
  800468:	68 ec 1f 80 00       	push   $0x801fec
  80046d:	e8 23 fe ff ff       	call   800295 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	8d 48 01             	lea    0x1(%eax),%ecx
  800483:	8b 55 0c             	mov    0xc(%ebp),%edx
  800486:	89 0a                	mov    %ecx,(%edx)
  800488:	8b 55 08             	mov    0x8(%ebp),%edx
  80048b:	88 d1                	mov    %dl,%cl
  80048d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800490:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800494:	8b 45 0c             	mov    0xc(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049e:	75 2c                	jne    8004cc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004a0:	a0 24 30 80 00       	mov    0x803024,%al
  8004a5:	0f b6 c0             	movzbl %al,%eax
  8004a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ab:	8b 12                	mov    (%edx),%edx
  8004ad:	89 d1                	mov    %edx,%ecx
  8004af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b2:	83 c2 08             	add    $0x8,%edx
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	50                   	push   %eax
  8004b9:	51                   	push   %ecx
  8004ba:	52                   	push   %edx
  8004bb:	e8 7b 0f 00 00       	call   80143b <sys_cputs>
  8004c0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	8b 40 04             	mov    0x4(%eax),%eax
  8004d2:	8d 50 01             	lea    0x1(%eax),%edx
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004db:	90                   	nop
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ee:	00 00 00 
	b.cnt = 0;
  8004f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004fb:	ff 75 0c             	pushl  0xc(%ebp)
  8004fe:	ff 75 08             	pushl  0x8(%ebp)
  800501:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800507:	50                   	push   %eax
  800508:	68 75 04 80 00       	push   $0x800475
  80050d:	e8 11 02 00 00       	call   800723 <vprintfmt>
  800512:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800515:	a0 24 30 80 00       	mov    0x803024,%al
  80051a:	0f b6 c0             	movzbl %al,%eax
  80051d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800523:	83 ec 04             	sub    $0x4,%esp
  800526:	50                   	push   %eax
  800527:	52                   	push   %edx
  800528:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052e:	83 c0 08             	add    $0x8,%eax
  800531:	50                   	push   %eax
  800532:	e8 04 0f 00 00       	call   80143b <sys_cputs>
  800537:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80053a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800541:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <cprintf>:

int cprintf(const char *fmt, ...) {
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800556:	8d 45 0c             	lea    0xc(%ebp),%eax
  800559:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 f4             	pushl  -0xc(%ebp)
  800565:	50                   	push   %eax
  800566:	e8 73 ff ff ff       	call   8004de <vcprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800571:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80057c:	e8 68 10 00 00       	call   8015e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800581:	8d 45 0c             	lea    0xc(%ebp),%eax
  800584:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	ff 75 f4             	pushl  -0xc(%ebp)
  800590:	50                   	push   %eax
  800591:	e8 48 ff ff ff       	call   8004de <vcprintf>
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80059c:	e8 62 10 00 00       	call   801603 <sys_enable_interrupt>
	return cnt;
  8005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a4:	c9                   	leave  
  8005a5:	c3                   	ret    

008005a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
  8005a9:	53                   	push   %ebx
  8005aa:	83 ec 14             	sub    $0x14,%esp
  8005ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	77 55                	ja     80061b <printnum+0x75>
  8005c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c9:	72 05                	jb     8005d0 <printnum+0x2a>
  8005cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ce:	77 4b                	ja     80061b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005d3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e6:	e8 85 14 00 00       	call   801a70 <__udivdi3>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	83 ec 04             	sub    $0x4,%esp
  8005f1:	ff 75 20             	pushl  0x20(%ebp)
  8005f4:	53                   	push   %ebx
  8005f5:	ff 75 18             	pushl  0x18(%ebp)
  8005f8:	52                   	push   %edx
  8005f9:	50                   	push   %eax
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 08             	pushl  0x8(%ebp)
  800600:	e8 a1 ff ff ff       	call   8005a6 <printnum>
  800605:	83 c4 20             	add    $0x20,%esp
  800608:	eb 1a                	jmp    800624 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	ff d0                	call   *%eax
  800618:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061b:	ff 4d 1c             	decl   0x1c(%ebp)
  80061e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800622:	7f e6                	jg     80060a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800624:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800627:	bb 00 00 00 00       	mov    $0x0,%ebx
  80062c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800632:	53                   	push   %ebx
  800633:	51                   	push   %ecx
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	e8 45 15 00 00       	call   801b80 <__umoddi3>
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	05 b4 22 80 00       	add    $0x8022b4,%eax
  800643:	8a 00                	mov    (%eax),%al
  800645:	0f be c0             	movsbl %al,%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
}
  800657:	90                   	nop
  800658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065b:	c9                   	leave  
  80065c:	c3                   	ret    

0080065d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800660:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800664:	7e 1c                	jle    800682 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	8d 50 08             	lea    0x8(%eax),%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	89 10                	mov    %edx,(%eax)
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	83 e8 08             	sub    $0x8,%eax
  80067b:	8b 50 04             	mov    0x4(%eax),%edx
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	eb 40                	jmp    8006c2 <getuint+0x65>
	else if (lflag)
  800682:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800686:	74 1e                	je     8006a6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	eb 1c                	jmp    8006c2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 04             	sub    $0x4,%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006c2:	5d                   	pop    %ebp
  8006c3:	c3                   	ret    

008006c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cb:	7e 1c                	jle    8006e9 <getint+0x25>
		return va_arg(*ap, long long);
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	8d 50 08             	lea    0x8(%eax),%edx
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	89 10                	mov    %edx,(%eax)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	83 e8 08             	sub    $0x8,%eax
  8006e2:	8b 50 04             	mov    0x4(%eax),%edx
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	eb 38                	jmp    800721 <getint+0x5d>
	else if (lflag)
  8006e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ed:	74 1a                	je     800709 <getint+0x45>
		return va_arg(*ap, long);
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	8d 50 04             	lea    0x4(%eax),%edx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	89 10                	mov    %edx,(%eax)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	99                   	cltd   
  800707:	eb 18                	jmp    800721 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 04             	lea    0x4(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 04             	sub    $0x4,%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	99                   	cltd   
}
  800721:	5d                   	pop    %ebp
  800722:	c3                   	ret    

00800723 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	56                   	push   %esi
  800727:	53                   	push   %ebx
  800728:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072b:	eb 17                	jmp    800744 <vprintfmt+0x21>
			if (ch == '\0')
  80072d:	85 db                	test   %ebx,%ebx
  80072f:	0f 84 af 03 00 00    	je     800ae4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	53                   	push   %ebx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	ff d0                	call   *%eax
  800741:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800744:	8b 45 10             	mov    0x10(%ebp),%eax
  800747:	8d 50 01             	lea    0x1(%eax),%edx
  80074a:	89 55 10             	mov    %edx,0x10(%ebp)
  80074d:	8a 00                	mov    (%eax),%al
  80074f:	0f b6 d8             	movzbl %al,%ebx
  800752:	83 fb 25             	cmp    $0x25,%ebx
  800755:	75 d6                	jne    80072d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800757:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80075b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800762:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800769:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800770:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800777:	8b 45 10             	mov    0x10(%ebp),%eax
  80077a:	8d 50 01             	lea    0x1(%eax),%edx
  80077d:	89 55 10             	mov    %edx,0x10(%ebp)
  800780:	8a 00                	mov    (%eax),%al
  800782:	0f b6 d8             	movzbl %al,%ebx
  800785:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800788:	83 f8 55             	cmp    $0x55,%eax
  80078b:	0f 87 2b 03 00 00    	ja     800abc <vprintfmt+0x399>
  800791:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  800798:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80079a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80079e:	eb d7                	jmp    800777 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007a4:	eb d1                	jmp    800777 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007b0:	89 d0                	mov    %edx,%eax
  8007b2:	c1 e0 02             	shl    $0x2,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	01 c0                	add    %eax,%eax
  8007b9:	01 d8                	add    %ebx,%eax
  8007bb:	83 e8 30             	sub    $0x30,%eax
  8007be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	8a 00                	mov    (%eax),%al
  8007c6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007cc:	7e 3e                	jle    80080c <vprintfmt+0xe9>
  8007ce:	83 fb 39             	cmp    $0x39,%ebx
  8007d1:	7f 39                	jg     80080c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d6:	eb d5                	jmp    8007ad <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	83 c0 04             	add    $0x4,%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	83 e8 04             	sub    $0x4,%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ec:	eb 1f                	jmp    80080d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	79 83                	jns    800777 <vprintfmt+0x54>
				width = 0;
  8007f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007fb:	e9 77 ff ff ff       	jmp    800777 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800800:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800807:	e9 6b ff ff ff       	jmp    800777 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80080c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	0f 89 60 ff ff ff    	jns    800777 <vprintfmt+0x54>
				width = precision, precision = -1;
  800817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80081d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800824:	e9 4e ff ff ff       	jmp    800777 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800829:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80082c:	e9 46 ff ff ff       	jmp    800777 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 c0 04             	add    $0x4,%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	83 e8 04             	sub    $0x4,%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	50                   	push   %eax
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 89 02 00 00       	jmp    800adf <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	83 c0 04             	add    $0x4,%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	83 e8 04             	sub    $0x4,%eax
  800865:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800867:	85 db                	test   %ebx,%ebx
  800869:	79 02                	jns    80086d <vprintfmt+0x14a>
				err = -err;
  80086b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80086d:	83 fb 64             	cmp    $0x64,%ebx
  800870:	7f 0b                	jg     80087d <vprintfmt+0x15a>
  800872:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  800879:	85 f6                	test   %esi,%esi
  80087b:	75 19                	jne    800896 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80087d:	53                   	push   %ebx
  80087e:	68 c5 22 80 00       	push   $0x8022c5
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	ff 75 08             	pushl  0x8(%ebp)
  800889:	e8 5e 02 00 00       	call   800aec <printfmt>
  80088e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800891:	e9 49 02 00 00       	jmp    800adf <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800896:	56                   	push   %esi
  800897:	68 ce 22 80 00       	push   $0x8022ce
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	ff 75 08             	pushl  0x8(%ebp)
  8008a2:	e8 45 02 00 00       	call   800aec <printfmt>
  8008a7:	83 c4 10             	add    $0x10,%esp
			break;
  8008aa:	e9 30 02 00 00       	jmp    800adf <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	83 c0 04             	add    $0x4,%eax
  8008b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	83 e8 04             	sub    $0x4,%eax
  8008be:	8b 30                	mov    (%eax),%esi
  8008c0:	85 f6                	test   %esi,%esi
  8008c2:	75 05                	jne    8008c9 <vprintfmt+0x1a6>
				p = "(null)";
  8008c4:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cd:	7e 6d                	jle    80093c <vprintfmt+0x219>
  8008cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008d3:	74 67                	je     80093c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	50                   	push   %eax
  8008dc:	56                   	push   %esi
  8008dd:	e8 0c 03 00 00       	call   800bee <strnlen>
  8008e2:	83 c4 10             	add    $0x10,%esp
  8008e5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e8:	eb 16                	jmp    800900 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ea:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	50                   	push   %eax
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800900:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800904:	7f e4                	jg     8008ea <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800906:	eb 34                	jmp    80093c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800908:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80090c:	74 1c                	je     80092a <vprintfmt+0x207>
  80090e:	83 fb 1f             	cmp    $0x1f,%ebx
  800911:	7e 05                	jle    800918 <vprintfmt+0x1f5>
  800913:	83 fb 7e             	cmp    $0x7e,%ebx
  800916:	7e 12                	jle    80092a <vprintfmt+0x207>
					putch('?', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 3f                	push   $0x3f
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	eb 0f                	jmp    800939 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	89 f0                	mov    %esi,%eax
  80093e:	8d 70 01             	lea    0x1(%eax),%esi
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f be d8             	movsbl %al,%ebx
  800946:	85 db                	test   %ebx,%ebx
  800948:	74 24                	je     80096e <vprintfmt+0x24b>
  80094a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094e:	78 b8                	js     800908 <vprintfmt+0x1e5>
  800950:	ff 4d e0             	decl   -0x20(%ebp)
  800953:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800957:	79 af                	jns    800908 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800959:	eb 13                	jmp    80096e <vprintfmt+0x24b>
				putch(' ', putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	6a 20                	push   $0x20
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	ff d0                	call   *%eax
  800968:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096b:	ff 4d e4             	decl   -0x1c(%ebp)
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800972:	7f e7                	jg     80095b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800974:	e9 66 01 00 00       	jmp    800adf <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 e8             	pushl  -0x18(%ebp)
  80097f:	8d 45 14             	lea    0x14(%ebp),%eax
  800982:	50                   	push   %eax
  800983:	e8 3c fd ff ff       	call   8006c4 <getint>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800997:	85 d2                	test   %edx,%edx
  800999:	79 23                	jns    8009be <vprintfmt+0x29b>
				putch('-', putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	6a 2d                	push   $0x2d
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b1:	f7 d8                	neg    %eax
  8009b3:	83 d2 00             	adc    $0x0,%edx
  8009b6:	f7 da                	neg    %edx
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 bc 00 00 00       	jmp    800a86 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d3:	50                   	push   %eax
  8009d4:	e8 84 fc ff ff       	call   80065d <getuint>
  8009d9:	83 c4 10             	add    $0x10,%esp
  8009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009e2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e9:	e9 98 00 00 00       	jmp    800a86 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 58                	push   $0x58
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	6a 58                	push   $0x58
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			break;
  800a1e:	e9 bc 00 00 00       	jmp    800adf <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 30                	push   $0x30
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 78                	push   $0x78
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a5e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a65:	eb 1f                	jmp    800a86 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a70:	50                   	push   %eax
  800a71:	e8 e7 fb ff ff       	call   80065d <getuint>
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a86:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8d:	83 ec 04             	sub    $0x4,%esp
  800a90:	52                   	push   %edx
  800a91:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a94:	50                   	push   %eax
  800a95:	ff 75 f4             	pushl  -0xc(%ebp)
  800a98:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	ff 75 08             	pushl  0x8(%ebp)
  800aa1:	e8 00 fb ff ff       	call   8005a6 <printnum>
  800aa6:	83 c4 20             	add    $0x20,%esp
			break;
  800aa9:	eb 34                	jmp    800adf <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			break;
  800aba:	eb 23                	jmp    800adf <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	6a 25                	push   $0x25
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	eb 03                	jmp    800ad4 <vprintfmt+0x3b1>
  800ad1:	ff 4d 10             	decl   0x10(%ebp)
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	48                   	dec    %eax
  800ad8:	8a 00                	mov    (%eax),%al
  800ada:	3c 25                	cmp    $0x25,%al
  800adc:	75 f3                	jne    800ad1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ade:	90                   	nop
		}
	}
  800adf:	e9 47 fc ff ff       	jmp    80072b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af2:	8d 45 10             	lea    0x10(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afb:	8b 45 10             	mov    0x10(%ebp),%eax
  800afe:	ff 75 f4             	pushl  -0xc(%ebp)
  800b01:	50                   	push   %eax
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 16 fc ff ff       	call   800723 <vprintfmt>
  800b0d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b10:	90                   	nop
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 40 08             	mov    0x8(%eax),%eax
  800b1c:	8d 50 01             	lea    0x1(%eax),%edx
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 10                	mov    (%eax),%edx
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	39 c2                	cmp    %eax,%edx
  800b32:	73 12                	jae    800b46 <sprintputch+0x33>
		*b->buf++ = ch;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	89 0a                	mov    %ecx,(%edx)
  800b41:	8b 55 08             	mov    0x8(%ebp),%edx
  800b44:	88 10                	mov    %dl,(%eax)
}
  800b46:	90                   	nop
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6e:	74 06                	je     800b76 <vsnprintf+0x2d>
  800b70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b74:	7f 07                	jg     800b7d <vsnprintf+0x34>
		return -E_INVAL;
  800b76:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7b:	eb 20                	jmp    800b9d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7d:	ff 75 14             	pushl  0x14(%ebp)
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 13 0b 80 00       	push   $0x800b13
  800b8c:	e8 92 fb ff ff       	call   800723 <vprintfmt>
  800b91:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b97:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bae:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb4:	50                   	push   %eax
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	ff 75 08             	pushl  0x8(%ebp)
  800bbb:	e8 89 ff ff ff       	call   800b49 <vsnprintf>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd8:	eb 06                	jmp    800be0 <strlen+0x15>
		n++;
  800bda:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	ff 45 08             	incl   0x8(%ebp)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	84 c0                	test   %al,%al
  800be7:	75 f1                	jne    800bda <strlen+0xf>
		n++;
	return n;
  800be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfb:	eb 09                	jmp    800c06 <strnlen+0x18>
		n++;
  800bfd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	ff 4d 0c             	decl   0xc(%ebp)
  800c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0a:	74 09                	je     800c15 <strnlen+0x27>
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	84 c0                	test   %al,%al
  800c13:	75 e8                	jne    800bfd <strnlen+0xf>
		n++;
	return n;
  800c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c26:	90                   	nop
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8d 50 01             	lea    0x1(%eax),%edx
  800c2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c39:	8a 12                	mov    (%edx),%dl
  800c3b:	88 10                	mov    %dl,(%eax)
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	75 e4                	jne    800c27 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5b:	eb 1f                	jmp    800c7c <strncpy+0x34>
		*dst++ = *src;
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8d 50 01             	lea    0x1(%eax),%edx
  800c63:	89 55 08             	mov    %edx,0x8(%ebp)
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c69:	8a 12                	mov    (%edx),%dl
  800c6b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	74 03                	je     800c79 <strncpy+0x31>
			src++;
  800c76:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c79:	ff 45 fc             	incl   -0x4(%ebp)
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c82:	72 d9                	jb     800c5d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c99:	74 30                	je     800ccb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9b:	eb 16                	jmp    800cb3 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8d 50 01             	lea    0x1(%eax),%edx
  800ca3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caf:	8a 12                	mov    (%edx),%dl
  800cb1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb3:	ff 4d 10             	decl   0x10(%ebp)
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 09                	je     800cc5 <strlcpy+0x3c>
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 d8                	jne    800c9d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd1:	29 c2                	sub    %eax,%edx
  800cd3:	89 d0                	mov    %edx,%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cda:	eb 06                	jmp    800ce2 <strcmp+0xb>
		p++, q++;
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 0e                	je     800cf9 <strcmp+0x22>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 10                	mov    (%eax),%dl
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	38 c2                	cmp    %al,%dl
  800cf7:	74 e3                	je     800cdc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 d0             	movzbl %al,%edx
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	0f b6 c0             	movzbl %al,%eax
  800d09:	29 c2                	sub    %eax,%edx
  800d0b:	89 d0                	mov    %edx,%eax
}
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d12:	eb 09                	jmp    800d1d <strncmp+0xe>
		n--, p++, q++;
  800d14:	ff 4d 10             	decl   0x10(%ebp)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 17                	je     800d3a <strncmp+0x2b>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	74 0e                	je     800d3a <strncmp+0x2b>
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 10                	mov    (%eax),%dl
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	38 c2                	cmp    %al,%dl
  800d38:	74 da                	je     800d14 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	75 07                	jne    800d47 <strncmp+0x38>
		return 0;
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	eb 14                	jmp    800d5b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f b6 d0             	movzbl %al,%edx
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f b6 c0             	movzbl %al,%eax
  800d57:	29 c2                	sub    %eax,%edx
  800d59:	89 d0                	mov    %edx,%eax
}
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    

00800d5d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d69:	eb 12                	jmp    800d7d <strchr+0x20>
		if (*s == c)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d73:	75 05                	jne    800d7a <strchr+0x1d>
			return (char *) s;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	eb 11                	jmp    800d8b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	84 c0                	test   %al,%al
  800d84:	75 e5                	jne    800d6b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 04             	sub    $0x4,%esp
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d99:	eb 0d                	jmp    800da8 <strfind+0x1b>
		if (*s == c)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da3:	74 0e                	je     800db3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da5:	ff 45 08             	incl   0x8(%ebp)
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	75 ea                	jne    800d9b <strfind+0xe>
  800db1:	eb 01                	jmp    800db4 <strfind+0x27>
		if (*s == c)
			break;
  800db3:	90                   	nop
	return (char *) s;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dcb:	eb 0e                	jmp    800ddb <memset+0x22>
		*p++ = c;
  800dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd0:	8d 50 01             	lea    0x1(%eax),%edx
  800dd3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ddb:	ff 4d f8             	decl   -0x8(%ebp)
  800dde:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de2:	79 e9                	jns    800dcd <memset+0x14>
		*p++ = c;

	return v;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfb:	eb 16                	jmp    800e13 <memcpy+0x2a>
		*d++ = *s++;
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 dd                	jne    800dfd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3d:	73 50                	jae    800e8f <memmove+0x6a>
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4a:	76 43                	jbe    800e8f <memmove+0x6a>
		s += n;
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e58:	eb 10                	jmp    800e6a <memmove+0x45>
			*--d = *--s;
  800e5a:	ff 4d f8             	decl   -0x8(%ebp)
  800e5d:	ff 4d fc             	decl   -0x4(%ebp)
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	8a 10                	mov    (%eax),%dl
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e70:	89 55 10             	mov    %edx,0x10(%ebp)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	75 e3                	jne    800e5a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e77:	eb 23                	jmp    800e9c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	8d 50 01             	lea    0x1(%eax),%edx
  800e7f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e88:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8b:	8a 12                	mov    (%edx),%dl
  800e8d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e95:	89 55 10             	mov    %edx,0x10(%ebp)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	75 dd                	jne    800e79 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb3:	eb 2a                	jmp    800edf <memcmp+0x3e>
		if (*s1 != *s2)
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb8:	8a 10                	mov    (%eax),%dl
  800eba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	38 c2                	cmp    %al,%dl
  800ec1:	74 16                	je     800ed9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 c0             	movzbl %al,%eax
  800ed3:	29 c2                	sub    %eax,%edx
  800ed5:	89 d0                	mov    %edx,%eax
  800ed7:	eb 18                	jmp    800ef1 <memcmp+0x50>
		s1++, s2++;
  800ed9:	ff 45 fc             	incl   -0x4(%ebp)
  800edc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	75 c9                	jne    800eb5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	01 d0                	add    %edx,%eax
  800f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f04:	eb 15                	jmp    800f1b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f b6 d0             	movzbl %al,%edx
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	0f b6 c0             	movzbl %al,%eax
  800f14:	39 c2                	cmp    %eax,%edx
  800f16:	74 0d                	je     800f25 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f21:	72 e3                	jb     800f06 <memfind+0x13>
  800f23:	eb 01                	jmp    800f26 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f25:	90                   	nop
	return (void *) s;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	eb 03                	jmp    800f44 <strtol+0x19>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 20                	cmp    $0x20,%al
  800f4b:	74 f4                	je     800f41 <strtol+0x16>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	3c 09                	cmp    $0x9,%al
  800f54:	74 eb                	je     800f41 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 2b                	cmp    $0x2b,%al
  800f5d:	75 05                	jne    800f64 <strtol+0x39>
		s++;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	eb 13                	jmp    800f77 <strtol+0x4c>
	else if (*s == '-')
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 2d                	cmp    $0x2d,%al
  800f6b:	75 0a                	jne    800f77 <strtol+0x4c>
		s++, neg = 1;
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	74 06                	je     800f83 <strtol+0x58>
  800f7d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f81:	75 20                	jne    800fa3 <strtol+0x78>
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3c 30                	cmp    $0x30,%al
  800f8a:	75 17                	jne    800fa3 <strtol+0x78>
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	40                   	inc    %eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 78                	cmp    $0x78,%al
  800f94:	75 0d                	jne    800fa3 <strtol+0x78>
		s += 2, base = 16;
  800f96:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa1:	eb 28                	jmp    800fcb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa7:	75 15                	jne    800fbe <strtol+0x93>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 30                	cmp    $0x30,%al
  800fb0:	75 0c                	jne    800fbe <strtol+0x93>
		s++, base = 8;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbc:	eb 0d                	jmp    800fcb <strtol+0xa0>
	else if (base == 0)
  800fbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc2:	75 07                	jne    800fcb <strtol+0xa0>
		base = 10;
  800fc4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 2f                	cmp    $0x2f,%al
  800fd2:	7e 19                	jle    800fed <strtol+0xc2>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 39                	cmp    $0x39,%al
  800fdb:	7f 10                	jg     800fed <strtol+0xc2>
			dig = *s - '0';
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	0f be c0             	movsbl %al,%eax
  800fe5:	83 e8 30             	sub    $0x30,%eax
  800fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800feb:	eb 42                	jmp    80102f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 60                	cmp    $0x60,%al
  800ff4:	7e 19                	jle    80100f <strtol+0xe4>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 7a                	cmp    $0x7a,%al
  800ffd:	7f 10                	jg     80100f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	0f be c0             	movsbl %al,%eax
  801007:	83 e8 57             	sub    $0x57,%eax
  80100a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100d:	eb 20                	jmp    80102f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 40                	cmp    $0x40,%al
  801016:	7e 39                	jle    801051 <strtol+0x126>
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	3c 5a                	cmp    $0x5a,%al
  80101f:	7f 30                	jg     801051 <strtol+0x126>
			dig = *s - 'A' + 10;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f be c0             	movsbl %al,%eax
  801029:	83 e8 37             	sub    $0x37,%eax
  80102c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801032:	3b 45 10             	cmp    0x10(%ebp),%eax
  801035:	7d 19                	jge    801050 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801037:	ff 45 08             	incl   0x8(%ebp)
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801041:	89 c2                	mov    %eax,%edx
  801043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104b:	e9 7b ff ff ff       	jmp    800fcb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801050:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801051:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801055:	74 08                	je     80105f <strtol+0x134>
		*endptr = (char *) s;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801063:	74 07                	je     80106c <strtol+0x141>
  801065:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801068:	f7 d8                	neg    %eax
  80106a:	eb 03                	jmp    80106f <strtol+0x144>
  80106c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <ltostr>:

void
ltostr(long value, char *str)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80107e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801089:	79 13                	jns    80109e <ltostr+0x2d>
	{
		neg = 1;
  80108b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801098:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a6:	99                   	cltd   
  8010a7:	f7 f9                	idiv   %ecx
  8010a9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	8d 50 01             	lea    0x1(%eax),%edx
  8010b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b5:	89 c2                	mov    %eax,%edx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	01 d0                	add    %edx,%eax
  8010bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010bf:	83 c2 30             	add    $0x30,%edx
  8010c2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cc:	f7 e9                	imul   %ecx
  8010ce:	c1 fa 02             	sar    $0x2,%edx
  8010d1:	89 c8                	mov    %ecx,%eax
  8010d3:	c1 f8 1f             	sar    $0x1f,%eax
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
  8010da:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e5:	f7 e9                	imul   %ecx
  8010e7:	c1 fa 02             	sar    $0x2,%edx
  8010ea:	89 c8                	mov    %ecx,%eax
  8010ec:	c1 f8 1f             	sar    $0x1f,%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
  8010f3:	c1 e0 02             	shl    $0x2,%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	01 c0                	add    %eax,%eax
  8010fa:	29 c1                	sub    %eax,%ecx
  8010fc:	89 ca                	mov    %ecx,%edx
  8010fe:	85 d2                	test   %edx,%edx
  801100:	75 9c                	jne    80109e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	48                   	dec    %eax
  80110d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801110:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801114:	74 3d                	je     801153 <ltostr+0xe2>
		start = 1 ;
  801116:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80111d:	eb 34                	jmp    801153 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80112c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	01 c2                	add    %eax,%edx
  801134:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 c8                	add    %ecx,%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801140:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c2                	add    %eax,%edx
  801148:	8a 45 eb             	mov    -0x15(%ebp),%al
  80114b:	88 02                	mov    %al,(%edx)
		start++ ;
  80114d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801150:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801156:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801159:	7c c4                	jl     80111f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80115b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801166:	90                   	nop
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116f:	ff 75 08             	pushl  0x8(%ebp)
  801172:	e8 54 fa ff ff       	call   800bcb <strlen>
  801177:	83 c4 04             	add    $0x4,%esp
  80117a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80117d:	ff 75 0c             	pushl  0xc(%ebp)
  801180:	e8 46 fa ff ff       	call   800bcb <strlen>
  801185:	83 c4 04             	add    $0x4,%esp
  801188:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80118b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801199:	eb 17                	jmp    8011b2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80119b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 c2                	add    %eax,%edx
  8011a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	01 c8                	add    %ecx,%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011af:	ff 45 fc             	incl   -0x4(%ebp)
  8011b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b8:	7c e1                	jl     80119b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c8:	eb 1f                	jmp    8011e9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cd:	8d 50 01             	lea    0x1(%eax),%edx
  8011d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011d3:	89 c2                	mov    %eax,%edx
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	01 c2                	add    %eax,%edx
  8011da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e0:	01 c8                	add    %ecx,%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e6:	ff 45 f8             	incl   -0x8(%ebp)
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ef:	7c d9                	jl     8011ca <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	c6 00 00             	movb   $0x0,(%eax)
}
  8011fc:	90                   	nop
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801202:	8b 45 14             	mov    0x14(%ebp),%eax
  801205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80120b:	8b 45 14             	mov    0x14(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801222:	eb 0c                	jmp    801230 <strsplit+0x31>
			*string++ = 0;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8d 50 01             	lea    0x1(%eax),%edx
  80122a:	89 55 08             	mov    %edx,0x8(%ebp)
  80122d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	84 c0                	test   %al,%al
  801237:	74 18                	je     801251 <strsplit+0x52>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	0f be c0             	movsbl %al,%eax
  801241:	50                   	push   %eax
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	e8 13 fb ff ff       	call   800d5d <strchr>
  80124a:	83 c4 08             	add    $0x8,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	75 d3                	jne    801224 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 5a                	je     8012b4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 f8 0f             	cmp    $0xf,%eax
  801262:	75 07                	jne    80126b <strsplit+0x6c>
		{
			return 0;
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	eb 66                	jmp    8012d1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	8b 00                	mov    (%eax),%eax
  801270:	8d 48 01             	lea    0x1(%eax),%ecx
  801273:	8b 55 14             	mov    0x14(%ebp),%edx
  801276:	89 0a                	mov    %ecx,(%edx)
  801278:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127f:	8b 45 10             	mov    0x10(%ebp),%eax
  801282:	01 c2                	add    %eax,%edx
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	eb 03                	jmp    80128e <strsplit+0x8f>
			string++;
  80128b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	84 c0                	test   %al,%al
  801295:	74 8b                	je     801222 <strsplit+0x23>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	0f be c0             	movsbl %al,%eax
  80129f:	50                   	push   %eax
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	e8 b5 fa ff ff       	call   800d5d <strchr>
  8012a8:	83 c4 08             	add    $0x8,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	74 dc                	je     80128b <strsplit+0x8c>
			string++;
	}
  8012af:	e9 6e ff ff ff       	jmp    801222 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012b4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	68 30 24 80 00       	push   $0x802430
  8012e1:	6a 0e                	push   $0xe
  8012e3:	68 6a 24 80 00       	push   $0x80246a
  8012e8:	e8 a8 ef ff ff       	call   800295 <_panic>

008012ed <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8012f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	74 0f                	je     80130b <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8012fc:	e8 d2 ff ff ff       	call   8012d3 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801301:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801308:	00 00 00 
	}
	if (size == 0) return NULL ;
  80130b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130f:	75 07                	jne    801318 <malloc+0x2b>
  801311:	b8 00 00 00 00       	mov    $0x0,%eax
  801316:	eb 14                	jmp    80132c <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801318:	83 ec 04             	sub    $0x4,%esp
  80131b:	68 78 24 80 00       	push   $0x802478
  801320:	6a 2e                	push   $0x2e
  801322:	68 6a 24 80 00       	push   $0x80246a
  801327:	e8 69 ef ff ff       	call   800295 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 a0 24 80 00       	push   $0x8024a0
  80133c:	6a 49                	push   $0x49
  80133e:	68 6a 24 80 00       	push   $0x80246a
  801343:	e8 4d ef ff ff       	call   800295 <_panic>

00801348 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 18             	sub    $0x18,%esp
  80134e:	8b 45 10             	mov    0x10(%ebp),%eax
  801351:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	68 c4 24 80 00       	push   $0x8024c4
  80135c:	6a 57                	push   $0x57
  80135e:	68 6a 24 80 00       	push   $0x80246a
  801363:	e8 2d ef ff ff       	call   800295 <_panic>

00801368 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 ec 24 80 00       	push   $0x8024ec
  801376:	6a 60                	push   $0x60
  801378:	68 6a 24 80 00       	push   $0x80246a
  80137d:	e8 13 ef ff ff       	call   800295 <_panic>

00801382 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 10 25 80 00       	push   $0x802510
  801390:	6a 7c                	push   $0x7c
  801392:	68 6a 24 80 00       	push   $0x80246a
  801397:	e8 f9 ee ff ff       	call   800295 <_panic>

0080139c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	68 38 25 80 00       	push   $0x802538
  8013aa:	68 86 00 00 00       	push   $0x86
  8013af:	68 6a 24 80 00       	push   $0x80246a
  8013b4:	e8 dc ee ff ff       	call   800295 <_panic>

008013b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 5c 25 80 00       	push   $0x80255c
  8013c7:	68 91 00 00 00       	push   $0x91
  8013cc:	68 6a 24 80 00       	push   $0x80246a
  8013d1:	e8 bf ee ff ff       	call   800295 <_panic>

008013d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	68 5c 25 80 00       	push   $0x80255c
  8013e4:	68 96 00 00 00       	push   $0x96
  8013e9:	68 6a 24 80 00       	push   $0x80246a
  8013ee:	e8 a2 ee ff ff       	call   800295 <_panic>

008013f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	68 5c 25 80 00       	push   $0x80255c
  801401:	68 9b 00 00 00       	push   $0x9b
  801406:	68 6a 24 80 00       	push   $0x80246a
  80140b:	e8 85 ee ff ff       	call   800295 <_panic>

00801410 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801422:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801425:	8b 7d 18             	mov    0x18(%ebp),%edi
  801428:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80142b:	cd 30                	int    $0x30
  80142d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	5b                   	pop    %ebx
  801437:	5e                   	pop    %esi
  801438:	5f                   	pop    %edi
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    

0080143b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801447:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	52                   	push   %edx
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	50                   	push   %eax
  801457:	6a 00                	push   $0x0
  801459:	e8 b2 ff ff ff       	call   801410 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	90                   	nop
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_cgetc>:

int
sys_cgetc(void)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 01                	push   $0x1
  801473:	e8 98 ff ff ff       	call   801410 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	52                   	push   %edx
  80148d:	50                   	push   %eax
  80148e:	6a 05                	push   $0x5
  801490:	e8 7b ff ff ff       	call   801410 <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	56                   	push   %esi
  80149e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80149f:	8b 75 18             	mov    0x18(%ebp),%esi
  8014a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	56                   	push   %esi
  8014af:	53                   	push   %ebx
  8014b0:	51                   	push   %ecx
  8014b1:	52                   	push   %edx
  8014b2:	50                   	push   %eax
  8014b3:	6a 06                	push   $0x6
  8014b5:	e8 56 ff ff ff       	call   801410 <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5e                   	pop    %esi
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	52                   	push   %edx
  8014d4:	50                   	push   %eax
  8014d5:	6a 07                	push   $0x7
  8014d7:	e8 34 ff ff ff       	call   801410 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	6a 08                	push   $0x8
  8014f2:	e8 19 ff ff ff       	call   801410 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 09                	push   $0x9
  80150b:	e8 00 ff ff ff       	call   801410 <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 0a                	push   $0xa
  801524:	e8 e7 fe ff ff       	call   801410 <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 0b                	push   $0xb
  80153d:	e8 ce fe ff ff       	call   801410 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	ff 75 08             	pushl  0x8(%ebp)
  801556:	6a 0f                	push   $0xf
  801558:	e8 b3 fe ff ff       	call   801410 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
	return;
  801560:	90                   	nop
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	6a 10                	push   $0x10
  801574:	e8 97 fe ff ff       	call   801410 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
	return ;
  80157c:	90                   	nop
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 10             	pushl  0x10(%ebp)
  801589:	ff 75 0c             	pushl  0xc(%ebp)
  80158c:	ff 75 08             	pushl  0x8(%ebp)
  80158f:	6a 11                	push   $0x11
  801591:	e8 7a fe ff ff       	call   801410 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
	return ;
  801599:	90                   	nop
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 0c                	push   $0xc
  8015ab:	e8 60 fe ff ff       	call   801410 <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	6a 0d                	push   $0xd
  8015c5:	e8 46 fe ff ff       	call   801410 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 0e                	push   $0xe
  8015de:	e8 2d fe ff ff       	call   801410 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 13                	push   $0x13
  8015f8:	e8 13 fe ff ff       	call   801410 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 14                	push   $0x14
  801612:	e8 f9 fd ff ff       	call   801410 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_cputc>:


void
sys_cputc(const char c)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801629:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	50                   	push   %eax
  801636:	6a 15                	push   $0x15
  801638:	e8 d3 fd ff ff       	call   801410 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	90                   	nop
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 16                	push   $0x16
  801652:	e8 b9 fd ff ff       	call   801410 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	50                   	push   %eax
  80166d:	6a 17                	push   $0x17
  80166f:	e8 9c fd ff ff       	call   801410 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80167c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 1a                	push   $0x1a
  80168c:	e8 7f fd ff ff       	call   801410 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 18                	push   $0x18
  8016a9:	e8 62 fd ff ff       	call   801410 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	90                   	nop
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 19                	push   $0x19
  8016c7:	e8 44 fd ff ff       	call   801410 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	90                   	nop
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 04             	sub    $0x4,%esp
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	6a 00                	push   $0x0
  8016ea:	51                   	push   %ecx
  8016eb:	52                   	push   %edx
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	50                   	push   %eax
  8016f0:	6a 1b                	push   $0x1b
  8016f2:	e8 19 fd ff ff       	call   801410 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 1c                	push   $0x1c
  80170f:	e8 fc fc ff ff       	call   801410 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80171c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	51                   	push   %ecx
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	6a 1d                	push   $0x1d
  80172e:	e8 dd fc ff ff       	call   801410 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 1e                	push   $0x1e
  80174b:	e8 c0 fc ff ff       	call   801410 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 1f                	push   $0x1f
  801764:	e8 a7 fc ff ff       	call   801410 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	ff 75 14             	pushl  0x14(%ebp)
  801779:	ff 75 10             	pushl  0x10(%ebp)
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	6a 20                	push   $0x20
  801782:	e8 89 fc ff ff       	call   801410 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	50                   	push   %eax
  80179b:	6a 21                	push   $0x21
  80179d:	e8 6e fc ff ff       	call   801410 <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	90                   	nop
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	50                   	push   %eax
  8017b7:	6a 22                	push   $0x22
  8017b9:	e8 52 fc ff ff       	call   801410 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 02                	push   $0x2
  8017d2:	e8 39 fc ff ff       	call   801410 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 03                	push   $0x3
  8017eb:	e8 20 fc ff ff       	call   801410 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 04                	push   $0x4
  801804:	e8 07 fc ff ff       	call   801410 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_exit_env>:


void sys_exit_env(void)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 23                	push   $0x23
  80181d:	e8 ee fb ff ff       	call   801410 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80182e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801831:	8d 50 04             	lea    0x4(%eax),%edx
  801834:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 24                	push   $0x24
  801841:	e8 ca fb ff ff       	call   801410 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
	return result;
  801849:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80184c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	89 01                	mov    %eax,(%ecx)
  801854:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	c9                   	leave  
  80185b:	c2 04 00             	ret    $0x4

0080185e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	ff 75 10             	pushl  0x10(%ebp)
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 12                	push   $0x12
  801870:	e8 9b fb ff ff       	call   801410 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return ;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_rcr2>:
uint32 sys_rcr2()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 25                	push   $0x25
  80188a:	e8 81 fb ff ff       	call   801410 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	50                   	push   %eax
  8018ad:	6a 26                	push   $0x26
  8018af:	e8 5c fb ff ff       	call   801410 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b7:	90                   	nop
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <rsttst>:
void rsttst()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 28                	push   $0x28
  8018c9:	e8 42 fb ff ff       	call   801410 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d1:	90                   	nop
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	8b 45 14             	mov    0x14(%ebp),%eax
  8018dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8018e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	ff 75 10             	pushl  0x10(%ebp)
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	ff 75 08             	pushl  0x8(%ebp)
  8018f2:	6a 27                	push   $0x27
  8018f4:	e8 17 fb ff ff       	call   801410 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fc:	90                   	nop
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <chktst>:
void chktst(uint32 n)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	6a 29                	push   $0x29
  80190f:	e8 fc fa ff ff       	call   801410 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return ;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <inctst>:

void inctst()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 2a                	push   $0x2a
  801929:	e8 e2 fa ff ff       	call   801410 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return ;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <gettst>:
uint32 gettst()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 2b                	push   $0x2b
  801943:	e8 c8 fa ff ff       	call   801410 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 2c                	push   $0x2c
  80195f:	e8 ac fa ff ff       	call   801410 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
  801967:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80196a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80196e:	75 07                	jne    801977 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801970:	b8 01 00 00 00       	mov    $0x1,%eax
  801975:	eb 05                	jmp    80197c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 2c                	push   $0x2c
  801990:	e8 7b fa ff ff       	call   801410 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
  801998:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80199b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80199f:	75 07                	jne    8019a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	eb 05                	jmp    8019ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 2c                	push   $0x2c
  8019c1:	e8 4a fa ff ff       	call   801410 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
  8019c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019d0:	75 07                	jne    8019d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d7:	eb 05                	jmp    8019de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 2c                	push   $0x2c
  8019f2:	e8 19 fa ff ff       	call   801410 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
  8019fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a01:	75 07                	jne    801a0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a03:	b8 01 00 00 00       	mov    $0x1,%eax
  801a08:	eb 05                	jmp    801a0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 2d                	push   $0x2d
  801a21:	e8 ea f9 ff ff       	call   801410 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	53                   	push   %ebx
  801a3f:	51                   	push   %ecx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 2e                	push   $0x2e
  801a44:	e8 c7 f9 ff ff       	call   801410 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 2f                	push   $0x2f
  801a64:	e8 a7 f9 ff ff       	call   801410 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    
  801a6e:	66 90                	xchg   %ax,%ax

00801a70 <__udivdi3>:
  801a70:	55                   	push   %ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a87:	89 ca                	mov    %ecx,%edx
  801a89:	89 f8                	mov    %edi,%eax
  801a8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a8f:	85 f6                	test   %esi,%esi
  801a91:	75 2d                	jne    801ac0 <__udivdi3+0x50>
  801a93:	39 cf                	cmp    %ecx,%edi
  801a95:	77 65                	ja     801afc <__udivdi3+0x8c>
  801a97:	89 fd                	mov    %edi,%ebp
  801a99:	85 ff                	test   %edi,%edi
  801a9b:	75 0b                	jne    801aa8 <__udivdi3+0x38>
  801a9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa2:	31 d2                	xor    %edx,%edx
  801aa4:	f7 f7                	div    %edi
  801aa6:	89 c5                	mov    %eax,%ebp
  801aa8:	31 d2                	xor    %edx,%edx
  801aaa:	89 c8                	mov    %ecx,%eax
  801aac:	f7 f5                	div    %ebp
  801aae:	89 c1                	mov    %eax,%ecx
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	f7 f5                	div    %ebp
  801ab4:	89 cf                	mov    %ecx,%edi
  801ab6:	89 fa                	mov    %edi,%edx
  801ab8:	83 c4 1c             	add    $0x1c,%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5f                   	pop    %edi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
  801ac0:	39 ce                	cmp    %ecx,%esi
  801ac2:	77 28                	ja     801aec <__udivdi3+0x7c>
  801ac4:	0f bd fe             	bsr    %esi,%edi
  801ac7:	83 f7 1f             	xor    $0x1f,%edi
  801aca:	75 40                	jne    801b0c <__udivdi3+0x9c>
  801acc:	39 ce                	cmp    %ecx,%esi
  801ace:	72 0a                	jb     801ada <__udivdi3+0x6a>
  801ad0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ad4:	0f 87 9e 00 00 00    	ja     801b78 <__udivdi3+0x108>
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
  801adf:	89 fa                	mov    %edi,%edx
  801ae1:	83 c4 1c             	add    $0x1c,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    
  801ae9:	8d 76 00             	lea    0x0(%esi),%esi
  801aec:	31 ff                	xor    %edi,%edi
  801aee:	31 c0                	xor    %eax,%eax
  801af0:	89 fa                	mov    %edi,%edx
  801af2:	83 c4 1c             	add    $0x1c,%esp
  801af5:	5b                   	pop    %ebx
  801af6:	5e                   	pop    %esi
  801af7:	5f                   	pop    %edi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	f7 f7                	div    %edi
  801b00:	31 ff                	xor    %edi,%edi
  801b02:	89 fa                	mov    %edi,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b11:	89 eb                	mov    %ebp,%ebx
  801b13:	29 fb                	sub    %edi,%ebx
  801b15:	89 f9                	mov    %edi,%ecx
  801b17:	d3 e6                	shl    %cl,%esi
  801b19:	89 c5                	mov    %eax,%ebp
  801b1b:	88 d9                	mov    %bl,%cl
  801b1d:	d3 ed                	shr    %cl,%ebp
  801b1f:	89 e9                	mov    %ebp,%ecx
  801b21:	09 f1                	or     %esi,%ecx
  801b23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b27:	89 f9                	mov    %edi,%ecx
  801b29:	d3 e0                	shl    %cl,%eax
  801b2b:	89 c5                	mov    %eax,%ebp
  801b2d:	89 d6                	mov    %edx,%esi
  801b2f:	88 d9                	mov    %bl,%cl
  801b31:	d3 ee                	shr    %cl,%esi
  801b33:	89 f9                	mov    %edi,%ecx
  801b35:	d3 e2                	shl    %cl,%edx
  801b37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b3b:	88 d9                	mov    %bl,%cl
  801b3d:	d3 e8                	shr    %cl,%eax
  801b3f:	09 c2                	or     %eax,%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	89 f2                	mov    %esi,%edx
  801b45:	f7 74 24 0c          	divl   0xc(%esp)
  801b49:	89 d6                	mov    %edx,%esi
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	f7 e5                	mul    %ebp
  801b4f:	39 d6                	cmp    %edx,%esi
  801b51:	72 19                	jb     801b6c <__udivdi3+0xfc>
  801b53:	74 0b                	je     801b60 <__udivdi3+0xf0>
  801b55:	89 d8                	mov    %ebx,%eax
  801b57:	31 ff                	xor    %edi,%edi
  801b59:	e9 58 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b5e:	66 90                	xchg   %ax,%ax
  801b60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b64:	89 f9                	mov    %edi,%ecx
  801b66:	d3 e2                	shl    %cl,%edx
  801b68:	39 c2                	cmp    %eax,%edx
  801b6a:	73 e9                	jae    801b55 <__udivdi3+0xe5>
  801b6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b6f:	31 ff                	xor    %edi,%edi
  801b71:	e9 40 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	31 c0                	xor    %eax,%eax
  801b7a:	e9 37 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b7f:	90                   	nop

00801b80 <__umoddi3>:
  801b80:	55                   	push   %ebp
  801b81:	57                   	push   %edi
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	83 ec 1c             	sub    $0x1c,%esp
  801b87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b9f:	89 f3                	mov    %esi,%ebx
  801ba1:	89 fa                	mov    %edi,%edx
  801ba3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba7:	89 34 24             	mov    %esi,(%esp)
  801baa:	85 c0                	test   %eax,%eax
  801bac:	75 1a                	jne    801bc8 <__umoddi3+0x48>
  801bae:	39 f7                	cmp    %esi,%edi
  801bb0:	0f 86 a2 00 00 00    	jbe    801c58 <__umoddi3+0xd8>
  801bb6:	89 c8                	mov    %ecx,%eax
  801bb8:	89 f2                	mov    %esi,%edx
  801bba:	f7 f7                	div    %edi
  801bbc:	89 d0                	mov    %edx,%eax
  801bbe:	31 d2                	xor    %edx,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	39 f0                	cmp    %esi,%eax
  801bca:	0f 87 ac 00 00 00    	ja     801c7c <__umoddi3+0xfc>
  801bd0:	0f bd e8             	bsr    %eax,%ebp
  801bd3:	83 f5 1f             	xor    $0x1f,%ebp
  801bd6:	0f 84 ac 00 00 00    	je     801c88 <__umoddi3+0x108>
  801bdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801be1:	29 ef                	sub    %ebp,%edi
  801be3:	89 fe                	mov    %edi,%esi
  801be5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 e0                	shl    %cl,%eax
  801bed:	89 d7                	mov    %edx,%edi
  801bef:	89 f1                	mov    %esi,%ecx
  801bf1:	d3 ef                	shr    %cl,%edi
  801bf3:	09 c7                	or     %eax,%edi
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 e2                	shl    %cl,%edx
  801bf9:	89 14 24             	mov    %edx,(%esp)
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	d3 e0                	shl    %cl,%eax
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c06:	d3 e0                	shl    %cl,%eax
  801c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c10:	89 f1                	mov    %esi,%ecx
  801c12:	d3 e8                	shr    %cl,%eax
  801c14:	09 d0                	or     %edx,%eax
  801c16:	d3 eb                	shr    %cl,%ebx
  801c18:	89 da                	mov    %ebx,%edx
  801c1a:	f7 f7                	div    %edi
  801c1c:	89 d3                	mov    %edx,%ebx
  801c1e:	f7 24 24             	mull   (%esp)
  801c21:	89 c6                	mov    %eax,%esi
  801c23:	89 d1                	mov    %edx,%ecx
  801c25:	39 d3                	cmp    %edx,%ebx
  801c27:	0f 82 87 00 00 00    	jb     801cb4 <__umoddi3+0x134>
  801c2d:	0f 84 91 00 00 00    	je     801cc4 <__umoddi3+0x144>
  801c33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c37:	29 f2                	sub    %esi,%edx
  801c39:	19 cb                	sbb    %ecx,%ebx
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 e9                	mov    %ebp,%ecx
  801c45:	d3 ea                	shr    %cl,%edx
  801c47:	09 d0                	or     %edx,%eax
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 eb                	shr    %cl,%ebx
  801c4d:	89 da                	mov    %ebx,%edx
  801c4f:	83 c4 1c             	add    $0x1c,%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5f                   	pop    %edi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    
  801c57:	90                   	nop
  801c58:	89 fd                	mov    %edi,%ebp
  801c5a:	85 ff                	test   %edi,%edi
  801c5c:	75 0b                	jne    801c69 <__umoddi3+0xe9>
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	31 d2                	xor    %edx,%edx
  801c65:	f7 f7                	div    %edi
  801c67:	89 c5                	mov    %eax,%ebp
  801c69:	89 f0                	mov    %esi,%eax
  801c6b:	31 d2                	xor    %edx,%edx
  801c6d:	f7 f5                	div    %ebp
  801c6f:	89 c8                	mov    %ecx,%eax
  801c71:	f7 f5                	div    %ebp
  801c73:	89 d0                	mov    %edx,%eax
  801c75:	e9 44 ff ff ff       	jmp    801bbe <__umoddi3+0x3e>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	89 c8                	mov    %ecx,%eax
  801c7e:	89 f2                	mov    %esi,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	3b 04 24             	cmp    (%esp),%eax
  801c8b:	72 06                	jb     801c93 <__umoddi3+0x113>
  801c8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c91:	77 0f                	ja     801ca2 <__umoddi3+0x122>
  801c93:	89 f2                	mov    %esi,%edx
  801c95:	29 f9                	sub    %edi,%ecx
  801c97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c9b:	89 14 24             	mov    %edx,(%esp)
  801c9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ca6:	8b 14 24             	mov    (%esp),%edx
  801ca9:	83 c4 1c             	add    $0x1c,%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    
  801cb1:	8d 76 00             	lea    0x0(%esi),%esi
  801cb4:	2b 04 24             	sub    (%esp),%eax
  801cb7:	19 fa                	sbb    %edi,%edx
  801cb9:	89 d1                	mov    %edx,%ecx
  801cbb:	89 c6                	mov    %eax,%esi
  801cbd:	e9 71 ff ff ff       	jmp    801c33 <__umoddi3+0xb3>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cc8:	72 ea                	jb     801cb4 <__umoddi3+0x134>
  801cca:	89 d9                	mov    %ebx,%ecx
  801ccc:	e9 62 ff ff ff       	jmp    801c33 <__umoddi3+0xb3>
