
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 00 1e 80 00       	push   $0x801e00
  800091:	6a 12                	push   $0x12
  800093:	68 1c 1e 80 00       	push   $0x801e1c
  800098:	e8 5f 02 00 00       	call   8002fc <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 ba 17 00 00       	call   80185c <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 3c 1e 80 00       	push   $0x801e3c
  8000aa:	50                   	push   %eax
  8000ab:	e8 1f 13 00 00       	call   8013cf <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 40 1e 80 00       	push   $0x801e40
  8000be:	e8 ed 04 00 00       	call   8005b0 <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 68 1e 80 00       	push   $0x801e68
  8000ce:	e8 dd 04 00 00       	call   8005b0 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 f2 19 00 00       	call   801ad5 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 78 14 00 00       	call   801563 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 0a 13 00 00       	call   801403 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 88 1e 80 00       	push   $0x801e88
  800104:	e8 a7 04 00 00       	call   8005b0 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 52 14 00 00       	call   801563 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 a0 1e 80 00       	push   $0x801ea0
  800127:	6a 20                	push   $0x20
  800129:	68 1c 1e 80 00       	push   $0x801e1c
  80012e:	e8 c9 01 00 00       	call   8002fc <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 63 18 00 00       	call   80199b <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 40 1f 80 00       	push   $0x801f40
  800145:	6a 23                	push   $0x23
  800147:	68 1c 1e 80 00       	push   $0x801e1c
  80014c:	e8 ab 01 00 00       	call   8002fc <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 4c 1f 80 00       	push   $0x801f4c
  800159:	e8 52 04 00 00       	call   8005b0 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 70 1f 80 00       	push   $0x801f70
  800169:	e8 42 04 00 00       	call   8005b0 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 e6 16 00 00       	call   80185c <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 bc 1f 80 00       	push   $0x801fbc
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 39 12 00 00       	call   8013cf <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 8b 16 00 00       	call   801843 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	01 c0                	add    %eax,%eax
  8001c2:	01 d0                	add    %edx,%eax
  8001c4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001cb:	01 c8                	add    %ecx,%eax
  8001cd:	c1 e0 02             	shl    $0x2,%eax
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001d9:	01 c8                	add    %ecx,%eax
  8001db:	c1 e0 02             	shl    $0x2,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	c1 e0 02             	shl    $0x2,%eax
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	c1 e0 03             	shl    $0x3,%eax
  8001e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ed:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8001fd:	84 c0                	test   %al,%al
  8001ff:	74 0f                	je     800210 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	05 18 da 01 00       	add    $0x1da18,%eax
  80020b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800214:	7e 0a                	jle    800220 <libmain+0x73>
		binaryname = argv[0];
  800216:	8b 45 0c             	mov    0xc(%ebp),%eax
  800219:	8b 00                	mov    (%eax),%eax
  80021b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 0c             	pushl  0xc(%ebp)
  800226:	ff 75 08             	pushl  0x8(%ebp)
  800229:	e8 0a fe ff ff       	call   800038 <_main>
  80022e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800231:	e8 1a 14 00 00       	call   801650 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 e4 1f 80 00       	push   $0x801fe4
  80023e:	e8 6d 03 00 00       	call   8005b0 <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800246:	a1 20 30 80 00       	mov    0x803020,%eax
  80024b:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800251:	a1 20 30 80 00       	mov    0x803020,%eax
  800256:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	52                   	push   %edx
  800260:	50                   	push   %eax
  800261:	68 0c 20 80 00       	push   $0x80200c
  800266:	e8 45 03 00 00       	call   8005b0 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80026e:	a1 20 30 80 00       	mov    0x803020,%eax
  800273:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800279:	a1 20 30 80 00       	mov    0x803020,%eax
  80027e:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800284:	a1 20 30 80 00       	mov    0x803020,%eax
  800289:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80028f:	51                   	push   %ecx
  800290:	52                   	push   %edx
  800291:	50                   	push   %eax
  800292:	68 34 20 80 00       	push   $0x802034
  800297:	e8 14 03 00 00       	call   8005b0 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029f:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a4:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	68 8c 20 80 00       	push   $0x80208c
  8002b3:	e8 f8 02 00 00       	call   8005b0 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 e4 1f 80 00       	push   $0x801fe4
  8002c3:	e8 e8 02 00 00       	call   8005b0 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002cb:	e8 9a 13 00 00       	call   80166a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002d0:	e8 19 00 00 00       	call   8002ee <exit>
}
  8002d5:	90                   	nop
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	6a 00                	push   $0x0
  8002e3:	e8 27 15 00 00       	call   80180f <sys_destroy_env>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <exit>:

void
exit(void)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f4:	e8 7c 15 00 00       	call   801875 <sys_exit_env>
}
  8002f9:	90                   	nop
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    

008002fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800302:	8d 45 10             	lea    0x10(%ebp),%eax
  800305:	83 c0 04             	add    $0x4,%eax
  800308:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030b:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800310:	85 c0                	test   %eax,%eax
  800312:	74 16                	je     80032a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800314:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	50                   	push   %eax
  80031d:	68 a0 20 80 00       	push   $0x8020a0
  800322:	e8 89 02 00 00       	call   8005b0 <cprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80032a:	a1 00 30 80 00       	mov    0x803000,%eax
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	50                   	push   %eax
  800336:	68 a5 20 80 00       	push   $0x8020a5
  80033b:	e8 70 02 00 00       	call   8005b0 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800343:	8b 45 10             	mov    0x10(%ebp),%eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	ff 75 f4             	pushl  -0xc(%ebp)
  80034c:	50                   	push   %eax
  80034d:	e8 f3 01 00 00       	call   800545 <vcprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	6a 00                	push   $0x0
  80035a:	68 c1 20 80 00       	push   $0x8020c1
  80035f:	e8 e1 01 00 00       	call   800545 <vcprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800367:	e8 82 ff ff ff       	call   8002ee <exit>

	// should not return here
	while (1) ;
  80036c:	eb fe                	jmp    80036c <_panic+0x70>

