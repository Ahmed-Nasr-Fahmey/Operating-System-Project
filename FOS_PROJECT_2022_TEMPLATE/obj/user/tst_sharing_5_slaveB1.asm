
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
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
  80008c:	68 80 1d 80 00       	push   $0x801d80
  800091:	6a 12                	push   $0x12
  800093:	68 9c 1d 80 00       	push   $0x801d9c
  800098:	e8 ed 01 00 00       	call   80028a <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 48 17 00 00       	call   8017ea <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 b9 1d 80 00       	push   $0x801db9
  8000aa:	50                   	push   %eax
  8000ab:	e8 ad 12 00 00       	call   80135d <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 bc 1d 80 00       	push   $0x801dbc
  8000be:	e8 7b 04 00 00       	call   80053e <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 e4 1d 80 00       	push   $0x801de4
  8000ce:	e8 6b 04 00 00       	call   80053e <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 80 19 00 00       	call   801a63 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 06 14 00 00       	call   8014f1 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 98 12 00 00       	call   801391 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 04 1e 80 00       	push   $0x801e04
  800104:	e8 35 04 00 00       	call   80053e <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 e0 13 00 00       	call   8014f1 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 1c 1e 80 00       	push   $0x801e1c
  800127:	6a 20                	push   $0x20
  800129:	68 9c 1d 80 00       	push   $0x801d9c
  80012e:	e8 57 01 00 00       	call   80028a <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 d7 17 00 00       	call   80190f <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 8b 16 00 00       	call   8017d1 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	01 c0                	add    %eax,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800159:	01 c8                	add    %ecx,%eax
  80015b:	c1 e0 02             	shl    $0x2,%eax
  80015e:	01 d0                	add    %edx,%eax
  800160:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800167:	01 c8                	add    %ecx,%eax
  800169:	c1 e0 02             	shl    $0x2,%eax
  80016c:	01 d0                	add    %edx,%eax
  80016e:	c1 e0 02             	shl    $0x2,%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	c1 e0 03             	shl    $0x3,%eax
  800176:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800180:	a1 20 30 80 00       	mov    0x803020,%eax
  800185:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80018b:	84 c0                	test   %al,%al
  80018d:	74 0f                	je     80019e <libmain+0x63>
		binaryname = myEnv->prog_name;
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	05 18 da 01 00       	add    $0x1da18,%eax
  800199:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a2:	7e 0a                	jle    8001ae <libmain+0x73>
		binaryname = argv[0];
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	8b 00                	mov    (%eax),%eax
  8001a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	ff 75 0c             	pushl  0xc(%ebp)
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	e8 7c fe ff ff       	call   800038 <_main>
  8001bc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bf:	e8 1a 14 00 00       	call   8015de <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 dc 1e 80 00       	push   $0x801edc
  8001cc:	e8 6d 03 00 00       	call   80053e <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	52                   	push   %edx
  8001ee:	50                   	push   %eax
  8001ef:	68 04 1f 80 00       	push   $0x801f04
  8001f4:	e8 45 03 00 00       	call   80053e <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800207:	a1 20 30 80 00       	mov    0x803020,%eax
  80020c:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80021d:	51                   	push   %ecx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 2c 1f 80 00       	push   $0x801f2c
  800225:	e8 14 03 00 00       	call   80053e <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	50                   	push   %eax
  80023c:	68 84 1f 80 00       	push   $0x801f84
  800241:	e8 f8 02 00 00       	call   80053e <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 dc 1e 80 00       	push   $0x801edc
  800251:	e8 e8 02 00 00       	call   80053e <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800259:	e8 9a 13 00 00       	call   8015f8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80025e:	e8 19 00 00 00       	call   80027c <exit>
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	6a 00                	push   $0x0
  800271:	e8 27 15 00 00       	call   80179d <sys_destroy_env>
  800276:	83 c4 10             	add    $0x10,%esp
}
  800279:	90                   	nop
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <exit>:

void
exit(void)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800282:	e8 7c 15 00 00       	call   801803 <sys_exit_env>
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800290:	8d 45 10             	lea    0x10(%ebp),%eax
  800293:	83 c0 04             	add    $0x4,%eax
  800296:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800299:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80029e:	85 c0                	test   %eax,%eax
  8002a0:	74 16                	je     8002b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a2:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	50                   	push   %eax
  8002ab:	68 98 1f 80 00       	push   $0x801f98
  8002b0:	e8 89 02 00 00       	call   80053e <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b8:	a1 00 30 80 00       	mov    0x803000,%eax
  8002bd:	ff 75 0c             	pushl  0xc(%ebp)
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	50                   	push   %eax
  8002c4:	68 9d 1f 80 00       	push   $0x801f9d
  8002c9:	e8 70 02 00 00       	call   80053e <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002da:	50                   	push   %eax
  8002db:	e8 f3 01 00 00       	call   8004d3 <vcprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	6a 00                	push   $0x0
  8002e8:	68 b9 1f 80 00       	push   $0x801fb9
  8002ed:	e8 e1 01 00 00       	call   8004d3 <vcprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f5:	e8 82 ff ff ff       	call   80027c <exit>

	// should not return here
	while (1) ;
  8002fa:	eb fe                	jmp    8002fa <_panic+0x70>

008002fc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800302:	a1 20 30 80 00       	mov    0x803020,%eax
  800307:	8b 50 74             	mov    0x74(%eax),%edx
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	39 c2                	cmp    %eax,%edx
  80030f:	74 14                	je     800325 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800311:	83 ec 04             	sub    $0x4,%esp
  800314:	68 bc 1f 80 00       	push   $0x801fbc
  800319:	6a 26                	push   $0x26
  80031b:	68 08 20 80 00       	push   $0x802008
  800320:	e8 65 ff ff ff       	call   80028a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800333:	e9 c2 00 00 00       	jmp    8003fa <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	01 d0                	add    %edx,%eax
  800347:	8b 00                	mov    (%eax),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	75 08                	jne    800355 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800350:	e9 a2 00 00 00       	jmp    8003f7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800355:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800363:	eb 69                	jmp    8003ce <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800365:	a1 20 30 80 00       	mov    0x803020,%eax
  80036a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800373:	89 d0                	mov    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	c1 e0 03             	shl    $0x3,%eax
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	8a 40 04             	mov    0x4(%eax),%al
  800381:	84 c0                	test   %al,%al
  800383:	75 46                	jne    8003cb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800385:	a1 20 30 80 00       	mov    0x803020,%eax
  80038a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800393:	89 d0                	mov    %edx,%eax
  800395:	01 c0                	add    %eax,%eax
  800397:	01 d0                	add    %edx,%eax
  800399:	c1 e0 03             	shl    $0x3,%eax
  80039c:	01 c8                	add    %ecx,%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	01 c8                	add    %ecx,%eax
  8003bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	75 09                	jne    8003cb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c9:	eb 12                	jmp    8003dd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cb:	ff 45 e8             	incl   -0x18(%ebp)
  8003ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d3:	8b 50 74             	mov    0x74(%eax),%edx
  8003d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	77 88                	ja     800365 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e1:	75 14                	jne    8003f7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 14 20 80 00       	push   $0x802014
  8003eb:	6a 3a                	push   $0x3a
  8003ed:	68 08 20 80 00       	push   $0x802008
  8003f2:	e8 93 fe ff ff       	call   80028a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f7:	ff 45 f0             	incl   -0x10(%ebp)
  8003fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800400:	0f 8c 32 ff ff ff    	jl     800338 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800406:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800414:	eb 26                	jmp    80043c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800416:	a1 20 30 80 00       	mov    0x803020,%eax
  80041b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800421:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800424:	89 d0                	mov    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	c1 e0 03             	shl    $0x3,%eax
  80042d:	01 c8                	add    %ecx,%eax
  80042f:	8a 40 04             	mov    0x4(%eax),%al
  800432:	3c 01                	cmp    $0x1,%al
  800434:	75 03                	jne    800439 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800436:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	ff 45 e0             	incl   -0x20(%ebp)
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 50 74             	mov    0x74(%eax),%edx
  800444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800447:	39 c2                	cmp    %eax,%edx
  800449:	77 cb                	ja     800416 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80044b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800451:	74 14                	je     800467 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800453:	83 ec 04             	sub    $0x4,%esp
  800456:	68 68 20 80 00       	push   $0x802068
  80045b:	6a 44                	push   $0x44
  80045d:	68 08 20 80 00       	push   $0x802008
  800462:	e8 23 fe ff ff       	call   80028a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800467:	90                   	nop
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	8d 48 01             	lea    0x1(%eax),%ecx
  800478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047b:	89 0a                	mov    %ecx,(%edx)
  80047d:	8b 55 08             	mov    0x8(%ebp),%edx
  800480:	88 d1                	mov    %dl,%cl
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800493:	75 2c                	jne    8004c1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800495:	a0 24 30 80 00       	mov    0x803024,%al
  80049a:	0f b6 c0             	movzbl %al,%eax
  80049d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a0:	8b 12                	mov    (%edx),%edx
  8004a2:	89 d1                	mov    %edx,%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	83 c2 08             	add    $0x8,%edx
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	50                   	push   %eax
  8004ae:	51                   	push   %ecx
  8004af:	52                   	push   %edx
  8004b0:	e8 7b 0f 00 00       	call   801430 <sys_cputs>
  8004b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c4:	8b 40 04             	mov    0x4(%eax),%eax
  8004c7:	8d 50 01             	lea    0x1(%eax),%edx
  8004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d0:	90                   	nop
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e3:	00 00 00 
	b.cnt = 0;
  8004e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ed:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004fc:	50                   	push   %eax
  8004fd:	68 6a 04 80 00       	push   $0x80046a
  800502:	e8 11 02 00 00       	call   800718 <vprintfmt>
  800507:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80050a:	a0 24 30 80 00       	mov    0x803024,%al
  80050f:	0f b6 c0             	movzbl %al,%eax
  800512:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	50                   	push   %eax
  80051c:	52                   	push   %edx
  80051d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800523:	83 c0 08             	add    $0x8,%eax
  800526:	50                   	push   %eax
  800527:	e8 04 0f 00 00       	call   801430 <sys_cputs>
  80052c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800536:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80053c:	c9                   	leave  
  80053d:	c3                   	ret    

