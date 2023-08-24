
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
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
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 1d 80 00       	push   $0x801de0
  80004a:	e8 48 13 00 00       	call   801397 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 e8 14 00 00       	call   80154b <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 80 15 00 00       	call   8015eb <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 1d 80 00       	push   $0x801df0
  800079:	e8 1a 05 00 00       	call   800598 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 23 1e 80 00       	push   $0x801e23
  800099:	e8 1f 17 00 00       	call   8017bd <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a9:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 2c 1e 80 00       	push   $0x801e2c
  8000bc:	e8 fc 16 00 00       	call   8017bd <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 09 17 00 00       	call   8017db <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 db 19 00 00       	call   801abd <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 eb 16 00 00       	call   8017db <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 48 14 00 00       	call   80154b <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 38 1e 80 00       	push   $0x801e38
  80010c:	e8 87 04 00 00       	call   800598 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 d8 16 00 00       	call   8017f7 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 ca 16 00 00       	call   8017f7 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 16 14 00 00       	call   80154b <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 ae 14 00 00       	call   8015eb <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 6c 1e 80 00       	push   $0x801e6c
  800153:	e8 40 04 00 00       	call   800598 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 bc 1e 80 00       	push   $0x801ebc
  800163:	6a 23                	push   $0x23
  800165:	68 f2 1e 80 00       	push   $0x801ef2
  80016a:	e8 75 01 00 00       	call   8002e4 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 08 1f 80 00       	push   $0x801f08
  80017a:	e8 19 04 00 00       	call   800598 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 68 1f 80 00       	push   $0x801f68
  80018a:	e8 09 04 00 00       	call   800598 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 8b 16 00 00       	call   80182b <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	01 c0                	add    %eax,%eax
  8001aa:	01 d0                	add    %edx,%eax
  8001ac:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001b3:	01 c8                	add    %ecx,%eax
  8001b5:	c1 e0 02             	shl    $0x2,%eax
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	c1 e0 02             	shl    $0x2,%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	c1 e0 02             	shl    $0x2,%eax
  8001cb:	01 d0                	add    %edx,%eax
  8001cd:	c1 e0 03             	shl    $0x3,%eax
  8001d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001d5:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8001e5:	84 c0                	test   %al,%al
  8001e7:	74 0f                	je     8001f8 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8001e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ee:	05 18 da 01 00       	add    $0x1da18,%eax
  8001f3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001fc:	7e 0a                	jle    800208 <libmain+0x73>
		binaryname = argv[0];
  8001fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800201:	8b 00                	mov    (%eax),%eax
  800203:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	ff 75 0c             	pushl  0xc(%ebp)
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	e8 22 fe ff ff       	call   800038 <_main>
  800216:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800219:	e8 1a 14 00 00       	call   801638 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	68 cc 1f 80 00       	push   $0x801fcc
  800226:	e8 6d 03 00 00       	call   800598 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	52                   	push   %edx
  800248:	50                   	push   %eax
  800249:	68 f4 1f 80 00       	push   $0x801ff4
  80024e:	e8 45 03 00 00       	call   800598 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800261:	a1 20 30 80 00       	mov    0x803020,%eax
  800266:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800277:	51                   	push   %ecx
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 1c 20 80 00       	push   $0x80201c
  80027f:	e8 14 03 00 00       	call   800598 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800287:	a1 20 30 80 00       	mov    0x803020,%eax
  80028c:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	50                   	push   %eax
  800296:	68 74 20 80 00       	push   $0x802074
  80029b:	e8 f8 02 00 00       	call   800598 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	68 cc 1f 80 00       	push   $0x801fcc
  8002ab:	e8 e8 02 00 00       	call   800598 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b3:	e8 9a 13 00 00       	call   801652 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002b8:	e8 19 00 00 00       	call   8002d6 <exit>
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	6a 00                	push   $0x0
  8002cb:	e8 27 15 00 00       	call   8017f7 <sys_destroy_env>
  8002d0:	83 c4 10             	add    $0x10,%esp
}
  8002d3:	90                   	nop
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <exit>:

void
exit(void)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002dc:	e8 7c 15 00 00       	call   80185d <sys_exit_env>
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ea:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ed:	83 c0 04             	add    $0x4,%eax
  8002f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f3:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	74 16                	je     800312 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002fc:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	50                   	push   %eax
  800305:	68 88 20 80 00       	push   $0x802088
  80030a:	e8 89 02 00 00       	call   800598 <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800312:	a1 00 30 80 00       	mov    0x803000,%eax
  800317:	ff 75 0c             	pushl  0xc(%ebp)
  80031a:	ff 75 08             	pushl  0x8(%ebp)
  80031d:	50                   	push   %eax
  80031e:	68 8d 20 80 00       	push   $0x80208d
  800323:	e8 70 02 00 00       	call   800598 <cprintf>
  800328:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80032b:	8b 45 10             	mov    0x10(%ebp),%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 f4             	pushl  -0xc(%ebp)
  800334:	50                   	push   %eax
  800335:	e8 f3 01 00 00       	call   80052d <vcprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 a9 20 80 00       	push   $0x8020a9
  800347:	e8 e1 01 00 00       	call   80052d <vcprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80034f:	e8 82 ff ff ff       	call   8002d6 <exit>

	// should not return here
	while (1) ;
  800354:	eb fe                	jmp    800354 <_panic+0x70>