0080036e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800374:	a1 20 30 80 00       	mov    0x803020,%eax
  800379:	8b 50 74             	mov    0x74(%eax),%edx
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037f:	39 c2                	cmp    %eax,%edx
  800381:	74 14                	je     800397 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800383:	83 ec 04             	sub    $0x4,%esp
  800386:	68 c4 20 80 00       	push   $0x8020c4
  80038b:	6a 26                	push   $0x26
  80038d:	68 10 21 80 00       	push   $0x802110
  800392:	e8 65 ff ff ff       	call   8002fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a5:	e9 c2 00 00 00       	jmp    80046c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	75 08                	jne    8003c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c2:	e9 a2 00 00 00       	jmp    800469 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d5:	eb 69                	jmp    800440 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e5:	89 d0                	mov    %edx,%eax
  8003e7:	01 c0                	add    %eax,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	c1 e0 03             	shl    $0x3,%eax
  8003ee:	01 c8                	add    %ecx,%eax
  8003f0:	8a 40 04             	mov    0x4(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	75 46                	jne    80043d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800405:	89 d0                	mov    %edx,%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	c1 e0 03             	shl    $0x3,%eax
  80040e:	01 c8                	add    %ecx,%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800422:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	39 c2                	cmp    %eax,%edx
  800432:	75 09                	jne    80043d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800434:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043b:	eb 12                	jmp    80044f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	ff 45 e8             	incl   -0x18(%ebp)
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 50 74             	mov    0x74(%eax),%edx
  800448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044b:	39 c2                	cmp    %eax,%edx
  80044d:	77 88                	ja     8003d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80044f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800453:	75 14                	jne    800469 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 1c 21 80 00       	push   $0x80211c
  80045d:	6a 3a                	push   $0x3a
  80045f:	68 10 21 80 00       	push   $0x802110
  800464:	e8 93 fe ff ff       	call   8002fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800469:	ff 45 f0             	incl   -0x10(%ebp)
  80046c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800472:	0f 8c 32 ff ff ff    	jl     8003aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800478:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800486:	eb 26                	jmp    8004ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800488:	a1 20 30 80 00       	mov    0x803020,%eax
  80048d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800493:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 03             	shl    $0x3,%eax
  80049f:	01 c8                	add    %ecx,%eax
  8004a1:	8a 40 04             	mov    0x4(%eax),%al
  8004a4:	3c 01                	cmp    $0x1,%al
  8004a6:	75 03                	jne    8004ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e0             	incl   -0x20(%ebp)
  8004ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 cb                	ja     800488 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c3:	74 14                	je     8004d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004c5:	83 ec 04             	sub    $0x4,%esp
  8004c8:	68 70 21 80 00       	push   $0x802170
  8004cd:	6a 44                	push   $0x44
  8004cf:	68 10 21 80 00       	push   $0x802110
  8004d4:	e8 23 fe ff ff       	call   8002fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d9:	90                   	nop
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	89 0a                	mov    %ecx,(%edx)
  8004ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f2:	88 d1                	mov    %dl,%cl
  8004f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	3d ff 00 00 00       	cmp    $0xff,%eax
  800505:	75 2c                	jne    800533 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800507:	a0 24 30 80 00       	mov    0x803024,%al
  80050c:	0f b6 c0             	movzbl %al,%eax
  80050f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800512:	8b 12                	mov    (%edx),%edx
  800514:	89 d1                	mov    %edx,%ecx
  800516:	8b 55 0c             	mov    0xc(%ebp),%edx
  800519:	83 c2 08             	add    $0x8,%edx
  80051c:	83 ec 04             	sub    $0x4,%esp
  80051f:	50                   	push   %eax
  800520:	51                   	push   %ecx
  800521:	52                   	push   %edx
  800522:	e8 7b 0f 00 00       	call   8014a2 <sys_cputs>
  800527:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	8b 40 04             	mov    0x4(%eax),%eax
  800539:	8d 50 01             	lea    0x1(%eax),%edx
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800542:	90                   	nop
  800543:	c9                   	leave  
  800544:	c3                   	ret    

00800545 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80054e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800555:	00 00 00 
	b.cnt = 0;
  800558:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80055f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	ff 75 08             	pushl  0x8(%ebp)
  800568:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056e:	50                   	push   %eax
  80056f:	68 dc 04 80 00       	push   $0x8004dc
  800574:	e8 11 02 00 00       	call   80078a <vprintfmt>
  800579:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80057c:	a0 24 30 80 00       	mov    0x803024,%al
  800581:	0f b6 c0             	movzbl %al,%eax
  800584:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	52                   	push   %edx
  80058f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800595:	83 c0 08             	add    $0x8,%eax
  800598:	50                   	push   %eax
  800599:	e8 04 0f 00 00       	call   8014a2 <sys_cputs>
  80059e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ae:	c9                   	leave  
  8005af:	c3                   	ret    

008005b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b6:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 73 ff ff ff       	call   800545 <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005db:	c9                   	leave  
  8005dc:	c3                   	ret    

008005dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005e3:	e8 68 10 00 00       	call   801650 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	e8 48 ff ff ff       	call   800545 <vcprintf>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800603:	e8 62 10 00 00       	call   80166a <sys_enable_interrupt>
	return cnt;
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    

0080060d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	53                   	push   %ebx
  800611:	83 ec 14             	sub    $0x14,%esp
  800614:	8b 45 10             	mov    0x10(%ebp),%eax
  800617:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800620:	8b 45 18             	mov    0x18(%ebp),%eax
  800623:	ba 00 00 00 00       	mov    $0x0,%edx
  800628:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062b:	77 55                	ja     800682 <printnum+0x75>
  80062d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800630:	72 05                	jb     800637 <printnum+0x2a>
  800632:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800635:	77 4b                	ja     800682 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800637:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80063a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80063d:	8b 45 18             	mov    0x18(%ebp),%eax
  800640:	ba 00 00 00 00       	mov    $0x0,%edx
  800645:	52                   	push   %edx
  800646:	50                   	push   %eax
  800647:	ff 75 f4             	pushl  -0xc(%ebp)
  80064a:	ff 75 f0             	pushl  -0x10(%ebp)
  80064d:	e8 3a 15 00 00       	call   801b8c <__udivdi3>
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	ff 75 20             	pushl  0x20(%ebp)
  80065b:	53                   	push   %ebx
  80065c:	ff 75 18             	pushl  0x18(%ebp)
  80065f:	52                   	push   %edx
  800660:	50                   	push   %eax
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 08             	pushl  0x8(%ebp)
  800667:	e8 a1 ff ff ff       	call   80060d <printnum>
  80066c:	83 c4 20             	add    $0x20,%esp
  80066f:	eb 1a                	jmp    80068b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 20             	pushl  0x20(%ebp)
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	ff d0                	call   *%eax
  80067f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800682:	ff 4d 1c             	decl   0x1c(%ebp)
  800685:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800689:	7f e6                	jg     800671 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80068e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800699:	53                   	push   %ebx
  80069a:	51                   	push   %ecx
  80069b:	52                   	push   %edx
  80069c:	50                   	push   %eax
  80069d:	e8 fa 15 00 00       	call   801c9c <__umoddi3>
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	05 d4 23 80 00       	add    $0x8023d4,%eax
  8006aa:	8a 00                	mov    (%eax),%al
  8006ac:	0f be c0             	movsbl %al,%eax
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	50                   	push   %eax
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	ff d0                	call   *%eax
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cb:	7e 1c                	jle    8006e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006e7:	eb 40                	jmp    800729 <getuint+0x65>
	else if (lflag)
  8006e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ed:	74 1e                	je     80070d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	8d 50 04             	lea    0x4(%eax),%edx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	89 10                	mov    %edx,(%eax)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	ba 00 00 00 00       	mov    $0x0,%edx
  80070b:	eb 1c                	jmp    800729 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 04             	sub    $0x4,%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800729:	5d                   	pop    %ebp
  80072a:	c3                   	ret    

0080072b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800732:	7e 1c                	jle    800750 <getint+0x25>
		return va_arg(*ap, long long);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	8d 50 08             	lea    0x8(%eax),%edx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	89 10                	mov    %edx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 e8 08             	sub    $0x8,%eax
  800749:	8b 50 04             	mov    0x4(%eax),%edx
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	eb 38                	jmp    800788 <getint+0x5d>
	else if (lflag)
  800750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800754:	74 1a                	je     800770 <getint+0x45>
		return va_arg(*ap, long);
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	8d 50 04             	lea    0x4(%eax),%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	89 10                	mov    %edx,(%eax)
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	83 e8 04             	sub    $0x4,%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	99                   	cltd   
  80076e:	eb 18                	jmp    800788 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	8d 50 04             	lea    0x4(%eax),%edx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	89 10                	mov    %edx,(%eax)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	99                   	cltd   
}
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	56                   	push   %esi
  80078e:	53                   	push   %ebx
  80078f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800792:	eb 17                	jmp    8007ab <vprintfmt+0x21>
			if (ch == '\0')
  800794:	85 db                	test   %ebx,%ebx
  800796:	0f 84 af 03 00 00    	je     800b4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	53                   	push   %ebx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8d 50 01             	lea    0x1(%eax),%edx
  8007b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b4:	8a 00                	mov    (%eax),%al
  8007b6:	0f b6 d8             	movzbl %al,%ebx
  8007b9:	83 fb 25             	cmp    $0x25,%ebx
  8007bc:	75 d6                	jne    800794 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8d 50 01             	lea    0x1(%eax),%edx
  8007e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e7:	8a 00                	mov    (%eax),%al
  8007e9:	0f b6 d8             	movzbl %al,%ebx
  8007ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007ef:	83 f8 55             	cmp    $0x55,%eax
  8007f2:	0f 87 2b 03 00 00    	ja     800b23 <vprintfmt+0x399>
  8007f8:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8007ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800801:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800805:	eb d7                	jmp    8007de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800807:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80080b:	eb d1                	jmp    8007de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800814:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800817:	89 d0                	mov    %edx,%eax
  800819:	c1 e0 02             	shl    $0x2,%eax
  80081c:	01 d0                	add    %edx,%eax
  80081e:	01 c0                	add    %eax,%eax
  800820:	01 d8                	add    %ebx,%eax
  800822:	83 e8 30             	sub    $0x30,%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800828:	8b 45 10             	mov    0x10(%ebp),%eax
  80082b:	8a 00                	mov    (%eax),%al
  80082d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800830:	83 fb 2f             	cmp    $0x2f,%ebx
  800833:	7e 3e                	jle    800873 <vprintfmt+0xe9>
  800835:	83 fb 39             	cmp    $0x39,%ebx
  800838:	7f 39                	jg     800873 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80083d:	eb d5                	jmp    800814 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 e8 04             	sub    $0x4,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800853:	eb 1f                	jmp    800874 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800859:	79 83                	jns    8007de <vprintfmt+0x54>
				width = 0;
  80085b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800862:	e9 77 ff ff ff       	jmp    8007de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800867:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80086e:	e9 6b ff ff ff       	jmp    8007de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800873:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800874:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800878:	0f 89 60 ff ff ff    	jns    8007de <vprintfmt+0x54>
				width = precision, precision = -1;
  80087e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800884:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80088b:	e9 4e ff ff ff       	jmp    8007de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800890:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800893:	e9 46 ff ff ff       	jmp    8007de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 c0 04             	add    $0x4,%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 e8 04             	sub    $0x4,%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
			break;
  8008b8:	e9 89 02 00 00       	jmp    800b46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	83 e8 04             	sub    $0x4,%eax
  8008cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ce:	85 db                	test   %ebx,%ebx
  8008d0:	79 02                	jns    8008d4 <vprintfmt+0x14a>
				err = -err;
  8008d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d4:	83 fb 64             	cmp    $0x64,%ebx
  8008d7:	7f 0b                	jg     8008e4 <vprintfmt+0x15a>
  8008d9:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 19                	jne    8008fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e4:	53                   	push   %ebx
  8008e5:	68 e5 23 80 00       	push   $0x8023e5
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 5e 02 00 00       	call   800b53 <printfmt>
  8008f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008f8:	e9 49 02 00 00       	jmp    800b46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008fd:	56                   	push   %esi
  8008fe:	68 ee 23 80 00       	push   $0x8023ee
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 45 02 00 00       	call   800b53 <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			break;
  800911:	e9 30 02 00 00       	jmp    800b46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	83 e8 04             	sub    $0x4,%eax
  800925:	8b 30                	mov    (%eax),%esi
  800927:	85 f6                	test   %esi,%esi
  800929:	75 05                	jne    800930 <vprintfmt+0x1a6>
				p = "(null)";
  80092b:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800930:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800934:	7e 6d                	jle    8009a3 <vprintfmt+0x219>
  800936:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80093a:	74 67                	je     8009a3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	50                   	push   %eax
  800943:	56                   	push   %esi
  800944:	e8 0c 03 00 00       	call   800c55 <strnlen>
  800949:	83 c4 10             	add    $0x10,%esp
  80094c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80094f:	eb 16                	jmp    800967 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800951:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	50                   	push   %eax
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800964:	ff 4d e4             	decl   -0x1c(%ebp)
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	7f e4                	jg     800951 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096d:	eb 34                	jmp    8009a3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80096f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800973:	74 1c                	je     800991 <vprintfmt+0x207>
  800975:	83 fb 1f             	cmp    $0x1f,%ebx
  800978:	7e 05                	jle    80097f <vprintfmt+0x1f5>
  80097a:	83 fb 7e             	cmp    $0x7e,%ebx
  80097d:	7e 12                	jle    800991 <vprintfmt+0x207>
					putch('?', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	6a 3f                	push   $0x3f
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	eb 0f                	jmp    8009a0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	53                   	push   %ebx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a3:	89 f0                	mov    %esi,%eax
  8009a5:	8d 70 01             	lea    0x1(%eax),%esi
  8009a8:	8a 00                	mov    (%eax),%al
  8009aa:	0f be d8             	movsbl %al,%ebx
  8009ad:	85 db                	test   %ebx,%ebx
  8009af:	74 24                	je     8009d5 <vprintfmt+0x24b>
  8009b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b5:	78 b8                	js     80096f <vprintfmt+0x1e5>
  8009b7:	ff 4d e0             	decl   -0x20(%ebp)
  8009ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009be:	79 af                	jns    80096f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c0:	eb 13                	jmp    8009d5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	6a 20                	push   $0x20
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e7                	jg     8009c2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009db:	e9 66 01 00 00       	jmp    800b46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 3c fd ff ff       	call   80072b <getint>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009fe:	85 d2                	test   %edx,%edx
  800a00:	79 23                	jns    800a25 <vprintfmt+0x29b>
				putch('-', putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	6a 2d                	push   $0x2d
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a18:	f7 d8                	neg    %eax
  800a1a:	83 d2 00             	adc    $0x0,%edx
  800a1d:	f7 da                	neg    %edx
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2c:	e9 bc 00 00 00       	jmp    800aed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 e8             	pushl  -0x18(%ebp)
  800a37:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3a:	50                   	push   %eax
  800a3b:	e8 84 fc ff ff       	call   8006c4 <getuint>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a50:	e9 98 00 00 00       	jmp    800aed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	6a 58                	push   $0x58
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	6a 58                	push   $0x58
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	6a 58                	push   $0x58
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
			break;
  800a85:	e9 bc 00 00 00       	jmp    800b46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 30                	push   $0x30
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 78                	push   $0x78
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 c0 04             	add    $0x4,%eax
  800ab0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 e8 04             	sub    $0x4,%eax
  800ab9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ac5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800acc:	eb 1f                	jmp    800aed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 e7 fb ff ff       	call   8006c4 <getuint>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	52                   	push   %edx
  800af8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 f4             	pushl  -0xc(%ebp)
  800aff:	ff 75 f0             	pushl  -0x10(%ebp)
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 00 fb ff ff       	call   80060d <printnum>
  800b0d:	83 c4 20             	add    $0x20,%esp
			break;
  800b10:	eb 34                	jmp    800b46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b12:	83 ec 08             	sub    $0x8,%esp
  800b15:	ff 75 0c             	pushl  0xc(%ebp)
  800b18:	53                   	push   %ebx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
			break;
  800b21:	eb 23                	jmp    800b46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	6a 25                	push   $0x25
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b33:	ff 4d 10             	decl   0x10(%ebp)
  800b36:	eb 03                	jmp    800b3b <vprintfmt+0x3b1>
  800b38:	ff 4d 10             	decl   0x10(%ebp)
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	48                   	dec    %eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	3c 25                	cmp    $0x25,%al
  800b43:	75 f3                	jne    800b38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b45:	90                   	nop
		}
	}
  800b46:	e9 47 fc ff ff       	jmp    800792 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b59:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5c:	83 c0 04             	add    $0x4,%eax
  800b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	ff 75 f4             	pushl  -0xc(%ebp)
  800b68:	50                   	push   %eax
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	ff 75 08             	pushl  0x8(%ebp)
  800b6f:	e8 16 fc ff ff       	call   80078a <vprintfmt>
  800b74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b77:	90                   	nop
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8b 40 08             	mov    0x8(%eax),%eax
  800b83:	8d 50 01             	lea    0x1(%eax),%edx
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8f:	8b 10                	mov    (%eax),%edx
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 40 04             	mov    0x4(%eax),%eax
  800b97:	39 c2                	cmp    %eax,%edx
  800b99:	73 12                	jae    800bad <sprintputch+0x33>
		*b->buf++ = ch;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba6:	89 0a                	mov    %ecx,(%edx)
  800ba8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bab:	88 10                	mov    %dl,(%eax)
}
  800bad:	90                   	nop
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bd5:	74 06                	je     800bdd <vsnprintf+0x2d>
  800bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdb:	7f 07                	jg     800be4 <vsnprintf+0x34>
		return -E_INVAL;
  800bdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800be2:	eb 20                	jmp    800c04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be4:	ff 75 14             	pushl  0x14(%ebp)
  800be7:	ff 75 10             	pushl  0x10(%ebp)
  800bea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bed:	50                   	push   %eax
  800bee:	68 7a 0b 80 00       	push   $0x800b7a
  800bf3:	e8 92 fb ff ff       	call   80078a <vprintfmt>
  800bf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0f:	83 c0 04             	add    $0x4,%eax
  800c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c15:	8b 45 10             	mov    0x10(%ebp),%eax
  800c18:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1b:	50                   	push   %eax
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	ff 75 08             	pushl  0x8(%ebp)
  800c22:	e8 89 ff ff ff       	call   800bb0 <vsnprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3f:	eb 06                	jmp    800c47 <strlen+0x15>
		n++;
  800c41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c44:	ff 45 08             	incl   0x8(%ebp)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	75 f1                	jne    800c41 <strlen+0xf>
		n++;
	return n;
  800c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c62:	eb 09                	jmp    800c6d <strnlen+0x18>
		n++;
  800c64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c67:	ff 45 08             	incl   0x8(%ebp)
  800c6a:	ff 4d 0c             	decl   0xc(%ebp)
  800c6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c71:	74 09                	je     800c7c <strnlen+0x27>
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e8                	jne    800c64 <strnlen+0xf>
		n++;
	return n;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c8d:	90                   	nop
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca0:	8a 12                	mov    (%edx),%dl
  800ca2:	88 10                	mov    %dl,(%eax)
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	84 c0                	test   %al,%al
  800ca8:	75 e4                	jne    800c8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc2:	eb 1f                	jmp    800ce3 <strncpy+0x34>
		*dst++ = *src;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8d 50 01             	lea    0x1(%eax),%edx
  800cca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	74 03                	je     800ce0 <strncpy+0x31>
			src++;
  800cdd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce0:	ff 45 fc             	incl   -0x4(%ebp)
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ce9:	72 d9                	jb     800cc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ceb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d00:	74 30                	je     800d32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d02:	eb 16                	jmp    800d1a <strlcpy+0x2a>
			*dst++ = *src++;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d16:	8a 12                	mov    (%edx),%dl
  800d18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d1a:	ff 4d 10             	decl   0x10(%ebp)
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 09                	je     800d2c <strlcpy+0x3c>
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 d8                	jne    800d04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d38:	29 c2                	sub    %eax,%edx
  800d3a:	89 d0                	mov    %edx,%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d41:	eb 06                	jmp    800d49 <strcmp+0xb>
		p++, q++;
  800d43:	ff 45 08             	incl   0x8(%ebp)
  800d46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 0e                	je     800d60 <strcmp+0x22>
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 10                	mov    (%eax),%dl
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	38 c2                	cmp    %al,%dl
  800d5e:	74 e3                	je     800d43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	0f b6 d0             	movzbl %al,%edx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 c0             	movzbl %al,%eax
  800d70:	29 c2                	sub    %eax,%edx
  800d72:	89 d0                	mov    %edx,%eax
}
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d79:	eb 09                	jmp    800d84 <strncmp+0xe>
		n--, p++, q++;
  800d7b:	ff 4d 10             	decl   0x10(%ebp)
  800d7e:	ff 45 08             	incl   0x8(%ebp)
  800d81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d88:	74 17                	je     800da1 <strncmp+0x2b>
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 0e                	je     800da1 <strncmp+0x2b>
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 10                	mov    (%eax),%dl
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	38 c2                	cmp    %al,%dl
  800d9f:	74 da                	je     800d7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da5:	75 07                	jne    800dae <strncmp+0x38>
		return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dac:	eb 14                	jmp    800dc2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	0f b6 d0             	movzbl %al,%edx
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 c0             	movzbl %al,%eax
  800dbe:	29 c2                	sub    %eax,%edx
  800dc0:	89 d0                	mov    %edx,%eax
}
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 04             	sub    $0x4,%esp
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd0:	eb 12                	jmp    800de4 <strchr+0x20>
		if (*s == c)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dda:	75 05                	jne    800de1 <strchr+0x1d>
			return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	eb 11                	jmp    800df2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 e5                	jne    800dd2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 04             	sub    $0x4,%esp
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e00:	eb 0d                	jmp    800e0f <strfind+0x1b>
		if (*s == c)
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0a:	74 0e                	je     800e1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	84 c0                	test   %al,%al
  800e16:	75 ea                	jne    800e02 <strfind+0xe>
  800e18:	eb 01                	jmp    800e1b <strfind+0x27>
		if (*s == c)
			break;
  800e1a:	90                   	nop
	return (char *) s;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e32:	eb 0e                	jmp    800e42 <memset+0x22>
		*p++ = c;
  800e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e37:	8d 50 01             	lea    0x1(%eax),%edx
  800e3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e42:	ff 4d f8             	decl   -0x8(%ebp)
  800e45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e49:	79 e9                	jns    800e34 <memset+0x14>
		*p++ = c;

	return v;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e62:	eb 16                	jmp    800e7a <memcpy+0x2a>
		*d++ = *s++;
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e76:	8a 12                	mov    (%edx),%dl
  800e78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e80:	89 55 10             	mov    %edx,0x10(%ebp)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	75 dd                	jne    800e64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea4:	73 50                	jae    800ef6 <memmove+0x6a>
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eac:	01 d0                	add    %edx,%eax
  800eae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eb1:	76 43                	jbe    800ef6 <memmove+0x6a>
		s += n;
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ebf:	eb 10                	jmp    800ed1 <memmove+0x45>
			*--d = *--s;
  800ec1:	ff 4d f8             	decl   -0x8(%ebp)
  800ec4:	ff 4d fc             	decl   -0x4(%ebp)
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eca:	8a 10                	mov    (%eax),%dl
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eda:	85 c0                	test   %eax,%eax
  800edc:	75 e3                	jne    800ec1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ede:	eb 23                	jmp    800f03 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee3:	8d 50 01             	lea    0x1(%eax),%edx
  800ee6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef2:	8a 12                	mov    (%edx),%dl
  800ef4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efc:	89 55 10             	mov    %edx,0x10(%ebp)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	75 dd                	jne    800ee0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f1a:	eb 2a                	jmp    800f46 <memcmp+0x3e>
		if (*s1 != *s2)
  800f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1f:	8a 10                	mov    (%eax),%dl
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	38 c2                	cmp    %al,%dl
  800f28:	74 16                	je     800f40 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f b6 d0             	movzbl %al,%edx
  800f32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f b6 c0             	movzbl %al,%eax
  800f3a:	29 c2                	sub    %eax,%edx
  800f3c:	89 d0                	mov    %edx,%eax
  800f3e:	eb 18                	jmp    800f58 <memcmp+0x50>
		s1++, s2++;
  800f40:	ff 45 fc             	incl   -0x4(%ebp)
  800f43:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	75 c9                	jne    800f1c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	01 d0                	add    %edx,%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f6b:	eb 15                	jmp    800f82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	0f b6 c0             	movzbl %al,%eax
  800f7b:	39 c2                	cmp    %eax,%edx
  800f7d:	74 0d                	je     800f8c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f7f:	ff 45 08             	incl   0x8(%ebp)
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f88:	72 e3                	jb     800f6d <memfind+0x13>
  800f8a:	eb 01                	jmp    800f8d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f8c:	90                   	nop
	return (void *) s;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa6:	eb 03                	jmp    800fab <strtol+0x19>
		s++;
  800fa8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 20                	cmp    $0x20,%al
  800fb2:	74 f4                	je     800fa8 <strtol+0x16>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	3c 09                	cmp    $0x9,%al
  800fbb:	74 eb                	je     800fa8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	3c 2b                	cmp    $0x2b,%al
  800fc4:	75 05                	jne    800fcb <strtol+0x39>
		s++;
  800fc6:	ff 45 08             	incl   0x8(%ebp)
  800fc9:	eb 13                	jmp    800fde <strtol+0x4c>
	else if (*s == '-')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 2d                	cmp    $0x2d,%al
  800fd2:	75 0a                	jne    800fde <strtol+0x4c>
		s++, neg = 1;
  800fd4:	ff 45 08             	incl   0x8(%ebp)
  800fd7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe2:	74 06                	je     800fea <strtol+0x58>
  800fe4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fe8:	75 20                	jne    80100a <strtol+0x78>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 30                	cmp    $0x30,%al
  800ff1:	75 17                	jne    80100a <strtol+0x78>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	40                   	inc    %eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 78                	cmp    $0x78,%al
  800ffb:	75 0d                	jne    80100a <strtol+0x78>
		s += 2, base = 16;
  800ffd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801001:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801008:	eb 28                	jmp    801032 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80100a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100e:	75 15                	jne    801025 <strtol+0x93>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 30                	cmp    $0x30,%al
  801017:	75 0c                	jne    801025 <strtol+0x93>
		s++, base = 8;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801023:	eb 0d                	jmp    801032 <strtol+0xa0>
	else if (base == 0)
  801025:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801029:	75 07                	jne    801032 <strtol+0xa0>
		base = 10;
  80102b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 2f                	cmp    $0x2f,%al
  801039:	7e 19                	jle    801054 <strtol+0xc2>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 39                	cmp    $0x39,%al
  801042:	7f 10                	jg     801054 <strtol+0xc2>
			dig = *s - '0';
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 30             	sub    $0x30,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801052:	eb 42                	jmp    801096 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 60                	cmp    $0x60,%al
  80105b:	7e 19                	jle    801076 <strtol+0xe4>
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 7a                	cmp    $0x7a,%al
  801064:	7f 10                	jg     801076 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	0f be c0             	movsbl %al,%eax
  80106e:	83 e8 57             	sub    $0x57,%eax
  801071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801074:	eb 20                	jmp    801096 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 40                	cmp    $0x40,%al
  80107d:	7e 39                	jle    8010b8 <strtol+0x126>
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 5a                	cmp    $0x5a,%al
  801086:	7f 30                	jg     8010b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	0f be c0             	movsbl %al,%eax
  801090:	83 e8 37             	sub    $0x37,%eax
  801093:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801099:	3b 45 10             	cmp    0x10(%ebp),%eax
  80109c:	7d 19                	jge    8010b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80109e:	ff 45 08             	incl   0x8(%ebp)
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010a8:	89 c2                	mov    %eax,%edx
  8010aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010b2:	e9 7b ff ff ff       	jmp    801032 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010bc:	74 08                	je     8010c6 <strtol+0x134>
		*endptr = (char *) s;
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ca:	74 07                	je     8010d3 <strtol+0x141>
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	f7 d8                	neg    %eax
  8010d1:	eb 03                	jmp    8010d6 <strtol+0x144>
  8010d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f0:	79 13                	jns    801105 <ltostr+0x2d>
	{
		neg = 1;
  8010f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801102:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80110d:	99                   	cltd   
  80110e:	f7 f9                	idiv   %ecx
  801110:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	8d 50 01             	lea    0x1(%eax),%edx
  801119:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801126:	83 c2 30             	add    $0x30,%edx
  801129:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80112b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801133:	f7 e9                	imul   %ecx
  801135:	c1 fa 02             	sar    $0x2,%edx
  801138:	89 c8                	mov    %ecx,%eax
  80113a:	c1 f8 1f             	sar    $0x1f,%eax
  80113d:	29 c2                	sub    %eax,%edx
  80113f:	89 d0                	mov    %edx,%eax
  801141:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	c1 e0 02             	shl    $0x2,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	01 c0                	add    %eax,%eax
  801161:	29 c1                	sub    %eax,%ecx
  801163:	89 ca                	mov    %ecx,%edx
  801165:	85 d2                	test   %edx,%edx
  801167:	75 9c                	jne    801105 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	48                   	dec    %eax
  801174:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801177:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117b:	74 3d                	je     8011ba <ltostr+0xe2>
		start = 1 ;
  80117d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801184:	eb 34                	jmp    8011ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 c2                	add    %eax,%edx
  80119b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 c8                	add    %ecx,%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8011b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c0:	7c c4                	jl     801186 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011cd:	90                   	nop
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011d6:	ff 75 08             	pushl  0x8(%ebp)
  8011d9:	e8 54 fa ff ff       	call   800c32 <strlen>
  8011de:	83 c4 04             	add    $0x4,%esp
  8011e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	e8 46 fa ff ff       	call   800c32 <strlen>
  8011ec:	83 c4 04             	add    $0x4,%esp
  8011ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801200:	eb 17                	jmp    801219 <strcconcat+0x49>
		final[s] = str1[s] ;
  801202:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	01 c2                	add    %eax,%edx
  80120a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	01 c8                	add    %ecx,%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801216:	ff 45 fc             	incl   -0x4(%ebp)
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80121f:	7c e1                	jl     801202 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801221:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801228:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80122f:	eb 1f                	jmp    801250 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801234:	8d 50 01             	lea    0x1(%eax),%edx
  801237:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	8b 45 10             	mov    0x10(%ebp),%eax
  80123f:	01 c2                	add    %eax,%edx
  801241:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	01 c8                	add    %ecx,%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80124d:	ff 45 f8             	incl   -0x8(%ebp)
  801250:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801253:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801256:	7c d9                	jl     801231 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801258:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	c6 00 00             	movb   $0x0,(%eax)
}
  801263:	90                   	nop
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801269:	8b 45 14             	mov    0x14(%ebp),%eax
  80126c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	8b 00                	mov    (%eax),%eax
  801277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801289:	eb 0c                	jmp    801297 <strsplit+0x31>
			*string++ = 0;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 08             	mov    %edx,0x8(%ebp)
  801294:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	84 c0                	test   %al,%al
  80129e:	74 18                	je     8012b8 <strsplit+0x52>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	0f be c0             	movsbl %al,%eax
  8012a8:	50                   	push   %eax
  8012a9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ac:	e8 13 fb ff ff       	call   800dc4 <strchr>
  8012b1:	83 c4 08             	add    $0x8,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	75 d3                	jne    80128b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 5a                	je     80131b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	83 f8 0f             	cmp    $0xf,%eax
  8012c9:	75 07                	jne    8012d2 <strsplit+0x6c>
		{
			return 0;
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	eb 66                	jmp    801338 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8012da:	8b 55 14             	mov    0x14(%ebp),%edx
  8012dd:	89 0a                	mov    %ecx,(%edx)
  8012df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e9:	01 c2                	add    %eax,%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f0:	eb 03                	jmp    8012f5 <strsplit+0x8f>
			string++;
  8012f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	84 c0                	test   %al,%al
  8012fc:	74 8b                	je     801289 <strsplit+0x23>
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f be c0             	movsbl %al,%eax
  801306:	50                   	push   %eax
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	e8 b5 fa ff ff       	call   800dc4 <strchr>
  80130f:	83 c4 08             	add    $0x8,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	74 dc                	je     8012f2 <strsplit+0x8c>
			string++;
	}
  801316:	e9 6e ff ff ff       	jmp    801289 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80131b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801333:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	68 50 25 80 00       	push   $0x802550
  801348:	6a 0e                	push   $0xe
  80134a:	68 8a 25 80 00       	push   $0x80258a
  80134f:	e8 a8 ef ff ff       	call   8002fc <_panic>