0080053e <cprintf>:

int cprintf(const char *fmt, ...) {
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800544:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80054b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	ff 75 f4             	pushl  -0xc(%ebp)
  80055a:	50                   	push   %eax
  80055b:	e8 73 ff ff ff       	call   8004d3 <vcprintf>
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800566:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800569:	c9                   	leave  
  80056a:	c3                   	ret    

0080056b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800571:	e8 68 10 00 00       	call   8015de <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800576:	8d 45 0c             	lea    0xc(%ebp),%eax
  800579:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	ff 75 f4             	pushl  -0xc(%ebp)
  800585:	50                   	push   %eax
  800586:	e8 48 ff ff ff       	call   8004d3 <vcprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800591:	e8 62 10 00 00       	call   8015f8 <sys_enable_interrupt>
	return cnt;
  800596:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	53                   	push   %ebx
  80059f:	83 ec 14             	sub    $0x14,%esp
  8005a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b9:	77 55                	ja     800610 <printnum+0x75>
  8005bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005be:	72 05                	jb     8005c5 <printnum+0x2a>
  8005c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c3:	77 4b                	ja     800610 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d3:	52                   	push   %edx
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8005db:	e8 38 15 00 00       	call   801b18 <__udivdi3>
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	83 ec 04             	sub    $0x4,%esp
  8005e6:	ff 75 20             	pushl  0x20(%ebp)
  8005e9:	53                   	push   %ebx
  8005ea:	ff 75 18             	pushl  0x18(%ebp)
  8005ed:	52                   	push   %edx
  8005ee:	50                   	push   %eax
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	e8 a1 ff ff ff       	call   80059b <printnum>
  8005fa:	83 c4 20             	add    $0x20,%esp
  8005fd:	eb 1a                	jmp    800619 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 20             	pushl  0x20(%ebp)
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	ff d0                	call   *%eax
  80060d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800610:	ff 4d 1c             	decl   0x1c(%ebp)
  800613:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800617:	7f e6                	jg     8005ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800619:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80061c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800627:	53                   	push   %ebx
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	50                   	push   %eax
  80062b:	e8 f8 15 00 00       	call   801c28 <__umoddi3>
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	05 d4 22 80 00       	add    $0x8022d4,%eax
  800638:	8a 00                	mov    (%eax),%al
  80063a:	0f be c0             	movsbl %al,%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
}
  80064c:	90                   	nop
  80064d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800650:	c9                   	leave  
  800651:	c3                   	ret    

00800652 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800655:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800659:	7e 1c                	jle    800677 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	8d 50 08             	lea    0x8(%eax),%edx
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	89 10                	mov    %edx,(%eax)
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	83 e8 08             	sub    $0x8,%eax
  800670:	8b 50 04             	mov    0x4(%eax),%edx
  800673:	8b 00                	mov    (%eax),%eax
  800675:	eb 40                	jmp    8006b7 <getuint+0x65>
	else if (lflag)
  800677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80067b:	74 1e                	je     80069b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	89 10                	mov    %edx,(%eax)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	83 e8 04             	sub    $0x4,%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	eb 1c                	jmp    8006b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	8d 50 04             	lea    0x4(%eax),%edx
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	89 10                	mov    %edx,(%eax)
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	83 e8 04             	sub    $0x4,%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b7:	5d                   	pop    %ebp
  8006b8:	c3                   	ret    

