
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 b6 01 00 00       	call   8001ec <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 80 1d 80 00       	push   $0x801d80
  800092:	6a 13                	push   $0x13
  800094:	68 9c 1d 80 00       	push   $0x801d9c
  800099:	e8 9d 02 00 00       	call   80033b <_panic>
	}

	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 f8 17 00 00       	call   80189b <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 e4 15 00 00       	call   80168f <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 f2 14 00 00       	call   8015a2 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 b7 1d 80 00       	push   $0x801db7
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 4b 13 00 00       	call   80140e <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 bc 1d 80 00       	push   $0x801dbc
  8000da:	6a 1e                	push   $0x1e
  8000dc:	68 9c 1d 80 00       	push   $0x801d9c
  8000e1:	e8 55 02 00 00       	call   80033b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 b4 14 00 00       	call   8015a2 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 1c 1e 80 00       	push   $0x801e1c
  8000ff:	6a 1f                	push   $0x1f
  800101:	68 9c 1d 80 00       	push   $0x801d9c
  800106:	e8 30 02 00 00       	call   80033b <_panic>
	sys_enable_interrupt();
  80010b:	e8 99 15 00 00       	call   8016a9 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 7a 15 00 00       	call   80168f <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 88 14 00 00       	call   8015a2 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ad 1e 80 00       	push   $0x801ead
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 e1 12 00 00       	call   80140e <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 bc 1d 80 00       	push   $0x801dbc
  800144:	6a 25                	push   $0x25
  800146:	68 9c 1d 80 00       	push   $0x801d9c
  80014b:	e8 eb 01 00 00       	call   80033b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 4d 14 00 00       	call   8015a2 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 1c 1e 80 00       	push   $0x801e1c
  800166:	6a 26                	push   $0x26
  800168:	68 9c 1d 80 00       	push   $0x801d9c
  80016d:	e8 c9 01 00 00       	call   80033b <_panic>
	sys_enable_interrupt();
  800172:	e8 32 15 00 00       	call   8016a9 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 0a             	cmp    $0xa,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 b0 1e 80 00       	push   $0x801eb0
  800189:	6a 29                	push   $0x29
  80018b:	68 9c 1d 80 00       	push   $0x801d9c
  800190:	e8 a6 01 00 00       	call   80033b <_panic>

	//Edit the writable object
	*z = 30;
  800195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800198:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80019e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a1:	8b 00                	mov    (%eax),%eax
  8001a3:	83 f8 1e             	cmp    $0x1e,%eax
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 b0 1e 80 00       	push   $0x801eb0
  8001b0:	6a 2d                	push   $0x2d
  8001b2:	68 9c 1d 80 00       	push   $0x801d9c
  8001b7:	e8 7f 01 00 00       	call   80033b <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001bc:	83 ec 08             	sub    $0x8,%esp
  8001bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c2:	68 e8 1e 80 00       	push   $0x801ee8
  8001c7:	e8 23 04 00 00       	call   8005ef <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d2:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 18 1f 80 00       	push   $0x801f18
  8001e0:	6a 33                	push   $0x33
  8001e2:	68 9c 1d 80 00       	push   $0x801d9c
  8001e7:	e8 4f 01 00 00       	call   80033b <_panic>

008001ec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f2:	e8 8b 16 00 00       	call   801882 <sys_getenvindex>
  8001f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fd:	89 d0                	mov    %edx,%eax
  8001ff:	01 c0                	add    %eax,%eax
  800201:	01 d0                	add    %edx,%eax
  800203:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800218:	01 c8                	add    %ecx,%eax
  80021a:	c1 e0 02             	shl    $0x2,%eax
  80021d:	01 d0                	add    %edx,%eax
  80021f:	c1 e0 02             	shl    $0x2,%eax
  800222:	01 d0                	add    %edx,%eax
  800224:	c1 e0 03             	shl    $0x3,%eax
  800227:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80022c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800231:	a1 20 30 80 00       	mov    0x803020,%eax
  800236:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80023c:	84 c0                	test   %al,%al
  80023e:	74 0f                	je     80024f <libmain+0x63>
		binaryname = myEnv->prog_name;
  800240:	a1 20 30 80 00       	mov    0x803020,%eax
  800245:	05 18 da 01 00       	add    $0x1da18,%eax
  80024a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800253:	7e 0a                	jle    80025f <libmain+0x73>
		binaryname = argv[0];
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
  800258:	8b 00                	mov    (%eax),%eax
  80025a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	ff 75 08             	pushl  0x8(%ebp)
  800268:	e8 cb fd ff ff       	call   800038 <_main>
  80026d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800270:	e8 1a 14 00 00       	call   80168f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 74 1f 80 00       	push   $0x801f74
  80027d:	e8 6d 03 00 00       	call   8005ef <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800285:	a1 20 30 80 00       	mov    0x803020,%eax
  80028a:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800290:	a1 20 30 80 00       	mov    0x803020,%eax
  800295:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	52                   	push   %edx
  80029f:	50                   	push   %eax
  8002a0:	68 9c 1f 80 00       	push   $0x801f9c
  8002a5:	e8 45 03 00 00       	call   8005ef <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b2:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8002b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bd:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8002c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c8:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8002ce:	51                   	push   %ecx
  8002cf:	52                   	push   %edx
  8002d0:	50                   	push   %eax
  8002d1:	68 c4 1f 80 00       	push   $0x801fc4
  8002d6:	e8 14 03 00 00       	call   8005ef <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002de:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e3:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	50                   	push   %eax
  8002ed:	68 1c 20 80 00       	push   $0x80201c
  8002f2:	e8 f8 02 00 00       	call   8005ef <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 74 1f 80 00       	push   $0x801f74
  800302:	e8 e8 02 00 00       	call   8005ef <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80030a:	e8 9a 13 00 00       	call   8016a9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80030f:	e8 19 00 00 00       	call   80032d <exit>
}
  800314:	90                   	nop
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	6a 00                	push   $0x0
  800322:	e8 27 15 00 00       	call   80184e <sys_destroy_env>
  800327:	83 c4 10             	add    $0x10,%esp
}
  80032a:	90                   	nop
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <exit>:

void
exit(void)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800333:	e8 7c 15 00 00       	call   8018b4 <sys_exit_env>
}
  800338:	90                   	nop
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800341:	8d 45 10             	lea    0x10(%ebp),%eax
  800344:	83 c0 04             	add    $0x4,%eax
  800347:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80034a:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	74 16                	je     800369 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800353:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	50                   	push   %eax
  80035c:	68 30 20 80 00       	push   $0x802030
  800361:	e8 89 02 00 00       	call   8005ef <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800369:	a1 00 30 80 00       	mov    0x803000,%eax
  80036e:	ff 75 0c             	pushl  0xc(%ebp)
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	50                   	push   %eax
  800375:	68 35 20 80 00       	push   $0x802035
  80037a:	e8 70 02 00 00       	call   8005ef <cprintf>
  80037f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	ff 75 f4             	pushl  -0xc(%ebp)
  80038b:	50                   	push   %eax
  80038c:	e8 f3 01 00 00       	call   800584 <vcprintf>
  800391:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	6a 00                	push   $0x0
  800399:	68 51 20 80 00       	push   $0x802051
  80039e:	e8 e1 01 00 00       	call   800584 <vcprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a6:	e8 82 ff ff ff       	call   80032d <exit>

	// should not return here
	while (1) ;
  8003ab:	eb fe                	jmp    8003ab <_panic+0x70>

