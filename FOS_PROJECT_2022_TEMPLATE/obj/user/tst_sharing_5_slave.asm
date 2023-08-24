
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  80008c:	68 c0 1c 80 00       	push   $0x801cc0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 1c 80 00       	push   $0x801cdc
  800098:	e8 d1 01 00 00       	call   80026e <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 2c 17 00 00       	call   8017ce <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 f7 1c 80 00       	push   $0x801cf7
  8000aa:	50                   	push   %eax
  8000ab:	e8 91 12 00 00       	call   801341 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 1a 14 00 00       	call   8014d5 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 fc 1c 80 00       	push   $0x801cfc
  8000c6:	e8 57 04 00 00       	call   800522 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 9c 12 00 00       	call   801375 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 20 1d 80 00       	push   $0x801d20
  8000e4:	e8 39 04 00 00       	call   800522 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 e4 13 00 00       	call   8014d5 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 38 1d 80 00       	push   $0x801d38
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 dc 1c 80 00       	push   $0x801cdc
  800112:	e8 57 01 00 00       	call   80026e <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 d7 17 00 00       	call   8018f3 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 8b 16 00 00       	call   8017b5 <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	01 d0                	add    %edx,%eax
  800136:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80013d:	01 c8                	add    %ecx,%eax
  80013f:	c1 e0 02             	shl    $0x2,%eax
  800142:	01 d0                	add    %edx,%eax
  800144:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80014b:	01 c8                	add    %ecx,%eax
  80014d:	c1 e0 02             	shl    $0x2,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	c1 e0 02             	shl    $0x2,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	c1 e0 03             	shl    $0x3,%eax
  80015a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80016f:	84 c0                	test   %al,%al
  800171:	74 0f                	je     800182 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800173:	a1 20 30 80 00       	mov    0x803020,%eax
  800178:	05 18 da 01 00       	add    $0x1da18,%eax
  80017d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800186:	7e 0a                	jle    800192 <libmain+0x73>
		binaryname = argv[0];
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	e8 98 fe ff ff       	call   800038 <_main>
  8001a0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a3:	e8 1a 14 00 00       	call   8015c2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	68 dc 1d 80 00       	push   $0x801ddc
  8001b0:	e8 6d 03 00 00       	call   800522 <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bd:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8001c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c8:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	52                   	push   %edx
  8001d2:	50                   	push   %eax
  8001d3:	68 04 1e 80 00       	push   $0x801e04
  8001d8:	e8 45 03 00 00       	call   800522 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e5:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8001f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fb:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800201:	51                   	push   %ecx
  800202:	52                   	push   %edx
  800203:	50                   	push   %eax
  800204:	68 2c 1e 80 00       	push   $0x801e2c
  800209:	e8 14 03 00 00       	call   800522 <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	50                   	push   %eax
  800220:	68 84 1e 80 00       	push   $0x801e84
  800225:	e8 f8 02 00 00       	call   800522 <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	68 dc 1d 80 00       	push   $0x801ddc
  800235:	e8 e8 02 00 00       	call   800522 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80023d:	e8 9a 13 00 00       	call   8015dc <sys_enable_interrupt>

	// exit gracefully
	exit();
  800242:	e8 19 00 00 00       	call   800260 <exit>
}
  800247:	90                   	nop
  800248:	c9                   	leave  
  800249:	c3                   	ret    

0080024a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 00                	push   $0x0
  800255:	e8 27 15 00 00       	call   801781 <sys_destroy_env>
  80025a:	83 c4 10             	add    $0x10,%esp
}
  80025d:	90                   	nop
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <exit>:

void
exit(void)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800266:	e8 7c 15 00 00       	call   8017e7 <sys_exit_env>
}
  80026b:	90                   	nop
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800274:	8d 45 10             	lea    0x10(%ebp),%eax
  800277:	83 c0 04             	add    $0x4,%eax
  80027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80027d:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800282:	85 c0                	test   %eax,%eax
  800284:	74 16                	je     80029c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800286:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	50                   	push   %eax
  80028f:	68 98 1e 80 00       	push   $0x801e98
  800294:	e8 89 02 00 00       	call   800522 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029c:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a1:	ff 75 0c             	pushl  0xc(%ebp)
  8002a4:	ff 75 08             	pushl  0x8(%ebp)
  8002a7:	50                   	push   %eax
  8002a8:	68 9d 1e 80 00       	push   $0x801e9d
  8002ad:	e8 70 02 00 00       	call   800522 <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002be:	50                   	push   %eax
  8002bf:	e8 f3 01 00 00       	call   8004b7 <vcprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	6a 00                	push   $0x0
  8002cc:	68 b9 1e 80 00       	push   $0x801eb9
  8002d1:	e8 e1 01 00 00       	call   8004b7 <vcprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d9:	e8 82 ff ff ff       	call   800260 <exit>

	// should not return here
	while (1) ;
  8002de:	eb fe                	jmp    8002de <_panic+0x70>

008002e0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 50 74             	mov    0x74(%eax),%edx
  8002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f1:	39 c2                	cmp    %eax,%edx
  8002f3:	74 14                	je     800309 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 bc 1e 80 00       	push   $0x801ebc
  8002fd:	6a 26                	push   $0x26
  8002ff:	68 08 1f 80 00       	push   $0x801f08
  800304:	e8 65 ff ff ff       	call   80026e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800309:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800310:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800317:	e9 c2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	01 d0                	add    %edx,%eax
  80032b:	8b 00                	mov    (%eax),%eax
  80032d:	85 c0                	test   %eax,%eax
  80032f:	75 08                	jne    800339 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800331:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800334:	e9 a2 00 00 00       	jmp    8003db <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800339:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800340:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800347:	eb 69                	jmp    8003b2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800349:	a1 20 30 80 00       	mov    0x803020,%eax
  80034e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800354:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800357:	89 d0                	mov    %edx,%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	01 d0                	add    %edx,%eax
  80035d:	c1 e0 03             	shl    $0x3,%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8a 40 04             	mov    0x4(%eax),%al
  800365:	84 c0                	test   %al,%al
  800367:	75 46                	jne    8003af <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800369:	a1 20 30 80 00       	mov    0x803020,%eax
  80036e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800374:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800377:	89 d0                	mov    %edx,%eax
  800379:	01 c0                	add    %eax,%eax
  80037b:	01 d0                	add    %edx,%eax
  80037d:	c1 e0 03             	shl    $0x3,%eax
  800380:	01 c8                	add    %ecx,%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800387:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800394:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c8                	add    %ecx,%eax
  8003a0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a2:	39 c2                	cmp    %eax,%edx
  8003a4:	75 09                	jne    8003af <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ad:	eb 12                	jmp    8003c1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003af:	ff 45 e8             	incl   -0x18(%ebp)
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	77 88                	ja     800349 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c5:	75 14                	jne    8003db <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	68 14 1f 80 00       	push   $0x801f14
  8003cf:	6a 3a                	push   $0x3a
  8003d1:	68 08 1f 80 00       	push   $0x801f08
  8003d6:	e8 93 fe ff ff       	call   80026e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003db:	ff 45 f0             	incl   -0x10(%ebp)
  8003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e4:	0f 8c 32 ff ff ff    	jl     80031c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f8:	eb 26                	jmp    800420 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800405:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800408:	89 d0                	mov    %edx,%eax
  80040a:	01 c0                	add    %eax,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	c1 e0 03             	shl    $0x3,%eax
  800411:	01 c8                	add    %ecx,%eax
  800413:	8a 40 04             	mov    0x4(%eax),%al
  800416:	3c 01                	cmp    $0x1,%al
  800418:	75 03                	jne    80041d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041d:	ff 45 e0             	incl   -0x20(%ebp)
  800420:	a1 20 30 80 00       	mov    0x803020,%eax
  800425:	8b 50 74             	mov    0x74(%eax),%edx
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	39 c2                	cmp    %eax,%edx
  80042d:	77 cb                	ja     8003fa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80042f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800432:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800435:	74 14                	je     80044b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	68 68 1f 80 00       	push   $0x801f68
  80043f:	6a 44                	push   $0x44
  800441:	68 08 1f 80 00       	push   $0x801f08
  800446:	e8 23 fe ff ff       	call   80026e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044b:	90                   	nop
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	8d 48 01             	lea    0x1(%eax),%ecx
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	89 0a                	mov    %ecx,(%edx)
  800461:	8b 55 08             	mov    0x8(%ebp),%edx
  800464:	88 d1                	mov    %dl,%cl
  800466:	8b 55 0c             	mov    0xc(%ebp),%edx
  800469:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	3d ff 00 00 00       	cmp    $0xff,%eax
  800477:	75 2c                	jne    8004a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800479:	a0 24 30 80 00       	mov    0x803024,%al
  80047e:	0f b6 c0             	movzbl %al,%eax
  800481:	8b 55 0c             	mov    0xc(%ebp),%edx
  800484:	8b 12                	mov    (%edx),%edx
  800486:	89 d1                	mov    %edx,%ecx
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	83 c2 08             	add    $0x8,%edx
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	50                   	push   %eax
  800492:	51                   	push   %ecx
  800493:	52                   	push   %edx
  800494:	e8 7b 0f 00 00       	call   801414 <sys_cputs>
  800499:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	8b 40 04             	mov    0x4(%eax),%eax
  8004ab:	8d 50 01             	lea    0x1(%eax),%edx
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b4:	90                   	nop
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c7:	00 00 00 
	b.cnt = 0;
  8004ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e0:	50                   	push   %eax
  8004e1:	68 4e 04 80 00       	push   $0x80044e
  8004e6:	e8 11 02 00 00       	call   8006fc <vprintfmt>
  8004eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ee:	a0 24 30 80 00       	mov    0x803024,%al
  8004f3:	0f b6 c0             	movzbl %al,%eax
  8004f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	50                   	push   %eax
  800500:	52                   	push   %edx
  800501:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800507:	83 c0 08             	add    $0x8,%eax
  80050a:	50                   	push   %eax
  80050b:	e8 04 0f 00 00       	call   801414 <sys_cputs>
  800510:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800513:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80051a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800520:	c9                   	leave  
  800521:	c3                   	ret    

