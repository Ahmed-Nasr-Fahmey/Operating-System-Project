
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 f3 01 00 00       	call   800229 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 65 13 00 00       	call   8013d0 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 54 13 00 00       	call   8013d0 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 f8 15 00 00       	call   80167f <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000a8:	c1 e0 03             	shl    $0x3,%eax
  8000ab:	89 c2                	mov    %eax,%edx
  8000ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	89 d0                	mov    %edx,%eax
  8000ba:	01 c0                	add    %eax,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	c1 e0 02             	shl    $0x2,%eax
  8000c1:	89 c2                	mov    %eax,%edx
  8000c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000c6:	01 d0                	add    %edx,%eax
  8000c8:	c6 00 ff             	movb   $0xff,(%eax)

		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;

		free(x);
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 cc             	pushl  -0x34(%ebp)
  8000d1:	e8 3b 13 00 00       	call   801411 <free>
  8000d6:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 c8             	pushl  -0x38(%ebp)
  8000df:	e8 2d 13 00 00       	call   801411 <free>
  8000e4:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  8000e7:	e8 f3 14 00 00       	call   8015df <sys_calculate_free_frames>
  8000ec:	89 45 c0             	mov    %eax,-0x40(%ebp)

		x = malloc(sizeof(char)*size) ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8000f5:	e8 d6 12 00 00       	call   8013d0 <malloc>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 cc             	mov    %eax,-0x34(%ebp)

		x[1]=-2;
  800100:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800103:	40                   	inc    %eax
  800104:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  800107:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80011b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011e:	c1 e0 03             	shl    $0x3,%eax
  800121:	89 c2                	mov    %eax,%edx
  800123:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[12*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	01 c0                	add    %eax,%eax
  800132:	01 d0                	add    %edx,%eax
  800134:	c1 e0 02             	shl    $0x2,%eax
  800137:	89 c2                	mov    %eax,%edx
  800139:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 fe             	movb   $0xfe,(%eax)

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};
  800141:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800144:	bb 80 1e 80 00       	mov    $0x801e80,%ebx
  800149:	ba 08 00 00 00       	mov    $0x8,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	89 de                	mov    %ebx,%esi
  800152:	89 d1                	mov    %edx,%ecx
  800154:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800156:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < (myEnv->page_WS_max_size); i++)
  80015d:	eb 79                	jmp    8001d8 <_main+0x1a0>
		{
			int found = 0 ;
  80015f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800166:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80016d:	eb 3d                	jmp    8001ac <_main+0x174>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80016f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800172:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8b 98 58 da 01 00    	mov    0x1da58(%eax),%ebx
  800181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800184:	89 d0                	mov    %edx,%eax
  800186:	01 c0                	add    %eax,%eax
  800188:	01 d0                	add    %edx,%eax
  80018a:	c1 e0 03             	shl    $0x3,%eax
  80018d:	01 d8                	add    %ebx,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800194:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	39 c1                	cmp    %eax,%ecx
  80019e:	75 09                	jne    8001a9 <_main+0x171>
				{
					found = 1 ;
  8001a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001a7:	eb 12                	jmp    8001bb <_main+0x183>

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)
  8001ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b1:	8b 50 74             	mov    0x74(%eax),%edx
  8001b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b7:	39 c2                	cmp    %eax,%edx
  8001b9:	77 b4                	ja     80016f <_main+0x137>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001bf:	75 14                	jne    8001d5 <_main+0x19d>
				panic("PAGE Placement algorithm failed after applying freeHeap");
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 c0 1d 80 00       	push   $0x801dc0
  8001c9:	6a 41                	push   $0x41
  8001cb:	68 f8 1d 80 00       	push   $0x801df8
  8001d0:	e8 a3 01 00 00       	call   800378 <_panic>
		x[12*Mega]=-2;

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
  8001d5:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 50 74             	mov    0x74(%eax),%edx
  8001e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e3:	39 c2                	cmp    %eax,%edx
  8001e5:	0f 87 74 ff ff ff    	ja     80015f <_main+0x127>
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap");
		}


		if( (freePages - sys_calculate_free_frames() ) != 8 ) panic("Extra/Less memory are wrongly allocated");
  8001eb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8001ee:	e8 ec 13 00 00       	call   8015df <sys_calculate_free_frames>
  8001f3:	29 c3                	sub    %eax,%ebx
  8001f5:	89 d8                	mov    %ebx,%eax
  8001f7:	83 f8 08             	cmp    $0x8,%eax
  8001fa:	74 14                	je     800210 <_main+0x1d8>
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	68 0c 1e 80 00       	push   $0x801e0c
  800204:	6a 45                	push   $0x45
  800206:	68 f8 1d 80 00       	push   $0x801df8
  80020b:	e8 68 01 00 00       	call   800378 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 34 1e 80 00       	push   $0x801e34
  800218:	e8 0f 04 00 00       	call   80062c <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp


	return;
  800220:	90                   	nop
}
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    

00800229 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80022f:	e8 8b 16 00 00       	call   8018bf <sys_getenvindex>
  800234:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023a:	89 d0                	mov    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	01 d0                	add    %edx,%eax
  800240:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800247:	01 c8                	add    %ecx,%eax
  800249:	c1 e0 02             	shl    $0x2,%eax
  80024c:	01 d0                	add    %edx,%eax
  80024e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800255:	01 c8                	add    %ecx,%eax
  800257:	c1 e0 02             	shl    $0x2,%eax
  80025a:	01 d0                	add    %edx,%eax
  80025c:	c1 e0 02             	shl    $0x2,%eax
  80025f:	01 d0                	add    %edx,%eax
  800261:	c1 e0 03             	shl    $0x3,%eax
  800264:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800269:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80026e:	a1 20 30 80 00       	mov    0x803020,%eax
  800273:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800279:	84 c0                	test   %al,%al
  80027b:	74 0f                	je     80028c <libmain+0x63>
		binaryname = myEnv->prog_name;
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	05 18 da 01 00       	add    $0x1da18,%eax
  800287:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800290:	7e 0a                	jle    80029c <libmain+0x73>
		binaryname = argv[0];
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
  800295:	8b 00                	mov    (%eax),%eax
  800297:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	ff 75 0c             	pushl  0xc(%ebp)
  8002a2:	ff 75 08             	pushl  0x8(%ebp)
  8002a5:	e8 8e fd ff ff       	call   800038 <_main>
  8002aa:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002ad:	e8 1a 14 00 00       	call   8016cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	68 b8 1e 80 00       	push   $0x801eb8
  8002ba:	e8 6d 03 00 00       	call   80062c <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c7:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8002cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d2:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	52                   	push   %edx
  8002dc:	50                   	push   %eax
  8002dd:	68 e0 1e 80 00       	push   $0x801ee0
  8002e2:	e8 45 03 00 00       	call   80062c <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ef:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8002f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fa:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800300:	a1 20 30 80 00       	mov    0x803020,%eax
  800305:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80030b:	51                   	push   %ecx
  80030c:	52                   	push   %edx
  80030d:	50                   	push   %eax
  80030e:	68 08 1f 80 00       	push   $0x801f08
  800313:	e8 14 03 00 00       	call   80062c <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80031b:	a1 20 30 80 00       	mov    0x803020,%eax
  800320:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	50                   	push   %eax
  80032a:	68 60 1f 80 00       	push   $0x801f60
  80032f:	e8 f8 02 00 00       	call   80062c <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	68 b8 1e 80 00       	push   $0x801eb8
  80033f:	e8 e8 02 00 00       	call   80062c <cprintf>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800347:	e8 9a 13 00 00       	call   8016e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80034c:	e8 19 00 00 00       	call   80036a <exit>
}
  800351:	90                   	nop
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	6a 00                	push   $0x0
  80035f:	e8 27 15 00 00       	call   80188b <sys_destroy_env>
  800364:	83 c4 10             	add    $0x10,%esp
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <exit>:

void
exit(void)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800370:	e8 7c 15 00 00       	call   8018f1 <sys_exit_env>
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80037e:	8d 45 10             	lea    0x10(%ebp),%eax
  800381:	83 c0 04             	add    $0x4,%eax
  800384:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800387:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80038c:	85 c0                	test   %eax,%eax
  80038e:	74 16                	je     8003a6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800390:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	50                   	push   %eax
  800399:	68 74 1f 80 00       	push   $0x801f74
  80039e:	e8 89 02 00 00       	call   80062c <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	50                   	push   %eax
  8003b2:	68 79 1f 80 00       	push   $0x801f79
  8003b7:	e8 70 02 00 00       	call   80062c <cprintf>
  8003bc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c2:	83 ec 08             	sub    $0x8,%esp
  8003c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c8:	50                   	push   %eax
  8003c9:	e8 f3 01 00 00       	call   8005c1 <vcprintf>
  8003ce:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	6a 00                	push   $0x0
  8003d6:	68 95 1f 80 00       	push   $0x801f95
  8003db:	e8 e1 01 00 00       	call   8005c1 <vcprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e3:	e8 82 ff ff ff       	call   80036a <exit>

	// should not return here
	while (1) ;
  8003e8:	eb fe                	jmp    8003e8 <_panic+0x70>

008003ea <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f5:	8b 50 74             	mov    0x74(%eax),%edx
  8003f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	74 14                	je     800413 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ff:	83 ec 04             	sub    $0x4,%esp
  800402:	68 98 1f 80 00       	push   $0x801f98
  800407:	6a 26                	push   $0x26
  800409:	68 e4 1f 80 00       	push   $0x801fe4
  80040e:	e8 65 ff ff ff       	call   800378 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800413:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80041a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800421:	e9 c2 00 00 00       	jmp    8004e8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	85 c0                	test   %eax,%eax
  800439:	75 08                	jne    800443 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80043b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80043e:	e9 a2 00 00 00       	jmp    8004e5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800443:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800451:	eb 69                	jmp    8004bc <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80045e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800461:	89 d0                	mov    %edx,%eax
  800463:	01 c0                	add    %eax,%eax
  800465:	01 d0                	add    %edx,%eax
  800467:	c1 e0 03             	shl    $0x3,%eax
  80046a:	01 c8                	add    %ecx,%eax
  80046c:	8a 40 04             	mov    0x4(%eax),%al
  80046f:	84 c0                	test   %al,%al
  800471:	75 46                	jne    8004b9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800473:	a1 20 30 80 00       	mov    0x803020,%eax
  800478:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	89 d0                	mov    %edx,%eax
  800483:	01 c0                	add    %eax,%eax
  800485:	01 d0                	add    %edx,%eax
  800487:	c1 e0 03             	shl    $0x3,%eax
  80048a:	01 c8                	add    %ecx,%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800491:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800499:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	01 c8                	add    %ecx,%eax
  8004aa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ac:	39 c2                	cmp    %eax,%edx
  8004ae:	75 09                	jne    8004b9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004b7:	eb 12                	jmp    8004cb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b9:	ff 45 e8             	incl   -0x18(%ebp)
  8004bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c1:	8b 50 74             	mov    0x74(%eax),%edx
  8004c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	77 88                	ja     800453 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004cf:	75 14                	jne    8004e5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	68 f0 1f 80 00       	push   $0x801ff0
  8004d9:	6a 3a                	push   $0x3a
  8004db:	68 e4 1f 80 00       	push   $0x801fe4
  8004e0:	e8 93 fe ff ff       	call   800378 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004e5:	ff 45 f0             	incl   -0x10(%ebp)
  8004e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ee:	0f 8c 32 ff ff ff    	jl     800426 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800502:	eb 26                	jmp    80052a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800504:	a1 20 30 80 00       	mov    0x803020,%eax
  800509:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80050f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	c1 e0 03             	shl    $0x3,%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8a 40 04             	mov    0x4(%eax),%al
  800520:	3c 01                	cmp    $0x1,%al
  800522:	75 03                	jne    800527 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800524:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800527:	ff 45 e0             	incl   -0x20(%ebp)
  80052a:	a1 20 30 80 00       	mov    0x803020,%eax
  80052f:	8b 50 74             	mov    0x74(%eax),%edx
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	39 c2                	cmp    %eax,%edx
  800537:	77 cb                	ja     800504 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80053f:	74 14                	je     800555 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	68 44 20 80 00       	push   $0x802044
  800549:	6a 44                	push   $0x44
  80054b:	68 e4 1f 80 00       	push   $0x801fe4
  800550:	e8 23 fe ff ff       	call   800378 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800555:	90                   	nop
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	8d 48 01             	lea    0x1(%eax),%ecx
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	89 0a                	mov    %ecx,(%edx)
  80056b:	8b 55 08             	mov    0x8(%ebp),%edx
  80056e:	88 d1                	mov    %dl,%cl
  800570:	8b 55 0c             	mov    0xc(%ebp),%edx
  800573:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800581:	75 2c                	jne    8005af <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800583:	a0 24 30 80 00       	mov    0x803024,%al
  800588:	0f b6 c0             	movzbl %al,%eax
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	8b 12                	mov    (%edx),%edx
  800590:	89 d1                	mov    %edx,%ecx
  800592:	8b 55 0c             	mov    0xc(%ebp),%edx
  800595:	83 c2 08             	add    $0x8,%edx
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	50                   	push   %eax
  80059c:	51                   	push   %ecx
  80059d:	52                   	push   %edx
  80059e:	e8 7b 0f 00 00       	call   80151e <sys_cputs>
  8005a3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	8b 40 04             	mov    0x4(%eax),%eax
  8005b5:	8d 50 01             	lea    0x1(%eax),%edx
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005be:	90                   	nop
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d1:	00 00 00 
	b.cnt = 0;
  8005d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 08             	pushl  0x8(%ebp)
  8005e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ea:	50                   	push   %eax
  8005eb:	68 58 05 80 00       	push   $0x800558
  8005f0:	e8 11 02 00 00       	call   800806 <vprintfmt>
  8005f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005f8:	a0 24 30 80 00       	mov    0x803024,%al
  8005fd:	0f b6 c0             	movzbl %al,%eax
  800600:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	50                   	push   %eax
  80060a:	52                   	push   %edx
  80060b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800611:	83 c0 08             	add    $0x8,%eax
  800614:	50                   	push   %eax
  800615:	e8 04 0f 00 00       	call   80151e <sys_cputs>
  80061a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80061d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800624:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <cprintf>:

int cprintf(const char *fmt, ...) {
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800632:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800639:	8d 45 0c             	lea    0xc(%ebp),%eax
  80063c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 f4             	pushl  -0xc(%ebp)
  800648:	50                   	push   %eax
  800649:	e8 73 ff ff ff       	call   8005c1 <vcprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80065f:	e8 68 10 00 00       	call   8016cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800664:	8d 45 0c             	lea    0xc(%ebp),%eax
  800667:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 f4             	pushl  -0xc(%ebp)
  800673:	50                   	push   %eax
  800674:	e8 48 ff ff ff       	call   8005c1 <vcprintf>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80067f:	e8 62 10 00 00       	call   8016e6 <sys_enable_interrupt>
	return cnt;
  800684:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	53                   	push   %ebx
  80068d:	83 ec 14             	sub    $0x14,%esp
  800690:	8b 45 10             	mov    0x10(%ebp),%eax
  800693:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80069c:	8b 45 18             	mov    0x18(%ebp),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a7:	77 55                	ja     8006fe <printnum+0x75>
  8006a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ac:	72 05                	jb     8006b3 <printnum+0x2a>
  8006ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b1:	77 4b                	ja     8006fe <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006b6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	52                   	push   %edx
  8006c2:	50                   	push   %eax
  8006c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8006c9:	e8 86 14 00 00       	call   801b54 <__udivdi3>
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	83 ec 04             	sub    $0x4,%esp
  8006d4:	ff 75 20             	pushl  0x20(%ebp)
  8006d7:	53                   	push   %ebx
  8006d8:	ff 75 18             	pushl  0x18(%ebp)
  8006db:	52                   	push   %edx
  8006dc:	50                   	push   %eax
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 08             	pushl  0x8(%ebp)
  8006e3:	e8 a1 ff ff ff       	call   800689 <printnum>
  8006e8:	83 c4 20             	add    $0x20,%esp
  8006eb:	eb 1a                	jmp    800707 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 20             	pushl  0x20(%ebp)
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006fe:	ff 4d 1c             	decl   0x1c(%ebp)
  800701:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800705:	7f e6                	jg     8006ed <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800707:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80070a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800715:	53                   	push   %ebx
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	50                   	push   %eax
  800719:	e8 46 15 00 00       	call   801c64 <__umoddi3>
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	05 b4 22 80 00       	add    $0x8022b4,%eax
  800726:	8a 00                	mov    (%eax),%al
  800728:	0f be c0             	movsbl %al,%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	90                   	nop
  80073b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800743:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800747:	7e 1c                	jle    800765 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	8d 50 08             	lea    0x8(%eax),%edx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	89 10                	mov    %edx,(%eax)
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	83 e8 08             	sub    $0x8,%eax
  80075e:	8b 50 04             	mov    0x4(%eax),%edx
  800761:	8b 00                	mov    (%eax),%eax
  800763:	eb 40                	jmp    8007a5 <getuint+0x65>
	else if (lflag)
  800765:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800769:	74 1e                	je     800789 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	8d 50 04             	lea    0x4(%eax),%edx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 10                	mov    %edx,(%eax)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	83 e8 04             	sub    $0x4,%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	eb 1c                	jmp    8007a5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ae:	7e 1c                	jle    8007cc <getint+0x25>
		return va_arg(*ap, long long);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8d 50 08             	lea    0x8(%eax),%edx
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	89 10                	mov    %edx,(%eax)
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	83 e8 08             	sub    $0x8,%eax
  8007c5:	8b 50 04             	mov    0x4(%eax),%edx
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	eb 38                	jmp    800804 <getint+0x5d>
	else if (lflag)
  8007cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d0:	74 1a                	je     8007ec <getint+0x45>
		return va_arg(*ap, long);
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	8d 50 04             	lea    0x4(%eax),%edx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	89 10                	mov    %edx,(%eax)
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	83 e8 04             	sub    $0x4,%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	99                   	cltd   
  8007ea:	eb 18                	jmp    800804 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	8d 50 04             	lea    0x4(%eax),%edx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	89 10                	mov    %edx,(%eax)
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	83 e8 04             	sub    $0x4,%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	99                   	cltd   
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080e:	eb 17                	jmp    800827 <vprintfmt+0x21>
			if (ch == '\0')
  800810:	85 db                	test   %ebx,%ebx
  800812:	0f 84 af 03 00 00    	je     800bc7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	53                   	push   %ebx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	8d 50 01             	lea    0x1(%eax),%edx
  80082d:	89 55 10             	mov    %edx,0x10(%ebp)
  800830:	8a 00                	mov    (%eax),%al
  800832:	0f b6 d8             	movzbl %al,%ebx
  800835:	83 fb 25             	cmp    $0x25,%ebx
  800838:	75 d6                	jne    800810 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80083a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80083e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80084c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800853:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085a:	8b 45 10             	mov    0x10(%ebp),%eax
  80085d:	8d 50 01             	lea    0x1(%eax),%edx
  800860:	89 55 10             	mov    %edx,0x10(%ebp)
  800863:	8a 00                	mov    (%eax),%al
  800865:	0f b6 d8             	movzbl %al,%ebx
  800868:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80086b:	83 f8 55             	cmp    $0x55,%eax
  80086e:	0f 87 2b 03 00 00    	ja     800b9f <vprintfmt+0x399>
  800874:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  80087b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80087d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800881:	eb d7                	jmp    80085a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800883:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800887:	eb d1                	jmp    80085a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800889:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800890:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	c1 e0 02             	shl    $0x2,%eax
  800898:	01 d0                	add    %edx,%eax
  80089a:	01 c0                	add    %eax,%eax
  80089c:	01 d8                	add    %ebx,%eax
  80089e:	83 e8 30             	sub    $0x30,%eax
  8008a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a7:	8a 00                	mov    (%eax),%al
  8008a9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ac:	83 fb 2f             	cmp    $0x2f,%ebx
  8008af:	7e 3e                	jle    8008ef <vprintfmt+0xe9>
  8008b1:	83 fb 39             	cmp    $0x39,%ebx
  8008b4:	7f 39                	jg     8008ef <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008b9:	eb d5                	jmp    800890 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008cf:	eb 1f                	jmp    8008f0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d5:	79 83                	jns    80085a <vprintfmt+0x54>
				width = 0;
  8008d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008de:	e9 77 ff ff ff       	jmp    80085a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ea:	e9 6b ff ff ff       	jmp    80085a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ef:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f4:	0f 89 60 ff ff ff    	jns    80085a <vprintfmt+0x54>
				width = precision, precision = -1;
  8008fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800900:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800907:	e9 4e ff ff ff       	jmp    80085a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80090c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80090f:	e9 46 ff ff ff       	jmp    80085a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	83 c0 04             	add    $0x4,%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	50                   	push   %eax
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			break;
  800934:	e9 89 02 00 00       	jmp    800bc2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80094a:	85 db                	test   %ebx,%ebx
  80094c:	79 02                	jns    800950 <vprintfmt+0x14a>
				err = -err;
  80094e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800950:	83 fb 64             	cmp    $0x64,%ebx
  800953:	7f 0b                	jg     800960 <vprintfmt+0x15a>
  800955:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  80095c:	85 f6                	test   %esi,%esi
  80095e:	75 19                	jne    800979 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800960:	53                   	push   %ebx
  800961:	68 c5 22 80 00       	push   $0x8022c5
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	ff 75 08             	pushl  0x8(%ebp)
  80096c:	e8 5e 02 00 00       	call   800bcf <printfmt>
  800971:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800974:	e9 49 02 00 00       	jmp    800bc2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800979:	56                   	push   %esi
  80097a:	68 ce 22 80 00       	push   $0x8022ce
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 45 02 00 00       	call   800bcf <printfmt>
  80098a:	83 c4 10             	add    $0x10,%esp
			break;
  80098d:	e9 30 02 00 00       	jmp    800bc2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800992:	8b 45 14             	mov    0x14(%ebp),%eax
  800995:	83 c0 04             	add    $0x4,%eax
  800998:	89 45 14             	mov    %eax,0x14(%ebp)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	83 e8 04             	sub    $0x4,%eax
  8009a1:	8b 30                	mov    (%eax),%esi
  8009a3:	85 f6                	test   %esi,%esi
  8009a5:	75 05                	jne    8009ac <vprintfmt+0x1a6>
				p = "(null)";
  8009a7:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  8009ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b0:	7e 6d                	jle    800a1f <vprintfmt+0x219>
  8009b2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009b6:	74 67                	je     800a1f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	50                   	push   %eax
  8009bf:	56                   	push   %esi
  8009c0:	e8 0c 03 00 00       	call   800cd1 <strnlen>
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009cb:	eb 16                	jmp    8009e3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009cd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	50                   	push   %eax
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e7:	7f e4                	jg     8009cd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e9:	eb 34                	jmp    800a1f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ef:	74 1c                	je     800a0d <vprintfmt+0x207>
  8009f1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f4:	7e 05                	jle    8009fb <vprintfmt+0x1f5>
  8009f6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f9:	7e 12                	jle    800a0d <vprintfmt+0x207>
					putch('?', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 3f                	push   $0x3f
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	eb 0f                	jmp    800a1c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	53                   	push   %ebx
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a1f:	89 f0                	mov    %esi,%eax
  800a21:	8d 70 01             	lea    0x1(%eax),%esi
  800a24:	8a 00                	mov    (%eax),%al
  800a26:	0f be d8             	movsbl %al,%ebx
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	74 24                	je     800a51 <vprintfmt+0x24b>
  800a2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a31:	78 b8                	js     8009eb <vprintfmt+0x1e5>
  800a33:	ff 4d e0             	decl   -0x20(%ebp)
  800a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3a:	79 af                	jns    8009eb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3c:	eb 13                	jmp    800a51 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	6a 20                	push   $0x20
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a55:	7f e7                	jg     800a3e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a57:	e9 66 01 00 00       	jmp    800bc2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a62:	8d 45 14             	lea    0x14(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	e8 3c fd ff ff       	call   8007a7 <getint>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7a:	85 d2                	test   %edx,%edx
  800a7c:	79 23                	jns    800aa1 <vprintfmt+0x29b>
				putch('-', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 2d                	push   $0x2d
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a94:	f7 d8                	neg    %eax
  800a96:	83 d2 00             	adc    $0x0,%edx
  800a99:	f7 da                	neg    %edx
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa8:	e9 bc 00 00 00       	jmp    800b69 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab6:	50                   	push   %eax
  800ab7:	e8 84 fc ff ff       	call   800740 <getuint>
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ac5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acc:	e9 98 00 00 00       	jmp    800b69 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 58                	push   $0x58
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	6a 58                	push   $0x58
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 58                	push   $0x58
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
			break;
  800b01:	e9 bc 00 00 00       	jmp    800bc2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 30                	push   $0x30
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 78                	push   $0x78
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b26:	8b 45 14             	mov    0x14(%ebp),%eax
  800b29:	83 c0 04             	add    $0x4,%eax
  800b2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	83 e8 04             	sub    $0x4,%eax
  800b35:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b48:	eb 1f                	jmp    800b69 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b50:	8d 45 14             	lea    0x14(%ebp),%eax
  800b53:	50                   	push   %eax
  800b54:	e8 e7 fb ff ff       	call   800740 <getuint>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b69:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b70:	83 ec 04             	sub    $0x4,%esp
  800b73:	52                   	push   %edx
  800b74:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b77:	50                   	push   %eax
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	ff 75 08             	pushl  0x8(%ebp)
  800b84:	e8 00 fb ff ff       	call   800689 <printnum>
  800b89:	83 c4 20             	add    $0x20,%esp
			break;
  800b8c:	eb 34                	jmp    800bc2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	53                   	push   %ebx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			break;
  800b9d:	eb 23                	jmp    800bc2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 25                	push   $0x25
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800baf:	ff 4d 10             	decl   0x10(%ebp)
  800bb2:	eb 03                	jmp    800bb7 <vprintfmt+0x3b1>
  800bb4:	ff 4d 10             	decl   0x10(%ebp)
  800bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bba:	48                   	dec    %eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	3c 25                	cmp    $0x25,%al
  800bbf:	75 f3                	jne    800bb4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc1:	90                   	nop
		}
	}
  800bc2:	e9 47 fc ff ff       	jmp    80080e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd5:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd8:	83 c0 04             	add    $0x4,%eax
  800bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bde:	8b 45 10             	mov    0x10(%ebp),%eax
  800be1:	ff 75 f4             	pushl  -0xc(%ebp)
  800be4:	50                   	push   %eax
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	ff 75 08             	pushl  0x8(%ebp)
  800beb:	e8 16 fc ff ff       	call   800806 <vprintfmt>
  800bf0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf3:	90                   	nop
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8b 40 08             	mov    0x8(%eax),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	8b 10                	mov    (%eax),%edx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 40 04             	mov    0x4(%eax),%eax
  800c13:	39 c2                	cmp    %eax,%edx
  800c15:	73 12                	jae    800c29 <sprintputch+0x33>
		*b->buf++ = ch;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	8d 48 01             	lea    0x1(%eax),%ecx
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	89 0a                	mov    %ecx,(%edx)
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	88 10                	mov    %dl,(%eax)
}
  800c29:	90                   	nop
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	01 d0                	add    %edx,%eax
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c51:	74 06                	je     800c59 <vsnprintf+0x2d>
  800c53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c57:	7f 07                	jg     800c60 <vsnprintf+0x34>
		return -E_INVAL;
  800c59:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5e:	eb 20                	jmp    800c80 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c60:	ff 75 14             	pushl  0x14(%ebp)
  800c63:	ff 75 10             	pushl  0x10(%ebp)
  800c66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c69:	50                   	push   %eax
  800c6a:	68 f6 0b 80 00       	push   $0x800bf6
  800c6f:	e8 92 fb ff ff       	call   800806 <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c88:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8b:	83 c0 04             	add    $0x4,%eax
  800c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c91:	8b 45 10             	mov    0x10(%ebp),%eax
  800c94:	ff 75 f4             	pushl  -0xc(%ebp)
  800c97:	50                   	push   %eax
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 89 ff ff ff       	call   800c2c <vsnprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbb:	eb 06                	jmp    800cc3 <strlen+0x15>
		n++;
  800cbd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc0:	ff 45 08             	incl   0x8(%ebp)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	84 c0                	test   %al,%al
  800cca:	75 f1                	jne    800cbd <strlen+0xf>
		n++;
	return n;
  800ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cde:	eb 09                	jmp    800ce9 <strnlen+0x18>
		n++;
  800ce0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce3:	ff 45 08             	incl   0x8(%ebp)
  800ce6:	ff 4d 0c             	decl   0xc(%ebp)
  800ce9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ced:	74 09                	je     800cf8 <strnlen+0x27>
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	75 e8                	jne    800ce0 <strnlen+0xf>
		n++;
	return n;
  800cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d09:	90                   	nop
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8d 50 01             	lea    0x1(%eax),%edx
  800d10:	89 55 08             	mov    %edx,0x8(%ebp)
  800d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d19:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1c:	8a 12                	mov    (%edx),%dl
  800d1e:	88 10                	mov    %dl,(%eax)
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	75 e4                	jne    800d0a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3e:	eb 1f                	jmp    800d5f <strncpy+0x34>
		*dst++ = *src;
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8d 50 01             	lea    0x1(%eax),%edx
  800d46:	89 55 08             	mov    %edx,0x8(%ebp)
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	8a 12                	mov    (%edx),%dl
  800d4e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	84 c0                	test   %al,%al
  800d57:	74 03                	je     800d5c <strncpy+0x31>
			src++;
  800d59:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d65:	72 d9                	jb     800d40 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7c:	74 30                	je     800dae <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d7e:	eb 16                	jmp    800d96 <strlcpy+0x2a>
			*dst++ = *src++;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8d 50 01             	lea    0x1(%eax),%edx
  800d86:	89 55 08             	mov    %edx,0x8(%ebp)
  800d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d92:	8a 12                	mov    (%edx),%dl
  800d94:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d96:	ff 4d 10             	decl   0x10(%ebp)
  800d99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9d:	74 09                	je     800da8 <strlcpy+0x3c>
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	84 c0                	test   %al,%al
  800da6:	75 d8                	jne    800d80 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db4:	29 c2                	sub    %eax,%edx
  800db6:	89 d0                	mov    %edx,%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dbd:	eb 06                	jmp    800dc5 <strcmp+0xb>
		p++, q++;
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	74 0e                	je     800ddc <strcmp+0x22>
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 10                	mov    (%eax),%dl
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	38 c2                	cmp    %al,%dl
  800dda:	74 e3                	je     800dbf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 d0             	movzbl %al,%edx
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f b6 c0             	movzbl %al,%eax
  800dec:	29 c2                	sub    %eax,%edx
  800dee:	89 d0                	mov    %edx,%eax
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df5:	eb 09                	jmp    800e00 <strncmp+0xe>
		n--, p++, q++;
  800df7:	ff 4d 10             	decl   0x10(%ebp)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e04:	74 17                	je     800e1d <strncmp+0x2b>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	74 0e                	je     800e1d <strncmp+0x2b>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 10                	mov    (%eax),%dl
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	38 c2                	cmp    %al,%dl
  800e1b:	74 da                	je     800df7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	75 07                	jne    800e2a <strncmp+0x38>
		return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
  800e28:	eb 14                	jmp    800e3e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	0f b6 d0             	movzbl %al,%edx
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f b6 c0             	movzbl %al,%eax
  800e3a:	29 c2                	sub    %eax,%edx
  800e3c:	89 d0                	mov    %edx,%eax
}
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 04             	sub    $0x4,%esp
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e4c:	eb 12                	jmp    800e60 <strchr+0x20>
		if (*s == c)
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e56:	75 05                	jne    800e5d <strchr+0x1d>
			return (char *) s;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	eb 11                	jmp    800e6e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e5                	jne    800e4e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7c:	eb 0d                	jmp    800e8b <strfind+0x1b>
		if (*s == c)
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e86:	74 0e                	je     800e96 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	84 c0                	test   %al,%al
  800e92:	75 ea                	jne    800e7e <strfind+0xe>
  800e94:	eb 01                	jmp    800e97 <strfind+0x27>
		if (*s == c)
			break;
  800e96:	90                   	nop
	return (char *) s;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eae:	eb 0e                	jmp    800ebe <memset+0x22>
		*p++ = c;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8d 50 01             	lea    0x1(%eax),%edx
  800eb6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ebe:	ff 4d f8             	decl   -0x8(%ebp)
  800ec1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ec5:	79 e9                	jns    800eb0 <memset+0x14>
		*p++ = c;

	return v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ede:	eb 16                	jmp    800ef6 <memcpy+0x2a>
		*d++ = *s++;
  800ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee3:	8d 50 01             	lea    0x1(%eax),%edx
  800ee6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef2:	8a 12                	mov    (%edx),%dl
  800ef4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efc:	89 55 10             	mov    %edx,0x10(%ebp)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	75 dd                	jne    800ee0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f20:	73 50                	jae    800f72 <memmove+0x6a>
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2d:	76 43                	jbe    800f72 <memmove+0x6a>
		s += n;
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f3b:	eb 10                	jmp    800f4d <memmove+0x45>
			*--d = *--s;
  800f3d:	ff 4d f8             	decl   -0x8(%ebp)
  800f40:	ff 4d fc             	decl   -0x4(%ebp)
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 10                	mov    (%eax),%dl
  800f48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 e3                	jne    800f3d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f5a:	eb 23                	jmp    800f7f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f96:	eb 2a                	jmp    800fc2 <memcmp+0x3e>
		if (*s1 != *s2)
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 10                	mov    (%eax),%dl
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	38 c2                	cmp    %al,%dl
  800fa4:	74 16                	je     800fbc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 c0             	movzbl %al,%eax
  800fb6:	29 c2                	sub    %eax,%edx
  800fb8:	89 d0                	mov    %edx,%eax
  800fba:	eb 18                	jmp    800fd4 <memcmp+0x50>
		s1++, s2++;
  800fbc:	ff 45 fc             	incl   -0x4(%ebp)
  800fbf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	75 c9                	jne    800f98 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 d0                	add    %edx,%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe7:	eb 15                	jmp    800ffe <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f b6 d0             	movzbl %al,%edx
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	0f b6 c0             	movzbl %al,%eax
  800ff7:	39 c2                	cmp    %eax,%edx
  800ff9:	74 0d                	je     801008 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801004:	72 e3                	jb     800fe9 <memfind+0x13>
  801006:	eb 01                	jmp    801009 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801008:	90                   	nop
	return (void *) s;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80101b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801022:	eb 03                	jmp    801027 <strtol+0x19>
		s++;
  801024:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	3c 20                	cmp    $0x20,%al
  80102e:	74 f4                	je     801024 <strtol+0x16>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 09                	cmp    $0x9,%al
  801037:	74 eb                	je     801024 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2b                	cmp    $0x2b,%al
  801040:	75 05                	jne    801047 <strtol+0x39>
		s++;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	eb 13                	jmp    80105a <strtol+0x4c>
	else if (*s == '-')
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3c 2d                	cmp    $0x2d,%al
  80104e:	75 0a                	jne    80105a <strtol+0x4c>
		s++, neg = 1;
  801050:	ff 45 08             	incl   0x8(%ebp)
  801053:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80105a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105e:	74 06                	je     801066 <strtol+0x58>
  801060:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801064:	75 20                	jne    801086 <strtol+0x78>
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 30                	cmp    $0x30,%al
  80106d:	75 17                	jne    801086 <strtol+0x78>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	40                   	inc    %eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 78                	cmp    $0x78,%al
  801077:	75 0d                	jne    801086 <strtol+0x78>
		s += 2, base = 16;
  801079:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801084:	eb 28                	jmp    8010ae <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801086:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108a:	75 15                	jne    8010a1 <strtol+0x93>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 30                	cmp    $0x30,%al
  801093:	75 0c                	jne    8010a1 <strtol+0x93>
		s++, base = 8;
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109f:	eb 0d                	jmp    8010ae <strtol+0xa0>
	else if (base == 0)
  8010a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a5:	75 07                	jne    8010ae <strtol+0xa0>
		base = 10;
  8010a7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 2f                	cmp    $0x2f,%al
  8010b5:	7e 19                	jle    8010d0 <strtol+0xc2>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 39                	cmp    $0x39,%al
  8010be:	7f 10                	jg     8010d0 <strtol+0xc2>
			dig = *s - '0';
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f be c0             	movsbl %al,%eax
  8010c8:	83 e8 30             	sub    $0x30,%eax
  8010cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ce:	eb 42                	jmp    801112 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 60                	cmp    $0x60,%al
  8010d7:	7e 19                	jle    8010f2 <strtol+0xe4>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 7a                	cmp    $0x7a,%al
  8010e0:	7f 10                	jg     8010f2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	0f be c0             	movsbl %al,%eax
  8010ea:	83 e8 57             	sub    $0x57,%eax
  8010ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f0:	eb 20                	jmp    801112 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 40                	cmp    $0x40,%al
  8010f9:	7e 39                	jle    801134 <strtol+0x126>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 5a                	cmp    $0x5a,%al
  801102:	7f 30                	jg     801134 <strtol+0x126>
			dig = *s - 'A' + 10;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f be c0             	movsbl %al,%eax
  80110c:	83 e8 37             	sub    $0x37,%eax
  80110f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801115:	3b 45 10             	cmp    0x10(%ebp),%eax
  801118:	7d 19                	jge    801133 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80111a:	ff 45 08             	incl   0x8(%ebp)
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	0f af 45 10          	imul   0x10(%ebp),%eax
  801124:	89 c2                	mov    %eax,%edx
  801126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112e:	e9 7b ff ff ff       	jmp    8010ae <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801133:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801134:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801138:	74 08                	je     801142 <strtol+0x134>
		*endptr = (char *) s;
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801142:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801146:	74 07                	je     80114f <strtol+0x141>
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114b:	f7 d8                	neg    %eax
  80114d:	eb 03                	jmp    801152 <strtol+0x144>
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <ltostr>:

void
ltostr(long value, char *str)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801168:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116c:	79 13                	jns    801181 <ltostr+0x2d>
	{
		neg = 1;
  80116e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80117b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801189:	99                   	cltd   
  80118a:	f7 f9                	idiv   %ecx
  80118c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	8d 50 01             	lea    0x1(%eax),%edx
  801195:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801198:	89 c2                	mov    %eax,%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a2:	83 c2 30             	add    $0x30,%edx
  8011a5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011aa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011af:	f7 e9                	imul   %ecx
  8011b1:	c1 fa 02             	sar    $0x2,%edx
  8011b4:	89 c8                	mov    %ecx,%eax
  8011b6:	c1 f8 1f             	sar    $0x1f,%eax
  8011b9:	29 c2                	sub    %eax,%edx
  8011bb:	89 d0                	mov    %edx,%eax
  8011bd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c8:	f7 e9                	imul   %ecx
  8011ca:	c1 fa 02             	sar    $0x2,%edx
  8011cd:	89 c8                	mov    %ecx,%eax
  8011cf:	c1 f8 1f             	sar    $0x1f,%eax
  8011d2:	29 c2                	sub    %eax,%edx
  8011d4:	89 d0                	mov    %edx,%eax
  8011d6:	c1 e0 02             	shl    $0x2,%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	01 c0                	add    %eax,%eax
  8011dd:	29 c1                	sub    %eax,%ecx
  8011df:	89 ca                	mov    %ecx,%edx
  8011e1:	85 d2                	test   %edx,%edx
  8011e3:	75 9c                	jne    801181 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ef:	48                   	dec    %eax
  8011f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f7:	74 3d                	je     801236 <ltostr+0xe2>
		start = 1 ;
  8011f9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801200:	eb 34                	jmp    801236 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 d0                	add    %edx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
  801215:	01 c2                	add    %eax,%edx
  801217:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	01 c8                	add    %ecx,%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801223:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80122e:	88 02                	mov    %al,(%edx)
		start++ ;
  801230:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801233:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801239:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80123c:	7c c4                	jl     801202 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80123e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801249:	90                   	nop
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801252:	ff 75 08             	pushl  0x8(%ebp)
  801255:	e8 54 fa ff ff       	call   800cae <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	e8 46 fa ff ff       	call   800cae <strlen>
  801268:	83 c4 04             	add    $0x4,%esp
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80126e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80127c:	eb 17                	jmp    801295 <strcconcat+0x49>
		final[s] = str1[s] ;
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	01 c2                	add    %eax,%edx
  801286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	01 c8                	add    %ecx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801292:	ff 45 fc             	incl   -0x4(%ebp)
  801295:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801298:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80129b:	7c e1                	jl     80127e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80129d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ab:	eb 1f                	jmp    8012cc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	8d 50 01             	lea    0x1(%eax),%edx
  8012b3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012b6:	89 c2                	mov    %eax,%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c3:	01 c8                	add    %ecx,%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012c9:	ff 45 f8             	incl   -0x8(%ebp)
  8012cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d2:	7c d9                	jl     8012ad <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	c6 00 00             	movb   $0x0,(%eax)
}
  8012df:	90                   	nop
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	eb 0c                	jmp    801313 <strsplit+0x31>
			*string++ = 0;
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8d 50 01             	lea    0x1(%eax),%edx
  80130d:	89 55 08             	mov    %edx,0x8(%ebp)
  801310:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	84 c0                	test   %al,%al
  80131a:	74 18                	je     801334 <strsplit+0x52>
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	0f be c0             	movsbl %al,%eax
  801324:	50                   	push   %eax
  801325:	ff 75 0c             	pushl  0xc(%ebp)
  801328:	e8 13 fb ff ff       	call   800e40 <strchr>
  80132d:	83 c4 08             	add    $0x8,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	75 d3                	jne    801307 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	84 c0                	test   %al,%al
  80133b:	74 5a                	je     801397 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	83 f8 0f             	cmp    $0xf,%eax
  801345:	75 07                	jne    80134e <strsplit+0x6c>
		{
			return 0;
  801347:	b8 00 00 00 00       	mov    $0x0,%eax
  80134c:	eb 66                	jmp    8013b4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80134e:	8b 45 14             	mov    0x14(%ebp),%eax
  801351:	8b 00                	mov    (%eax),%eax
  801353:	8d 48 01             	lea    0x1(%eax),%ecx
  801356:	8b 55 14             	mov    0x14(%ebp),%edx
  801359:	89 0a                	mov    %ecx,(%edx)
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	01 c2                	add    %eax,%edx
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80136c:	eb 03                	jmp    801371 <strsplit+0x8f>
			string++;
  80136e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	84 c0                	test   %al,%al
  801378:	74 8b                	je     801305 <strsplit+0x23>
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	0f be c0             	movsbl %al,%eax
  801382:	50                   	push   %eax
  801383:	ff 75 0c             	pushl  0xc(%ebp)
  801386:	e8 b5 fa ff ff       	call   800e40 <strchr>
  80138b:	83 c4 08             	add    $0x8,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	74 dc                	je     80136e <strsplit+0x8c>
			string++;
	}
  801392:	e9 6e ff ff ff       	jmp    801305 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801397:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	8b 00                	mov    (%eax),%eax
  80139d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013af:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 30 24 80 00       	push   $0x802430
  8013c4:	6a 0e                	push   $0xe
  8013c6:	68 6a 24 80 00       	push   $0x80246a
  8013cb:	e8 a8 ef ff ff       	call   800378 <_panic>

