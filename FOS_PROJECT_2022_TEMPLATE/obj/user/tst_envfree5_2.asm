
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 1d 80 00       	push   $0x801de0
  80004a:	e8 34 13 00 00       	call   801383 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 d4 14 00 00       	call   801537 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 6c 15 00 00       	call   8015d7 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 1d 80 00       	push   $0x801df0
  800079:	e8 06 05 00 00       	call   800584 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 23 1e 80 00       	push   $0x801e23
  80008f:	e8 15 17 00 00       	call   8017a9 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 2c 1e 80 00       	push   $0x801e2c
  8000a8:	e8 fc 16 00 00       	call   8017a9 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 09 17 00 00       	call   8017c7 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 db 19 00 00       	call   801aa9 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 eb 16 00 00       	call   8017c7 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 48 14 00 00       	call   801537 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 38 1e 80 00       	push   $0x801e38
  8000f8:	e8 87 04 00 00       	call   800584 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 d8 16 00 00       	call   8017e3 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 ca 16 00 00       	call   8017e3 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 16 14 00 00       	call   801537 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 ae 14 00 00       	call   8015d7 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 6c 1e 80 00       	push   $0x801e6c
  80013f:	e8 40 04 00 00       	call   800584 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 bc 1e 80 00       	push   $0x801ebc
  80014f:	6a 23                	push   $0x23
  800151:	68 f2 1e 80 00       	push   $0x801ef2
  800156:	e8 75 01 00 00       	call   8002d0 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 08 1f 80 00       	push   $0x801f08
  800166:	e8 19 04 00 00       	call   800584 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 68 1f 80 00       	push   $0x801f68
  800176:	e8 09 04 00 00       	call   800584 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 8b 16 00 00       	call   801817 <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80019f:	01 c8                	add    %ecx,%eax
  8001a1:	c1 e0 02             	shl    $0x2,%eax
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001ad:	01 c8                	add    %ecx,%eax
  8001af:	c1 e0 02             	shl    $0x2,%eax
  8001b2:	01 d0                	add    %edx,%eax
  8001b4:	c1 e0 02             	shl    $0x2,%eax
  8001b7:	01 d0                	add    %edx,%eax
  8001b9:	c1 e0 03             	shl    $0x3,%eax
  8001bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cb:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8001d1:	84 c0                	test   %al,%al
  8001d3:	74 0f                	je     8001e4 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8001d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001da:	05 18 da 01 00       	add    $0x1da18,%eax
  8001df:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e8:	7e 0a                	jle    8001f4 <libmain+0x73>
		binaryname = argv[0];
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001f4:	83 ec 08             	sub    $0x8,%esp
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 36 fe ff ff       	call   800038 <_main>
  800202:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800205:	e8 1a 14 00 00       	call   801624 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 cc 1f 80 00       	push   $0x801fcc
  800212:	e8 6d 03 00 00       	call   800584 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021a:	a1 20 30 80 00       	mov    0x803020,%eax
  80021f:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800225:	a1 20 30 80 00       	mov    0x803020,%eax
  80022a:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	52                   	push   %edx
  800234:	50                   	push   %eax
  800235:	68 f4 1f 80 00       	push   $0x801ff4
  80023a:	e8 45 03 00 00       	call   800584 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800242:	a1 20 30 80 00       	mov    0x803020,%eax
  800247:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80024d:	a1 20 30 80 00       	mov    0x803020,%eax
  800252:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800263:	51                   	push   %ecx
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 1c 20 80 00       	push   $0x80201c
  80026b:	e8 14 03 00 00       	call   800584 <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800273:	a1 20 30 80 00       	mov    0x803020,%eax
  800278:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	50                   	push   %eax
  800282:	68 74 20 80 00       	push   $0x802074
  800287:	e8 f8 02 00 00       	call   800584 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	68 cc 1f 80 00       	push   $0x801fcc
  800297:	e8 e8 02 00 00       	call   800584 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029f:	e8 9a 13 00 00       	call   80163e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a4:	e8 19 00 00 00       	call   8002c2 <exit>
}
  8002a9:	90                   	nop
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	6a 00                	push   $0x0
  8002b7:	e8 27 15 00 00       	call   8017e3 <sys_destroy_env>
  8002bc:	83 c4 10             	add    $0x10,%esp
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <exit>:

void
exit(void)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c8:	e8 7c 15 00 00       	call   801849 <sys_exit_env>
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d9:	83 c0 04             	add    $0x4,%eax
  8002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002df:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	74 16                	je     8002fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e8:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	50                   	push   %eax
  8002f1:	68 88 20 80 00       	push   $0x802088
  8002f6:	e8 89 02 00 00       	call   800584 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	50                   	push   %eax
  80030a:	68 8d 20 80 00       	push   $0x80208d
  80030f:	e8 70 02 00 00       	call   800584 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800317:	8b 45 10             	mov    0x10(%ebp),%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 f4             	pushl  -0xc(%ebp)
  800320:	50                   	push   %eax
  800321:	e8 f3 01 00 00       	call   800519 <vcprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	6a 00                	push   $0x0
  80032e:	68 a9 20 80 00       	push   $0x8020a9
  800333:	e8 e1 01 00 00       	call   800519 <vcprintf>
  800338:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033b:	e8 82 ff ff ff       	call   8002c2 <exit>

	// should not return here
	while (1) ;
  800340:	eb fe                	jmp    800340 <_panic+0x70>