008006b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c0:	7e 1c                	jle    8006de <getint+0x25>
		return va_arg(*ap, long long);
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	8d 50 08             	lea    0x8(%eax),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 10                	mov    %edx,(%eax)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	83 e8 08             	sub    $0x8,%eax
  8006d7:	8b 50 04             	mov    0x4(%eax),%edx
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	eb 38                	jmp    800716 <getint+0x5d>
	else if (lflag)
  8006de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e2:	74 1a                	je     8006fe <getint+0x45>
		return va_arg(*ap, long);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	8d 50 04             	lea    0x4(%eax),%edx
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	89 10                	mov    %edx,(%eax)
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	99                   	cltd   
  8006fc:	eb 18                	jmp    800716 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	8d 50 04             	lea    0x4(%eax),%edx
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	89 10                	mov    %edx,(%eax)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	83 e8 04             	sub    $0x4,%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	99                   	cltd   
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	56                   	push   %esi
  80071c:	53                   	push   %ebx
  80071d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	eb 17                	jmp    800739 <vprintfmt+0x21>
			if (ch == '\0')
  800722:	85 db                	test   %ebx,%ebx
  800724:	0f 84 af 03 00 00    	je     800ad9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	53                   	push   %ebx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	ff d0                	call   *%eax
  800736:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800739:	8b 45 10             	mov    0x10(%ebp),%eax
  80073c:	8d 50 01             	lea    0x1(%eax),%edx
  80073f:	89 55 10             	mov    %edx,0x10(%ebp)
  800742:	8a 00                	mov    (%eax),%al
  800744:	0f b6 d8             	movzbl %al,%ebx
  800747:	83 fb 25             	cmp    $0x25,%ebx
  80074a:	75 d6                	jne    800722 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80074c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800750:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800757:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800765:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80077d:	83 f8 55             	cmp    $0x55,%eax
  800780:	0f 87 2b 03 00 00    	ja     800ab1 <vprintfmt+0x399>
  800786:	8b 04 85 f8 22 80 00 	mov    0x8022f8(,%eax,4),%eax
  80078d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800793:	eb d7                	jmp    80076c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800795:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800799:	eb d1                	jmp    80076c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	c1 e0 02             	shl    $0x2,%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	01 c0                	add    %eax,%eax
  8007ae:	01 d8                	add    %ebx,%eax
  8007b0:	83 e8 30             	sub    $0x30,%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007be:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c1:	7e 3e                	jle    800801 <vprintfmt+0xe9>
  8007c3:	83 fb 39             	cmp    $0x39,%ebx
  8007c6:	7f 39                	jg     800801 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007cb:	eb d5                	jmp    8007a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	83 c0 04             	add    $0x4,%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	83 e8 04             	sub    $0x4,%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e1:	eb 1f                	jmp    800802 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	79 83                	jns    80076c <vprintfmt+0x54>
				width = 0;
  8007e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f0:	e9 77 ff ff ff       	jmp    80076c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007fc:	e9 6b ff ff ff       	jmp    80076c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800801:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800802:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800806:	0f 89 60 ff ff ff    	jns    80076c <vprintfmt+0x54>
				width = precision, precision = -1;
  80080c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800812:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800819:	e9 4e ff ff ff       	jmp    80076c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800821:	e9 46 ff ff ff       	jmp    80076c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 c0 04             	add    $0x4,%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 e8 04             	sub    $0x4,%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
			break;
  800846:	e9 89 02 00 00       	jmp    800ad4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80085c:	85 db                	test   %ebx,%ebx
  80085e:	79 02                	jns    800862 <vprintfmt+0x14a>
				err = -err;
  800860:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800862:	83 fb 64             	cmp    $0x64,%ebx
  800865:	7f 0b                	jg     800872 <vprintfmt+0x15a>
  800867:	8b 34 9d 40 21 80 00 	mov    0x802140(,%ebx,4),%esi
  80086e:	85 f6                	test   %esi,%esi
  800870:	75 19                	jne    80088b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800872:	53                   	push   %ebx
  800873:	68 e5 22 80 00       	push   $0x8022e5
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 5e 02 00 00       	call   800ae1 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800886:	e9 49 02 00 00       	jmp    800ad4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80088b:	56                   	push   %esi
  80088c:	68 ee 22 80 00       	push   $0x8022ee
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	ff 75 08             	pushl  0x8(%ebp)
  800897:	e8 45 02 00 00       	call   800ae1 <printfmt>
  80089c:	83 c4 10             	add    $0x10,%esp
			break;
  80089f:	e9 30 02 00 00       	jmp    800ad4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 c0 04             	add    $0x4,%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 e8 04             	sub    $0x4,%eax
  8008b3:	8b 30                	mov    (%eax),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 05                	jne    8008be <vprintfmt+0x1a6>
				p = "(null)";
  8008b9:	be f1 22 80 00       	mov    $0x8022f1,%esi
			if (width > 0 && padc != '-')
  8008be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c2:	7e 6d                	jle    800931 <vprintfmt+0x219>
  8008c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c8:	74 67                	je     800931 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	50                   	push   %eax
  8008d1:	56                   	push   %esi
  8008d2:	e8 0c 03 00 00       	call   800be3 <strnlen>
  8008d7:	83 c4 10             	add    $0x10,%esp
  8008da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008dd:	eb 16                	jmp    8008f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	50                   	push   %eax
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	ff d0                	call   *%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f9:	7f e4                	jg     8008df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fb:	eb 34                	jmp    800931 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800901:	74 1c                	je     80091f <vprintfmt+0x207>
  800903:	83 fb 1f             	cmp    $0x1f,%ebx
  800906:	7e 05                	jle    80090d <vprintfmt+0x1f5>
  800908:	83 fb 7e             	cmp    $0x7e,%ebx
  80090b:	7e 12                	jle    80091f <vprintfmt+0x207>
					putch('?', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	6a 3f                	push   $0x3f
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	eb 0f                	jmp    80092e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	53                   	push   %ebx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	ff d0                	call   *%eax
  80092b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	ff 4d e4             	decl   -0x1c(%ebp)
  800931:	89 f0                	mov    %esi,%eax
  800933:	8d 70 01             	lea    0x1(%eax),%esi
  800936:	8a 00                	mov    (%eax),%al
  800938:	0f be d8             	movsbl %al,%ebx
  80093b:	85 db                	test   %ebx,%ebx
  80093d:	74 24                	je     800963 <vprintfmt+0x24b>
  80093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800943:	78 b8                	js     8008fd <vprintfmt+0x1e5>
  800945:	ff 4d e0             	decl   -0x20(%ebp)
  800948:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094c:	79 af                	jns    8008fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094e:	eb 13                	jmp    800963 <vprintfmt+0x24b>
				putch(' ', putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	6a 20                	push   $0x20
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	ff d0                	call   *%eax
  80095d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800960:	ff 4d e4             	decl   -0x1c(%ebp)
  800963:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800967:	7f e7                	jg     800950 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800969:	e9 66 01 00 00       	jmp    800ad4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 e8             	pushl  -0x18(%ebp)
  800974:	8d 45 14             	lea    0x14(%ebp),%eax
  800977:	50                   	push   %eax
  800978:	e8 3c fd ff ff       	call   8006b9 <getint>
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800983:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098c:	85 d2                	test   %edx,%edx
  80098e:	79 23                	jns    8009b3 <vprintfmt+0x29b>
				putch('-', putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	6a 2d                	push   $0x2d
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a6:	f7 d8                	neg    %eax
  8009a8:	83 d2 00             	adc    $0x0,%edx
  8009ab:	f7 da                	neg    %edx
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ba:	e9 bc 00 00 00       	jmp    800a7b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c8:	50                   	push   %eax
  8009c9:	e8 84 fc ff ff       	call   800652 <getuint>
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009de:	e9 98 00 00 00       	jmp    800a7b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 58                	push   $0x58
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	6a 58                	push   $0x58
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	ff d0                	call   *%eax
  800a00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	6a 58                	push   $0x58
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			break;
  800a13:	e9 bc 00 00 00       	jmp    800ad4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a18:	83 ec 08             	sub    $0x8,%esp
  800a1b:	ff 75 0c             	pushl  0xc(%ebp)
  800a1e:	6a 30                	push   $0x30
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	ff d0                	call   *%eax
  800a25:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	6a 78                	push   $0x78
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	ff d0                	call   *%eax
  800a35:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	83 c0 04             	add    $0x4,%eax
  800a3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	83 e8 04             	sub    $0x4,%eax
  800a47:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a53:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5a:	eb 1f                	jmp    800a7b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a62:	8d 45 14             	lea    0x14(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	e8 e7 fb ff ff       	call   800652 <getuint>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a82:	83 ec 04             	sub    $0x4,%esp
  800a85:	52                   	push   %edx
  800a86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 00 fb ff ff       	call   80059b <printnum>
  800a9b:	83 c4 20             	add    $0x20,%esp
			break;
  800a9e:	eb 34                	jmp    800ad4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	53                   	push   %ebx
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	eb 23                	jmp    800ad4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	6a 25                	push   $0x25
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac1:	ff 4d 10             	decl   0x10(%ebp)
  800ac4:	eb 03                	jmp    800ac9 <vprintfmt+0x3b1>
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	48                   	dec    %eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	3c 25                	cmp    $0x25,%al
  800ad1:	75 f3                	jne    800ac6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad3:	90                   	nop
		}
	}
  800ad4:	e9 47 fc ff ff       	jmp    800720 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800add:	5b                   	pop    %ebx
  800ade:	5e                   	pop    %esi
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae7:	8d 45 10             	lea    0x10(%ebp),%eax
  800aea:	83 c0 04             	add    $0x4,%eax
  800aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af0:	8b 45 10             	mov    0x10(%ebp),%eax
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 16 fc ff ff       	call   800718 <vprintfmt>
  800b02:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b05:	90                   	nop
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 40 08             	mov    0x8(%eax),%eax
  800b11:	8d 50 01             	lea    0x1(%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8b 10                	mov    (%eax),%edx
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 40 04             	mov    0x4(%eax),%eax
  800b25:	39 c2                	cmp    %eax,%edx
  800b27:	73 12                	jae    800b3b <sprintputch+0x33>
		*b->buf++ = ch;
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b34:	89 0a                	mov    %ecx,(%edx)
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	88 10                	mov    %dl,(%eax)
}
  800b3b:	90                   	nop
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	01 d0                	add    %edx,%eax
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b63:	74 06                	je     800b6b <vsnprintf+0x2d>
  800b65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b69:	7f 07                	jg     800b72 <vsnprintf+0x34>
		return -E_INVAL;
  800b6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b70:	eb 20                	jmp    800b92 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b72:	ff 75 14             	pushl  0x14(%ebp)
  800b75:	ff 75 10             	pushl  0x10(%ebp)
  800b78:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7b:	50                   	push   %eax
  800b7c:	68 08 0b 80 00       	push   $0x800b08
  800b81:	e8 92 fb ff ff       	call   800718 <vprintfmt>
  800b86:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9d:	83 c0 04             	add    $0x4,%eax
  800ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	ff 75 08             	pushl  0x8(%ebp)
  800bb0:	e8 89 ff ff ff       	call   800b3e <vsnprintf>
  800bb5:	83 c4 10             	add    $0x10,%esp
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcd:	eb 06                	jmp    800bd5 <strlen+0x15>
		n++;
  800bcf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd2:	ff 45 08             	incl   0x8(%ebp)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	84 c0                	test   %al,%al
  800bdc:	75 f1                	jne    800bcf <strlen+0xf>
		n++;
	return n;
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf0:	eb 09                	jmp    800bfb <strnlen+0x18>
		n++;
  800bf2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf5:	ff 45 08             	incl   0x8(%ebp)
  800bf8:	ff 4d 0c             	decl   0xc(%ebp)
  800bfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bff:	74 09                	je     800c0a <strnlen+0x27>
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 e8                	jne    800bf2 <strnlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1b:	90                   	nop
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8d 50 01             	lea    0x1(%eax),%edx
  800c22:	89 55 08             	mov    %edx,0x8(%ebp)
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2e:	8a 12                	mov    (%edx),%dl
  800c30:	88 10                	mov    %dl,(%eax)
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	84 c0                	test   %al,%al
  800c36:	75 e4                	jne    800c1c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c50:	eb 1f                	jmp    800c71 <strncpy+0x34>
		*dst++ = *src;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8d 50 01             	lea    0x1(%eax),%edx
  800c58:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5e:	8a 12                	mov    (%edx),%dl
  800c60:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	74 03                	je     800c6e <strncpy+0x31>
			src++;
  800c6b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6e:	ff 45 fc             	incl   -0x4(%ebp)
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c77:	72 d9                	jb     800c52 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8e:	74 30                	je     800cc0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c90:	eb 16                	jmp    800ca8 <strlcpy+0x2a>
			*dst++ = *src++;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8d 50 01             	lea    0x1(%eax),%edx
  800c98:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca4:	8a 12                	mov    (%edx),%dl
  800ca6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca8:	ff 4d 10             	decl   0x10(%ebp)
  800cab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800caf:	74 09                	je     800cba <strlcpy+0x3c>
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 d8                	jne    800c92 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc6:	29 c2                	sub    %eax,%edx
  800cc8:	89 d0                	mov    %edx,%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ccf:	eb 06                	jmp    800cd7 <strcmp+0xb>
		p++, q++;
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	84 c0                	test   %al,%al
  800cde:	74 0e                	je     800cee <strcmp+0x22>
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 10                	mov    (%eax),%dl
  800ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	38 c2                	cmp    %al,%dl
  800cec:	74 e3                	je     800cd1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 d0             	movzbl %al,%edx
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 c0             	movzbl %al,%eax
  800cfe:	29 c2                	sub    %eax,%edx
  800d00:	89 d0                	mov    %edx,%eax
}
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d07:	eb 09                	jmp    800d12 <strncmp+0xe>
		n--, p++, q++;
  800d09:	ff 4d 10             	decl   0x10(%ebp)
  800d0c:	ff 45 08             	incl   0x8(%ebp)
  800d0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	74 17                	je     800d2f <strncmp+0x2b>
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	84 c0                	test   %al,%al
  800d1f:	74 0e                	je     800d2f <strncmp+0x2b>
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 10                	mov    (%eax),%dl
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	38 c2                	cmp    %al,%dl
  800d2d:	74 da                	je     800d09 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d33:	75 07                	jne    800d3c <strncmp+0x38>
		return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	eb 14                	jmp    800d50 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 d0             	movzbl %al,%edx
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	0f b6 c0             	movzbl %al,%eax
  800d4c:	29 c2                	sub    %eax,%edx
  800d4e:	89 d0                	mov    %edx,%eax
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 04             	sub    $0x4,%esp
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5e:	eb 12                	jmp    800d72 <strchr+0x20>
		if (*s == c)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d68:	75 05                	jne    800d6f <strchr+0x1d>
			return (char *) s;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	eb 11                	jmp    800d80 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	84 c0                	test   %al,%al
  800d79:	75 e5                	jne    800d60 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 04             	sub    $0x4,%esp
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8e:	eb 0d                	jmp    800d9d <strfind+0x1b>
		if (*s == c)
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d98:	74 0e                	je     800da8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	84 c0                	test   %al,%al
  800da4:	75 ea                	jne    800d90 <strfind+0xe>
  800da6:	eb 01                	jmp    800da9 <strfind+0x27>
		if (*s == c)
			break;
  800da8:	90                   	nop
	return (char *) s;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dba:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc0:	eb 0e                	jmp    800dd0 <memset+0x22>
		*p++ = c;
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	8d 50 01             	lea    0x1(%eax),%edx
  800dc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dce:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd0:	ff 4d f8             	decl   -0x8(%ebp)
  800dd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dd7:	79 e9                	jns    800dc2 <memset+0x14>
		*p++ = c;

	return v;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df0:	eb 16                	jmp    800e08 <memcpy+0x2a>
		*d++ = *s++;
  800df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e01:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e04:	8a 12                	mov    (%edx),%dl
  800e06:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	75 dd                	jne    800df2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e32:	73 50                	jae    800e84 <memmove+0x6a>
  800e34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	01 d0                	add    %edx,%eax
  800e3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3f:	76 43                	jbe    800e84 <memmove+0x6a>
		s += n;
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e4d:	eb 10                	jmp    800e5f <memmove+0x45>
			*--d = *--s;
  800e4f:	ff 4d f8             	decl   -0x8(%ebp)
  800e52:	ff 4d fc             	decl   -0x4(%ebp)
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	8a 10                	mov    (%eax),%dl
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e65:	89 55 10             	mov    %edx,0x10(%ebp)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	75 e3                	jne    800e4f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e6c:	eb 23                	jmp    800e91 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e80:	8a 12                	mov    (%edx),%dl
  800e82:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	75 dd                	jne    800e6e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea8:	eb 2a                	jmp    800ed4 <memcmp+0x3e>
		if (*s1 != *s2)
  800eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ead:	8a 10                	mov    (%eax),%dl
  800eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	38 c2                	cmp    %al,%dl
  800eb6:	74 16                	je     800ece <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 d0             	movzbl %al,%edx
  800ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f b6 c0             	movzbl %al,%eax
  800ec8:	29 c2                	sub    %eax,%edx
  800eca:	89 d0                	mov    %edx,%eax
  800ecc:	eb 18                	jmp    800ee6 <memcmp+0x50>
		s1++, s2++;
  800ece:	ff 45 fc             	incl   -0x4(%ebp)
  800ed1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 c9                	jne    800eaa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 d0                	add    %edx,%eax
  800ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef9:	eb 15                	jmp    800f10 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f b6 d0             	movzbl %al,%edx
  800f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f06:	0f b6 c0             	movzbl %al,%eax
  800f09:	39 c2                	cmp    %eax,%edx
  800f0b:	74 0d                	je     800f1a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f16:	72 e3                	jb     800efb <memfind+0x13>
  800f18:	eb 01                	jmp    800f1b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f1a:	90                   	nop
	return (void *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f34:	eb 03                	jmp    800f39 <strtol+0x19>
		s++;
  800f36:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	3c 20                	cmp    $0x20,%al
  800f40:	74 f4                	je     800f36 <strtol+0x16>
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 09                	cmp    $0x9,%al
  800f49:	74 eb                	je     800f36 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	3c 2b                	cmp    $0x2b,%al
  800f52:	75 05                	jne    800f59 <strtol+0x39>
		s++;
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	eb 13                	jmp    800f6c <strtol+0x4c>
	else if (*s == '-')
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 2d                	cmp    $0x2d,%al
  800f60:	75 0a                	jne    800f6c <strtol+0x4c>
		s++, neg = 1;
  800f62:	ff 45 08             	incl   0x8(%ebp)
  800f65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	74 06                	je     800f78 <strtol+0x58>
  800f72:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f76:	75 20                	jne    800f98 <strtol+0x78>
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	3c 30                	cmp    $0x30,%al
  800f7f:	75 17                	jne    800f98 <strtol+0x78>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	40                   	inc    %eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 78                	cmp    $0x78,%al
  800f89:	75 0d                	jne    800f98 <strtol+0x78>
		s += 2, base = 16;
  800f8b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f8f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f96:	eb 28                	jmp    800fc0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 15                	jne    800fb3 <strtol+0x93>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 30                	cmp    $0x30,%al
  800fa5:	75 0c                	jne    800fb3 <strtol+0x93>
		s++, base = 8;
  800fa7:	ff 45 08             	incl   0x8(%ebp)
  800faa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb1:	eb 0d                	jmp    800fc0 <strtol+0xa0>
	else if (base == 0)
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	75 07                	jne    800fc0 <strtol+0xa0>
		base = 10;
  800fb9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 2f                	cmp    $0x2f,%al
  800fc7:	7e 19                	jle    800fe2 <strtol+0xc2>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 39                	cmp    $0x39,%al
  800fd0:	7f 10                	jg     800fe2 <strtol+0xc2>
			dig = *s - '0';
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f be c0             	movsbl %al,%eax
  800fda:	83 e8 30             	sub    $0x30,%eax
  800fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe0:	eb 42                	jmp    801024 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 60                	cmp    $0x60,%al
  800fe9:	7e 19                	jle    801004 <strtol+0xe4>
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 7a                	cmp    $0x7a,%al
  800ff2:	7f 10                	jg     801004 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	0f be c0             	movsbl %al,%eax
  800ffc:	83 e8 57             	sub    $0x57,%eax
  800fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801002:	eb 20                	jmp    801024 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 40                	cmp    $0x40,%al
  80100b:	7e 39                	jle    801046 <strtol+0x126>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 5a                	cmp    $0x5a,%al
  801014:	7f 30                	jg     801046 <strtol+0x126>
			dig = *s - 'A' + 10;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 37             	sub    $0x37,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801027:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102a:	7d 19                	jge    801045 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	0f af 45 10          	imul   0x10(%ebp),%eax
  801036:	89 c2                	mov    %eax,%edx
  801038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103b:	01 d0                	add    %edx,%eax
  80103d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801040:	e9 7b ff ff ff       	jmp    800fc0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801045:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801046:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104a:	74 08                	je     801054 <strtol+0x134>
		*endptr = (char *) s;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801054:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801058:	74 07                	je     801061 <strtol+0x141>
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	f7 d8                	neg    %eax
  80105f:	eb 03                	jmp    801064 <strtol+0x144>
  801061:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <ltostr>:

void
ltostr(long value, char *str)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801073:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80107a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107e:	79 13                	jns    801093 <ltostr+0x2d>
	{
		neg = 1;
  801080:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80108d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801090:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80109b:	99                   	cltd   
  80109c:	f7 f9                	idiv   %ecx
  80109e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b4:	83 c2 30             	add    $0x30,%edx
  8010b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010da:	f7 e9                	imul   %ecx
  8010dc:	c1 fa 02             	sar    $0x2,%edx
  8010df:	89 c8                	mov    %ecx,%eax
  8010e1:	c1 f8 1f             	sar    $0x1f,%eax
  8010e4:	29 c2                	sub    %eax,%edx
  8010e6:	89 d0                	mov    %edx,%eax
  8010e8:	c1 e0 02             	shl    $0x2,%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	01 c0                	add    %eax,%eax
  8010ef:	29 c1                	sub    %eax,%ecx
  8010f1:	89 ca                	mov    %ecx,%edx
  8010f3:	85 d2                	test   %edx,%edx
  8010f5:	75 9c                	jne    801093 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	48                   	dec    %eax
  801102:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801105:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801109:	74 3d                	je     801148 <ltostr+0xe2>
		start = 1 ;
  80110b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801112:	eb 34                	jmp    801148 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	01 d0                	add    %edx,%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c2                	add    %eax,%edx
  801129:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	01 c8                	add    %ecx,%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801135:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	01 c2                	add    %eax,%edx
  80113d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801140:	88 02                	mov    %al,(%edx)
		start++ ;
  801142:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801145:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80114e:	7c c4                	jl     801114 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801150:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	01 d0                	add    %edx,%eax
  801158:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80115b:	90                   	nop
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	e8 54 fa ff ff       	call   800bc0 <strlen>
  80116c:	83 c4 04             	add    $0x4,%esp
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801172:	ff 75 0c             	pushl  0xc(%ebp)
  801175:	e8 46 fa ff ff       	call   800bc0 <strlen>
  80117a:	83 c4 04             	add    $0x4,%esp
  80117d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801187:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118e:	eb 17                	jmp    8011a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801190:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	01 c2                	add    %eax,%edx
  801198:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	01 c8                	add    %ecx,%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011a4:	ff 45 fc             	incl   -0x4(%ebp)
  8011a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011ad:	7c e1                	jl     801190 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011bd:	eb 1f                	jmp    8011de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	8d 50 01             	lea    0x1(%eax),%edx
  8011c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c8:	89 c2                	mov    %eax,%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 c2                	add    %eax,%edx
  8011cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	01 c8                	add    %ecx,%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011db:	ff 45 f8             	incl   -0x8(%ebp)
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e4:	7c d9                	jl     8011bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f1:	90                   	nop
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801200:	8b 45 14             	mov    0x14(%ebp),%eax
  801203:	8b 00                	mov    (%eax),%eax
  801205:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801217:	eb 0c                	jmp    801225 <strsplit+0x31>
			*string++ = 0;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 08             	mov    %edx,0x8(%ebp)
  801222:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	84 c0                	test   %al,%al
  80122c:	74 18                	je     801246 <strsplit+0x52>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	0f be c0             	movsbl %al,%eax
  801236:	50                   	push   %eax
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	e8 13 fb ff ff       	call   800d52 <strchr>
  80123f:	83 c4 08             	add    $0x8,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	75 d3                	jne    801219 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	74 5a                	je     8012a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	8b 00                	mov    (%eax),%eax
  801254:	83 f8 0f             	cmp    $0xf,%eax
  801257:	75 07                	jne    801260 <strsplit+0x6c>
		{
			return 0;
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
  80125e:	eb 66                	jmp    8012c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801260:	8b 45 14             	mov    0x14(%ebp),%eax
  801263:	8b 00                	mov    (%eax),%eax
  801265:	8d 48 01             	lea    0x1(%eax),%ecx
  801268:	8b 55 14             	mov    0x14(%ebp),%edx
  80126b:	89 0a                	mov    %ecx,(%edx)
  80126d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 c2                	add    %eax,%edx
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127e:	eb 03                	jmp    801283 <strsplit+0x8f>
			string++;
  801280:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	74 8b                	je     801217 <strsplit+0x23>
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	0f be c0             	movsbl %al,%eax
  801294:	50                   	push   %eax
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	e8 b5 fa ff ff       	call   800d52 <strchr>
  80129d:	83 c4 08             	add    $0x8,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	74 dc                	je     801280 <strsplit+0x8c>
			string++;
	}
  8012a4:	e9 6e ff ff ff       	jmp    801217 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	8b 00                	mov    (%eax),%eax
  8012af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	68 50 24 80 00       	push   $0x802450
  8012d6:	6a 0e                	push   $0xe
  8012d8:	68 8a 24 80 00       	push   $0x80248a
  8012dd:	e8 a8 ef ff ff       	call   80028a <_panic>

008012e2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8012e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	74 0f                	je     801300 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8012f1:	e8 d2 ff ff ff       	call   8012c8 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f6:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8012fd:	00 00 00 
	}
	if (size == 0) return NULL ;
  801300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801304:	75 07                	jne    80130d <malloc+0x2b>
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
  80130b:	eb 14                	jmp    801321 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	68 98 24 80 00       	push   $0x802498
  801315:	6a 2e                	push   $0x2e
  801317:	68 8a 24 80 00       	push   $0x80248a
  80131c:	e8 69 ef ff ff       	call   80028a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	68 c0 24 80 00       	push   $0x8024c0
  801331:	6a 49                	push   $0x49
  801333:	68 8a 24 80 00       	push   $0x80248a
  801338:	e8 4d ef ff ff       	call   80028a <_panic>

0080133d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 18             	sub    $0x18,%esp
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 e4 24 80 00       	push   $0x8024e4
  801351:	6a 57                	push   $0x57
  801353:	68 8a 24 80 00       	push   $0x80248a
  801358:	e8 2d ef ff ff       	call   80028a <_panic>

0080135d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	68 0c 25 80 00       	push   $0x80250c
  80136b:	6a 60                	push   $0x60
  80136d:	68 8a 24 80 00       	push   $0x80248a
  801372:	e8 13 ef ff ff       	call   80028a <_panic>

00801377 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	68 30 25 80 00       	push   $0x802530
  801385:	6a 7c                	push   $0x7c
  801387:	68 8a 24 80 00       	push   $0x80248a
  80138c:	e8 f9 ee ff ff       	call   80028a <_panic>

00801391 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	68 58 25 80 00       	push   $0x802558
  80139f:	68 86 00 00 00       	push   $0x86
  8013a4:	68 8a 24 80 00       	push   $0x80248a
  8013a9:	e8 dc ee ff ff       	call   80028a <_panic>

008013ae <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	68 7c 25 80 00       	push   $0x80257c
  8013bc:	68 91 00 00 00       	push   $0x91
  8013c1:	68 8a 24 80 00       	push   $0x80248a
  8013c6:	e8 bf ee ff ff       	call   80028a <_panic>

008013cb <shrink>:

}
void shrink(uint32 newSize)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	68 7c 25 80 00       	push   $0x80257c
  8013d9:	68 96 00 00 00       	push   $0x96
  8013de:	68 8a 24 80 00       	push   $0x80248a
  8013e3:	e8 a2 ee ff ff       	call   80028a <_panic>

008013e8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	68 7c 25 80 00       	push   $0x80257c
  8013f6:	68 9b 00 00 00       	push   $0x9b
  8013fb:	68 8a 24 80 00       	push   $0x80248a
  801400:	e8 85 ee ff ff       	call   80028a <_panic>

00801405 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8b 55 0c             	mov    0xc(%ebp),%edx
  801414:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801417:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80141a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80141d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801420:	cd 30                	int    $0x30
  801422:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801425:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	5b                   	pop    %ebx
  80142c:	5e                   	pop    %esi
  80142d:	5f                   	pop    %edi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80143c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	52                   	push   %edx
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	50                   	push   %eax
  80144c:	6a 00                	push   $0x0
  80144e:	e8 b2 ff ff ff       	call   801405 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	90                   	nop
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_cgetc>:

int
sys_cgetc(void)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 01                	push   $0x1
  801468:	e8 98 ff ff ff       	call   801405 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801475:	8b 55 0c             	mov    0xc(%ebp),%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	52                   	push   %edx
  801482:	50                   	push   %eax
  801483:	6a 05                	push   $0x5
  801485:	e8 7b ff ff ff       	call   801405 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	56                   	push   %esi
  801493:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801494:	8b 75 18             	mov    0x18(%ebp),%esi
  801497:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	51                   	push   %ecx
  8014a6:	52                   	push   %edx
  8014a7:	50                   	push   %eax
  8014a8:	6a 06                	push   $0x6
  8014aa:	e8 56 ff ff ff       	call   801405 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	52                   	push   %edx
  8014c9:	50                   	push   %eax
  8014ca:	6a 07                	push   $0x7
  8014cc:	e8 34 ff ff ff       	call   801405 <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	6a 08                	push   $0x8
  8014e7:	e8 19 ff ff ff       	call   801405 <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 09                	push   $0x9
  801500:	e8 00 ff ff ff       	call   801405 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 0a                	push   $0xa
  801519:	e8 e7 fe ff ff       	call   801405 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 0b                	push   $0xb
  801532:	e8 ce fe ff ff       	call   801405 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	6a 0f                	push   $0xf
  80154d:	e8 b3 fe ff ff       	call   801405 <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
	return;
  801555:	90                   	nop
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	ff 75 0c             	pushl  0xc(%ebp)
  801564:	ff 75 08             	pushl  0x8(%ebp)
  801567:	6a 10                	push   $0x10
  801569:	e8 97 fe ff ff       	call   801405 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
	return ;
  801571:	90                   	nop
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 10             	pushl  0x10(%ebp)
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	ff 75 08             	pushl  0x8(%ebp)
  801584:	6a 11                	push   $0x11
  801586:	e8 7a fe ff ff       	call   801405 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
	return ;
  80158e:	90                   	nop
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 0c                	push   $0xc
  8015a0:	e8 60 fe ff ff       	call   801405 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	ff 75 08             	pushl  0x8(%ebp)
  8015b8:	6a 0d                	push   $0xd
  8015ba:	e8 46 fe ff ff       	call   801405 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 0e                	push   $0xe
  8015d3:	e8 2d fe ff ff       	call   801405 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	90                   	nop
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 13                	push   $0x13
  8015ed:	e8 13 fe ff ff       	call   801405 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	90                   	nop
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 14                	push   $0x14
  801607:	e8 f9 fd ff ff       	call   801405 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	90                   	nop
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_cputc>:


void
sys_cputc(const char c)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80161e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	50                   	push   %eax
  80162b:	6a 15                	push   $0x15
  80162d:	e8 d3 fd ff ff       	call   801405 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	90                   	nop
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 16                	push   $0x16
  801647:	e8 b9 fd ff ff       	call   801405 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	90                   	nop
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	50                   	push   %eax
  801662:	6a 17                	push   $0x17
  801664:	e8 9c fd ff ff       	call   801405 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801671:	8b 55 0c             	mov    0xc(%ebp),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	52                   	push   %edx
  80167e:	50                   	push   %eax
  80167f:	6a 1a                	push   $0x1a
  801681:	e8 7f fd ff ff       	call   801405 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	52                   	push   %edx
  80169b:	50                   	push   %eax
  80169c:	6a 18                	push   $0x18
  80169e:	e8 62 fd ff ff       	call   801405 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	52                   	push   %edx
  8016b9:	50                   	push   %eax
  8016ba:	6a 19                	push   $0x19
  8016bc:	e8 44 fd ff ff       	call   801405 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	90                   	nop
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	6a 00                	push   $0x0
  8016df:	51                   	push   %ecx
  8016e0:	52                   	push   %edx
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	6a 1b                	push   $0x1b
  8016e7:	e8 19 fd ff ff       	call   801405 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	52                   	push   %edx
  801701:	50                   	push   %eax
  801702:	6a 1c                	push   $0x1c
  801704:	e8 fc fc ff ff       	call   801405 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801711:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	51                   	push   %ecx
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	6a 1d                	push   $0x1d
  801723:	e8 dd fc ff ff       	call   801405 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	52                   	push   %edx
  80173d:	50                   	push   %eax
  80173e:	6a 1e                	push   $0x1e
  801740:	e8 c0 fc ff ff       	call   801405 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 1f                	push   $0x1f
  801759:	e8 a7 fc ff ff       	call   801405 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 14             	pushl  0x14(%ebp)
  80176e:	ff 75 10             	pushl  0x10(%ebp)
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	50                   	push   %eax
  801775:	6a 20                	push   $0x20
  801777:	e8 89 fc ff ff       	call   801405 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 21                	push   $0x21
  801792:	e8 6e fc ff ff       	call   801405 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	50                   	push   %eax
  8017ac:	6a 22                	push   $0x22
  8017ae:	e8 52 fc ff ff       	call   801405 <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 02                	push   $0x2
  8017c7:	e8 39 fc ff ff       	call   801405 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 03                	push   $0x3
  8017e0:	e8 20 fc ff ff       	call   801405 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 04                	push   $0x4
  8017f9:	e8 07 fc ff ff       	call   801405 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_exit_env>:


void sys_exit_env(void)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 23                	push   $0x23
  801812:	e8 ee fb ff ff       	call   801405 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801823:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801826:	8d 50 04             	lea    0x4(%eax),%edx
  801829:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	6a 24                	push   $0x24
  801836:	e8 ca fb ff ff       	call   801405 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
	return result;
  80183e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801841:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801844:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801847:	89 01                	mov    %eax,(%ecx)
  801849:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	c9                   	leave  
  801850:	c2 04 00             	ret    $0x4

00801853 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	6a 12                	push   $0x12
  801865:	e8 9b fb ff ff       	call   801405 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return ;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_rcr2>:
uint32 sys_rcr2()
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 25                	push   $0x25
  80187f:	e8 81 fb ff ff       	call   801405 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801895:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	50                   	push   %eax
  8018a2:	6a 26                	push   $0x26
  8018a4:	e8 5c fb ff ff       	call   801405 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ac:	90                   	nop
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <rsttst>:
void rsttst()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 28                	push   $0x28
  8018be:	e8 42 fb ff ff       	call   801405 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c6:	90                   	nop
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018d5:	8b 55 18             	mov    0x18(%ebp),%edx
  8018d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	ff 75 10             	pushl  0x10(%ebp)
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 27                	push   $0x27
  8018e9:	e8 17 fb ff ff       	call   801405 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <chktst>:
void chktst(uint32 n)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	6a 29                	push   $0x29
  801904:	e8 fc fa ff ff       	call   801405 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <inctst>:

void inctst()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 2a                	push   $0x2a
  80191e:	e8 e2 fa ff ff       	call   801405 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return ;
  801926:	90                   	nop
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <gettst>:
uint32 gettst()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 2b                	push   $0x2b
  801938:	e8 c8 fa ff ff       	call   801405 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 2c                	push   $0x2c
  801954:	e8 ac fa ff ff       	call   801405 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
  80195c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80195f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801963:	75 07                	jne    80196c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801965:	b8 01 00 00 00       	mov    $0x1,%eax
  80196a:	eb 05                	jmp    801971 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 2c                	push   $0x2c
  801985:	e8 7b fa ff ff       	call   801405 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
  80198d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801990:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801994:	75 07                	jne    80199d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801996:	b8 01 00 00 00       	mov    $0x1,%eax
  80199b:	eb 05                	jmp    8019a2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80199d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 2c                	push   $0x2c
  8019b6:	e8 4a fa ff ff       	call   801405 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
  8019be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019c1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019c5:	75 07                	jne    8019ce <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cc:	eb 05                	jmp    8019d3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 2c                	push   $0x2c
  8019e7:	e8 19 fa ff ff       	call   801405 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019f2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019f6:	75 07                	jne    8019ff <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fd:	eb 05                	jmp    801a04 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 2d                	push   $0x2d
  801a16:	e8 ea f9 ff ff       	call   801405 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	53                   	push   %ebx
  801a34:	51                   	push   %ecx
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 2e                	push   $0x2e
  801a39:	e8 c7 f9 ff ff       	call   801405 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 2f                	push   $0x2f
  801a59:	e8 a7 f9 ff ff       	call   801405 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a69:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	c1 e0 02             	shl    $0x2,%eax
  801a71:	01 d0                	add    %edx,%eax
  801a73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7a:	01 d0                	add    %edx,%eax
  801a7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a83:	01 d0                	add    %edx,%eax
  801a85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c1 e0 04             	shl    $0x4,%eax
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a9b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a9e:	83 ec 0c             	sub    $0xc,%esp
  801aa1:	50                   	push   %eax
  801aa2:	e8 76 fd ff ff       	call   80181d <sys_get_virtual_time>
  801aa7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801aaa:	eb 41                	jmp    801aed <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801aac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	50                   	push   %eax
  801ab3:	e8 65 fd ff ff       	call   80181d <sys_get_virtual_time>
  801ab8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801abb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac1:	29 c2                	sub    %eax,%edx
  801ac3:	89 d0                	mov    %edx,%eax
  801ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801ac8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ace:	89 d1                	mov    %edx,%ecx
  801ad0:	29 c1                	sub    %eax,%ecx
  801ad2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad8:	39 c2                	cmp    %eax,%edx
  801ada:	0f 97 c0             	seta   %al
  801add:	0f b6 c0             	movzbl %al,%eax
  801ae0:	29 c1                	sub    %eax,%ecx
  801ae2:	89 c8                	mov    %ecx,%eax
  801ae4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801ae7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af3:	72 b7                	jb     801aac <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801afe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b05:	eb 03                	jmp    801b0a <busy_wait+0x12>
  801b07:	ff 45 fc             	incl   -0x4(%ebp)
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b10:	72 f5                	jb     801b07 <busy_wait+0xf>
	return i;
  801b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    
  801b17:	90                   	nop

00801b18 <__udivdi3>:
  801b18:	55                   	push   %ebp
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	53                   	push   %ebx
  801b1c:	83 ec 1c             	sub    $0x1c,%esp
  801b1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2f:	89 ca                	mov    %ecx,%edx
  801b31:	89 f8                	mov    %edi,%eax
  801b33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b37:	85 f6                	test   %esi,%esi
  801b39:	75 2d                	jne    801b68 <__udivdi3+0x50>
  801b3b:	39 cf                	cmp    %ecx,%edi
  801b3d:	77 65                	ja     801ba4 <__udivdi3+0x8c>
  801b3f:	89 fd                	mov    %edi,%ebp
  801b41:	85 ff                	test   %edi,%edi
  801b43:	75 0b                	jne    801b50 <__udivdi3+0x38>
  801b45:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4a:	31 d2                	xor    %edx,%edx
  801b4c:	f7 f7                	div    %edi
  801b4e:	89 c5                	mov    %eax,%ebp
  801b50:	31 d2                	xor    %edx,%edx
  801b52:	89 c8                	mov    %ecx,%eax
  801b54:	f7 f5                	div    %ebp
  801b56:	89 c1                	mov    %eax,%ecx
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	f7 f5                	div    %ebp
  801b5c:	89 cf                	mov    %ecx,%edi
  801b5e:	89 fa                	mov    %edi,%edx
  801b60:	83 c4 1c             	add    $0x1c,%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
  801b68:	39 ce                	cmp    %ecx,%esi
  801b6a:	77 28                	ja     801b94 <__udivdi3+0x7c>
  801b6c:	0f bd fe             	bsr    %esi,%edi
  801b6f:	83 f7 1f             	xor    $0x1f,%edi
  801b72:	75 40                	jne    801bb4 <__udivdi3+0x9c>
  801b74:	39 ce                	cmp    %ecx,%esi
  801b76:	72 0a                	jb     801b82 <__udivdi3+0x6a>
  801b78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b7c:	0f 87 9e 00 00 00    	ja     801c20 <__udivdi3+0x108>
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
  801b87:	89 fa                	mov    %edi,%edx
  801b89:	83 c4 1c             	add    $0x1c,%esp
  801b8c:	5b                   	pop    %ebx
  801b8d:	5e                   	pop    %esi
  801b8e:	5f                   	pop    %edi
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    
  801b91:	8d 76 00             	lea    0x0(%esi),%esi
  801b94:	31 ff                	xor    %edi,%edi
  801b96:	31 c0                	xor    %eax,%eax
  801b98:	89 fa                	mov    %edi,%edx
  801b9a:	83 c4 1c             	add    $0x1c,%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    
  801ba2:	66 90                	xchg   %ax,%ax
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	f7 f7                	div    %edi
  801ba8:	31 ff                	xor    %edi,%edi
  801baa:	89 fa                	mov    %edi,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bb9:	89 eb                	mov    %ebp,%ebx
  801bbb:	29 fb                	sub    %edi,%ebx
  801bbd:	89 f9                	mov    %edi,%ecx
  801bbf:	d3 e6                	shl    %cl,%esi
  801bc1:	89 c5                	mov    %eax,%ebp
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 ed                	shr    %cl,%ebp
  801bc7:	89 e9                	mov    %ebp,%ecx
  801bc9:	09 f1                	or     %esi,%ecx
  801bcb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bcf:	89 f9                	mov    %edi,%ecx
  801bd1:	d3 e0                	shl    %cl,%eax
  801bd3:	89 c5                	mov    %eax,%ebp
  801bd5:	89 d6                	mov    %edx,%esi
  801bd7:	88 d9                	mov    %bl,%cl
  801bd9:	d3 ee                	shr    %cl,%esi
  801bdb:	89 f9                	mov    %edi,%ecx
  801bdd:	d3 e2                	shl    %cl,%edx
  801bdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be3:	88 d9                	mov    %bl,%cl
  801be5:	d3 e8                	shr    %cl,%eax
  801be7:	09 c2                	or     %eax,%edx
  801be9:	89 d0                	mov    %edx,%eax
  801beb:	89 f2                	mov    %esi,%edx
  801bed:	f7 74 24 0c          	divl   0xc(%esp)
  801bf1:	89 d6                	mov    %edx,%esi
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	f7 e5                	mul    %ebp
  801bf7:	39 d6                	cmp    %edx,%esi
  801bf9:	72 19                	jb     801c14 <__udivdi3+0xfc>
  801bfb:	74 0b                	je     801c08 <__udivdi3+0xf0>
  801bfd:	89 d8                	mov    %ebx,%eax
  801bff:	31 ff                	xor    %edi,%edi
  801c01:	e9 58 ff ff ff       	jmp    801b5e <__udivdi3+0x46>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c0c:	89 f9                	mov    %edi,%ecx
  801c0e:	d3 e2                	shl    %cl,%edx
  801c10:	39 c2                	cmp    %eax,%edx
  801c12:	73 e9                	jae    801bfd <__udivdi3+0xe5>
  801c14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c17:	31 ff                	xor    %edi,%edi
  801c19:	e9 40 ff ff ff       	jmp    801b5e <__udivdi3+0x46>
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	31 c0                	xor    %eax,%eax
  801c22:	e9 37 ff ff ff       	jmp    801b5e <__udivdi3+0x46>
  801c27:	90                   	nop

00801c28 <__umoddi3>:
  801c28:	55                   	push   %ebp
  801c29:	57                   	push   %edi
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 1c             	sub    $0x1c,%esp
  801c2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c47:	89 f3                	mov    %esi,%ebx
  801c49:	89 fa                	mov    %edi,%edx
  801c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4f:	89 34 24             	mov    %esi,(%esp)
  801c52:	85 c0                	test   %eax,%eax
  801c54:	75 1a                	jne    801c70 <__umoddi3+0x48>
  801c56:	39 f7                	cmp    %esi,%edi
  801c58:	0f 86 a2 00 00 00    	jbe    801d00 <__umoddi3+0xd8>
  801c5e:	89 c8                	mov    %ecx,%eax
  801c60:	89 f2                	mov    %esi,%edx
  801c62:	f7 f7                	div    %edi
  801c64:	89 d0                	mov    %edx,%eax
  801c66:	31 d2                	xor    %edx,%edx
  801c68:	83 c4 1c             	add    $0x1c,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5f                   	pop    %edi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    
  801c70:	39 f0                	cmp    %esi,%eax
  801c72:	0f 87 ac 00 00 00    	ja     801d24 <__umoddi3+0xfc>
  801c78:	0f bd e8             	bsr    %eax,%ebp
  801c7b:	83 f5 1f             	xor    $0x1f,%ebp
  801c7e:	0f 84 ac 00 00 00    	je     801d30 <__umoddi3+0x108>
  801c84:	bf 20 00 00 00       	mov    $0x20,%edi
  801c89:	29 ef                	sub    %ebp,%edi
  801c8b:	89 fe                	mov    %edi,%esi
  801c8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c91:	89 e9                	mov    %ebp,%ecx
  801c93:	d3 e0                	shl    %cl,%eax
  801c95:	89 d7                	mov    %edx,%edi
  801c97:	89 f1                	mov    %esi,%ecx
  801c99:	d3 ef                	shr    %cl,%edi
  801c9b:	09 c7                	or     %eax,%edi
  801c9d:	89 e9                	mov    %ebp,%ecx
  801c9f:	d3 e2                	shl    %cl,%edx
  801ca1:	89 14 24             	mov    %edx,(%esp)
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	d3 e0                	shl    %cl,%eax
  801ca8:	89 c2                	mov    %eax,%edx
  801caa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cae:	d3 e0                	shl    %cl,%eax
  801cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb8:	89 f1                	mov    %esi,%ecx
  801cba:	d3 e8                	shr    %cl,%eax
  801cbc:	09 d0                	or     %edx,%eax
  801cbe:	d3 eb                	shr    %cl,%ebx
  801cc0:	89 da                	mov    %ebx,%edx
  801cc2:	f7 f7                	div    %edi
  801cc4:	89 d3                	mov    %edx,%ebx
  801cc6:	f7 24 24             	mull   (%esp)
  801cc9:	89 c6                	mov    %eax,%esi
  801ccb:	89 d1                	mov    %edx,%ecx
  801ccd:	39 d3                	cmp    %edx,%ebx
  801ccf:	0f 82 87 00 00 00    	jb     801d5c <__umoddi3+0x134>
  801cd5:	0f 84 91 00 00 00    	je     801d6c <__umoddi3+0x144>
  801cdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cdf:	29 f2                	sub    %esi,%edx
  801ce1:	19 cb                	sbb    %ecx,%ebx
  801ce3:	89 d8                	mov    %ebx,%eax
  801ce5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ce9:	d3 e0                	shl    %cl,%eax
  801ceb:	89 e9                	mov    %ebp,%ecx
  801ced:	d3 ea                	shr    %cl,%edx
  801cef:	09 d0                	or     %edx,%eax
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 eb                	shr    %cl,%ebx
  801cf5:	89 da                	mov    %ebx,%edx
  801cf7:	83 c4 1c             	add    $0x1c,%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5f                   	pop    %edi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    
  801cff:	90                   	nop
  801d00:	89 fd                	mov    %edi,%ebp
  801d02:	85 ff                	test   %edi,%edi
  801d04:	75 0b                	jne    801d11 <__umoddi3+0xe9>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	31 d2                	xor    %edx,%edx
  801d0d:	f7 f7                	div    %edi
  801d0f:	89 c5                	mov    %eax,%ebp
  801d11:	89 f0                	mov    %esi,%eax
  801d13:	31 d2                	xor    %edx,%edx
  801d15:	f7 f5                	div    %ebp
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	f7 f5                	div    %ebp
  801d1b:	89 d0                	mov    %edx,%eax
  801d1d:	e9 44 ff ff ff       	jmp    801c66 <__umoddi3+0x3e>
  801d22:	66 90                	xchg   %ax,%ax
  801d24:	89 c8                	mov    %ecx,%eax
  801d26:	89 f2                	mov    %esi,%edx
  801d28:	83 c4 1c             	add    $0x1c,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5f                   	pop    %edi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    
  801d30:	3b 04 24             	cmp    (%esp),%eax
  801d33:	72 06                	jb     801d3b <__umoddi3+0x113>
  801d35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d39:	77 0f                	ja     801d4a <__umoddi3+0x122>
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	29 f9                	sub    %edi,%ecx
  801d3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d43:	89 14 24             	mov    %edx,(%esp)
  801d46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d4e:	8b 14 24             	mov    (%esp),%edx
  801d51:	83 c4 1c             	add    $0x1c,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    
  801d59:	8d 76 00             	lea    0x0(%esi),%esi
  801d5c:	2b 04 24             	sub    (%esp),%eax
  801d5f:	19 fa                	sbb    %edi,%edx
  801d61:	89 d1                	mov    %edx,%ecx
  801d63:	89 c6                	mov    %eax,%esi
  801d65:	e9 71 ff ff ff       	jmp    801cdb <__umoddi3+0xb3>
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d70:	72 ea                	jb     801d5c <__umoddi3+0x134>
  801d72:	89 d9                	mov    %ebx,%ecx
  801d74:	e9 62 ff ff ff       	jmp    801cdb <__umoddi3+0xb3>