00801354 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80135a:	a1 04 30 80 00       	mov    0x803004,%eax
  80135f:	85 c0                	test   %eax,%eax
  801361:	74 0f                	je     801372 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801363:	e8 d2 ff ff ff       	call   80133a <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801368:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80136f:	00 00 00 
	}
	if (size == 0) return NULL ;
  801372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801376:	75 07                	jne    80137f <malloc+0x2b>
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	eb 14                	jmp    801393 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 98 25 80 00       	push   $0x802598
  801387:	6a 2e                	push   $0x2e
  801389:	68 8a 25 80 00       	push   $0x80258a
  80138e:	e8 69 ef ff ff       	call   8002fc <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	68 c0 25 80 00       	push   $0x8025c0
  8013a3:	6a 49                	push   $0x49
  8013a5:	68 8a 25 80 00       	push   $0x80258a
  8013aa:	e8 4d ef ff ff       	call   8002fc <_panic>

008013af <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 18             	sub    $0x18,%esp
  8013b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b8:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 e4 25 80 00       	push   $0x8025e4
  8013c3:	6a 57                	push   $0x57
  8013c5:	68 8a 25 80 00       	push   $0x80258a
  8013ca:	e8 2d ef ff ff       	call   8002fc <_panic>

008013cf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 0c 26 80 00       	push   $0x80260c
  8013dd:	6a 60                	push   $0x60
  8013df:	68 8a 25 80 00       	push   $0x80258a
  8013e4:	e8 13 ef ff ff       	call   8002fc <_panic>