008003ad <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b8:	8b 50 74             	mov    0x74(%eax),%edx
  8003bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	74 14                	je     8003d6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	68 54 20 80 00       	push   $0x802054
  8003ca:	6a 26                	push   $0x26
  8003cc:	68 a0 20 80 00       	push   $0x8020a0
  8003d1:	e8 65 ff ff ff       	call   80033b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e4:	e9 c2 00 00 00       	jmp    8004ab <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	85 c0                	test   %eax,%eax
  8003fc:	75 08                	jne    800406 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003fe:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800401:	e9 a2 00 00 00       	jmp    8004a8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800406:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800414:	eb 69                	jmp    80047f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800416:	a1 20 30 80 00       	mov    0x803020,%eax
  80041b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800421:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800424:	89 d0                	mov    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	c1 e0 03             	shl    $0x3,%eax
  80042d:	01 c8                	add    %ecx,%eax
  80042f:	8a 40 04             	mov    0x4(%eax),%al
  800432:	84 c0                	test   %al,%al
  800434:	75 46                	jne    80047c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800436:	a1 20 30 80 00       	mov    0x803020,%eax
  80043b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800441:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800444:	89 d0                	mov    %edx,%eax
  800446:	01 c0                	add    %eax,%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	c1 e0 03             	shl    $0x3,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800454:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800457:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80046f:	39 c2                	cmp    %eax,%edx
  800471:	75 09                	jne    80047c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800473:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80047a:	eb 12                	jmp    80048e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047c:	ff 45 e8             	incl   -0x18(%ebp)
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 50 74             	mov    0x74(%eax),%edx
  800487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80048a:	39 c2                	cmp    %eax,%edx
  80048c:	77 88                	ja     800416 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80048e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800492:	75 14                	jne    8004a8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 ac 20 80 00       	push   $0x8020ac
  80049c:	6a 3a                	push   $0x3a
  80049e:	68 a0 20 80 00       	push   $0x8020a0
  8004a3:	e8 93 fe ff ff       	call   80033b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a8:	ff 45 f0             	incl   -0x10(%ebp)
  8004ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b1:	0f 8c 32 ff ff ff    	jl     8003e9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004c5:	eb 26                	jmp    8004ed <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d5:	89 d0                	mov    %edx,%eax
  8004d7:	01 c0                	add    %eax,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	c1 e0 03             	shl    $0x3,%eax
  8004de:	01 c8                	add    %ecx,%eax
  8004e0:	8a 40 04             	mov    0x4(%eax),%al
  8004e3:	3c 01                	cmp    $0x1,%al
  8004e5:	75 03                	jne    8004ea <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ea:	ff 45 e0             	incl   -0x20(%ebp)
  8004ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f2:	8b 50 74             	mov    0x74(%eax),%edx
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	39 c2                	cmp    %eax,%edx
  8004fa:	77 cb                	ja     8004c7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800502:	74 14                	je     800518 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800504:	83 ec 04             	sub    $0x4,%esp
  800507:	68 00 21 80 00       	push   $0x802100
  80050c:	6a 44                	push   $0x44
  80050e:	68 a0 20 80 00       	push   $0x8020a0
  800513:	e8 23 fe ff ff       	call   80033b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800518:	90                   	nop
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 48 01             	lea    0x1(%eax),%ecx
  800529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052c:	89 0a                	mov    %ecx,(%edx)
  80052e:	8b 55 08             	mov    0x8(%ebp),%edx
  800531:	88 d1                	mov    %dl,%cl
  800533:	8b 55 0c             	mov    0xc(%ebp),%edx
  800536:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	75 2c                	jne    800572 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800546:	a0 24 30 80 00       	mov    0x803024,%al
  80054b:	0f b6 c0             	movzbl %al,%eax
  80054e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800551:	8b 12                	mov    (%edx),%edx
  800553:	89 d1                	mov    %edx,%ecx
  800555:	8b 55 0c             	mov    0xc(%ebp),%edx
  800558:	83 c2 08             	add    $0x8,%edx
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	50                   	push   %eax
  80055f:	51                   	push   %ecx
  800560:	52                   	push   %edx
  800561:	e8 7b 0f 00 00       	call   8014e1 <sys_cputs>
  800566:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	8b 40 04             	mov    0x4(%eax),%eax
  800578:	8d 50 01             	lea    0x1(%eax),%edx
  80057b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800581:	90                   	nop
  800582:	c9                   	leave  
  800583:	c3                   	ret    

00800584 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
  800587:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80058d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800594:	00 00 00 
	b.cnt = 0;
  800597:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80059e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005a1:	ff 75 0c             	pushl  0xc(%ebp)
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ad:	50                   	push   %eax
  8005ae:	68 1b 05 80 00       	push   $0x80051b
  8005b3:	e8 11 02 00 00       	call   8007c9 <vprintfmt>
  8005b8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005bb:	a0 24 30 80 00       	mov    0x803024,%al
  8005c0:	0f b6 c0             	movzbl %al,%eax
  8005c3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	50                   	push   %eax
  8005cd:	52                   	push   %edx
  8005ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d4:	83 c0 08             	add    $0x8,%eax
  8005d7:	50                   	push   %eax
  8005d8:	e8 04 0f 00 00       	call   8014e1 <sys_cputs>
  8005dd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005e0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <cprintf>:

int cprintf(const char *fmt, ...) {
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	50                   	push   %eax
  80060c:	e8 73 ff ff ff       	call   800584 <vcprintf>
  800611:	83 c4 10             	add    $0x10,%esp
  800614:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061a:	c9                   	leave  
  80061b:	c3                   	ret    

0080061c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80061c:	55                   	push   %ebp
  80061d:	89 e5                	mov    %esp,%ebp
  80061f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800622:	e8 68 10 00 00       	call   80168f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800627:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 f4             	pushl  -0xc(%ebp)
  800636:	50                   	push   %eax
  800637:	e8 48 ff ff ff       	call   800584 <vcprintf>
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800642:	e8 62 10 00 00       	call   8016a9 <sys_enable_interrupt>
	return cnt;
  800647:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064a:	c9                   	leave  
  80064b:	c3                   	ret    

0080064c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 14             	sub    $0x14,%esp
  800653:	8b 45 10             	mov    0x10(%ebp),%eax
  800656:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80065f:	8b 45 18             	mov    0x18(%ebp),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066a:	77 55                	ja     8006c1 <printnum+0x75>
  80066c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066f:	72 05                	jb     800676 <printnum+0x2a>
  800671:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800674:	77 4b                	ja     8006c1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800676:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800679:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80067c:	8b 45 18             	mov    0x18(%ebp),%eax
  80067f:	ba 00 00 00 00       	mov    $0x0,%edx
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	ff 75 f4             	pushl  -0xc(%ebp)
  800689:	ff 75 f0             	pushl  -0x10(%ebp)
  80068c:	e8 83 14 00 00       	call   801b14 <__udivdi3>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	ff 75 20             	pushl  0x20(%ebp)
  80069a:	53                   	push   %ebx
  80069b:	ff 75 18             	pushl  0x18(%ebp)
  80069e:	52                   	push   %edx
  80069f:	50                   	push   %eax
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	ff 75 08             	pushl  0x8(%ebp)
  8006a6:	e8 a1 ff ff ff       	call   80064c <printnum>
  8006ab:	83 c4 20             	add    $0x20,%esp
  8006ae:	eb 1a                	jmp    8006ca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	ff 75 20             	pushl  0x20(%ebp)
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c1:	ff 4d 1c             	decl   0x1c(%ebp)
  8006c4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c8:	7f e6                	jg     8006b0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d8:	53                   	push   %ebx
  8006d9:	51                   	push   %ecx
  8006da:	52                   	push   %edx
  8006db:	50                   	push   %eax
  8006dc:	e8 43 15 00 00       	call   801c24 <__umoddi3>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	05 74 23 80 00       	add    $0x802374,%eax
  8006e9:	8a 00                	mov    (%eax),%al
  8006eb:	0f be c0             	movsbl %al,%eax
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	50                   	push   %eax
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	ff d0                	call   *%eax
  8006fa:	83 c4 10             	add    $0x10,%esp
}
  8006fd:	90                   	nop
  8006fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800701:	c9                   	leave  
  800702:	c3                   	ret    