00800356 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80035c:	a1 20 30 80 00       	mov    0x803020,%eax
  800361:	8b 50 74             	mov    0x74(%eax),%edx
  800364:	8b 45 0c             	mov    0xc(%ebp),%eax
  800367:	39 c2                	cmp    %eax,%edx
  800369:	74 14                	je     80037f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 ac 20 80 00       	push   $0x8020ac
  800373:	6a 26                	push   $0x26
  800375:	68 f8 20 80 00       	push   $0x8020f8
  80037a:	e8 65 ff ff ff       	call   8002e4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80037f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80038d:	e9 c2 00 00 00       	jmp    800454 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800395:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	75 08                	jne    8003af <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003a7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003aa:	e9 a2 00 00 00       	jmp    800451 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003bd:	eb 69                	jmp    800428 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003cd:	89 d0                	mov    %edx,%eax
  8003cf:	01 c0                	add    %eax,%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	c1 e0 03             	shl    $0x3,%eax
  8003d6:	01 c8                	add    %ecx,%eax
  8003d8:	8a 40 04             	mov    0x4(%eax),%al
  8003db:	84 c0                	test   %al,%al
  8003dd:	75 46                	jne    800425 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003df:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ed:	89 d0                	mov    %edx,%eax
  8003ef:	01 c0                	add    %eax,%eax
  8003f1:	01 d0                	add    %edx,%eax
  8003f3:	c1 e0 03             	shl    $0x3,%eax
  8003f6:	01 c8                	add    %ecx,%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800400:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800405:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	75 09                	jne    800425 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80041c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800423:	eb 12                	jmp    800437 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800425:	ff 45 e8             	incl   -0x18(%ebp)
  800428:	a1 20 30 80 00       	mov    0x803020,%eax
  80042d:	8b 50 74             	mov    0x74(%eax),%edx
  800430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800433:	39 c2                	cmp    %eax,%edx
  800435:	77 88                	ja     8003bf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800437:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80043b:	75 14                	jne    800451 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80043d:	83 ec 04             	sub    $0x4,%esp
  800440:	68 04 21 80 00       	push   $0x802104
  800445:	6a 3a                	push   $0x3a
  800447:	68 f8 20 80 00       	push   $0x8020f8
  80044c:	e8 93 fe ff ff       	call   8002e4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800451:	ff 45 f0             	incl   -0x10(%ebp)
  800454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800457:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045a:	0f 8c 32 ff ff ff    	jl     800392 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800460:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046e:	eb 26                	jmp    800496 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800470:	a1 20 30 80 00       	mov    0x803020,%eax
  800475:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80047b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047e:	89 d0                	mov    %edx,%eax
  800480:	01 c0                	add    %eax,%eax
  800482:	01 d0                	add    %edx,%eax
  800484:	c1 e0 03             	shl    $0x3,%eax
  800487:	01 c8                	add    %ecx,%eax
  800489:	8a 40 04             	mov    0x4(%eax),%al
  80048c:	3c 01                	cmp    $0x1,%al
  80048e:	75 03                	jne    800493 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800490:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800493:	ff 45 e0             	incl   -0x20(%ebp)
  800496:	a1 20 30 80 00       	mov    0x803020,%eax
  80049b:	8b 50 74             	mov    0x74(%eax),%edx
  80049e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a1:	39 c2                	cmp    %eax,%edx
  8004a3:	77 cb                	ja     800470 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ab:	74 14                	je     8004c1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ad:	83 ec 04             	sub    $0x4,%esp
  8004b0:	68 58 21 80 00       	push   $0x802158
  8004b5:	6a 44                	push   $0x44
  8004b7:	68 f8 20 80 00       	push   $0x8020f8
  8004bc:	e8 23 fe ff ff       	call   8002e4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d5:	89 0a                	mov    %ecx,(%edx)
  8004d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004da:	88 d1                	mov    %dl,%cl
  8004dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004df:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ed:	75 2c                	jne    80051b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ef:	a0 24 30 80 00       	mov    0x803024,%al
  8004f4:	0f b6 c0             	movzbl %al,%eax
  8004f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fa:	8b 12                	mov    (%edx),%edx
  8004fc:	89 d1                	mov    %edx,%ecx
  8004fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800501:	83 c2 08             	add    $0x8,%edx
  800504:	83 ec 04             	sub    $0x4,%esp
  800507:	50                   	push   %eax
  800508:	51                   	push   %ecx
  800509:	52                   	push   %edx
  80050a:	e8 7b 0f 00 00       	call   80148a <sys_cputs>
  80050f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800512:	8b 45 0c             	mov    0xc(%ebp),%eax
  800515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 40 04             	mov    0x4(%eax),%eax
  800521:	8d 50 01             	lea    0x1(%eax),%edx
  800524:	8b 45 0c             	mov    0xc(%ebp),%eax
  800527:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800536:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80053d:	00 00 00 
	b.cnt = 0;
  800540:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800547:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054a:	ff 75 0c             	pushl  0xc(%ebp)
  80054d:	ff 75 08             	pushl  0x8(%ebp)
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	50                   	push   %eax
  800557:	68 c4 04 80 00       	push   $0x8004c4
  80055c:	e8 11 02 00 00       	call   800772 <vprintfmt>
  800561:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800564:	a0 24 30 80 00       	mov    0x803024,%al
  800569:	0f b6 c0             	movzbl %al,%eax
  80056c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800572:	83 ec 04             	sub    $0x4,%esp
  800575:	50                   	push   %eax
  800576:	52                   	push   %edx
  800577:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057d:	83 c0 08             	add    $0x8,%eax
  800580:	50                   	push   %eax
  800581:	e8 04 0f 00 00       	call   80148a <sys_cputs>
  800586:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800589:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800590:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800596:	c9                   	leave  
  800597:	c3                   	ret    

00800598 <cprintf>:

int cprintf(const char *fmt, ...) {
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80059e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b4:	50                   	push   %eax
  8005b5:	e8 73 ff ff ff       	call   80052d <vcprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005cb:	e8 68 10 00 00       	call   801638 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005df:	50                   	push   %eax
  8005e0:	e8 48 ff ff ff       	call   80052d <vcprintf>
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005eb:	e8 62 10 00 00       	call   801652 <sys_enable_interrupt>
	return cnt;
  8005f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	53                   	push   %ebx
  8005f9:	83 ec 14             	sub    $0x14,%esp
  8005fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800608:	8b 45 18             	mov    0x18(%ebp),%eax
  80060b:	ba 00 00 00 00       	mov    $0x0,%edx
  800610:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800613:	77 55                	ja     80066a <printnum+0x75>
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	72 05                	jb     80061f <printnum+0x2a>
  80061a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80061d:	77 4b                	ja     80066a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80061f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800622:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800625:	8b 45 18             	mov    0x18(%ebp),%eax
  800628:	ba 00 00 00 00       	mov    $0x0,%edx
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	ff 75 f4             	pushl  -0xc(%ebp)
  800632:	ff 75 f0             	pushl  -0x10(%ebp)
  800635:	e8 3a 15 00 00       	call   801b74 <__udivdi3>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	ff 75 20             	pushl  0x20(%ebp)
  800643:	53                   	push   %ebx
  800644:	ff 75 18             	pushl  0x18(%ebp)
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 08             	pushl  0x8(%ebp)
  80064f:	e8 a1 ff ff ff       	call   8005f5 <printnum>
  800654:	83 c4 20             	add    $0x20,%esp
  800657:	eb 1a                	jmp    800673 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	ff 75 20             	pushl  0x20(%ebp)
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	ff d0                	call   *%eax
  800667:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066a:	ff 4d 1c             	decl   0x1c(%ebp)
  80066d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800671:	7f e6                	jg     800659 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800673:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800676:	bb 00 00 00 00       	mov    $0x0,%ebx
  80067b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800681:	53                   	push   %ebx
  800682:	51                   	push   %ecx
  800683:	52                   	push   %edx
  800684:	50                   	push   %eax
  800685:	e8 fa 15 00 00       	call   801c84 <__umoddi3>
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800692:	8a 00                	mov    (%eax),%al
  800694:	0f be c0             	movsbl %al,%eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	50                   	push   %eax
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
}
  8006a6:	90                   	nop
  8006a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    

