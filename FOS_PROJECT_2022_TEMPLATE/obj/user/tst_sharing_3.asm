
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 49 02 00 00       	call   80027f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
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
  80008c:	68 20 1e 80 00       	push   $0x801e20
  800091:	6a 12                	push   $0x12
  800093:	68 3c 1e 80 00       	push   $0x801e3c
  800098:	e8 31 03 00 00       	call   8003ce <_panic>
	}
	cprintf("************************************************\n");
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 54 1e 80 00       	push   $0x801e54
  8000a5:	e8 d8 05 00 00       	call   800682 <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 88 1e 80 00       	push   $0x801e88
  8000b5:	e8 c8 05 00 00       	call   800682 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 e4 1e 80 00       	push   $0x801ee4
  8000c5:	e8 b8 05 00 00       	call   800682 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 18 1f 80 00       	push   $0x801f18
  8000d5:	e8 a8 05 00 00       	call   800682 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 01                	push   $0x1
  8000e2:	68 00 10 00 00       	push   $0x1000
  8000e7:	68 60 1f 80 00       	push   $0x801f60
  8000ec:	e8 90 13 00 00       	call   801481 <smalloc>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000f7:	e8 39 15 00 00       	call   801635 <sys_calculate_free_frames>
  8000fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	6a 01                	push   $0x1
  800104:	68 00 10 00 00       	push   $0x1000
  800109:	68 60 1f 80 00       	push   $0x801f60
  80010e:	e8 6e 13 00 00       	call   801481 <smalloc>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800119:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 64 1f 80 00       	push   $0x801f64
  800127:	6a 20                	push   $0x20
  800129:	68 3c 1e 80 00       	push   $0x801e3c
  80012e:	e8 9b 02 00 00       	call   8003ce <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800133:	e8 fd 14 00 00       	call   801635 <sys_calculate_free_frames>
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013d:	39 c2                	cmp    %eax,%edx
  80013f:	74 14                	je     800155 <_main+0x11d>
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	68 b8 1f 80 00       	push   $0x801fb8
  800149:	6a 21                	push   $0x21
  80014b:	68 3c 1e 80 00       	push   $0x801e3c
  800150:	e8 79 02 00 00       	call   8003ce <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 14 20 80 00       	push   $0x802014
  80015d:	e8 20 05 00 00       	call   800682 <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800165:	e8 cb 14 00 00       	call   801635 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80016d:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	6a 01                	push   $0x1
  800179:	ff 75 dc             	pushl  -0x24(%ebp)
  80017c:	68 6c 20 80 00       	push   $0x80206c
  800181:	e8 fb 12 00 00       	call   801481 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  80018c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800190:	74 14                	je     8001a6 <_main+0x16e>
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	68 70 20 80 00       	push   $0x802070
  80019a:	6a 29                	push   $0x29
  80019c:	68 3c 1e 80 00       	push   $0x801e3c
  8001a1:	e8 28 02 00 00       	call   8003ce <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001a6:	e8 8a 14 00 00       	call   801635 <sys_calculate_free_frames>
  8001ab:	89 c2                	mov    %eax,%edx
  8001ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b0:	39 c2                	cmp    %eax,%edx
  8001b2:	74 14                	je     8001c8 <_main+0x190>
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	68 e4 20 80 00       	push   $0x8020e4
  8001bc:	6a 2a                	push   $0x2a
  8001be:	68 3c 1e 80 00       	push   $0x801e3c
  8001c3:	e8 06 02 00 00       	call   8003ce <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 58 21 80 00       	push   $0x802158
  8001d0:	e8 ad 04 00 00       	call   800682 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001d8:	e8 b1 16 00 00       	call   80188e <sys_getMaxShares>
  8001dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001e7:	eb 45                	jmp    80022e <_main+0x1f6>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f3:	e8 b2 0f 00 00       	call   8011aa <ltostr>
  8001f8:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	6a 01                	push   $0x1
  800200:	6a 01                	push   $0x1
  800202:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	e8 76 12 00 00       	call   801481 <smalloc>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  800211:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800215:	75 14                	jne    80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 cc 21 80 00       	push   $0x8021cc
  80021f:	6a 36                	push   $0x36
  800221:	68 3c 1e 80 00       	push   $0x801e3c
  800226:	e8 a3 01 00 00       	call   8003ce <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  80022b:	ff 45 ec             	incl   -0x14(%ebp)
  80022e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800231:	8d 50 ff             	lea    -0x1(%eax),%edx
  800234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800237:	39 c2                	cmp    %eax,%edx
  800239:	77 ae                	ja     8001e9 <_main+0x1b1>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	6a 01                	push   $0x1
  800240:	6a 01                	push   $0x1
  800242:	68 fc 21 80 00       	push   $0x8021fc
  800247:	e8 35 12 00 00       	call   801481 <smalloc>
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != NULL) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800252:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800256:	74 14                	je     80026c <_main+0x234>
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	68 08 22 80 00       	push   $0x802208
  800260:	6a 39                	push   $0x39
  800262:	68 3c 1e 80 00       	push   $0x801e3c
  800267:	e8 62 01 00 00       	call   8003ce <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 84 22 80 00       	push   $0x802284
  800274:	e8 09 04 00 00       	call   800682 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp

	return;
  80027c:	90                   	nop
}
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800285:	e8 8b 16 00 00       	call   801915 <sys_getenvindex>
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80028d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800290:	89 d0                	mov    %edx,%eax
  800292:	01 c0                	add    %eax,%eax
  800294:	01 d0                	add    %edx,%eax
  800296:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80029d:	01 c8                	add    %ecx,%eax
  80029f:	c1 e0 02             	shl    $0x2,%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002ab:	01 c8                	add    %ecx,%eax
  8002ad:	c1 e0 02             	shl    $0x2,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 02             	shl    $0x2,%eax
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 03             	shl    $0x3,%eax
  8002ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c9:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8002cf:	84 c0                	test   %al,%al
  8002d1:	74 0f                	je     8002e2 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8002d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d8:	05 18 da 01 00       	add    $0x1da18,%eax
  8002dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e6:	7e 0a                	jle    8002f2 <libmain+0x73>
		binaryname = argv[0];
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 38 fd ff ff       	call   800038 <_main>
  800300:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800303:	e8 1a 14 00 00       	call   801722 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 22 80 00       	push   $0x8022fc
  800310:	e8 6d 03 00 00       	call   800682 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800318:	a1 20 30 80 00       	mov    0x803020,%eax
  80031d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 24 23 80 00       	push   $0x802324
  800338:	e8 45 03 00 00       	call   800682 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800340:	a1 20 30 80 00       	mov    0x803020,%eax
  800345:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80034b:	a1 20 30 80 00       	mov    0x803020,%eax
  800350:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800356:	a1 20 30 80 00       	mov    0x803020,%eax
  80035b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800361:	51                   	push   %ecx
  800362:	52                   	push   %edx
  800363:	50                   	push   %eax
  800364:	68 4c 23 80 00       	push   $0x80234c
  800369:	e8 14 03 00 00       	call   800682 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800371:	a1 20 30 80 00       	mov    0x803020,%eax
  800376:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	50                   	push   %eax
  800380:	68 a4 23 80 00       	push   $0x8023a4
  800385:	e8 f8 02 00 00       	call   800682 <cprintf>
  80038a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	68 fc 22 80 00       	push   $0x8022fc
  800395:	e8 e8 02 00 00       	call   800682 <cprintf>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80039d:	e8 9a 13 00 00       	call   80173c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003a2:	e8 19 00 00 00       	call   8003c0 <exit>
}
  8003a7:	90                   	nop
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    

008003aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	6a 00                	push   $0x0
  8003b5:	e8 27 15 00 00       	call   8018e1 <sys_destroy_env>
  8003ba:	83 c4 10             	add    $0x10,%esp
}
  8003bd:	90                   	nop
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <exit>:

void
exit(void)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003c6:	e8 7c 15 00 00       	call   801947 <sys_exit_env>
}
  8003cb:	90                   	nop
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8003d7:	83 c0 04             	add    $0x4,%eax
  8003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003dd:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	74 16                	je     8003fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003e6:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 b8 23 80 00       	push   $0x8023b8
  8003f4:	e8 89 02 00 00       	call   800682 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003fc:	a1 00 30 80 00       	mov    0x803000,%eax
  800401:	ff 75 0c             	pushl  0xc(%ebp)
  800404:	ff 75 08             	pushl  0x8(%ebp)
  800407:	50                   	push   %eax
  800408:	68 bd 23 80 00       	push   $0x8023bd
  80040d:	e8 70 02 00 00       	call   800682 <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800415:	8b 45 10             	mov    0x10(%ebp),%eax
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	50                   	push   %eax
  80041f:	e8 f3 01 00 00       	call   800617 <vcprintf>
  800424:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	6a 00                	push   $0x0
  80042c:	68 d9 23 80 00       	push   $0x8023d9
  800431:	e8 e1 01 00 00       	call   800617 <vcprintf>
  800436:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800439:	e8 82 ff ff ff       	call   8003c0 <exit>

	// should not return here
	while (1) ;
  80043e:	eb fe                	jmp    80043e <_panic+0x70>

00800440 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 50 74             	mov    0x74(%eax),%edx
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 dc 23 80 00       	push   $0x8023dc
  80045d:	6a 26                	push   $0x26
  80045f:	68 28 24 80 00       	push   $0x802428
  800464:	e8 65 ff ff ff       	call   8003ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800470:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800477:	e9 c2 00 00 00       	jmp    80053e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	85 c0                	test   %eax,%eax
  80048f:	75 08                	jne    800499 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800491:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800494:	e9 a2 00 00 00       	jmp    80053b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800499:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004a7:	eb 69                	jmp    800512 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ae:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004b7:	89 d0                	mov    %edx,%eax
  8004b9:	01 c0                	add    %eax,%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	c1 e0 03             	shl    $0x3,%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8a 40 04             	mov    0x4(%eax),%al
  8004c5:	84 c0                	test   %al,%al
  8004c7:	75 46                	jne    80050f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ce:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004d7:	89 d0                	mov    %edx,%eax
  8004d9:	01 c0                	add    %eax,%eax
  8004db:	01 d0                	add    %edx,%eax
  8004dd:	c1 e0 03             	shl    $0x3,%eax
  8004e0:	01 c8                	add    %ecx,%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	01 c8                	add    %ecx,%eax
  800500:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800502:	39 c2                	cmp    %eax,%edx
  800504:	75 09                	jne    80050f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800506:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80050d:	eb 12                	jmp    800521 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050f:	ff 45 e8             	incl   -0x18(%ebp)
  800512:	a1 20 30 80 00       	mov    0x803020,%eax
  800517:	8b 50 74             	mov    0x74(%eax),%edx
  80051a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80051d:	39 c2                	cmp    %eax,%edx
  80051f:	77 88                	ja     8004a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800525:	75 14                	jne    80053b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	68 34 24 80 00       	push   $0x802434
  80052f:	6a 3a                	push   $0x3a
  800531:	68 28 24 80 00       	push   $0x802428
  800536:	e8 93 fe ff ff       	call   8003ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80053b:	ff 45 f0             	incl   -0x10(%ebp)
  80053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800541:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800544:	0f 8c 32 ff ff ff    	jl     80047c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80054a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800551:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800558:	eb 26                	jmp    800580 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80055a:	a1 20 30 80 00       	mov    0x803020,%eax
  80055f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800565:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800568:	89 d0                	mov    %edx,%eax
  80056a:	01 c0                	add    %eax,%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	c1 e0 03             	shl    $0x3,%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8a 40 04             	mov    0x4(%eax),%al
  800576:	3c 01                	cmp    $0x1,%al
  800578:	75 03                	jne    80057d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80057a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057d:	ff 45 e0             	incl   -0x20(%ebp)
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	8b 50 74             	mov    0x74(%eax),%edx
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	39 c2                	cmp    %eax,%edx
  80058d:	77 cb                	ja     80055a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80058f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800592:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800595:	74 14                	je     8005ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800597:	83 ec 04             	sub    $0x4,%esp
  80059a:	68 88 24 80 00       	push   $0x802488
  80059f:	6a 44                	push   $0x44
  8005a1:	68 28 24 80 00       	push   $0x802428
  8005a6:	e8 23 fe ff ff       	call   8003ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005ab:	90                   	nop
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005bf:	89 0a                	mov    %ecx,(%edx)
  8005c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c4:	88 d1                	mov    %dl,%cl
  8005c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d7:	75 2c                	jne    800605 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005d9:	a0 24 30 80 00       	mov    0x803024,%al
  8005de:	0f b6 c0             	movzbl %al,%eax
  8005e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e4:	8b 12                	mov    (%edx),%edx
  8005e6:	89 d1                	mov    %edx,%ecx
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	83 c2 08             	add    $0x8,%edx
  8005ee:	83 ec 04             	sub    $0x4,%esp
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	e8 7b 0f 00 00       	call   801574 <sys_cputs>
  8005f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	8b 40 04             	mov    0x4(%eax),%eax
  80060b:	8d 50 01             	lea    0x1(%eax),%edx
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	89 50 04             	mov    %edx,0x4(%eax)
}
  800614:	90                   	nop
  800615:	c9                   	leave  
  800616:	c3                   	ret    

00800617 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800617:	55                   	push   %ebp
  800618:	89 e5                	mov    %esp,%ebp
  80061a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800620:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800627:	00 00 00 
	b.cnt = 0;
  80062a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800631:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800634:	ff 75 0c             	pushl  0xc(%ebp)
  800637:	ff 75 08             	pushl  0x8(%ebp)
  80063a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800640:	50                   	push   %eax
  800641:	68 ae 05 80 00       	push   $0x8005ae
  800646:	e8 11 02 00 00       	call   80085c <vprintfmt>
  80064b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064e:	a0 24 30 80 00       	mov    0x803024,%al
  800653:	0f b6 c0             	movzbl %al,%eax
  800656:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065c:	83 ec 04             	sub    $0x4,%esp
  80065f:	50                   	push   %eax
  800660:	52                   	push   %edx
  800661:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800667:	83 c0 08             	add    $0x8,%eax
  80066a:	50                   	push   %eax
  80066b:	e8 04 0f 00 00       	call   801574 <sys_cputs>
  800670:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800673:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80067a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <cprintf>:

int cprintf(const char *fmt, ...) {
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800688:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80068f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	ff 75 f4             	pushl  -0xc(%ebp)
  80069e:	50                   	push   %eax
  80069f:	e8 73 ff ff ff       	call   800617 <vcprintf>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    

008006af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b5:	e8 68 10 00 00       	call   801722 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	e8 48 ff ff ff       	call   800617 <vcprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d5:	e8 62 10 00 00       	call   80173c <sys_enable_interrupt>
	return cnt;
  8006da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006dd:	c9                   	leave  
  8006de:	c3                   	ret    

008006df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
  8006e2:	53                   	push   %ebx
  8006e3:	83 ec 14             	sub    $0x14,%esp
  8006e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fd:	77 55                	ja     800754 <printnum+0x75>
  8006ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800702:	72 05                	jb     800709 <printnum+0x2a>
  800704:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800707:	77 4b                	ja     800754 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800709:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80070f:	8b 45 18             	mov    0x18(%ebp),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	52                   	push   %edx
  800718:	50                   	push   %eax
  800719:	ff 75 f4             	pushl  -0xc(%ebp)
  80071c:	ff 75 f0             	pushl  -0x10(%ebp)
  80071f:	e8 84 14 00 00       	call   801ba8 <__udivdi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	ff 75 20             	pushl  0x20(%ebp)
  80072d:	53                   	push   %ebx
  80072e:	ff 75 18             	pushl  0x18(%ebp)
  800731:	52                   	push   %edx
  800732:	50                   	push   %eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	e8 a1 ff ff ff       	call   8006df <printnum>
  80073e:	83 c4 20             	add    $0x20,%esp
  800741:	eb 1a                	jmp    80075d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	ff 75 20             	pushl  0x20(%ebp)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800754:	ff 4d 1c             	decl   0x1c(%ebp)
  800757:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075b:	7f e6                	jg     800743 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800760:	bb 00 00 00 00       	mov    $0x0,%ebx
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076b:	53                   	push   %ebx
  80076c:	51                   	push   %ecx
  80076d:	52                   	push   %edx
  80076e:	50                   	push   %eax
  80076f:	e8 44 15 00 00       	call   801cb8 <__umoddi3>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	05 f4 26 80 00       	add    $0x8026f4,%eax
  80077c:	8a 00                	mov    (%eax),%al
  80077e:	0f be c0             	movsbl %al,%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	ff d0                	call   *%eax
  80078d:	83 c4 10             	add    $0x10,%esp
}
  800790:	90                   	nop
  800791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800799:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079d:	7e 1c                	jle    8007bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	8d 50 08             	lea    0x8(%eax),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 10                	mov    %edx,(%eax)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	83 e8 08             	sub    $0x8,%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	eb 40                	jmp    8007fb <getuint+0x65>
	else if (lflag)
  8007bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bf:	74 1e                	je     8007df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	8d 50 04             	lea    0x4(%eax),%edx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	89 10                	mov    %edx,(%eax)
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	eb 1c                	jmp    8007fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	8d 50 04             	lea    0x4(%eax),%edx
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	89 10                	mov    %edx,(%eax)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 e8 04             	sub    $0x4,%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800800:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800804:	7e 1c                	jle    800822 <getint+0x25>
		return va_arg(*ap, long long);
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	8d 50 08             	lea    0x8(%eax),%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	89 10                	mov    %edx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 e8 08             	sub    $0x8,%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	eb 38                	jmp    80085a <getint+0x5d>
	else if (lflag)
  800822:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800826:	74 1a                	je     800842 <getint+0x45>
		return va_arg(*ap, long);
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	8d 50 04             	lea    0x4(%eax),%edx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 10                	mov    %edx,(%eax)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	83 e8 04             	sub    $0x4,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	99                   	cltd   
  800840:	eb 18                	jmp    80085a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	8d 50 04             	lea    0x4(%eax),%edx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	89 10                	mov    %edx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	83 e8 04             	sub    $0x4,%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	99                   	cltd   
}
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	56                   	push   %esi
  800860:	53                   	push   %ebx
  800861:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800864:	eb 17                	jmp    80087d <vprintfmt+0x21>
			if (ch == '\0')
  800866:	85 db                	test   %ebx,%ebx
  800868:	0f 84 af 03 00 00    	je     800c1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	53                   	push   %ebx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087d:	8b 45 10             	mov    0x10(%ebp),%eax
  800880:	8d 50 01             	lea    0x1(%eax),%edx
  800883:	89 55 10             	mov    %edx,0x10(%ebp)
  800886:	8a 00                	mov    (%eax),%al
  800888:	0f b6 d8             	movzbl %al,%ebx
  80088b:	83 fb 25             	cmp    $0x25,%ebx
  80088e:	75 d6                	jne    800866 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800890:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800894:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b3:	8d 50 01             	lea    0x1(%eax),%edx
  8008b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b9:	8a 00                	mov    (%eax),%al
  8008bb:	0f b6 d8             	movzbl %al,%ebx
  8008be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c1:	83 f8 55             	cmp    $0x55,%eax
  8008c4:	0f 87 2b 03 00 00    	ja     800bf5 <vprintfmt+0x399>
  8008ca:	8b 04 85 18 27 80 00 	mov    0x802718(,%eax,4),%eax
  8008d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d7:	eb d7                	jmp    8008b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008dd:	eb d1                	jmp    8008b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e9:	89 d0                	mov    %edx,%eax
  8008eb:	c1 e0 02             	shl    $0x2,%eax
  8008ee:	01 d0                	add    %edx,%eax
  8008f0:	01 c0                	add    %eax,%eax
  8008f2:	01 d8                	add    %ebx,%eax
  8008f4:	83 e8 30             	sub    $0x30,%eax
  8008f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	8a 00                	mov    (%eax),%al
  8008ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800902:	83 fb 2f             	cmp    $0x2f,%ebx
  800905:	7e 3e                	jle    800945 <vprintfmt+0xe9>
  800907:	83 fb 39             	cmp    $0x39,%ebx
  80090a:	7f 39                	jg     800945 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80090f:	eb d5                	jmp    8008e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 c0 04             	add    $0x4,%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 e8 04             	sub    $0x4,%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800925:	eb 1f                	jmp    800946 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800927:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092b:	79 83                	jns    8008b0 <vprintfmt+0x54>
				width = 0;
  80092d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800934:	e9 77 ff ff ff       	jmp    8008b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800939:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800940:	e9 6b ff ff ff       	jmp    8008b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800945:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094a:	0f 89 60 ff ff ff    	jns    8008b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095d:	e9 4e ff ff ff       	jmp    8008b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800962:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800965:	e9 46 ff ff ff       	jmp    8008b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	83 e8 04             	sub    $0x4,%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	50                   	push   %eax
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			break;
  80098a:	e9 89 02 00 00       	jmp    800c18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	83 c0 04             	add    $0x4,%eax
  800995:	89 45 14             	mov    %eax,0x14(%ebp)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 e8 04             	sub    $0x4,%eax
  80099e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a0:	85 db                	test   %ebx,%ebx
  8009a2:	79 02                	jns    8009a6 <vprintfmt+0x14a>
				err = -err;
  8009a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a6:	83 fb 64             	cmp    $0x64,%ebx
  8009a9:	7f 0b                	jg     8009b6 <vprintfmt+0x15a>
  8009ab:	8b 34 9d 60 25 80 00 	mov    0x802560(,%ebx,4),%esi
  8009b2:	85 f6                	test   %esi,%esi
  8009b4:	75 19                	jne    8009cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b6:	53                   	push   %ebx
  8009b7:	68 05 27 80 00       	push   $0x802705
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	ff 75 08             	pushl  0x8(%ebp)
  8009c2:	e8 5e 02 00 00       	call   800c25 <printfmt>
  8009c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ca:	e9 49 02 00 00       	jmp    800c18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009cf:	56                   	push   %esi
  8009d0:	68 0e 27 80 00       	push   $0x80270e
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	e8 45 02 00 00       	call   800c25 <printfmt>
  8009e0:	83 c4 10             	add    $0x10,%esp
			break;
  8009e3:	e9 30 02 00 00       	jmp    800c18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	83 c0 04             	add    $0x4,%eax
  8009ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	83 e8 04             	sub    $0x4,%eax
  8009f7:	8b 30                	mov    (%eax),%esi
  8009f9:	85 f6                	test   %esi,%esi
  8009fb:	75 05                	jne    800a02 <vprintfmt+0x1a6>
				p = "(null)";
  8009fd:	be 11 27 80 00       	mov    $0x802711,%esi
			if (width > 0 && padc != '-')
  800a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a06:	7e 6d                	jle    800a75 <vprintfmt+0x219>
  800a08:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0c:	74 67                	je     800a75 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	50                   	push   %eax
  800a15:	56                   	push   %esi
  800a16:	e8 0c 03 00 00       	call   800d27 <strnlen>
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a21:	eb 16                	jmp    800a39 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a23:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a36:	ff 4d e4             	decl   -0x1c(%ebp)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	7f e4                	jg     800a23 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3f:	eb 34                	jmp    800a75 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a45:	74 1c                	je     800a63 <vprintfmt+0x207>
  800a47:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4a:	7e 05                	jle    800a51 <vprintfmt+0x1f5>
  800a4c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a4f:	7e 12                	jle    800a63 <vprintfmt+0x207>
					putch('?', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 3f                	push   $0x3f
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	eb 0f                	jmp    800a72 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	53                   	push   %ebx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a72:	ff 4d e4             	decl   -0x1c(%ebp)
  800a75:	89 f0                	mov    %esi,%eax
  800a77:	8d 70 01             	lea    0x1(%eax),%esi
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f be d8             	movsbl %al,%ebx
  800a7f:	85 db                	test   %ebx,%ebx
  800a81:	74 24                	je     800aa7 <vprintfmt+0x24b>
  800a83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a87:	78 b8                	js     800a41 <vprintfmt+0x1e5>
  800a89:	ff 4d e0             	decl   -0x20(%ebp)
  800a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a90:	79 af                	jns    800a41 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a92:	eb 13                	jmp    800aa7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	6a 20                	push   $0x20
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aab:	7f e7                	jg     800a94 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aad:	e9 66 01 00 00       	jmp    800c18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab8:	8d 45 14             	lea    0x14(%ebp),%eax
  800abb:	50                   	push   %eax
  800abc:	e8 3c fd ff ff       	call   8007fd <getint>
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad0:	85 d2                	test   %edx,%edx
  800ad2:	79 23                	jns    800af7 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad4:	83 ec 08             	sub    $0x8,%esp
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	6a 2d                	push   $0x2d
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	ff d0                	call   *%eax
  800ae1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aea:	f7 d8                	neg    %eax
  800aec:	83 d2 00             	adc    $0x0,%edx
  800aef:	f7 da                	neg    %edx
  800af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800afe:	e9 bc 00 00 00       	jmp    800bbf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 e8             	pushl  -0x18(%ebp)
  800b09:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0c:	50                   	push   %eax
  800b0d:	e8 84 fc ff ff       	call   800796 <getuint>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b22:	e9 98 00 00 00       	jmp    800bbf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	6a 58                	push   $0x58
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	6a 58                	push   $0x58
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	6a 58                	push   $0x58
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			break;
  800b57:	e9 bc 00 00 00       	jmp    800c18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 30                	push   $0x30
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 78                	push   $0x78
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	83 c0 04             	add    $0x4,%eax
  800b82:	89 45 14             	mov    %eax,0x14(%ebp)
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	83 e8 04             	sub    $0x4,%eax
  800b8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9e:	eb 1f                	jmp    800bbf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba9:	50                   	push   %eax
  800baa:	e8 e7 fb ff ff       	call   800796 <getuint>
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bbf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc6:	83 ec 04             	sub    $0x4,%esp
  800bc9:	52                   	push   %edx
  800bca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bcd:	50                   	push   %eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 00 fb ff ff       	call   8006df <printnum>
  800bdf:	83 c4 20             	add    $0x20,%esp
			break;
  800be2:	eb 34                	jmp    800c18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	53                   	push   %ebx
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	ff d0                	call   *%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
			break;
  800bf3:	eb 23                	jmp    800c18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 25                	push   $0x25
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c05:	ff 4d 10             	decl   0x10(%ebp)
  800c08:	eb 03                	jmp    800c0d <vprintfmt+0x3b1>
  800c0a:	ff 4d 10             	decl   0x10(%ebp)
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	48                   	dec    %eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	3c 25                	cmp    $0x25,%al
  800c15:	75 f3                	jne    800c0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c17:	90                   	nop
		}
	}
  800c18:	e9 47 fc ff ff       	jmp    800864 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2e:	83 c0 04             	add    $0x4,%eax
  800c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	ff 75 08             	pushl  0x8(%ebp)
  800c41:	e8 16 fc ff ff       	call   80085c <vprintfmt>
  800c46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c49:	90                   	nop
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8b 40 08             	mov    0x8(%eax),%eax
  800c55:	8d 50 01             	lea    0x1(%eax),%edx
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 10                	mov    (%eax),%edx
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8b 40 04             	mov    0x4(%eax),%eax
  800c69:	39 c2                	cmp    %eax,%edx
  800c6b:	73 12                	jae    800c7f <sprintputch+0x33>
		*b->buf++ = ch;
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	8d 48 01             	lea    0x1(%eax),%ecx
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 0a                	mov    %ecx,(%edx)
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	88 10                	mov    %dl,(%eax)
}
  800c7f:	90                   	nop
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	01 d0                	add    %edx,%eax
  800c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca7:	74 06                	je     800caf <vsnprintf+0x2d>
  800ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cad:	7f 07                	jg     800cb6 <vsnprintf+0x34>
		return -E_INVAL;
  800caf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb4:	eb 20                	jmp    800cd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb6:	ff 75 14             	pushl  0x14(%ebp)
  800cb9:	ff 75 10             	pushl  0x10(%ebp)
  800cbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cbf:	50                   	push   %eax
  800cc0:	68 4c 0c 80 00       	push   $0x800c4c
  800cc5:	e8 92 fb ff ff       	call   80085c <vprintfmt>
  800cca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cde:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ced:	50                   	push   %eax
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 89 ff ff ff       	call   800c82 <vsnprintf>
  800cf9:	83 c4 10             	add    $0x10,%esp
  800cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d11:	eb 06                	jmp    800d19 <strlen+0x15>
		n++;
  800d13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d16:	ff 45 08             	incl   0x8(%ebp)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	84 c0                	test   %al,%al
  800d20:	75 f1                	jne    800d13 <strlen+0xf>
		n++;
	return n;
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 09                	jmp    800d3f <strnlen+0x18>
		n++;
  800d36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d39:	ff 45 08             	incl   0x8(%ebp)
  800d3c:	ff 4d 0c             	decl   0xc(%ebp)
  800d3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d43:	74 09                	je     800d4e <strnlen+0x27>
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	84 c0                	test   %al,%al
  800d4c:	75 e8                	jne    800d36 <strnlen+0xf>
		n++;
	return n;
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d5f:	90                   	nop
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8d 50 01             	lea    0x1(%eax),%edx
  800d66:	89 55 08             	mov    %edx,0x8(%ebp)
  800d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d72:	8a 12                	mov    (%edx),%dl
  800d74:	88 10                	mov    %dl,(%eax)
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e4                	jne    800d60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d94:	eb 1f                	jmp    800db5 <strncpy+0x34>
		*dst++ = *src;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	8a 12                	mov    (%edx),%dl
  800da4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	74 03                	je     800db2 <strncpy+0x31>
			src++;
  800daf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db2:	ff 45 fc             	incl   -0x4(%ebp)
  800db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbb:	72 d9                	jb     800d96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd2:	74 30                	je     800e04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd4:	eb 16                	jmp    800dec <strlcpy+0x2a>
			*dst++ = *src++;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8d 50 01             	lea    0x1(%eax),%edx
  800ddc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de8:	8a 12                	mov    (%edx),%dl
  800dea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dec:	ff 4d 10             	decl   0x10(%ebp)
  800def:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df3:	74 09                	je     800dfe <strlcpy+0x3c>
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	84 c0                	test   %al,%al
  800dfc:	75 d8                	jne    800dd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0a:	29 c2                	sub    %eax,%edx
  800e0c:	89 d0                	mov    %edx,%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e13:	eb 06                	jmp    800e1b <strcmp+0xb>
		p++, q++;
  800e15:	ff 45 08             	incl   0x8(%ebp)
  800e18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	74 0e                	je     800e32 <strcmp+0x22>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 10                	mov    (%eax),%dl
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	38 c2                	cmp    %al,%dl
  800e30:	74 e3                	je     800e15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f b6 d0             	movzbl %al,%edx
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f b6 c0             	movzbl %al,%eax
  800e42:	29 c2                	sub    %eax,%edx
  800e44:	89 d0                	mov    %edx,%eax
}
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4b:	eb 09                	jmp    800e56 <strncmp+0xe>
		n--, p++, q++;
  800e4d:	ff 4d 10             	decl   0x10(%ebp)
  800e50:	ff 45 08             	incl   0x8(%ebp)
  800e53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5a:	74 17                	je     800e73 <strncmp+0x2b>
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	84 c0                	test   %al,%al
  800e63:	74 0e                	je     800e73 <strncmp+0x2b>
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 10                	mov    (%eax),%dl
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	38 c2                	cmp    %al,%dl
  800e71:	74 da                	je     800e4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e77:	75 07                	jne    800e80 <strncmp+0x38>
		return 0;
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7e:	eb 14                	jmp    800e94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	0f b6 d0             	movzbl %al,%edx
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 c0             	movzbl %al,%eax
  800e90:	29 c2                	sub    %eax,%edx
  800e92:	89 d0                	mov    %edx,%eax
}
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 04             	sub    $0x4,%esp
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea2:	eb 12                	jmp    800eb6 <strchr+0x20>
		if (*s == c)
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eac:	75 05                	jne    800eb3 <strchr+0x1d>
			return (char *) s;
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	eb 11                	jmp    800ec4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb3:	ff 45 08             	incl   0x8(%ebp)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	84 c0                	test   %al,%al
  800ebd:	75 e5                	jne    800ea4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed2:	eb 0d                	jmp    800ee1 <strfind+0x1b>
		if (*s == c)
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edc:	74 0e                	je     800eec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	84 c0                	test   %al,%al
  800ee8:	75 ea                	jne    800ed4 <strfind+0xe>
  800eea:	eb 01                	jmp    800eed <strfind+0x27>
		if (*s == c)
			break;
  800eec:	90                   	nop
	return (char *) s;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f04:	eb 0e                	jmp    800f14 <memset+0x22>
		*p++ = c;
  800f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f09:	8d 50 01             	lea    0x1(%eax),%edx
  800f0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f14:	ff 4d f8             	decl   -0x8(%ebp)
  800f17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1b:	79 e9                	jns    800f06 <memset+0x14>
		*p++ = c;

	return v;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    