00800522 <cprintf>:

int cprintf(const char *fmt, ...) {
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800528:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80052f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800532:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 f4             	pushl  -0xc(%ebp)
  80053e:	50                   	push   %eax
  80053f:	e8 73 ff ff ff       	call   8004b7 <vcprintf>
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    

0080054f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800555:	e8 68 10 00 00       	call   8015c2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	ff 75 f4             	pushl  -0xc(%ebp)
  800569:	50                   	push   %eax
  80056a:	e8 48 ff ff ff       	call   8004b7 <vcprintf>
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800575:	e8 62 10 00 00       	call   8015dc <sys_enable_interrupt>
	return cnt;
  80057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057d:	c9                   	leave  
  80057e:	c3                   	ret    

0080057f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	53                   	push   %ebx
  800583:	83 ec 14             	sub    $0x14,%esp
  800586:	8b 45 10             	mov    0x10(%ebp),%eax
  800589:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800592:	8b 45 18             	mov    0x18(%ebp),%eax
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059d:	77 55                	ja     8005f4 <printnum+0x75>
  80059f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a2:	72 05                	jb     8005a9 <printnum+0x2a>
  8005a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a7:	77 4b                	ja     8005f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005af:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	52                   	push   %edx
  8005b8:	50                   	push   %eax
  8005b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8005bf:	e8 84 14 00 00       	call   801a48 <__udivdi3>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	83 ec 04             	sub    $0x4,%esp
  8005ca:	ff 75 20             	pushl  0x20(%ebp)
  8005cd:	53                   	push   %ebx
  8005ce:	ff 75 18             	pushl  0x18(%ebp)
  8005d1:	52                   	push   %edx
  8005d2:	50                   	push   %eax
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 08             	pushl  0x8(%ebp)
  8005d9:	e8 a1 ff ff ff       	call   80057f <printnum>
  8005de:	83 c4 20             	add    $0x20,%esp
  8005e1:	eb 1a                	jmp    8005fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	ff 75 0c             	pushl  0xc(%ebp)
  8005e9:	ff 75 20             	pushl  0x20(%ebp)
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	ff d0                	call   *%eax
  8005f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fb:	7f e6                	jg     8005e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800600:	bb 00 00 00 00       	mov    $0x0,%ebx
  800605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060b:	53                   	push   %ebx
  80060c:	51                   	push   %ecx
  80060d:	52                   	push   %edx
  80060e:	50                   	push   %eax
  80060f:	e8 44 15 00 00       	call   801b58 <__umoddi3>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	05 d4 21 80 00       	add    $0x8021d4,%eax
  80061c:	8a 00                	mov    (%eax),%al
  80061e:	0f be c0             	movsbl %al,%eax
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	ff 75 0c             	pushl  0xc(%ebp)
  800627:	50                   	push   %eax
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	ff d0                	call   *%eax
  80062d:	83 c4 10             	add    $0x10,%esp
}
  800630:	90                   	nop
  800631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800639:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063d:	7e 1c                	jle    80065b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	8d 50 08             	lea    0x8(%eax),%edx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	89 10                	mov    %edx,(%eax)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	83 e8 08             	sub    $0x8,%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	eb 40                	jmp    80069b <getuint+0x65>
	else if (lflag)
  80065b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065f:	74 1e                	je     80067f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 04             	lea    0x4(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 04             	sub    $0x4,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	ba 00 00 00 00       	mov    $0x0,%edx
  80067d:	eb 1c                	jmp    80069b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 50 04             	lea    0x4(%eax),%edx
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	89 10                	mov    %edx,(%eax)
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	83 e8 04             	sub    $0x4,%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    

0080069d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a4:	7e 1c                	jle    8006c2 <getint+0x25>
		return va_arg(*ap, long long);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 08             	lea    0x8(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 08             	sub    $0x8,%eax
  8006bb:	8b 50 04             	mov    0x4(%eax),%edx
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	eb 38                	jmp    8006fa <getint+0x5d>
	else if (lflag)
  8006c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c6:	74 1a                	je     8006e2 <getint+0x45>
		return va_arg(*ap, long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 04             	lea    0x4(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 04             	sub    $0x4,%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	99                   	cltd   
  8006e0:	eb 18                	jmp    8006fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	99                   	cltd   
}
  8006fa:	5d                   	pop    %ebp
  8006fb:	c3                   	ret    

008006fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	56                   	push   %esi
  800700:	53                   	push   %ebx
  800701:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800704:	eb 17                	jmp    80071d <vprintfmt+0x21>
			if (ch == '\0')
  800706:	85 db                	test   %ebx,%ebx
  800708:	0f 84 af 03 00 00    	je     800abd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	53                   	push   %ebx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	ff d0                	call   *%eax
  80071a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071d:	8b 45 10             	mov    0x10(%ebp),%eax
  800720:	8d 50 01             	lea    0x1(%eax),%edx
  800723:	89 55 10             	mov    %edx,0x10(%ebp)
  800726:	8a 00                	mov    (%eax),%al
  800728:	0f b6 d8             	movzbl %al,%ebx
  80072b:	83 fb 25             	cmp    $0x25,%ebx
  80072e:	75 d6                	jne    800706 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800730:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800734:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800742:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800749:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800761:	83 f8 55             	cmp    $0x55,%eax
  800764:	0f 87 2b 03 00 00    	ja     800a95 <vprintfmt+0x399>
  80076a:	8b 04 85 f8 21 80 00 	mov    0x8021f8(,%eax,4),%eax
  800771:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800773:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800777:	eb d7                	jmp    800750 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800779:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077d:	eb d1                	jmp    800750 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800786:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800789:	89 d0                	mov    %edx,%eax
  80078b:	c1 e0 02             	shl    $0x2,%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	01 c0                	add    %eax,%eax
  800792:	01 d8                	add    %ebx,%eax
  800794:	83 e8 30             	sub    $0x30,%eax
  800797:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079a:	8b 45 10             	mov    0x10(%ebp),%eax
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a5:	7e 3e                	jle    8007e5 <vprintfmt+0xe9>
  8007a7:	83 fb 39             	cmp    $0x39,%ebx
  8007aa:	7f 39                	jg     8007e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007af:	eb d5                	jmp    800786 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	83 c0 04             	add    $0x4,%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 e8 04             	sub    $0x4,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c5:	eb 1f                	jmp    8007e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cb:	79 83                	jns    800750 <vprintfmt+0x54>
				width = 0;
  8007cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d4:	e9 77 ff ff ff       	jmp    800750 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e0:	e9 6b ff ff ff       	jmp    800750 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ea:	0f 89 60 ff ff ff    	jns    800750 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fd:	e9 4e ff ff ff       	jmp    800750 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800802:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800805:	e9 46 ff ff ff       	jmp    800750 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	83 c0 04             	add    $0x4,%eax
  800810:	89 45 14             	mov    %eax,0x14(%ebp)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
			break;
  80082a:	e9 89 02 00 00       	jmp    800ab8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800840:	85 db                	test   %ebx,%ebx
  800842:	79 02                	jns    800846 <vprintfmt+0x14a>
				err = -err;
  800844:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800846:	83 fb 64             	cmp    $0x64,%ebx
  800849:	7f 0b                	jg     800856 <vprintfmt+0x15a>
  80084b:	8b 34 9d 40 20 80 00 	mov    0x802040(,%ebx,4),%esi
  800852:	85 f6                	test   %esi,%esi
  800854:	75 19                	jne    80086f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800856:	53                   	push   %ebx
  800857:	68 e5 21 80 00       	push   $0x8021e5
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	ff 75 08             	pushl  0x8(%ebp)
  800862:	e8 5e 02 00 00       	call   800ac5 <printfmt>
  800867:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086a:	e9 49 02 00 00       	jmp    800ab8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086f:	56                   	push   %esi
  800870:	68 ee 21 80 00       	push   $0x8021ee
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 08             	pushl  0x8(%ebp)
  80087b:	e8 45 02 00 00       	call   800ac5 <printfmt>
  800880:	83 c4 10             	add    $0x10,%esp
			break;
  800883:	e9 30 02 00 00       	jmp    800ab8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 c0 04             	add    $0x4,%eax
  80088e:	89 45 14             	mov    %eax,0x14(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 e8 04             	sub    $0x4,%eax
  800897:	8b 30                	mov    (%eax),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 05                	jne    8008a2 <vprintfmt+0x1a6>
				p = "(null)";
  80089d:	be f1 21 80 00       	mov    $0x8021f1,%esi
			if (width > 0 && padc != '-')
  8008a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a6:	7e 6d                	jle    800915 <vprintfmt+0x219>
  8008a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ac:	74 67                	je     800915 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	50                   	push   %eax
  8008b5:	56                   	push   %esi
  8008b6:	e8 0c 03 00 00       	call   800bc7 <strnlen>
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c1:	eb 16                	jmp    8008d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	50                   	push   %eax
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	ff d0                	call   *%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008dd:	7f e4                	jg     8008c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008df:	eb 34                	jmp    800915 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e5:	74 1c                	je     800903 <vprintfmt+0x207>
  8008e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ea:	7e 05                	jle    8008f1 <vprintfmt+0x1f5>
  8008ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ef:	7e 12                	jle    800903 <vprintfmt+0x207>
					putch('?', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 3f                	push   $0x3f
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	eb 0f                	jmp    800912 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	53                   	push   %ebx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	ff 4d e4             	decl   -0x1c(%ebp)
  800915:	89 f0                	mov    %esi,%eax
  800917:	8d 70 01             	lea    0x1(%eax),%esi
  80091a:	8a 00                	mov    (%eax),%al
  80091c:	0f be d8             	movsbl %al,%ebx
  80091f:	85 db                	test   %ebx,%ebx
  800921:	74 24                	je     800947 <vprintfmt+0x24b>
  800923:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800927:	78 b8                	js     8008e1 <vprintfmt+0x1e5>
  800929:	ff 4d e0             	decl   -0x20(%ebp)
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	79 af                	jns    8008e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800932:	eb 13                	jmp    800947 <vprintfmt+0x24b>
				putch(' ', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 20                	push   $0x20
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800944:	ff 4d e4             	decl   -0x1c(%ebp)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	7f e7                	jg     800934 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094d:	e9 66 01 00 00       	jmp    800ab8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 e8             	pushl  -0x18(%ebp)
  800958:	8d 45 14             	lea    0x14(%ebp),%eax
  80095b:	50                   	push   %eax
  80095c:	e8 3c fd ff ff       	call   80069d <getint>
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800967:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800970:	85 d2                	test   %edx,%edx
  800972:	79 23                	jns    800997 <vprintfmt+0x29b>
				putch('-', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	6a 2d                	push   $0x2d
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	f7 d8                	neg    %eax
  80098c:	83 d2 00             	adc    $0x0,%edx
  80098f:	f7 da                	neg    %edx
  800991:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800994:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800997:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099e:	e9 bc 00 00 00       	jmp    800a5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a3:	83 ec 08             	sub    $0x8,%esp
  8009a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ac:	50                   	push   %eax
  8009ad:	e8 84 fc ff ff       	call   800636 <getuint>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c2:	e9 98 00 00 00       	jmp    800a5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	6a 58                	push   $0x58
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
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
			break;
  8009f7:	e9 bc 00 00 00       	jmp    800ab8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	6a 30                	push   $0x30
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	ff d0                	call   *%eax
  800a09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	6a 78                	push   $0x78
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 c0 04             	add    $0x4,%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 e8 04             	sub    $0x4,%eax
  800a2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3e:	eb 1f                	jmp    800a5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 e8             	pushl  -0x18(%ebp)
  800a46:	8d 45 14             	lea    0x14(%ebp),%eax
  800a49:	50                   	push   %eax
  800a4a:	e8 e7 fb ff ff       	call   800636 <getuint>
  800a4f:	83 c4 10             	add    $0x10,%esp
  800a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	52                   	push   %edx
  800a6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a71:	ff 75 f0             	pushl  -0x10(%ebp)
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	ff 75 08             	pushl  0x8(%ebp)
  800a7a:	e8 00 fb ff ff       	call   80057f <printnum>
  800a7f:	83 c4 20             	add    $0x20,%esp
			break;
  800a82:	eb 34                	jmp    800ab8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	53                   	push   %ebx
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
			break;
  800a93:	eb 23                	jmp    800ab8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 25                	push   $0x25
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa5:	ff 4d 10             	decl   0x10(%ebp)
  800aa8:	eb 03                	jmp    800aad <vprintfmt+0x3b1>
  800aaa:	ff 4d 10             	decl   0x10(%ebp)
  800aad:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab0:	48                   	dec    %eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	3c 25                	cmp    $0x25,%al
  800ab5:	75 f3                	jne    800aaa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab7:	90                   	nop
		}
	}
  800ab8:	e9 47 fc ff ff       	jmp    800704 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800abd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800acb:	8d 45 10             	lea    0x10(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	ff 75 f4             	pushl  -0xc(%ebp)
  800ada:	50                   	push   %eax
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 16 fc ff ff       	call   8006fc <vprintfmt>
  800ae6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8b 40 08             	mov    0x8(%eax),%eax
  800af5:	8d 50 01             	lea    0x1(%eax),%edx
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b01:	8b 10                	mov    (%eax),%edx
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 04             	mov    0x4(%eax),%eax
  800b09:	39 c2                	cmp    %eax,%edx
  800b0b:	73 12                	jae    800b1f <sprintputch+0x33>
		*b->buf++ = ch;
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 48 01             	lea    0x1(%eax),%ecx
  800b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b18:	89 0a                	mov    %ecx,(%edx)
  800b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1d:	88 10                	mov    %dl,(%eax)
}
  800b1f:	90                   	nop
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	01 d0                	add    %edx,%eax
  800b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b47:	74 06                	je     800b4f <vsnprintf+0x2d>
  800b49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4d:	7f 07                	jg     800b56 <vsnprintf+0x34>
		return -E_INVAL;
  800b4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b54:	eb 20                	jmp    800b76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b56:	ff 75 14             	pushl  0x14(%ebp)
  800b59:	ff 75 10             	pushl  0x10(%ebp)
  800b5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5f:	50                   	push   %eax
  800b60:	68 ec 0a 80 00       	push   $0x800aec
  800b65:	e8 92 fb ff ff       	call   8006fc <vprintfmt>
  800b6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b81:	83 c0 04             	add    $0x4,%eax
  800b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8d:	50                   	push   %eax
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 08             	pushl  0x8(%ebp)
  800b94:	e8 89 ff ff ff       	call   800b22 <vsnprintf>
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800baa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb1:	eb 06                	jmp    800bb9 <strlen+0x15>
		n++;
  800bb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb6:	ff 45 08             	incl   0x8(%ebp)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	84 c0                	test   %al,%al
  800bc0:	75 f1                	jne    800bb3 <strlen+0xf>
		n++;
	return n;
  800bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd4:	eb 09                	jmp    800bdf <strnlen+0x18>
		n++;
  800bd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd9:	ff 45 08             	incl   0x8(%ebp)
  800bdc:	ff 4d 0c             	decl   0xc(%ebp)
  800bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be3:	74 09                	je     800bee <strnlen+0x27>
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	84 c0                	test   %al,%al
  800bec:	75 e8                	jne    800bd6 <strnlen+0xf>
		n++;
	return n;
  800bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bff:	90                   	nop
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 08             	mov    %edx,0x8(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c12:	8a 12                	mov    (%edx),%dl
  800c14:	88 10                	mov    %dl,(%eax)
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	75 e4                	jne    800c00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 1f                	jmp    800c55 <strncpy+0x34>
		*dst++ = *src;
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8d 50 01             	lea    0x1(%eax),%edx
  800c3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	74 03                	je     800c52 <strncpy+0x31>
			src++;
  800c4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c52:	ff 45 fc             	incl   -0x4(%ebp)
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5b:	72 d9                	jb     800c36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c72:	74 30                	je     800ca4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c74:	eb 16                	jmp    800c8c <strlcpy+0x2a>
			*dst++ = *src++;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8d 50 01             	lea    0x1(%eax),%edx
  800c7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c88:	8a 12                	mov    (%edx),%dl
  800c8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8c:	ff 4d 10             	decl   0x10(%ebp)
  800c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c93:	74 09                	je     800c9e <strlcpy+0x3c>
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	75 d8                	jne    800c76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb3:	eb 06                	jmp    800cbb <strcmp+0xb>
		p++, q++;
  800cb5:	ff 45 08             	incl   0x8(%ebp)
  800cb8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	74 0e                	je     800cd2 <strcmp+0x22>
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 10                	mov    (%eax),%dl
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	38 c2                	cmp    %al,%dl
  800cd0:	74 e3                	je     800cb5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 d0             	movzbl %al,%edx
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 c0             	movzbl %al,%eax
  800ce2:	29 c2                	sub    %eax,%edx
  800ce4:	89 d0                	mov    %edx,%eax
}
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ceb:	eb 09                	jmp    800cf6 <strncmp+0xe>
		n--, p++, q++;
  800ced:	ff 4d 10             	decl   0x10(%ebp)
  800cf0:	ff 45 08             	incl   0x8(%ebp)
  800cf3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfa:	74 17                	je     800d13 <strncmp+0x2b>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	84 c0                	test   %al,%al
  800d03:	74 0e                	je     800d13 <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 10                	mov    (%eax),%dl
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	38 c2                	cmp    %al,%dl
  800d11:	74 da                	je     800ced <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d17:	75 07                	jne    800d20 <strncmp+0x38>
		return 0;
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	eb 14                	jmp    800d34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 d0             	movzbl %al,%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 c0             	movzbl %al,%eax
  800d30:	29 c2                	sub    %eax,%edx
  800d32:	89 d0                	mov    %edx,%eax
}
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 04             	sub    $0x4,%esp
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d42:	eb 12                	jmp    800d56 <strchr+0x20>
		if (*s == c)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4c:	75 05                	jne    800d53 <strchr+0x1d>
			return (char *) s;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	eb 11                	jmp    800d64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	75 e5                	jne    800d44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 04             	sub    $0x4,%esp
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d72:	eb 0d                	jmp    800d81 <strfind+0x1b>
		if (*s == c)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7c:	74 0e                	je     800d8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7e:	ff 45 08             	incl   0x8(%ebp)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 ea                	jne    800d74 <strfind+0xe>
  800d8a:	eb 01                	jmp    800d8d <strfind+0x27>
		if (*s == c)
			break;
  800d8c:	90                   	nop
	return (char *) s;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da4:	eb 0e                	jmp    800db4 <memset+0x22>
		*p++ = c;
  800da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da9:	8d 50 01             	lea    0x1(%eax),%edx
  800dac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db4:	ff 4d f8             	decl   -0x8(%ebp)
  800db7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbb:	79 e9                	jns    800da6 <memset+0x14>
		*p++ = c;

	return v;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd4:	eb 16                	jmp    800dec <memcpy+0x2a>
		*d++ = *s++;
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	8d 50 01             	lea    0x1(%eax),%edx
  800ddc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de8:	8a 12                	mov    (%edx),%dl
  800dea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df2:	89 55 10             	mov    %edx,0x10(%ebp)
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 dd                	jne    800dd6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e16:	73 50                	jae    800e68 <memmove+0x6a>
  800e18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	01 d0                	add    %edx,%eax
  800e20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e23:	76 43                	jbe    800e68 <memmove+0x6a>
		s += n;
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e31:	eb 10                	jmp    800e43 <memmove+0x45>
			*--d = *--s;
  800e33:	ff 4d f8             	decl   -0x8(%ebp)
  800e36:	ff 4d fc             	decl   -0x4(%ebp)
  800e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3c:	8a 10                	mov    (%eax),%dl
  800e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e49:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	75 e3                	jne    800e33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e50:	eb 23                	jmp    800e75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	8d 50 01             	lea    0x1(%eax),%edx
  800e58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e64:	8a 12                	mov    (%edx),%dl
  800e66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	75 dd                	jne    800e52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8c:	eb 2a                	jmp    800eb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	8a 10                	mov    (%eax),%dl
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	38 c2                	cmp    %al,%dl
  800e9a:	74 16                	je     800eb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	0f b6 d0             	movzbl %al,%edx
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	0f b6 c0             	movzbl %al,%eax
  800eac:	29 c2                	sub    %eax,%edx
  800eae:	89 d0                	mov    %edx,%eax
  800eb0:	eb 18                	jmp    800eca <memcmp+0x50>
		s1++, s2++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
  800eb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebe:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	75 c9                	jne    800e8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	01 d0                	add    %edx,%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edd:	eb 15                	jmp    800ef4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	0f b6 d0             	movzbl %al,%edx
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	0f b6 c0             	movzbl %al,%eax
  800eed:	39 c2                	cmp    %eax,%edx
  800eef:	74 0d                	je     800efe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef1:	ff 45 08             	incl   0x8(%ebp)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efa:	72 e3                	jb     800edf <memfind+0x13>
  800efc:	eb 01                	jmp    800eff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efe:	90                   	nop
	return (void *) s;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f18:	eb 03                	jmp    800f1d <strtol+0x19>
		s++;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 20                	cmp    $0x20,%al
  800f24:	74 f4                	je     800f1a <strtol+0x16>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 09                	cmp    $0x9,%al
  800f2d:	74 eb                	je     800f1a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 2b                	cmp    $0x2b,%al
  800f36:	75 05                	jne    800f3d <strtol+0x39>
		s++;
  800f38:	ff 45 08             	incl   0x8(%ebp)
  800f3b:	eb 13                	jmp    800f50 <strtol+0x4c>
	else if (*s == '-')
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	3c 2d                	cmp    $0x2d,%al
  800f44:	75 0a                	jne    800f50 <strtol+0x4c>
		s++, neg = 1;
  800f46:	ff 45 08             	incl   0x8(%ebp)
  800f49:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f54:	74 06                	je     800f5c <strtol+0x58>
  800f56:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5a:	75 20                	jne    800f7c <strtol+0x78>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	3c 30                	cmp    $0x30,%al
  800f63:	75 17                	jne    800f7c <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	40                   	inc    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 78                	cmp    $0x78,%al
  800f6d:	75 0d                	jne    800f7c <strtol+0x78>
		s += 2, base = 16;
  800f6f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f73:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7a:	eb 28                	jmp    800fa4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f80:	75 15                	jne    800f97 <strtol+0x93>
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 30                	cmp    $0x30,%al
  800f89:	75 0c                	jne    800f97 <strtol+0x93>
		s++, base = 8;
  800f8b:	ff 45 08             	incl   0x8(%ebp)
  800f8e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f95:	eb 0d                	jmp    800fa4 <strtol+0xa0>
	else if (base == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strtol+0xa0>
		base = 10;
  800f9d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 2f                	cmp    $0x2f,%al
  800fab:	7e 19                	jle    800fc6 <strtol+0xc2>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 39                	cmp    $0x39,%al
  800fb4:	7f 10                	jg     800fc6 <strtol+0xc2>
			dig = *s - '0';
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	83 e8 30             	sub    $0x30,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	eb 42                	jmp    801008 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 60                	cmp    $0x60,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xe4>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 7a                	cmp    $0x7a,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 57             	sub    $0x57,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 20                	jmp    801008 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 40                	cmp    $0x40,%al
  800fef:	7e 39                	jle    80102a <strtol+0x126>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 5a                	cmp    $0x5a,%al
  800ff8:	7f 30                	jg     80102a <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 37             	sub    $0x37,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100e:	7d 19                	jge    801029 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801010:	ff 45 08             	incl   0x8(%ebp)
  801013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801016:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101a:	89 c2                	mov    %eax,%edx
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	01 d0                	add    %edx,%eax
  801021:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801024:	e9 7b ff ff ff       	jmp    800fa4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801029:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102e:	74 08                	je     801038 <strtol+0x134>
		*endptr = (char *) s;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801038:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103c:	74 07                	je     801045 <strtol+0x141>
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	f7 d8                	neg    %eax
  801043:	eb 03                	jmp    801048 <strtol+0x144>
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <ltostr>:

void
ltostr(long value, char *str)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801057:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801062:	79 13                	jns    801077 <ltostr+0x2d>
	{
		neg = 1;
  801064:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801071:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801074:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107f:	99                   	cltd   
  801080:	f7 f9                	idiv   %ecx
  801082:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801085:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801088:	8d 50 01             	lea    0x1(%eax),%edx
  80108b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108e:	89 c2                	mov    %eax,%edx
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	01 d0                	add    %edx,%eax
  801095:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801098:	83 c2 30             	add    $0x30,%edx
  80109b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a5:	f7 e9                	imul   %ecx
  8010a7:	c1 fa 02             	sar    $0x2,%edx
  8010aa:	89 c8                	mov    %ecx,%eax
  8010ac:	c1 f8 1f             	sar    $0x1f,%eax
  8010af:	29 c2                	sub    %eax,%edx
  8010b1:	89 d0                	mov    %edx,%eax
  8010b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010be:	f7 e9                	imul   %ecx
  8010c0:	c1 fa 02             	sar    $0x2,%edx
  8010c3:	89 c8                	mov    %ecx,%eax
  8010c5:	c1 f8 1f             	sar    $0x1f,%eax
  8010c8:	29 c2                	sub    %eax,%edx
  8010ca:	89 d0                	mov    %edx,%eax
  8010cc:	c1 e0 02             	shl    $0x2,%eax
  8010cf:	01 d0                	add    %edx,%eax
  8010d1:	01 c0                	add    %eax,%eax
  8010d3:	29 c1                	sub    %eax,%ecx
  8010d5:	89 ca                	mov    %ecx,%edx
  8010d7:	85 d2                	test   %edx,%edx
  8010d9:	75 9c                	jne    801077 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e5:	48                   	dec    %eax
  8010e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ed:	74 3d                	je     80112c <ltostr+0xe2>
		start = 1 ;
  8010ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f6:	eb 34                	jmp    80112c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	01 d0                	add    %edx,%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	01 c2                	add    %eax,%edx
  80110d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 c8                	add    %ecx,%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801119:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8a 45 eb             	mov    -0x15(%ebp),%al
  801124:	88 02                	mov    %al,(%edx)
		start++ ;
  801126:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801129:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801132:	7c c4                	jl     8010f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801134:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113f:	90                   	nop
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801148:	ff 75 08             	pushl  0x8(%ebp)
  80114b:	e8 54 fa ff ff       	call   800ba4 <strlen>
  801150:	83 c4 04             	add    $0x4,%esp
  801153:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801156:	ff 75 0c             	pushl  0xc(%ebp)
  801159:	e8 46 fa ff ff       	call   800ba4 <strlen>
  80115e:	83 c4 04             	add    $0x4,%esp
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801172:	eb 17                	jmp    80118b <strcconcat+0x49>
		final[s] = str1[s] ;
  801174:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801177:	8b 45 10             	mov    0x10(%ebp),%eax
  80117a:	01 c2                	add    %eax,%edx
  80117c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	01 c8                	add    %ecx,%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801188:	ff 45 fc             	incl   -0x4(%ebp)
  80118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801191:	7c e1                	jl     801174 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801193:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a1:	eb 1f                	jmp    8011c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b1:	01 c2                	add    %eax,%edx
  8011b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	01 c8                	add    %ecx,%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011bf:	ff 45 f8             	incl   -0x8(%ebp)
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c8:	7c d9                	jl     8011a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d5:	90                   	nop
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011db:	8b 45 14             	mov    0x14(%ebp),%eax
  8011de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	8b 00                	mov    (%eax),%eax
  8011e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	01 d0                	add    %edx,%eax
  8011f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fb:	eb 0c                	jmp    801209 <strsplit+0x31>
			*string++ = 0;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 08             	mov    %edx,0x8(%ebp)
  801206:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 18                	je     80122a <strsplit+0x52>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f be c0             	movsbl %al,%eax
  80121a:	50                   	push   %eax
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	e8 13 fb ff ff       	call   800d36 <strchr>
  801223:	83 c4 08             	add    $0x8,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	75 d3                	jne    8011fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	84 c0                	test   %al,%al
  801231:	74 5a                	je     80128d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	83 f8 0f             	cmp    $0xf,%eax
  80123b:	75 07                	jne    801244 <strsplit+0x6c>
		{
			return 0;
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
  801242:	eb 66                	jmp    8012aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 48 01             	lea    0x1(%eax),%ecx
  80124c:	8b 55 14             	mov    0x14(%ebp),%edx
  80124f:	89 0a                	mov    %ecx,(%edx)
  801251:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	01 c2                	add    %eax,%edx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801262:	eb 03                	jmp    801267 <strsplit+0x8f>
			string++;
  801264:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	84 c0                	test   %al,%al
  80126e:	74 8b                	je     8011fb <strsplit+0x23>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	0f be c0             	movsbl %al,%eax
  801278:	50                   	push   %eax
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	e8 b5 fa ff ff       	call   800d36 <strchr>
  801281:	83 c4 08             	add    $0x8,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	74 dc                	je     801264 <strsplit+0x8c>
			string++;
	}
  801288:	e9 6e ff ff ff       	jmp    8011fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	8b 00                	mov    (%eax),%eax
  801293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 d0                	add    %edx,%eax
  80129f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	68 50 23 80 00       	push   $0x802350
  8012ba:	6a 0e                	push   $0xe
  8012bc:	68 8a 23 80 00       	push   $0x80238a
  8012c1:	e8 a8 ef ff ff       	call   80026e <_panic>

008012c6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8012cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	74 0f                	je     8012e4 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8012d5:	e8 d2 ff ff ff       	call   8012ac <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012da:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8012e1:	00 00 00 
	}
	if (size == 0) return NULL ;
  8012e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e8:	75 07                	jne    8012f1 <malloc+0x2b>
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ef:	eb 14                	jmp    801305 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	68 98 23 80 00       	push   $0x802398
  8012f9:	6a 2e                	push   $0x2e
  8012fb:	68 8a 23 80 00       	push   $0x80238a
  801300:	e8 69 ef ff ff       	call   80026e <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	68 c0 23 80 00       	push   $0x8023c0
  801315:	6a 49                	push   $0x49
  801317:	68 8a 23 80 00       	push   $0x80238a
  80131c:	e8 4d ef ff ff       	call   80026e <_panic>

00801321 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 18             	sub    $0x18,%esp
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80132d:	83 ec 04             	sub    $0x4,%esp
  801330:	68 e4 23 80 00       	push   $0x8023e4
  801335:	6a 57                	push   $0x57
  801337:	68 8a 23 80 00       	push   $0x80238a
  80133c:	e8 2d ef ff ff       	call   80026e <_panic>

00801341 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	68 0c 24 80 00       	push   $0x80240c
  80134f:	6a 60                	push   $0x60
  801351:	68 8a 23 80 00       	push   $0x80238a
  801356:	e8 13 ef ff ff       	call   80026e <_panic>

0080135b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	68 30 24 80 00       	push   $0x802430
  801369:	6a 7c                	push   $0x7c
  80136b:	68 8a 23 80 00       	push   $0x80238a
  801370:	e8 f9 ee ff ff       	call   80026e <_panic>

00801375 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80137b:	83 ec 04             	sub    $0x4,%esp
  80137e:	68 58 24 80 00       	push   $0x802458
  801383:	68 86 00 00 00       	push   $0x86
  801388:	68 8a 23 80 00       	push   $0x80238a
  80138d:	e8 dc ee ff ff       	call   80026e <_panic>

00801392 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	68 7c 24 80 00       	push   $0x80247c
  8013a0:	68 91 00 00 00       	push   $0x91
  8013a5:	68 8a 23 80 00       	push   $0x80238a
  8013aa:	e8 bf ee ff ff       	call   80026e <_panic>

008013af <shrink>:

}
void shrink(uint32 newSize)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	68 7c 24 80 00       	push   $0x80247c
  8013bd:	68 96 00 00 00       	push   $0x96
  8013c2:	68 8a 23 80 00       	push   $0x80238a
  8013c7:	e8 a2 ee ff ff       	call   80026e <_panic>

008013cc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	68 7c 24 80 00       	push   $0x80247c
  8013da:	68 9b 00 00 00       	push   $0x9b
  8013df:	68 8a 23 80 00       	push   $0x80238a
  8013e4:	e8 85 ee ff ff       	call   80026e <_panic>

008013e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	57                   	push   %edi
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
  8013ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801401:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801404:	cd 30                	int    $0x30
  801406:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801420:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	52                   	push   %edx
  80142c:	ff 75 0c             	pushl  0xc(%ebp)
  80142f:	50                   	push   %eax
  801430:	6a 00                	push   $0x0
  801432:	e8 b2 ff ff ff       	call   8013e9 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	90                   	nop
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_cgetc>:

int
sys_cgetc(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 01                	push   $0x1
  80144c:	e8 98 ff ff ff       	call   8013e9 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	52                   	push   %edx
  801466:	50                   	push   %eax
  801467:	6a 05                	push   $0x5
  801469:	e8 7b ff ff ff       	call   8013e9 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	56                   	push   %esi
  801477:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801478:	8b 75 18             	mov    0x18(%ebp),%esi
  80147b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80147e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	51                   	push   %ecx
  80148a:	52                   	push   %edx
  80148b:	50                   	push   %eax
  80148c:	6a 06                	push   $0x6
  80148e:	e8 56 ff ff ff       	call   8013e9 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	52                   	push   %edx
  8014ad:	50                   	push   %eax
  8014ae:	6a 07                	push   $0x7
  8014b0:	e8 34 ff ff ff       	call   8013e9 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	ff 75 08             	pushl  0x8(%ebp)
  8014c9:	6a 08                	push   $0x8
  8014cb:	e8 19 ff ff ff       	call   8013e9 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 09                	push   $0x9
  8014e4:	e8 00 ff ff ff       	call   8013e9 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 0a                	push   $0xa
  8014fd:	e8 e7 fe ff ff       	call   8013e9 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 0b                	push   $0xb
  801516:	e8 ce fe ff ff       	call   8013e9 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	ff 75 0c             	pushl  0xc(%ebp)
  80152c:	ff 75 08             	pushl  0x8(%ebp)
  80152f:	6a 0f                	push   $0xf
  801531:	e8 b3 fe ff ff       	call   8013e9 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
	return;
  801539:	90                   	nop
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	6a 10                	push   $0x10
  80154d:	e8 97 fe ff ff       	call   8013e9 <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
	return ;
  801555:	90                   	nop
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 10             	pushl  0x10(%ebp)
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	6a 11                	push   $0x11
  80156a:	e8 7a fe ff ff       	call   8013e9 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
	return ;
  801572:	90                   	nop
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 0c                	push   $0xc
  801584:	e8 60 fe ff ff       	call   8013e9 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	6a 0d                	push   $0xd
  80159e:	e8 46 fe ff ff       	call   8013e9 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 0e                	push   $0xe
  8015b7:	e8 2d fe ff ff       	call   8013e9 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	90                   	nop
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 13                	push   $0x13
  8015d1:	e8 13 fe ff ff       	call   8013e9 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	90                   	nop
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 14                	push   $0x14
  8015eb:	e8 f9 fd ff ff       	call   8013e9 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	90                   	nop
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801602:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	50                   	push   %eax
  80160f:	6a 15                	push   $0x15
  801611:	e8 d3 fd ff ff       	call   8013e9 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 16                	push   $0x16
  80162b:	e8 b9 fd ff ff       	call   8013e9 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	ff 75 0c             	pushl  0xc(%ebp)
  801645:	50                   	push   %eax
  801646:	6a 17                	push   $0x17
  801648:	e8 9c fd ff ff       	call   8013e9 <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	52                   	push   %edx
  801662:	50                   	push   %eax
  801663:	6a 1a                	push   $0x1a
  801665:	e8 7f fd ff ff       	call   8013e9 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801672:	8b 55 0c             	mov    0xc(%ebp),%edx
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	52                   	push   %edx
  80167f:	50                   	push   %eax
  801680:	6a 18                	push   $0x18
  801682:	e8 62 fd ff ff       	call   8013e9 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	90                   	nop
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	52                   	push   %edx
  80169d:	50                   	push   %eax
  80169e:	6a 19                	push   $0x19
  8016a0:	e8 44 fd ff ff       	call   8013e9 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	90                   	nop
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	6a 00                	push   $0x0
  8016c3:	51                   	push   %ecx
  8016c4:	52                   	push   %edx
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	50                   	push   %eax
  8016c9:	6a 1b                	push   $0x1b
  8016cb:	e8 19 fd ff ff       	call   8013e9 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 1c                	push   $0x1c
  8016e8:	e8 fc fc ff ff       	call   8013e9 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	51                   	push   %ecx
  801703:	52                   	push   %edx
  801704:	50                   	push   %eax
  801705:	6a 1d                	push   $0x1d
  801707:	e8 dd fc ff ff       	call   8013e9 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 1e                	push   $0x1e
  801724:	e8 c0 fc ff ff       	call   8013e9 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 1f                	push   $0x1f
  80173d:	e8 a7 fc ff ff       	call   8013e9 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 14             	pushl  0x14(%ebp)
  801752:	ff 75 10             	pushl  0x10(%ebp)
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	50                   	push   %eax
  801759:	6a 20                	push   $0x20
  80175b:	e8 89 fc ff ff       	call   8013e9 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	50                   	push   %eax
  801774:	6a 21                	push   $0x21
  801776:	e8 6e fc ff ff       	call   8013e9 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 22                	push   $0x22
  801792:	e8 52 fc ff ff       	call   8013e9 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 02                	push   $0x2
  8017ab:	e8 39 fc ff ff       	call   8013e9 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 03                	push   $0x3
  8017c4:	e8 20 fc ff ff       	call   8013e9 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 04                	push   $0x4
  8017dd:	e8 07 fc ff ff       	call   8013e9 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 23                	push   $0x23
  8017f6:	e8 ee fb ff ff       	call   8013e9 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	90                   	nop
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801807:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80180a:	8d 50 04             	lea    0x4(%eax),%edx
  80180d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	52                   	push   %edx
  801817:	50                   	push   %eax
  801818:	6a 24                	push   $0x24
  80181a:	e8 ca fb ff ff       	call   8013e9 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
	return result;
  801822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801828:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182b:	89 01                	mov    %eax,(%ecx)
  80182d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	c9                   	leave  
  801834:	c2 04 00             	ret    $0x4

00801837 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 10             	pushl  0x10(%ebp)
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	6a 12                	push   $0x12
  801849:	e8 9b fb ff ff       	call   8013e9 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
	return ;
  801851:	90                   	nop
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_rcr2>:
uint32 sys_rcr2()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 25                	push   $0x25
  801863:	e8 81 fb ff ff       	call   8013e9 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801879:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 26                	push   $0x26
  801888:	e8 5c fb ff ff       	call   8013e9 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
	return ;
  801890:	90                   	nop
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <rsttst>:
void rsttst()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 28                	push   $0x28
  8018a2:	e8 42 fb ff ff       	call   8013e9 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018aa:	90                   	nop
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8018bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	ff 75 10             	pushl  0x10(%ebp)
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 27                	push   $0x27
  8018cd:	e8 17 fb ff ff       	call   8013e9 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <chktst>:
void chktst(uint32 n)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 29                	push   $0x29
  8018e8:	e8 fc fa ff ff       	call   8013e9 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <inctst>:

void inctst()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 2a                	push   $0x2a
  801902:	e8 e2 fa ff ff       	call   8013e9 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
	return ;
  80190a:	90                   	nop
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <gettst>:
uint32 gettst()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 2b                	push   $0x2b
  80191c:	e8 c8 fa ff ff       	call   8013e9 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 2c                	push   $0x2c
  801938:	e8 ac fa ff ff       	call   8013e9 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
  801940:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801943:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801947:	75 07                	jne    801950 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801949:	b8 01 00 00 00       	mov    $0x1,%eax
  80194e:	eb 05                	jmp    801955 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 2c                	push   $0x2c
  801969:	e8 7b fa ff ff       	call   8013e9 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
  801971:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801974:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801978:	75 07                	jne    801981 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
  80197f:	eb 05                	jmp    801986 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  80199a:	e8 4a fa ff ff       	call   8013e9 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
  8019a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019a5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019a9:	75 07                	jne    8019b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b0:	eb 05                	jmp    8019b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  8019cb:	e8 19 fa ff ff       	call   8013e9 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
  8019d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019da:	75 07                	jne    8019e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e1:	eb 05                	jmp    8019e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	6a 2d                	push   $0x2d
  8019fa:	e8 ea f9 ff ff       	call   8013e9 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801a02:	90                   	nop
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	53                   	push   %ebx
  801a18:	51                   	push   %ecx
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 2e                	push   $0x2e
  801a1d:	e8 c7 f9 ff ff       	call   8013e9 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	52                   	push   %edx
  801a3a:	50                   	push   %eax
  801a3b:	6a 2f                	push   $0x2f
  801a3d:	e8 a7 f9 ff ff       	call   8013e9 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    
  801a47:	90                   	nop

00801a48 <__udivdi3>:
  801a48:	55                   	push   %ebp
  801a49:	57                   	push   %edi
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 1c             	sub    $0x1c,%esp
  801a4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5f:	89 ca                	mov    %ecx,%edx
  801a61:	89 f8                	mov    %edi,%eax
  801a63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a67:	85 f6                	test   %esi,%esi
  801a69:	75 2d                	jne    801a98 <__udivdi3+0x50>
  801a6b:	39 cf                	cmp    %ecx,%edi
  801a6d:	77 65                	ja     801ad4 <__udivdi3+0x8c>
  801a6f:	89 fd                	mov    %edi,%ebp
  801a71:	85 ff                	test   %edi,%edi
  801a73:	75 0b                	jne    801a80 <__udivdi3+0x38>
  801a75:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7a:	31 d2                	xor    %edx,%edx
  801a7c:	f7 f7                	div    %edi
  801a7e:	89 c5                	mov    %eax,%ebp
  801a80:	31 d2                	xor    %edx,%edx
  801a82:	89 c8                	mov    %ecx,%eax
  801a84:	f7 f5                	div    %ebp
  801a86:	89 c1                	mov    %eax,%ecx
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	f7 f5                	div    %ebp
  801a8c:	89 cf                	mov    %ecx,%edi
  801a8e:	89 fa                	mov    %edi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	39 ce                	cmp    %ecx,%esi
  801a9a:	77 28                	ja     801ac4 <__udivdi3+0x7c>
  801a9c:	0f bd fe             	bsr    %esi,%edi
  801a9f:	83 f7 1f             	xor    $0x1f,%edi
  801aa2:	75 40                	jne    801ae4 <__udivdi3+0x9c>
  801aa4:	39 ce                	cmp    %ecx,%esi
  801aa6:	72 0a                	jb     801ab2 <__udivdi3+0x6a>
  801aa8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aac:	0f 87 9e 00 00 00    	ja     801b50 <__udivdi3+0x108>
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	89 fa                	mov    %edi,%edx
  801ab9:	83 c4 1c             	add    $0x1c,%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5f                   	pop    %edi
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    
  801ac1:	8d 76 00             	lea    0x0(%esi),%esi
  801ac4:	31 ff                	xor    %edi,%edi
  801ac6:	31 c0                	xor    %eax,%eax
  801ac8:	89 fa                	mov    %edi,%edx
  801aca:	83 c4 1c             	add    $0x1c,%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5f                   	pop    %edi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	89 d8                	mov    %ebx,%eax
  801ad6:	f7 f7                	div    %edi
  801ad8:	31 ff                	xor    %edi,%edi
  801ada:	89 fa                	mov    %edi,%edx
  801adc:	83 c4 1c             	add    $0x1c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
  801ae4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae9:	89 eb                	mov    %ebp,%ebx
  801aeb:	29 fb                	sub    %edi,%ebx
  801aed:	89 f9                	mov    %edi,%ecx
  801aef:	d3 e6                	shl    %cl,%esi
  801af1:	89 c5                	mov    %eax,%ebp
  801af3:	88 d9                	mov    %bl,%cl
  801af5:	d3 ed                	shr    %cl,%ebp
  801af7:	89 e9                	mov    %ebp,%ecx
  801af9:	09 f1                	or     %esi,%ecx
  801afb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aff:	89 f9                	mov    %edi,%ecx
  801b01:	d3 e0                	shl    %cl,%eax
  801b03:	89 c5                	mov    %eax,%ebp
  801b05:	89 d6                	mov    %edx,%esi
  801b07:	88 d9                	mov    %bl,%cl
  801b09:	d3 ee                	shr    %cl,%esi
  801b0b:	89 f9                	mov    %edi,%ecx
  801b0d:	d3 e2                	shl    %cl,%edx
  801b0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b13:	88 d9                	mov    %bl,%cl
  801b15:	d3 e8                	shr    %cl,%eax
  801b17:	09 c2                	or     %eax,%edx
  801b19:	89 d0                	mov    %edx,%eax
  801b1b:	89 f2                	mov    %esi,%edx
  801b1d:	f7 74 24 0c          	divl   0xc(%esp)
  801b21:	89 d6                	mov    %edx,%esi
  801b23:	89 c3                	mov    %eax,%ebx
  801b25:	f7 e5                	mul    %ebp
  801b27:	39 d6                	cmp    %edx,%esi
  801b29:	72 19                	jb     801b44 <__udivdi3+0xfc>
  801b2b:	74 0b                	je     801b38 <__udivdi3+0xf0>
  801b2d:	89 d8                	mov    %ebx,%eax
  801b2f:	31 ff                	xor    %edi,%edi
  801b31:	e9 58 ff ff ff       	jmp    801a8e <__udivdi3+0x46>
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b3c:	89 f9                	mov    %edi,%ecx
  801b3e:	d3 e2                	shl    %cl,%edx
  801b40:	39 c2                	cmp    %eax,%edx
  801b42:	73 e9                	jae    801b2d <__udivdi3+0xe5>
  801b44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b47:	31 ff                	xor    %edi,%edi
  801b49:	e9 40 ff ff ff       	jmp    801a8e <__udivdi3+0x46>
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	31 c0                	xor    %eax,%eax
  801b52:	e9 37 ff ff ff       	jmp    801a8e <__udivdi3+0x46>
  801b57:	90                   	nop

00801b58 <__umoddi3>:
  801b58:	55                   	push   %ebp
  801b59:	57                   	push   %edi
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 1c             	sub    $0x1c,%esp
  801b5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b77:	89 f3                	mov    %esi,%ebx
  801b79:	89 fa                	mov    %edi,%edx
  801b7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b7f:	89 34 24             	mov    %esi,(%esp)
  801b82:	85 c0                	test   %eax,%eax
  801b84:	75 1a                	jne    801ba0 <__umoddi3+0x48>
  801b86:	39 f7                	cmp    %esi,%edi
  801b88:	0f 86 a2 00 00 00    	jbe    801c30 <__umoddi3+0xd8>
  801b8e:	89 c8                	mov    %ecx,%eax
  801b90:	89 f2                	mov    %esi,%edx
  801b92:	f7 f7                	div    %edi
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	31 d2                	xor    %edx,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	39 f0                	cmp    %esi,%eax
  801ba2:	0f 87 ac 00 00 00    	ja     801c54 <__umoddi3+0xfc>
  801ba8:	0f bd e8             	bsr    %eax,%ebp
  801bab:	83 f5 1f             	xor    $0x1f,%ebp
  801bae:	0f 84 ac 00 00 00    	je     801c60 <__umoddi3+0x108>
  801bb4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb9:	29 ef                	sub    %ebp,%edi
  801bbb:	89 fe                	mov    %edi,%esi
  801bbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bc1:	89 e9                	mov    %ebp,%ecx
  801bc3:	d3 e0                	shl    %cl,%eax
  801bc5:	89 d7                	mov    %edx,%edi
  801bc7:	89 f1                	mov    %esi,%ecx
  801bc9:	d3 ef                	shr    %cl,%edi
  801bcb:	09 c7                	or     %eax,%edi
  801bcd:	89 e9                	mov    %ebp,%ecx
  801bcf:	d3 e2                	shl    %cl,%edx
  801bd1:	89 14 24             	mov    %edx,(%esp)
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	d3 e0                	shl    %cl,%eax
  801bd8:	89 c2                	mov    %eax,%edx
  801bda:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bde:	d3 e0                	shl    %cl,%eax
  801be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be8:	89 f1                	mov    %esi,%ecx
  801bea:	d3 e8                	shr    %cl,%eax
  801bec:	09 d0                	or     %edx,%eax
  801bee:	d3 eb                	shr    %cl,%ebx
  801bf0:	89 da                	mov    %ebx,%edx
  801bf2:	f7 f7                	div    %edi
  801bf4:	89 d3                	mov    %edx,%ebx
  801bf6:	f7 24 24             	mull   (%esp)
  801bf9:	89 c6                	mov    %eax,%esi
  801bfb:	89 d1                	mov    %edx,%ecx
  801bfd:	39 d3                	cmp    %edx,%ebx
  801bff:	0f 82 87 00 00 00    	jb     801c8c <__umoddi3+0x134>
  801c05:	0f 84 91 00 00 00    	je     801c9c <__umoddi3+0x144>
  801c0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c0f:	29 f2                	sub    %esi,%edx
  801c11:	19 cb                	sbb    %ecx,%ebx
  801c13:	89 d8                	mov    %ebx,%eax
  801c15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c19:	d3 e0                	shl    %cl,%eax
  801c1b:	89 e9                	mov    %ebp,%ecx
  801c1d:	d3 ea                	shr    %cl,%edx
  801c1f:	09 d0                	or     %edx,%eax
  801c21:	89 e9                	mov    %ebp,%ecx
  801c23:	d3 eb                	shr    %cl,%ebx
  801c25:	89 da                	mov    %ebx,%edx
  801c27:	83 c4 1c             	add    $0x1c,%esp
  801c2a:	5b                   	pop    %ebx
  801c2b:	5e                   	pop    %esi
  801c2c:	5f                   	pop    %edi
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    
  801c2f:	90                   	nop
  801c30:	89 fd                	mov    %edi,%ebp
  801c32:	85 ff                	test   %edi,%edi
  801c34:	75 0b                	jne    801c41 <__umoddi3+0xe9>
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	31 d2                	xor    %edx,%edx
  801c3d:	f7 f7                	div    %edi
  801c3f:	89 c5                	mov    %eax,%ebp
  801c41:	89 f0                	mov    %esi,%eax
  801c43:	31 d2                	xor    %edx,%edx
  801c45:	f7 f5                	div    %ebp
  801c47:	89 c8                	mov    %ecx,%eax
  801c49:	f7 f5                	div    %ebp
  801c4b:	89 d0                	mov    %edx,%eax
  801c4d:	e9 44 ff ff ff       	jmp    801b96 <__umoddi3+0x3e>
  801c52:	66 90                	xchg   %ax,%ax
  801c54:	89 c8                	mov    %ecx,%eax
  801c56:	89 f2                	mov    %esi,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	3b 04 24             	cmp    (%esp),%eax
  801c63:	72 06                	jb     801c6b <__umoddi3+0x113>
  801c65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c69:	77 0f                	ja     801c7a <__umoddi3+0x122>
  801c6b:	89 f2                	mov    %esi,%edx
  801c6d:	29 f9                	sub    %edi,%ecx
  801c6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c73:	89 14 24             	mov    %edx,(%esp)
  801c76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c7e:	8b 14 24             	mov    (%esp),%edx
  801c81:	83 c4 1c             	add    $0x1c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	8d 76 00             	lea    0x0(%esi),%esi
  801c8c:	2b 04 24             	sub    (%esp),%eax
  801c8f:	19 fa                	sbb    %edi,%edx
  801c91:	89 d1                	mov    %edx,%ecx
  801c93:	89 c6                	mov    %eax,%esi
  801c95:	e9 71 ff ff ff       	jmp    801c0b <__umoddi3+0xb3>
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ca0:	72 ea                	jb     801c8c <__umoddi3+0x134>
  801ca2:	89 d9                	mov    %ebx,%ecx
  801ca4:	e9 62 ff ff ff       	jmp    801c0b <__umoddi3+0xb3>