00800342 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800348:	a1 20 30 80 00       	mov    0x803020,%eax
  80034d:	8b 50 74             	mov    0x74(%eax),%edx
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	74 14                	je     80036b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	68 ac 20 80 00       	push   $0x8020ac
  80035f:	6a 26                	push   $0x26
  800361:	68 f8 20 80 00       	push   $0x8020f8
  800366:	e8 65 ff ff ff       	call   8002d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800372:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800379:	e9 c2 00 00 00       	jmp    800440 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	85 c0                	test   %eax,%eax
  800391:	75 08                	jne    80039b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800393:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800396:	e9 a2 00 00 00       	jmp    80043d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a9:	eb 69                	jmp    800414 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b0:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b9:	89 d0                	mov    %edx,%eax
  8003bb:	01 c0                	add    %eax,%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 03             	shl    $0x3,%eax
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	8a 40 04             	mov    0x4(%eax),%al
  8003c7:	84 c0                	test   %al,%al
  8003c9:	75 46                	jne    800411 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d9:	89 d0                	mov    %edx,%eax
  8003db:	01 c0                	add    %eax,%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	c1 e0 03             	shl    $0x3,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800404:	39 c2                	cmp    %eax,%edx
  800406:	75 09                	jne    800411 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800408:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040f:	eb 12                	jmp    800423 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800411:	ff 45 e8             	incl   -0x18(%ebp)
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8b 50 74             	mov    0x74(%eax),%edx
  80041c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041f:	39 c2                	cmp    %eax,%edx
  800421:	77 88                	ja     8003ab <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800423:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800427:	75 14                	jne    80043d <CheckWSWithoutLastIndex+0xfb>
			panic(
  800429:	83 ec 04             	sub    $0x4,%esp
  80042c:	68 04 21 80 00       	push   $0x802104
  800431:	6a 3a                	push   $0x3a
  800433:	68 f8 20 80 00       	push   $0x8020f8
  800438:	e8 93 fe ff ff       	call   8002d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043d:	ff 45 f0             	incl   -0x10(%ebp)
  800440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800443:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800446:	0f 8c 32 ff ff ff    	jl     80037e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800453:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045a:	eb 26                	jmp    800482 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045c:	a1 20 30 80 00       	mov    0x803020,%eax
  800461:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800467:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046a:	89 d0                	mov    %edx,%eax
  80046c:	01 c0                	add    %eax,%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	c1 e0 03             	shl    $0x3,%eax
  800473:	01 c8                	add    %ecx,%eax
  800475:	8a 40 04             	mov    0x4(%eax),%al
  800478:	3c 01                	cmp    $0x1,%al
  80047a:	75 03                	jne    80047f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047f:	ff 45 e0             	incl   -0x20(%ebp)
  800482:	a1 20 30 80 00       	mov    0x803020,%eax
  800487:	8b 50 74             	mov    0x74(%eax),%edx
  80048a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048d:	39 c2                	cmp    %eax,%edx
  80048f:	77 cb                	ja     80045c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800494:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800497:	74 14                	je     8004ad <CheckWSWithoutLastIndex+0x16b>
		panic(
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 58 21 80 00       	push   $0x802158
  8004a1:	6a 44                	push   $0x44
  8004a3:	68 f8 20 80 00       	push   $0x8020f8
  8004a8:	e8 23 fe ff ff       	call   8002d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8004be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c1:	89 0a                	mov    %ecx,(%edx)
  8004c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c6:	88 d1                	mov    %dl,%cl
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d9:	75 2c                	jne    800507 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004db:	a0 24 30 80 00       	mov    0x803024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e6:	8b 12                	mov    (%edx),%edx
  8004e8:	89 d1                	mov    %edx,%ecx
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	83 c2 08             	add    $0x8,%edx
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	50                   	push   %eax
  8004f4:	51                   	push   %ecx
  8004f5:	52                   	push   %edx
  8004f6:	e8 7b 0f 00 00       	call   801476 <sys_cputs>
  8004fb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	8b 40 04             	mov    0x4(%eax),%eax
  80050d:	8d 50 01             	lea    0x1(%eax),%edx
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	89 50 04             	mov    %edx,0x4(%eax)
}
  800516:	90                   	nop
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800522:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800529:	00 00 00 
	b.cnt = 0;
  80052c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800533:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800536:	ff 75 0c             	pushl  0xc(%ebp)
  800539:	ff 75 08             	pushl  0x8(%ebp)
  80053c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800542:	50                   	push   %eax
  800543:	68 b0 04 80 00       	push   $0x8004b0
  800548:	e8 11 02 00 00       	call   80075e <vprintfmt>
  80054d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800550:	a0 24 30 80 00       	mov    0x803024,%al
  800555:	0f b6 c0             	movzbl %al,%eax
  800558:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055e:	83 ec 04             	sub    $0x4,%esp
  800561:	50                   	push   %eax
  800562:	52                   	push   %edx
  800563:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800569:	83 c0 08             	add    $0x8,%eax
  80056c:	50                   	push   %eax
  80056d:	e8 04 0f 00 00       	call   801476 <sys_cputs>
  800572:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800575:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80057c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800582:	c9                   	leave  
  800583:	c3                   	ret    

00800584 <cprintf>:

int cprintf(const char *fmt, ...) {
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
  800587:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800591:	8d 45 0c             	lea    0xc(%ebp),%eax
  800594:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a0:	50                   	push   %eax
  8005a1:	e8 73 ff ff ff       	call   800519 <vcprintf>
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b7:	e8 68 10 00 00       	call   801624 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	e8 48 ff ff ff       	call   800519 <vcprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d7:	e8 62 10 00 00       	call   80163e <sys_enable_interrupt>
	return cnt;
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 14             	sub    $0x14,%esp
  8005e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ff:	77 55                	ja     800656 <printnum+0x75>
  800601:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800604:	72 05                	jb     80060b <printnum+0x2a>
  800606:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800609:	77 4b                	ja     800656 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800611:	8b 45 18             	mov    0x18(%ebp),%eax
  800614:	ba 00 00 00 00       	mov    $0x0,%edx
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 f4             	pushl  -0xc(%ebp)
  80061e:	ff 75 f0             	pushl  -0x10(%ebp)
  800621:	e8 3a 15 00 00       	call   801b60 <__udivdi3>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	ff 75 20             	pushl  0x20(%ebp)
  80062f:	53                   	push   %ebx
  800630:	ff 75 18             	pushl  0x18(%ebp)
  800633:	52                   	push   %edx
  800634:	50                   	push   %eax
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	e8 a1 ff ff ff       	call   8005e1 <printnum>
  800640:	83 c4 20             	add    $0x20,%esp
  800643:	eb 1a                	jmp    80065f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	ff 75 20             	pushl  0x20(%ebp)
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	ff d0                	call   *%eax
  800653:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800656:	ff 4d 1c             	decl   0x1c(%ebp)
  800659:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065d:	7f e6                	jg     800645 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800662:	bb 00 00 00 00       	mov    $0x0,%ebx
  800667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066d:	53                   	push   %ebx
  80066e:	51                   	push   %ecx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	e8 fa 15 00 00       	call   801c70 <__umoddi3>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	05 d4 23 80 00       	add    $0x8023d4,%eax
  80067e:	8a 00                	mov    (%eax),%al
  800680:	0f be c0             	movsbl %al,%eax
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	50                   	push   %eax
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	ff d0                	call   *%eax
  80068f:	83 c4 10             	add    $0x10,%esp
}
  800692:	90                   	nop
  800693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069f:	7e 1c                	jle    8006bd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 08             	lea    0x8(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 08             	sub    $0x8,%eax
  8006b6:	8b 50 04             	mov    0x4(%eax),%edx
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	eb 40                	jmp    8006fd <getuint+0x65>
	else if (lflag)
  8006bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c1:	74 1e                	je     8006e1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
  8006df:	eb 1c                	jmp    8006fd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	8d 50 04             	lea    0x4(%eax),%edx
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 10                	mov    %edx,(%eax)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	83 e8 04             	sub    $0x4,%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800702:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800706:	7e 1c                	jle    800724 <getint+0x25>
		return va_arg(*ap, long long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 08             	lea    0x8(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 08             	sub    $0x8,%eax
  80071d:	8b 50 04             	mov    0x4(%eax),%edx
  800720:	8b 00                	mov    (%eax),%eax
  800722:	eb 38                	jmp    80075c <getint+0x5d>
	else if (lflag)
  800724:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800728:	74 1a                	je     800744 <getint+0x45>
		return va_arg(*ap, long);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
  800742:	eb 18                	jmp    80075c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	99                   	cltd   
}
  80075c:	5d                   	pop    %ebp
  80075d:	c3                   	ret    

0080075e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	56                   	push   %esi
  800762:	53                   	push   %ebx
  800763:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800766:	eb 17                	jmp    80077f <vprintfmt+0x21>
			if (ch == '\0')
  800768:	85 db                	test   %ebx,%ebx
  80076a:	0f 84 af 03 00 00    	je     800b1f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 0c             	pushl  0xc(%ebp)
  800776:	53                   	push   %ebx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	ff d0                	call   *%eax
  80077c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	8b 45 10             	mov    0x10(%ebp),%eax
  800782:	8d 50 01             	lea    0x1(%eax),%edx
  800785:	89 55 10             	mov    %edx,0x10(%ebp)
  800788:	8a 00                	mov    (%eax),%al
  80078a:	0f b6 d8             	movzbl %al,%ebx
  80078d:	83 fb 25             	cmp    $0x25,%ebx
  800790:	75 d6                	jne    800768 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800792:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800796:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	8d 50 01             	lea    0x1(%eax),%edx
  8007b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bb:	8a 00                	mov    (%eax),%al
  8007bd:	0f b6 d8             	movzbl %al,%ebx
  8007c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c3:	83 f8 55             	cmp    $0x55,%eax
  8007c6:	0f 87 2b 03 00 00    	ja     800af7 <vprintfmt+0x399>
  8007cc:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8007d3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d9:	eb d7                	jmp    8007b2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007df:	eb d1                	jmp    8007b2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007eb:	89 d0                	mov    %edx,%eax
  8007ed:	c1 e0 02             	shl    $0x2,%eax
  8007f0:	01 d0                	add    %edx,%eax
  8007f2:	01 c0                	add    %eax,%eax
  8007f4:	01 d8                	add    %ebx,%eax
  8007f6:	83 e8 30             	sub    $0x30,%eax
  8007f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ff:	8a 00                	mov    (%eax),%al
  800801:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800804:	83 fb 2f             	cmp    $0x2f,%ebx
  800807:	7e 3e                	jle    800847 <vprintfmt+0xe9>
  800809:	83 fb 39             	cmp    $0x39,%ebx
  80080c:	7f 39                	jg     800847 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800811:	eb d5                	jmp    8007e8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800827:	eb 1f                	jmp    800848 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800829:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082d:	79 83                	jns    8007b2 <vprintfmt+0x54>
				width = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800836:	e9 77 ff ff ff       	jmp    8007b2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800842:	e9 6b ff ff ff       	jmp    8007b2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800847:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084c:	0f 89 60 ff ff ff    	jns    8007b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800858:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085f:	e9 4e ff ff ff       	jmp    8007b2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800864:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800867:	e9 46 ff ff ff       	jmp    8007b2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 e8 04             	sub    $0x4,%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	50                   	push   %eax
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 89 02 00 00       	jmp    800b1a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a2:	85 db                	test   %ebx,%ebx
  8008a4:	79 02                	jns    8008a8 <vprintfmt+0x14a>
				err = -err;
  8008a6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a8:	83 fb 64             	cmp    $0x64,%ebx
  8008ab:	7f 0b                	jg     8008b8 <vprintfmt+0x15a>
  8008ad:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8008b4:	85 f6                	test   %esi,%esi
  8008b6:	75 19                	jne    8008d1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b8:	53                   	push   %ebx
  8008b9:	68 e5 23 80 00       	push   $0x8023e5
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 5e 02 00 00       	call   800b27 <printfmt>
  8008c9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cc:	e9 49 02 00 00       	jmp    800b1a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d1:	56                   	push   %esi
  8008d2:	68 ee 23 80 00       	push   $0x8023ee
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 45 02 00 00       	call   800b27 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			break;
  8008e5:	e9 30 02 00 00       	jmp    800b1a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	83 c0 04             	add    $0x4,%eax
  8008f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 30                	mov    (%eax),%esi
  8008fb:	85 f6                	test   %esi,%esi
  8008fd:	75 05                	jne    800904 <vprintfmt+0x1a6>
				p = "(null)";
  8008ff:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800904:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800908:	7e 6d                	jle    800977 <vprintfmt+0x219>
  80090a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090e:	74 67                	je     800977 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	50                   	push   %eax
  800917:	56                   	push   %esi
  800918:	e8 0c 03 00 00       	call   800c29 <strnlen>
  80091d:	83 c4 10             	add    $0x10,%esp
  800920:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800923:	eb 16                	jmp    80093b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800925:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	50                   	push   %eax
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800938:	ff 4d e4             	decl   -0x1c(%ebp)
  80093b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093f:	7f e4                	jg     800925 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800941:	eb 34                	jmp    800977 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800943:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800947:	74 1c                	je     800965 <vprintfmt+0x207>
  800949:	83 fb 1f             	cmp    $0x1f,%ebx
  80094c:	7e 05                	jle    800953 <vprintfmt+0x1f5>
  80094e:	83 fb 7e             	cmp    $0x7e,%ebx
  800951:	7e 12                	jle    800965 <vprintfmt+0x207>
					putch('?', putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	6a 3f                	push   $0x3f
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	eb 0f                	jmp    800974 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	53                   	push   %ebx
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800974:	ff 4d e4             	decl   -0x1c(%ebp)
  800977:	89 f0                	mov    %esi,%eax
  800979:	8d 70 01             	lea    0x1(%eax),%esi
  80097c:	8a 00                	mov    (%eax),%al
  80097e:	0f be d8             	movsbl %al,%ebx
  800981:	85 db                	test   %ebx,%ebx
  800983:	74 24                	je     8009a9 <vprintfmt+0x24b>
  800985:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800989:	78 b8                	js     800943 <vprintfmt+0x1e5>
  80098b:	ff 4d e0             	decl   -0x20(%ebp)
  80098e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800992:	79 af                	jns    800943 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800994:	eb 13                	jmp    8009a9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 20                	push   $0x20
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ad:	7f e7                	jg     800996 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009af:	e9 66 01 00 00       	jmp    800b1a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 3c fd ff ff       	call   8006ff <getint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	85 d2                	test   %edx,%edx
  8009d4:	79 23                	jns    8009f9 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 2d                	push   $0x2d
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ec:	f7 d8                	neg    %eax
  8009ee:	83 d2 00             	adc    $0x0,%edx
  8009f1:	f7 da                	neg    %edx
  8009f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0e:	50                   	push   %eax
  800a0f:	e8 84 fc ff ff       	call   800698 <getuint>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a24:	e9 98 00 00 00       	jmp    800ac1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	6a 58                	push   $0x58
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 58                	push   $0x58
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	6a 58                	push   $0x58
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
			break;
  800a59:	e9 bc 00 00 00       	jmp    800b1a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	6a 30                	push   $0x30
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 78                	push   $0x78
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	83 c0 04             	add    $0x4,%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	83 e8 04             	sub    $0x4,%eax
  800a8d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa0:	eb 1f                	jmp    800ac1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa8:	8d 45 14             	lea    0x14(%ebp),%eax
  800aab:	50                   	push   %eax
  800aac:	e8 e7 fb ff ff       	call   800698 <getuint>
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac8:	83 ec 04             	sub    $0x4,%esp
  800acb:	52                   	push   %edx
  800acc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acf:	50                   	push   %eax
  800ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 00 fb ff ff       	call   8005e1 <printnum>
  800ae1:	83 c4 20             	add    $0x20,%esp
			break;
  800ae4:	eb 34                	jmp    800b1a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	53                   	push   %ebx
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			break;
  800af5:	eb 23                	jmp    800b1a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 25                	push   $0x25
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b07:	ff 4d 10             	decl   0x10(%ebp)
  800b0a:	eb 03                	jmp    800b0f <vprintfmt+0x3b1>
  800b0c:	ff 4d 10             	decl   0x10(%ebp)
  800b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b12:	48                   	dec    %eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	3c 25                	cmp    $0x25,%al
  800b17:	75 f3                	jne    800b0c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b19:	90                   	nop
		}
	}
  800b1a:	e9 47 fc ff ff       	jmp    800766 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b30:	83 c0 04             	add    $0x4,%eax
  800b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b36:	8b 45 10             	mov    0x10(%ebp),%eax
  800b39:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3c:	50                   	push   %eax
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	e8 16 fc ff ff       	call   80075e <vprintfmt>
  800b48:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4b:	90                   	nop
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 08             	mov    0x8(%eax),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	8b 10                	mov    (%eax),%edx
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 40 04             	mov    0x4(%eax),%eax
  800b6b:	39 c2                	cmp    %eax,%edx
  800b6d:	73 12                	jae    800b81 <sprintputch+0x33>
		*b->buf++ = ch;
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	8d 48 01             	lea    0x1(%eax),%ecx
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	89 0a                	mov    %ecx,(%edx)
  800b7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7f:	88 10                	mov    %dl,(%eax)
}
  800b81:	90                   	nop
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	01 d0                	add    %edx,%eax
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba9:	74 06                	je     800bb1 <vsnprintf+0x2d>
  800bab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800baf:	7f 07                	jg     800bb8 <vsnprintf+0x34>
		return -E_INVAL;
  800bb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb6:	eb 20                	jmp    800bd8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb8:	ff 75 14             	pushl  0x14(%ebp)
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	68 4e 0b 80 00       	push   $0x800b4e
  800bc7:	e8 92 fb ff ff       	call   80075e <vprintfmt>
  800bcc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be0:	8d 45 10             	lea    0x10(%ebp),%eax
  800be3:	83 c0 04             	add    $0x4,%eax
  800be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	50                   	push   %eax
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	e8 89 ff ff ff       	call   800b84 <vsnprintf>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c13:	eb 06                	jmp    800c1b <strlen+0x15>
		n++;
  800c15:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c18:	ff 45 08             	incl   0x8(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	84 c0                	test   %al,%al
  800c22:	75 f1                	jne    800c15 <strlen+0xf>
		n++;
	return n;
  800c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c36:	eb 09                	jmp    800c41 <strnlen+0x18>
		n++;
  800c38:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3b:	ff 45 08             	incl   0x8(%ebp)
  800c3e:	ff 4d 0c             	decl   0xc(%ebp)
  800c41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c45:	74 09                	je     800c50 <strnlen+0x27>
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	75 e8                	jne    800c38 <strnlen+0xf>
		n++;
	return n;
  800c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c61:	90                   	nop
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c74:	8a 12                	mov    (%edx),%dl
  800c76:	88 10                	mov    %dl,(%eax)
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	75 e4                	jne    800c62 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c96:	eb 1f                	jmp    800cb7 <strncpy+0x34>
		*dst++ = *src;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8a 12                	mov    (%edx),%dl
  800ca6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 03                	je     800cb4 <strncpy+0x31>
			src++;
  800cb1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb4:	ff 45 fc             	incl   -0x4(%ebp)
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cba:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbd:	72 d9                	jb     800c98 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd4:	74 30                	je     800d06 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd6:	eb 16                	jmp    800cee <strlcpy+0x2a>
			*dst++ = *src++;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8d 50 01             	lea    0x1(%eax),%edx
  800cde:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cea:	8a 12                	mov    (%edx),%dl
  800cec:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cee:	ff 4d 10             	decl   0x10(%ebp)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	74 09                	je     800d00 <strlcpy+0x3c>
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	84 c0                	test   %al,%al
  800cfe:	75 d8                	jne    800cd8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0c:	29 c2                	sub    %eax,%edx
  800d0e:	89 d0                	mov    %edx,%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d15:	eb 06                	jmp    800d1d <strcmp+0xb>
		p++, q++;
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 0e                	je     800d34 <strcmp+0x22>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 10                	mov    (%eax),%dl
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	38 c2                	cmp    %al,%dl
  800d32:	74 e3                	je     800d17 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4d:	eb 09                	jmp    800d58 <strncmp+0xe>
		n--, p++, q++;
  800d4f:	ff 4d 10             	decl   0x10(%ebp)
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5c:	74 17                	je     800d75 <strncmp+0x2b>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	74 0e                	je     800d75 <strncmp+0x2b>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 10                	mov    (%eax),%dl
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	38 c2                	cmp    %al,%dl
  800d73:	74 da                	je     800d4f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d79:	75 07                	jne    800d82 <strncmp+0x38>
		return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	eb 14                	jmp    800d96 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 d0             	movzbl %al,%edx
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 c0             	movzbl %al,%eax
  800d92:	29 c2                	sub    %eax,%edx
  800d94:	89 d0                	mov    %edx,%eax
}
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 04             	sub    $0x4,%esp
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da4:	eb 12                	jmp    800db8 <strchr+0x20>
		if (*s == c)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dae:	75 05                	jne    800db5 <strchr+0x1d>
			return (char *) s;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	eb 11                	jmp    800dc6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	84 c0                	test   %al,%al
  800dbf:	75 e5                	jne    800da6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd4:	eb 0d                	jmp    800de3 <strfind+0x1b>
		if (*s == c)
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dde:	74 0e                	je     800dee <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de0:	ff 45 08             	incl   0x8(%ebp)
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	84 c0                	test   %al,%al
  800dea:	75 ea                	jne    800dd6 <strfind+0xe>
  800dec:	eb 01                	jmp    800def <strfind+0x27>
		if (*s == c)
			break;
  800dee:	90                   	nop
	return (char *) s;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e06:	eb 0e                	jmp    800e16 <memset+0x22>
		*p++ = c;
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	8d 50 01             	lea    0x1(%eax),%edx
  800e0e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e14:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e16:	ff 4d f8             	decl   -0x8(%ebp)
  800e19:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1d:	79 e9                	jns    800e08 <memset+0x14>
		*p++ = c;

	return v;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e36:	eb 16                	jmp    800e4e <memcpy+0x2a>
		*d++ = *s++;
  800e38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3b:	8d 50 01             	lea    0x1(%eax),%edx
  800e3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e47:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4a:	8a 12                	mov    (%edx),%dl
  800e4c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e54:	89 55 10             	mov    %edx,0x10(%ebp)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	75 dd                	jne    800e38 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e78:	73 50                	jae    800eca <memmove+0x6a>
  800e7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e80:	01 d0                	add    %edx,%eax
  800e82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e85:	76 43                	jbe    800eca <memmove+0x6a>
		s += n;
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e93:	eb 10                	jmp    800ea5 <memmove+0x45>
			*--d = *--s;
  800e95:	ff 4d f8             	decl   -0x8(%ebp)
  800e98:	ff 4d fc             	decl   -0x4(%ebp)
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	8a 10                	mov    (%eax),%dl
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 e3                	jne    800e95 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb2:	eb 23                	jmp    800ed7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8d 50 01             	lea    0x1(%eax),%edx
  800eba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	75 dd                	jne    800eb4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eee:	eb 2a                	jmp    800f1a <memcmp+0x3e>
		if (*s1 != *s2)
  800ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef3:	8a 10                	mov    (%eax),%dl
  800ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	38 c2                	cmp    %al,%dl
  800efc:	74 16                	je     800f14 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 d0             	movzbl %al,%edx
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	29 c2                	sub    %eax,%edx
  800f10:	89 d0                	mov    %edx,%eax
  800f12:	eb 18                	jmp    800f2c <memcmp+0x50>
		s1++, s2++;
  800f14:	ff 45 fc             	incl   -0x4(%ebp)
  800f17:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f20:	89 55 10             	mov    %edx,0x10(%ebp)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	75 c9                	jne    800ef0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	01 d0                	add    %edx,%eax
  800f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3f:	eb 15                	jmp    800f56 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	0f b6 d0             	movzbl %al,%edx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	0f b6 c0             	movzbl %al,%eax
  800f4f:	39 c2                	cmp    %eax,%edx
  800f51:	74 0d                	je     800f60 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5c:	72 e3                	jb     800f41 <memfind+0x13>
  800f5e:	eb 01                	jmp    800f61 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f60:	90                   	nop
	return (void *) s;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7a:	eb 03                	jmp    800f7f <strtol+0x19>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 20                	cmp    $0x20,%al
  800f86:	74 f4                	je     800f7c <strtol+0x16>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 09                	cmp    $0x9,%al
  800f8f:	74 eb                	je     800f7c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2b                	cmp    $0x2b,%al
  800f98:	75 05                	jne    800f9f <strtol+0x39>
		s++;
  800f9a:	ff 45 08             	incl   0x8(%ebp)
  800f9d:	eb 13                	jmp    800fb2 <strtol+0x4c>
	else if (*s == '-')
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3c 2d                	cmp    $0x2d,%al
  800fa6:	75 0a                	jne    800fb2 <strtol+0x4c>
		s++, neg = 1;
  800fa8:	ff 45 08             	incl   0x8(%ebp)
  800fab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb6:	74 06                	je     800fbe <strtol+0x58>
  800fb8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbc:	75 20                	jne    800fde <strtol+0x78>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 30                	cmp    $0x30,%al
  800fc5:	75 17                	jne    800fde <strtol+0x78>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	40                   	inc    %eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 78                	cmp    $0x78,%al
  800fcf:	75 0d                	jne    800fde <strtol+0x78>
		s += 2, base = 16;
  800fd1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdc:	eb 28                	jmp    801006 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe2:	75 15                	jne    800ff9 <strtol+0x93>
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 30                	cmp    $0x30,%al
  800feb:	75 0c                	jne    800ff9 <strtol+0x93>
		s++, base = 8;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff7:	eb 0d                	jmp    801006 <strtol+0xa0>
	else if (base == 0)
  800ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffd:	75 07                	jne    801006 <strtol+0xa0>
		base = 10;
  800fff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	3c 2f                	cmp    $0x2f,%al
  80100d:	7e 19                	jle    801028 <strtol+0xc2>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 39                	cmp    $0x39,%al
  801016:	7f 10                	jg     801028 <strtol+0xc2>
			dig = *s - '0';
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f be c0             	movsbl %al,%eax
  801020:	83 e8 30             	sub    $0x30,%eax
  801023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801026:	eb 42                	jmp    80106a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 60                	cmp    $0x60,%al
  80102f:	7e 19                	jle    80104a <strtol+0xe4>
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 7a                	cmp    $0x7a,%al
  801038:	7f 10                	jg     80104a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f be c0             	movsbl %al,%eax
  801042:	83 e8 57             	sub    $0x57,%eax
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801048:	eb 20                	jmp    80106a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 40                	cmp    $0x40,%al
  801051:	7e 39                	jle    80108c <strtol+0x126>
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 5a                	cmp    $0x5a,%al
  80105a:	7f 30                	jg     80108c <strtol+0x126>
			dig = *s - 'A' + 10;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f be c0             	movsbl %al,%eax
  801064:	83 e8 37             	sub    $0x37,%eax
  801067:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801070:	7d 19                	jge    80108b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801072:	ff 45 08             	incl   0x8(%ebp)
  801075:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801078:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801081:	01 d0                	add    %edx,%eax
  801083:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801086:	e9 7b ff ff ff       	jmp    801006 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801090:	74 08                	je     80109a <strtol+0x134>
		*endptr = (char *) s;
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109e:	74 07                	je     8010a7 <strtol+0x141>
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	f7 d8                	neg    %eax
  8010a5:	eb 03                	jmp    8010aa <strtol+0x144>
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <ltostr>:

void
ltostr(long value, char *str)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c4:	79 13                	jns    8010d9 <ltostr+0x2d>
	{
		neg = 1;
  8010c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e1:	99                   	cltd   
  8010e2:	f7 f9                	idiv   %ecx
  8010e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	01 d0                	add    %edx,%eax
  8010f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fa:	83 c2 30             	add    $0x30,%edx
  8010fd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801102:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801107:	f7 e9                	imul   %ecx
  801109:	c1 fa 02             	sar    $0x2,%edx
  80110c:	89 c8                	mov    %ecx,%eax
  80110e:	c1 f8 1f             	sar    $0x1f,%eax
  801111:	29 c2                	sub    %eax,%edx
  801113:	89 d0                	mov    %edx,%eax
  801115:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	c1 e0 02             	shl    $0x2,%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	01 c0                	add    %eax,%eax
  801135:	29 c1                	sub    %eax,%ecx
  801137:	89 ca                	mov    %ecx,%edx
  801139:	85 d2                	test   %edx,%edx
  80113b:	75 9c                	jne    8010d9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801147:	48                   	dec    %eax
  801148:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114f:	74 3d                	je     80118e <ltostr+0xe2>
		start = 1 ;
  801151:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801158:	eb 34                	jmp    80118e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 c2                	add    %eax,%edx
  80116f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	01 c8                	add    %ecx,%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 c2                	add    %eax,%edx
  801183:	8a 45 eb             	mov    -0x15(%ebp),%al
  801186:	88 02                	mov    %al,(%edx)
		start++ ;
  801188:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801194:	7c c4                	jl     80115a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801196:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a1:	90                   	nop
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011aa:	ff 75 08             	pushl  0x8(%ebp)
  8011ad:	e8 54 fa ff ff       	call   800c06 <strlen>
  8011b2:	83 c4 04             	add    $0x4,%esp
  8011b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	e8 46 fa ff ff       	call   800c06 <strlen>
  8011c0:	83 c4 04             	add    $0x4,%esp
  8011c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d4:	eb 17                	jmp    8011ed <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	01 c2                	add    %eax,%edx
  8011de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	01 c8                	add    %ecx,%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011ea:	ff 45 fc             	incl   -0x4(%ebp)
  8011ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f3:	7c e1                	jl     8011d6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801203:	eb 1f                	jmp    801224 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801205:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801208:	8d 50 01             	lea    0x1(%eax),%edx
  80120b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120e:	89 c2                	mov    %eax,%edx
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	01 c2                	add    %eax,%edx
  801215:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c8                	add    %ecx,%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801221:	ff 45 f8             	incl   -0x8(%ebp)
  801224:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801227:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122a:	7c d9                	jl     801205 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 d0                	add    %edx,%eax
  801234:	c6 00 00             	movb   $0x0,(%eax)
}
  801237:	90                   	nop
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123d:	8b 45 14             	mov    0x14(%ebp),%eax
  801240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	8b 00                	mov    (%eax),%eax
  80124b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801252:	8b 45 10             	mov    0x10(%ebp),%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125d:	eb 0c                	jmp    80126b <strsplit+0x31>
			*string++ = 0;
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8d 50 01             	lea    0x1(%eax),%edx
  801265:	89 55 08             	mov    %edx,0x8(%ebp)
  801268:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	84 c0                	test   %al,%al
  801272:	74 18                	je     80128c <strsplit+0x52>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	0f be c0             	movsbl %al,%eax
  80127c:	50                   	push   %eax
  80127d:	ff 75 0c             	pushl  0xc(%ebp)
  801280:	e8 13 fb ff ff       	call   800d98 <strchr>
  801285:	83 c4 08             	add    $0x8,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	75 d3                	jne    80125f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	84 c0                	test   %al,%al
  801293:	74 5a                	je     8012ef <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801295:	8b 45 14             	mov    0x14(%ebp),%eax
  801298:	8b 00                	mov    (%eax),%eax
  80129a:	83 f8 0f             	cmp    $0xf,%eax
  80129d:	75 07                	jne    8012a6 <strsplit+0x6c>
		{
			return 0;
  80129f:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a4:	eb 66                	jmp    80130c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a9:	8b 00                	mov    (%eax),%eax
  8012ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ae:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b1:	89 0a                	mov    %ecx,(%edx)
  8012b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	01 c2                	add    %eax,%edx
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c4:	eb 03                	jmp    8012c9 <strsplit+0x8f>
			string++;
  8012c6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	84 c0                	test   %al,%al
  8012d0:	74 8b                	je     80125d <strsplit+0x23>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	0f be c0             	movsbl %al,%eax
  8012da:	50                   	push   %eax
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	e8 b5 fa ff ff       	call   800d98 <strchr>
  8012e3:	83 c4 08             	add    $0x8,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	74 dc                	je     8012c6 <strsplit+0x8c>
			string++;
	}
  8012ea:	e9 6e ff ff ff       	jmp    80125d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ef:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f3:	8b 00                	mov    (%eax),%eax
  8012f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801307:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	68 50 25 80 00       	push   $0x802550
  80131c:	6a 0e                	push   $0xe
  80131e:	68 8a 25 80 00       	push   $0x80258a
  801323:	e8 a8 ef ff ff       	call   8002d0 <_panic>

00801328 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80132e:	a1 04 30 80 00       	mov    0x803004,%eax
  801333:	85 c0                	test   %eax,%eax
  801335:	74 0f                	je     801346 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801337:	e8 d2 ff ff ff       	call   80130e <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80133c:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801343:	00 00 00 
	}
	if (size == 0) return NULL ;
  801346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134a:	75 07                	jne    801353 <malloc+0x2b>
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
  801351:	eb 14                	jmp    801367 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	68 98 25 80 00       	push   $0x802598
  80135b:	6a 2e                	push   $0x2e
  80135d:	68 8a 25 80 00       	push   $0x80258a
  801362:	e8 69 ef ff ff       	call   8002d0 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	68 c0 25 80 00       	push   $0x8025c0
  801377:	6a 49                	push   $0x49
  801379:	68 8a 25 80 00       	push   $0x80258a
  80137e:	e8 4d ef ff ff       	call   8002d0 <_panic>

