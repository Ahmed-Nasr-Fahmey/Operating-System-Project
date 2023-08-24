
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
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
  80008d:	68 e0 1d 80 00       	push   $0x801de0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 1d 80 00       	push   $0x801dfc
  800099:	e8 05 03 00 00       	call   8003a3 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 60 18 00 00       	call   801903 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 4c 16 00 00       	call   8016f7 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 5a 15 00 00       	call   80160a <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 17 1e 80 00       	push   $0x801e17
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 b3 13 00 00       	call   801476 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 1c 1e 80 00       	push   $0x801e1c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 fc 1d 80 00       	push   $0x801dfc
  8000e1:	e8 bd 02 00 00       	call   8003a3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 1c 15 00 00       	call   80160a <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 7c 1e 80 00       	push   $0x801e7c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 fc 1d 80 00       	push   $0x801dfc
  800106:	e8 98 02 00 00       	call   8003a3 <_panic>
	sys_enable_interrupt();
  80010b:	e8 01 16 00 00       	call   801711 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 e2 15 00 00       	call   8016f7 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 f0 14 00 00       	call   80160a <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 0d 1f 80 00       	push   $0x801f0d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 49 13 00 00       	call   801476 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 1c 1e 80 00       	push   $0x801e1c
  800144:	6a 23                	push   $0x23
  800146:	68 fc 1d 80 00       	push   $0x801dfc
  80014b:	e8 53 02 00 00       	call   8003a3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 b5 14 00 00       	call   80160a <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 7c 1e 80 00       	push   $0x801e7c
  800166:	6a 24                	push   $0x24
  800168:	68 fc 1d 80 00       	push   $0x801dfc
  80016d:	e8 31 02 00 00       	call   8003a3 <_panic>
	sys_enable_interrupt();
  800172:	e8 9a 15 00 00       	call   801711 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 10 1f 80 00       	push   $0x801f10
  800189:	6a 27                	push   $0x27
  80018b:	68 fc 1d 80 00       	push   $0x801dfc
  800190:	e8 0e 02 00 00       	call   8003a3 <_panic>

	sys_disable_interrupt();
  800195:	e8 5d 15 00 00       	call   8016f7 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 6b 14 00 00       	call   80160a <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 47 1f 80 00       	push   $0x801f47
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 c4 12 00 00       	call   801476 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 1c 1e 80 00       	push   $0x801e1c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 fc 1d 80 00       	push   $0x801dfc
  8001d0:	e8 ce 01 00 00       	call   8003a3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 30 14 00 00       	call   80160a <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 7c 1e 80 00       	push   $0x801e7c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 fc 1d 80 00       	push   $0x801dfc
  8001f2:	e8 ac 01 00 00       	call   8003a3 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 15 15 00 00       	call   801711 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 10 1f 80 00       	push   $0x801f10
  80020e:	6a 30                	push   $0x30
  800210:	68 fc 1d 80 00       	push   $0x801dfc
  800215:	e8 89 01 00 00       	call   8003a3 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 10 1f 80 00       	push   $0x801f10
  80023d:	6a 33                	push   $0x33
  80023f:	68 fc 1d 80 00       	push   $0x801dfc
  800244:	e8 5a 01 00 00       	call   8003a3 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 da 17 00 00       	call   801a28 <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 8b 16 00 00       	call   8018ea <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	01 c0                	add    %eax,%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800272:	01 c8                	add    %ecx,%eax
  800274:	c1 e0 02             	shl    $0x2,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800280:	01 c8                	add    %ecx,%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c1 e0 02             	shl    $0x2,%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	c1 e0 03             	shl    $0x3,%eax
  80028f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800294:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800299:	a1 20 30 80 00       	mov    0x803020,%eax
  80029e:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8002a4:	84 c0                	test   %al,%al
  8002a6:	74 0f                	je     8002b7 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8002a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ad:	05 18 da 01 00       	add    $0x1da18,%eax
  8002b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002bb:	7e 0a                	jle    8002c7 <libmain+0x73>
		binaryname = argv[0];
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	ff 75 0c             	pushl  0xc(%ebp)
  8002cd:	ff 75 08             	pushl  0x8(%ebp)
  8002d0:	e8 63 fd ff ff       	call   800038 <_main>
  8002d5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d8:	e8 1a 14 00 00       	call   8016f7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	68 64 1f 80 00       	push   $0x801f64
  8002e5:	e8 6d 03 00 00       	call   800657 <cprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f2:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8002f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fd:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800303:	83 ec 04             	sub    $0x4,%esp
  800306:	52                   	push   %edx
  800307:	50                   	push   %eax
  800308:	68 8c 1f 80 00       	push   $0x801f8c
  80030d:	e8 45 03 00 00       	call   800657 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800315:	a1 20 30 80 00       	mov    0x803020,%eax
  80031a:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80032b:	a1 20 30 80 00       	mov    0x803020,%eax
  800330:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800336:	51                   	push   %ecx
  800337:	52                   	push   %edx
  800338:	50                   	push   %eax
  800339:	68 b4 1f 80 00       	push   $0x801fb4
  80033e:	e8 14 03 00 00       	call   800657 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	50                   	push   %eax
  800355:	68 0c 20 80 00       	push   $0x80200c
  80035a:	e8 f8 02 00 00       	call   800657 <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	68 64 1f 80 00       	push   $0x801f64
  80036a:	e8 e8 02 00 00       	call   800657 <cprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800372:	e8 9a 13 00 00       	call   801711 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800377:	e8 19 00 00 00       	call   800395 <exit>
}
  80037c:	90                   	nop
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	6a 00                	push   $0x0
  80038a:	e8 27 15 00 00       	call   8018b6 <sys_destroy_env>
  80038f:	83 c4 10             	add    $0x10,%esp
}
  800392:	90                   	nop
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <exit>:

void
exit(void)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80039b:	e8 7c 15 00 00       	call   80191c <sys_exit_env>
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8003ac:	83 c0 04             	add    $0x4,%eax
  8003af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003b2:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8003b7:	85 c0                	test   %eax,%eax
  8003b9:	74 16                	je     8003d1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003bb:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	50                   	push   %eax
  8003c4:	68 20 20 80 00       	push   $0x802020
  8003c9:	e8 89 02 00 00       	call   800657 <cprintf>
  8003ce:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003d1:	a1 00 30 80 00       	mov    0x803000,%eax
  8003d6:	ff 75 0c             	pushl  0xc(%ebp)
  8003d9:	ff 75 08             	pushl  0x8(%ebp)
  8003dc:	50                   	push   %eax
  8003dd:	68 25 20 80 00       	push   $0x802025
  8003e2:	e8 70 02 00 00       	call   800657 <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	e8 f3 01 00 00       	call   8005ec <vcprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	6a 00                	push   $0x0
  800401:	68 41 20 80 00       	push   $0x802041
  800406:	e8 e1 01 00 00       	call   8005ec <vcprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80040e:	e8 82 ff ff ff       	call   800395 <exit>

	// should not return here
	while (1) ;
  800413:	eb fe                	jmp    800413 <_panic+0x70>