008013e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	68 30 26 80 00       	push   $0x802630
  8013f7:	6a 7c                	push   $0x7c
  8013f9:	68 8a 25 80 00       	push   $0x80258a
  8013fe:	e8 f9 ee ff ff       	call   8002fc <_panic>

00801403 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	68 58 26 80 00       	push   $0x802658
  801411:	68 86 00 00 00       	push   $0x86
  801416:	68 8a 25 80 00       	push   $0x80258a
  80141b:	e8 dc ee ff ff       	call   8002fc <_panic>

00801420 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	68 7c 26 80 00       	push   $0x80267c
  80142e:	68 91 00 00 00       	push   $0x91
  801433:	68 8a 25 80 00       	push   $0x80258a
  801438:	e8 bf ee ff ff       	call   8002fc <_panic>

0080143d <shrink>:

}
void shrink(uint32 newSize)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801443:	83 ec 04             	sub    $0x4,%esp
  801446:	68 7c 26 80 00       	push   $0x80267c
  80144b:	68 96 00 00 00       	push   $0x96
  801450:	68 8a 25 80 00       	push   $0x80258a
  801455:	e8 a2 ee ff ff       	call   8002fc <_panic>

0080145a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801460:	83 ec 04             	sub    $0x4,%esp
  801463:	68 7c 26 80 00       	push   $0x80267c
  801468:	68 9b 00 00 00       	push   $0x9b
  80146d:	68 8a 25 80 00       	push   $0x80258a
  801472:	e8 85 ee ff ff       	call   8002fc <_panic>

