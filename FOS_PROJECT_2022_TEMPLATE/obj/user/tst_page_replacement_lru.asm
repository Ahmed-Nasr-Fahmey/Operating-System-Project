
obj/user/tst_page_replacement_lru:     file format elf32-i386


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
  800031:	e8 fc 02 00 00       	call   800332 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
//	cprintf("envID = %d\n",envID);


	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 a0 1d 80 00       	push   $0x801da0
  800068:	6a 13                	push   $0x13
  80006a:	68 e4 1d 80 00       	push   $0x801de4
  80006f:	e8 0d 04 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007f:	83 c0 18             	add    $0x18,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800087:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 a0 1d 80 00       	push   $0x801da0
  80009e:	6a 14                	push   $0x14
  8000a0:	68 e4 1d 80 00       	push   $0x801de4
  8000a5:	e8 d7 03 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b5:	83 c0 30             	add    $0x30,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 a0 1d 80 00       	push   $0x801da0
  8000d4:	6a 15                	push   $0x15
  8000d6:	68 e4 1d 80 00       	push   $0x801de4
  8000db:	e8 a1 03 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000eb:	83 c0 48             	add    $0x48,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 a0 1d 80 00       	push   $0x801da0
  80010a:	6a 16                	push   $0x16
  80010c:	68 e4 1d 80 00       	push   $0x801de4
  800111:	e8 6b 03 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800121:	83 c0 60             	add    $0x60,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800129:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 a0 1d 80 00       	push   $0x801da0
  800140:	6a 17                	push   $0x17
  800142:	68 e4 1d 80 00       	push   $0x801de4
  800147:	e8 35 03 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800157:	83 c0 78             	add    $0x78,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80015f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 a0 1d 80 00       	push   $0x801da0
  800176:	6a 18                	push   $0x18
  800178:	68 e4 1d 80 00       	push   $0x801de4
  80017d:	e8 ff 02 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018d:	05 90 00 00 00       	add    $0x90,%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800197:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 a0 1d 80 00       	push   $0x801da0
  8001ae:	6a 19                	push   $0x19
  8001b0:	68 e4 1d 80 00       	push   $0x801de4
  8001b5:	e8 c7 02 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c5:	05 a8 00 00 00       	add    $0xa8,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 a0 1d 80 00       	push   $0x801da0
  8001e6:	6a 1a                	push   $0x1a
  8001e8:	68 e4 1d 80 00       	push   $0x801de4
  8001ed:	e8 8f 02 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fd:	05 c0 00 00 00       	add    $0xc0,%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800207:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80020a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 a0 1d 80 00       	push   $0x801da0
  80021e:	6a 1b                	push   $0x1b
  800220:	68 e4 1d 80 00       	push   $0x801de4
  800225:	e8 57 02 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800235:	05 d8 00 00 00       	add    $0xd8,%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80023f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800247:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 a0 1d 80 00       	push   $0x801da0
  800256:	6a 1c                	push   $0x1c
  800258:	68 e4 1d 80 00       	push   $0x801de4
  80025d:	e8 1f 02 00 00       	call   800481 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026d:	05 f0 00 00 00       	add    $0xf0,%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800277:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80027a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800284:	74 14                	je     80029a <_main+0x262>
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 a0 1d 80 00       	push   $0x801da0
  80028e:	6a 1d                	push   $0x1d
  800290:	68 e4 1d 80 00       	push   $0x801de4
  800295:	e8 e7 01 00 00       	call   800481 <_panic>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80029a:	a0 5f 51 83 00       	mov    0x83515f,%al
  80029f:	88 45 b7             	mov    %al,-0x49(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002a2:	a0 5f 61 83 00       	mov    0x83615f,%al
  8002a7:	88 45 b6             	mov    %al,-0x4a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002b1:	eb 37                	jmp    8002ea <_main+0x2b2>
	{
		arr[i] = -1 ;
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	05 60 a1 82 00       	add    $0x82a160,%eax
  8002bb:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002be:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002c9:	8a 12                	mov    (%edx),%dl
  8002cb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002cd:	a1 00 30 80 00       	mov    0x803000,%eax
  8002d2:	40                   	inc    %eax
  8002d3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002dd:	40                   	inc    %eax
  8002de:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002e3:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8002ea:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8002f1:	7e c0                	jle    8002b3 <_main+0x27b>
		ptr++ ; ptr2++ ;
	}

	//===================

	uint32 expectedPages[11] = {0x809000,0x80a000,0x804000,0x80b000,0x80c000,0x800000,0x801000,0x808000,0x803000,0xeebfd000,0};
  8002f3:	8d 45 88             	lea    -0x78(%ebp),%eax
  8002f6:	bb 60 1e 80 00       	mov    $0x801e60,%ebx
  8002fb:	ba 0b 00 00 00       	mov    $0xb,%edx
  800300:	89 c7                	mov    %eax,%edi
  800302:	89 de                	mov    %ebx,%esi
  800304:	89 d1                	mov    %edx,%ecx
  800306:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		CheckWSWithoutLastIndex(expectedPages, 11);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	6a 0b                	push   $0xb
  80030d:	8d 45 88             	lea    -0x78(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 dd 01 00 00       	call   8004f3 <CheckWSWithoutLastIndex>
  800316:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");

	}

	cprintf("Congratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 04 1e 80 00       	push   $0x801e04
  800321:	e8 0f 04 00 00       	call   800735 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	return;
  800329:	90                   	nop
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800338:	e8 4e 15 00 00       	call   80188b <sys_getenvindex>
  80033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800340:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	01 c0                	add    %eax,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800350:	01 c8                	add    %ecx,%eax
  800352:	c1 e0 02             	shl    $0x2,%eax
  800355:	01 d0                	add    %edx,%eax
  800357:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80035e:	01 c8                	add    %ecx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800372:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800382:	84 c0                	test   %al,%al
  800384:	74 0f                	je     800395 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800386:	a1 20 30 80 00       	mov    0x803020,%eax
  80038b:	05 18 da 01 00       	add    $0x1da18,%eax
  800390:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800399:	7e 0a                	jle    8003a5 <libmain+0x73>
		binaryname = argv[0];
  80039b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 08             	pushl  0x8(%ebp)
  8003ae:	e8 85 fc ff ff       	call   800038 <_main>
  8003b3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003b6:	e8 dd 12 00 00       	call   801698 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 a4 1e 80 00       	push   $0x801ea4
  8003c3:	e8 6d 03 00 00       	call   800735 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8003d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003db:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	68 cc 1e 80 00       	push   $0x801ecc
  8003eb:	e8 45 03 00 00       	call   800735 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f8:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800409:	a1 20 30 80 00       	mov    0x803020,%eax
  80040e:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800414:	51                   	push   %ecx
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	68 f4 1e 80 00       	push   $0x801ef4
  80041c:	e8 14 03 00 00       	call   800735 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 4c 1f 80 00       	push   $0x801f4c
  800438:	e8 f8 02 00 00       	call   800735 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 a4 1e 80 00       	push   $0x801ea4
  800448:	e8 e8 02 00 00       	call   800735 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800450:	e8 5d 12 00 00       	call   8016b2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800455:	e8 19 00 00 00       	call   800473 <exit>
}
  80045a:	90                   	nop
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	6a 00                	push   $0x0
  800468:	e8 ea 13 00 00       	call   801857 <sys_destroy_env>
  80046d:	83 c4 10             	add    $0x10,%esp
}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <exit>:

void
exit(void)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800479:	e8 3f 14 00 00       	call   8018bd <sys_exit_env>
}
  80047e:	90                   	nop
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800487:	8d 45 10             	lea    0x10(%ebp),%eax
  80048a:	83 c0 04             	add    $0x4,%eax
  80048d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800490:	a1 58 62 83 00       	mov    0x836258,%eax
  800495:	85 c0                	test   %eax,%eax
  800497:	74 16                	je     8004af <_panic+0x2e>
		cprintf("%s: ", argv0);
  800499:	a1 58 62 83 00       	mov    0x836258,%eax
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	50                   	push   %eax
  8004a2:	68 60 1f 80 00       	push   $0x801f60
  8004a7:	e8 89 02 00 00       	call   800735 <cprintf>
  8004ac:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004af:	a1 08 30 80 00       	mov    0x803008,%eax
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	ff 75 08             	pushl  0x8(%ebp)
  8004ba:	50                   	push   %eax
  8004bb:	68 65 1f 80 00       	push   $0x801f65
  8004c0:	e8 70 02 00 00       	call   800735 <cprintf>
  8004c5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d1:	50                   	push   %eax
  8004d2:	e8 f3 01 00 00       	call   8006ca <vcprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	6a 00                	push   $0x0
  8004df:	68 81 1f 80 00       	push   $0x801f81
  8004e4:	e8 e1 01 00 00       	call   8006ca <vcprintf>
  8004e9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ec:	e8 82 ff ff ff       	call   800473 <exit>

	// should not return here
	while (1) ;
  8004f1:	eb fe                	jmp    8004f1 <_panic+0x70>

008004f3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004fe:	8b 50 74             	mov    0x74(%eax),%edx
  800501:	8b 45 0c             	mov    0xc(%ebp),%eax
  800504:	39 c2                	cmp    %eax,%edx
  800506:	74 14                	je     80051c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	68 84 1f 80 00       	push   $0x801f84
  800510:	6a 26                	push   $0x26
  800512:	68 d0 1f 80 00       	push   $0x801fd0
  800517:	e8 65 ff ff ff       	call   800481 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80051c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052a:	e9 c2 00 00 00       	jmp    8005f1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800539:	8b 45 08             	mov    0x8(%ebp),%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	85 c0                	test   %eax,%eax
  800542:	75 08                	jne    80054c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800544:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800547:	e9 a2 00 00 00       	jmp    8005ee <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80054c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800553:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80055a:	eb 69                	jmp    8005c5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80055c:	a1 20 30 80 00       	mov    0x803020,%eax
  800561:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800567:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056a:	89 d0                	mov    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	c1 e0 03             	shl    $0x3,%eax
  800573:	01 c8                	add    %ecx,%eax
  800575:	8a 40 04             	mov    0x4(%eax),%al
  800578:	84 c0                	test   %al,%al
  80057a:	75 46                	jne    8005c2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057c:	a1 20 30 80 00       	mov    0x803020,%eax
  800581:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800587:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058a:	89 d0                	mov    %edx,%eax
  80058c:	01 c0                	add    %eax,%eax
  80058e:	01 d0                	add    %edx,%eax
  800590:	c1 e0 03             	shl    $0x3,%eax
  800593:	01 c8                	add    %ecx,%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80059a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	01 c8                	add    %ecx,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	75 09                	jne    8005c2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005b9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c0:	eb 12                	jmp    8005d4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c2:	ff 45 e8             	incl   -0x18(%ebp)
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 50 74             	mov    0x74(%eax),%edx
  8005cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d0:	39 c2                	cmp    %eax,%edx
  8005d2:	77 88                	ja     80055c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d8:	75 14                	jne    8005ee <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	68 dc 1f 80 00       	push   $0x801fdc
  8005e2:	6a 3a                	push   $0x3a
  8005e4:	68 d0 1f 80 00       	push   $0x801fd0
  8005e9:	e8 93 fe ff ff       	call   800481 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ee:	ff 45 f0             	incl   -0x10(%ebp)
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f7:	0f 8c 32 ff ff ff    	jl     80052f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800604:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80060b:	eb 26                	jmp    800633 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80060d:	a1 20 30 80 00       	mov    0x803020,%eax
  800612:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800618:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061b:	89 d0                	mov    %edx,%eax
  80061d:	01 c0                	add    %eax,%eax
  80061f:	01 d0                	add    %edx,%eax
  800621:	c1 e0 03             	shl    $0x3,%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8a 40 04             	mov    0x4(%eax),%al
  800629:	3c 01                	cmp    $0x1,%al
  80062b:	75 03                	jne    800630 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80062d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800630:	ff 45 e0             	incl   -0x20(%ebp)
  800633:	a1 20 30 80 00       	mov    0x803020,%eax
  800638:	8b 50 74             	mov    0x74(%eax),%edx
  80063b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	77 cb                	ja     80060d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800645:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800648:	74 14                	je     80065e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80064a:	83 ec 04             	sub    $0x4,%esp
  80064d:	68 30 20 80 00       	push   $0x802030
  800652:	6a 44                	push   $0x44
  800654:	68 d0 1f 80 00       	push   $0x801fd0
  800659:	e8 23 fe ff ff       	call   800481 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80065e:	90                   	nop
  80065f:	c9                   	leave  
  800660:	c3                   	ret    