00800415 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80041b:	a1 20 30 80 00       	mov    0x803020,%eax
  800420:	8b 50 74             	mov    0x74(%eax),%edx
  800423:	8b 45 0c             	mov    0xc(%ebp),%eax
  800426:	39 c2                	cmp    %eax,%edx
  800428:	74 14                	je     80043e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 44 20 80 00       	push   $0x802044
  800432:	6a 26                	push   $0x26
  800434:	68 90 20 80 00       	push   $0x802090
  800439:	e8 65 ff ff ff       	call   8003a3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80043e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800445:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80044c:	e9 c2 00 00 00       	jmp    800513 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800454:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	01 d0                	add    %edx,%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	75 08                	jne    80046e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800466:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800469:	e9 a2 00 00 00       	jmp    800510 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80046e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800475:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80047c:	eb 69                	jmp    8004e7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80047e:	a1 20 30 80 00       	mov    0x803020,%eax
  800483:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800489:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80048c:	89 d0                	mov    %edx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	c1 e0 03             	shl    $0x3,%eax
  800495:	01 c8                	add    %ecx,%eax
  800497:	8a 40 04             	mov    0x4(%eax),%al
  80049a:	84 c0                	test   %al,%al
  80049c:	75 46                	jne    8004e4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a3:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004ac:	89 d0                	mov    %edx,%eax
  8004ae:	01 c0                	add    %eax,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	c1 e0 03             	shl    $0x3,%eax
  8004b5:	01 c8                	add    %ecx,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	01 c8                	add    %ecx,%eax
  8004d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d7:	39 c2                	cmp    %eax,%edx
  8004d9:	75 09                	jne    8004e4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004e2:	eb 12                	jmp    8004f6 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e8             	incl   -0x18(%ebp)
  8004e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 88                	ja     80047e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004fa:	75 14                	jne    800510 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 9c 20 80 00       	push   $0x80209c
  800504:	6a 3a                	push   $0x3a
  800506:	68 90 20 80 00       	push   $0x802090
  80050b:	e8 93 fe ff ff       	call   8003a3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800510:	ff 45 f0             	incl   -0x10(%ebp)
  800513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	0f 8c 32 ff ff ff    	jl     800451 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80051f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800526:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80052d:	eb 26                	jmp    800555 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80052f:	a1 20 30 80 00       	mov    0x803020,%eax
  800534:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80053a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053d:	89 d0                	mov    %edx,%eax
  80053f:	01 c0                	add    %eax,%eax
  800541:	01 d0                	add    %edx,%eax
  800543:	c1 e0 03             	shl    $0x3,%eax
  800546:	01 c8                	add    %ecx,%eax
  800548:	8a 40 04             	mov    0x4(%eax),%al
  80054b:	3c 01                	cmp    $0x1,%al
  80054d:	75 03                	jne    800552 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80054f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800552:	ff 45 e0             	incl   -0x20(%ebp)
  800555:	a1 20 30 80 00       	mov    0x803020,%eax
  80055a:	8b 50 74             	mov    0x74(%eax),%edx
  80055d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800560:	39 c2                	cmp    %eax,%edx
  800562:	77 cb                	ja     80052f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800567:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80056a:	74 14                	je     800580 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 f0 20 80 00       	push   $0x8020f0
  800574:	6a 44                	push   $0x44
  800576:	68 90 20 80 00       	push   $0x802090
  80057b:	e8 23 fe ff ff       	call   8003a3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800580:	90                   	nop
  800581:	c9                   	leave  
  800582:	c3                   	ret    

00800583 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800583:	55                   	push   %ebp
  800584:	89 e5                	mov    %esp,%ebp
  800586:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	8d 48 01             	lea    0x1(%eax),%ecx
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	89 0a                	mov    %ecx,(%edx)
  800596:	8b 55 08             	mov    0x8(%ebp),%edx
  800599:	88 d1                	mov    %dl,%cl
  80059b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ac:	75 2c                	jne    8005da <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ae:	a0 24 30 80 00       	mov    0x803024,%al
  8005b3:	0f b6 c0             	movzbl %al,%eax
  8005b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b9:	8b 12                	mov    (%edx),%edx
  8005bb:	89 d1                	mov    %edx,%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	83 c2 08             	add    $0x8,%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	51                   	push   %ecx
  8005c8:	52                   	push   %edx
  8005c9:	e8 7b 0f 00 00       	call   801549 <sys_cputs>
  8005ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 40 04             	mov    0x4(%eax),%eax
  8005e0:	8d 50 01             	lea    0x1(%eax),%edx
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005fc:	00 00 00 
	b.cnt = 0;
  8005ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800606:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	ff 75 08             	pushl  0x8(%ebp)
  80060f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	68 83 05 80 00       	push   $0x800583
  80061b:	e8 11 02 00 00       	call   800831 <vprintfmt>
  800620:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800623:	a0 24 30 80 00       	mov    0x803024,%al
  800628:	0f b6 c0             	movzbl %al,%eax
  80062b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	50                   	push   %eax
  800635:	52                   	push   %edx
  800636:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063c:	83 c0 08             	add    $0x8,%eax
  80063f:	50                   	push   %eax
  800640:	e8 04 0f 00 00       	call   801549 <sys_cputs>
  800645:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800648:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80064f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <cprintf>:

int cprintf(const char *fmt, ...) {
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80065d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800664:	8d 45 0c             	lea    0xc(%ebp),%eax
  800667:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 f4             	pushl  -0xc(%ebp)
  800673:	50                   	push   %eax
  800674:	e8 73 ff ff ff       	call   8005ec <vcprintf>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80067f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800682:	c9                   	leave  
  800683:	c3                   	ret    

00800684 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800684:	55                   	push   %ebp
  800685:	89 e5                	mov    %esp,%ebp
  800687:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80068a:	e8 68 10 00 00       	call   8016f7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80068f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	ff 75 f4             	pushl  -0xc(%ebp)
  80069e:	50                   	push   %eax
  80069f:	e8 48 ff ff ff       	call   8005ec <vcprintf>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006aa:	e8 62 10 00 00       	call   801711 <sys_enable_interrupt>
	return cnt;
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	53                   	push   %ebx
  8006b8:	83 ec 14             	sub    $0x14,%esp
  8006bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d2:	77 55                	ja     800729 <printnum+0x75>
  8006d4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d7:	72 05                	jb     8006de <printnum+0x2a>
  8006d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006dc:	77 4b                	ja     800729 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006de:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	52                   	push   %edx
  8006ed:	50                   	push   %eax
  8006ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f4:	e8 83 14 00 00       	call   801b7c <__udivdi3>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	ff 75 20             	pushl  0x20(%ebp)
  800702:	53                   	push   %ebx
  800703:	ff 75 18             	pushl  0x18(%ebp)
  800706:	52                   	push   %edx
  800707:	50                   	push   %eax
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 08             	pushl  0x8(%ebp)
  80070e:	e8 a1 ff ff ff       	call   8006b4 <printnum>
  800713:	83 c4 20             	add    $0x20,%esp
  800716:	eb 1a                	jmp    800732 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	ff 75 20             	pushl  0x20(%ebp)
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800729:	ff 4d 1c             	decl   0x1c(%ebp)
  80072c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800730:	7f e6                	jg     800718 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800732:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800735:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800740:	53                   	push   %ebx
  800741:	51                   	push   %ecx
  800742:	52                   	push   %edx
  800743:	50                   	push   %eax
  800744:	e8 43 15 00 00       	call   801c8c <__umoddi3>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	05 54 23 80 00       	add    $0x802354,%eax
  800751:	8a 00                	mov    (%eax),%al
  800753:	0f be c0             	movsbl %al,%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	50                   	push   %eax
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
}
  800765:	90                   	nop
  800766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80076e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800772:	7e 1c                	jle    800790 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 08             	lea    0x8(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 08             	sub    $0x8,%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	eb 40                	jmp    8007d0 <getuint+0x65>
	else if (lflag)
  800790:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800794:	74 1e                	je     8007b4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	8d 50 04             	lea    0x4(%eax),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	89 10                	mov    %edx,(%eax)
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	83 e8 04             	sub    $0x4,%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	eb 1c                	jmp    8007d0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	8d 50 04             	lea    0x4(%eax),%edx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	89 10                	mov    %edx,(%eax)
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d9:	7e 1c                	jle    8007f7 <getint+0x25>
		return va_arg(*ap, long long);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 08             	lea    0x8(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 08             	sub    $0x8,%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	eb 38                	jmp    80082f <getint+0x5d>
	else if (lflag)
  8007f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fb:	74 1a                	je     800817 <getint+0x45>
		return va_arg(*ap, long);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 10                	mov    %edx,(%eax)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	83 e8 04             	sub    $0x4,%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	99                   	cltd   
  800815:	eb 18                	jmp    80082f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	8d 50 04             	lea    0x4(%eax),%edx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	89 10                	mov    %edx,(%eax)
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	99                   	cltd   
}
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800839:	eb 17                	jmp    800852 <vprintfmt+0x21>
			if (ch == '\0')
  80083b:	85 db                	test   %ebx,%ebx
  80083d:	0f 84 af 03 00 00    	je     800bf2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8d 50 01             	lea    0x1(%eax),%edx
  800858:	89 55 10             	mov    %edx,0x10(%ebp)
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	0f b6 d8             	movzbl %al,%ebx
  800860:	83 fb 25             	cmp    $0x25,%ebx
  800863:	75 d6                	jne    80083b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800865:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800869:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800870:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800877:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80087e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	8d 50 01             	lea    0x1(%eax),%edx
  80088b:	89 55 10             	mov    %edx,0x10(%ebp)
  80088e:	8a 00                	mov    (%eax),%al
  800890:	0f b6 d8             	movzbl %al,%ebx
  800893:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800896:	83 f8 55             	cmp    $0x55,%eax
  800899:	0f 87 2b 03 00 00    	ja     800bca <vprintfmt+0x399>
  80089f:	8b 04 85 78 23 80 00 	mov    0x802378(,%eax,4),%eax
  8008a6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d7                	jmp    800885 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ae:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b2:	eb d1                	jmp    800885 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008be:	89 d0                	mov    %edx,%eax
  8008c0:	c1 e0 02             	shl    $0x2,%eax
  8008c3:	01 d0                	add    %edx,%eax
  8008c5:	01 c0                	add    %eax,%eax
  8008c7:	01 d8                	add    %ebx,%eax
  8008c9:	83 e8 30             	sub    $0x30,%eax
  8008cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d2:	8a 00                	mov    (%eax),%al
  8008d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8008da:	7e 3e                	jle    80091a <vprintfmt+0xe9>
  8008dc:	83 fb 39             	cmp    $0x39,%ebx
  8008df:	7f 39                	jg     80091a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e4:	eb d5                	jmp    8008bb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	83 c0 04             	add    $0x4,%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	83 e8 04             	sub    $0x4,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008fa:	eb 1f                	jmp    80091b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800900:	79 83                	jns    800885 <vprintfmt+0x54>
				width = 0;
  800902:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800909:	e9 77 ff ff ff       	jmp    800885 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80090e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800915:	e9 6b ff ff ff       	jmp    800885 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80091a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80091b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091f:	0f 89 60 ff ff ff    	jns    800885 <vprintfmt+0x54>
				width = precision, precision = -1;
  800925:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800932:	e9 4e ff ff ff       	jmp    800885 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800937:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80093a:	e9 46 ff ff ff       	jmp    800885 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	50                   	push   %eax
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
			break;
  80095f:	e9 89 02 00 00       	jmp    800bed <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	83 c0 04             	add    $0x4,%eax
  80096a:	89 45 14             	mov    %eax,0x14(%ebp)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 e8 04             	sub    $0x4,%eax
  800973:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800975:	85 db                	test   %ebx,%ebx
  800977:	79 02                	jns    80097b <vprintfmt+0x14a>
				err = -err;
  800979:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80097b:	83 fb 64             	cmp    $0x64,%ebx
  80097e:	7f 0b                	jg     80098b <vprintfmt+0x15a>
  800980:	8b 34 9d c0 21 80 00 	mov    0x8021c0(,%ebx,4),%esi
  800987:	85 f6                	test   %esi,%esi
  800989:	75 19                	jne    8009a4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80098b:	53                   	push   %ebx
  80098c:	68 65 23 80 00       	push   $0x802365
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	ff 75 08             	pushl  0x8(%ebp)
  800997:	e8 5e 02 00 00       	call   800bfa <printfmt>
  80099c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80099f:	e9 49 02 00 00       	jmp    800bed <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a4:	56                   	push   %esi
  8009a5:	68 6e 23 80 00       	push   $0x80236e
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	ff 75 08             	pushl  0x8(%ebp)
  8009b0:	e8 45 02 00 00       	call   800bfa <printfmt>
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 30 02 00 00       	jmp    800bed <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 30                	mov    (%eax),%esi
  8009ce:	85 f6                	test   %esi,%esi
  8009d0:	75 05                	jne    8009d7 <vprintfmt+0x1a6>
				p = "(null)";
  8009d2:	be 71 23 80 00       	mov    $0x802371,%esi
			if (width > 0 && padc != '-')
  8009d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009db:	7e 6d                	jle    800a4a <vprintfmt+0x219>
  8009dd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009e1:	74 67                	je     800a4a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	50                   	push   %eax
  8009ea:	56                   	push   %esi
  8009eb:	e8 0c 03 00 00       	call   800cfc <strnlen>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f6:	eb 16                	jmp    800a0e <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	50                   	push   %eax
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e4                	jg     8009f8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a14:	eb 34                	jmp    800a4a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a16:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a1a:	74 1c                	je     800a38 <vprintfmt+0x207>
  800a1c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a1f:	7e 05                	jle    800a26 <vprintfmt+0x1f5>
  800a21:	83 fb 7e             	cmp    $0x7e,%ebx
  800a24:	7e 12                	jle    800a38 <vprintfmt+0x207>
					putch('?', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 3f                	push   $0x3f
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	eb 0f                	jmp    800a47 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	53                   	push   %ebx
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a47:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4a:	89 f0                	mov    %esi,%eax
  800a4c:	8d 70 01             	lea    0x1(%eax),%esi
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	0f be d8             	movsbl %al,%ebx
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	74 24                	je     800a7c <vprintfmt+0x24b>
  800a58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5c:	78 b8                	js     800a16 <vprintfmt+0x1e5>
  800a5e:	ff 4d e0             	decl   -0x20(%ebp)
  800a61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a65:	79 af                	jns    800a16 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a67:	eb 13                	jmp    800a7c <vprintfmt+0x24b>
				putch(' ', putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	6a 20                	push   $0x20
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a79:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a80:	7f e7                	jg     800a69 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a82:	e9 66 01 00 00       	jmp    800bed <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 3c fd ff ff       	call   8007d2 <getint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa5:	85 d2                	test   %edx,%edx
  800aa7:	79 23                	jns    800acc <vprintfmt+0x29b>
				putch('-', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 2d                	push   $0x2d
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abf:	f7 d8                	neg    %eax
  800ac1:	83 d2 00             	adc    $0x0,%edx
  800ac4:	f7 da                	neg    %edx
  800ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800acc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad3:	e9 bc 00 00 00       	jmp    800b94 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 84 fc ff ff       	call   80076b <getuint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800af0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af7:	e9 98 00 00 00       	jmp    800b94 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 58                	push   $0x58
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 58                	push   $0x58
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 58                	push   $0x58
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			break;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	6a 30                	push   $0x30
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	6a 78                	push   $0x78
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	83 c0 04             	add    $0x4,%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5d:	83 e8 04             	sub    $0x4,%eax
  800b60:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b73:	eb 1f                	jmp    800b94 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	e8 e7 fb ff ff       	call   80076b <getuint>
  800b84:	83 c4 10             	add    $0x10,%esp
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b8d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b94:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	52                   	push   %edx
  800b9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba2:	50                   	push   %eax
  800ba3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 00 fb ff ff       	call   8006b4 <printnum>
  800bb4:	83 c4 20             	add    $0x20,%esp
			break;
  800bb7:	eb 34                	jmp    800bed <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	53                   	push   %ebx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			break;
  800bc8:	eb 23                	jmp    800bed <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	6a 25                	push   $0x25
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	ff d0                	call   *%eax
  800bd7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bda:	ff 4d 10             	decl   0x10(%ebp)
  800bdd:	eb 03                	jmp    800be2 <vprintfmt+0x3b1>
  800bdf:	ff 4d 10             	decl   0x10(%ebp)
  800be2:	8b 45 10             	mov    0x10(%ebp),%eax
  800be5:	48                   	dec    %eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	3c 25                	cmp    $0x25,%al
  800bea:	75 f3                	jne    800bdf <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bec:	90                   	nop
		}
	}
  800bed:	e9 47 fc ff ff       	jmp    800839 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bf2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c00:	8d 45 10             	lea    0x10(%ebp),%eax
  800c03:	83 c0 04             	add    $0x4,%eax
  800c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c09:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0f:	50                   	push   %eax
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 08             	pushl  0x8(%ebp)
  800c16:	e8 16 fc ff ff       	call   800831 <vprintfmt>
  800c1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c1e:	90                   	nop
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8b 40 08             	mov    0x8(%eax),%eax
  800c2a:	8d 50 01             	lea    0x1(%eax),%edx
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8b 10                	mov    (%eax),%edx
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8b 40 04             	mov    0x4(%eax),%eax
  800c3e:	39 c2                	cmp    %eax,%edx
  800c40:	73 12                	jae    800c54 <sprintputch+0x33>
		*b->buf++ = ch;
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	8d 48 01             	lea    0x1(%eax),%ecx
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4d:	89 0a                	mov    %ecx,(%edx)
  800c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c52:	88 10                	mov    %dl,(%eax)
}
  800c54:	90                   	nop
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c7c:	74 06                	je     800c84 <vsnprintf+0x2d>
  800c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c82:	7f 07                	jg     800c8b <vsnprintf+0x34>
		return -E_INVAL;
  800c84:	b8 03 00 00 00       	mov    $0x3,%eax
  800c89:	eb 20                	jmp    800cab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c8b:	ff 75 14             	pushl  0x14(%ebp)
  800c8e:	ff 75 10             	pushl  0x10(%ebp)
  800c91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c94:	50                   	push   %eax
  800c95:	68 21 0c 80 00       	push   $0x800c21
  800c9a:	e8 92 fb ff ff       	call   800831 <vprintfmt>
  800c9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb6:	83 c0 04             	add    $0x4,%eax
  800cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc2:	50                   	push   %eax
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	ff 75 08             	pushl  0x8(%ebp)
  800cc9:	e8 89 ff ff ff       	call   800c57 <vsnprintf>
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce6:	eb 06                	jmp    800cee <strlen+0x15>
		n++;
  800ce8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ceb:	ff 45 08             	incl   0x8(%ebp)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 f1                	jne    800ce8 <strlen+0xf>
		n++;
	return n;
  800cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d09:	eb 09                	jmp    800d14 <strnlen+0x18>
		n++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0e:	ff 45 08             	incl   0x8(%ebp)
  800d11:	ff 4d 0c             	decl   0xc(%ebp)
  800d14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d18:	74 09                	je     800d23 <strnlen+0x27>
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 e8                	jne    800d0b <strnlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d34:	90                   	nop
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8d 50 01             	lea    0x1(%eax),%edx
  800d3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d47:	8a 12                	mov    (%edx),%dl
  800d49:	88 10                	mov    %dl,(%eax)
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 e4                	jne    800d35 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d69:	eb 1f                	jmp    800d8a <strncpy+0x34>
		*dst++ = *src;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8d 50 01             	lea    0x1(%eax),%edx
  800d71:	89 55 08             	mov    %edx,0x8(%ebp)
  800d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d77:	8a 12                	mov    (%edx),%dl
  800d79:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	74 03                	je     800d87 <strncpy+0x31>
			src++;
  800d84:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d87:	ff 45 fc             	incl   -0x4(%ebp)
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d90:	72 d9                	jb     800d6b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da7:	74 30                	je     800dd9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da9:	eb 16                	jmp    800dc1 <strlcpy+0x2a>
			*dst++ = *src++;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 08             	mov    %edx,0x8(%ebp)
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dbd:	8a 12                	mov    (%edx),%dl
  800dbf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dc1:	ff 4d 10             	decl   0x10(%ebp)
  800dc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc8:	74 09                	je     800dd3 <strlcpy+0x3c>
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	84 c0                	test   %al,%al
  800dd1:	75 d8                	jne    800dab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddf:	29 c2                	sub    %eax,%edx
  800de1:	89 d0                	mov    %edx,%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de8:	eb 06                	jmp    800df0 <strcmp+0xb>
		p++, q++;
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	84 c0                	test   %al,%al
  800df7:	74 0e                	je     800e07 <strcmp+0x22>
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 10                	mov    (%eax),%dl
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	38 c2                	cmp    %al,%dl
  800e05:	74 e3                	je     800dea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f b6 d0             	movzbl %al,%edx
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f b6 c0             	movzbl %al,%eax
  800e17:	29 c2                	sub    %eax,%edx
  800e19:	89 d0                	mov    %edx,%eax
}
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e20:	eb 09                	jmp    800e2b <strncmp+0xe>
		n--, p++, q++;
  800e22:	ff 4d 10             	decl   0x10(%ebp)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2f:	74 17                	je     800e48 <strncmp+0x2b>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	84 c0                	test   %al,%al
  800e38:	74 0e                	je     800e48 <strncmp+0x2b>
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	38 c2                	cmp    %al,%dl
  800e46:	74 da                	je     800e22 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4c:	75 07                	jne    800e55 <strncmp+0x38>
		return 0;
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e53:	eb 14                	jmp    800e69 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d0             	movzbl %al,%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 c0             	movzbl %al,%eax
  800e65:	29 c2                	sub    %eax,%edx
  800e67:	89 d0                	mov    %edx,%eax
}
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e77:	eb 12                	jmp    800e8b <strchr+0x20>
		if (*s == c)
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e81:	75 05                	jne    800e88 <strchr+0x1d>
			return (char *) s;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	eb 11                	jmp    800e99 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	84 c0                	test   %al,%al
  800e92:	75 e5                	jne    800e79 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea7:	eb 0d                	jmp    800eb6 <strfind+0x1b>
		if (*s == c)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb1:	74 0e                	je     800ec1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eb3:	ff 45 08             	incl   0x8(%ebp)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	84 c0                	test   %al,%al
  800ebd:	75 ea                	jne    800ea9 <strfind+0xe>
  800ebf:	eb 01                	jmp    800ec2 <strfind+0x27>
		if (*s == c)
			break;
  800ec1:	90                   	nop
	return (char *) s;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed9:	eb 0e                	jmp    800ee9 <memset+0x22>
		*p++ = c;
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ede:	8d 50 01             	lea    0x1(%eax),%edx
  800ee1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee9:	ff 4d f8             	decl   -0x8(%ebp)
  800eec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ef0:	79 e9                	jns    800edb <memset+0x14>
		*p++ = c;

	return v;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f09:	eb 16                	jmp    800f21 <memcpy+0x2a>
		*d++ = *s++;
  800f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1d:	8a 12                	mov    (%edx),%dl
  800f1f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f27:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	75 dd                	jne    800f0b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f4b:	73 50                	jae    800f9d <memmove+0x6a>
  800f4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f58:	76 43                	jbe    800f9d <memmove+0x6a>
		s += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f66:	eb 10                	jmp    800f78 <memmove+0x45>
			*--d = *--s;
  800f68:	ff 4d f8             	decl   -0x8(%ebp)
  800f6b:	ff 4d fc             	decl   -0x4(%ebp)
  800f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f71:	8a 10                	mov    (%eax),%dl
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f76:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 e3                	jne    800f68 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f85:	eb 23                	jmp    800faa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8a:	8d 50 01             	lea    0x1(%eax),%edx
  800f8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f99:	8a 12                	mov    (%edx),%dl
  800f9b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	75 dd                	jne    800f87 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fc1:	eb 2a                	jmp    800fed <memcmp+0x3e>
		if (*s1 != *s2)
  800fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc6:	8a 10                	mov    (%eax),%dl
  800fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	38 c2                	cmp    %al,%dl
  800fcf:	74 16                	je     800fe7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f b6 d0             	movzbl %al,%edx
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f b6 c0             	movzbl %al,%eax
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 d0                	mov    %edx,%eax
  800fe5:	eb 18                	jmp    800fff <memcmp+0x50>
		s1++, s2++;
  800fe7:	ff 45 fc             	incl   -0x4(%ebp)
  800fea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	75 c9                	jne    800fc3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801007:	8b 55 08             	mov    0x8(%ebp),%edx
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	01 d0                	add    %edx,%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801012:	eb 15                	jmp    801029 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	0f b6 d0             	movzbl %al,%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	0f b6 c0             	movzbl %al,%eax
  801022:	39 c2                	cmp    %eax,%edx
  801024:	74 0d                	je     801033 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801026:	ff 45 08             	incl   0x8(%ebp)
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80102f:	72 e3                	jb     801014 <memfind+0x13>
  801031:	eb 01                	jmp    801034 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801033:	90                   	nop
	return (void *) s;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80103f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801046:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104d:	eb 03                	jmp    801052 <strtol+0x19>
		s++;
  80104f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	3c 20                	cmp    $0x20,%al
  801059:	74 f4                	je     80104f <strtol+0x16>
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	3c 09                	cmp    $0x9,%al
  801062:	74 eb                	je     80104f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 2b                	cmp    $0x2b,%al
  80106b:	75 05                	jne    801072 <strtol+0x39>
		s++;
  80106d:	ff 45 08             	incl   0x8(%ebp)
  801070:	eb 13                	jmp    801085 <strtol+0x4c>
	else if (*s == '-')
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	3c 2d                	cmp    $0x2d,%al
  801079:	75 0a                	jne    801085 <strtol+0x4c>
		s++, neg = 1;
  80107b:	ff 45 08             	incl   0x8(%ebp)
  80107e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801085:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801089:	74 06                	je     801091 <strtol+0x58>
  80108b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80108f:	75 20                	jne    8010b1 <strtol+0x78>
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 30                	cmp    $0x30,%al
  801098:	75 17                	jne    8010b1 <strtol+0x78>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	40                   	inc    %eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 78                	cmp    $0x78,%al
  8010a2:	75 0d                	jne    8010b1 <strtol+0x78>
		s += 2, base = 16;
  8010a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010af:	eb 28                	jmp    8010d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	75 15                	jne    8010cc <strtol+0x93>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 30                	cmp    $0x30,%al
  8010be:	75 0c                	jne    8010cc <strtol+0x93>
		s++, base = 8;
  8010c0:	ff 45 08             	incl   0x8(%ebp)
  8010c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010ca:	eb 0d                	jmp    8010d9 <strtol+0xa0>
	else if (base == 0)
  8010cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d0:	75 07                	jne    8010d9 <strtol+0xa0>
		base = 10;
  8010d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 2f                	cmp    $0x2f,%al
  8010e0:	7e 19                	jle    8010fb <strtol+0xc2>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 39                	cmp    $0x39,%al
  8010e9:	7f 10                	jg     8010fb <strtol+0xc2>
			dig = *s - '0';
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	0f be c0             	movsbl %al,%eax
  8010f3:	83 e8 30             	sub    $0x30,%eax
  8010f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f9:	eb 42                	jmp    80113d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 60                	cmp    $0x60,%al
  801102:	7e 19                	jle    80111d <strtol+0xe4>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 7a                	cmp    $0x7a,%al
  80110b:	7f 10                	jg     80111d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f be c0             	movsbl %al,%eax
  801115:	83 e8 57             	sub    $0x57,%eax
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80111b:	eb 20                	jmp    80113d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 40                	cmp    $0x40,%al
  801124:	7e 39                	jle    80115f <strtol+0x126>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 5a                	cmp    $0x5a,%al
  80112d:	7f 30                	jg     80115f <strtol+0x126>
			dig = *s - 'A' + 10;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f be c0             	movsbl %al,%eax
  801137:	83 e8 37             	sub    $0x37,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 10             	cmp    0x10(%ebp),%eax
  801143:	7d 19                	jge    80115e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801145:	ff 45 08             	incl   0x8(%ebp)
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80114f:	89 c2                	mov    %eax,%edx
  801151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801154:	01 d0                	add    %edx,%eax
  801156:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801159:	e9 7b ff ff ff       	jmp    8010d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80115e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80115f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801163:	74 08                	je     80116d <strtol+0x134>
		*endptr = (char *) s;
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	8b 55 08             	mov    0x8(%ebp),%edx
  80116b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80116d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801171:	74 07                	je     80117a <strtol+0x141>
  801173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801176:	f7 d8                	neg    %eax
  801178:	eb 03                	jmp    80117d <strtol+0x144>
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <ltostr>:

void
ltostr(long value, char *str)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80118c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801197:	79 13                	jns    8011ac <ltostr+0x2d>
	{
		neg = 1;
  801199:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011b4:	99                   	cltd   
  8011b5:	f7 f9                	idiv   %ecx
  8011b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bd:	8d 50 01             	lea    0x1(%eax),%edx
  8011c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011cd:	83 c2 30             	add    $0x30,%edx
  8011d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011da:	f7 e9                	imul   %ecx
  8011dc:	c1 fa 02             	sar    $0x2,%edx
  8011df:	89 c8                	mov    %ecx,%eax
  8011e1:	c1 f8 1f             	sar    $0x1f,%eax
  8011e4:	29 c2                	sub    %eax,%edx
  8011e6:	89 d0                	mov    %edx,%eax
  8011e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f3:	f7 e9                	imul   %ecx
  8011f5:	c1 fa 02             	sar    $0x2,%edx
  8011f8:	89 c8                	mov    %ecx,%eax
  8011fa:	c1 f8 1f             	sar    $0x1f,%eax
  8011fd:	29 c2                	sub    %eax,%edx
  8011ff:	89 d0                	mov    %edx,%eax
  801201:	c1 e0 02             	shl    $0x2,%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	01 c0                	add    %eax,%eax
  801208:	29 c1                	sub    %eax,%ecx
  80120a:	89 ca                	mov    %ecx,%edx
  80120c:	85 d2                	test   %edx,%edx
  80120e:	75 9c                	jne    8011ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	48                   	dec    %eax
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80121e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801222:	74 3d                	je     801261 <ltostr+0xe2>
		start = 1 ;
  801224:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122b:	eb 34                	jmp    801261 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80122d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	01 c2                	add    %eax,%edx
  801242:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 c8                	add    %ecx,%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80124e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8a 45 eb             	mov    -0x15(%ebp),%al
  801259:	88 02                	mov    %al,(%edx)
		start++ ;
  80125b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80125e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801267:	7c c4                	jl     80122d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801269:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80126c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801274:	90                   	nop
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80127d:	ff 75 08             	pushl  0x8(%ebp)
  801280:	e8 54 fa ff ff       	call   800cd9 <strlen>
  801285:	83 c4 04             	add    $0x4,%esp
  801288:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128b:	ff 75 0c             	pushl  0xc(%ebp)
  80128e:	e8 46 fa ff ff       	call   800cd9 <strlen>
  801293:	83 c4 04             	add    $0x4,%esp
  801296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801299:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a7:	eb 17                	jmp    8012c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	01 c2                	add    %eax,%edx
  8012b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	01 c8                	add    %ecx,%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c6:	7c e1                	jl     8012a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d6:	eb 1f                	jmp    8012f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	8d 50 01             	lea    0x1(%eax),%edx
  8012de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	01 c2                	add    %eax,%edx
  8012e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	01 c8                	add    %ecx,%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f4:	ff 45 f8             	incl   -0x8(%ebp)
  8012f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012fd:	7c d9                	jl     8012d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
  801305:	01 d0                	add    %edx,%eax
  801307:	c6 00 00             	movb   $0x0,(%eax)
}
  80130a:	90                   	nop
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801310:	8b 45 14             	mov    0x14(%ebp),%eax
  801313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801319:	8b 45 14             	mov    0x14(%ebp),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 d0                	add    %edx,%eax
  80132a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801330:	eb 0c                	jmp    80133e <strsplit+0x31>
			*string++ = 0;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8d 50 01             	lea    0x1(%eax),%edx
  801338:	89 55 08             	mov    %edx,0x8(%ebp)
  80133b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	74 18                	je     80135f <strsplit+0x52>
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	0f be c0             	movsbl %al,%eax
  80134f:	50                   	push   %eax
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	e8 13 fb ff ff       	call   800e6b <strchr>
  801358:	83 c4 08             	add    $0x8,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	75 d3                	jne    801332 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	84 c0                	test   %al,%al
  801366:	74 5a                	je     8013c2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801368:	8b 45 14             	mov    0x14(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 f8 0f             	cmp    $0xf,%eax
  801370:	75 07                	jne    801379 <strsplit+0x6c>
		{
			return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
  801377:	eb 66                	jmp    8013df <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801379:	8b 45 14             	mov    0x14(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 48 01             	lea    0x1(%eax),%ecx
  801381:	8b 55 14             	mov    0x14(%ebp),%edx
  801384:	89 0a                	mov    %ecx,(%edx)
  801386:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138d:	8b 45 10             	mov    0x10(%ebp),%eax
  801390:	01 c2                	add    %eax,%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801397:	eb 03                	jmp    80139c <strsplit+0x8f>
			string++;
  801399:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	74 8b                	je     801330 <strsplit+0x23>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f be c0             	movsbl %al,%eax
  8013ad:	50                   	push   %eax
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 b5 fa ff ff       	call   800e6b <strchr>
  8013b6:	83 c4 08             	add    $0x8,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	74 dc                	je     801399 <strsplit+0x8c>
			string++;
	}
  8013bd:	e9 6e ff ff ff       	jmp    801330 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 d0 24 80 00       	push   $0x8024d0
  8013ef:	6a 0e                	push   $0xe
  8013f1:	68 0a 25 80 00       	push   $0x80250a
  8013f6:	e8 a8 ef ff ff       	call   8003a3 <_panic>

008013fb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801401:	a1 04 30 80 00       	mov    0x803004,%eax
  801406:	85 c0                	test   %eax,%eax
  801408:	74 0f                	je     801419 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80140a:	e8 d2 ff ff ff       	call   8013e1 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80140f:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801416:	00 00 00 
	}
	if (size == 0) return NULL ;
  801419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80141d:	75 07                	jne    801426 <malloc+0x2b>
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
  801424:	eb 14                	jmp    80143a <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	68 18 25 80 00       	push   $0x802518
  80142e:	6a 2e                	push   $0x2e
  801430:	68 0a 25 80 00       	push   $0x80250a
  801435:	e8 69 ef ff ff       	call   8003a3 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	68 40 25 80 00       	push   $0x802540
  80144a:	6a 49                	push   $0x49
  80144c:	68 0a 25 80 00       	push   $0x80250a
  801451:	e8 4d ef ff ff       	call   8003a3 <_panic>

00801456 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 18             	sub    $0x18,%esp
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 64 25 80 00       	push   $0x802564
  80146a:	6a 57                	push   $0x57
  80146c:	68 0a 25 80 00       	push   $0x80250a
  801471:	e8 2d ef ff ff       	call   8003a3 <_panic>

00801476 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	68 8c 25 80 00       	push   $0x80258c
  801484:	6a 60                	push   $0x60
  801486:	68 0a 25 80 00       	push   $0x80250a
  80148b:	e8 13 ef ff ff       	call   8003a3 <_panic>

00801490 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	68 b0 25 80 00       	push   $0x8025b0
  80149e:	6a 7c                	push   $0x7c
  8014a0:	68 0a 25 80 00       	push   $0x80250a
  8014a5:	e8 f9 ee ff ff       	call   8003a3 <_panic>

008014aa <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 d8 25 80 00       	push   $0x8025d8
  8014b8:	68 86 00 00 00       	push   $0x86
  8014bd:	68 0a 25 80 00       	push   $0x80250a
  8014c2:	e8 dc ee ff ff       	call   8003a3 <_panic>

008014c7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	68 fc 25 80 00       	push   $0x8025fc
  8014d5:	68 91 00 00 00       	push   $0x91
  8014da:	68 0a 25 80 00       	push   $0x80250a
  8014df:	e8 bf ee ff ff       	call   8003a3 <_panic>

008014e4 <shrink>:

}
void shrink(uint32 newSize)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	68 fc 25 80 00       	push   $0x8025fc
  8014f2:	68 96 00 00 00       	push   $0x96
  8014f7:	68 0a 25 80 00       	push   $0x80250a
  8014fc:	e8 a2 ee ff ff       	call   8003a3 <_panic>