008006ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b3:	7e 1c                	jle    8006d1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 08             	lea    0x8(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 08             	sub    $0x8,%eax
  8006ca:	8b 50 04             	mov    0x4(%eax),%edx
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	eb 40                	jmp    800711 <getuint+0x65>
	else if (lflag)
  8006d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d5:	74 1e                	je     8006f5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	8d 50 04             	lea    0x4(%eax),%edx
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	89 10                	mov    %edx,(%eax)
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	83 e8 04             	sub    $0x4,%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f3:	eb 1c                	jmp    800711 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 04             	lea    0x4(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 04             	sub    $0x4,%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800711:	5d                   	pop    %ebp
  800712:	c3                   	ret    

00800713 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800716:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071a:	7e 1c                	jle    800738 <getint+0x25>
		return va_arg(*ap, long long);
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	8d 50 08             	lea    0x8(%eax),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	89 10                	mov    %edx,(%eax)
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	83 e8 08             	sub    $0x8,%eax
  800731:	8b 50 04             	mov    0x4(%eax),%edx
  800734:	8b 00                	mov    (%eax),%eax
  800736:	eb 38                	jmp    800770 <getint+0x5d>
	else if (lflag)
  800738:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80073c:	74 1a                	je     800758 <getint+0x45>
		return va_arg(*ap, long);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	8d 50 04             	lea    0x4(%eax),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	89 10                	mov    %edx,(%eax)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	99                   	cltd   
  800756:	eb 18                	jmp    800770 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	99                   	cltd   
}
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	56                   	push   %esi
  800776:	53                   	push   %ebx
  800777:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077a:	eb 17                	jmp    800793 <vprintfmt+0x21>
			if (ch == '\0')
  80077c:	85 db                	test   %ebx,%ebx
  80077e:	0f 84 af 03 00 00    	je     800b33 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	53                   	push   %ebx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	ff d0                	call   *%eax
  800790:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800793:	8b 45 10             	mov    0x10(%ebp),%eax
  800796:	8d 50 01             	lea    0x1(%eax),%edx
  800799:	89 55 10             	mov    %edx,0x10(%ebp)
  80079c:	8a 00                	mov    (%eax),%al
  80079e:	0f b6 d8             	movzbl %al,%ebx
  8007a1:	83 fb 25             	cmp    $0x25,%ebx
  8007a4:	75 d6                	jne    80077c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007a6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c9:	8d 50 01             	lea    0x1(%eax),%edx
  8007cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cf:	8a 00                	mov    (%eax),%al
  8007d1:	0f b6 d8             	movzbl %al,%ebx
  8007d4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007d7:	83 f8 55             	cmp    $0x55,%eax
  8007da:	0f 87 2b 03 00 00    	ja     800b0b <vprintfmt+0x399>
  8007e0:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8007e7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007e9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007ed:	eb d7                	jmp    8007c6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ef:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f3:	eb d1                	jmp    8007c6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	c1 e0 02             	shl    $0x2,%eax
  800804:	01 d0                	add    %edx,%eax
  800806:	01 c0                	add    %eax,%eax
  800808:	01 d8                	add    %ebx,%eax
  80080a:	83 e8 30             	sub    $0x30,%eax
  80080d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800810:	8b 45 10             	mov    0x10(%ebp),%eax
  800813:	8a 00                	mov    (%eax),%al
  800815:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800818:	83 fb 2f             	cmp    $0x2f,%ebx
  80081b:	7e 3e                	jle    80085b <vprintfmt+0xe9>
  80081d:	83 fb 39             	cmp    $0x39,%ebx
  800820:	7f 39                	jg     80085b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800822:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800825:	eb d5                	jmp    8007fc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 e8 04             	sub    $0x4,%eax
  800836:	8b 00                	mov    (%eax),%eax
  800838:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80083b:	eb 1f                	jmp    80085c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80083d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800841:	79 83                	jns    8007c6 <vprintfmt+0x54>
				width = 0;
  800843:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084a:	e9 77 ff ff ff       	jmp    8007c6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80084f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800856:	e9 6b ff ff ff       	jmp    8007c6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80085b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80085c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800860:	0f 89 60 ff ff ff    	jns    8007c6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800873:	e9 4e ff ff ff       	jmp    8007c6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800878:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80087b:	e9 46 ff ff ff       	jmp    8007c6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 c0 04             	add    $0x4,%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 e8 04             	sub    $0x4,%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	50                   	push   %eax
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
			break;
  8008a0:	e9 89 02 00 00       	jmp    800b2e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008b6:	85 db                	test   %ebx,%ebx
  8008b8:	79 02                	jns    8008bc <vprintfmt+0x14a>
				err = -err;
  8008ba:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008bc:	83 fb 64             	cmp    $0x64,%ebx
  8008bf:	7f 0b                	jg     8008cc <vprintfmt+0x15a>
  8008c1:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8008c8:	85 f6                	test   %esi,%esi
  8008ca:	75 19                	jne    8008e5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008cc:	53                   	push   %ebx
  8008cd:	68 e5 23 80 00       	push   $0x8023e5
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	ff 75 08             	pushl  0x8(%ebp)
  8008d8:	e8 5e 02 00 00       	call   800b3b <printfmt>
  8008dd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e0:	e9 49 02 00 00       	jmp    800b2e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008e5:	56                   	push   %esi
  8008e6:	68 ee 23 80 00       	push   $0x8023ee
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 45 02 00 00       	call   800b3b <printfmt>
  8008f6:	83 c4 10             	add    $0x10,%esp
			break;
  8008f9:	e9 30 02 00 00       	jmp    800b2e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 30                	mov    (%eax),%esi
  80090f:	85 f6                	test   %esi,%esi
  800911:	75 05                	jne    800918 <vprintfmt+0x1a6>
				p = "(null)";
  800913:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800918:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091c:	7e 6d                	jle    80098b <vprintfmt+0x219>
  80091e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800922:	74 67                	je     80098b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	50                   	push   %eax
  80092b:	56                   	push   %esi
  80092c:	e8 0c 03 00 00       	call   800c3d <strnlen>
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800937:	eb 16                	jmp    80094f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800939:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80094c:	ff 4d e4             	decl   -0x1c(%ebp)
  80094f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800953:	7f e4                	jg     800939 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800955:	eb 34                	jmp    80098b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800957:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80095b:	74 1c                	je     800979 <vprintfmt+0x207>
  80095d:	83 fb 1f             	cmp    $0x1f,%ebx
  800960:	7e 05                	jle    800967 <vprintfmt+0x1f5>
  800962:	83 fb 7e             	cmp    $0x7e,%ebx
  800965:	7e 12                	jle    800979 <vprintfmt+0x207>
					putch('?', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 3f                	push   $0x3f
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	eb 0f                	jmp    800988 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	89 f0                	mov    %esi,%eax
  80098d:	8d 70 01             	lea    0x1(%eax),%esi
  800990:	8a 00                	mov    (%eax),%al
  800992:	0f be d8             	movsbl %al,%ebx
  800995:	85 db                	test   %ebx,%ebx
  800997:	74 24                	je     8009bd <vprintfmt+0x24b>
  800999:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80099d:	78 b8                	js     800957 <vprintfmt+0x1e5>
  80099f:	ff 4d e0             	decl   -0x20(%ebp)
  8009a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a6:	79 af                	jns    800957 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a8:	eb 13                	jmp    8009bd <vprintfmt+0x24b>
				putch(' ', putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	6a 20                	push   $0x20
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	ff d0                	call   *%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c1:	7f e7                	jg     8009aa <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c3:	e9 66 01 00 00       	jmp    800b2e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d1:	50                   	push   %eax
  8009d2:	e8 3c fd ff ff       	call   800713 <getint>
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e6:	85 d2                	test   %edx,%edx
  8009e8:	79 23                	jns    800a0d <vprintfmt+0x29b>
				putch('-', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 2d                	push   $0x2d
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a00:	f7 d8                	neg    %eax
  800a02:	83 d2 00             	adc    $0x0,%edx
  800a05:	f7 da                	neg    %edx
  800a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a14:	e9 bc 00 00 00       	jmp    800ad5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 84 fc ff ff       	call   8006ac <getuint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a38:	e9 98 00 00 00       	jmp    800ad5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	6a 58                	push   $0x58
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	ff d0                	call   *%eax
  800a4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 58                	push   $0x58
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	6a 58                	push   $0x58
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	ff d0                	call   *%eax
  800a6a:	83 c4 10             	add    $0x10,%esp
			break;
  800a6d:	e9 bc 00 00 00       	jmp    800b2e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 30                	push   $0x30
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 78                	push   $0x78
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	83 c0 04             	add    $0x4,%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 e8 04             	sub    $0x4,%eax
  800aa1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab4:	eb 1f                	jmp    800ad5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 e8             	pushl  -0x18(%ebp)
  800abc:	8d 45 14             	lea    0x14(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	e8 e7 fb ff ff       	call   8006ac <getuint>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ace:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	52                   	push   %edx
  800ae0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	ff 75 08             	pushl  0x8(%ebp)
  800af0:	e8 00 fb ff ff       	call   8005f5 <printnum>
  800af5:	83 c4 20             	add    $0x20,%esp
			break;
  800af8:	eb 34                	jmp    800b2e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	53                   	push   %ebx
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			break;
  800b09:	eb 23                	jmp    800b2e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 25                	push   $0x25
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1b:	ff 4d 10             	decl   0x10(%ebp)
  800b1e:	eb 03                	jmp    800b23 <vprintfmt+0x3b1>
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	48                   	dec    %eax
  800b27:	8a 00                	mov    (%eax),%al
  800b29:	3c 25                	cmp    $0x25,%al
  800b2b:	75 f3                	jne    800b20 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b2d:	90                   	nop
		}
	}
  800b2e:	e9 47 fc ff ff       	jmp    80077a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b33:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b41:	8d 45 10             	lea    0x10(%ebp),%eax
  800b44:	83 c0 04             	add    $0x4,%eax
  800b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 16 fc ff ff       	call   800772 <vprintfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b5f:	90                   	nop
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 40 08             	mov    0x8(%eax),%eax
  800b6b:	8d 50 01             	lea    0x1(%eax),%edx
  800b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b71:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8b 10                	mov    (%eax),%edx
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 40 04             	mov    0x4(%eax),%eax
  800b7f:	39 c2                	cmp    %eax,%edx
  800b81:	73 12                	jae    800b95 <sprintputch+0x33>
		*b->buf++ = ch;
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	8d 48 01             	lea    0x1(%eax),%ecx
  800b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8e:	89 0a                	mov    %ecx,(%edx)
  800b90:	8b 55 08             	mov    0x8(%ebp),%edx
  800b93:	88 10                	mov    %dl,(%eax)
}
  800b95:	90                   	nop
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	01 d0                	add    %edx,%eax
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bbd:	74 06                	je     800bc5 <vsnprintf+0x2d>
  800bbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc3:	7f 07                	jg     800bcc <vsnprintf+0x34>
		return -E_INVAL;
  800bc5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bca:	eb 20                	jmp    800bec <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bcc:	ff 75 14             	pushl  0x14(%ebp)
  800bcf:	ff 75 10             	pushl  0x10(%ebp)
  800bd2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	68 62 0b 80 00       	push   $0x800b62
  800bdb:	e8 92 fb ff ff       	call   800772 <vprintfmt>
  800be0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf4:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf7:	83 c0 04             	add    $0x4,%eax
  800bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800c00:	ff 75 f4             	pushl  -0xc(%ebp)
  800c03:	50                   	push   %eax
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	ff 75 08             	pushl  0x8(%ebp)
  800c0a:	e8 89 ff ff ff       	call   800b98 <vsnprintf>
  800c0f:	83 c4 10             	add    $0x10,%esp
  800c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c27:	eb 06                	jmp    800c2f <strlen+0x15>
		n++;
  800c29:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c2c:	ff 45 08             	incl   0x8(%ebp)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	84 c0                	test   %al,%al
  800c36:	75 f1                	jne    800c29 <strlen+0xf>
		n++;
	return n;
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4a:	eb 09                	jmp    800c55 <strnlen+0x18>
		n++;
  800c4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4f:	ff 45 08             	incl   0x8(%ebp)
  800c52:	ff 4d 0c             	decl   0xc(%ebp)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 09                	je     800c64 <strnlen+0x27>
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e8                	jne    800c4c <strnlen+0xf>
		n++;
	return n;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c75:	90                   	nop
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8d 50 01             	lea    0x1(%eax),%edx
  800c7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c88:	8a 12                	mov    (%edx),%dl
  800c8a:	88 10                	mov    %dl,(%eax)
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	84 c0                	test   %al,%al
  800c90:	75 e4                	jne    800c76 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caa:	eb 1f                	jmp    800ccb <strncpy+0x34>
		*dst++ = *src;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb8:	8a 12                	mov    (%edx),%dl
  800cba:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 03                	je     800cc8 <strncpy+0x31>
			src++;
  800cc5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cc8:	ff 45 fc             	incl   -0x4(%ebp)
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cce:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd1:	72 d9                	jb     800cac <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce8:	74 30                	je     800d1a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cea:	eb 16                	jmp    800d02 <strlcpy+0x2a>
			*dst++ = *src++;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8d 50 01             	lea    0x1(%eax),%edx
  800cf2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfe:	8a 12                	mov    (%edx),%dl
  800d00:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d02:	ff 4d 10             	decl   0x10(%ebp)
  800d05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d09:	74 09                	je     800d14 <strlcpy+0x3c>
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	75 d8                	jne    800cec <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d20:	29 c2                	sub    %eax,%edx
  800d22:	89 d0                	mov    %edx,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d29:	eb 06                	jmp    800d31 <strcmp+0xb>
		p++, q++;
  800d2b:	ff 45 08             	incl   0x8(%ebp)
  800d2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 0e                	je     800d48 <strcmp+0x22>
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 10                	mov    (%eax),%dl
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	38 c2                	cmp    %al,%dl
  800d46:	74 e3                	je     800d2b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	0f b6 d0             	movzbl %al,%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	0f b6 c0             	movzbl %al,%eax
  800d58:	29 c2                	sub    %eax,%edx
  800d5a:	89 d0                	mov    %edx,%eax
}
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d61:	eb 09                	jmp    800d6c <strncmp+0xe>
		n--, p++, q++;
  800d63:	ff 4d 10             	decl   0x10(%ebp)
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	74 17                	je     800d89 <strncmp+0x2b>
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	84 c0                	test   %al,%al
  800d79:	74 0e                	je     800d89 <strncmp+0x2b>
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 10                	mov    (%eax),%dl
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	38 c2                	cmp    %al,%dl
  800d87:	74 da                	je     800d63 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8d:	75 07                	jne    800d96 <strncmp+0x38>
		return 0;
  800d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d94:	eb 14                	jmp    800daa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	0f b6 d0             	movzbl %al,%edx
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	0f b6 c0             	movzbl %al,%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db8:	eb 12                	jmp    800dcc <strchr+0x20>
		if (*s == c)
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc2:	75 05                	jne    800dc9 <strchr+0x1d>
			return (char *) s;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	eb 11                	jmp    800dda <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dc9:	ff 45 08             	incl   0x8(%ebp)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	75 e5                	jne    800dba <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de8:	eb 0d                	jmp    800df7 <strfind+0x1b>
		if (*s == c)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df2:	74 0e                	je     800e02 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	84 c0                	test   %al,%al
  800dfe:	75 ea                	jne    800dea <strfind+0xe>
  800e00:	eb 01                	jmp    800e03 <strfind+0x27>
		if (*s == c)
			break;
  800e02:	90                   	nop
	return (char *) s;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1a:	eb 0e                	jmp    800e2a <memset+0x22>
		*p++ = c;
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e28:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2a:	ff 4d f8             	decl   -0x8(%ebp)
  800e2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e31:	79 e9                	jns    800e1c <memset+0x14>
		*p++ = c;

	return v;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4a:	eb 16                	jmp    800e62 <memcpy+0x2a>
		*d++ = *s++;
  800e4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4f:	8d 50 01             	lea    0x1(%eax),%edx
  800e52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e5e:	8a 12                	mov    (%edx),%dl
  800e60:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e68:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 dd                	jne    800e4c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8c:	73 50                	jae    800ede <memmove+0x6a>
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	01 d0                	add    %edx,%eax
  800e96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e99:	76 43                	jbe    800ede <memmove+0x6a>
		s += n;
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ea7:	eb 10                	jmp    800eb9 <memmove+0x45>
			*--d = *--s;
  800ea9:	ff 4d f8             	decl   -0x8(%ebp)
  800eac:	ff 4d fc             	decl   -0x4(%ebp)
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	8a 10                	mov    (%eax),%dl
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	75 e3                	jne    800ea9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec6:	eb 23                	jmp    800eeb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eda:	8a 12                	mov    (%edx),%dl
  800edc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	75 dd                	jne    800ec8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f02:	eb 2a                	jmp    800f2e <memcmp+0x3e>
		if (*s1 != *s2)
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f07:	8a 10                	mov    (%eax),%dl
  800f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	38 c2                	cmp    %al,%dl
  800f10:	74 16                	je     800f28 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	eb 18                	jmp    800f40 <memcmp+0x50>
		s1++, s2++;
  800f28:	ff 45 fc             	incl   -0x4(%ebp)
  800f2b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 c9                	jne    800f04 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f40:	c9                   	leave  
  800f41:	c3                   	ret    

00800f42 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	01 d0                	add    %edx,%eax
  800f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f53:	eb 15                	jmp    800f6a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f b6 d0             	movzbl %al,%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	0f b6 c0             	movzbl %al,%eax
  800f63:	39 c2                	cmp    %eax,%edx
  800f65:	74 0d                	je     800f74 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f70:	72 e3                	jb     800f55 <memfind+0x13>
  800f72:	eb 01                	jmp    800f75 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f74:	90                   	nop
	return (void *) s;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f8e:	eb 03                	jmp    800f93 <strtol+0x19>
		s++;
  800f90:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 20                	cmp    $0x20,%al
  800f9a:	74 f4                	je     800f90 <strtol+0x16>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3c 09                	cmp    $0x9,%al
  800fa3:	74 eb                	je     800f90 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3c 2b                	cmp    $0x2b,%al
  800fac:	75 05                	jne    800fb3 <strtol+0x39>
		s++;
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	eb 13                	jmp    800fc6 <strtol+0x4c>
	else if (*s == '-')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 2d                	cmp    $0x2d,%al
  800fba:	75 0a                	jne    800fc6 <strtol+0x4c>
		s++, neg = 1;
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fca:	74 06                	je     800fd2 <strtol+0x58>
  800fcc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd0:	75 20                	jne    800ff2 <strtol+0x78>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 30                	cmp    $0x30,%al
  800fd9:	75 17                	jne    800ff2 <strtol+0x78>
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	40                   	inc    %eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3c 78                	cmp    $0x78,%al
  800fe3:	75 0d                	jne    800ff2 <strtol+0x78>
		s += 2, base = 16;
  800fe5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fe9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff0:	eb 28                	jmp    80101a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff6:	75 15                	jne    80100d <strtol+0x93>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 30                	cmp    $0x30,%al
  800fff:	75 0c                	jne    80100d <strtol+0x93>
		s++, base = 8;
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80100b:	eb 0d                	jmp    80101a <strtol+0xa0>
	else if (base == 0)
  80100d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801011:	75 07                	jne    80101a <strtol+0xa0>
		base = 10;
  801013:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 2f                	cmp    $0x2f,%al
  801021:	7e 19                	jle    80103c <strtol+0xc2>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 39                	cmp    $0x39,%al
  80102a:	7f 10                	jg     80103c <strtol+0xc2>
			dig = *s - '0';
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	0f be c0             	movsbl %al,%eax
  801034:	83 e8 30             	sub    $0x30,%eax
  801037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103a:	eb 42                	jmp    80107e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	3c 60                	cmp    $0x60,%al
  801043:	7e 19                	jle    80105e <strtol+0xe4>
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 7a                	cmp    $0x7a,%al
  80104c:	7f 10                	jg     80105e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f be c0             	movsbl %al,%eax
  801056:	83 e8 57             	sub    $0x57,%eax
  801059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80105c:	eb 20                	jmp    80107e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 40                	cmp    $0x40,%al
  801065:	7e 39                	jle    8010a0 <strtol+0x126>
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	3c 5a                	cmp    $0x5a,%al
  80106e:	7f 30                	jg     8010a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	0f be c0             	movsbl %al,%eax
  801078:	83 e8 37             	sub    $0x37,%eax
  80107b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801081:	3b 45 10             	cmp    0x10(%ebp),%eax
  801084:	7d 19                	jge    80109f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801086:	ff 45 08             	incl   0x8(%ebp)
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109a:	e9 7b ff ff ff       	jmp    80101a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80109f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a4:	74 08                	je     8010ae <strtol+0x134>
		*endptr = (char *) s;
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b2:	74 07                	je     8010bb <strtol+0x141>
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	f7 d8                	neg    %eax
  8010b9:	eb 03                	jmp    8010be <strtol+0x144>
  8010bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d8:	79 13                	jns    8010ed <ltostr+0x2d>
	{
		neg = 1;
  8010da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010f5:	99                   	cltd   
  8010f6:	f7 f9                	idiv   %ecx
  8010f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8d 50 01             	lea    0x1(%eax),%edx
  801101:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801104:	89 c2                	mov    %eax,%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80110e:	83 c2 30             	add    $0x30,%edx
  801111:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801116:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111b:	f7 e9                	imul   %ecx
  80111d:	c1 fa 02             	sar    $0x2,%edx
  801120:	89 c8                	mov    %ecx,%eax
  801122:	c1 f8 1f             	sar    $0x1f,%eax
  801125:	29 c2                	sub    %eax,%edx
  801127:	89 d0                	mov    %edx,%eax
  801129:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80112c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801134:	f7 e9                	imul   %ecx
  801136:	c1 fa 02             	sar    $0x2,%edx
  801139:	89 c8                	mov    %ecx,%eax
  80113b:	c1 f8 1f             	sar    $0x1f,%eax
  80113e:	29 c2                	sub    %eax,%edx
  801140:	89 d0                	mov    %edx,%eax
  801142:	c1 e0 02             	shl    $0x2,%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	01 c0                	add    %eax,%eax
  801149:	29 c1                	sub    %eax,%ecx
  80114b:	89 ca                	mov    %ecx,%edx
  80114d:	85 d2                	test   %edx,%edx
  80114f:	75 9c                	jne    8010ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801151:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	48                   	dec    %eax
  80115c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80115f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801163:	74 3d                	je     8011a2 <ltostr+0xe2>
		start = 1 ;
  801165:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80116c:	eb 34                	jmp    8011a2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80116e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	01 d0                	add    %edx,%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80117b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 c2                	add    %eax,%edx
  801183:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 c8                	add    %ecx,%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80118f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	01 c2                	add    %eax,%edx
  801197:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119a:	88 02                	mov    %al,(%edx)
		start++ ;
  80119c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80119f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a8:	7c c4                	jl     80116e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011b5:	90                   	nop
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 54 fa ff ff       	call   800c1a <strlen>
  8011c6:	83 c4 04             	add    $0x4,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	e8 46 fa ff ff       	call   800c1a <strlen>
  8011d4:	83 c4 04             	add    $0x4,%esp
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e8:	eb 17                	jmp    801201 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f0:	01 c2                	add    %eax,%edx
  8011f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	01 c8                	add    %ecx,%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011fe:	ff 45 fc             	incl   -0x4(%ebp)
  801201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801204:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801207:	7c e1                	jl     8011ea <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801209:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801210:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801217:	eb 1f                	jmp    801238 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	89 c2                	mov    %eax,%edx
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	01 c2                	add    %eax,%edx
  801229:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c8                	add    %ecx,%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801235:	ff 45 f8             	incl   -0x8(%ebp)
  801238:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80123e:	7c d9                	jl     801219 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	01 d0                	add    %edx,%eax
  801248:	c6 00 00             	movb   $0x0,(%eax)
}
  80124b:	90                   	nop
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801271:	eb 0c                	jmp    80127f <strsplit+0x31>
			*string++ = 0;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8d 50 01             	lea    0x1(%eax),%edx
  801279:	89 55 08             	mov    %edx,0x8(%ebp)
  80127c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	74 18                	je     8012a0 <strsplit+0x52>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f be c0             	movsbl %al,%eax
  801290:	50                   	push   %eax
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	e8 13 fb ff ff       	call   800dac <strchr>
  801299:	83 c4 08             	add    $0x8,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	75 d3                	jne    801273 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	84 c0                	test   %al,%al
  8012a7:	74 5a                	je     801303 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ac:	8b 00                	mov    (%eax),%eax
  8012ae:	83 f8 0f             	cmp    $0xf,%eax
  8012b1:	75 07                	jne    8012ba <strsplit+0x6c>
		{
			return 0;
  8012b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b8:	eb 66                	jmp    801320 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bd:	8b 00                	mov    (%eax),%eax
  8012bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c2:	8b 55 14             	mov    0x14(%ebp),%edx
  8012c5:	89 0a                	mov    %ecx,(%edx)
  8012c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	01 c2                	add    %eax,%edx
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d8:	eb 03                	jmp    8012dd <strsplit+0x8f>
			string++;
  8012da:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	74 8b                	je     801271 <strsplit+0x23>
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	0f be c0             	movsbl %al,%eax
  8012ee:	50                   	push   %eax
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	e8 b5 fa ff ff       	call   800dac <strchr>
  8012f7:	83 c4 08             	add    $0x8,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	74 dc                	je     8012da <strsplit+0x8c>
			string++;
	}
  8012fe:	e9 6e ff ff ff       	jmp    801271 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801303:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801304:	8b 45 14             	mov    0x14(%ebp),%eax
  801307:	8b 00                	mov    (%eax),%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80131b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801328:	83 ec 04             	sub    $0x4,%esp
  80132b:	68 50 25 80 00       	push   $0x802550
  801330:	6a 0e                	push   $0xe
  801332:	68 8a 25 80 00       	push   $0x80258a
  801337:	e8 a8 ef ff ff       	call   8002e4 <_panic>

0080133c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801342:	a1 04 30 80 00       	mov    0x803004,%eax
  801347:	85 c0                	test   %eax,%eax
  801349:	74 0f                	je     80135a <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80134b:	e8 d2 ff ff ff       	call   801322 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801350:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801357:	00 00 00 
	}
	if (size == 0) return NULL ;
  80135a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135e:	75 07                	jne    801367 <malloc+0x2b>
  801360:	b8 00 00 00 00       	mov    $0x0,%eax
  801365:	eb 14                	jmp    80137b <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 98 25 80 00       	push   $0x802598
  80136f:	6a 2e                	push   $0x2e
  801371:	68 8a 25 80 00       	push   $0x80258a
  801376:	e8 69 ef ff ff       	call   8002e4 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	68 c0 25 80 00       	push   $0x8025c0
  80138b:	6a 49                	push   $0x49
  80138d:	68 8a 25 80 00       	push   $0x80258a
  801392:	e8 4d ef ff ff       	call   8002e4 <_panic>