00800703 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800706:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070a:	7e 1c                	jle    800728 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 08             	lea    0x8(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 08             	sub    $0x8,%eax
  800721:	8b 50 04             	mov    0x4(%eax),%edx
  800724:	8b 00                	mov    (%eax),%eax
  800726:	eb 40                	jmp    800768 <getuint+0x65>
	else if (lflag)
  800728:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80072c:	74 1e                	je     80074c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	8d 50 04             	lea    0x4(%eax),%edx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	89 10                	mov    %edx,(%eax)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
  80074a:	eb 1c                	jmp    800768 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	89 10                	mov    %edx,(%eax)
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	83 e8 04             	sub    $0x4,%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    

0080076a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80076d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800771:	7e 1c                	jle    80078f <getint+0x25>
		return va_arg(*ap, long long);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 08             	lea    0x8(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 08             	sub    $0x8,%eax
  800788:	8b 50 04             	mov    0x4(%eax),%edx
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	eb 38                	jmp    8007c7 <getint+0x5d>
	else if (lflag)
  80078f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800793:	74 1a                	je     8007af <getint+0x45>
		return va_arg(*ap, long);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	89 10                	mov    %edx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	99                   	cltd   
  8007ad:	eb 18                	jmp    8007c7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	8d 50 04             	lea    0x4(%eax),%edx
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	89 10                	mov    %edx,(%eax)
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	83 e8 04             	sub    $0x4,%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	99                   	cltd   
}
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	56                   	push   %esi
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d1:	eb 17                	jmp    8007ea <vprintfmt+0x21>
			if (ch == '\0')
  8007d3:	85 db                	test   %ebx,%ebx
  8007d5:	0f 84 af 03 00 00    	je     800b8a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	53                   	push   %ebx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	8d 50 01             	lea    0x1(%eax),%edx
  8007f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f3:	8a 00                	mov    (%eax),%al
  8007f5:	0f b6 d8             	movzbl %al,%ebx
  8007f8:	83 fb 25             	cmp    $0x25,%ebx
  8007fb:	75 d6                	jne    8007d3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007fd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800801:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800808:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80080f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800816:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80082e:	83 f8 55             	cmp    $0x55,%eax
  800831:	0f 87 2b 03 00 00    	ja     800b62 <vprintfmt+0x399>
  800837:	8b 04 85 98 23 80 00 	mov    0x802398(,%eax,4),%eax
  80083e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800840:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800844:	eb d7                	jmp    80081d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800846:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80084a:	eb d1                	jmp    80081d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800853:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800856:	89 d0                	mov    %edx,%eax
  800858:	c1 e0 02             	shl    $0x2,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	01 c0                	add    %eax,%eax
  80085f:	01 d8                	add    %ebx,%eax
  800861:	83 e8 30             	sub    $0x30,%eax
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	8a 00                	mov    (%eax),%al
  80086c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80086f:	83 fb 2f             	cmp    $0x2f,%ebx
  800872:	7e 3e                	jle    8008b2 <vprintfmt+0xe9>
  800874:	83 fb 39             	cmp    $0x39,%ebx
  800877:	7f 39                	jg     8008b2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800879:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087c:	eb d5                	jmp    800853 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800892:	eb 1f                	jmp    8008b3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800894:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800898:	79 83                	jns    80081d <vprintfmt+0x54>
				width = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a1:	e9 77 ff ff ff       	jmp    80081d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ad:	e9 6b ff ff ff       	jmp    80081d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	0f 89 60 ff ff ff    	jns    80081d <vprintfmt+0x54>
				width = precision, precision = -1;
  8008bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ca:	e9 4e ff ff ff       	jmp    80081d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008cf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d2:	e9 46 ff ff ff       	jmp    80081d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			break;
  8008f7:	e9 89 02 00 00       	jmp    800b85 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	83 c0 04             	add    $0x4,%eax
  800902:	89 45 14             	mov    %eax,0x14(%ebp)
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	83 e8 04             	sub    $0x4,%eax
  80090b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80090d:	85 db                	test   %ebx,%ebx
  80090f:	79 02                	jns    800913 <vprintfmt+0x14a>
				err = -err;
  800911:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800913:	83 fb 64             	cmp    $0x64,%ebx
  800916:	7f 0b                	jg     800923 <vprintfmt+0x15a>
  800918:	8b 34 9d e0 21 80 00 	mov    0x8021e0(,%ebx,4),%esi
  80091f:	85 f6                	test   %esi,%esi
  800921:	75 19                	jne    80093c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800923:	53                   	push   %ebx
  800924:	68 85 23 80 00       	push   $0x802385
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	ff 75 08             	pushl  0x8(%ebp)
  80092f:	e8 5e 02 00 00       	call   800b92 <printfmt>
  800934:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800937:	e9 49 02 00 00       	jmp    800b85 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093c:	56                   	push   %esi
  80093d:	68 8e 23 80 00       	push   $0x80238e
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 45 02 00 00       	call   800b92 <printfmt>
  80094d:	83 c4 10             	add    $0x10,%esp
			break;
  800950:	e9 30 02 00 00       	jmp    800b85 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 c0 04             	add    $0x4,%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 e8 04             	sub    $0x4,%eax
  800964:	8b 30                	mov    (%eax),%esi
  800966:	85 f6                	test   %esi,%esi
  800968:	75 05                	jne    80096f <vprintfmt+0x1a6>
				p = "(null)";
  80096a:	be 91 23 80 00       	mov    $0x802391,%esi
			if (width > 0 && padc != '-')
  80096f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800973:	7e 6d                	jle    8009e2 <vprintfmt+0x219>
  800975:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800979:	74 67                	je     8009e2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80097b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	50                   	push   %eax
  800982:	56                   	push   %esi
  800983:	e8 0c 03 00 00       	call   800c94 <strnlen>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80098e:	eb 16                	jmp    8009a6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800990:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	50                   	push   %eax
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	ff d0                	call   *%eax
  8009a0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009aa:	7f e4                	jg     800990 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ac:	eb 34                	jmp    8009e2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b2:	74 1c                	je     8009d0 <vprintfmt+0x207>
  8009b4:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b7:	7e 05                	jle    8009be <vprintfmt+0x1f5>
  8009b9:	83 fb 7e             	cmp    $0x7e,%ebx
  8009bc:	7e 12                	jle    8009d0 <vprintfmt+0x207>
					putch('?', putdat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	6a 3f                	push   $0x3f
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	ff d0                	call   *%eax
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	eb 0f                	jmp    8009df <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e2:	89 f0                	mov    %esi,%eax
  8009e4:	8d 70 01             	lea    0x1(%eax),%esi
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f be d8             	movsbl %al,%ebx
  8009ec:	85 db                	test   %ebx,%ebx
  8009ee:	74 24                	je     800a14 <vprintfmt+0x24b>
  8009f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f4:	78 b8                	js     8009ae <vprintfmt+0x1e5>
  8009f6:	ff 4d e0             	decl   -0x20(%ebp)
  8009f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009fd:	79 af                	jns    8009ae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ff:	eb 13                	jmp    800a14 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 20                	push   $0x20
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a11:	ff 4d e4             	decl   -0x1c(%ebp)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	7f e7                	jg     800a01 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a1a:	e9 66 01 00 00       	jmp    800b85 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 e8             	pushl  -0x18(%ebp)
  800a25:	8d 45 14             	lea    0x14(%ebp),%eax
  800a28:	50                   	push   %eax
  800a29:	e8 3c fd ff ff       	call   80076a <getint>
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3d:	85 d2                	test   %edx,%edx
  800a3f:	79 23                	jns    800a64 <vprintfmt+0x29b>
				putch('-', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	6a 2d                	push   $0x2d
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a57:	f7 d8                	neg    %eax
  800a59:	83 d2 00             	adc    $0x0,%edx
  800a5c:	f7 da                	neg    %edx
  800a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6b:	e9 bc 00 00 00       	jmp    800b2c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 e8             	pushl  -0x18(%ebp)
  800a76:	8d 45 14             	lea    0x14(%ebp),%eax
  800a79:	50                   	push   %eax
  800a7a:	e8 84 fc ff ff       	call   800703 <getuint>
  800a7f:	83 c4 10             	add    $0x10,%esp
  800a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a8f:	e9 98 00 00 00       	jmp    800b2c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	6a 58                	push   $0x58
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	6a 58                	push   $0x58
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 58                	push   $0x58
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			break;
  800ac4:	e9 bc 00 00 00       	jmp    800b85 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 30                	push   $0x30
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 78                	push   $0x78
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	83 c0 04             	add    $0x4,%eax
  800aef:	89 45 14             	mov    %eax,0x14(%ebp)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 e8 04             	sub    $0x4,%eax
  800af8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b0b:	eb 1f                	jmp    800b2c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 e8             	pushl  -0x18(%ebp)
  800b13:	8d 45 14             	lea    0x14(%ebp),%eax
  800b16:	50                   	push   %eax
  800b17:	e8 e7 fb ff ff       	call   800703 <getuint>
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b2c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b33:	83 ec 04             	sub    $0x4,%esp
  800b36:	52                   	push   %edx
  800b37:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	ff 75 08             	pushl  0x8(%ebp)
  800b47:	e8 00 fb ff ff       	call   80064c <printnum>
  800b4c:	83 c4 20             	add    $0x20,%esp
			break;
  800b4f:	eb 34                	jmp    800b85 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	53                   	push   %ebx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
			break;
  800b60:	eb 23                	jmp    800b85 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	6a 25                	push   $0x25
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b72:	ff 4d 10             	decl   0x10(%ebp)
  800b75:	eb 03                	jmp    800b7a <vprintfmt+0x3b1>
  800b77:	ff 4d 10             	decl   0x10(%ebp)
  800b7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7d:	48                   	dec    %eax
  800b7e:	8a 00                	mov    (%eax),%al
  800b80:	3c 25                	cmp    $0x25,%al
  800b82:	75 f3                	jne    800b77 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b84:	90                   	nop
		}
	}
  800b85:	e9 47 fc ff ff       	jmp    8007d1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b8a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b98:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9b:	83 c0 04             	add    $0x4,%eax
  800b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 16 fc ff ff       	call   8007c9 <vprintfmt>
  800bb3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb6:	90                   	nop
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    

00800bb9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8b 40 08             	mov    0x8(%eax),%eax
  800bc2:	8d 50 01             	lea    0x1(%eax),%edx
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 10                	mov    (%eax),%edx
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8b 40 04             	mov    0x4(%eax),%eax
  800bd6:	39 c2                	cmp    %eax,%edx
  800bd8:	73 12                	jae    800bec <sprintputch+0x33>
		*b->buf++ = ch;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 48 01             	lea    0x1(%eax),%ecx
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	89 0a                	mov    %ecx,(%edx)
  800be7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bea:	88 10                	mov    %dl,(%eax)
}
  800bec:	90                   	nop
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	01 d0                	add    %edx,%eax
  800c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c14:	74 06                	je     800c1c <vsnprintf+0x2d>
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	7f 07                	jg     800c23 <vsnprintf+0x34>
		return -E_INVAL;
  800c1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c21:	eb 20                	jmp    800c43 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c23:	ff 75 14             	pushl  0x14(%ebp)
  800c26:	ff 75 10             	pushl  0x10(%ebp)
  800c29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c2c:	50                   	push   %eax
  800c2d:	68 b9 0b 80 00       	push   $0x800bb9
  800c32:	e8 92 fb ff ff       	call   8007c9 <vprintfmt>
  800c37:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c3d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c4b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4e:	83 c0 04             	add    $0x4,%eax
  800c51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	50                   	push   %eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	e8 89 ff ff ff       	call   800bef <vsnprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6f:	c9                   	leave  
  800c70:	c3                   	ret    