00800661 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	8d 48 01             	lea    0x1(%eax),%ecx
  80066f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800672:	89 0a                	mov    %ecx,(%edx)
  800674:	8b 55 08             	mov    0x8(%ebp),%edx
  800677:	88 d1                	mov    %dl,%cl
  800679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800680:	8b 45 0c             	mov    0xc(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068a:	75 2c                	jne    8006b8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80068c:	a0 24 30 80 00       	mov    0x803024,%al
  800691:	0f b6 c0             	movzbl %al,%eax
  800694:	8b 55 0c             	mov    0xc(%ebp),%edx
  800697:	8b 12                	mov    (%edx),%edx
  800699:	89 d1                	mov    %edx,%ecx
  80069b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069e:	83 c2 08             	add    $0x8,%edx
  8006a1:	83 ec 04             	sub    $0x4,%esp
  8006a4:	50                   	push   %eax
  8006a5:	51                   	push   %ecx
  8006a6:	52                   	push   %edx
  8006a7:	e8 3e 0e 00 00       	call   8014ea <sys_cputs>
  8006ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bb:	8b 40 04             	mov    0x4(%eax),%eax
  8006be:	8d 50 01             	lea    0x1(%eax),%edx
  8006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006c7:	90                   	nop
  8006c8:	c9                   	leave  
  8006c9:	c3                   	ret    

008006ca <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006da:	00 00 00 
	b.cnt = 0;
  8006dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	ff 75 08             	pushl  0x8(%ebp)
  8006ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	68 61 06 80 00       	push   $0x800661
  8006f9:	e8 11 02 00 00       	call   80090f <vprintfmt>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800701:	a0 24 30 80 00       	mov    0x803024,%al
  800706:	0f b6 c0             	movzbl %al,%eax
  800709:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80070f:	83 ec 04             	sub    $0x4,%esp
  800712:	50                   	push   %eax
  800713:	52                   	push   %edx
  800714:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071a:	83 c0 08             	add    $0x8,%eax
  80071d:	50                   	push   %eax
  80071e:	e8 c7 0d 00 00       	call   8014ea <sys_cputs>
  800723:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800726:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80072d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <cprintf>:

int cprintf(const char *fmt, ...) {
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800742:	8d 45 0c             	lea    0xc(%ebp),%eax
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 f4             	pushl  -0xc(%ebp)
  800751:	50                   	push   %eax
  800752:	e8 73 ff ff ff       	call   8006ca <vcprintf>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80075d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800760:	c9                   	leave  
  800761:	c3                   	ret    

00800762 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800768:	e8 2b 0f 00 00       	call   801698 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80076d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800770:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 f4             	pushl  -0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	e8 48 ff ff ff       	call   8006ca <vcprintf>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800788:	e8 25 0f 00 00       	call   8016b2 <sys_enable_interrupt>
	return cnt;
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	53                   	push   %ebx
  800796:	83 ec 14             	sub    $0x14,%esp
  800799:	8b 45 10             	mov    0x10(%ebp),%eax
  80079c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b0:	77 55                	ja     800807 <printnum+0x75>
  8007b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b5:	72 05                	jb     8007bc <printnum+0x2a>
  8007b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ba:	77 4b                	ja     800807 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	52                   	push   %edx
  8007cb:	50                   	push   %eax
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d2:	e8 49 13 00 00       	call   801b20 <__udivdi3>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	ff 75 20             	pushl  0x20(%ebp)
  8007e0:	53                   	push   %ebx
  8007e1:	ff 75 18             	pushl  0x18(%ebp)
  8007e4:	52                   	push   %edx
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	ff 75 08             	pushl  0x8(%ebp)
  8007ec:	e8 a1 ff ff ff       	call   800792 <printnum>
  8007f1:	83 c4 20             	add    $0x20,%esp
  8007f4:	eb 1a                	jmp    800810 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 20             	pushl  0x20(%ebp)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800807:	ff 4d 1c             	decl   0x1c(%ebp)
  80080a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80080e:	7f e6                	jg     8007f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800810:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800813:	bb 00 00 00 00       	mov    $0x0,%ebx
  800818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081e:	53                   	push   %ebx
  80081f:	51                   	push   %ecx
  800820:	52                   	push   %edx
  800821:	50                   	push   %eax
  800822:	e8 09 14 00 00       	call   801c30 <__umoddi3>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	05 94 22 80 00       	add    $0x802294,%eax
  80082f:	8a 00                	mov    (%eax),%al
  800831:	0f be c0             	movsbl %al,%eax
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	50                   	push   %eax
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	ff d0                	call   *%eax
  800840:	83 c4 10             	add    $0x10,%esp
}
  800843:	90                   	nop
  800844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800847:	c9                   	leave  
  800848:	c3                   	ret    

00800849 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800850:	7e 1c                	jle    80086e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	8d 50 08             	lea    0x8(%eax),%edx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	89 10                	mov    %edx,(%eax)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	83 e8 08             	sub    $0x8,%eax
  800867:	8b 50 04             	mov    0x4(%eax),%edx
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	eb 40                	jmp    8008ae <getuint+0x65>
	else if (lflag)
  80086e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800872:	74 1e                	je     800892 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	89 10                	mov    %edx,(%eax)
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	83 e8 04             	sub    $0x4,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	ba 00 00 00 00       	mov    $0x0,%edx
  800890:	eb 1c                	jmp    8008ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	8d 50 04             	lea    0x4(%eax),%edx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 10                	mov    %edx,(%eax)
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	83 e8 04             	sub    $0x4,%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b7:	7e 1c                	jle    8008d5 <getint+0x25>
		return va_arg(*ap, long long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 08             	lea    0x8(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 08             	sub    $0x8,%eax
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	eb 38                	jmp    80090d <getint+0x5d>
	else if (lflag)
  8008d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d9:	74 1a                	je     8008f5 <getint+0x45>
		return va_arg(*ap, long);
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	8d 50 04             	lea    0x4(%eax),%edx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 10                	mov    %edx,(%eax)
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	99                   	cltd   
  8008f3:	eb 18                	jmp    80090d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 50 04             	lea    0x4(%eax),%edx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	89 10                	mov    %edx,(%eax)
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	83 e8 04             	sub    $0x4,%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	99                   	cltd   
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800917:	eb 17                	jmp    800930 <vprintfmt+0x21>
			if (ch == '\0')
  800919:	85 db                	test   %ebx,%ebx
  80091b:	0f 84 af 03 00 00    	je     800cd0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	53                   	push   %ebx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800930:	8b 45 10             	mov    0x10(%ebp),%eax
  800933:	8d 50 01             	lea    0x1(%eax),%edx
  800936:	89 55 10             	mov    %edx,0x10(%ebp)
  800939:	8a 00                	mov    (%eax),%al
  80093b:	0f b6 d8             	movzbl %al,%ebx
  80093e:	83 fb 25             	cmp    $0x25,%ebx
  800941:	75 d6                	jne    800919 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800943:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800947:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80094e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800955:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80095c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800963:	8b 45 10             	mov    0x10(%ebp),%eax
  800966:	8d 50 01             	lea    0x1(%eax),%edx
  800969:	89 55 10             	mov    %edx,0x10(%ebp)
  80096c:	8a 00                	mov    (%eax),%al
  80096e:	0f b6 d8             	movzbl %al,%ebx
  800971:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800974:	83 f8 55             	cmp    $0x55,%eax
  800977:	0f 87 2b 03 00 00    	ja     800ca8 <vprintfmt+0x399>
  80097d:	8b 04 85 b8 22 80 00 	mov    0x8022b8(,%eax,4),%eax
  800984:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800986:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80098a:	eb d7                	jmp    800963 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800990:	eb d1                	jmp    800963 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800992:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800999:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	c1 e0 02             	shl    $0x2,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	01 d8                	add    %ebx,%eax
  8009a7:	83 e8 30             	sub    $0x30,%eax
  8009aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	8a 00                	mov    (%eax),%al
  8009b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b8:	7e 3e                	jle    8009f8 <vprintfmt+0xe9>
  8009ba:	83 fb 39             	cmp    $0x39,%ebx
  8009bd:	7f 39                	jg     8009f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c2:	eb d5                	jmp    800999 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	83 c0 04             	add    $0x4,%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009d8:	eb 1f                	jmp    8009f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009de:	79 83                	jns    800963 <vprintfmt+0x54>
				width = 0;
  8009e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009e7:	e9 77 ff ff ff       	jmp    800963 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009f3:	e9 6b ff ff ff       	jmp    800963 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fd:	0f 89 60 ff ff ff    	jns    800963 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a09:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a10:	e9 4e ff ff ff       	jmp    800963 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a15:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a18:	e9 46 ff ff ff       	jmp    800963 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 e8 04             	sub    $0x4,%eax
  800a2c:	8b 00                	mov    (%eax),%eax
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	50                   	push   %eax
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 89 02 00 00       	jmp    800ccb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 c0 04             	add    $0x4,%eax
  800a48:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	83 e8 04             	sub    $0x4,%eax
  800a51:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a53:	85 db                	test   %ebx,%ebx
  800a55:	79 02                	jns    800a59 <vprintfmt+0x14a>
				err = -err;
  800a57:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a59:	83 fb 64             	cmp    $0x64,%ebx
  800a5c:	7f 0b                	jg     800a69 <vprintfmt+0x15a>
  800a5e:	8b 34 9d 00 21 80 00 	mov    0x802100(,%ebx,4),%esi
  800a65:	85 f6                	test   %esi,%esi
  800a67:	75 19                	jne    800a82 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a69:	53                   	push   %ebx
  800a6a:	68 a5 22 80 00       	push   $0x8022a5
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	ff 75 08             	pushl  0x8(%ebp)
  800a75:	e8 5e 02 00 00       	call   800cd8 <printfmt>
  800a7a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7d:	e9 49 02 00 00       	jmp    800ccb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a82:	56                   	push   %esi
  800a83:	68 ae 22 80 00       	push   $0x8022ae
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 45 02 00 00       	call   800cd8 <printfmt>
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	e9 30 02 00 00       	jmp    800ccb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 c0 04             	add    $0x4,%eax
  800aa1:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	83 e8 04             	sub    $0x4,%eax
  800aaa:	8b 30                	mov    (%eax),%esi
  800aac:	85 f6                	test   %esi,%esi
  800aae:	75 05                	jne    800ab5 <vprintfmt+0x1a6>
				p = "(null)";
  800ab0:	be b1 22 80 00       	mov    $0x8022b1,%esi
			if (width > 0 && padc != '-')
  800ab5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab9:	7e 6d                	jle    800b28 <vprintfmt+0x219>
  800abb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800abf:	74 67                	je     800b28 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	50                   	push   %eax
  800ac8:	56                   	push   %esi
  800ac9:	e8 0c 03 00 00       	call   800dda <strnlen>
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ad4:	eb 16                	jmp    800aec <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ad6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	50                   	push   %eax
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae9:	ff 4d e4             	decl   -0x1c(%ebp)
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	7f e4                	jg     800ad6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af2:	eb 34                	jmp    800b28 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800af4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af8:	74 1c                	je     800b16 <vprintfmt+0x207>
  800afa:	83 fb 1f             	cmp    $0x1f,%ebx
  800afd:	7e 05                	jle    800b04 <vprintfmt+0x1f5>
  800aff:	83 fb 7e             	cmp    $0x7e,%ebx
  800b02:	7e 12                	jle    800b16 <vprintfmt+0x207>
					putch('?', putdat);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	6a 3f                	push   $0x3f
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	eb 0f                	jmp    800b25 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b25:	ff 4d e4             	decl   -0x1c(%ebp)
  800b28:	89 f0                	mov    %esi,%eax
  800b2a:	8d 70 01             	lea    0x1(%eax),%esi
  800b2d:	8a 00                	mov    (%eax),%al
  800b2f:	0f be d8             	movsbl %al,%ebx
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	74 24                	je     800b5a <vprintfmt+0x24b>
  800b36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b3a:	78 b8                	js     800af4 <vprintfmt+0x1e5>
  800b3c:	ff 4d e0             	decl   -0x20(%ebp)
  800b3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b43:	79 af                	jns    800af4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b45:	eb 13                	jmp    800b5a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	6a 20                	push   $0x20
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b57:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5e:	7f e7                	jg     800b47 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b60:	e9 66 01 00 00       	jmp    800ccb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6e:	50                   	push   %eax
  800b6f:	e8 3c fd ff ff       	call   8008b0 <getint>
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b83:	85 d2                	test   %edx,%edx
  800b85:	79 23                	jns    800baa <vprintfmt+0x29b>
				putch('-', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 2d                	push   $0x2d
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9d:	f7 d8                	neg    %eax
  800b9f:	83 d2 00             	adc    $0x0,%edx
  800ba2:	f7 da                	neg    %edx
  800ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800baa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb1:	e9 bc 00 00 00       	jmp    800c72 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	e8 84 fc ff ff       	call   800849 <getuint>
  800bc5:	83 c4 10             	add    $0x10,%esp
  800bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd5:	e9 98 00 00 00       	jmp    800c72 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	6a 58                	push   $0x58
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bea:	83 ec 08             	sub    $0x8,%esp
  800bed:	ff 75 0c             	pushl  0xc(%ebp)
  800bf0:	6a 58                	push   $0x58
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	ff d0                	call   *%eax
  800bf7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	6a 58                	push   $0x58
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	ff d0                	call   *%eax
  800c07:	83 c4 10             	add    $0x10,%esp
			break;
  800c0a:	e9 bc 00 00 00       	jmp    800ccb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	6a 30                	push   $0x30
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	ff d0                	call   *%eax
  800c1c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	6a 78                	push   $0x78
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	83 c0 04             	add    $0x4,%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	83 e8 04             	sub    $0x4,%eax
  800c3e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c51:	eb 1f                	jmp    800c72 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 e8             	pushl  -0x18(%ebp)
  800c59:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5c:	50                   	push   %eax
  800c5d:	e8 e7 fb ff ff       	call   800849 <getuint>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c72:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	52                   	push   %edx
  800c7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c80:	50                   	push   %eax
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	ff 75 f0             	pushl  -0x10(%ebp)
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	ff 75 08             	pushl  0x8(%ebp)
  800c8d:	e8 00 fb ff ff       	call   800792 <printnum>
  800c92:	83 c4 20             	add    $0x20,%esp
			break;
  800c95:	eb 34                	jmp    800ccb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	53                   	push   %ebx
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	ff d0                	call   *%eax
  800ca3:	83 c4 10             	add    $0x10,%esp
			break;
  800ca6:	eb 23                	jmp    800ccb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	6a 25                	push   $0x25
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	ff d0                	call   *%eax
  800cb5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb8:	ff 4d 10             	decl   0x10(%ebp)
  800cbb:	eb 03                	jmp    800cc0 <vprintfmt+0x3b1>
  800cbd:	ff 4d 10             	decl   0x10(%ebp)
  800cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc3:	48                   	dec    %eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	3c 25                	cmp    $0x25,%al
  800cc8:	75 f3                	jne    800cbd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cca:	90                   	nop
		}
	}
  800ccb:	e9 47 fc ff ff       	jmp    800917 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cde:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ced:	50                   	push   %eax
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 16 fc ff ff       	call   80090f <vprintfmt>
  800cf9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cfc:	90                   	nop
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8b 40 08             	mov    0x8(%eax),%eax
  800d08:	8d 50 01             	lea    0x1(%eax),%edx
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8b 10                	mov    (%eax),%edx
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	8b 40 04             	mov    0x4(%eax),%eax
  800d1c:	39 c2                	cmp    %eax,%edx
  800d1e:	73 12                	jae    800d32 <sprintputch+0x33>
		*b->buf++ = ch;
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	8d 48 01             	lea    0x1(%eax),%ecx
  800d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2b:	89 0a                	mov    %ecx,(%edx)
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	88 10                	mov    %dl,(%eax)
}
  800d32:	90                   	nop
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	01 d0                	add    %edx,%eax
  800d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d5a:	74 06                	je     800d62 <vsnprintf+0x2d>
  800d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d60:	7f 07                	jg     800d69 <vsnprintf+0x34>
		return -E_INVAL;
  800d62:	b8 03 00 00 00       	mov    $0x3,%eax
  800d67:	eb 20                	jmp    800d89 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d69:	ff 75 14             	pushl  0x14(%ebp)
  800d6c:	ff 75 10             	pushl  0x10(%ebp)
  800d6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d72:	50                   	push   %eax
  800d73:	68 ff 0c 80 00       	push   $0x800cff
  800d78:	e8 92 fb ff ff       	call   80090f <vprintfmt>
  800d7d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d91:	8d 45 10             	lea    0x10(%ebp),%eax
  800d94:	83 c0 04             	add    $0x4,%eax
  800d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800da0:	50                   	push   %eax
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	ff 75 08             	pushl  0x8(%ebp)
  800da7:	e8 89 ff ff ff       	call   800d35 <vsnprintf>
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc4:	eb 06                	jmp    800dcc <strlen+0x15>
		n++;
  800dc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc9:	ff 45 08             	incl   0x8(%ebp)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	75 f1                	jne    800dc6 <strlen+0xf>
		n++;
	return n;
  800dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de7:	eb 09                	jmp    800df2 <strnlen+0x18>
		n++;
  800de9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 4d 0c             	decl   0xc(%ebp)
  800df2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df6:	74 09                	je     800e01 <strnlen+0x27>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 e8                	jne    800de9 <strnlen+0xf>
		n++;
	return n;
  800e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e12:	90                   	nop
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e25:	8a 12                	mov    (%edx),%dl
  800e27:	88 10                	mov    %dl,(%eax)
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e4                	jne    800e13 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e47:	eb 1f                	jmp    800e68 <strncpy+0x34>
		*dst++ = *src;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8d 50 01             	lea    0x1(%eax),%edx
  800e4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e55:	8a 12                	mov    (%edx),%dl
  800e57:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	74 03                	je     800e65 <strncpy+0x31>
			src++;
  800e62:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e65:	ff 45 fc             	incl   -0x4(%ebp)
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e6e:	72 d9                	jb     800e49 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e73:	c9                   	leave  
  800e74:	c3                   	ret    

00800e75 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e85:	74 30                	je     800eb7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e87:	eb 16                	jmp    800e9f <strlcpy+0x2a>
			*dst++ = *src++;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8d 50 01             	lea    0x1(%eax),%edx
  800e8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9b:	8a 12                	mov    (%edx),%dl
  800e9d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e9f:	ff 4d 10             	decl   0x10(%ebp)
  800ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea6:	74 09                	je     800eb1 <strlcpy+0x3c>
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	84 c0                	test   %al,%al
  800eaf:	75 d8                	jne    800e89 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ec6:	eb 06                	jmp    800ece <strcmp+0xb>
		p++, q++;
  800ec8:	ff 45 08             	incl   0x8(%ebp)
  800ecb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	74 0e                	je     800ee5 <strcmp+0x22>
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 10                	mov    (%eax),%dl
  800edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	38 c2                	cmp    %al,%dl
  800ee3:	74 e3                	je     800ec8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	0f b6 d0             	movzbl %al,%edx
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 c0             	movzbl %al,%eax
  800ef5:	29 c2                	sub    %eax,%edx
  800ef7:	89 d0                	mov    %edx,%eax
}
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800efe:	eb 09                	jmp    800f09 <strncmp+0xe>
		n--, p++, q++;
  800f00:	ff 4d 10             	decl   0x10(%ebp)
  800f03:	ff 45 08             	incl   0x8(%ebp)
  800f06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0d:	74 17                	je     800f26 <strncmp+0x2b>
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	74 0e                	je     800f26 <strncmp+0x2b>
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 10                	mov    (%eax),%dl
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	38 c2                	cmp    %al,%dl
  800f24:	74 da                	je     800f00 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2a:	75 07                	jne    800f33 <strncmp+0x38>
		return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f31:	eb 14                	jmp    800f47 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f b6 d0             	movzbl %al,%edx
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 c0             	movzbl %al,%eax
  800f43:	29 c2                	sub    %eax,%edx
  800f45:	89 d0                	mov    %edx,%eax
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f55:	eb 12                	jmp    800f69 <strchr+0x20>
		if (*s == c)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f5f:	75 05                	jne    800f66 <strchr+0x1d>
			return (char *) s;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	eb 11                	jmp    800f77 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f66:	ff 45 08             	incl   0x8(%ebp)
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	84 c0                	test   %al,%al
  800f70:	75 e5                	jne    800f57 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 04             	sub    $0x4,%esp
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f85:	eb 0d                	jmp    800f94 <strfind+0x1b>
		if (*s == c)
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8f:	74 0e                	je     800f9f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	75 ea                	jne    800f87 <strfind+0xe>
  800f9d:	eb 01                	jmp    800fa0 <strfind+0x27>
		if (*s == c)
			break;
  800f9f:	90                   	nop
	return (char *) s;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fb7:	eb 0e                	jmp    800fc7 <memset+0x22>
		*p++ = c;
  800fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbc:	8d 50 01             	lea    0x1(%eax),%edx
  800fbf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fc7:	ff 4d f8             	decl   -0x8(%ebp)
  800fca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fce:	79 e9                	jns    800fb9 <memset+0x14>
		*p++ = c;

	return v;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fe7:	eb 16                	jmp    800fff <memcpy+0x2a>
		*d++ = *s++;
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	8d 50 01             	lea    0x1(%eax),%edx
  800fef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffb:	8a 12                	mov    (%edx),%dl
  800ffd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fff:	8b 45 10             	mov    0x10(%ebp),%eax
  801002:	8d 50 ff             	lea    -0x1(%eax),%edx
  801005:	89 55 10             	mov    %edx,0x10(%ebp)
  801008:	85 c0                	test   %eax,%eax
  80100a:	75 dd                	jne    800fe9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801029:	73 50                	jae    80107b <memmove+0x6a>
  80102b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801036:	76 43                	jbe    80107b <memmove+0x6a>
		s += n;
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801044:	eb 10                	jmp    801056 <memmove+0x45>
			*--d = *--s;
  801046:	ff 4d f8             	decl   -0x8(%ebp)
  801049:	ff 4d fc             	decl   -0x4(%ebp)
  80104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104f:	8a 10                	mov    (%eax),%dl
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801054:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105c:	89 55 10             	mov    %edx,0x10(%ebp)
  80105f:	85 c0                	test   %eax,%eax
  801061:	75 e3                	jne    801046 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801063:	eb 23                	jmp    801088 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801065:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801068:	8d 50 01             	lea    0x1(%eax),%edx
  80106b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801071:	8d 4a 01             	lea    0x1(%edx),%ecx
  801074:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801077:	8a 12                	mov    (%edx),%dl
  801079:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801081:	89 55 10             	mov    %edx,0x10(%ebp)
  801084:	85 c0                	test   %eax,%eax
  801086:	75 dd                	jne    801065 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80109f:	eb 2a                	jmp    8010cb <memcmp+0x3e>
		if (*s1 != *s2)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	38 c2                	cmp    %al,%dl
  8010ad:	74 16                	je     8010c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	0f b6 d0             	movzbl %al,%edx
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 c0             	movzbl %al,%eax
  8010bf:	29 c2                	sub    %eax,%edx
  8010c1:	89 d0                	mov    %edx,%eax
  8010c3:	eb 18                	jmp    8010dd <memcmp+0x50>
		s1++, s2++;
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	75 c9                	jne    8010a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f0:	eb 15                	jmp    801107 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	0f b6 d0             	movzbl %al,%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	0f b6 c0             	movzbl %al,%eax
  801100:	39 c2                	cmp    %eax,%edx
  801102:	74 0d                	je     801111 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80110d:	72 e3                	jb     8010f2 <memfind+0x13>
  80110f:	eb 01                	jmp    801112 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801111:	90                   	nop
	return (void *) s;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801124:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80112b:	eb 03                	jmp    801130 <strtol+0x19>
		s++;
  80112d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 20                	cmp    $0x20,%al
  801137:	74 f4                	je     80112d <strtol+0x16>
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 09                	cmp    $0x9,%al
  801140:	74 eb                	je     80112d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 2b                	cmp    $0x2b,%al
  801149:	75 05                	jne    801150 <strtol+0x39>
		s++;
  80114b:	ff 45 08             	incl   0x8(%ebp)
  80114e:	eb 13                	jmp    801163 <strtol+0x4c>
	else if (*s == '-')
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 2d                	cmp    $0x2d,%al
  801157:	75 0a                	jne    801163 <strtol+0x4c>
		s++, neg = 1;
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801167:	74 06                	je     80116f <strtol+0x58>
  801169:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80116d:	75 20                	jne    80118f <strtol+0x78>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	3c 30                	cmp    $0x30,%al
  801176:	75 17                	jne    80118f <strtol+0x78>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	40                   	inc    %eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 78                	cmp    $0x78,%al
  801180:	75 0d                	jne    80118f <strtol+0x78>
		s += 2, base = 16;
  801182:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801186:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80118d:	eb 28                	jmp    8011b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	75 15                	jne    8011aa <strtol+0x93>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 0c                	jne    8011aa <strtol+0x93>
		s++, base = 8;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011a8:	eb 0d                	jmp    8011b7 <strtol+0xa0>
	else if (base == 0)
  8011aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ae:	75 07                	jne    8011b7 <strtol+0xa0>
		base = 10;
  8011b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 2f                	cmp    $0x2f,%al
  8011be:	7e 19                	jle    8011d9 <strtol+0xc2>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 39                	cmp    $0x39,%al
  8011c7:	7f 10                	jg     8011d9 <strtol+0xc2>
			dig = *s - '0';
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	0f be c0             	movsbl %al,%eax
  8011d1:	83 e8 30             	sub    $0x30,%eax
  8011d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d7:	eb 42                	jmp    80121b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 60                	cmp    $0x60,%al
  8011e0:	7e 19                	jle    8011fb <strtol+0xe4>
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 7a                	cmp    $0x7a,%al
  8011e9:	7f 10                	jg     8011fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f be c0             	movsbl %al,%eax
  8011f3:	83 e8 57             	sub    $0x57,%eax
  8011f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f9:	eb 20                	jmp    80121b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 40                	cmp    $0x40,%al
  801202:	7e 39                	jle    80123d <strtol+0x126>
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 5a                	cmp    $0x5a,%al
  80120b:	7f 30                	jg     80123d <strtol+0x126>
			dig = *s - 'A' + 10;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	0f be c0             	movsbl %al,%eax
  801215:	83 e8 37             	sub    $0x37,%eax
  801218:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801221:	7d 19                	jge    80123c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801229:	0f af 45 10          	imul   0x10(%ebp),%eax
  80122d:	89 c2                	mov    %eax,%edx
  80122f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801232:	01 d0                	add    %edx,%eax
  801234:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801237:	e9 7b ff ff ff       	jmp    8011b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80123c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80123d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801241:	74 08                	je     80124b <strtol+0x134>
		*endptr = (char *) s;
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80124b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124f:	74 07                	je     801258 <strtol+0x141>
  801251:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801254:	f7 d8                	neg    %eax
  801256:	eb 03                	jmp    80125b <strtol+0x144>
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <ltostr>:

void
ltostr(long value, char *str)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80126a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801271:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801275:	79 13                	jns    80128a <ltostr+0x2d>
	{
		neg = 1;
  801277:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801284:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801287:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801292:	99                   	cltd   
  801293:	f7 f9                	idiv   %ecx
  801295:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129b:	8d 50 01             	lea    0x1(%eax),%edx
  80129e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a1:	89 c2                	mov    %eax,%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ab:	83 c2 30             	add    $0x30,%edx
  8012ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012b8:	f7 e9                	imul   %ecx
  8012ba:	c1 fa 02             	sar    $0x2,%edx
  8012bd:	89 c8                	mov    %ecx,%eax
  8012bf:	c1 f8 1f             	sar    $0x1f,%eax
  8012c2:	29 c2                	sub    %eax,%edx
  8012c4:	89 d0                	mov    %edx,%eax
  8012c6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d1:	f7 e9                	imul   %ecx
  8012d3:	c1 fa 02             	sar    $0x2,%edx
  8012d6:	89 c8                	mov    %ecx,%eax
  8012d8:	c1 f8 1f             	sar    $0x1f,%eax
  8012db:	29 c2                	sub    %eax,%edx
  8012dd:	89 d0                	mov    %edx,%eax
  8012df:	c1 e0 02             	shl    $0x2,%eax
  8012e2:	01 d0                	add    %edx,%eax
  8012e4:	01 c0                	add    %eax,%eax
  8012e6:	29 c1                	sub    %eax,%ecx
  8012e8:	89 ca                	mov    %ecx,%edx
  8012ea:	85 d2                	test   %edx,%edx
  8012ec:	75 9c                	jne    80128a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f8:	48                   	dec    %eax
  8012f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801300:	74 3d                	je     80133f <ltostr+0xe2>
		start = 1 ;
  801302:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801309:	eb 34                	jmp    80133f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80130b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	01 d0                	add    %edx,%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	01 c2                	add    %eax,%edx
  801320:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c8                	add    %ecx,%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80132c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 c2                	add    %eax,%edx
  801334:	8a 45 eb             	mov    -0x15(%ebp),%al
  801337:	88 02                	mov    %al,(%edx)
		start++ ;
  801339:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80133c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801342:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801345:	7c c4                	jl     80130b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801347:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	01 d0                	add    %edx,%eax
  80134f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801352:	90                   	nop
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	e8 54 fa ff ff       	call   800db7 <strlen>
  801363:	83 c4 04             	add    $0x4,%esp
  801366:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	e8 46 fa ff ff       	call   800db7 <strlen>
  801371:	83 c4 04             	add    $0x4,%esp
  801374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801377:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80137e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801385:	eb 17                	jmp    80139e <strcconcat+0x49>
		final[s] = str1[s] ;
  801387:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
  80138d:	01 c2                	add    %eax,%edx
  80138f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	01 c8                	add    %ecx,%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80139b:	ff 45 fc             	incl   -0x4(%ebp)
  80139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a4:	7c e1                	jl     801387 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b4:	eb 1f                	jmp    8013d5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	8d 50 01             	lea    0x1(%eax),%edx
  8013bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c4:	01 c2                	add    %eax,%edx
  8013c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 c8                	add    %ecx,%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d2:	ff 45 f8             	incl   -0x8(%ebp)
  8013d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013db:	7c d9                	jl     8013b6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e3:	01 d0                	add    %edx,%eax
  8013e5:	c6 00 00             	movb   $0x0,(%eax)
}
  8013e8:	90                   	nop
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fa:	8b 00                	mov    (%eax),%eax
  8013fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801403:	8b 45 10             	mov    0x10(%ebp),%eax
  801406:	01 d0                	add    %edx,%eax
  801408:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80140e:	eb 0c                	jmp    80141c <strsplit+0x31>
			*string++ = 0;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	89 55 08             	mov    %edx,0x8(%ebp)
  801419:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	84 c0                	test   %al,%al
  801423:	74 18                	je     80143d <strsplit+0x52>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	0f be c0             	movsbl %al,%eax
  80142d:	50                   	push   %eax
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	e8 13 fb ff ff       	call   800f49 <strchr>
  801436:	83 c4 08             	add    $0x8,%esp
  801439:	85 c0                	test   %eax,%eax
  80143b:	75 d3                	jne    801410 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	84 c0                	test   %al,%al
  801444:	74 5a                	je     8014a0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801446:	8b 45 14             	mov    0x14(%ebp),%eax
  801449:	8b 00                	mov    (%eax),%eax
  80144b:	83 f8 0f             	cmp    $0xf,%eax
  80144e:	75 07                	jne    801457 <strsplit+0x6c>
		{
			return 0;
  801450:	b8 00 00 00 00       	mov    $0x0,%eax
  801455:	eb 66                	jmp    8014bd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	8b 00                	mov    (%eax),%eax
  80145c:	8d 48 01             	lea    0x1(%eax),%ecx
  80145f:	8b 55 14             	mov    0x14(%ebp),%edx
  801462:	89 0a                	mov    %ecx,(%edx)
  801464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 c2                	add    %eax,%edx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801475:	eb 03                	jmp    80147a <strsplit+0x8f>
			string++;
  801477:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	84 c0                	test   %al,%al
  801481:	74 8b                	je     80140e <strsplit+0x23>
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	0f be c0             	movsbl %al,%eax
  80148b:	50                   	push   %eax
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	e8 b5 fa ff ff       	call   800f49 <strchr>
  801494:	83 c4 08             	add    $0x8,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	74 dc                	je     801477 <strsplit+0x8c>
			string++;
	}
  80149b:	e9 6e ff ff ff       	jmp    80140e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a4:	8b 00                	mov    (%eax),%eax
  8014a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	01 d0                	add    %edx,%eax
  8014b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	57                   	push   %edi
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
  8014c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014da:	cd 30                	int    $0x30
  8014dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	52                   	push   %edx
  801502:	ff 75 0c             	pushl  0xc(%ebp)
  801505:	50                   	push   %eax
  801506:	6a 00                	push   $0x0
  801508:	e8 b2 ff ff ff       	call   8014bf <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	90                   	nop
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_cgetc>:

int
sys_cgetc(void)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 01                	push   $0x1
  801522:	e8 98 ff ff ff       	call   8014bf <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80152f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	6a 05                	push   $0x5
  80153f:	e8 7b ff ff ff       	call   8014bf <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	56                   	push   %esi
  80154d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80154e:	8b 75 18             	mov    0x18(%ebp),%esi
  801551:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	51                   	push   %ecx
  801560:	52                   	push   %edx
  801561:	50                   	push   %eax
  801562:	6a 06                	push   $0x6
  801564:	e8 56 ff ff ff       	call   8014bf <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801576:	8b 55 0c             	mov    0xc(%ebp),%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	52                   	push   %edx
  801583:	50                   	push   %eax
  801584:	6a 07                	push   $0x7
  801586:	e8 34 ff ff ff       	call   8014bf <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	6a 08                	push   $0x8
  8015a1:	e8 19 ff ff ff       	call   8014bf <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 09                	push   $0x9
  8015ba:	e8 00 ff ff ff       	call   8014bf <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 0a                	push   $0xa
  8015d3:	e8 e7 fe ff ff       	call   8014bf <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 0b                	push   $0xb
  8015ec:	e8 ce fe ff ff       	call   8014bf <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	6a 0f                	push   $0xf
  801607:	e8 b3 fe ff ff       	call   8014bf <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
	return;
  80160f:	90                   	nop
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	6a 10                	push   $0x10
  801623:	e8 97 fe ff ff       	call   8014bf <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return ;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	ff 75 10             	pushl  0x10(%ebp)
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	ff 75 08             	pushl  0x8(%ebp)
  80163e:	6a 11                	push   $0x11
  801640:	e8 7a fe ff ff       	call   8014bf <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
	return ;
  801648:	90                   	nop
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 0c                	push   $0xc
  80165a:	e8 60 fe ff ff       	call   8014bf <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 0d                	push   $0xd
  801674:	e8 46 fe ff ff       	call   8014bf <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 0e                	push   $0xe
  80168d:	e8 2d fe ff ff       	call   8014bf <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 13                	push   $0x13
  8016a7:	e8 13 fe ff ff       	call   8014bf <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 14                	push   $0x14
  8016c1:	e8 f9 fd ff ff       	call   8014bf <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	90                   	nop
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_cputc>:


void
sys_cputc(const char c)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	50                   	push   %eax
  8016e5:	6a 15                	push   $0x15
  8016e7:	e8 d3 fd ff ff       	call   8014bf <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	90                   	nop
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 16                	push   $0x16
  801701:	e8 b9 fd ff ff       	call   8014bf <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	90                   	nop
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	50                   	push   %eax
  80171c:	6a 17                	push   $0x17
  80171e:	e8 9c fd ff ff       	call   8014bf <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	52                   	push   %edx
  801738:	50                   	push   %eax
  801739:	6a 1a                	push   $0x1a
  80173b:	e8 7f fd ff ff       	call   8014bf <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	6a 18                	push   $0x18
  801758:	e8 62 fd ff ff       	call   8014bf <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	90                   	nop
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 19                	push   $0x19
  801776:	e8 44 fd ff ff       	call   8014bf <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80178d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801790:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	51                   	push   %ecx
  80179a:	52                   	push   %edx
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	50                   	push   %eax
  80179f:	6a 1b                	push   $0x1b
  8017a1:	e8 19 fd ff ff       	call   8014bf <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 1c                	push   $0x1c
  8017be:	e8 fc fc ff ff       	call   8014bf <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	51                   	push   %ecx
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 1d                	push   $0x1d
  8017dd:	e8 dd fc ff ff       	call   8014bf <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	52                   	push   %edx
  8017f7:	50                   	push   %eax
  8017f8:	6a 1e                	push   $0x1e
  8017fa:	e8 c0 fc ff ff       	call   8014bf <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 1f                	push   $0x1f
  801813:	e8 a7 fc ff ff       	call   8014bf <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	ff 75 14             	pushl  0x14(%ebp)
  801828:	ff 75 10             	pushl  0x10(%ebp)
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	50                   	push   %eax
  80182f:	6a 20                	push   $0x20
  801831:	e8 89 fc ff ff       	call   8014bf <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	50                   	push   %eax
  80184a:	6a 21                	push   $0x21
  80184c:	e8 6e fc ff ff       	call   8014bf <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	50                   	push   %eax
  801866:	6a 22                	push   $0x22
  801868:	e8 52 fc ff ff       	call   8014bf <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 02                	push   $0x2
  801881:	e8 39 fc ff ff       	call   8014bf <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 03                	push   $0x3
  80189a:	e8 20 fc ff ff       	call   8014bf <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 04                	push   $0x4
  8018b3:	e8 07 fc ff ff       	call   8014bf <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_exit_env>:


void sys_exit_env(void)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 23                	push   $0x23
  8018cc:	e8 ee fb ff ff       	call   8014bf <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e0:	8d 50 04             	lea    0x4(%eax),%edx
  8018e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	6a 24                	push   $0x24
  8018f0:	e8 ca fb ff ff       	call   8014bf <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801901:	89 01                	mov    %eax,(%ecx)
  801903:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	c9                   	leave  
  80190a:	c2 04 00             	ret    $0x4

0080190d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	ff 75 10             	pushl  0x10(%ebp)
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	ff 75 08             	pushl  0x8(%ebp)
  80191d:	6a 12                	push   $0x12
  80191f:	e8 9b fb ff ff       	call   8014bf <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
	return ;
  801927:	90                   	nop
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_rcr2>:
uint32 sys_rcr2()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 25                	push   $0x25
  801939:	e8 81 fb ff ff       	call   8014bf <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80194f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	50                   	push   %eax
  80195c:	6a 26                	push   $0x26
  80195e:	e8 5c fb ff ff       	call   8014bf <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <rsttst>:
void rsttst()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 28                	push   $0x28
  801978:	e8 42 fb ff ff       	call   8014bf <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return ;
  801980:	90                   	nop
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 14             	mov    0x14(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80198f:	8b 55 18             	mov    0x18(%ebp),%edx
  801992:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	ff 75 08             	pushl  0x8(%ebp)
  8019a1:	6a 27                	push   $0x27
  8019a3:	e8 17 fb ff ff       	call   8014bf <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ab:	90                   	nop
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <chktst>:
void chktst(uint32 n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 29                	push   $0x29
  8019be:	e8 fc fa ff ff       	call   8014bf <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <inctst>:

void inctst()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 2a                	push   $0x2a
  8019d8:	e8 e2 fa ff ff       	call   8014bf <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <gettst>:
uint32 gettst()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 2b                	push   $0x2b
  8019f2:	e8 c8 fa ff ff       	call   8014bf <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 2c                	push   $0x2c
  801a0e:	e8 ac fa ff ff       	call   8014bf <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
  801a16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a1d:	75 07                	jne    801a26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a24:	eb 05                	jmp    801a2b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 2c                	push   $0x2c
  801a3f:	e8 7b fa ff ff       	call   8014bf <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
  801a47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a4a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a4e:	75 07                	jne    801a57 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a50:	b8 01 00 00 00       	mov    $0x1,%eax
  801a55:	eb 05                	jmp    801a5c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 2c                	push   $0x2c
  801a70:	e8 4a fa ff ff       	call   8014bf <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
  801a78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a7b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a7f:	75 07                	jne    801a88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a81:	b8 01 00 00 00       	mov    $0x1,%eax
  801a86:	eb 05                	jmp    801a8d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 2c                	push   $0x2c
  801aa1:	e8 19 fa ff ff       	call   8014bf <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
  801aa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ab0:	75 07                	jne    801ab9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	eb 05                	jmp    801abe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 08             	pushl  0x8(%ebp)
  801ace:	6a 2d                	push   $0x2d
  801ad0:	e8 ea f9 ff ff       	call   8014bf <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad8:	90                   	nop
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801adf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	53                   	push   %ebx
  801aee:	51                   	push   %ecx
  801aef:	52                   	push   %edx
  801af0:	50                   	push   %eax
  801af1:	6a 2e                	push   $0x2e
  801af3:	e8 c7 f9 ff ff       	call   8014bf <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 2f                	push   $0x2f
  801b13:	e8 a7 f9 ff ff       	call   8014bf <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    
  801b1d:	66 90                	xchg   %ax,%ax
  801b1f:	90                   	nop

00801b20 <__udivdi3>:
  801b20:	55                   	push   %ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 1c             	sub    $0x1c,%esp
  801b27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b37:	89 ca                	mov    %ecx,%edx
  801b39:	89 f8                	mov    %edi,%eax
  801b3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b3f:	85 f6                	test   %esi,%esi
  801b41:	75 2d                	jne    801b70 <__udivdi3+0x50>
  801b43:	39 cf                	cmp    %ecx,%edi
  801b45:	77 65                	ja     801bac <__udivdi3+0x8c>
  801b47:	89 fd                	mov    %edi,%ebp
  801b49:	85 ff                	test   %edi,%edi
  801b4b:	75 0b                	jne    801b58 <__udivdi3+0x38>
  801b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b52:	31 d2                	xor    %edx,%edx
  801b54:	f7 f7                	div    %edi
  801b56:	89 c5                	mov    %eax,%ebp
  801b58:	31 d2                	xor    %edx,%edx
  801b5a:	89 c8                	mov    %ecx,%eax
  801b5c:	f7 f5                	div    %ebp
  801b5e:	89 c1                	mov    %eax,%ecx
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	f7 f5                	div    %ebp
  801b64:	89 cf                	mov    %ecx,%edi
  801b66:	89 fa                	mov    %edi,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	39 ce                	cmp    %ecx,%esi
  801b72:	77 28                	ja     801b9c <__udivdi3+0x7c>
  801b74:	0f bd fe             	bsr    %esi,%edi
  801b77:	83 f7 1f             	xor    $0x1f,%edi
  801b7a:	75 40                	jne    801bbc <__udivdi3+0x9c>
  801b7c:	39 ce                	cmp    %ecx,%esi
  801b7e:	72 0a                	jb     801b8a <__udivdi3+0x6a>
  801b80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b84:	0f 87 9e 00 00 00    	ja     801c28 <__udivdi3+0x108>
  801b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8f:	89 fa                	mov    %edi,%edx
  801b91:	83 c4 1c             	add    $0x1c,%esp
  801b94:	5b                   	pop    %ebx
  801b95:	5e                   	pop    %esi
  801b96:	5f                   	pop    %edi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
  801b99:	8d 76 00             	lea    0x0(%esi),%esi
  801b9c:	31 ff                	xor    %edi,%edi
  801b9e:	31 c0                	xor    %eax,%eax
  801ba0:	89 fa                	mov    %edi,%edx
  801ba2:	83 c4 1c             	add    $0x1c,%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5f                   	pop    %edi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	f7 f7                	div    %edi
  801bb0:	31 ff                	xor    %edi,%edi
  801bb2:	89 fa                	mov    %edi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bc1:	89 eb                	mov    %ebp,%ebx
  801bc3:	29 fb                	sub    %edi,%ebx
  801bc5:	89 f9                	mov    %edi,%ecx
  801bc7:	d3 e6                	shl    %cl,%esi
  801bc9:	89 c5                	mov    %eax,%ebp
  801bcb:	88 d9                	mov    %bl,%cl
  801bcd:	d3 ed                	shr    %cl,%ebp
  801bcf:	89 e9                	mov    %ebp,%ecx
  801bd1:	09 f1                	or     %esi,%ecx
  801bd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bd7:	89 f9                	mov    %edi,%ecx
  801bd9:	d3 e0                	shl    %cl,%eax
  801bdb:	89 c5                	mov    %eax,%ebp
  801bdd:	89 d6                	mov    %edx,%esi
  801bdf:	88 d9                	mov    %bl,%cl
  801be1:	d3 ee                	shr    %cl,%esi
  801be3:	89 f9                	mov    %edi,%ecx
  801be5:	d3 e2                	shl    %cl,%edx
  801be7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801beb:	88 d9                	mov    %bl,%cl
  801bed:	d3 e8                	shr    %cl,%eax
  801bef:	09 c2                	or     %eax,%edx
  801bf1:	89 d0                	mov    %edx,%eax
  801bf3:	89 f2                	mov    %esi,%edx
  801bf5:	f7 74 24 0c          	divl   0xc(%esp)
  801bf9:	89 d6                	mov    %edx,%esi
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	f7 e5                	mul    %ebp
  801bff:	39 d6                	cmp    %edx,%esi
  801c01:	72 19                	jb     801c1c <__udivdi3+0xfc>
  801c03:	74 0b                	je     801c10 <__udivdi3+0xf0>
  801c05:	89 d8                	mov    %ebx,%eax
  801c07:	31 ff                	xor    %edi,%edi
  801c09:	e9 58 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c14:	89 f9                	mov    %edi,%ecx
  801c16:	d3 e2                	shl    %cl,%edx
  801c18:	39 c2                	cmp    %eax,%edx
  801c1a:	73 e9                	jae    801c05 <__udivdi3+0xe5>
  801c1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c1f:	31 ff                	xor    %edi,%edi
  801c21:	e9 40 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	31 c0                	xor    %eax,%eax
  801c2a:	e9 37 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c2f:	90                   	nop

00801c30 <__umoddi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c4f:	89 f3                	mov    %esi,%ebx
  801c51:	89 fa                	mov    %edi,%edx
  801c53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c57:	89 34 24             	mov    %esi,(%esp)
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	75 1a                	jne    801c78 <__umoddi3+0x48>
  801c5e:	39 f7                	cmp    %esi,%edi
  801c60:	0f 86 a2 00 00 00    	jbe    801d08 <__umoddi3+0xd8>
  801c66:	89 c8                	mov    %ecx,%eax
  801c68:	89 f2                	mov    %esi,%edx
  801c6a:	f7 f7                	div    %edi
  801c6c:	89 d0                	mov    %edx,%eax
  801c6e:	31 d2                	xor    %edx,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	39 f0                	cmp    %esi,%eax
  801c7a:	0f 87 ac 00 00 00    	ja     801d2c <__umoddi3+0xfc>
  801c80:	0f bd e8             	bsr    %eax,%ebp
  801c83:	83 f5 1f             	xor    $0x1f,%ebp
  801c86:	0f 84 ac 00 00 00    	je     801d38 <__umoddi3+0x108>
  801c8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c91:	29 ef                	sub    %ebp,%edi
  801c93:	89 fe                	mov    %edi,%esi
  801c95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c99:	89 e9                	mov    %ebp,%ecx
  801c9b:	d3 e0                	shl    %cl,%eax
  801c9d:	89 d7                	mov    %edx,%edi
  801c9f:	89 f1                	mov    %esi,%ecx
  801ca1:	d3 ef                	shr    %cl,%edi
  801ca3:	09 c7                	or     %eax,%edi
  801ca5:	89 e9                	mov    %ebp,%ecx
  801ca7:	d3 e2                	shl    %cl,%edx
  801ca9:	89 14 24             	mov    %edx,(%esp)
  801cac:	89 d8                	mov    %ebx,%eax
  801cae:	d3 e0                	shl    %cl,%eax
  801cb0:	89 c2                	mov    %eax,%edx
  801cb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb6:	d3 e0                	shl    %cl,%eax
  801cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc0:	89 f1                	mov    %esi,%ecx
  801cc2:	d3 e8                	shr    %cl,%eax
  801cc4:	09 d0                	or     %edx,%eax
  801cc6:	d3 eb                	shr    %cl,%ebx
  801cc8:	89 da                	mov    %ebx,%edx
  801cca:	f7 f7                	div    %edi
  801ccc:	89 d3                	mov    %edx,%ebx
  801cce:	f7 24 24             	mull   (%esp)
  801cd1:	89 c6                	mov    %eax,%esi
  801cd3:	89 d1                	mov    %edx,%ecx
  801cd5:	39 d3                	cmp    %edx,%ebx
  801cd7:	0f 82 87 00 00 00    	jb     801d64 <__umoddi3+0x134>
  801cdd:	0f 84 91 00 00 00    	je     801d74 <__umoddi3+0x144>
  801ce3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ce7:	29 f2                	sub    %esi,%edx
  801ce9:	19 cb                	sbb    %ecx,%ebx
  801ceb:	89 d8                	mov    %ebx,%eax
  801ced:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cf1:	d3 e0                	shl    %cl,%eax
  801cf3:	89 e9                	mov    %ebp,%ecx
  801cf5:	d3 ea                	shr    %cl,%edx
  801cf7:	09 d0                	or     %edx,%eax
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 eb                	shr    %cl,%ebx
  801cfd:	89 da                	mov    %ebx,%edx
  801cff:	83 c4 1c             	add    $0x1c,%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5f                   	pop    %edi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    
  801d07:	90                   	nop
  801d08:	89 fd                	mov    %edi,%ebp
  801d0a:	85 ff                	test   %edi,%edi
  801d0c:	75 0b                	jne    801d19 <__umoddi3+0xe9>
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	31 d2                	xor    %edx,%edx
  801d15:	f7 f7                	div    %edi
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f5                	div    %ebp
  801d1f:	89 c8                	mov    %ecx,%eax
  801d21:	f7 f5                	div    %ebp
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	e9 44 ff ff ff       	jmp    801c6e <__umoddi3+0x3e>
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	89 c8                	mov    %ecx,%eax
  801d2e:	89 f2                	mov    %esi,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	3b 04 24             	cmp    (%esp),%eax
  801d3b:	72 06                	jb     801d43 <__umoddi3+0x113>
  801d3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d41:	77 0f                	ja     801d52 <__umoddi3+0x122>
  801d43:	89 f2                	mov    %esi,%edx
  801d45:	29 f9                	sub    %edi,%ecx
  801d47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d4b:	89 14 24             	mov    %edx,(%esp)
  801d4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d56:	8b 14 24             	mov    (%esp),%edx
  801d59:	83 c4 1c             	add    $0x1c,%esp
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5f                   	pop    %edi
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    
  801d61:	8d 76 00             	lea    0x0(%esi),%esi
  801d64:	2b 04 24             	sub    (%esp),%eax
  801d67:	19 fa                	sbb    %edi,%edx
  801d69:	89 d1                	mov    %edx,%ecx
  801d6b:	89 c6                	mov    %eax,%esi
  801d6d:	e9 71 ff ff ff       	jmp    801ce3 <__umoddi3+0xb3>
  801d72:	66 90                	xchg   %ax,%ax
  801d74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d78:	72 ea                	jb     801d64 <__umoddi3+0x134>
  801d7a:	89 d9                	mov    %ebx,%ecx
  801d7c:	e9 62 ff ff ff       	jmp    801ce3 <__umoddi3+0xb3>