00801383 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 18             	sub    $0x18,%esp
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	68 e4 25 80 00       	push   $0x8025e4
  801397:	6a 57                	push   $0x57
  801399:	68 8a 25 80 00       	push   $0x80258a
  80139e:	e8 2d ef ff ff       	call   8002d0 <_panic>

008013a3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	68 0c 26 80 00       	push   $0x80260c
  8013b1:	6a 60                	push   $0x60
  8013b3:	68 8a 25 80 00       	push   $0x80258a
  8013b8:	e8 13 ef ff ff       	call   8002d0 <_panic>

008013bd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	68 30 26 80 00       	push   $0x802630
  8013cb:	6a 7c                	push   $0x7c
  8013cd:	68 8a 25 80 00       	push   $0x80258a
  8013d2:	e8 f9 ee ff ff       	call   8002d0 <_panic>

008013d7 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	68 58 26 80 00       	push   $0x802658
  8013e5:	68 86 00 00 00       	push   $0x86
  8013ea:	68 8a 25 80 00       	push   $0x80258a
  8013ef:	e8 dc ee ff ff       	call   8002d0 <_panic>

008013f4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 7c 26 80 00       	push   $0x80267c
  801402:	68 91 00 00 00       	push   $0x91
  801407:	68 8a 25 80 00       	push   $0x80258a
  80140c:	e8 bf ee ff ff       	call   8002d0 <_panic>