008013d0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8013d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	74 0f                	je     8013ee <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8013df:	e8 d2 ff ff ff       	call   8013b6 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e4:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8013eb:	00 00 00 
	}
	if (size == 0) return NULL ;
  8013ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f2:	75 07                	jne    8013fb <malloc+0x2b>
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f9:	eb 14                	jmp    80140f <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 78 24 80 00       	push   $0x802478
  801403:	6a 2e                	push   $0x2e
  801405:	68 6a 24 80 00       	push   $0x80246a
  80140a:	e8 69 ef ff ff       	call   800378 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	68 a0 24 80 00       	push   $0x8024a0
  80141f:	6a 49                	push   $0x49
  801421:	68 6a 24 80 00       	push   $0x80246a
  801426:	e8 4d ef ff ff       	call   800378 <_panic>

0080142b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 18             	sub    $0x18,%esp
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	68 c4 24 80 00       	push   $0x8024c4
  80143f:	6a 57                	push   $0x57
  801441:	68 6a 24 80 00       	push   $0x80246a
  801446:	e8 2d ef ff ff       	call   800378 <_panic>

0080144b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	68 ec 24 80 00       	push   $0x8024ec
  801459:	6a 60                	push   $0x60
  80145b:	68 6a 24 80 00       	push   $0x80246a
  801460:	e8 13 ef ff ff       	call   800378 <_panic>