00800f22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f34:	eb 16                	jmp    800f4c <memcpy+0x2a>
		*d++ = *s++;
  800f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f48:	8a 12                	mov    (%edx),%dl
  800f4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f52:	89 55 10             	mov    %edx,0x10(%ebp)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	75 dd                	jne    800f36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f76:	73 50                	jae    800fc8 <memmove+0x6a>
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f83:	76 43                	jbe    800fc8 <memmove+0x6a>
		s += n;
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f91:	eb 10                	jmp    800fa3 <memmove+0x45>
			*--d = *--s;
  800f93:	ff 4d f8             	decl   -0x8(%ebp)
  800f96:	ff 4d fc             	decl   -0x4(%ebp)
  800f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9c:	8a 10                	mov    (%eax),%dl
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	75 e3                	jne    800f93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb0:	eb 23                	jmp    800fd5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb5:	8d 50 01             	lea    0x1(%eax),%edx
  800fb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc4:	8a 12                	mov    (%edx),%dl
  800fc6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 dd                	jne    800fb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    

00800fda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fec:	eb 2a                	jmp    801018 <memcmp+0x3e>
		if (*s1 != *s2)
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff1:	8a 10                	mov    (%eax),%dl
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	38 c2                	cmp    %al,%dl
  800ffa:	74 16                	je     801012 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
  801010:	eb 18                	jmp    80102a <memcmp+0x50>
		s1++, s2++;
  801012:	ff 45 fc             	incl   -0x4(%ebp)
  801015:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	89 55 10             	mov    %edx,0x10(%ebp)
  801021:	85 c0                	test   %eax,%eax
  801023:	75 c9                	jne    800fee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103d:	eb 15                	jmp    801054 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 d0             	movzbl %al,%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	0f b6 c0             	movzbl %al,%eax
  80104d:	39 c2                	cmp    %eax,%edx
  80104f:	74 0d                	je     80105e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801051:	ff 45 08             	incl   0x8(%ebp)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105a:	72 e3                	jb     80103f <memfind+0x13>
  80105c:	eb 01                	jmp    80105f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105e:	90                   	nop
	return (void *) s;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801071:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801078:	eb 03                	jmp    80107d <strtol+0x19>
		s++;
  80107a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 20                	cmp    $0x20,%al
  801084:	74 f4                	je     80107a <strtol+0x16>
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 09                	cmp    $0x9,%al
  80108d:	74 eb                	je     80107a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 2b                	cmp    $0x2b,%al
  801096:	75 05                	jne    80109d <strtol+0x39>
		s++;
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	eb 13                	jmp    8010b0 <strtol+0x4c>
	else if (*s == '-')
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 2d                	cmp    $0x2d,%al
  8010a4:	75 0a                	jne    8010b0 <strtol+0x4c>
		s++, neg = 1;
  8010a6:	ff 45 08             	incl   0x8(%ebp)
  8010a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b4:	74 06                	je     8010bc <strtol+0x58>
  8010b6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ba:	75 20                	jne    8010dc <strtol+0x78>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 30                	cmp    $0x30,%al
  8010c3:	75 17                	jne    8010dc <strtol+0x78>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	40                   	inc    %eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 78                	cmp    $0x78,%al
  8010cd:	75 0d                	jne    8010dc <strtol+0x78>
		s += 2, base = 16;
  8010cf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010da:	eb 28                	jmp    801104 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e0:	75 15                	jne    8010f7 <strtol+0x93>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 0c                	jne    8010f7 <strtol+0x93>
		s++, base = 8;
  8010eb:	ff 45 08             	incl   0x8(%ebp)
  8010ee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f5:	eb 0d                	jmp    801104 <strtol+0xa0>
	else if (base == 0)
  8010f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fb:	75 07                	jne    801104 <strtol+0xa0>
		base = 10;
  8010fd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 2f                	cmp    $0x2f,%al
  80110b:	7e 19                	jle    801126 <strtol+0xc2>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 39                	cmp    $0x39,%al
  801114:	7f 10                	jg     801126 <strtol+0xc2>
			dig = *s - '0';
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	83 e8 30             	sub    $0x30,%eax
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801124:	eb 42                	jmp    801168 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 60                	cmp    $0x60,%al
  80112d:	7e 19                	jle    801148 <strtol+0xe4>
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	3c 7a                	cmp    $0x7a,%al
  801136:	7f 10                	jg     801148 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	0f be c0             	movsbl %al,%eax
  801140:	83 e8 57             	sub    $0x57,%eax
  801143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801146:	eb 20                	jmp    801168 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 40                	cmp    $0x40,%al
  80114f:	7e 39                	jle    80118a <strtol+0x126>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 5a                	cmp    $0x5a,%al
  801158:	7f 30                	jg     80118a <strtol+0x126>
			dig = *s - 'A' + 10;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 37             	sub    $0x37,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116e:	7d 19                	jge    801189 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801170:	ff 45 08             	incl   0x8(%ebp)
  801173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801176:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801184:	e9 7b ff ff ff       	jmp    801104 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801189:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118e:	74 08                	je     801198 <strtol+0x134>
		*endptr = (char *) s;
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 07                	je     8011a5 <strtol+0x141>
  80119e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a1:	f7 d8                	neg    %eax
  8011a3:	eb 03                	jmp    8011a8 <strtol+0x144>
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <ltostr>:

void
ltostr(long value, char *str)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	79 13                	jns    8011d7 <ltostr+0x2d>
	{
		neg = 1;
  8011c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011df:	99                   	cltd   
  8011e0:	f7 f9                	idiv   %ecx
  8011e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ee:	89 c2                	mov    %eax,%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 d0                	add    %edx,%eax
  8011f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f8:	83 c2 30             	add    $0x30,%edx
  8011fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801200:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801205:	f7 e9                	imul   %ecx
  801207:	c1 fa 02             	sar    $0x2,%edx
  80120a:	89 c8                	mov    %ecx,%eax
  80120c:	c1 f8 1f             	sar    $0x1f,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
  801213:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801216:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801219:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121e:	f7 e9                	imul   %ecx
  801220:	c1 fa 02             	sar    $0x2,%edx
  801223:	89 c8                	mov    %ecx,%eax
  801225:	c1 f8 1f             	sar    $0x1f,%eax
  801228:	29 c2                	sub    %eax,%edx
  80122a:	89 d0                	mov    %edx,%eax
  80122c:	c1 e0 02             	shl    $0x2,%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	01 c0                	add    %eax,%eax
  801233:	29 c1                	sub    %eax,%ecx
  801235:	89 ca                	mov    %ecx,%edx
  801237:	85 d2                	test   %edx,%edx
  801239:	75 9c                	jne    8011d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801242:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801245:	48                   	dec    %eax
  801246:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801249:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124d:	74 3d                	je     80128c <ltostr+0xe2>
		start = 1 ;
  80124f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801256:	eb 34                	jmp    80128c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126b:	01 c2                	add    %eax,%edx
  80126d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	01 c8                	add    %ecx,%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	01 c2                	add    %eax,%edx
  801281:	8a 45 eb             	mov    -0x15(%ebp),%al
  801284:	88 02                	mov    %al,(%edx)
		start++ ;
  801286:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801289:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801292:	7c c4                	jl     801258 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801294:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a8:	ff 75 08             	pushl  0x8(%ebp)
  8012ab:	e8 54 fa ff ff       	call   800d04 <strlen>
  8012b0:	83 c4 04             	add    $0x4,%esp
  8012b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b6:	ff 75 0c             	pushl  0xc(%ebp)
  8012b9:	e8 46 fa ff ff       	call   800d04 <strlen>
  8012be:	83 c4 04             	add    $0x4,%esp
  8012c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 17                	jmp    8012eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	01 c2                	add    %eax,%edx
  8012dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	01 c8                	add    %ecx,%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e8:	ff 45 fc             	incl   -0x4(%ebp)
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f1:	7c e1                	jl     8012d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801301:	eb 1f                	jmp    801322 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801303:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130c:	89 c2                	mov    %eax,%edx
  80130e:	8b 45 10             	mov    0x10(%ebp),%eax
  801311:	01 c2                	add    %eax,%edx
  801313:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 c8                	add    %ecx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80131f:	ff 45 f8             	incl   -0x8(%ebp)
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801325:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801328:	7c d9                	jl     801303 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 d0                	add    %edx,%eax
  801332:	c6 00 00             	movb   $0x0,(%eax)
}
  801335:	90                   	nop
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133b:	8b 45 14             	mov    0x14(%ebp),%eax
  80133e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135b:	eb 0c                	jmp    801369 <strsplit+0x31>
			*string++ = 0;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8d 50 01             	lea    0x1(%eax),%edx
  801363:	89 55 08             	mov    %edx,0x8(%ebp)
  801366:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	84 c0                	test   %al,%al
  801370:	74 18                	je     80138a <strsplit+0x52>
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	0f be c0             	movsbl %al,%eax
  80137a:	50                   	push   %eax
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	e8 13 fb ff ff       	call   800e96 <strchr>
  801383:	83 c4 08             	add    $0x8,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	75 d3                	jne    80135d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	84 c0                	test   %al,%al
  801391:	74 5a                	je     8013ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801393:	8b 45 14             	mov    0x14(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	83 f8 0f             	cmp    $0xf,%eax
  80139b:	75 07                	jne    8013a4 <strsplit+0x6c>
		{
			return 0;
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a2:	eb 66                	jmp    80140a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8013af:	89 0a                	mov    %ecx,(%edx)
  8013b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	01 c2                	add    %eax,%edx
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c2:	eb 03                	jmp    8013c7 <strsplit+0x8f>
			string++;
  8013c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	84 c0                	test   %al,%al
  8013ce:	74 8b                	je     80135b <strsplit+0x23>
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	0f be c0             	movsbl %al,%eax
  8013d8:	50                   	push   %eax
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	e8 b5 fa ff ff       	call   800e96 <strchr>
  8013e1:	83 c4 08             	add    $0x8,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	74 dc                	je     8013c4 <strsplit+0x8c>
			string++;
	}
  8013e8:	e9 6e ff ff ff       	jmp    80135b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801405:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	68 70 28 80 00       	push   $0x802870
  80141a:	6a 0e                	push   $0xe
  80141c:	68 aa 28 80 00       	push   $0x8028aa
  801421:	e8 a8 ef ff ff       	call   8003ce <_panic>

00801426 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80142c:	a1 04 30 80 00       	mov    0x803004,%eax
  801431:	85 c0                	test   %eax,%eax
  801433:	74 0f                	je     801444 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801435:	e8 d2 ff ff ff       	call   80140c <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80143a:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801441:	00 00 00 
	}
	if (size == 0) return NULL ;
  801444:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801448:	75 07                	jne    801451 <malloc+0x2b>
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
  80144f:	eb 14                	jmp    801465 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	68 b8 28 80 00       	push   $0x8028b8
  801459:	6a 2e                	push   $0x2e
  80145b:	68 aa 28 80 00       	push   $0x8028aa
  801460:	e8 69 ef ff ff       	call   8003ce <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	68 e0 28 80 00       	push   $0x8028e0
  801475:	6a 49                	push   $0x49
  801477:	68 aa 28 80 00       	push   $0x8028aa
  80147c:	e8 4d ef ff ff       	call   8003ce <_panic>