00801411 <shrink>:

}
void shrink(uint32 newSize)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	68 7c 26 80 00       	push   $0x80267c
  80141f:	68 96 00 00 00       	push   $0x96
  801424:	68 8a 25 80 00       	push   $0x80258a
  801429:	e8 a2 ee ff ff       	call   8002d0 <_panic>

0080142e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	68 7c 26 80 00       	push   $0x80267c
  80143c:	68 9b 00 00 00       	push   $0x9b
  801441:	68 8a 25 80 00       	push   $0x80258a
  801446:	e8 85 ee ff ff       	call   8002d0 <_panic>

0080144b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	57                   	push   %edi
  80144f:	56                   	push   %esi
  801450:	53                   	push   %ebx
  801451:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801460:	8b 7d 18             	mov    0x18(%ebp),%edi
  801463:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801466:	cd 30                	int    $0x30
  801468:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801482:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	52                   	push   %edx
  80148e:	ff 75 0c             	pushl  0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	6a 00                	push   $0x0
  801494:	e8 b2 ff ff ff       	call   80144b <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_cgetc>:

int
sys_cgetc(void)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 01                	push   $0x1
  8014ae:	e8 98 ff ff ff       	call   80144b <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	52                   	push   %edx
  8014c8:	50                   	push   %eax
  8014c9:	6a 05                	push   $0x5
  8014cb:	e8 7b ff ff ff       	call   80144b <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014da:	8b 75 18             	mov    0x18(%ebp),%esi
  8014dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	51                   	push   %ecx
  8014ec:	52                   	push   %edx
  8014ed:	50                   	push   %eax
  8014ee:	6a 06                	push   $0x6
  8014f0:	e8 56 ff ff ff       	call   80144b <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
}
  8014f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fb:	5b                   	pop    %ebx
  8014fc:	5e                   	pop    %esi
  8014fd:	5d                   	pop    %ebp
  8014fe:	c3                   	ret    