00801477 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	57                   	push   %edi
  80147b:	56                   	push   %esi
  80147c:	53                   	push   %ebx
  80147d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801489:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80148f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801492:	cd 30                	int    $0x30
  801494:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	5b                   	pop    %ebx
  80149e:	5e                   	pop    %esi
  80149f:	5f                   	pop    %edi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	6a 00                	push   $0x0
  8014c0:	e8 b2 ff ff ff       	call   801477 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_cgetc>:

int
sys_cgetc(void)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 01                	push   $0x1
  8014da:	e8 98 ff ff ff       	call   801477 <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	52                   	push   %edx
  8014f4:	50                   	push   %eax
  8014f5:	6a 05                	push   $0x5
  8014f7:	e8 7b ff ff ff       	call   801477 <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801506:	8b 75 18             	mov    0x18(%ebp),%esi
  801509:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80150c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
  801517:	51                   	push   %ecx
  801518:	52                   	push   %edx
  801519:	50                   	push   %eax
  80151a:	6a 06                	push   $0x6
  80151c:	e8 56 ff ff ff       	call   801477 <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801527:	5b                   	pop    %ebx
  801528:	5e                   	pop    %esi
  801529:	5d                   	pop    %ebp
  80152a:	c3                   	ret    

0080152b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	52                   	push   %edx
  80153b:	50                   	push   %eax
  80153c:	6a 07                	push   $0x7
  80153e:	e8 34 ff ff ff       	call   801477 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	ff 75 0c             	pushl  0xc(%ebp)
  801554:	ff 75 08             	pushl  0x8(%ebp)
  801557:	6a 08                	push   $0x8
  801559:	e8 19 ff ff ff       	call   801477 <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 09                	push   $0x9
  801572:	e8 00 ff ff ff       	call   801477 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 0a                	push   $0xa
  80158b:	e8 e7 fe ff ff       	call   801477 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 0b                	push   $0xb
  8015a4:	e8 ce fe ff ff       	call   801477 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	ff 75 08             	pushl  0x8(%ebp)
  8015bd:	6a 0f                	push   $0xf
  8015bf:	e8 b3 fe ff ff       	call   801477 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
	return;
  8015c7:	90                   	nop
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	6a 10                	push   $0x10
  8015db:	e8 97 fe ff ff       	call   801477 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e3:	90                   	nop
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	ff 75 10             	pushl  0x10(%ebp)
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 11                	push   $0x11
  8015f8:	e8 7a fe ff ff       	call   801477 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801600:	90                   	nop
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 0c                	push   $0xc
  801612:	e8 60 fe ff ff       	call   801477 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	ff 75 08             	pushl  0x8(%ebp)
  80162a:	6a 0d                	push   $0xd
  80162c:	e8 46 fe ff ff       	call   801477 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 0e                	push   $0xe
  801645:	e8 2d fe ff ff       	call   801477 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 13                	push   $0x13
  80165f:	e8 13 fe ff ff       	call   801477 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 14                	push   $0x14
  801679:	e8 f9 fd ff ff       	call   801477 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_cputc>:


void
sys_cputc(const char c)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801690:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	50                   	push   %eax
  80169d:	6a 15                	push   $0x15
  80169f:	e8 d3 fd ff ff       	call   801477 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	90                   	nop
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 16                	push   $0x16
  8016b9:	e8 b9 fd ff ff       	call   801477 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	50                   	push   %eax
  8016d4:	6a 17                	push   $0x17
  8016d6:	e8 9c fd ff ff       	call   801477 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	52                   	push   %edx
  8016f0:	50                   	push   %eax
  8016f1:	6a 1a                	push   $0x1a
  8016f3:	e8 7f fd ff ff       	call   801477 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 18                	push   $0x18
  801710:	e8 62 fd ff ff       	call   801477 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	90                   	nop
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80171e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	6a 19                	push   $0x19
  80172e:	e8 44 fd ff ff       	call   801477 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801745:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801748:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	6a 00                	push   $0x0
  801751:	51                   	push   %ecx
  801752:	52                   	push   %edx
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	50                   	push   %eax
  801757:	6a 1b                	push   $0x1b
  801759:	e8 19 fd ff ff       	call   801477 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 1c                	push   $0x1c
  801776:	e8 fc fc ff ff       	call   801477 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801783:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	51                   	push   %ecx
  801791:	52                   	push   %edx
  801792:	50                   	push   %eax
  801793:	6a 1d                	push   $0x1d
  801795:	e8 dd fc ff ff       	call   801477 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 1e                	push   $0x1e
  8017b2:	e8 c0 fc ff ff       	call   801477 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 1f                	push   $0x1f
  8017cb:	e8 a7 fc ff ff       	call   801477 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	6a 00                	push   $0x0
  8017dd:	ff 75 14             	pushl  0x14(%ebp)
  8017e0:	ff 75 10             	pushl  0x10(%ebp)
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	50                   	push   %eax
  8017e7:	6a 20                	push   $0x20
  8017e9:	e8 89 fc ff ff       	call   801477 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	50                   	push   %eax
  801802:	6a 21                	push   $0x21
  801804:	e8 6e fc ff ff       	call   801477 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	90                   	nop
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	50                   	push   %eax
  80181e:	6a 22                	push   $0x22
  801820:	e8 52 fc ff ff       	call   801477 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 02                	push   $0x2
  801839:	e8 39 fc ff ff       	call   801477 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 03                	push   $0x3
  801852:	e8 20 fc ff ff       	call   801477 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 04                	push   $0x4
  80186b:	e8 07 fc ff ff       	call   801477 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_exit_env>:


void sys_exit_env(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 23                	push   $0x23
  801884:	e8 ee fb ff ff       	call   801477 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	90                   	nop
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801895:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801898:	8d 50 04             	lea    0x4(%eax),%edx
  80189b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	50                   	push   %eax
  8018a6:	6a 24                	push   $0x24
  8018a8:	e8 ca fb ff ff       	call   801477 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
	return result;
  8018b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b9:	89 01                	mov    %eax,(%ecx)
  8018bb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	c9                   	leave  
  8018c2:	c2 04 00             	ret    $0x4

008018c5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 10             	pushl  0x10(%ebp)
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 12                	push   $0x12
  8018d7:	e8 9b fb ff ff       	call   801477 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 25                	push   $0x25
  8018f1:	e8 81 fb ff ff       	call   801477 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801907:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	50                   	push   %eax
  801914:	6a 26                	push   $0x26
  801916:	e8 5c fb ff ff       	call   801477 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
	return ;
  80191e:	90                   	nop
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <rsttst>:
void rsttst()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 28                	push   $0x28
  801930:	e8 42 fb ff ff       	call   801477 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return ;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 14             	mov    0x14(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801947:	8b 55 18             	mov    0x18(%ebp),%edx
  80194a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194e:	52                   	push   %edx
  80194f:	50                   	push   %eax
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 27                	push   $0x27
  80195b:	e8 17 fb ff ff       	call   801477 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return ;
  801963:	90                   	nop
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <chktst>:
void chktst(uint32 n)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 29                	push   $0x29
  801976:	e8 fc fa ff ff       	call   801477 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return ;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <inctst>:

void inctst()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 2a                	push   $0x2a
  801990:	e8 e2 fa ff ff       	call   801477 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <gettst>:
uint32 gettst()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 2b                	push   $0x2b
  8019aa:	e8 c8 fa ff ff       	call   801477 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 2c                	push   $0x2c
  8019c6:	e8 ac fa ff ff       	call   801477 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
  8019ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019d1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019d5:	75 07                	jne    8019de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019dc:	eb 05                	jmp    8019e3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 2c                	push   $0x2c
  8019f7:	e8 7b fa ff ff       	call   801477 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a02:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a06:	75 07                	jne    801a0f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a08:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0d:	eb 05                	jmp    801a14 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 2c                	push   $0x2c
  801a28:	e8 4a fa ff ff       	call   801477 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
  801a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a33:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a37:	75 07                	jne    801a40 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	eb 05                	jmp    801a45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 2c                	push   $0x2c
  801a59:	e8 19 fa ff ff       	call   801477 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
  801a61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a64:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a68:	75 07                	jne    801a71 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6f:	eb 05                	jmp    801a76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 2d                	push   $0x2d
  801a88:	e8 ea f9 ff ff       	call   801477 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a97:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	53                   	push   %ebx
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 2e                	push   $0x2e
  801aab:	e8 c7 f9 ff ff       	call   801477 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 2f                	push   $0x2f
  801acb:	e8 a7 f9 ff ff       	call   801477 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801adb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	c1 e0 02             	shl    $0x2,%eax
  801ae3:	01 d0                	add    %edx,%eax
  801ae5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aec:	01 d0                	add    %edx,%eax
  801aee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af5:	01 d0                	add    %edx,%eax
  801af7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801afe:	01 d0                	add    %edx,%eax
  801b00:	c1 e0 04             	shl    $0x4,%eax
  801b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801b0d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	50                   	push   %eax
  801b14:	e8 76 fd ff ff       	call   80188f <sys_get_virtual_time>
  801b19:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801b1c:	eb 41                	jmp    801b5f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801b1e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	50                   	push   %eax
  801b25:	e8 65 fd ff ff       	call   80188f <sys_get_virtual_time>
  801b2a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b33:	29 c2                	sub    %eax,%edx
  801b35:	89 d0                	mov    %edx,%eax
  801b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b40:	89 d1                	mov    %edx,%ecx
  801b42:	29 c1                	sub    %eax,%ecx
  801b44:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4a:	39 c2                	cmp    %eax,%edx
  801b4c:	0f 97 c0             	seta   %al
  801b4f:	0f b6 c0             	movzbl %al,%eax
  801b52:	29 c1                	sub    %eax,%ecx
  801b54:	89 c8                	mov    %ecx,%eax
  801b56:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b65:	72 b7                	jb     801b1e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b77:	eb 03                	jmp    801b7c <busy_wait+0x12>
  801b79:	ff 45 fc             	incl   -0x4(%ebp)
  801b7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b82:	72 f5                	jb     801b79 <busy_wait+0xf>
	return i;
  801b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
  801b89:	66 90                	xchg   %ax,%ax
  801b8b:	90                   	nop

00801b8c <__udivdi3>:
  801b8c:	55                   	push   %ebp
  801b8d:	57                   	push   %edi
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 1c             	sub    $0x1c,%esp
  801b93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ba3:	89 ca                	mov    %ecx,%edx
  801ba5:	89 f8                	mov    %edi,%eax
  801ba7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bab:	85 f6                	test   %esi,%esi
  801bad:	75 2d                	jne    801bdc <__udivdi3+0x50>
  801baf:	39 cf                	cmp    %ecx,%edi
  801bb1:	77 65                	ja     801c18 <__udivdi3+0x8c>
  801bb3:	89 fd                	mov    %edi,%ebp
  801bb5:	85 ff                	test   %edi,%edi
  801bb7:	75 0b                	jne    801bc4 <__udivdi3+0x38>
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	31 d2                	xor    %edx,%edx
  801bc0:	f7 f7                	div    %edi
  801bc2:	89 c5                	mov    %eax,%ebp
  801bc4:	31 d2                	xor    %edx,%edx
  801bc6:	89 c8                	mov    %ecx,%eax
  801bc8:	f7 f5                	div    %ebp
  801bca:	89 c1                	mov    %eax,%ecx
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	f7 f5                	div    %ebp
  801bd0:	89 cf                	mov    %ecx,%edi
  801bd2:	89 fa                	mov    %edi,%edx
  801bd4:	83 c4 1c             	add    $0x1c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	39 ce                	cmp    %ecx,%esi
  801bde:	77 28                	ja     801c08 <__udivdi3+0x7c>
  801be0:	0f bd fe             	bsr    %esi,%edi
  801be3:	83 f7 1f             	xor    $0x1f,%edi
  801be6:	75 40                	jne    801c28 <__udivdi3+0x9c>
  801be8:	39 ce                	cmp    %ecx,%esi
  801bea:	72 0a                	jb     801bf6 <__udivdi3+0x6a>
  801bec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf0:	0f 87 9e 00 00 00    	ja     801c94 <__udivdi3+0x108>
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	89 fa                	mov    %edi,%edx
  801bfd:	83 c4 1c             	add    $0x1c,%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
  801c05:	8d 76 00             	lea    0x0(%esi),%esi
  801c08:	31 ff                	xor    %edi,%edi
  801c0a:	31 c0                	xor    %eax,%eax
  801c0c:	89 fa                	mov    %edi,%edx
  801c0e:	83 c4 1c             	add    $0x1c,%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5e                   	pop    %esi
  801c13:	5f                   	pop    %edi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    
  801c16:	66 90                	xchg   %ax,%ax
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	f7 f7                	div    %edi
  801c1c:	31 ff                	xor    %edi,%edi
  801c1e:	89 fa                	mov    %edi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c2d:	89 eb                	mov    %ebp,%ebx
  801c2f:	29 fb                	sub    %edi,%ebx
  801c31:	89 f9                	mov    %edi,%ecx
  801c33:	d3 e6                	shl    %cl,%esi
  801c35:	89 c5                	mov    %eax,%ebp
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 ed                	shr    %cl,%ebp
  801c3b:	89 e9                	mov    %ebp,%ecx
  801c3d:	09 f1                	or     %esi,%ecx
  801c3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c43:	89 f9                	mov    %edi,%ecx
  801c45:	d3 e0                	shl    %cl,%eax
  801c47:	89 c5                	mov    %eax,%ebp
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	88 d9                	mov    %bl,%cl
  801c4d:	d3 ee                	shr    %cl,%esi
  801c4f:	89 f9                	mov    %edi,%ecx
  801c51:	d3 e2                	shl    %cl,%edx
  801c53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c57:	88 d9                	mov    %bl,%cl
  801c59:	d3 e8                	shr    %cl,%eax
  801c5b:	09 c2                	or     %eax,%edx
  801c5d:	89 d0                	mov    %edx,%eax
  801c5f:	89 f2                	mov    %esi,%edx
  801c61:	f7 74 24 0c          	divl   0xc(%esp)
  801c65:	89 d6                	mov    %edx,%esi
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	f7 e5                	mul    %ebp
  801c6b:	39 d6                	cmp    %edx,%esi
  801c6d:	72 19                	jb     801c88 <__udivdi3+0xfc>
  801c6f:	74 0b                	je     801c7c <__udivdi3+0xf0>
  801c71:	89 d8                	mov    %ebx,%eax
  801c73:	31 ff                	xor    %edi,%edi
  801c75:	e9 58 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c80:	89 f9                	mov    %edi,%ecx
  801c82:	d3 e2                	shl    %cl,%edx
  801c84:	39 c2                	cmp    %eax,%edx
  801c86:	73 e9                	jae    801c71 <__udivdi3+0xe5>
  801c88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c8b:	31 ff                	xor    %edi,%edi
  801c8d:	e9 40 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	31 c0                	xor    %eax,%eax
  801c96:	e9 37 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c9b:	90                   	nop

00801c9c <__umoddi3>:
  801c9c:	55                   	push   %ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
  801ca3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801caf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cbb:	89 f3                	mov    %esi,%ebx
  801cbd:	89 fa                	mov    %edi,%edx
  801cbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc3:	89 34 24             	mov    %esi,(%esp)
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	75 1a                	jne    801ce4 <__umoddi3+0x48>
  801cca:	39 f7                	cmp    %esi,%edi
  801ccc:	0f 86 a2 00 00 00    	jbe    801d74 <__umoddi3+0xd8>
  801cd2:	89 c8                	mov    %ecx,%eax
  801cd4:	89 f2                	mov    %esi,%edx
  801cd6:	f7 f7                	div    %edi
  801cd8:	89 d0                	mov    %edx,%eax
  801cda:	31 d2                	xor    %edx,%edx
  801cdc:	83 c4 1c             	add    $0x1c,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    
  801ce4:	39 f0                	cmp    %esi,%eax
  801ce6:	0f 87 ac 00 00 00    	ja     801d98 <__umoddi3+0xfc>
  801cec:	0f bd e8             	bsr    %eax,%ebp
  801cef:	83 f5 1f             	xor    $0x1f,%ebp
  801cf2:	0f 84 ac 00 00 00    	je     801da4 <__umoddi3+0x108>
  801cf8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cfd:	29 ef                	sub    %ebp,%edi
  801cff:	89 fe                	mov    %edi,%esi
  801d01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d05:	89 e9                	mov    %ebp,%ecx
  801d07:	d3 e0                	shl    %cl,%eax
  801d09:	89 d7                	mov    %edx,%edi
  801d0b:	89 f1                	mov    %esi,%ecx
  801d0d:	d3 ef                	shr    %cl,%edi
  801d0f:	09 c7                	or     %eax,%edi
  801d11:	89 e9                	mov    %ebp,%ecx
  801d13:	d3 e2                	shl    %cl,%edx
  801d15:	89 14 24             	mov    %edx,(%esp)
  801d18:	89 d8                	mov    %ebx,%eax
  801d1a:	d3 e0                	shl    %cl,%eax
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d22:	d3 e0                	shl    %cl,%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2c:	89 f1                	mov    %esi,%ecx
  801d2e:	d3 e8                	shr    %cl,%eax
  801d30:	09 d0                	or     %edx,%eax
  801d32:	d3 eb                	shr    %cl,%ebx
  801d34:	89 da                	mov    %ebx,%edx
  801d36:	f7 f7                	div    %edi
  801d38:	89 d3                	mov    %edx,%ebx
  801d3a:	f7 24 24             	mull   (%esp)
  801d3d:	89 c6                	mov    %eax,%esi
  801d3f:	89 d1                	mov    %edx,%ecx
  801d41:	39 d3                	cmp    %edx,%ebx
  801d43:	0f 82 87 00 00 00    	jb     801dd0 <__umoddi3+0x134>
  801d49:	0f 84 91 00 00 00    	je     801de0 <__umoddi3+0x144>
  801d4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d53:	29 f2                	sub    %esi,%edx
  801d55:	19 cb                	sbb    %ecx,%ebx
  801d57:	89 d8                	mov    %ebx,%eax
  801d59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d5d:	d3 e0                	shl    %cl,%eax
  801d5f:	89 e9                	mov    %ebp,%ecx
  801d61:	d3 ea                	shr    %cl,%edx
  801d63:	09 d0                	or     %edx,%eax
  801d65:	89 e9                	mov    %ebp,%ecx
  801d67:	d3 eb                	shr    %cl,%ebx
  801d69:	89 da                	mov    %ebx,%edx
  801d6b:	83 c4 1c             	add    $0x1c,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5f                   	pop    %edi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    
  801d73:	90                   	nop
  801d74:	89 fd                	mov    %edi,%ebp
  801d76:	85 ff                	test   %edi,%edi
  801d78:	75 0b                	jne    801d85 <__umoddi3+0xe9>
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	31 d2                	xor    %edx,%edx
  801d81:	f7 f7                	div    %edi
  801d83:	89 c5                	mov    %eax,%ebp
  801d85:	89 f0                	mov    %esi,%eax
  801d87:	31 d2                	xor    %edx,%edx
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 c8                	mov    %ecx,%eax
  801d8d:	f7 f5                	div    %ebp
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	e9 44 ff ff ff       	jmp    801cda <__umoddi3+0x3e>
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	89 c8                	mov    %ecx,%eax
  801d9a:	89 f2                	mov    %esi,%edx
  801d9c:	83 c4 1c             	add    $0x1c,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    
  801da4:	3b 04 24             	cmp    (%esp),%eax
  801da7:	72 06                	jb     801daf <__umoddi3+0x113>
  801da9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dad:	77 0f                	ja     801dbe <__umoddi3+0x122>
  801daf:	89 f2                	mov    %esi,%edx
  801db1:	29 f9                	sub    %edi,%ecx
  801db3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db7:	89 14 24             	mov    %edx,(%esp)
  801dba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dc2:	8b 14 24             	mov    (%esp),%edx
  801dc5:	83 c4 1c             	add    $0x1c,%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5f                   	pop    %edi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    
  801dcd:	8d 76 00             	lea    0x0(%esi),%esi
  801dd0:	2b 04 24             	sub    (%esp),%eax
  801dd3:	19 fa                	sbb    %edi,%edx
  801dd5:	89 d1                	mov    %edx,%ecx
  801dd7:	89 c6                	mov    %eax,%esi
  801dd9:	e9 71 ff ff ff       	jmp    801d4f <__umoddi3+0xb3>
  801dde:	66 90                	xchg   %ax,%ax
  801de0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de4:	72 ea                	jb     801dd0 <__umoddi3+0x134>
  801de6:	89 d9                	mov    %ebx,%ecx
  801de8:	e9 62 ff ff ff       	jmp    801d4f <__umoddi3+0xb3>