00800c71 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7e:	eb 06                	jmp    800c86 <strlen+0x15>
		n++;
  800c80:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c83:	ff 45 08             	incl   0x8(%ebp)
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	84 c0                	test   %al,%al
  800c8d:	75 f1                	jne    800c80 <strlen+0xf>
		n++;
	return n;
  800c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca1:	eb 09                	jmp    800cac <strnlen+0x18>
		n++;
  800ca3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca6:	ff 45 08             	incl   0x8(%ebp)
  800ca9:	ff 4d 0c             	decl   0xc(%ebp)
  800cac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb0:	74 09                	je     800cbb <strnlen+0x27>
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	75 e8                	jne    800ca3 <strnlen+0xf>
		n++;
	return n;
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ccc:	90                   	nop
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8d 50 01             	lea    0x1(%eax),%edx
  800cd3:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cdf:	8a 12                	mov    (%edx),%dl
  800ce1:	88 10                	mov    %dl,(%eax)
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	84 c0                	test   %al,%al
  800ce7:	75 e4                	jne    800ccd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d01:	eb 1f                	jmp    800d22 <strncpy+0x34>
		*dst++ = *src;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8d 50 01             	lea    0x1(%eax),%edx
  800d09:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	8a 12                	mov    (%edx),%dl
  800d11:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 03                	je     800d1f <strncpy+0x31>
			src++;
  800d1c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d1f:	ff 45 fc             	incl   -0x4(%ebp)
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d28:	72 d9                	jb     800d03 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3f:	74 30                	je     800d71 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d41:	eb 16                	jmp    800d59 <strlcpy+0x2a>
			*dst++ = *src++;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8d 50 01             	lea    0x1(%eax),%edx
  800d49:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d52:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d55:	8a 12                	mov    (%edx),%dl
  800d57:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d59:	ff 4d 10             	decl   0x10(%ebp)
  800d5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d60:	74 09                	je     800d6b <strlcpy+0x3c>
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	75 d8                	jne    800d43 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	29 c2                	sub    %eax,%edx
  800d79:	89 d0                	mov    %edx,%eax
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d80:	eb 06                	jmp    800d88 <strcmp+0xb>
		p++, q++;
  800d82:	ff 45 08             	incl   0x8(%ebp)
  800d85:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	84 c0                	test   %al,%al
  800d8f:	74 0e                	je     800d9f <strcmp+0x22>
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 10                	mov    (%eax),%dl
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	38 c2                	cmp    %al,%dl
  800d9d:	74 e3                	je     800d82 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	0f b6 d0             	movzbl %al,%edx
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	0f b6 c0             	movzbl %al,%eax
  800daf:	29 c2                	sub    %eax,%edx
  800db1:	89 d0                	mov    %edx,%eax
}
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db8:	eb 09                	jmp    800dc3 <strncmp+0xe>
		n--, p++, q++;
  800dba:	ff 4d 10             	decl   0x10(%ebp)
  800dbd:	ff 45 08             	incl   0x8(%ebp)
  800dc0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc7:	74 17                	je     800de0 <strncmp+0x2b>
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	74 0e                	je     800de0 <strncmp+0x2b>
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 10                	mov    (%eax),%dl
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	38 c2                	cmp    %al,%dl
  800dde:	74 da                	je     800dba <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de4:	75 07                	jne    800ded <strncmp+0x38>
		return 0;
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	eb 14                	jmp    800e01 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 d0             	movzbl %al,%edx
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	0f b6 c0             	movzbl %al,%eax
  800dfd:	29 c2                	sub    %eax,%edx
  800dff:	89 d0                	mov    %edx,%eax
}
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 04             	sub    $0x4,%esp
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e0f:	eb 12                	jmp    800e23 <strchr+0x20>
		if (*s == c)
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e19:	75 05                	jne    800e20 <strchr+0x1d>
			return (char *) s;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	eb 11                	jmp    800e31 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e20:	ff 45 08             	incl   0x8(%ebp)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 e5                	jne    800e11 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 04             	sub    $0x4,%esp
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3f:	eb 0d                	jmp    800e4e <strfind+0x1b>
		if (*s == c)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e49:	74 0e                	je     800e59 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	75 ea                	jne    800e41 <strfind+0xe>
  800e57:	eb 01                	jmp    800e5a <strfind+0x27>
		if (*s == c)
			break;
  800e59:	90                   	nop
	return (char *) s;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e71:	eb 0e                	jmp    800e81 <memset+0x22>
		*p++ = c;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	8d 50 01             	lea    0x1(%eax),%edx
  800e79:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e81:	ff 4d f8             	decl   -0x8(%ebp)
  800e84:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e88:	79 e9                	jns    800e73 <memset+0x14>
		*p++ = c;

	return v;
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ea1:	eb 16                	jmp    800eb9 <memcpy+0x2a>
		*d++ = *s++;
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	8d 50 01             	lea    0x1(%eax),%edx
  800ea9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eaf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb5:	8a 12                	mov    (%edx),%dl
  800eb7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	75 dd                	jne    800ea3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee3:	73 50                	jae    800f35 <memmove+0x6a>
  800ee5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef0:	76 43                	jbe    800f35 <memmove+0x6a>
		s += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efe:	eb 10                	jmp    800f10 <memmove+0x45>
			*--d = *--s;
  800f00:	ff 4d f8             	decl   -0x8(%ebp)
  800f03:	ff 4d fc             	decl   -0x4(%ebp)
  800f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f09:	8a 10                	mov    (%eax),%dl
  800f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f10:	8b 45 10             	mov    0x10(%ebp),%eax
  800f13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f16:	89 55 10             	mov    %edx,0x10(%ebp)
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	75 e3                	jne    800f00 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1d:	eb 23                	jmp    800f42 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8d 50 01             	lea    0x1(%eax),%edx
  800f25:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f31:	8a 12                	mov    (%edx),%dl
  800f33:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	75 dd                	jne    800f1f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f59:	eb 2a                	jmp    800f85 <memcmp+0x3e>
		if (*s1 != *s2)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	38 c2                	cmp    %al,%dl
  800f67:	74 16                	je     800f7f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	0f b6 d0             	movzbl %al,%edx
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	0f b6 c0             	movzbl %al,%eax
  800f79:	29 c2                	sub    %eax,%edx
  800f7b:	89 d0                	mov    %edx,%eax
  800f7d:	eb 18                	jmp    800f97 <memcmp+0x50>
		s1++, s2++;
  800f7f:	ff 45 fc             	incl   -0x4(%ebp)
  800f82:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 c9                	jne    800f5b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	01 d0                	add    %edx,%eax
  800fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800faa:	eb 15                	jmp    800fc1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	0f b6 c0             	movzbl %al,%eax
  800fba:	39 c2                	cmp    %eax,%edx
  800fbc:	74 0d                	je     800fcb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc7:	72 e3                	jb     800fac <memfind+0x13>
  800fc9:	eb 01                	jmp    800fcc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fcb:	90                   	nop
	return (void *) s;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fde:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe5:	eb 03                	jmp    800fea <strtol+0x19>
		s++;
  800fe7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 20                	cmp    $0x20,%al
  800ff1:	74 f4                	je     800fe7 <strtol+0x16>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 09                	cmp    $0x9,%al
  800ffa:	74 eb                	je     800fe7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 2b                	cmp    $0x2b,%al
  801003:	75 05                	jne    80100a <strtol+0x39>
		s++;
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	eb 13                	jmp    80101d <strtol+0x4c>
	else if (*s == '-')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 2d                	cmp    $0x2d,%al
  801011:	75 0a                	jne    80101d <strtol+0x4c>
		s++, neg = 1;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801021:	74 06                	je     801029 <strtol+0x58>
  801023:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801027:	75 20                	jne    801049 <strtol+0x78>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 17                	jne    801049 <strtol+0x78>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	40                   	inc    %eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	3c 78                	cmp    $0x78,%al
  80103a:	75 0d                	jne    801049 <strtol+0x78>
		s += 2, base = 16;
  80103c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801040:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801047:	eb 28                	jmp    801071 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801049:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104d:	75 15                	jne    801064 <strtol+0x93>
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 30                	cmp    $0x30,%al
  801056:	75 0c                	jne    801064 <strtol+0x93>
		s++, base = 8;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801062:	eb 0d                	jmp    801071 <strtol+0xa0>
	else if (base == 0)
  801064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801068:	75 07                	jne    801071 <strtol+0xa0>
		base = 10;
  80106a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 2f                	cmp    $0x2f,%al
  801078:	7e 19                	jle    801093 <strtol+0xc2>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 39                	cmp    $0x39,%al
  801081:	7f 10                	jg     801093 <strtol+0xc2>
			dig = *s - '0';
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f be c0             	movsbl %al,%eax
  80108b:	83 e8 30             	sub    $0x30,%eax
  80108e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801091:	eb 42                	jmp    8010d5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 60                	cmp    $0x60,%al
  80109a:	7e 19                	jle    8010b5 <strtol+0xe4>
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 7a                	cmp    $0x7a,%al
  8010a3:	7f 10                	jg     8010b5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	0f be c0             	movsbl %al,%eax
  8010ad:	83 e8 57             	sub    $0x57,%eax
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b3:	eb 20                	jmp    8010d5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 40                	cmp    $0x40,%al
  8010bc:	7e 39                	jle    8010f7 <strtol+0x126>
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3c 5a                	cmp    $0x5a,%al
  8010c5:	7f 30                	jg     8010f7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f be c0             	movsbl %al,%eax
  8010cf:	83 e8 37             	sub    $0x37,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010db:	7d 19                	jge    8010f6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010dd:	ff 45 08             	incl   0x8(%ebp)
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e7:	89 c2                	mov    %eax,%edx
  8010e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ec:	01 d0                	add    %edx,%eax
  8010ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f1:	e9 7b ff ff ff       	jmp    801071 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fb:	74 08                	je     801105 <strtol+0x134>
		*endptr = (char *) s;
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801105:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801109:	74 07                	je     801112 <strtol+0x141>
  80110b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110e:	f7 d8                	neg    %eax
  801110:	eb 03                	jmp    801115 <strtol+0x144>
  801112:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <ltostr>:

void
ltostr(long value, char *str)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801124:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80112b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80112f:	79 13                	jns    801144 <ltostr+0x2d>
	{
		neg = 1;
  801131:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80113e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801141:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80114c:	99                   	cltd   
  80114d:	f7 f9                	idiv   %ecx
  80114f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	8d 50 01             	lea    0x1(%eax),%edx
  801158:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801165:	83 c2 30             	add    $0x30,%edx
  801168:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80116a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801172:	f7 e9                	imul   %ecx
  801174:	c1 fa 02             	sar    $0x2,%edx
  801177:	89 c8                	mov    %ecx,%eax
  801179:	c1 f8 1f             	sar    $0x1f,%eax
  80117c:	29 c2                	sub    %eax,%edx
  80117e:	89 d0                	mov    %edx,%eax
  801180:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801186:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80118b:	f7 e9                	imul   %ecx
  80118d:	c1 fa 02             	sar    $0x2,%edx
  801190:	89 c8                	mov    %ecx,%eax
  801192:	c1 f8 1f             	sar    $0x1f,%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
  801199:	c1 e0 02             	shl    $0x2,%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	01 c0                	add    %eax,%eax
  8011a0:	29 c1                	sub    %eax,%ecx
  8011a2:	89 ca                	mov    %ecx,%edx
  8011a4:	85 d2                	test   %edx,%edx
  8011a6:	75 9c                	jne    801144 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	48                   	dec    %eax
  8011b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ba:	74 3d                	je     8011f9 <ltostr+0xe2>
		start = 1 ;
  8011bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011c3:	eb 34                	jmp    8011f9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	01 c2                	add    %eax,%edx
  8011da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e0:	01 c8                	add    %ecx,%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 c2                	add    %eax,%edx
  8011ee:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011f1:	88 02                	mov    %al,(%edx)
		start++ ;
  8011f3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ff:	7c c4                	jl     8011c5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801201:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80120c:	90                   	nop
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801215:	ff 75 08             	pushl  0x8(%ebp)
  801218:	e8 54 fa ff ff       	call   800c71 <strlen>
  80121d:	83 c4 04             	add    $0x4,%esp
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	e8 46 fa ff ff       	call   800c71 <strlen>
  80122b:	83 c4 04             	add    $0x4,%esp
  80122e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80123f:	eb 17                	jmp    801258 <strcconcat+0x49>
		final[s] = str1[s] ;
  801241:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801244:	8b 45 10             	mov    0x10(%ebp),%eax
  801247:	01 c2                	add    %eax,%edx
  801249:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	01 c8                	add    %ecx,%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801255:	ff 45 fc             	incl   -0x4(%ebp)
  801258:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80125e:	7c e1                	jl     801241 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801260:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801267:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80126e:	eb 1f                	jmp    80128f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801273:	8d 50 01             	lea    0x1(%eax),%edx
  801276:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801279:	89 c2                	mov    %eax,%edx
  80127b:	8b 45 10             	mov    0x10(%ebp),%eax
  80127e:	01 c2                	add    %eax,%edx
  801280:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c8                	add    %ecx,%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80128c:	ff 45 f8             	incl   -0x8(%ebp)
  80128f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801292:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801295:	7c d9                	jl     801270 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801297:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 d0                	add    %edx,%eax
  80129f:	c6 00 00             	movb   $0x0,(%eax)
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b4:	8b 00                	mov    (%eax),%eax
  8012b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c8:	eb 0c                	jmp    8012d6 <strsplit+0x31>
			*string++ = 0;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8d 50 01             	lea    0x1(%eax),%edx
  8012d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	84 c0                	test   %al,%al
  8012dd:	74 18                	je     8012f7 <strsplit+0x52>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	0f be c0             	movsbl %al,%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	e8 13 fb ff ff       	call   800e03 <strchr>
  8012f0:	83 c4 08             	add    $0x8,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	75 d3                	jne    8012ca <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	84 c0                	test   %al,%al
  8012fe:	74 5a                	je     80135a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801300:	8b 45 14             	mov    0x14(%ebp),%eax
  801303:	8b 00                	mov    (%eax),%eax
  801305:	83 f8 0f             	cmp    $0xf,%eax
  801308:	75 07                	jne    801311 <strsplit+0x6c>
		{
			return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
  80130f:	eb 66                	jmp    801377 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	8b 00                	mov    (%eax),%eax
  801316:	8d 48 01             	lea    0x1(%eax),%ecx
  801319:	8b 55 14             	mov    0x14(%ebp),%edx
  80131c:	89 0a                	mov    %ecx,(%edx)
  80131e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 c2                	add    %eax,%edx
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132f:	eb 03                	jmp    801334 <strsplit+0x8f>
			string++;
  801331:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	84 c0                	test   %al,%al
  80133b:	74 8b                	je     8012c8 <strsplit+0x23>
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	0f be c0             	movsbl %al,%eax
  801345:	50                   	push   %eax
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	e8 b5 fa ff ff       	call   800e03 <strchr>
  80134e:	83 c4 08             	add    $0x8,%esp
  801351:	85 c0                	test   %eax,%eax
  801353:	74 dc                	je     801331 <strsplit+0x8c>
			string++;
	}
  801355:	e9 6e ff ff ff       	jmp    8012c8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80135a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80135b:	8b 45 14             	mov    0x14(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801372:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 f0 24 80 00       	push   $0x8024f0
  801387:	6a 0e                	push   $0xe
  801389:	68 2a 25 80 00       	push   $0x80252a
  80138e:	e8 a8 ef ff ff       	call   80033b <_panic>

00801393 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801399:	a1 04 30 80 00       	mov    0x803004,%eax
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	74 0f                	je     8013b1 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8013a2:	e8 d2 ff ff ff       	call   801379 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013a7:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8013ae:	00 00 00 
	}
	if (size == 0) return NULL ;
  8013b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b5:	75 07                	jne    8013be <malloc+0x2b>
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	68 38 25 80 00       	push   $0x802538
  8013c6:	6a 2e                	push   $0x2e
  8013c8:	68 2a 25 80 00       	push   $0x80252a
  8013cd:	e8 69 ef ff ff       	call   80033b <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	68 60 25 80 00       	push   $0x802560
  8013e2:	6a 49                	push   $0x49
  8013e4:	68 2a 25 80 00       	push   $0x80252a
  8013e9:	e8 4d ef ff ff       	call   80033b <_panic>

008013ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 18             	sub    $0x18,%esp
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 84 25 80 00       	push   $0x802584
  801402:	6a 57                	push   $0x57
  801404:	68 2a 25 80 00       	push   $0x80252a
  801409:	e8 2d ef ff ff       	call   80033b <_panic>

0080140e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	68 ac 25 80 00       	push   $0x8025ac
  80141c:	6a 60                	push   $0x60
  80141e:	68 2a 25 80 00       	push   $0x80252a
  801423:	e8 13 ef ff ff       	call   80033b <_panic>

00801428 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 d0 25 80 00       	push   $0x8025d0
  801436:	6a 7c                	push   $0x7c
  801438:	68 2a 25 80 00       	push   $0x80252a
  80143d:	e8 f9 ee ff ff       	call   80033b <_panic>

00801442 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	68 f8 25 80 00       	push   $0x8025f8
  801450:	68 86 00 00 00       	push   $0x86
  801455:	68 2a 25 80 00       	push   $0x80252a
  80145a:	e8 dc ee ff ff       	call   80033b <_panic>

0080145f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	68 1c 26 80 00       	push   $0x80261c
  80146d:	68 91 00 00 00       	push   $0x91
  801472:	68 2a 25 80 00       	push   $0x80252a
  801477:	e8 bf ee ff ff       	call   80033b <_panic>

0080147c <shrink>:

}
void shrink(uint32 newSize)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	68 1c 26 80 00       	push   $0x80261c
  80148a:	68 96 00 00 00       	push   $0x96
  80148f:	68 2a 25 80 00       	push   $0x80252a
  801494:	e8 a2 ee ff ff       	call   80033b <_panic>