00801397 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	83 ec 18             	sub    $0x18,%esp
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 e4 25 80 00       	push   $0x8025e4
  8013ab:	6a 57                	push   $0x57
  8013ad:	68 8a 25 80 00       	push   $0x80258a
  8013b2:	e8 2d ef ff ff       	call   8002e4 <_panic>

008013b7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	68 0c 26 80 00       	push   $0x80260c
  8013c5:	6a 60                	push   $0x60
  8013c7:	68 8a 25 80 00       	push   $0x80258a
  8013cc:	e8 13 ef ff ff       	call   8002e4 <_panic>

008013d1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	68 30 26 80 00       	push   $0x802630
  8013df:	6a 7c                	push   $0x7c
  8013e1:	68 8a 25 80 00       	push   $0x80258a
  8013e6:	e8 f9 ee ff ff       	call   8002e4 <_panic>

008013eb <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	68 58 26 80 00       	push   $0x802658
  8013f9:	68 86 00 00 00       	push   $0x86
  8013fe:	68 8a 25 80 00       	push   $0x80258a
  801403:	e8 dc ee ff ff       	call   8002e4 <_panic>

00801408 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	68 7c 26 80 00       	push   $0x80267c
  801416:	68 91 00 00 00       	push   $0x91
  80141b:	68 8a 25 80 00       	push   $0x80258a
  801420:	e8 bf ee ff ff       	call   8002e4 <_panic>