008014ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	52                   	push   %edx
  80150f:	50                   	push   %eax
  801510:	6a 07                	push   $0x7
  801512:	e8 34 ff ff ff       	call   80144b <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	ff 75 08             	pushl  0x8(%ebp)
  80152b:	6a 08                	push   $0x8
  80152d:	e8 19 ff ff ff       	call   80144b <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 09                	push   $0x9
  801546:	e8 00 ff ff ff       	call   80144b <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 0a                	push   $0xa
  80155f:	e8 e7 fe ff ff       	call   80144b <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 0b                	push   $0xb
  801578:	e8 ce fe ff ff       	call   80144b <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	ff 75 08             	pushl  0x8(%ebp)
  801591:	6a 0f                	push   $0xf
  801593:	e8 b3 fe ff ff       	call   80144b <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
	return;
  80159b:	90                   	nop
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	6a 10                	push   $0x10
  8015af:	e8 97 fe ff ff       	call   80144b <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b7:	90                   	nop
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	ff 75 10             	pushl  0x10(%ebp)
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	ff 75 08             	pushl  0x8(%ebp)
  8015ca:	6a 11                	push   $0x11
  8015cc:	e8 7a fe ff ff       	call   80144b <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d4:	90                   	nop
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 0c                	push   $0xc
  8015e6:	e8 60 fe ff ff       	call   80144b <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 0d                	push   $0xd
  801600:	e8 46 fe ff ff       	call   80144b <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 0e                	push   $0xe
  801619:	e8 2d fe ff ff       	call   80144b <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 13                	push   $0x13
  801633:	e8 13 fe ff ff       	call   80144b <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	90                   	nop
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 14                	push   $0x14
  80164d:	e8 f9 fd ff ff       	call   80144b <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	90                   	nop
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_cputc>:


void
sys_cputc(const char c)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801664:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	50                   	push   %eax
  801671:	6a 15                	push   $0x15
  801673:	e8 d3 fd ff ff       	call   80144b <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	90                   	nop
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 16                	push   $0x16
  80168d:	e8 b9 fd ff ff       	call   80144b <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	6a 17                	push   $0x17
  8016aa:	e8 9c fd ff ff       	call   80144b <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 1a                	push   $0x1a
  8016c7:	e8 7f fd ff ff       	call   80144b <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	52                   	push   %edx
  8016e1:	50                   	push   %eax
  8016e2:	6a 18                	push   $0x18
  8016e4:	e8 62 fd ff ff       	call   80144b <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	90                   	nop
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	52                   	push   %edx
  8016ff:	50                   	push   %eax
  801700:	6a 19                	push   $0x19
  801702:	e8 44 fd ff ff       	call   80144b <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	90                   	nop
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801719:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80171c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	6a 00                	push   $0x0
  801725:	51                   	push   %ecx
  801726:	52                   	push   %edx
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	50                   	push   %eax
  80172b:	6a 1b                	push   $0x1b
  80172d:	e8 19 fd ff ff       	call   80144b <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 1c                	push   $0x1c
  80174a:	e8 fc fc ff ff       	call   80144b <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801757:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	51                   	push   %ecx
  801765:	52                   	push   %edx
  801766:	50                   	push   %eax
  801767:	6a 1d                	push   $0x1d
  801769:	e8 dd fc ff ff       	call   80144b <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	52                   	push   %edx
  801783:	50                   	push   %eax
  801784:	6a 1e                	push   $0x1e
  801786:	e8 c0 fc ff ff       	call   80144b <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 1f                	push   $0x1f
  80179f:	e8 a7 fc ff ff       	call   80144b <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	ff 75 14             	pushl  0x14(%ebp)
  8017b4:	ff 75 10             	pushl  0x10(%ebp)
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	50                   	push   %eax
  8017bb:	6a 20                	push   $0x20
  8017bd:	e8 89 fc ff ff       	call   80144b <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	50                   	push   %eax
  8017d6:	6a 21                	push   $0x21
  8017d8:	e8 6e fc ff ff       	call   80144b <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	50                   	push   %eax
  8017f2:	6a 22                	push   $0x22
  8017f4:	e8 52 fc ff ff       	call   80144b <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 02                	push   $0x2
  80180d:	e8 39 fc ff ff       	call   80144b <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 03                	push   $0x3
  801826:	e8 20 fc ff ff       	call   80144b <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 04                	push   $0x4
  80183f:	e8 07 fc ff ff       	call   80144b <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_exit_env>:


void sys_exit_env(void)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 23                	push   $0x23
  801858:	e8 ee fb ff ff       	call   80144b <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	90                   	nop
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801869:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80186c:	8d 50 04             	lea    0x4(%eax),%edx
  80186f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 24                	push   $0x24
  80187c:	e8 ca fb ff ff       	call   80144b <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return result;
  801884:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801887:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188d:	89 01                	mov    %eax,(%ecx)
  80188f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	c9                   	leave  
  801896:	c2 04 00             	ret    $0x4

00801899 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 10             	pushl  0x10(%ebp)
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 12                	push   $0x12
  8018ab:	e8 9b fb ff ff       	call   80144b <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b3:	90                   	nop
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 25                	push   $0x25
  8018c5:	e8 81 fb ff ff       	call   80144b <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018db:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	50                   	push   %eax
  8018e8:	6a 26                	push   $0x26
  8018ea:	e8 5c fb ff ff       	call   80144b <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f2:	90                   	nop
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <rsttst>:
void rsttst()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 28                	push   $0x28
  801904:	e8 42 fb ff ff       	call   80144b <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	8b 45 14             	mov    0x14(%ebp),%eax
  801918:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80191b:	8b 55 18             	mov    0x18(%ebp),%edx
  80191e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	ff 75 10             	pushl  0x10(%ebp)
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	6a 27                	push   $0x27
  80192f:	e8 17 fb ff ff       	call   80144b <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return ;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <chktst>:
void chktst(uint32 n)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 29                	push   $0x29
  80194a:	e8 fc fa ff ff       	call   80144b <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return ;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <inctst>:

void inctst()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 2a                	push   $0x2a
  801964:	e8 e2 fa ff ff       	call   80144b <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return ;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <gettst>:
uint32 gettst()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 2b                	push   $0x2b
  80197e:	e8 c8 fa ff ff       	call   80144b <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 2c                	push   $0x2c
  80199a:	e8 ac fa ff ff       	call   80144b <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
  8019a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019a5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019a9:	75 07                	jne    8019b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b0:	eb 05                	jmp    8019b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 2c                	push   $0x2c
  8019cb:	e8 7b fa ff ff       	call   80144b <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
  8019d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019d6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019da:	75 07                	jne    8019e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e1:	eb 05                	jmp    8019e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 2c                	push   $0x2c
  8019fc:	e8 4a fa ff ff       	call   80144b <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
  801a04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a0b:	75 07                	jne    801a14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a12:	eb 05                	jmp    801a19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 2c                	push   $0x2c
  801a2d:	e8 19 fa ff ff       	call   80144b <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
  801a35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a3c:	75 07                	jne    801a45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a43:	eb 05                	jmp    801a4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 2d                	push   $0x2d
  801a5c:	e8 ea f9 ff ff       	call   80144b <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	53                   	push   %ebx
  801a7a:	51                   	push   %ecx
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 2e                	push   $0x2e
  801a7f:	e8 c7 f9 ff ff       	call   80144b <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 2f                	push   $0x2f
  801a9f:	e8 a7 f9 ff ff       	call   80144b <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab2:	89 d0                	mov    %edx,%eax
  801ab4:	c1 e0 02             	shl    $0x2,%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c1 e0 04             	shl    $0x4,%eax
  801ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801ae1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ae4:	83 ec 0c             	sub    $0xc,%esp
  801ae7:	50                   	push   %eax
  801ae8:	e8 76 fd ff ff       	call   801863 <sys_get_virtual_time>
  801aed:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801af0:	eb 41                	jmp    801b33 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801af2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	50                   	push   %eax
  801af9:	e8 65 fd ff ff       	call   801863 <sys_get_virtual_time>
  801afe:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b07:	29 c2                	sub    %eax,%edx
  801b09:	89 d0                	mov    %edx,%eax
  801b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b14:	89 d1                	mov    %edx,%ecx
  801b16:	29 c1                	sub    %eax,%ecx
  801b18:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1e:	39 c2                	cmp    %eax,%edx
  801b20:	0f 97 c0             	seta   %al
  801b23:	0f b6 c0             	movzbl %al,%eax
  801b26:	29 c1                	sub    %eax,%ecx
  801b28:	89 c8                	mov    %ecx,%eax
  801b2a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b39:	72 b7                	jb     801af2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b4b:	eb 03                	jmp    801b50 <busy_wait+0x12>
  801b4d:	ff 45 fc             	incl   -0x4(%ebp)
  801b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b56:	72 f5                	jb     801b4d <busy_wait+0xf>
	return i;
  801b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    
  801b5d:	66 90                	xchg   %ax,%ax
  801b5f:	90                   	nop