00801481 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 18             	sub    $0x18,%esp
  801487:	8b 45 10             	mov    0x10(%ebp),%eax
  80148a:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 04 29 80 00       	push   $0x802904
  801495:	6a 57                	push   $0x57
  801497:	68 aa 28 80 00       	push   $0x8028aa
  80149c:	e8 2d ef ff ff       	call   8003ce <_panic>

008014a1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	68 2c 29 80 00       	push   $0x80292c
  8014af:	6a 60                	push   $0x60
  8014b1:	68 aa 28 80 00       	push   $0x8028aa
  8014b6:	e8 13 ef ff ff       	call   8003ce <_panic>

008014bb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	68 50 29 80 00       	push   $0x802950
  8014c9:	6a 7c                	push   $0x7c
  8014cb:	68 aa 28 80 00       	push   $0x8028aa
  8014d0:	e8 f9 ee ff ff       	call   8003ce <_panic>

008014d5 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	68 78 29 80 00       	push   $0x802978
  8014e3:	68 86 00 00 00       	push   $0x86
  8014e8:	68 aa 28 80 00       	push   $0x8028aa
  8014ed:	e8 dc ee ff ff       	call   8003ce <_panic>

008014f2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	68 9c 29 80 00       	push   $0x80299c
  801500:	68 91 00 00 00       	push   $0x91
  801505:	68 aa 28 80 00       	push   $0x8028aa
  80150a:	e8 bf ee ff ff       	call   8003ce <_panic>

0080150f <shrink>:

}
void shrink(uint32 newSize)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	68 9c 29 80 00       	push   $0x80299c
  80151d:	68 96 00 00 00       	push   $0x96
  801522:	68 aa 28 80 00       	push   $0x8028aa
  801527:	e8 a2 ee ff ff       	call   8003ce <_panic>

0080152c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 9c 29 80 00       	push   $0x80299c
  80153a:	68 9b 00 00 00       	push   $0x9b
  80153f:	68 aa 28 80 00       	push   $0x8028aa
  801544:	e8 85 ee ff ff       	call   8003ce <_panic>

00801549 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	57                   	push   %edi
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8b 55 0c             	mov    0xc(%ebp),%edx
  801558:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801561:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801564:	cd 30                	int    $0x30
  801566:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5f                   	pop    %edi
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	8b 45 10             	mov    0x10(%ebp),%eax
  80157d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801580:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	52                   	push   %edx
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	50                   	push   %eax
  801590:	6a 00                	push   $0x0
  801592:	e8 b2 ff ff ff       	call   801549 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	90                   	nop
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_cgetc>:

int
sys_cgetc(void)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 01                	push   $0x1
  8015ac:	e8 98 ff ff ff       	call   801549 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	52                   	push   %edx
  8015c6:	50                   	push   %eax
  8015c7:	6a 05                	push   $0x5
  8015c9:	e8 7b ff ff ff       	call   801549 <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	56                   	push   %esi
  8015d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8015db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	51                   	push   %ecx
  8015ea:	52                   	push   %edx
  8015eb:	50                   	push   %eax
  8015ec:	6a 06                	push   $0x6
  8015ee:	e8 56 ff ff ff       	call   801549 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	52                   	push   %edx
  80160d:	50                   	push   %eax
  80160e:	6a 07                	push   $0x7
  801610:	e8 34 ff ff ff       	call   801549 <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	ff 75 0c             	pushl  0xc(%ebp)
  801626:	ff 75 08             	pushl  0x8(%ebp)
  801629:	6a 08                	push   $0x8
  80162b:	e8 19 ff ff ff       	call   801549 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 09                	push   $0x9
  801644:	e8 00 ff ff ff       	call   801549 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 0a                	push   $0xa
  80165d:	e8 e7 fe ff ff       	call   801549 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 0b                	push   $0xb
  801676:	e8 ce fe ff ff       	call   801549 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	6a 0f                	push   $0xf
  801691:	e8 b3 fe ff ff       	call   801549 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
	return;
  801699:	90                   	nop
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	ff 75 08             	pushl  0x8(%ebp)
  8016ab:	6a 10                	push   $0x10
  8016ad:	e8 97 fe ff ff       	call   801549 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b5:	90                   	nop
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 10             	pushl  0x10(%ebp)
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	6a 11                	push   $0x11
  8016ca:	e8 7a fe ff ff       	call   801549 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 0c                	push   $0xc
  8016e4:	e8 60 fe ff ff       	call   801549 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 0d                	push   $0xd
  8016fe:	e8 46 fe ff ff       	call   801549 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 0e                	push   $0xe
  801717:	e8 2d fe ff ff       	call   801549 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 13                	push   $0x13
  801731:	e8 13 fe ff ff       	call   801549 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 14                	push   $0x14
  80174b:	e8 f9 fd ff ff       	call   801549 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	90                   	nop
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_cputc>:


void
sys_cputc(const char c)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801762:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	50                   	push   %eax
  80176f:	6a 15                	push   $0x15
  801771:	e8 d3 fd ff ff       	call   801549 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 16                	push   $0x16
  80178b:	e8 b9 fd ff ff       	call   801549 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	50                   	push   %eax
  8017a6:	6a 17                	push   $0x17
  8017a8:	e8 9c fd ff ff       	call   801549 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	6a 1a                	push   $0x1a
  8017c5:	e8 7f fd ff ff       	call   801549 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	6a 18                	push   $0x18
  8017e2:	e8 62 fd ff ff       	call   801549 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	90                   	nop
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 19                	push   $0x19
  801800:	e8 44 fd ff ff       	call   801549 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	90                   	nop
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	8b 45 10             	mov    0x10(%ebp),%eax
  801814:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801817:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	51                   	push   %ecx
  801824:	52                   	push   %edx
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	50                   	push   %eax
  801829:	6a 1b                	push   $0x1b
  80182b:	e8 19 fd ff ff       	call   801549 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	6a 1c                	push   $0x1c
  801848:	e8 fc fc ff ff       	call   801549 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801855:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	51                   	push   %ecx
  801863:	52                   	push   %edx
  801864:	50                   	push   %eax
  801865:	6a 1d                	push   $0x1d
  801867:	e8 dd fc ff ff       	call   801549 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801874:	8b 55 0c             	mov    0xc(%ebp),%edx
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 1e                	push   $0x1e
  801884:	e8 c0 fc ff ff       	call   801549 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 1f                	push   $0x1f
  80189d:	e8 a7 fc ff ff       	call   801549 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 14             	pushl  0x14(%ebp)
  8018b2:	ff 75 10             	pushl  0x10(%ebp)
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	50                   	push   %eax
  8018b9:	6a 20                	push   $0x20
  8018bb:	e8 89 fc ff ff       	call   801549 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	50                   	push   %eax
  8018d4:	6a 21                	push   $0x21
  8018d6:	e8 6e fc ff ff       	call   801549 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	90                   	nop
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	50                   	push   %eax
  8018f0:	6a 22                	push   $0x22
  8018f2:	e8 52 fc ff ff       	call   801549 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 02                	push   $0x2
  80190b:	e8 39 fc ff ff       	call   801549 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 03                	push   $0x3
  801924:	e8 20 fc ff ff       	call   801549 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 04                	push   $0x4
  80193d:	e8 07 fc ff ff       	call   801549 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_exit_env>:


void sys_exit_env(void)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 23                	push   $0x23
  801956:	e8 ee fb ff ff       	call   801549 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801967:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196a:	8d 50 04             	lea    0x4(%eax),%edx
  80196d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 24                	push   $0x24
  80197a:	e8 ca fb ff ff       	call   801549 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return result;
  801982:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801985:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801988:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198b:	89 01                	mov    %eax,(%ecx)
  80198d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	c9                   	leave  
  801994:	c2 04 00             	ret    $0x4

00801997 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 10             	pushl  0x10(%ebp)
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 12                	push   $0x12
  8019a9:	e8 9b fb ff ff       	call   801549 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 25                	push   $0x25
  8019c3:	e8 81 fb ff ff       	call   801549 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	50                   	push   %eax
  8019e6:	6a 26                	push   $0x26
  8019e8:	e8 5c fb ff ff       	call   801549 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <rsttst>:
void rsttst()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 28                	push   $0x28
  801a02:	e8 42 fb ff ff       	call   801549 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	8b 45 14             	mov    0x14(%ebp),%eax
  801a16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a19:	8b 55 18             	mov    0x18(%ebp),%edx
  801a1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a20:	52                   	push   %edx
  801a21:	50                   	push   %eax
  801a22:	ff 75 10             	pushl  0x10(%ebp)
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	6a 27                	push   $0x27
  801a2d:	e8 17 fb ff ff       	call   801549 <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
	return ;
  801a35:	90                   	nop
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <chktst>:
void chktst(uint32 n)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	6a 29                	push   $0x29
  801a48:	e8 fc fa ff ff       	call   801549 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a50:	90                   	nop
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <inctst>:

void inctst()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 2a                	push   $0x2a
  801a62:	e8 e2 fa ff ff       	call   801549 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <gettst>:
uint32 gettst()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 2b                	push   $0x2b
  801a7c:	e8 c8 fa ff ff       	call   801549 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801a98:	e8 ac fa ff ff       	call   801549 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
  801aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801aa3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa7:	75 07                	jne    801ab0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aae:	eb 05                	jmp    801ab5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 2c                	push   $0x2c
  801ac9:	e8 7b fa ff ff       	call   801549 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
  801ad1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ad4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ad8:	75 07                	jne    801ae1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
  801adf:	eb 05                	jmp    801ae6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 2c                	push   $0x2c
  801afa:	e8 4a fa ff ff       	call   801549 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
  801b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b05:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b09:	75 07                	jne    801b12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b10:	eb 05                	jmp    801b17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 2c                	push   $0x2c
  801b2b:	e8 19 fa ff ff       	call   801549 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
  801b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b36:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b3a:	75 07                	jne    801b43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b41:	eb 05                	jmp    801b48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 08             	pushl  0x8(%ebp)
  801b58:	6a 2d                	push   $0x2d
  801b5a:	e8 ea f9 ff ff       	call   801549 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	53                   	push   %ebx
  801b78:	51                   	push   %ecx
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 2e                	push   $0x2e
  801b7d:	e8 c7 f9 ff ff       	call   801549 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 2f                	push   $0x2f
  801b9d:	e8 a7 f9 ff ff       	call   801549 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
  801ba7:	90                   	nop