00801425 <shrink>:

}
void shrink(uint32 newSize)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	68 7c 26 80 00       	push   $0x80267c
  801433:	68 96 00 00 00       	push   $0x96
  801438:	68 8a 25 80 00       	push   $0x80258a
  80143d:	e8 a2 ee ff ff       	call   8002e4 <_panic>

00801442 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	68 7c 26 80 00       	push   $0x80267c
  801450:	68 9b 00 00 00       	push   $0x9b
  801455:	68 8a 25 80 00       	push   $0x80258a
  80145a:	e8 85 ee ff ff       	call   8002e4 <_panic>

0080145f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	57                   	push   %edi
  801463:	56                   	push   %esi
  801464:	53                   	push   %ebx
  801465:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801471:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801474:	8b 7d 18             	mov    0x18(%ebp),%edi
  801477:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147a:	cd 30                	int    $0x30
  80147c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	5b                   	pop    %ebx
  801486:	5e                   	pop    %esi
  801487:	5f                   	pop    %edi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801496:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	52                   	push   %edx
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	50                   	push   %eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	e8 b2 ff ff ff       	call   80145f <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	90                   	nop
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 01                	push   $0x1
  8014c2:	e8 98 ff ff ff       	call   80145f <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	52                   	push   %edx
  8014dc:	50                   	push   %eax
  8014dd:	6a 05                	push   $0x5
  8014df:	e8 7b ff ff ff       	call   80145f <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014ee:	8b 75 18             	mov    0x18(%ebp),%esi
  8014f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	56                   	push   %esi
  8014fe:	53                   	push   %ebx
  8014ff:	51                   	push   %ecx
  801500:	52                   	push   %edx
  801501:	50                   	push   %eax
  801502:	6a 06                	push   $0x6
  801504:	e8 56 ff ff ff       	call   80145f <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801516:	8b 55 0c             	mov    0xc(%ebp),%edx
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	52                   	push   %edx
  801523:	50                   	push   %eax
  801524:	6a 07                	push   $0x7
  801526:	e8 34 ff ff ff       	call   80145f <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	6a 08                	push   $0x8
  801541:	e8 19 ff ff ff       	call   80145f <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 09                	push   $0x9
  80155a:	e8 00 ff ff ff       	call   80145f <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 0a                	push   $0xa
  801573:	e8 e7 fe ff ff       	call   80145f <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 0b                	push   $0xb
  80158c:	e8 ce fe ff ff       	call   80145f <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	6a 0f                	push   $0xf
  8015a7:	e8 b3 fe ff ff       	call   80145f <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
	return;
  8015af:	90                   	nop
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	6a 10                	push   $0x10
  8015c3:	e8 97 fe ff ff       	call   80145f <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cb:	90                   	nop
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	ff 75 10             	pushl  0x10(%ebp)
  8015d8:	ff 75 0c             	pushl  0xc(%ebp)
  8015db:	ff 75 08             	pushl  0x8(%ebp)
  8015de:	6a 11                	push   $0x11
  8015e0:	e8 7a fe ff ff       	call   80145f <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e8:	90                   	nop
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 0c                	push   $0xc
  8015fa:	e8 60 fe ff ff       	call   80145f <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	6a 0d                	push   $0xd
  801614:	e8 46 fe ff ff       	call   80145f <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 0e                	push   $0xe
  80162d:	e8 2d fe ff ff       	call   80145f <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	90                   	nop
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 13                	push   $0x13
  801647:	e8 13 fe ff ff       	call   80145f <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	90                   	nop
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 14                	push   $0x14
  801661:	e8 f9 fd ff ff       	call   80145f <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_cputc>:


void
sys_cputc(const char c)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801678:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	50                   	push   %eax
  801685:	6a 15                	push   $0x15
  801687:	e8 d3 fd ff ff       	call   80145f <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 16                	push   $0x16
  8016a1:	e8 b9 fd ff ff       	call   80145f <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	6a 17                	push   $0x17
  8016be:	e8 9c fd ff ff       	call   80145f <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	52                   	push   %edx
  8016d8:	50                   	push   %eax
  8016d9:	6a 1a                	push   $0x1a
  8016db:	e8 7f fd ff ff       	call   80145f <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	52                   	push   %edx
  8016f5:	50                   	push   %eax
  8016f6:	6a 18                	push   $0x18
  8016f8:	e8 62 fd ff ff       	call   80145f <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 19                	push   $0x19
  801716:	e8 44 fd ff ff       	call   80145f <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	90                   	nop
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80172d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801730:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	51                   	push   %ecx
  80173a:	52                   	push   %edx
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	50                   	push   %eax
  80173f:	6a 1b                	push   $0x1b
  801741:	e8 19 fd ff ff       	call   80145f <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80174e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	52                   	push   %edx
  80175b:	50                   	push   %eax
  80175c:	6a 1c                	push   $0x1c
  80175e:	e8 fc fc ff ff       	call   80145f <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80176b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	51                   	push   %ecx
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	6a 1d                	push   $0x1d
  80177d:	e8 dd fc ff ff       	call   80145f <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	52                   	push   %edx
  801797:	50                   	push   %eax
  801798:	6a 1e                	push   $0x1e
  80179a:	e8 c0 fc ff ff       	call   80145f <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 1f                	push   $0x1f
  8017b3:	e8 a7 fc ff ff       	call   80145f <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 14             	pushl  0x14(%ebp)
  8017c8:	ff 75 10             	pushl  0x10(%ebp)
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	6a 20                	push   $0x20
  8017d1:	e8 89 fc ff ff       	call   80145f <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	50                   	push   %eax
  8017ea:	6a 21                	push   $0x21
  8017ec:	e8 6e fc ff ff       	call   80145f <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	90                   	nop
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 22                	push   $0x22
  801808:	e8 52 fc ff ff       	call   80145f <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 02                	push   $0x2
  801821:	e8 39 fc ff ff       	call   80145f <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 03                	push   $0x3
  80183a:	e8 20 fc ff ff       	call   80145f <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 04                	push   $0x4
  801853:	e8 07 fc ff ff       	call   80145f <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_exit_env>:


void sys_exit_env(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 23                	push   $0x23
  80186c:	e8 ee fb ff ff       	call   80145f <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80187d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801880:	8d 50 04             	lea    0x4(%eax),%edx
  801883:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 24                	push   $0x24
  801890:	e8 ca fb ff ff       	call   80145f <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return result;
  801898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a1:	89 01                	mov    %eax,(%ecx)
  8018a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	c9                   	leave  
  8018aa:	c2 04 00             	ret    $0x4

008018ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 10             	pushl  0x10(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 12                	push   $0x12
  8018bf:	e8 9b fb ff ff       	call   80145f <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 25                	push   $0x25
  8018d9:	e8 81 fb ff ff       	call   80145f <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	50                   	push   %eax
  8018fc:	6a 26                	push   $0x26
  8018fe:	e8 5c fb ff ff       	call   80145f <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <rsttst>:
void rsttst()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 28                	push   $0x28
  801918:	e8 42 fb ff ff       	call   80145f <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80192f:	8b 55 18             	mov    0x18(%ebp),%edx
  801932:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	ff 75 10             	pushl  0x10(%ebp)
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 27                	push   $0x27
  801943:	e8 17 fb ff ff       	call   80145f <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return ;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <chktst>:
void chktst(uint32 n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 29                	push   $0x29
  80195e:	e8 fc fa ff ff       	call   80145f <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <inctst>:

void inctst()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 2a                	push   $0x2a
  801978:	e8 e2 fa ff ff       	call   80145f <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return ;
  801980:	90                   	nop
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <gettst>:
uint32 gettst()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 2b                	push   $0x2b
  801992:	e8 c8 fa ff ff       	call   80145f <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 2c                	push   $0x2c
  8019ae:	e8 ac fa ff ff       	call   80145f <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
  8019b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019b9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019bd:	75 07                	jne    8019c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c4:	eb 05                	jmp    8019cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 2c                	push   $0x2c
  8019df:	e8 7b fa ff ff       	call   80145f <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
  8019e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019ea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019ee:	75 07                	jne    8019f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f5:	eb 05                	jmp    8019fc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 2c                	push   $0x2c
  801a10:	e8 4a fa ff ff       	call   80145f <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
  801a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a1b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a1f:	75 07                	jne    801a28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	eb 05                	jmp    801a2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 2c                	push   $0x2c
  801a41:	e8 19 fa ff ff       	call   80145f <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
  801a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a50:	75 07                	jne    801a59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	eb 05                	jmp    801a5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 2d                	push   $0x2d
  801a70:	e8 ea f9 ff ff       	call   80145f <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	53                   	push   %ebx
  801a8e:	51                   	push   %ecx
  801a8f:	52                   	push   %edx
  801a90:	50                   	push   %eax
  801a91:	6a 2e                	push   $0x2e
  801a93:	e8 c7 f9 ff ff       	call   80145f <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 2f                	push   $0x2f
  801ab3:	e8 a7 f9 ff ff       	call   80145f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac6:	89 d0                	mov    %edx,%eax
  801ac8:	c1 e0 02             	shl    $0x2,%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801add:	01 d0                	add    %edx,%eax
  801adf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c1 e0 04             	shl    $0x4,%eax
  801aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801aee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801af5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801af8:	83 ec 0c             	sub    $0xc,%esp
  801afb:	50                   	push   %eax
  801afc:	e8 76 fd ff ff       	call   801877 <sys_get_virtual_time>
  801b01:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801b04:	eb 41                	jmp    801b47 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801b06:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b09:	83 ec 0c             	sub    $0xc,%esp
  801b0c:	50                   	push   %eax
  801b0d:	e8 65 fd ff ff       	call   801877 <sys_get_virtual_time>
  801b12:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1b:	29 c2                	sub    %eax,%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b28:	89 d1                	mov    %edx,%ecx
  801b2a:	29 c1                	sub    %eax,%ecx
  801b2c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b32:	39 c2                	cmp    %eax,%edx
  801b34:	0f 97 c0             	seta   %al
  801b37:	0f b6 c0             	movzbl %al,%eax
  801b3a:	29 c1                	sub    %eax,%ecx
  801b3c:	89 c8                	mov    %ecx,%eax
  801b3e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4d:	72 b7                	jb     801b06 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b5f:	eb 03                	jmp    801b64 <busy_wait+0x12>
  801b61:	ff 45 fc             	incl   -0x4(%ebp)
  801b64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b6a:	72 f5                	jb     801b61 <busy_wait+0xf>
	return i;
  801b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    
  801b71:	66 90                	xchg   %ax,%ax
  801b73:	90                   	nop

00801b74 <__udivdi3>:
  801b74:	55                   	push   %ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 1c             	sub    $0x1c,%esp
  801b7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8b:	89 ca                	mov    %ecx,%edx
  801b8d:	89 f8                	mov    %edi,%eax
  801b8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b93:	85 f6                	test   %esi,%esi
  801b95:	75 2d                	jne    801bc4 <__udivdi3+0x50>
  801b97:	39 cf                	cmp    %ecx,%edi
  801b99:	77 65                	ja     801c00 <__udivdi3+0x8c>
  801b9b:	89 fd                	mov    %edi,%ebp
  801b9d:	85 ff                	test   %edi,%edi
  801b9f:	75 0b                	jne    801bac <__udivdi3+0x38>
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	31 d2                	xor    %edx,%edx
  801ba8:	f7 f7                	div    %edi
  801baa:	89 c5                	mov    %eax,%ebp
  801bac:	31 d2                	xor    %edx,%edx
  801bae:	89 c8                	mov    %ecx,%eax
  801bb0:	f7 f5                	div    %ebp
  801bb2:	89 c1                	mov    %eax,%ecx
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	f7 f5                	div    %ebp
  801bb8:	89 cf                	mov    %ecx,%edi
  801bba:	89 fa                	mov    %edi,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	39 ce                	cmp    %ecx,%esi
  801bc6:	77 28                	ja     801bf0 <__udivdi3+0x7c>
  801bc8:	0f bd fe             	bsr    %esi,%edi
  801bcb:	83 f7 1f             	xor    $0x1f,%edi
  801bce:	75 40                	jne    801c10 <__udivdi3+0x9c>
  801bd0:	39 ce                	cmp    %ecx,%esi
  801bd2:	72 0a                	jb     801bde <__udivdi3+0x6a>
  801bd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd8:	0f 87 9e 00 00 00    	ja     801c7c <__udivdi3+0x108>
  801bde:	b8 01 00 00 00       	mov    $0x1,%eax
  801be3:	89 fa                	mov    %edi,%edx
  801be5:	83 c4 1c             	add    $0x1c,%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5f                   	pop    %edi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    
  801bed:	8d 76 00             	lea    0x0(%esi),%esi
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	31 c0                	xor    %eax,%eax
  801bf4:	89 fa                	mov    %edi,%edx
  801bf6:	83 c4 1c             	add    $0x1c,%esp
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5f                   	pop    %edi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	89 d8                	mov    %ebx,%eax
  801c02:	f7 f7                	div    %edi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	89 fa                	mov    %edi,%edx
  801c08:	83 c4 1c             	add    $0x1c,%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5f                   	pop    %edi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    
  801c10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c15:	89 eb                	mov    %ebp,%ebx
  801c17:	29 fb                	sub    %edi,%ebx
  801c19:	89 f9                	mov    %edi,%ecx
  801c1b:	d3 e6                	shl    %cl,%esi
  801c1d:	89 c5                	mov    %eax,%ebp
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 ed                	shr    %cl,%ebp
  801c23:	89 e9                	mov    %ebp,%ecx
  801c25:	09 f1                	or     %esi,%ecx
  801c27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c2b:	89 f9                	mov    %edi,%ecx
  801c2d:	d3 e0                	shl    %cl,%eax
  801c2f:	89 c5                	mov    %eax,%ebp
  801c31:	89 d6                	mov    %edx,%esi
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ee                	shr    %cl,%esi
  801c37:	89 f9                	mov    %edi,%ecx
  801c39:	d3 e2                	shl    %cl,%edx
  801c3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 e8                	shr    %cl,%eax
  801c43:	09 c2                	or     %eax,%edx
  801c45:	89 d0                	mov    %edx,%eax
  801c47:	89 f2                	mov    %esi,%edx
  801c49:	f7 74 24 0c          	divl   0xc(%esp)
  801c4d:	89 d6                	mov    %edx,%esi
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	f7 e5                	mul    %ebp
  801c53:	39 d6                	cmp    %edx,%esi
  801c55:	72 19                	jb     801c70 <__udivdi3+0xfc>
  801c57:	74 0b                	je     801c64 <__udivdi3+0xf0>
  801c59:	89 d8                	mov    %ebx,%eax
  801c5b:	31 ff                	xor    %edi,%edi
  801c5d:	e9 58 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c68:	89 f9                	mov    %edi,%ecx
  801c6a:	d3 e2                	shl    %cl,%edx
  801c6c:	39 c2                	cmp    %eax,%edx
  801c6e:	73 e9                	jae    801c59 <__udivdi3+0xe5>
  801c70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c73:	31 ff                	xor    %edi,%edi
  801c75:	e9 40 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	31 c0                	xor    %eax,%eax
  801c7e:	e9 37 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c83:	90                   	nop

00801c84 <__umoddi3>:
  801c84:	55                   	push   %ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca3:	89 f3                	mov    %esi,%ebx
  801ca5:	89 fa                	mov    %edi,%edx
  801ca7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cab:	89 34 24             	mov    %esi,(%esp)
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	75 1a                	jne    801ccc <__umoddi3+0x48>
  801cb2:	39 f7                	cmp    %esi,%edi
  801cb4:	0f 86 a2 00 00 00    	jbe    801d5c <__umoddi3+0xd8>
  801cba:	89 c8                	mov    %ecx,%eax
  801cbc:	89 f2                	mov    %esi,%edx
  801cbe:	f7 f7                	div    %edi
  801cc0:	89 d0                	mov    %edx,%eax
  801cc2:	31 d2                	xor    %edx,%edx
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
  801ccc:	39 f0                	cmp    %esi,%eax
  801cce:	0f 87 ac 00 00 00    	ja     801d80 <__umoddi3+0xfc>
  801cd4:	0f bd e8             	bsr    %eax,%ebp
  801cd7:	83 f5 1f             	xor    $0x1f,%ebp
  801cda:	0f 84 ac 00 00 00    	je     801d8c <__umoddi3+0x108>
  801ce0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce5:	29 ef                	sub    %ebp,%edi
  801ce7:	89 fe                	mov    %edi,%esi
  801ce9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	d3 e0                	shl    %cl,%eax
  801cf1:	89 d7                	mov    %edx,%edi
  801cf3:	89 f1                	mov    %esi,%ecx
  801cf5:	d3 ef                	shr    %cl,%edi
  801cf7:	09 c7                	or     %eax,%edi
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 e2                	shl    %cl,%edx
  801cfd:	89 14 24             	mov    %edx,(%esp)
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	d3 e0                	shl    %cl,%eax
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0a:	d3 e0                	shl    %cl,%eax
  801d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d14:	89 f1                	mov    %esi,%ecx
  801d16:	d3 e8                	shr    %cl,%eax
  801d18:	09 d0                	or     %edx,%eax
  801d1a:	d3 eb                	shr    %cl,%ebx
  801d1c:	89 da                	mov    %ebx,%edx
  801d1e:	f7 f7                	div    %edi
  801d20:	89 d3                	mov    %edx,%ebx
  801d22:	f7 24 24             	mull   (%esp)
  801d25:	89 c6                	mov    %eax,%esi
  801d27:	89 d1                	mov    %edx,%ecx
  801d29:	39 d3                	cmp    %edx,%ebx
  801d2b:	0f 82 87 00 00 00    	jb     801db8 <__umoddi3+0x134>
  801d31:	0f 84 91 00 00 00    	je     801dc8 <__umoddi3+0x144>
  801d37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d3b:	29 f2                	sub    %esi,%edx
  801d3d:	19 cb                	sbb    %ecx,%ebx
  801d3f:	89 d8                	mov    %ebx,%eax
  801d41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d45:	d3 e0                	shl    %cl,%eax
  801d47:	89 e9                	mov    %ebp,%ecx
  801d49:	d3 ea                	shr    %cl,%edx
  801d4b:	09 d0                	or     %edx,%eax
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	d3 eb                	shr    %cl,%ebx
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	83 c4 1c             	add    $0x1c,%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5f                   	pop    %edi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    
  801d5b:	90                   	nop
  801d5c:	89 fd                	mov    %edi,%ebp
  801d5e:	85 ff                	test   %edi,%edi
  801d60:	75 0b                	jne    801d6d <__umoddi3+0xe9>
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	31 d2                	xor    %edx,%edx
  801d69:	f7 f7                	div    %edi
  801d6b:	89 c5                	mov    %eax,%ebp
  801d6d:	89 f0                	mov    %esi,%eax
  801d6f:	31 d2                	xor    %edx,%edx
  801d71:	f7 f5                	div    %ebp
  801d73:	89 c8                	mov    %ecx,%eax
  801d75:	f7 f5                	div    %ebp
  801d77:	89 d0                	mov    %edx,%eax
  801d79:	e9 44 ff ff ff       	jmp    801cc2 <__umoddi3+0x3e>
  801d7e:	66 90                	xchg   %ax,%ax
  801d80:	89 c8                	mov    %ecx,%eax
  801d82:	89 f2                	mov    %esi,%edx
  801d84:	83 c4 1c             	add    $0x1c,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    
  801d8c:	3b 04 24             	cmp    (%esp),%eax
  801d8f:	72 06                	jb     801d97 <__umoddi3+0x113>
  801d91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d95:	77 0f                	ja     801da6 <__umoddi3+0x122>
  801d97:	89 f2                	mov    %esi,%edx
  801d99:	29 f9                	sub    %edi,%ecx
  801d9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9f:	89 14 24             	mov    %edx,(%esp)
  801da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801daa:	8b 14 24             	mov    (%esp),%edx
  801dad:	83 c4 1c             	add    $0x1c,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
  801db5:	8d 76 00             	lea    0x0(%esi),%esi
  801db8:	2b 04 24             	sub    (%esp),%eax
  801dbb:	19 fa                	sbb    %edi,%edx
  801dbd:	89 d1                	mov    %edx,%ecx
  801dbf:	89 c6                	mov    %eax,%esi
  801dc1:	e9 71 ff ff ff       	jmp    801d37 <__umoddi3+0xb3>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dcc:	72 ea                	jb     801db8 <__umoddi3+0x134>
  801dce:	89 d9                	mov    %ebx,%ecx
  801dd0:	e9 62 ff ff ff       	jmp    801d37 <__umoddi3+0xb3>