00801b60 <__udivdi3>:
  801b60:	55                   	push   %ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b77:	89 ca                	mov    %ecx,%edx
  801b79:	89 f8                	mov    %edi,%eax
  801b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b7f:	85 f6                	test   %esi,%esi
  801b81:	75 2d                	jne    801bb0 <__udivdi3+0x50>
  801b83:	39 cf                	cmp    %ecx,%edi
  801b85:	77 65                	ja     801bec <__udivdi3+0x8c>
  801b87:	89 fd                	mov    %edi,%ebp
  801b89:	85 ff                	test   %edi,%edi
  801b8b:	75 0b                	jne    801b98 <__udivdi3+0x38>
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	31 d2                	xor    %edx,%edx
  801b94:	f7 f7                	div    %edi
  801b96:	89 c5                	mov    %eax,%ebp
  801b98:	31 d2                	xor    %edx,%edx
  801b9a:	89 c8                	mov    %ecx,%eax
  801b9c:	f7 f5                	div    %ebp
  801b9e:	89 c1                	mov    %eax,%ecx
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f5                	div    %ebp
  801ba4:	89 cf                	mov    %ecx,%edi
  801ba6:	89 fa                	mov    %edi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	39 ce                	cmp    %ecx,%esi
  801bb2:	77 28                	ja     801bdc <__udivdi3+0x7c>
  801bb4:	0f bd fe             	bsr    %esi,%edi
  801bb7:	83 f7 1f             	xor    $0x1f,%edi
  801bba:	75 40                	jne    801bfc <__udivdi3+0x9c>
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	72 0a                	jb     801bca <__udivdi3+0x6a>
  801bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc4:	0f 87 9e 00 00 00    	ja     801c68 <__udivdi3+0x108>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	89 fa                	mov    %edi,%edx
  801bd1:	83 c4 1c             	add    $0x1c,%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
  801bd9:	8d 76 00             	lea    0x0(%esi),%esi
  801bdc:	31 ff                	xor    %edi,%edi
  801bde:	31 c0                	xor    %eax,%eax
  801be0:	89 fa                	mov    %edi,%edx
  801be2:	83 c4 1c             	add    $0x1c,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5f                   	pop    %edi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	f7 f7                	div    %edi
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	89 fa                	mov    %edi,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c01:	89 eb                	mov    %ebp,%ebx
  801c03:	29 fb                	sub    %edi,%ebx
  801c05:	89 f9                	mov    %edi,%ecx
  801c07:	d3 e6                	shl    %cl,%esi
  801c09:	89 c5                	mov    %eax,%ebp
  801c0b:	88 d9                	mov    %bl,%cl
  801c0d:	d3 ed                	shr    %cl,%ebp
  801c0f:	89 e9                	mov    %ebp,%ecx
  801c11:	09 f1                	or     %esi,%ecx
  801c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c17:	89 f9                	mov    %edi,%ecx
  801c19:	d3 e0                	shl    %cl,%eax
  801c1b:	89 c5                	mov    %eax,%ebp
  801c1d:	89 d6                	mov    %edx,%esi
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 ee                	shr    %cl,%esi
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e2                	shl    %cl,%edx
  801c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 e8                	shr    %cl,%eax
  801c2f:	09 c2                	or     %eax,%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	89 f2                	mov    %esi,%edx
  801c35:	f7 74 24 0c          	divl   0xc(%esp)
  801c39:	89 d6                	mov    %edx,%esi
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	f7 e5                	mul    %ebp
  801c3f:	39 d6                	cmp    %edx,%esi
  801c41:	72 19                	jb     801c5c <__udivdi3+0xfc>
  801c43:	74 0b                	je     801c50 <__udivdi3+0xf0>
  801c45:	89 d8                	mov    %ebx,%eax
  801c47:	31 ff                	xor    %edi,%edi
  801c49:	e9 58 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c54:	89 f9                	mov    %edi,%ecx
  801c56:	d3 e2                	shl    %cl,%edx
  801c58:	39 c2                	cmp    %eax,%edx
  801c5a:	73 e9                	jae    801c45 <__udivdi3+0xe5>
  801c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c5f:	31 ff                	xor    %edi,%edi
  801c61:	e9 40 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	31 c0                	xor    %eax,%eax
  801c6a:	e9 37 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c6f:	90                   	nop

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8f:	89 f3                	mov    %esi,%ebx
  801c91:	89 fa                	mov    %edi,%edx
  801c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c97:	89 34 24             	mov    %esi,(%esp)
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	75 1a                	jne    801cb8 <__umoddi3+0x48>
  801c9e:	39 f7                	cmp    %esi,%edi
  801ca0:	0f 86 a2 00 00 00    	jbe    801d48 <__umoddi3+0xd8>
  801ca6:	89 c8                	mov    %ecx,%eax
  801ca8:	89 f2                	mov    %esi,%edx
  801caa:	f7 f7                	div    %edi
  801cac:	89 d0                	mov    %edx,%eax
  801cae:	31 d2                	xor    %edx,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 f0                	cmp    %esi,%eax
  801cba:	0f 87 ac 00 00 00    	ja     801d6c <__umoddi3+0xfc>
  801cc0:	0f bd e8             	bsr    %eax,%ebp
  801cc3:	83 f5 1f             	xor    $0x1f,%ebp
  801cc6:	0f 84 ac 00 00 00    	je     801d78 <__umoddi3+0x108>
  801ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  801cd1:	29 ef                	sub    %ebp,%edi
  801cd3:	89 fe                	mov    %edi,%esi
  801cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 e0                	shl    %cl,%eax
  801cdd:	89 d7                	mov    %edx,%edi
  801cdf:	89 f1                	mov    %esi,%ecx
  801ce1:	d3 ef                	shr    %cl,%edi
  801ce3:	09 c7                	or     %eax,%edi
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e2                	shl    %cl,%edx
  801ce9:	89 14 24             	mov    %edx,(%esp)
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	d3 e0                	shl    %cl,%eax
  801cf0:	89 c2                	mov    %eax,%edx
  801cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf6:	d3 e0                	shl    %cl,%eax
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d00:	89 f1                	mov    %esi,%ecx
  801d02:	d3 e8                	shr    %cl,%eax
  801d04:	09 d0                	or     %edx,%eax
  801d06:	d3 eb                	shr    %cl,%ebx
  801d08:	89 da                	mov    %ebx,%edx
  801d0a:	f7 f7                	div    %edi
  801d0c:	89 d3                	mov    %edx,%ebx
  801d0e:	f7 24 24             	mull   (%esp)
  801d11:	89 c6                	mov    %eax,%esi
  801d13:	89 d1                	mov    %edx,%ecx
  801d15:	39 d3                	cmp    %edx,%ebx
  801d17:	0f 82 87 00 00 00    	jb     801da4 <__umoddi3+0x134>
  801d1d:	0f 84 91 00 00 00    	je     801db4 <__umoddi3+0x144>
  801d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d27:	29 f2                	sub    %esi,%edx
  801d29:	19 cb                	sbb    %ecx,%ebx
  801d2b:	89 d8                	mov    %ebx,%eax
  801d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d31:	d3 e0                	shl    %cl,%eax
  801d33:	89 e9                	mov    %ebp,%ecx
  801d35:	d3 ea                	shr    %cl,%edx
  801d37:	09 d0                	or     %edx,%eax
  801d39:	89 e9                	mov    %ebp,%ecx
  801d3b:	d3 eb                	shr    %cl,%ebx
  801d3d:	89 da                	mov    %ebx,%edx
  801d3f:	83 c4 1c             	add    $0x1c,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
  801d47:	90                   	nop
  801d48:	89 fd                	mov    %edi,%ebp
  801d4a:	85 ff                	test   %edi,%edi
  801d4c:	75 0b                	jne    801d59 <__umoddi3+0xe9>
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	31 d2                	xor    %edx,%edx
  801d55:	f7 f7                	div    %edi
  801d57:	89 c5                	mov    %eax,%ebp
  801d59:	89 f0                	mov    %esi,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f5                	div    %ebp
  801d5f:	89 c8                	mov    %ecx,%eax
  801d61:	f7 f5                	div    %ebp
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	e9 44 ff ff ff       	jmp    801cae <__umoddi3+0x3e>
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	89 c8                	mov    %ecx,%eax
  801d6e:	89 f2                	mov    %esi,%edx
  801d70:	83 c4 1c             	add    $0x1c,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
  801d78:	3b 04 24             	cmp    (%esp),%eax
  801d7b:	72 06                	jb     801d83 <__umoddi3+0x113>
  801d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d81:	77 0f                	ja     801d92 <__umoddi3+0x122>
  801d83:	89 f2                	mov    %esi,%edx
  801d85:	29 f9                	sub    %edi,%ecx
  801d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d8b:	89 14 24             	mov    %edx,(%esp)
  801d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d96:	8b 14 24             	mov    (%esp),%edx
  801d99:	83 c4 1c             	add    $0x1c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	8d 76 00             	lea    0x0(%esi),%esi
  801da4:	2b 04 24             	sub    (%esp),%eax
  801da7:	19 fa                	sbb    %edi,%edx
  801da9:	89 d1                	mov    %edx,%ecx
  801dab:	89 c6                	mov    %eax,%esi
  801dad:	e9 71 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801db8:	72 ea                	jb     801da4 <__umoddi3+0x134>
  801dba:	89 d9                	mov    %ebx,%ecx
  801dbc:	e9 62 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