00801501 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	68 fc 25 80 00       	push   $0x8025fc
  80150f:	68 9b 00 00 00       	push   $0x9b
  801514:	68 0a 25 80 00       	push   $0x80250a
  801519:	e8 85 ee ff ff       	call   8003a3 <_panic>

0080151e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	57                   	push   %edi
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801530:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801533:	8b 7d 18             	mov    0x18(%ebp),%edi
  801536:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801539:	cd 30                	int    $0x30
  80153b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5f                   	pop    %edi
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    

00801549 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
  801552:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801555:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	52                   	push   %edx
  801561:	ff 75 0c             	pushl  0xc(%ebp)
  801564:	50                   	push   %eax
  801565:	6a 00                	push   $0x0
  801567:	e8 b2 ff ff ff       	call   80151e <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	90                   	nop
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_cgetc>:

int
sys_cgetc(void)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 01                	push   $0x1
  801581:	e8 98 ff ff ff       	call   80151e <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80158e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	52                   	push   %edx
  80159b:	50                   	push   %eax
  80159c:	6a 05                	push   $0x5
  80159e:	e8 7b ff ff ff       	call   80151e <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015ad:	8b 75 18             	mov    0x18(%ebp),%esi
  8015b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	51                   	push   %ecx
  8015bf:	52                   	push   %edx
  8015c0:	50                   	push   %eax
  8015c1:	6a 06                	push   $0x6
  8015c3:	e8 56 ff ff ff       	call   80151e <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ce:	5b                   	pop    %ebx
  8015cf:	5e                   	pop    %esi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    