00801465 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 10 25 80 00       	push   $0x802510
  801473:	6a 7c                	push   $0x7c
  801475:	68 6a 24 80 00       	push   $0x80246a
  80147a:	e8 f9 ee ff ff       	call   800378 <_panic>

0080147f <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	68 38 25 80 00       	push   $0x802538
  80148d:	68 86 00 00 00       	push   $0x86
  801492:	68 6a 24 80 00       	push   $0x80246a
  801497:	e8 dc ee ff ff       	call   800378 <_panic>

0080149c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	68 5c 25 80 00       	push   $0x80255c
  8014aa:	68 91 00 00 00       	push   $0x91
  8014af:	68 6a 24 80 00       	push   $0x80246a
  8014b4:	e8 bf ee ff ff       	call   800378 <_panic>

008014b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	68 5c 25 80 00       	push   $0x80255c
  8014c7:	68 96 00 00 00       	push   $0x96
  8014cc:	68 6a 24 80 00       	push   $0x80246a
  8014d1:	e8 a2 ee ff ff       	call   800378 <_panic>

008014d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	68 5c 25 80 00       	push   $0x80255c
  8014e4:	68 9b 00 00 00       	push   $0x9b
  8014e9:	68 6a 24 80 00       	push   $0x80246a
  8014ee:	e8 85 ee ff ff       	call   800378 <_panic>

008014f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	57                   	push   %edi
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801505:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801508:	8b 7d 18             	mov    0x18(%ebp),%edi
  80150b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80150e:	cd 30                	int    $0x30
  801510:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	5b                   	pop    %ebx
  80151a:	5e                   	pop    %esi
  80151b:	5f                   	pop    %edi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	8b 45 10             	mov    0x10(%ebp),%eax
  801527:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80152a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	52                   	push   %edx
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	50                   	push   %eax
  80153a:	6a 00                	push   $0x0
  80153c:	e8 b2 ff ff ff       	call   8014f3 <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	90                   	nop
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <sys_cgetc>:

int
sys_cgetc(void)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 01                	push   $0x1
  801556:	e8 98 ff ff ff       	call   8014f3 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	6a 05                	push   $0x5
  801573:	e8 7b ff ff ff       	call   8014f3 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801582:	8b 75 18             	mov    0x18(%ebp),%esi
  801585:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	51                   	push   %ecx
  801594:	52                   	push   %edx
  801595:	50                   	push   %eax
  801596:	6a 06                	push   $0x6
  801598:	e8 56 ff ff ff       	call   8014f3 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	52                   	push   %edx
  8015b7:	50                   	push   %eax
  8015b8:	6a 07                	push   $0x7
  8015ba:	e8 34 ff ff ff       	call   8014f3 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	ff 75 08             	pushl  0x8(%ebp)
  8015d3:	6a 08                	push   $0x8
  8015d5:	e8 19 ff ff ff       	call   8014f3 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 09                	push   $0x9
  8015ee:	e8 00 ff ff ff       	call   8014f3 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 0a                	push   $0xa
  801607:	e8 e7 fe ff ff       	call   8014f3 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 0b                	push   $0xb
  801620:	e8 ce fe ff ff       	call   8014f3 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	ff 75 0c             	pushl  0xc(%ebp)
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	6a 0f                	push   $0xf
  80163b:	e8 b3 fe ff ff       	call   8014f3 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
	return;
  801643:	90                   	nop
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	ff 75 08             	pushl  0x8(%ebp)
  801655:	6a 10                	push   $0x10
  801657:	e8 97 fe ff ff       	call   8014f3 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
	return ;
  80165f:	90                   	nop
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	ff 75 10             	pushl  0x10(%ebp)
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 11                	push   $0x11
  801674:	e8 7a fe ff ff       	call   8014f3 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
	return ;
  80167c:	90                   	nop
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 0c                	push   $0xc
  80168e:	e8 60 fe ff ff       	call   8014f3 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	ff 75 08             	pushl  0x8(%ebp)
  8016a6:	6a 0d                	push   $0xd
  8016a8:	e8 46 fe ff ff       	call   8014f3 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 0e                	push   $0xe
  8016c1:	e8 2d fe ff ff       	call   8014f3 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	90                   	nop
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 13                	push   $0x13
  8016db:	e8 13 fe ff ff       	call   8014f3 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	90                   	nop
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 14                	push   $0x14
  8016f5:	e8 f9 fd ff ff       	call   8014f3 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	90                   	nop
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_cputc>:


void
sys_cputc(const char c)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 04             	sub    $0x4,%esp
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80170c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	50                   	push   %eax
  801719:	6a 15                	push   $0x15
  80171b:	e8 d3 fd ff ff       	call   8014f3 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 16                	push   $0x16
  801735:	e8 b9 fd ff ff       	call   8014f3 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	50                   	push   %eax
  801750:	6a 17                	push   $0x17
  801752:	e8 9c fd ff ff       	call   8014f3 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80175f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	52                   	push   %edx
  80176c:	50                   	push   %eax
  80176d:	6a 1a                	push   $0x1a
  80176f:	e8 7f fd ff ff       	call   8014f3 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80177c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	52                   	push   %edx
  801789:	50                   	push   %eax
  80178a:	6a 18                	push   $0x18
  80178c:	e8 62 fd ff ff       	call   8014f3 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	90                   	nop
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	52                   	push   %edx
  8017a7:	50                   	push   %eax
  8017a8:	6a 19                	push   $0x19
  8017aa:	e8 44 fd ff ff       	call   8014f3 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	51                   	push   %ecx
  8017ce:	52                   	push   %edx
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	50                   	push   %eax
  8017d3:	6a 1b                	push   $0x1b
  8017d5:	e8 19 fd ff ff       	call   8014f3 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	52                   	push   %edx
  8017ef:	50                   	push   %eax
  8017f0:	6a 1c                	push   $0x1c
  8017f2:	e8 fc fc ff ff       	call   8014f3 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	51                   	push   %ecx
  80180d:	52                   	push   %edx
  80180e:	50                   	push   %eax
  80180f:	6a 1d                	push   $0x1d
  801811:	e8 dd fc ff ff       	call   8014f3 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 1e                	push   $0x1e
  80182e:	e8 c0 fc ff ff       	call   8014f3 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 1f                	push   $0x1f
  801847:	e8 a7 fc ff ff       	call   8014f3 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	ff 75 14             	pushl  0x14(%ebp)
  80185c:	ff 75 10             	pushl  0x10(%ebp)
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	50                   	push   %eax
  801863:	6a 20                	push   $0x20
  801865:	e8 89 fc ff ff       	call   8014f3 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	50                   	push   %eax
  80187e:	6a 21                	push   $0x21
  801880:	e8 6e fc ff ff       	call   8014f3 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	50                   	push   %eax
  80189a:	6a 22                	push   $0x22
  80189c:	e8 52 fc ff ff       	call   8014f3 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 02                	push   $0x2
  8018b5:	e8 39 fc ff ff       	call   8014f3 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 03                	push   $0x3
  8018ce:	e8 20 fc ff ff       	call   8014f3 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 04                	push   $0x4
  8018e7:	e8 07 fc ff ff       	call   8014f3 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_exit_env>:


void sys_exit_env(void)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 23                	push   $0x23
  801900:	e8 ee fb ff ff       	call   8014f3 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801911:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801914:	8d 50 04             	lea    0x4(%eax),%edx
  801917:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 24                	push   $0x24
  801924:	e8 ca fb ff ff       	call   8014f3 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
	return result;
  80192c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801932:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801935:	89 01                	mov    %eax,(%ecx)
  801937:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	c9                   	leave  
  80193e:	c2 04 00             	ret    $0x4

00801941 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	ff 75 10             	pushl  0x10(%ebp)
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 12                	push   $0x12
  801953:	e8 9b fb ff ff       	call   8014f3 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return ;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_rcr2>:
uint32 sys_rcr2()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 25                	push   $0x25
  80196d:	e8 81 fb ff ff       	call   8014f3 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801983:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	50                   	push   %eax
  801990:	6a 26                	push   $0x26
  801992:	e8 5c fb ff ff       	call   8014f3 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return ;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <rsttst>:
void rsttst()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 28                	push   $0x28
  8019ac:	e8 42 fb ff ff       	call   8014f3 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b4:	90                   	nop
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c3:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	ff 75 10             	pushl  0x10(%ebp)
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 27                	push   $0x27
  8019d7:	e8 17 fb ff ff       	call   8014f3 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <chktst>:
void chktst(uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 29                	push   $0x29
  8019f2:	e8 fc fa ff ff       	call   8014f3 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <inctst>:

void inctst()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 2a                	push   $0x2a
  801a0c:	e8 e2 fa ff ff       	call   8014f3 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
	return ;
  801a14:	90                   	nop
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <gettst>:
uint32 gettst()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 2b                	push   $0x2b
  801a26:	e8 c8 fa ff ff       	call   8014f3 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 2c                	push   $0x2c
  801a42:	e8 ac fa ff ff       	call   8014f3 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
  801a4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a4d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a51:	75 07                	jne    801a5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a53:	b8 01 00 00 00       	mov    $0x1,%eax
  801a58:	eb 05                	jmp    801a5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 2c                	push   $0x2c
  801a73:	e8 7b fa ff ff       	call   8014f3 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
  801a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a7e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a82:	75 07                	jne    801a8b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a84:	b8 01 00 00 00       	mov    $0x1,%eax
  801a89:	eb 05                	jmp    801a90 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 2c                	push   $0x2c
  801aa4:	e8 4a fa ff ff       	call   8014f3 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
  801aac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aaf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ab3:	75 07                	jne    801abc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aba:	eb 05                	jmp    801ac1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 2c                	push   $0x2c
  801ad5:	e8 19 fa ff ff       	call   8014f3 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
  801add:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ae0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ae4:	75 07                	jne    801aed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aeb:	eb 05                	jmp    801af2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 2d                	push   $0x2d
  801b04:	e8 ea f9 ff ff       	call   8014f3 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	53                   	push   %ebx
  801b22:	51                   	push   %ecx
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 2e                	push   $0x2e
  801b27:	e8 c7 f9 ff ff       	call   8014f3 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 2f                	push   $0x2f
  801b47:	e8 a7 f9 ff ff       	call   8014f3 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    
  801b51:	66 90                	xchg   %ax,%ax
  801b53:	90                   	nop

00801b54 <__udivdi3>:
  801b54:	55                   	push   %ebp
  801b55:	57                   	push   %edi
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 1c             	sub    $0x1c,%esp
  801b5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b6b:	89 ca                	mov    %ecx,%edx
  801b6d:	89 f8                	mov    %edi,%eax
  801b6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 2d                	jne    801ba4 <__udivdi3+0x50>
  801b77:	39 cf                	cmp    %ecx,%edi
  801b79:	77 65                	ja     801be0 <__udivdi3+0x8c>
  801b7b:	89 fd                	mov    %edi,%ebp
  801b7d:	85 ff                	test   %edi,%edi
  801b7f:	75 0b                	jne    801b8c <__udivdi3+0x38>
  801b81:	b8 01 00 00 00       	mov    $0x1,%eax
  801b86:	31 d2                	xor    %edx,%edx
  801b88:	f7 f7                	div    %edi
  801b8a:	89 c5                	mov    %eax,%ebp
  801b8c:	31 d2                	xor    %edx,%edx
  801b8e:	89 c8                	mov    %ecx,%eax
  801b90:	f7 f5                	div    %ebp
  801b92:	89 c1                	mov    %eax,%ecx
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	f7 f5                	div    %ebp
  801b98:	89 cf                	mov    %ecx,%edi
  801b9a:	89 fa                	mov    %edi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	39 ce                	cmp    %ecx,%esi
  801ba6:	77 28                	ja     801bd0 <__udivdi3+0x7c>
  801ba8:	0f bd fe             	bsr    %esi,%edi
  801bab:	83 f7 1f             	xor    $0x1f,%edi
  801bae:	75 40                	jne    801bf0 <__udivdi3+0x9c>
  801bb0:	39 ce                	cmp    %ecx,%esi
  801bb2:	72 0a                	jb     801bbe <__udivdi3+0x6a>
  801bb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bb8:	0f 87 9e 00 00 00    	ja     801c5c <__udivdi3+0x108>
  801bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc3:	89 fa                	mov    %edi,%edx
  801bc5:	83 c4 1c             	add    $0x1c,%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
  801bcd:	8d 76 00             	lea    0x0(%esi),%esi
  801bd0:	31 ff                	xor    %edi,%edi
  801bd2:	31 c0                	xor    %eax,%eax
  801bd4:	89 fa                	mov    %edi,%edx
  801bd6:	83 c4 1c             	add    $0x1c,%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5f                   	pop    %edi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	f7 f7                	div    %edi
  801be4:	31 ff                	xor    %edi,%edi
  801be6:	89 fa                	mov    %edi,%edx
  801be8:	83 c4 1c             	add    $0x1c,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5f                   	pop    %edi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
  801bf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bf5:	89 eb                	mov    %ebp,%ebx
  801bf7:	29 fb                	sub    %edi,%ebx
  801bf9:	89 f9                	mov    %edi,%ecx
  801bfb:	d3 e6                	shl    %cl,%esi
  801bfd:	89 c5                	mov    %eax,%ebp
  801bff:	88 d9                	mov    %bl,%cl
  801c01:	d3 ed                	shr    %cl,%ebp
  801c03:	89 e9                	mov    %ebp,%ecx
  801c05:	09 f1                	or     %esi,%ecx
  801c07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c0b:	89 f9                	mov    %edi,%ecx
  801c0d:	d3 e0                	shl    %cl,%eax
  801c0f:	89 c5                	mov    %eax,%ebp
  801c11:	89 d6                	mov    %edx,%esi
  801c13:	88 d9                	mov    %bl,%cl
  801c15:	d3 ee                	shr    %cl,%esi
  801c17:	89 f9                	mov    %edi,%ecx
  801c19:	d3 e2                	shl    %cl,%edx
  801c1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 e8                	shr    %cl,%eax
  801c23:	09 c2                	or     %eax,%edx
  801c25:	89 d0                	mov    %edx,%eax
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	f7 74 24 0c          	divl   0xc(%esp)
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	f7 e5                	mul    %ebp
  801c33:	39 d6                	cmp    %edx,%esi
  801c35:	72 19                	jb     801c50 <__udivdi3+0xfc>
  801c37:	74 0b                	je     801c44 <__udivdi3+0xf0>
  801c39:	89 d8                	mov    %ebx,%eax
  801c3b:	31 ff                	xor    %edi,%edi
  801c3d:	e9 58 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c48:	89 f9                	mov    %edi,%ecx
  801c4a:	d3 e2                	shl    %cl,%edx
  801c4c:	39 c2                	cmp    %eax,%edx
  801c4e:	73 e9                	jae    801c39 <__udivdi3+0xe5>
  801c50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	e9 40 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	31 c0                	xor    %eax,%eax
  801c5e:	e9 37 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c63:	90                   	nop

00801c64 <__umoddi3>:
  801c64:	55                   	push   %ebp
  801c65:	57                   	push   %edi
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	83 ec 1c             	sub    $0x1c,%esp
  801c6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c83:	89 f3                	mov    %esi,%ebx
  801c85:	89 fa                	mov    %edi,%edx
  801c87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c8b:	89 34 24             	mov    %esi,(%esp)
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	75 1a                	jne    801cac <__umoddi3+0x48>
  801c92:	39 f7                	cmp    %esi,%edi
  801c94:	0f 86 a2 00 00 00    	jbe    801d3c <__umoddi3+0xd8>
  801c9a:	89 c8                	mov    %ecx,%eax
  801c9c:	89 f2                	mov    %esi,%edx
  801c9e:	f7 f7                	div    %edi
  801ca0:	89 d0                	mov    %edx,%eax
  801ca2:	31 d2                	xor    %edx,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 f0                	cmp    %esi,%eax
  801cae:	0f 87 ac 00 00 00    	ja     801d60 <__umoddi3+0xfc>
  801cb4:	0f bd e8             	bsr    %eax,%ebp
  801cb7:	83 f5 1f             	xor    $0x1f,%ebp
  801cba:	0f 84 ac 00 00 00    	je     801d6c <__umoddi3+0x108>
  801cc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cc5:	29 ef                	sub    %ebp,%edi
  801cc7:	89 fe                	mov    %edi,%esi
  801cc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ccd:	89 e9                	mov    %ebp,%ecx
  801ccf:	d3 e0                	shl    %cl,%eax
  801cd1:	89 d7                	mov    %edx,%edi
  801cd3:	89 f1                	mov    %esi,%ecx
  801cd5:	d3 ef                	shr    %cl,%edi
  801cd7:	09 c7                	or     %eax,%edi
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 e2                	shl    %cl,%edx
  801cdd:	89 14 24             	mov    %edx,(%esp)
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	d3 e0                	shl    %cl,%eax
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cea:	d3 e0                	shl    %cl,%eax
  801cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf4:	89 f1                	mov    %esi,%ecx
  801cf6:	d3 e8                	shr    %cl,%eax
  801cf8:	09 d0                	or     %edx,%eax
  801cfa:	d3 eb                	shr    %cl,%ebx
  801cfc:	89 da                	mov    %ebx,%edx
  801cfe:	f7 f7                	div    %edi
  801d00:	89 d3                	mov    %edx,%ebx
  801d02:	f7 24 24             	mull   (%esp)
  801d05:	89 c6                	mov    %eax,%esi
  801d07:	89 d1                	mov    %edx,%ecx
  801d09:	39 d3                	cmp    %edx,%ebx
  801d0b:	0f 82 87 00 00 00    	jb     801d98 <__umoddi3+0x134>
  801d11:	0f 84 91 00 00 00    	je     801da8 <__umoddi3+0x144>
  801d17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d1b:	29 f2                	sub    %esi,%edx
  801d1d:	19 cb                	sbb    %ecx,%ebx
  801d1f:	89 d8                	mov    %ebx,%eax
  801d21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d25:	d3 e0                	shl    %cl,%eax
  801d27:	89 e9                	mov    %ebp,%ecx
  801d29:	d3 ea                	shr    %cl,%edx
  801d2b:	09 d0                	or     %edx,%eax
  801d2d:	89 e9                	mov    %ebp,%ecx
  801d2f:	d3 eb                	shr    %cl,%ebx
  801d31:	89 da                	mov    %ebx,%edx
  801d33:	83 c4 1c             	add    $0x1c,%esp
  801d36:	5b                   	pop    %ebx
  801d37:	5e                   	pop    %esi
  801d38:	5f                   	pop    %edi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    
  801d3b:	90                   	nop
  801d3c:	89 fd                	mov    %edi,%ebp
  801d3e:	85 ff                	test   %edi,%edi
  801d40:	75 0b                	jne    801d4d <__umoddi3+0xe9>
  801d42:	b8 01 00 00 00       	mov    $0x1,%eax
  801d47:	31 d2                	xor    %edx,%edx
  801d49:	f7 f7                	div    %edi
  801d4b:	89 c5                	mov    %eax,%ebp
  801d4d:	89 f0                	mov    %esi,%eax
  801d4f:	31 d2                	xor    %edx,%edx
  801d51:	f7 f5                	div    %ebp
  801d53:	89 c8                	mov    %ecx,%eax
  801d55:	f7 f5                	div    %ebp
  801d57:	89 d0                	mov    %edx,%eax
  801d59:	e9 44 ff ff ff       	jmp    801ca2 <__umoddi3+0x3e>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	89 c8                	mov    %ecx,%eax
  801d62:	89 f2                	mov    %esi,%edx
  801d64:	83 c4 1c             	add    $0x1c,%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    
  801d6c:	3b 04 24             	cmp    (%esp),%eax
  801d6f:	72 06                	jb     801d77 <__umoddi3+0x113>
  801d71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d75:	77 0f                	ja     801d86 <__umoddi3+0x122>
  801d77:	89 f2                	mov    %esi,%edx
  801d79:	29 f9                	sub    %edi,%ecx
  801d7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d7f:	89 14 24             	mov    %edx,(%esp)
  801d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d8a:	8b 14 24             	mov    (%esp),%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	2b 04 24             	sub    (%esp),%eax
  801d9b:	19 fa                	sbb    %edi,%edx
  801d9d:	89 d1                	mov    %edx,%ecx
  801d9f:	89 c6                	mov    %eax,%esi
  801da1:	e9 71 ff ff ff       	jmp    801d17 <__umoddi3+0xb3>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dac:	72 ea                	jb     801d98 <__umoddi3+0x134>
  801dae:	89 d9                	mov    %ebx,%ecx
  801db0:	e9 62 ff ff ff       	jmp    801d17 <__umoddi3+0xb3>