00801499 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	68 1c 26 80 00       	push   $0x80261c
  8014a7:	68 9b 00 00 00       	push   $0x9b
  8014ac:	68 2a 25 80 00       	push   $0x80252a
  8014b1:	e8 85 ee ff ff       	call   80033b <_panic>

008014b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	57                   	push   %edi
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014d1:	cd 30                	int    $0x30
  8014d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5f                   	pop    %edi
  8014df:	5d                   	pop    %ebp
  8014e0:	c3                   	ret    

008014e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	52                   	push   %edx
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	50                   	push   %eax
  8014fd:	6a 00                	push   $0x0
  8014ff:	e8 b2 ff ff ff       	call   8014b6 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_cgetc>:

int
sys_cgetc(void)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 01                	push   $0x1
  801519:	e8 98 ff ff ff       	call   8014b6 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	6a 05                	push   $0x5
  801536:	e8 7b ff ff ff       	call   8014b6 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	56                   	push   %esi
  801544:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801545:	8b 75 18             	mov    0x18(%ebp),%esi
  801548:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	56                   	push   %esi
  801555:	53                   	push   %ebx
  801556:	51                   	push   %ecx
  801557:	52                   	push   %edx
  801558:	50                   	push   %eax
  801559:	6a 06                	push   $0x6
  80155b:	e8 56 ff ff ff       	call   8014b6 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801566:	5b                   	pop    %ebx
  801567:	5e                   	pop    %esi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	52                   	push   %edx
  80157a:	50                   	push   %eax
  80157b:	6a 07                	push   $0x7
  80157d:	e8 34 ff ff ff       	call   8014b6 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	6a 08                	push   $0x8
  801598:	e8 19 ff ff ff       	call   8014b6 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 09                	push   $0x9
  8015b1:	e8 00 ff ff ff       	call   8014b6 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 0a                	push   $0xa
  8015ca:	e8 e7 fe ff ff       	call   8014b6 <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 0b                	push   $0xb
  8015e3:	e8 ce fe ff ff       	call   8014b6 <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	ff 75 08             	pushl  0x8(%ebp)
  8015fc:	6a 0f                	push   $0xf
  8015fe:	e8 b3 fe ff ff       	call   8014b6 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return;
  801606:	90                   	nop
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	ff 75 08             	pushl  0x8(%ebp)
  801618:	6a 10                	push   $0x10
  80161a:	e8 97 fe ff ff       	call   8014b6 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
	return ;
  801622:	90                   	nop
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	ff 75 10             	pushl  0x10(%ebp)
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	ff 75 08             	pushl  0x8(%ebp)
  801635:	6a 11                	push   $0x11
  801637:	e8 7a fe ff ff       	call   8014b6 <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
	return ;
  80163f:	90                   	nop
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 0c                	push   $0xc
  801651:	e8 60 fe ff ff       	call   8014b6 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	6a 0d                	push   $0xd
  80166b:	e8 46 fe ff ff       	call   8014b6 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 0e                	push   $0xe
  801684:	e8 2d fe ff ff       	call   8014b6 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	90                   	nop
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 13                	push   $0x13
  80169e:	e8 13 fe ff ff       	call   8014b6 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 14                	push   $0x14
  8016b8:	e8 f9 fd ff ff       	call   8014b6 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	50                   	push   %eax
  8016dc:	6a 15                	push   $0x15
  8016de:	e8 d3 fd ff ff       	call   8014b6 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	90                   	nop
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 16                	push   $0x16
  8016f8:	e8 b9 fd ff ff       	call   8014b6 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	6a 17                	push   $0x17
  801715:	e8 9c fd ff ff       	call   8014b6 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801722:	8b 55 0c             	mov    0xc(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 1a                	push   $0x1a
  801732:	e8 7f fd ff ff       	call   8014b6 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	52                   	push   %edx
  80174c:	50                   	push   %eax
  80174d:	6a 18                	push   $0x18
  80174f:	e8 62 fd ff ff       	call   8014b6 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	90                   	nop
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 19                	push   $0x19
  80176d:	e8 44 fd ff ff       	call   8014b6 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	90                   	nop
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	8b 45 10             	mov    0x10(%ebp),%eax
  801781:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801784:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801787:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	6a 00                	push   $0x0
  801790:	51                   	push   %ecx
  801791:	52                   	push   %edx
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	50                   	push   %eax
  801796:	6a 1b                	push   $0x1b
  801798:	e8 19 fd ff ff       	call   8014b6 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	6a 1c                	push   $0x1c
  8017b5:	e8 fc fc ff ff       	call   8014b6 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	51                   	push   %ecx
  8017d0:	52                   	push   %edx
  8017d1:	50                   	push   %eax
  8017d2:	6a 1d                	push   $0x1d
  8017d4:	e8 dd fc ff ff       	call   8014b6 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	52                   	push   %edx
  8017ee:	50                   	push   %eax
  8017ef:	6a 1e                	push   $0x1e
  8017f1:	e8 c0 fc ff ff       	call   8014b6 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 1f                	push   $0x1f
  80180a:	e8 a7 fc ff ff       	call   8014b6 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 14             	pushl  0x14(%ebp)
  80181f:	ff 75 10             	pushl  0x10(%ebp)
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	50                   	push   %eax
  801826:	6a 20                	push   $0x20
  801828:	e8 89 fc ff ff       	call   8014b6 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	50                   	push   %eax
  801841:	6a 21                	push   $0x21
  801843:	e8 6e fc ff ff       	call   8014b6 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	50                   	push   %eax
  80185d:	6a 22                	push   $0x22
  80185f:	e8 52 fc ff ff       	call   8014b6 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 02                	push   $0x2
  801878:	e8 39 fc ff ff       	call   8014b6 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 03                	push   $0x3
  801891:	e8 20 fc ff ff       	call   8014b6 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 04                	push   $0x4
  8018aa:	e8 07 fc ff ff       	call   8014b6 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 23                	push   $0x23
  8018c3:	e8 ee fb ff ff       	call   8014b6 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d7:	8d 50 04             	lea    0x4(%eax),%edx
  8018da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	6a 24                	push   $0x24
  8018e7:	e8 ca fb ff ff       	call   8014b6 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f8:	89 01                	mov    %eax,(%ecx)
  8018fa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	c9                   	leave  
  801901:	c2 04 00             	ret    $0x4

00801904 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 10             	pushl  0x10(%ebp)
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 12                	push   $0x12
  801916:	e8 9b fb ff ff       	call   8014b6 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
	return ;
  80191e:	90                   	nop
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_rcr2>:
uint32 sys_rcr2()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 25                	push   $0x25
  801930:	e8 81 fb ff ff       	call   8014b6 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801946:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	50                   	push   %eax
  801953:	6a 26                	push   $0x26
  801955:	e8 5c fb ff ff       	call   8014b6 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <rsttst>:
void rsttst()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 28                	push   $0x28
  80196f:	e8 42 fb ff ff       	call   8014b6 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	8b 45 14             	mov    0x14(%ebp),%eax
  801983:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801986:	8b 55 18             	mov    0x18(%ebp),%edx
  801989:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 27                	push   $0x27
  80199a:	e8 17 fb ff ff       	call   8014b6 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a2:	90                   	nop
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <chktst>:
void chktst(uint32 n)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 29                	push   $0x29
  8019b5:	e8 fc fa ff ff       	call   8014b6 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <inctst>:

void inctst()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 2a                	push   $0x2a
  8019cf:	e8 e2 fa ff ff       	call   8014b6 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <gettst>:
uint32 gettst()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 2b                	push   $0x2b
  8019e9:	e8 c8 fa ff ff       	call   8014b6 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 2c                	push   $0x2c
  801a05:	e8 ac fa ff ff       	call   8014b6 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
  801a0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a10:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a14:	75 07                	jne    801a1d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a16:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1b:	eb 05                	jmp    801a22 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 2c                	push   $0x2c
  801a36:	e8 7b fa ff ff       	call   8014b6 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
  801a3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a41:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a45:	75 07                	jne    801a4e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a47:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4c:	eb 05                	jmp    801a53 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 2c                	push   $0x2c
  801a67:	e8 4a fa ff ff       	call   8014b6 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
  801a6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a72:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a76:	75 07                	jne    801a7f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a78:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7d:	eb 05                	jmp    801a84 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 2c                	push   $0x2c
  801a98:	e8 19 fa ff ff       	call   8014b6 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
  801aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa7:	75 07                	jne    801ab0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aae:	eb 05                	jmp    801ab5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	ff 75 08             	pushl  0x8(%ebp)
  801ac5:	6a 2d                	push   $0x2d
  801ac7:	e8 ea f9 ff ff       	call   8014b6 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return ;
  801acf:	90                   	nop
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	53                   	push   %ebx
  801ae5:	51                   	push   %ecx
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 2e                	push   $0x2e
  801aea:	e8 c7 f9 ff ff       	call   8014b6 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 2f                	push   $0x2f
  801b0a:	e8 a7 f9 ff ff       	call   8014b6 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <__udivdi3>:
  801b14:	55                   	push   %ebp
  801b15:	57                   	push   %edi
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	83 ec 1c             	sub    $0x1c,%esp
  801b1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2b:	89 ca                	mov    %ecx,%edx
  801b2d:	89 f8                	mov    %edi,%eax
  801b2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b33:	85 f6                	test   %esi,%esi
  801b35:	75 2d                	jne    801b64 <__udivdi3+0x50>
  801b37:	39 cf                	cmp    %ecx,%edi
  801b39:	77 65                	ja     801ba0 <__udivdi3+0x8c>
  801b3b:	89 fd                	mov    %edi,%ebp
  801b3d:	85 ff                	test   %edi,%edi
  801b3f:	75 0b                	jne    801b4c <__udivdi3+0x38>
  801b41:	b8 01 00 00 00       	mov    $0x1,%eax
  801b46:	31 d2                	xor    %edx,%edx
  801b48:	f7 f7                	div    %edi
  801b4a:	89 c5                	mov    %eax,%ebp
  801b4c:	31 d2                	xor    %edx,%edx
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	f7 f5                	div    %ebp
  801b52:	89 c1                	mov    %eax,%ecx
  801b54:	89 d8                	mov    %ebx,%eax
  801b56:	f7 f5                	div    %ebp
  801b58:	89 cf                	mov    %ecx,%edi
  801b5a:	89 fa                	mov    %edi,%edx
  801b5c:	83 c4 1c             	add    $0x1c,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
  801b64:	39 ce                	cmp    %ecx,%esi
  801b66:	77 28                	ja     801b90 <__udivdi3+0x7c>
  801b68:	0f bd fe             	bsr    %esi,%edi
  801b6b:	83 f7 1f             	xor    $0x1f,%edi
  801b6e:	75 40                	jne    801bb0 <__udivdi3+0x9c>
  801b70:	39 ce                	cmp    %ecx,%esi
  801b72:	72 0a                	jb     801b7e <__udivdi3+0x6a>
  801b74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b78:	0f 87 9e 00 00 00    	ja     801c1c <__udivdi3+0x108>
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	89 fa                	mov    %edi,%edx
  801b85:	83 c4 1c             	add    $0x1c,%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5e                   	pop    %esi
  801b8a:	5f                   	pop    %edi
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    
  801b8d:	8d 76 00             	lea    0x0(%esi),%esi
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	31 c0                	xor    %eax,%eax
  801b94:	89 fa                	mov    %edi,%edx
  801b96:	83 c4 1c             	add    $0x1c,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f7                	div    %edi
  801ba4:	31 ff                	xor    %edi,%edi
  801ba6:	89 fa                	mov    %edi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bb5:	89 eb                	mov    %ebp,%ebx
  801bb7:	29 fb                	sub    %edi,%ebx
  801bb9:	89 f9                	mov    %edi,%ecx
  801bbb:	d3 e6                	shl    %cl,%esi
  801bbd:	89 c5                	mov    %eax,%ebp
  801bbf:	88 d9                	mov    %bl,%cl
  801bc1:	d3 ed                	shr    %cl,%ebp
  801bc3:	89 e9                	mov    %ebp,%ecx
  801bc5:	09 f1                	or     %esi,%ecx
  801bc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bcb:	89 f9                	mov    %edi,%ecx
  801bcd:	d3 e0                	shl    %cl,%eax
  801bcf:	89 c5                	mov    %eax,%ebp
  801bd1:	89 d6                	mov    %edx,%esi
  801bd3:	88 d9                	mov    %bl,%cl
  801bd5:	d3 ee                	shr    %cl,%esi
  801bd7:	89 f9                	mov    %edi,%ecx
  801bd9:	d3 e2                	shl    %cl,%edx
  801bdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bdf:	88 d9                	mov    %bl,%cl
  801be1:	d3 e8                	shr    %cl,%eax
  801be3:	09 c2                	or     %eax,%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	89 f2                	mov    %esi,%edx
  801be9:	f7 74 24 0c          	divl   0xc(%esp)
  801bed:	89 d6                	mov    %edx,%esi
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	f7 e5                	mul    %ebp
  801bf3:	39 d6                	cmp    %edx,%esi
  801bf5:	72 19                	jb     801c10 <__udivdi3+0xfc>
  801bf7:	74 0b                	je     801c04 <__udivdi3+0xf0>
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	31 ff                	xor    %edi,%edi
  801bfd:	e9 58 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c08:	89 f9                	mov    %edi,%ecx
  801c0a:	d3 e2                	shl    %cl,%edx
  801c0c:	39 c2                	cmp    %eax,%edx
  801c0e:	73 e9                	jae    801bf9 <__udivdi3+0xe5>
  801c10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c13:	31 ff                	xor    %edi,%edi
  801c15:	e9 40 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	31 c0                	xor    %eax,%eax
  801c1e:	e9 37 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c23:	90                   	nop

00801c24 <__umoddi3>:
  801c24:	55                   	push   %ebp
  801c25:	57                   	push   %edi
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	83 ec 1c             	sub    $0x1c,%esp
  801c2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c43:	89 f3                	mov    %esi,%ebx
  801c45:	89 fa                	mov    %edi,%edx
  801c47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4b:	89 34 24             	mov    %esi,(%esp)
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	75 1a                	jne    801c6c <__umoddi3+0x48>
  801c52:	39 f7                	cmp    %esi,%edi
  801c54:	0f 86 a2 00 00 00    	jbe    801cfc <__umoddi3+0xd8>
  801c5a:	89 c8                	mov    %ecx,%eax
  801c5c:	89 f2                	mov    %esi,%edx
  801c5e:	f7 f7                	div    %edi
  801c60:	89 d0                	mov    %edx,%eax
  801c62:	31 d2                	xor    %edx,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	39 f0                	cmp    %esi,%eax
  801c6e:	0f 87 ac 00 00 00    	ja     801d20 <__umoddi3+0xfc>
  801c74:	0f bd e8             	bsr    %eax,%ebp
  801c77:	83 f5 1f             	xor    $0x1f,%ebp
  801c7a:	0f 84 ac 00 00 00    	je     801d2c <__umoddi3+0x108>
  801c80:	bf 20 00 00 00       	mov    $0x20,%edi
  801c85:	29 ef                	sub    %ebp,%edi
  801c87:	89 fe                	mov    %edi,%esi
  801c89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c8d:	89 e9                	mov    %ebp,%ecx
  801c8f:	d3 e0                	shl    %cl,%eax
  801c91:	89 d7                	mov    %edx,%edi
  801c93:	89 f1                	mov    %esi,%ecx
  801c95:	d3 ef                	shr    %cl,%edi
  801c97:	09 c7                	or     %eax,%edi
  801c99:	89 e9                	mov    %ebp,%ecx
  801c9b:	d3 e2                	shl    %cl,%edx
  801c9d:	89 14 24             	mov    %edx,(%esp)
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	d3 e0                	shl    %cl,%eax
  801ca4:	89 c2                	mov    %eax,%edx
  801ca6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801caa:	d3 e0                	shl    %cl,%eax
  801cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb4:	89 f1                	mov    %esi,%ecx
  801cb6:	d3 e8                	shr    %cl,%eax
  801cb8:	09 d0                	or     %edx,%eax
  801cba:	d3 eb                	shr    %cl,%ebx
  801cbc:	89 da                	mov    %ebx,%edx
  801cbe:	f7 f7                	div    %edi
  801cc0:	89 d3                	mov    %edx,%ebx
  801cc2:	f7 24 24             	mull   (%esp)
  801cc5:	89 c6                	mov    %eax,%esi
  801cc7:	89 d1                	mov    %edx,%ecx
  801cc9:	39 d3                	cmp    %edx,%ebx
  801ccb:	0f 82 87 00 00 00    	jb     801d58 <__umoddi3+0x134>
  801cd1:	0f 84 91 00 00 00    	je     801d68 <__umoddi3+0x144>
  801cd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cdb:	29 f2                	sub    %esi,%edx
  801cdd:	19 cb                	sbb    %ecx,%ebx
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ce5:	d3 e0                	shl    %cl,%eax
  801ce7:	89 e9                	mov    %ebp,%ecx
  801ce9:	d3 ea                	shr    %cl,%edx
  801ceb:	09 d0                	or     %edx,%eax
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	d3 eb                	shr    %cl,%ebx
  801cf1:	89 da                	mov    %ebx,%edx
  801cf3:	83 c4 1c             	add    $0x1c,%esp
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5f                   	pop    %edi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
  801cfb:	90                   	nop
  801cfc:	89 fd                	mov    %edi,%ebp
  801cfe:	85 ff                	test   %edi,%edi
  801d00:	75 0b                	jne    801d0d <__umoddi3+0xe9>
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	31 d2                	xor    %edx,%edx
  801d09:	f7 f7                	div    %edi
  801d0b:	89 c5                	mov    %eax,%ebp
  801d0d:	89 f0                	mov    %esi,%eax
  801d0f:	31 d2                	xor    %edx,%edx
  801d11:	f7 f5                	div    %ebp
  801d13:	89 c8                	mov    %ecx,%eax
  801d15:	f7 f5                	div    %ebp
  801d17:	89 d0                	mov    %edx,%eax
  801d19:	e9 44 ff ff ff       	jmp    801c62 <__umoddi3+0x3e>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	89 c8                	mov    %ecx,%eax
  801d22:	89 f2                	mov    %esi,%edx
  801d24:	83 c4 1c             	add    $0x1c,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
  801d2c:	3b 04 24             	cmp    (%esp),%eax
  801d2f:	72 06                	jb     801d37 <__umoddi3+0x113>
  801d31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d35:	77 0f                	ja     801d46 <__umoddi3+0x122>
  801d37:	89 f2                	mov    %esi,%edx
  801d39:	29 f9                	sub    %edi,%ecx
  801d3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d3f:	89 14 24             	mov    %edx,(%esp)
  801d42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d4a:	8b 14 24             	mov    (%esp),%edx
  801d4d:	83 c4 1c             	add    $0x1c,%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    
  801d55:	8d 76 00             	lea    0x0(%esi),%esi
  801d58:	2b 04 24             	sub    (%esp),%eax
  801d5b:	19 fa                	sbb    %edi,%edx
  801d5d:	89 d1                	mov    %edx,%ecx
  801d5f:	89 c6                	mov    %eax,%esi
  801d61:	e9 71 ff ff ff       	jmp    801cd7 <__umoddi3+0xb3>
  801d66:	66 90                	xchg   %ax,%ax
  801d68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d6c:	72 ea                	jb     801d58 <__umoddi3+0x134>
  801d6e:	89 d9                	mov    %ebx,%ecx
  801d70:	e9 62 ff ff ff       	jmp    801cd7 <__umoddi3+0xb3>