008015d2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	52                   	push   %edx
  8015e2:	50                   	push   %eax
  8015e3:	6a 07                	push   $0x7
  8015e5:	e8 34 ff ff ff       	call   80151e <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 08                	push   $0x8
  801600:	e8 19 ff ff ff       	call   80151e <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 09                	push   $0x9
  801619:	e8 00 ff ff ff       	call   80151e <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 0a                	push   $0xa
  801632:	e8 e7 fe ff ff       	call   80151e <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 0b                	push   $0xb
  80164b:	e8 ce fe ff ff       	call   80151e <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	6a 0f                	push   $0xf
  801666:	e8 b3 fe ff ff       	call   80151e <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
	return;
  80166e:	90                   	nop
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	6a 10                	push   $0x10
  801682:	e8 97 fe ff ff       	call   80151e <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
	return ;
  80168a:	90                   	nop
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	ff 75 10             	pushl  0x10(%ebp)
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	6a 11                	push   $0x11
  80169f:	e8 7a fe ff ff       	call   80151e <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a7:	90                   	nop
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 0c                	push   $0xc
  8016b9:	e8 60 fe ff ff       	call   80151e <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 0d                	push   $0xd
  8016d3:	e8 46 fe ff ff       	call   80151e <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 0e                	push   $0xe
  8016ec:	e8 2d fe ff ff       	call   80151e <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 13                	push   $0x13
  801706:	e8 13 fe ff ff       	call   80151e <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 14                	push   $0x14
  801720:	e8 f9 fd ff ff       	call   80151e <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_cputc>:


void
sys_cputc(const char c)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801737:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	50                   	push   %eax
  801744:	6a 15                	push   $0x15
  801746:	e8 d3 fd ff ff       	call   80151e <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 16                	push   $0x16
  801760:	e8 b9 fd ff ff       	call   80151e <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	50                   	push   %eax
  80177b:	6a 17                	push   $0x17
  80177d:	e8 9c fd ff ff       	call   80151e <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	52                   	push   %edx
  801797:	50                   	push   %eax
  801798:	6a 1a                	push   $0x1a
  80179a:	e8 7f fd ff ff       	call   80151e <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	52                   	push   %edx
  8017b4:	50                   	push   %eax
  8017b5:	6a 18                	push   $0x18
  8017b7:	e8 62 fd ff ff       	call   80151e <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	90                   	nop
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	6a 19                	push   $0x19
  8017d5:	e8 44 fd ff ff       	call   80151e <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	51                   	push   %ecx
  8017f9:	52                   	push   %edx
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	6a 1b                	push   $0x1b
  801800:	e8 19 fd ff ff       	call   80151e <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 1c                	push   $0x1c
  80181d:	e8 fc fc ff ff       	call   80151e <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80182a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	51                   	push   %ecx
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 1d                	push   $0x1d
  80183c:	e8 dd fc ff ff       	call   80151e <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	52                   	push   %edx
  801856:	50                   	push   %eax
  801857:	6a 1e                	push   $0x1e
  801859:	e8 c0 fc ff ff       	call   80151e <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 1f                	push   $0x1f
  801872:	e8 a7 fc ff ff       	call   80151e <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	ff 75 14             	pushl  0x14(%ebp)
  801887:	ff 75 10             	pushl  0x10(%ebp)
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	6a 20                	push   $0x20
  801890:	e8 89 fc ff ff       	call   80151e <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	50                   	push   %eax
  8018a9:	6a 21                	push   $0x21
  8018ab:	e8 6e fc ff ff       	call   80151e <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	90                   	nop
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	50                   	push   %eax
  8018c5:	6a 22                	push   $0x22
  8018c7:	e8 52 fc ff ff       	call   80151e <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 02                	push   $0x2
  8018e0:	e8 39 fc ff ff       	call   80151e <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 03                	push   $0x3
  8018f9:	e8 20 fc ff ff       	call   80151e <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 04                	push   $0x4
  801912:	e8 07 fc ff ff       	call   80151e <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_exit_env>:


void sys_exit_env(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 23                	push   $0x23
  80192b:	e8 ee fb ff ff       	call   80151e <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80193c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80193f:	8d 50 04             	lea    0x4(%eax),%edx
  801942:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	6a 24                	push   $0x24
  80194f:	e8 ca fb ff ff       	call   80151e <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return result;
  801957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801960:	89 01                	mov    %eax,(%ecx)
  801962:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	c9                   	leave  
  801969:	c2 04 00             	ret    $0x4

0080196c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 10             	pushl  0x10(%ebp)
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 12                	push   $0x12
  80197e:	e8 9b fb ff ff       	call   80151e <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_rcr2>:
uint32 sys_rcr2()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 25                	push   $0x25
  801998:	e8 81 fb ff ff       	call   80151e <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	50                   	push   %eax
  8019bb:	6a 26                	push   $0x26
  8019bd:	e8 5c fb ff ff       	call   80151e <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c5:	90                   	nop
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <rsttst>:
void rsttst()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 28                	push   $0x28
  8019d7:	e8 42 fb ff ff       	call   80151e <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ee:	8b 55 18             	mov    0x18(%ebp),%edx
  8019f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	ff 75 10             	pushl  0x10(%ebp)
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 27                	push   $0x27
  801a02:	e8 17 fb ff ff       	call   80151e <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <chktst>:
void chktst(uint32 n)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	6a 29                	push   $0x29
  801a1d:	e8 fc fa ff ff       	call   80151e <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <inctst>:

void inctst()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 2a                	push   $0x2a
  801a37:	e8 e2 fa ff ff       	call   80151e <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <gettst>:
uint32 gettst()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 2b                	push   $0x2b
  801a51:	e8 c8 fa ff ff       	call   80151e <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 2c                	push   $0x2c
  801a6d:	e8 ac fa ff ff       	call   80151e <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
  801a75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a78:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a7c:	75 07                	jne    801a85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a83:	eb 05                	jmp    801a8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 2c                	push   $0x2c
  801a9e:	e8 7b fa ff ff       	call   80151e <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
  801aa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aa9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aad:	75 07                	jne    801ab6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab4:	eb 05                	jmp    801abb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 2c                	push   $0x2c
  801acf:	e8 4a fa ff ff       	call   80151e <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ada:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ade:	75 07                	jne    801ae7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ae0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae5:	eb 05                	jmp    801aec <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 2c                	push   $0x2c
  801b00:	e8 19 fa ff ff       	call   80151e <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
  801b08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b0b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b0f:	75 07                	jne    801b18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	eb 05                	jmp    801b1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 2d                	push   $0x2d
  801b2f:	e8 ea f9 ff ff       	call   80151e <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return ;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	53                   	push   %ebx
  801b4d:	51                   	push   %ecx
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 2e                	push   $0x2e
  801b52:	e8 c7 f9 ff ff       	call   80151e <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 2f                	push   $0x2f
  801b72:	e8 a7 f9 ff ff       	call   80151e <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <__udivdi3>:
  801b7c:	55                   	push   %ebp
  801b7d:	57                   	push   %edi
  801b7e:	56                   	push   %esi
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 1c             	sub    $0x1c,%esp
  801b83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b93:	89 ca                	mov    %ecx,%edx
  801b95:	89 f8                	mov    %edi,%eax
  801b97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b9b:	85 f6                	test   %esi,%esi
  801b9d:	75 2d                	jne    801bcc <__udivdi3+0x50>
  801b9f:	39 cf                	cmp    %ecx,%edi
  801ba1:	77 65                	ja     801c08 <__udivdi3+0x8c>
  801ba3:	89 fd                	mov    %edi,%ebp
  801ba5:	85 ff                	test   %edi,%edi
  801ba7:	75 0b                	jne    801bb4 <__udivdi3+0x38>
  801ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bae:	31 d2                	xor    %edx,%edx
  801bb0:	f7 f7                	div    %edi
  801bb2:	89 c5                	mov    %eax,%ebp
  801bb4:	31 d2                	xor    %edx,%edx
  801bb6:	89 c8                	mov    %ecx,%eax
  801bb8:	f7 f5                	div    %ebp
  801bba:	89 c1                	mov    %eax,%ecx
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	f7 f5                	div    %ebp
  801bc0:	89 cf                	mov    %ecx,%edi
  801bc2:	89 fa                	mov    %edi,%edx
  801bc4:	83 c4 1c             	add    $0x1c,%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
  801bcc:	39 ce                	cmp    %ecx,%esi
  801bce:	77 28                	ja     801bf8 <__udivdi3+0x7c>
  801bd0:	0f bd fe             	bsr    %esi,%edi
  801bd3:	83 f7 1f             	xor    $0x1f,%edi
  801bd6:	75 40                	jne    801c18 <__udivdi3+0x9c>
  801bd8:	39 ce                	cmp    %ecx,%esi
  801bda:	72 0a                	jb     801be6 <__udivdi3+0x6a>
  801bdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801be0:	0f 87 9e 00 00 00    	ja     801c84 <__udivdi3+0x108>
  801be6:	b8 01 00 00 00       	mov    $0x1,%eax
  801beb:	89 fa                	mov    %edi,%edx
  801bed:	83 c4 1c             	add    $0x1c,%esp
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5f                   	pop    %edi
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    
  801bf5:	8d 76 00             	lea    0x0(%esi),%esi
  801bf8:	31 ff                	xor    %edi,%edi
  801bfa:	31 c0                	xor    %eax,%eax
  801bfc:	89 fa                	mov    %edi,%edx
  801bfe:	83 c4 1c             	add    $0x1c,%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5e                   	pop    %esi
  801c03:	5f                   	pop    %edi
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	f7 f7                	div    %edi
  801c0c:	31 ff                	xor    %edi,%edi
  801c0e:	89 fa                	mov    %edi,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c1d:	89 eb                	mov    %ebp,%ebx
  801c1f:	29 fb                	sub    %edi,%ebx
  801c21:	89 f9                	mov    %edi,%ecx
  801c23:	d3 e6                	shl    %cl,%esi
  801c25:	89 c5                	mov    %eax,%ebp
  801c27:	88 d9                	mov    %bl,%cl
  801c29:	d3 ed                	shr    %cl,%ebp
  801c2b:	89 e9                	mov    %ebp,%ecx
  801c2d:	09 f1                	or     %esi,%ecx
  801c2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c33:	89 f9                	mov    %edi,%ecx
  801c35:	d3 e0                	shl    %cl,%eax
  801c37:	89 c5                	mov    %eax,%ebp
  801c39:	89 d6                	mov    %edx,%esi
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 ee                	shr    %cl,%esi
  801c3f:	89 f9                	mov    %edi,%ecx
  801c41:	d3 e2                	shl    %cl,%edx
  801c43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 e8                	shr    %cl,%eax
  801c4b:	09 c2                	or     %eax,%edx
  801c4d:	89 d0                	mov    %edx,%eax
  801c4f:	89 f2                	mov    %esi,%edx
  801c51:	f7 74 24 0c          	divl   0xc(%esp)
  801c55:	89 d6                	mov    %edx,%esi
  801c57:	89 c3                	mov    %eax,%ebx
  801c59:	f7 e5                	mul    %ebp
  801c5b:	39 d6                	cmp    %edx,%esi
  801c5d:	72 19                	jb     801c78 <__udivdi3+0xfc>
  801c5f:	74 0b                	je     801c6c <__udivdi3+0xf0>
  801c61:	89 d8                	mov    %ebx,%eax
  801c63:	31 ff                	xor    %edi,%edi
  801c65:	e9 58 ff ff ff       	jmp    801bc2 <__udivdi3+0x46>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c70:	89 f9                	mov    %edi,%ecx
  801c72:	d3 e2                	shl    %cl,%edx
  801c74:	39 c2                	cmp    %eax,%edx
  801c76:	73 e9                	jae    801c61 <__udivdi3+0xe5>
  801c78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c7b:	31 ff                	xor    %edi,%edi
  801c7d:	e9 40 ff ff ff       	jmp    801bc2 <__udivdi3+0x46>
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	31 c0                	xor    %eax,%eax
  801c86:	e9 37 ff ff ff       	jmp    801bc2 <__udivdi3+0x46>
  801c8b:	90                   	nop

00801c8c <__umoddi3>:
  801c8c:	55                   	push   %ebp
  801c8d:	57                   	push   %edi
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 1c             	sub    $0x1c,%esp
  801c93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ca3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cab:	89 f3                	mov    %esi,%ebx
  801cad:	89 fa                	mov    %edi,%edx
  801caf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb3:	89 34 24             	mov    %esi,(%esp)
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	75 1a                	jne    801cd4 <__umoddi3+0x48>
  801cba:	39 f7                	cmp    %esi,%edi
  801cbc:	0f 86 a2 00 00 00    	jbe    801d64 <__umoddi3+0xd8>
  801cc2:	89 c8                	mov    %ecx,%eax
  801cc4:	89 f2                	mov    %esi,%edx
  801cc6:	f7 f7                	div    %edi
  801cc8:	89 d0                	mov    %edx,%eax
  801cca:	31 d2                	xor    %edx,%edx
  801ccc:	83 c4 1c             	add    $0x1c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    
  801cd4:	39 f0                	cmp    %esi,%eax
  801cd6:	0f 87 ac 00 00 00    	ja     801d88 <__umoddi3+0xfc>
  801cdc:	0f bd e8             	bsr    %eax,%ebp
  801cdf:	83 f5 1f             	xor    $0x1f,%ebp
  801ce2:	0f 84 ac 00 00 00    	je     801d94 <__umoddi3+0x108>
  801ce8:	bf 20 00 00 00       	mov    $0x20,%edi
  801ced:	29 ef                	sub    %ebp,%edi
  801cef:	89 fe                	mov    %edi,%esi
  801cf1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cf5:	89 e9                	mov    %ebp,%ecx
  801cf7:	d3 e0                	shl    %cl,%eax
  801cf9:	89 d7                	mov    %edx,%edi
  801cfb:	89 f1                	mov    %esi,%ecx
  801cfd:	d3 ef                	shr    %cl,%edi
  801cff:	09 c7                	or     %eax,%edi
  801d01:	89 e9                	mov    %ebp,%ecx
  801d03:	d3 e2                	shl    %cl,%edx
  801d05:	89 14 24             	mov    %edx,(%esp)
  801d08:	89 d8                	mov    %ebx,%eax
  801d0a:	d3 e0                	shl    %cl,%eax
  801d0c:	89 c2                	mov    %eax,%edx
  801d0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d12:	d3 e0                	shl    %cl,%eax
  801d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1c:	89 f1                	mov    %esi,%ecx
  801d1e:	d3 e8                	shr    %cl,%eax
  801d20:	09 d0                	or     %edx,%eax
  801d22:	d3 eb                	shr    %cl,%ebx
  801d24:	89 da                	mov    %ebx,%edx
  801d26:	f7 f7                	div    %edi
  801d28:	89 d3                	mov    %edx,%ebx
  801d2a:	f7 24 24             	mull   (%esp)
  801d2d:	89 c6                	mov    %eax,%esi
  801d2f:	89 d1                	mov    %edx,%ecx
  801d31:	39 d3                	cmp    %edx,%ebx
  801d33:	0f 82 87 00 00 00    	jb     801dc0 <__umoddi3+0x134>
  801d39:	0f 84 91 00 00 00    	je     801dd0 <__umoddi3+0x144>
  801d3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d43:	29 f2                	sub    %esi,%edx
  801d45:	19 cb                	sbb    %ecx,%ebx
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d4d:	d3 e0                	shl    %cl,%eax
  801d4f:	89 e9                	mov    %ebp,%ecx
  801d51:	d3 ea                	shr    %cl,%edx
  801d53:	09 d0                	or     %edx,%eax
  801d55:	89 e9                	mov    %ebp,%ecx
  801d57:	d3 eb                	shr    %cl,%ebx
  801d59:	89 da                	mov    %ebx,%edx
  801d5b:	83 c4 1c             	add    $0x1c,%esp
  801d5e:	5b                   	pop    %ebx
  801d5f:	5e                   	pop    %esi
  801d60:	5f                   	pop    %edi
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    
  801d63:	90                   	nop
  801d64:	89 fd                	mov    %edi,%ebp
  801d66:	85 ff                	test   %edi,%edi
  801d68:	75 0b                	jne    801d75 <__umoddi3+0xe9>
  801d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6f:	31 d2                	xor    %edx,%edx
  801d71:	f7 f7                	div    %edi
  801d73:	89 c5                	mov    %eax,%ebp
  801d75:	89 f0                	mov    %esi,%eax
  801d77:	31 d2                	xor    %edx,%edx
  801d79:	f7 f5                	div    %ebp
  801d7b:	89 c8                	mov    %ecx,%eax
  801d7d:	f7 f5                	div    %ebp
  801d7f:	89 d0                	mov    %edx,%eax
  801d81:	e9 44 ff ff ff       	jmp    801cca <__umoddi3+0x3e>
  801d86:	66 90                	xchg   %ax,%ax
  801d88:	89 c8                	mov    %ecx,%eax
  801d8a:	89 f2                	mov    %esi,%edx
  801d8c:	83 c4 1c             	add    $0x1c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
  801d94:	3b 04 24             	cmp    (%esp),%eax
  801d97:	72 06                	jb     801d9f <__umoddi3+0x113>
  801d99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d9d:	77 0f                	ja     801dae <__umoddi3+0x122>
  801d9f:	89 f2                	mov    %esi,%edx
  801da1:	29 f9                	sub    %edi,%ecx
  801da3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801da7:	89 14 24             	mov    %edx,(%esp)
  801daa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801db2:	8b 14 24             	mov    (%esp),%edx
  801db5:	83 c4 1c             	add    $0x1c,%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	2b 04 24             	sub    (%esp),%eax
  801dc3:	19 fa                	sbb    %edi,%edx
  801dc5:	89 d1                	mov    %edx,%ecx
  801dc7:	89 c6                	mov    %eax,%esi
  801dc9:	e9 71 ff ff ff       	jmp    801d3f <__umoddi3+0xb3>
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dd4:	72 ea                	jb     801dc0 <__umoddi3+0x134>
  801dd6:	89 d9                	mov    %ebx,%ecx
  801dd8:	e9 62 ff ff ff       	jmp    801d3f <__umoddi3+0xb3>