00801ba8 <__udivdi3>:
  801ba8:	55                   	push   %ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 1c             	sub    $0x1c,%esp
  801baf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbf:	89 ca                	mov    %ecx,%edx
  801bc1:	89 f8                	mov    %edi,%eax
  801bc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bc7:	85 f6                	test   %esi,%esi
  801bc9:	75 2d                	jne    801bf8 <__udivdi3+0x50>
  801bcb:	39 cf                	cmp    %ecx,%edi
  801bcd:	77 65                	ja     801c34 <__udivdi3+0x8c>
  801bcf:	89 fd                	mov    %edi,%ebp
  801bd1:	85 ff                	test   %edi,%edi
  801bd3:	75 0b                	jne    801be0 <__udivdi3+0x38>
  801bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bda:	31 d2                	xor    %edx,%edx
  801bdc:	f7 f7                	div    %edi
  801bde:	89 c5                	mov    %eax,%ebp
  801be0:	31 d2                	xor    %edx,%edx
  801be2:	89 c8                	mov    %ecx,%eax
  801be4:	f7 f5                	div    %ebp
  801be6:	89 c1                	mov    %eax,%ecx
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	f7 f5                	div    %ebp
  801bec:	89 cf                	mov    %ecx,%edi
  801bee:	89 fa                	mov    %edi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	39 ce                	cmp    %ecx,%esi
  801bfa:	77 28                	ja     801c24 <__udivdi3+0x7c>
  801bfc:	0f bd fe             	bsr    %esi,%edi
  801bff:	83 f7 1f             	xor    $0x1f,%edi
  801c02:	75 40                	jne    801c44 <__udivdi3+0x9c>
  801c04:	39 ce                	cmp    %ecx,%esi
  801c06:	72 0a                	jb     801c12 <__udivdi3+0x6a>
  801c08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c0c:	0f 87 9e 00 00 00    	ja     801cb0 <__udivdi3+0x108>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	89 fa                	mov    %edi,%edx
  801c19:	83 c4 1c             	add    $0x1c,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5f                   	pop    %edi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    
  801c21:	8d 76 00             	lea    0x0(%esi),%esi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	31 c0                	xor    %eax,%eax
  801c28:	89 fa                	mov    %edi,%edx
  801c2a:	83 c4 1c             	add    $0x1c,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	89 d8                	mov    %ebx,%eax
  801c36:	f7 f7                	div    %edi
  801c38:	31 ff                	xor    %edi,%edi
  801c3a:	89 fa                	mov    %edi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c49:	89 eb                	mov    %ebp,%ebx
  801c4b:	29 fb                	sub    %edi,%ebx
  801c4d:	89 f9                	mov    %edi,%ecx
  801c4f:	d3 e6                	shl    %cl,%esi
  801c51:	89 c5                	mov    %eax,%ebp
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ed                	shr    %cl,%ebp
  801c57:	89 e9                	mov    %ebp,%ecx
  801c59:	09 f1                	or     %esi,%ecx
  801c5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c5f:	89 f9                	mov    %edi,%ecx
  801c61:	d3 e0                	shl    %cl,%eax
  801c63:	89 c5                	mov    %eax,%ebp
  801c65:	89 d6                	mov    %edx,%esi
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 ee                	shr    %cl,%esi
  801c6b:	89 f9                	mov    %edi,%ecx
  801c6d:	d3 e2                	shl    %cl,%edx
  801c6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c73:	88 d9                	mov    %bl,%cl
  801c75:	d3 e8                	shr    %cl,%eax
  801c77:	09 c2                	or     %eax,%edx
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	89 f2                	mov    %esi,%edx
  801c7d:	f7 74 24 0c          	divl   0xc(%esp)
  801c81:	89 d6                	mov    %edx,%esi
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	f7 e5                	mul    %ebp
  801c87:	39 d6                	cmp    %edx,%esi
  801c89:	72 19                	jb     801ca4 <__udivdi3+0xfc>
  801c8b:	74 0b                	je     801c98 <__udivdi3+0xf0>
  801c8d:	89 d8                	mov    %ebx,%eax
  801c8f:	31 ff                	xor    %edi,%edi
  801c91:	e9 58 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c9c:	89 f9                	mov    %edi,%ecx
  801c9e:	d3 e2                	shl    %cl,%edx
  801ca0:	39 c2                	cmp    %eax,%edx
  801ca2:	73 e9                	jae    801c8d <__udivdi3+0xe5>
  801ca4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca7:	31 ff                	xor    %edi,%edi
  801ca9:	e9 40 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	31 c0                	xor    %eax,%eax
  801cb2:	e9 37 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cb7:	90                   	nop

00801cb8 <__umoddi3>:
  801cb8:	55                   	push   %ebp
  801cb9:	57                   	push   %edi
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
  801cbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ccb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd7:	89 f3                	mov    %esi,%ebx
  801cd9:	89 fa                	mov    %edi,%edx
  801cdb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cdf:	89 34 24             	mov    %esi,(%esp)
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	75 1a                	jne    801d00 <__umoddi3+0x48>
  801ce6:	39 f7                	cmp    %esi,%edi
  801ce8:	0f 86 a2 00 00 00    	jbe    801d90 <__umoddi3+0xd8>
  801cee:	89 c8                	mov    %ecx,%eax
  801cf0:	89 f2                	mov    %esi,%edx
  801cf2:	f7 f7                	div    %edi
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	31 d2                	xor    %edx,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	39 f0                	cmp    %esi,%eax
  801d02:	0f 87 ac 00 00 00    	ja     801db4 <__umoddi3+0xfc>
  801d08:	0f bd e8             	bsr    %eax,%ebp
  801d0b:	83 f5 1f             	xor    $0x1f,%ebp
  801d0e:	0f 84 ac 00 00 00    	je     801dc0 <__umoddi3+0x108>
  801d14:	bf 20 00 00 00       	mov    $0x20,%edi
  801d19:	29 ef                	sub    %ebp,%edi
  801d1b:	89 fe                	mov    %edi,%esi
  801d1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d21:	89 e9                	mov    %ebp,%ecx
  801d23:	d3 e0                	shl    %cl,%eax
  801d25:	89 d7                	mov    %edx,%edi
  801d27:	89 f1                	mov    %esi,%ecx
  801d29:	d3 ef                	shr    %cl,%edi
  801d2b:	09 c7                	or     %eax,%edi
  801d2d:	89 e9                	mov    %ebp,%ecx
  801d2f:	d3 e2                	shl    %cl,%edx
  801d31:	89 14 24             	mov    %edx,(%esp)
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	d3 e0                	shl    %cl,%eax
  801d38:	89 c2                	mov    %eax,%edx
  801d3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3e:	d3 e0                	shl    %cl,%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d48:	89 f1                	mov    %esi,%ecx
  801d4a:	d3 e8                	shr    %cl,%eax
  801d4c:	09 d0                	or     %edx,%eax
  801d4e:	d3 eb                	shr    %cl,%ebx
  801d50:	89 da                	mov    %ebx,%edx
  801d52:	f7 f7                	div    %edi
  801d54:	89 d3                	mov    %edx,%ebx
  801d56:	f7 24 24             	mull   (%esp)
  801d59:	89 c6                	mov    %eax,%esi
  801d5b:	89 d1                	mov    %edx,%ecx
  801d5d:	39 d3                	cmp    %edx,%ebx
  801d5f:	0f 82 87 00 00 00    	jb     801dec <__umoddi3+0x134>
  801d65:	0f 84 91 00 00 00    	je     801dfc <__umoddi3+0x144>
  801d6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d6f:	29 f2                	sub    %esi,%edx
  801d71:	19 cb                	sbb    %ecx,%ebx
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d79:	d3 e0                	shl    %cl,%eax
  801d7b:	89 e9                	mov    %ebp,%ecx
  801d7d:	d3 ea                	shr    %cl,%edx
  801d7f:	09 d0                	or     %edx,%eax
  801d81:	89 e9                	mov    %ebp,%ecx
  801d83:	d3 eb                	shr    %cl,%ebx
  801d85:	89 da                	mov    %ebx,%edx
  801d87:	83 c4 1c             	add    $0x1c,%esp
  801d8a:	5b                   	pop    %ebx
  801d8b:	5e                   	pop    %esi
  801d8c:	5f                   	pop    %edi
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    
  801d8f:	90                   	nop
  801d90:	89 fd                	mov    %edi,%ebp
  801d92:	85 ff                	test   %edi,%edi
  801d94:	75 0b                	jne    801da1 <__umoddi3+0xe9>
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f7                	div    %edi
  801d9f:	89 c5                	mov    %eax,%ebp
  801da1:	89 f0                	mov    %esi,%eax
  801da3:	31 d2                	xor    %edx,%edx
  801da5:	f7 f5                	div    %ebp
  801da7:	89 c8                	mov    %ecx,%eax
  801da9:	f7 f5                	div    %ebp
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	e9 44 ff ff ff       	jmp    801cf6 <__umoddi3+0x3e>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	89 c8                	mov    %ecx,%eax
  801db6:	89 f2                	mov    %esi,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	3b 04 24             	cmp    (%esp),%eax
  801dc3:	72 06                	jb     801dcb <__umoddi3+0x113>
  801dc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc9:	77 0f                	ja     801dda <__umoddi3+0x122>
  801dcb:	89 f2                	mov    %esi,%edx
  801dcd:	29 f9                	sub    %edi,%ecx
  801dcf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dd3:	89 14 24             	mov    %edx,(%esp)
  801dd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dda:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dde:	8b 14 24             	mov    (%esp),%edx
  801de1:	83 c4 1c             	add    $0x1c,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
  801de9:	8d 76 00             	lea    0x0(%esi),%esi
  801dec:	2b 04 24             	sub    (%esp),%eax
  801def:	19 fa                	sbb    %edi,%edx
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	89 c6                	mov    %eax,%esi
  801df5:	e9 71 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e00:	72 ea                	jb     801dec <__umoddi3+0x134>
  801e02:	89 d9                	mov    %ebx,%ecx
  801e04:	e9 62 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
