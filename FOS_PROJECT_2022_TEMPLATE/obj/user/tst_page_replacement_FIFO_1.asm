
obj/user/tst_page_replacement_FIFO_1:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
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
  80003b:	83 ec 78             	sub    $0x78,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80004e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 40 20 80 00       	push   $0x802040
  800065:	6a 15                	push   $0x15
  800067:	68 84 20 80 00       	push   $0x802084
  80006c:	e8 c0 06 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 40 20 80 00       	push   $0x802040
  80009b:	6a 16                	push   $0x16
  80009d:	68 84 20 80 00       	push   $0x802084
  8000a2:	e8 8a 06 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 40 20 80 00       	push   $0x802040
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 84 20 80 00       	push   $0x802084
  8000d8:	e8 54 06 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 40 20 80 00       	push   $0x802040
  800107:	6a 18                	push   $0x18
  800109:	68 84 20 80 00       	push   $0x802084
  80010e:	e8 1e 06 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800126:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 40 20 80 00       	push   $0x802040
  80013d:	6a 19                	push   $0x19
  80013f:	68 84 20 80 00       	push   $0x802084
  800144:	e8 e8 05 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80015c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 40 20 80 00       	push   $0x802040
  800173:	6a 1a                	push   $0x1a
  800175:	68 84 20 80 00       	push   $0x802084
  80017a:	e8 b2 05 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800194:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 40 20 80 00       	push   $0x802040
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 84 20 80 00       	push   $0x802084
  8001b2:	e8 7a 05 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 40 20 80 00       	push   $0x802040
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 84 20 80 00       	push   $0x802084
  8001ea:	e8 42 05 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800204:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 40 20 80 00       	push   $0x802040
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 84 20 80 00       	push   $0x802084
  800222:	e8 0a 05 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80023c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 40 20 80 00       	push   $0x802040
  800253:	6a 1e                	push   $0x1e
  800255:	68 84 20 80 00       	push   $0x802084
  80025a:	e8 d2 04 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800274:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 40 20 80 00       	push   $0x802040
  80028b:	6a 1f                	push   $0x1f
  80028d:	68 84 20 80 00       	push   $0x802084
  800292:	e8 9a 04 00 00       	call   800731 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 a8 20 80 00       	push   $0x8020a8
  8002ae:	6a 20                	push   $0x20
  8002b0:	68 84 20 80 00       	push   $0x802084
  8002b5:	e8 77 04 00 00       	call   800731 <_panic>
	}


	int freePages = sys_calculate_free_frames();
  8002ba:	e8 9c 15 00 00       	call   80185b <sys_calculate_free_frames>
  8002bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c2:	e8 34 16 00 00       	call   8018fb <sys_pf_calculate_allocated_pages>
  8002c7:	89 45 bc             	mov    %eax,-0x44(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  8002ca:	a0 5f 51 83 00       	mov    0x83515f,%al
  8002cf:	88 45 bb             	mov    %al,-0x45(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  8002d2:	a0 5f 61 83 00       	mov    0x83615f,%al
  8002d7:	88 45 ba             	mov    %al,-0x46(%ebp)
	char garbage4,garbage5;
	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002e1:	eb 26                	jmp    800309 <_main+0x2d1>
	{
		arr[i] = -1 ;
  8002e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e6:	05 60 a1 82 00       	add    $0x82a160,%eax
  8002eb:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8002ee:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f3:	8a 00                	mov    (%eax),%al
  8002f5:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *ptr2 ;
  8002f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002fd:	8a 00                	mov    (%eax),%al
  8002ff:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage1 = arr[PAGE_SIZE*11-1];
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4,garbage5;
	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800302:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  800309:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  800310:	7e d1                	jle    8002e3 <_main+0x2ab>
	}

	//===================
	//cprintf("Checking PAGE FIFO algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800312:	a1 20 30 80 00       	mov    0x803020,%eax
  800317:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80031d:	8b 00                	mov    (%eax),%eax
  80031f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800322:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800325:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032a:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80032f:	74 14                	je     800345 <_main+0x30d>
  800331:	83 ec 04             	sub    $0x4,%esp
  800334:	68 f0 20 80 00       	push   $0x8020f0
  800339:	6a 3c                	push   $0x3c
  80033b:	68 84 20 80 00       	push   $0x802084
  800340:	e8 ec 03 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800345:	a1 20 30 80 00       	mov    0x803020,%eax
  80034a:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800350:	83 c0 18             	add    $0x18,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800358:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80035b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800360:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800365:	74 14                	je     80037b <_main+0x343>
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 f0 20 80 00       	push   $0x8020f0
  80036f:	6a 3d                	push   $0x3d
  800371:	68 84 20 80 00       	push   $0x802084
  800376:	e8 b6 03 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80037b:	a1 20 30 80 00       	mov    0x803020,%eax
  800380:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800386:	83 c0 30             	add    $0x30,%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80038e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800396:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 f0 20 80 00       	push   $0x8020f0
  8003a5:	6a 3e                	push   $0x3e
  8003a7:	68 84 20 80 00       	push   $0x802084
  8003ac:	e8 80 03 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b6:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003bc:	83 c0 48             	add    $0x48,%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8003c4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cc:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8003d1:	74 14                	je     8003e7 <_main+0x3af>
  8003d3:	83 ec 04             	sub    $0x4,%esp
  8003d6:	68 f0 20 80 00       	push   $0x8020f0
  8003db:	6a 3f                	push   $0x3f
  8003dd:	68 84 20 80 00       	push   $0x802084
  8003e2:	e8 4a 03 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003f2:	83 c0 60             	add    $0x60,%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800402:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800407:	74 14                	je     80041d <_main+0x3e5>
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	68 f0 20 80 00       	push   $0x8020f0
  800411:	6a 40                	push   $0x40
  800413:	68 84 20 80 00       	push   $0x802084
  800418:	e8 14 03 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80041d:	a1 20 30 80 00       	mov    0x803020,%eax
  800422:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800428:	83 c0 78             	add    $0x78,%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800430:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800438:	3d 00 70 80 00       	cmp    $0x807000,%eax
  80043d:	74 14                	je     800453 <_main+0x41b>
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	68 f0 20 80 00       	push   $0x8020f0
  800447:	6a 41                	push   $0x41
  800449:	68 84 20 80 00       	push   $0x802084
  80044e:	e8 de 02 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x808000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80045e:	05 90 00 00 00       	add    $0x90,%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800468:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80046b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800470:	3d 00 80 80 00       	cmp    $0x808000,%eax
  800475:	74 14                	je     80048b <_main+0x453>
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	68 f0 20 80 00       	push   $0x8020f0
  80047f:	6a 42                	push   $0x42
  800481:	68 84 20 80 00       	push   $0x802084
  800486:	e8 a6 02 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800496:	05 a8 00 00 00       	add    $0xa8,%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8004a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a8:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8004ad:	74 14                	je     8004c3 <_main+0x48b>
  8004af:	83 ec 04             	sub    $0x4,%esp
  8004b2:	68 f0 20 80 00       	push   $0x8020f0
  8004b7:	6a 43                	push   $0x43
  8004b9:	68 84 20 80 00       	push   $0x802084
  8004be:	e8 6e 02 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c8:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8004ce:	05 c0 00 00 00       	add    $0xc0,%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8004d8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e0:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004e5:	74 14                	je     8004fb <_main+0x4c3>
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	68 f0 20 80 00       	push   $0x8020f0
  8004ef:	6a 44                	push   $0x44
  8004f1:	68 84 20 80 00       	push   $0x802084
  8004f6:	e8 36 02 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800500:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800506:	05 d8 00 00 00       	add    $0xd8,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 90             	mov    %eax,-0x70(%ebp)
  800510:	8b 45 90             	mov    -0x70(%ebp),%eax
  800513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800518:	3d 00 90 80 00       	cmp    $0x809000,%eax
  80051d:	74 14                	je     800533 <_main+0x4fb>
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 f0 20 80 00       	push   $0x8020f0
  800527:	6a 45                	push   $0x45
  800529:	68 84 20 80 00       	push   $0x802084
  80052e:	e8 fe 01 00 00       	call   800731 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800533:	a1 20 30 80 00       	mov    0x803020,%eax
  800538:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80053e:	05 f0 00 00 00       	add    $0xf0,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800548:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80054b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800550:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800555:	74 14                	je     80056b <_main+0x533>
  800557:	83 ec 04             	sub    $0x4,%esp
  80055a:	68 f0 20 80 00       	push   $0x8020f0
  80055f:	6a 46                	push   $0x46
  800561:	68 84 20 80 00       	push   $0x802084
  800566:	e8 c6 01 00 00       	call   800731 <_panic>

		if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");
  80056b:	a1 20 30 80 00       	mov    0x803020,%eax
  800570:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  800576:	83 f8 05             	cmp    $0x5,%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 3c 21 80 00       	push   $0x80213c
  800583:	6a 48                	push   $0x48
  800585:	68 84 20 80 00       	push   $0x802084
  80058a:	e8 a2 01 00 00       	call   800731 <_panic>

	}
	{
		if (garbage4 != *ptr) panic("test failed!");
  80058f:	a1 00 30 80 00       	mov    0x803000,%eax
  800594:	8a 00                	mov    (%eax),%al
  800596:	3a 45 f7             	cmp    -0x9(%ebp),%al
  800599:	74 14                	je     8005af <_main+0x577>
  80059b:	83 ec 04             	sub    $0x4,%esp
  80059e:	68 5b 21 80 00       	push   $0x80215b
  8005a3:	6a 4c                	push   $0x4c
  8005a5:	68 84 20 80 00       	push   $0x802084
  8005aa:	e8 82 01 00 00       	call   800731 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  8005af:	a1 04 30 80 00       	mov    0x803004,%eax
  8005b4:	8a 00                	mov    (%eax),%al
  8005b6:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8005b9:	74 14                	je     8005cf <_main+0x597>
  8005bb:	83 ec 04             	sub    $0x4,%esp
  8005be:	68 5b 21 80 00       	push   $0x80215b
  8005c3:	6a 4d                	push   $0x4d
  8005c5:	68 84 20 80 00       	push   $0x802084
  8005ca:	e8 62 01 00 00       	call   800731 <_panic>
	}
	cprintf("Congratulations!! test PAGE replacement [FIFO 1] is completed successfully.\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 68 21 80 00       	push   $0x802168
  8005d7:	e8 09 04 00 00       	call   8009e5 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
	return;
  8005df:	90                   	nop
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 4e 15 00 00       	call   801b3b <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	01 c0                	add    %eax,%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800600:	01 c8                	add    %ecx,%eax
  800602:	c1 e0 02             	shl    $0x2,%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80060e:	01 c8                	add    %ecx,%eax
  800610:	c1 e0 02             	shl    $0x2,%eax
  800613:	01 d0                	add    %edx,%eax
  800615:	c1 e0 02             	shl    $0x2,%eax
  800618:	01 d0                	add    %edx,%eax
  80061a:	c1 e0 03             	shl    $0x3,%eax
  80061d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800622:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800627:	a1 20 30 80 00       	mov    0x803020,%eax
  80062c:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800632:	84 c0                	test   %al,%al
  800634:	74 0f                	je     800645 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800636:	a1 20 30 80 00       	mov    0x803020,%eax
  80063b:	05 18 da 01 00       	add    $0x1da18,%eax
  800640:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800649:	7e 0a                	jle    800655 <libmain+0x73>
		binaryname = argv[0];
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	ff 75 08             	pushl  0x8(%ebp)
  80065e:	e8 d5 f9 ff ff       	call   800038 <_main>
  800663:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800666:	e8 dd 12 00 00       	call   801948 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	68 d0 21 80 00       	push   $0x8021d0
  800673:	e8 6d 03 00 00       	call   8009e5 <cprintf>
  800678:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80067b:	a1 20 30 80 00       	mov    0x803020,%eax
  800680:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800686:	a1 20 30 80 00       	mov    0x803020,%eax
  80068b:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800691:	83 ec 04             	sub    $0x4,%esp
  800694:	52                   	push   %edx
  800695:	50                   	push   %eax
  800696:	68 f8 21 80 00       	push   $0x8021f8
  80069b:	e8 45 03 00 00       	call   8009e5 <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a8:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8006ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b3:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8006b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8006be:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	68 20 22 80 00       	push   $0x802220
  8006cc:	e8 14 03 00 00       	call   8009e5 <cprintf>
  8006d1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8006d9:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	50                   	push   %eax
  8006e3:	68 78 22 80 00       	push   $0x802278
  8006e8:	e8 f8 02 00 00       	call   8009e5 <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	68 d0 21 80 00       	push   $0x8021d0
  8006f8:	e8 e8 02 00 00       	call   8009e5 <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800700:	e8 5d 12 00 00       	call   801962 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800705:	e8 19 00 00 00       	call   800723 <exit>
}
  80070a:	90                   	nop
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	6a 00                	push   $0x0
  800718:	e8 ea 13 00 00       	call   801b07 <sys_destroy_env>
  80071d:	83 c4 10             	add    $0x10,%esp
}
  800720:	90                   	nop
  800721:	c9                   	leave  
  800722:	c3                   	ret    

00800723 <exit>:

void
exit(void)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800729:	e8 3f 14 00 00       	call   801b6d <sys_exit_env>
}
  80072e:	90                   	nop
  80072f:	c9                   	leave  
  800730:	c3                   	ret    

00800731 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800737:	8d 45 10             	lea    0x10(%ebp),%eax
  80073a:	83 c0 04             	add    $0x4,%eax
  80073d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800740:	a1 58 62 83 00       	mov    0x836258,%eax
  800745:	85 c0                	test   %eax,%eax
  800747:	74 16                	je     80075f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800749:	a1 58 62 83 00       	mov    0x836258,%eax
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	50                   	push   %eax
  800752:	68 8c 22 80 00       	push   $0x80228c
  800757:	e8 89 02 00 00       	call   8009e5 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80075f:	a1 08 30 80 00       	mov    0x803008,%eax
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	50                   	push   %eax
  80076b:	68 91 22 80 00       	push   $0x802291
  800770:	e8 70 02 00 00       	call   8009e5 <cprintf>
  800775:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 f4             	pushl  -0xc(%ebp)
  800781:	50                   	push   %eax
  800782:	e8 f3 01 00 00       	call   80097a <vcprintf>
  800787:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	6a 00                	push   $0x0
  80078f:	68 ad 22 80 00       	push   $0x8022ad
  800794:	e8 e1 01 00 00       	call   80097a <vcprintf>
  800799:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80079c:	e8 82 ff ff ff       	call   800723 <exit>

	// should not return here
	while (1) ;
  8007a1:	eb fe                	jmp    8007a1 <_panic+0x70>

008007a3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ae:	8b 50 74             	mov    0x74(%eax),%edx
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 14                	je     8007cc <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 b0 22 80 00       	push   $0x8022b0
  8007c0:	6a 26                	push   $0x26
  8007c2:	68 fc 22 80 00       	push   $0x8022fc
  8007c7:	e8 65 ff ff ff       	call   800731 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007da:	e9 c2 00 00 00       	jmp    8008a1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	01 d0                	add    %edx,%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	75 08                	jne    8007fc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007f4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007f7:	e9 a2 00 00 00       	jmp    80089e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800803:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80080a:	eb 69                	jmp    800875 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80080c:	a1 20 30 80 00       	mov    0x803020,%eax
  800811:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800817:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80081a:	89 d0                	mov    %edx,%eax
  80081c:	01 c0                	add    %eax,%eax
  80081e:	01 d0                	add    %edx,%eax
  800820:	c1 e0 03             	shl    $0x3,%eax
  800823:	01 c8                	add    %ecx,%eax
  800825:	8a 40 04             	mov    0x4(%eax),%al
  800828:	84 c0                	test   %al,%al
  80082a:	75 46                	jne    800872 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80082c:	a1 20 30 80 00       	mov    0x803020,%eax
  800831:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800837:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80083a:	89 d0                	mov    %edx,%eax
  80083c:	01 c0                	add    %eax,%eax
  80083e:	01 d0                	add    %edx,%eax
  800840:	c1 e0 03             	shl    $0x3,%eax
  800843:	01 c8                	add    %ecx,%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80084a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80084d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800852:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800857:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	01 c8                	add    %ecx,%eax
  800863:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800865:	39 c2                	cmp    %eax,%edx
  800867:	75 09                	jne    800872 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800869:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800870:	eb 12                	jmp    800884 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800872:	ff 45 e8             	incl   -0x18(%ebp)
  800875:	a1 20 30 80 00       	mov    0x803020,%eax
  80087a:	8b 50 74             	mov    0x74(%eax),%edx
  80087d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800880:	39 c2                	cmp    %eax,%edx
  800882:	77 88                	ja     80080c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800884:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800888:	75 14                	jne    80089e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80088a:	83 ec 04             	sub    $0x4,%esp
  80088d:	68 08 23 80 00       	push   $0x802308
  800892:	6a 3a                	push   $0x3a
  800894:	68 fc 22 80 00       	push   $0x8022fc
  800899:	e8 93 fe ff ff       	call   800731 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80089e:	ff 45 f0             	incl   -0x10(%ebp)
  8008a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008a7:	0f 8c 32 ff ff ff    	jl     8007df <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008bb:	eb 26                	jmp    8008e3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8008c2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008cb:	89 d0                	mov    %edx,%eax
  8008cd:	01 c0                	add    %eax,%eax
  8008cf:	01 d0                	add    %edx,%eax
  8008d1:	c1 e0 03             	shl    $0x3,%eax
  8008d4:	01 c8                	add    %ecx,%eax
  8008d6:	8a 40 04             	mov    0x4(%eax),%al
  8008d9:	3c 01                	cmp    $0x1,%al
  8008db:	75 03                	jne    8008e0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008dd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e0:	ff 45 e0             	incl   -0x20(%ebp)
  8008e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8008e8:	8b 50 74             	mov    0x74(%eax),%edx
  8008eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ee:	39 c2                	cmp    %eax,%edx
  8008f0:	77 cb                	ja     8008bd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008f8:	74 14                	je     80090e <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008fa:	83 ec 04             	sub    $0x4,%esp
  8008fd:	68 5c 23 80 00       	push   $0x80235c
  800902:	6a 44                	push   $0x44
  800904:	68 fc 22 80 00       	push   $0x8022fc
  800909:	e8 23 fe ff ff       	call   800731 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80090e:	90                   	nop
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8d 48 01             	lea    0x1(%eax),%ecx
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 0a                	mov    %ecx,(%edx)
  800924:	8b 55 08             	mov    0x8(%ebp),%edx
  800927:	88 d1                	mov    %dl,%cl
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	3d ff 00 00 00       	cmp    $0xff,%eax
  80093a:	75 2c                	jne    800968 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80093c:	a0 24 30 80 00       	mov    0x803024,%al
  800941:	0f b6 c0             	movzbl %al,%eax
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	8b 12                	mov    (%edx),%edx
  800949:	89 d1                	mov    %edx,%ecx
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	83 c2 08             	add    $0x8,%edx
  800951:	83 ec 04             	sub    $0x4,%esp
  800954:	50                   	push   %eax
  800955:	51                   	push   %ecx
  800956:	52                   	push   %edx
  800957:	e8 3e 0e 00 00       	call   80179a <sys_cputs>
  80095c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	8b 40 04             	mov    0x4(%eax),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	89 50 04             	mov    %edx,0x4(%eax)
}
  800977:	90                   	nop
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800983:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80098a:	00 00 00 
	b.cnt = 0;
  80098d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800994:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	68 11 09 80 00       	push   $0x800911
  8009a9:	e8 11 02 00 00       	call   800bbf <vprintfmt>
  8009ae:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009b1:	a0 24 30 80 00       	mov    0x803024,%al
  8009b6:	0f b6 c0             	movzbl %al,%eax
  8009b9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009bf:	83 ec 04             	sub    $0x4,%esp
  8009c2:	50                   	push   %eax
  8009c3:	52                   	push   %edx
  8009c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ca:	83 c0 08             	add    $0x8,%eax
  8009cd:	50                   	push   %eax
  8009ce:	e8 c7 0d 00 00       	call   80179a <sys_cputs>
  8009d3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009d6:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009eb:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	50                   	push   %eax
  800a02:	e8 73 ff ff ff       	call   80097a <vcprintf>
  800a07:	83 c4 10             	add    $0x10,%esp
  800a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a18:	e8 2b 0f 00 00       	call   801948 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a1d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2c:	50                   	push   %eax
  800a2d:	e8 48 ff ff ff       	call   80097a <vcprintf>
  800a32:	83 c4 10             	add    $0x10,%esp
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a38:	e8 25 0f 00 00       	call   801962 <sys_enable_interrupt>
	return cnt;
  800a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	83 ec 14             	sub    $0x14,%esp
  800a49:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a55:	8b 45 18             	mov    0x18(%ebp),%eax
  800a58:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a60:	77 55                	ja     800ab7 <printnum+0x75>
  800a62:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a65:	72 05                	jb     800a6c <printnum+0x2a>
  800a67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a6a:	77 4b                	ja     800ab7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a6c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a6f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a72:	8b 45 18             	mov    0x18(%ebp),%eax
  800a75:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7a:	52                   	push   %edx
  800a7b:	50                   	push   %eax
  800a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a82:	e8 49 13 00 00       	call   801dd0 <__udivdi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	83 ec 04             	sub    $0x4,%esp
  800a8d:	ff 75 20             	pushl  0x20(%ebp)
  800a90:	53                   	push   %ebx
  800a91:	ff 75 18             	pushl  0x18(%ebp)
  800a94:	52                   	push   %edx
  800a95:	50                   	push   %eax
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 a1 ff ff ff       	call   800a42 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
  800aa4:	eb 1a                	jmp    800ac0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 20             	pushl  0x20(%ebp)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ab7:	ff 4d 1c             	decl   0x1c(%ebp)
  800aba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800abe:	7f e6                	jg     800aa6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ac0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ac3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ace:	53                   	push   %ebx
  800acf:	51                   	push   %ecx
  800ad0:	52                   	push   %edx
  800ad1:	50                   	push   %eax
  800ad2:	e8 09 14 00 00       	call   801ee0 <__umoddi3>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	05 d4 25 80 00       	add    $0x8025d4,%eax
  800adf:	8a 00                	mov    (%eax),%al
  800ae1:	0f be c0             	movsbl %al,%eax
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	50                   	push   %eax
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
}
  800af3:	90                   	nop
  800af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800afc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b00:	7e 1c                	jle    800b1e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	8d 50 08             	lea    0x8(%eax),%edx
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	89 10                	mov    %edx,(%eax)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 00                	mov    (%eax),%eax
  800b14:	83 e8 08             	sub    $0x8,%eax
  800b17:	8b 50 04             	mov    0x4(%eax),%edx
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	eb 40                	jmp    800b5e <getuint+0x65>
	else if (lflag)
  800b1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b22:	74 1e                	je     800b42 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	8d 50 04             	lea    0x4(%eax),%edx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	89 10                	mov    %edx,(%eax)
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	83 e8 04             	sub    $0x4,%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	eb 1c                	jmp    800b5e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	8d 50 04             	lea    0x4(%eax),%edx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 10                	mov    %edx,(%eax)
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	83 e8 04             	sub    $0x4,%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b63:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b67:	7e 1c                	jle    800b85 <getint+0x25>
		return va_arg(*ap, long long);
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	8d 50 08             	lea    0x8(%eax),%edx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	89 10                	mov    %edx,(%eax)
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	83 e8 08             	sub    $0x8,%eax
  800b7e:	8b 50 04             	mov    0x4(%eax),%edx
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	eb 38                	jmp    800bbd <getint+0x5d>
	else if (lflag)
  800b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b89:	74 1a                	je     800ba5 <getint+0x45>
		return va_arg(*ap, long);
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	8d 50 04             	lea    0x4(%eax),%edx
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	89 10                	mov    %edx,(%eax)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	83 e8 04             	sub    $0x4,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	99                   	cltd   
  800ba3:	eb 18                	jmp    800bbd <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	8d 50 04             	lea    0x4(%eax),%edx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	89 10                	mov    %edx,(%eax)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	83 e8 04             	sub    $0x4,%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	99                   	cltd   
}
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc7:	eb 17                	jmp    800be0 <vprintfmt+0x21>
			if (ch == '\0')
  800bc9:	85 db                	test   %ebx,%ebx
  800bcb:	0f 84 af 03 00 00    	je     800f80 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	8d 50 01             	lea    0x1(%eax),%edx
  800be6:	89 55 10             	mov    %edx,0x10(%ebp)
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	0f b6 d8             	movzbl %al,%ebx
  800bee:	83 fb 25             	cmp    $0x25,%ebx
  800bf1:	75 d6                	jne    800bc9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bf3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bf7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bfe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c13:	8b 45 10             	mov    0x10(%ebp),%eax
  800c16:	8d 50 01             	lea    0x1(%eax),%edx
  800c19:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	0f b6 d8             	movzbl %al,%ebx
  800c21:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c24:	83 f8 55             	cmp    $0x55,%eax
  800c27:	0f 87 2b 03 00 00    	ja     800f58 <vprintfmt+0x399>
  800c2d:	8b 04 85 f8 25 80 00 	mov    0x8025f8(,%eax,4),%eax
  800c34:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c36:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c3a:	eb d7                	jmp    800c13 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c3c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c40:	eb d1                	jmp    800c13 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4c:	89 d0                	mov    %edx,%eax
  800c4e:	c1 e0 02             	shl    $0x2,%eax
  800c51:	01 d0                	add    %edx,%eax
  800c53:	01 c0                	add    %eax,%eax
  800c55:	01 d8                	add    %ebx,%eax
  800c57:	83 e8 30             	sub    $0x30,%eax
  800c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c65:	83 fb 2f             	cmp    $0x2f,%ebx
  800c68:	7e 3e                	jle    800ca8 <vprintfmt+0xe9>
  800c6a:	83 fb 39             	cmp    $0x39,%ebx
  800c6d:	7f 39                	jg     800ca8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c72:	eb d5                	jmp    800c49 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c88:	eb 1f                	jmp    800ca9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8e:	79 83                	jns    800c13 <vprintfmt+0x54>
				width = 0;
  800c90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c97:	e9 77 ff ff ff       	jmp    800c13 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c9c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ca3:	e9 6b ff ff ff       	jmp    800c13 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ca8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ca9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cad:	0f 89 60 ff ff ff    	jns    800c13 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cc0:	e9 4e ff ff ff       	jmp    800c13 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cc5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cc8:	e9 46 ff ff ff       	jmp    800c13 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	50                   	push   %eax
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	ff d0                	call   *%eax
  800cea:	83 c4 10             	add    $0x10,%esp
			break;
  800ced:	e9 89 02 00 00       	jmp    800f7b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 c0 04             	add    $0x4,%eax
  800cf8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 e8 04             	sub    $0x4,%eax
  800d01:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d03:	85 db                	test   %ebx,%ebx
  800d05:	79 02                	jns    800d09 <vprintfmt+0x14a>
				err = -err;
  800d07:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d09:	83 fb 64             	cmp    $0x64,%ebx
  800d0c:	7f 0b                	jg     800d19 <vprintfmt+0x15a>
  800d0e:	8b 34 9d 40 24 80 00 	mov    0x802440(,%ebx,4),%esi
  800d15:	85 f6                	test   %esi,%esi
  800d17:	75 19                	jne    800d32 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d19:	53                   	push   %ebx
  800d1a:	68 e5 25 80 00       	push   $0x8025e5
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	ff 75 08             	pushl  0x8(%ebp)
  800d25:	e8 5e 02 00 00       	call   800f88 <printfmt>
  800d2a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d2d:	e9 49 02 00 00       	jmp    800f7b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d32:	56                   	push   %esi
  800d33:	68 ee 25 80 00       	push   $0x8025ee
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	ff 75 08             	pushl  0x8(%ebp)
  800d3e:	e8 45 02 00 00       	call   800f88 <printfmt>
  800d43:	83 c4 10             	add    $0x10,%esp
			break;
  800d46:	e9 30 02 00 00       	jmp    800f7b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	83 c0 04             	add    $0x4,%eax
  800d51:	89 45 14             	mov    %eax,0x14(%ebp)
  800d54:	8b 45 14             	mov    0x14(%ebp),%eax
  800d57:	83 e8 04             	sub    $0x4,%eax
  800d5a:	8b 30                	mov    (%eax),%esi
  800d5c:	85 f6                	test   %esi,%esi
  800d5e:	75 05                	jne    800d65 <vprintfmt+0x1a6>
				p = "(null)";
  800d60:	be f1 25 80 00       	mov    $0x8025f1,%esi
			if (width > 0 && padc != '-')
  800d65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d69:	7e 6d                	jle    800dd8 <vprintfmt+0x219>
  800d6b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d6f:	74 67                	je     800dd8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	50                   	push   %eax
  800d78:	56                   	push   %esi
  800d79:	e8 0c 03 00 00       	call   80108a <strnlen>
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d84:	eb 16                	jmp    800d9c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d86:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	50                   	push   %eax
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	ff d0                	call   *%eax
  800d96:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	ff 4d e4             	decl   -0x1c(%ebp)
  800d9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da0:	7f e4                	jg     800d86 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da2:	eb 34                	jmp    800dd8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800da4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800da8:	74 1c                	je     800dc6 <vprintfmt+0x207>
  800daa:	83 fb 1f             	cmp    $0x1f,%ebx
  800dad:	7e 05                	jle    800db4 <vprintfmt+0x1f5>
  800daf:	83 fb 7e             	cmp    $0x7e,%ebx
  800db2:	7e 12                	jle    800dc6 <vprintfmt+0x207>
					putch('?', putdat);
  800db4:	83 ec 08             	sub    $0x8,%esp
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	6a 3f                	push   $0x3f
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	ff d0                	call   *%eax
  800dc1:	83 c4 10             	add    $0x10,%esp
  800dc4:	eb 0f                	jmp    800dd5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	53                   	push   %ebx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	ff d0                	call   *%eax
  800dd2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd5:	ff 4d e4             	decl   -0x1c(%ebp)
  800dd8:	89 f0                	mov    %esi,%eax
  800dda:	8d 70 01             	lea    0x1(%eax),%esi
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f be d8             	movsbl %al,%ebx
  800de2:	85 db                	test   %ebx,%ebx
  800de4:	74 24                	je     800e0a <vprintfmt+0x24b>
  800de6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dea:	78 b8                	js     800da4 <vprintfmt+0x1e5>
  800dec:	ff 4d e0             	decl   -0x20(%ebp)
  800def:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df3:	79 af                	jns    800da4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df5:	eb 13                	jmp    800e0a <vprintfmt+0x24b>
				putch(' ', putdat);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	ff 75 0c             	pushl  0xc(%ebp)
  800dfd:	6a 20                	push   $0x20
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	ff d0                	call   *%eax
  800e04:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e07:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0e:	7f e7                	jg     800df7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e10:	e9 66 01 00 00       	jmp    800f7b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1e:	50                   	push   %eax
  800e1f:	e8 3c fd ff ff       	call   800b60 <getint>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e33:	85 d2                	test   %edx,%edx
  800e35:	79 23                	jns    800e5a <vprintfmt+0x29b>
				putch('-', putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	6a 2d                	push   $0x2d
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	ff d0                	call   *%eax
  800e44:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4d:	f7 d8                	neg    %eax
  800e4f:	83 d2 00             	adc    $0x0,%edx
  800e52:	f7 da                	neg    %edx
  800e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e61:	e9 bc 00 00 00       	jmp    800f22 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6f:	50                   	push   %eax
  800e70:	e8 84 fc ff ff       	call   800af9 <getuint>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e85:	e9 98 00 00 00       	jmp    800f22 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e8a:	83 ec 08             	sub    $0x8,%esp
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	6a 58                	push   $0x58
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	ff d0                	call   *%eax
  800e97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	6a 58                	push   $0x58
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	ff d0                	call   *%eax
  800ea7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eaa:	83 ec 08             	sub    $0x8,%esp
  800ead:	ff 75 0c             	pushl  0xc(%ebp)
  800eb0:	6a 58                	push   $0x58
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	ff d0                	call   *%eax
  800eb7:	83 c4 10             	add    $0x10,%esp
			break;
  800eba:	e9 bc 00 00 00       	jmp    800f7b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ebf:	83 ec 08             	sub    $0x8,%esp
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	6a 30                	push   $0x30
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	ff d0                	call   *%eax
  800ecc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	ff 75 0c             	pushl  0xc(%ebp)
  800ed5:	6a 78                	push   $0x78
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	ff d0                	call   *%eax
  800edc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800edf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee2:	83 c0 04             	add    $0x4,%eax
  800ee5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eeb:	83 e8 04             	sub    $0x4,%eax
  800eee:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800efa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f01:	eb 1f                	jmp    800f22 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	ff 75 e8             	pushl  -0x18(%ebp)
  800f09:	8d 45 14             	lea    0x14(%ebp),%eax
  800f0c:	50                   	push   %eax
  800f0d:	e8 e7 fb ff ff       	call   800af9 <getuint>
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f22:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f29:	83 ec 04             	sub    $0x4,%esp
  800f2c:	52                   	push   %edx
  800f2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f30:	50                   	push   %eax
  800f31:	ff 75 f4             	pushl  -0xc(%ebp)
  800f34:	ff 75 f0             	pushl  -0x10(%ebp)
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	ff 75 08             	pushl  0x8(%ebp)
  800f3d:	e8 00 fb ff ff       	call   800a42 <printnum>
  800f42:	83 c4 20             	add    $0x20,%esp
			break;
  800f45:	eb 34                	jmp    800f7b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f47:	83 ec 08             	sub    $0x8,%esp
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	53                   	push   %ebx
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	ff d0                	call   *%eax
  800f53:	83 c4 10             	add    $0x10,%esp
			break;
  800f56:	eb 23                	jmp    800f7b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f58:	83 ec 08             	sub    $0x8,%esp
  800f5b:	ff 75 0c             	pushl  0xc(%ebp)
  800f5e:	6a 25                	push   $0x25
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	ff d0                	call   *%eax
  800f65:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	eb 03                	jmp    800f70 <vprintfmt+0x3b1>
  800f6d:	ff 4d 10             	decl   0x10(%ebp)
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	48                   	dec    %eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 25                	cmp    $0x25,%al
  800f78:	75 f3                	jne    800f6d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f7a:	90                   	nop
		}
	}
  800f7b:	e9 47 fc ff ff       	jmp    800bc7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f80:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f91:	83 c0 04             	add    $0x4,%eax
  800f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9d:	50                   	push   %eax
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 16 fc ff ff       	call   800bbf <vprintfmt>
  800fa9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fac:	90                   	nop
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8b 40 08             	mov    0x8(%eax),%eax
  800fb8:	8d 50 01             	lea    0x1(%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	8b 10                	mov    (%eax),%edx
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	8b 40 04             	mov    0x4(%eax),%eax
  800fcc:	39 c2                	cmp    %eax,%edx
  800fce:	73 12                	jae    800fe2 <sprintputch+0x33>
		*b->buf++ = ch;
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	8b 00                	mov    (%eax),%eax
  800fd5:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdb:	89 0a                	mov    %ecx,(%edx)
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	88 10                	mov    %dl,(%eax)
}
  800fe2:	90                   	nop
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100a:	74 06                	je     801012 <vsnprintf+0x2d>
  80100c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801010:	7f 07                	jg     801019 <vsnprintf+0x34>
		return -E_INVAL;
  801012:	b8 03 00 00 00       	mov    $0x3,%eax
  801017:	eb 20                	jmp    801039 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801019:	ff 75 14             	pushl  0x14(%ebp)
  80101c:	ff 75 10             	pushl  0x10(%ebp)
  80101f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801022:	50                   	push   %eax
  801023:	68 af 0f 80 00       	push   $0x800faf
  801028:	e8 92 fb ff ff       	call   800bbf <vprintfmt>
  80102d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801033:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801036:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801041:	8d 45 10             	lea    0x10(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	ff 75 f4             	pushl  -0xc(%ebp)
  801050:	50                   	push   %eax
  801051:	ff 75 0c             	pushl  0xc(%ebp)
  801054:	ff 75 08             	pushl  0x8(%ebp)
  801057:	e8 89 ff ff ff       	call   800fe5 <vsnprintf>
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80106d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801074:	eb 06                	jmp    80107c <strlen+0x15>
		n++;
  801076:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801079:	ff 45 08             	incl   0x8(%ebp)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	84 c0                	test   %al,%al
  801083:	75 f1                	jne    801076 <strlen+0xf>
		n++;
	return n;
  801085:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801097:	eb 09                	jmp    8010a2 <strnlen+0x18>
		n++;
  801099:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109c:	ff 45 08             	incl   0x8(%ebp)
  80109f:	ff 4d 0c             	decl   0xc(%ebp)
  8010a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a6:	74 09                	je     8010b1 <strnlen+0x27>
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	84 c0                	test   %al,%al
  8010af:	75 e8                	jne    801099 <strnlen+0xf>
		n++;
	return n;
  8010b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010c2:	90                   	nop
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d5:	8a 12                	mov    (%edx),%dl
  8010d7:	88 10                	mov    %dl,(%eax)
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	84 c0                	test   %al,%al
  8010dd:	75 e4                	jne    8010c3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f7:	eb 1f                	jmp    801118 <strncpy+0x34>
		*dst++ = *src;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8d 50 01             	lea    0x1(%eax),%edx
  8010ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801102:	8b 55 0c             	mov    0xc(%ebp),%edx
  801105:	8a 12                	mov    (%edx),%dl
  801107:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	84 c0                	test   %al,%al
  801110:	74 03                	je     801115 <strncpy+0x31>
			src++;
  801112:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801115:	ff 45 fc             	incl   -0x4(%ebp)
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	72 d9                	jb     8010f9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801120:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	74 30                	je     801167 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801137:	eb 16                	jmp    80114f <strlcpy+0x2a>
			*dst++ = *src++;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 08             	mov    %edx,0x8(%ebp)
  801142:	8b 55 0c             	mov    0xc(%ebp),%edx
  801145:	8d 4a 01             	lea    0x1(%edx),%ecx
  801148:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80114b:	8a 12                	mov    (%edx),%dl
  80114d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80114f:	ff 4d 10             	decl   0x10(%ebp)
  801152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801156:	74 09                	je     801161 <strlcpy+0x3c>
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	84 c0                	test   %al,%al
  80115f:	75 d8                	jne    801139 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	29 c2                	sub    %eax,%edx
  80116f:	89 d0                	mov    %edx,%eax
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801176:	eb 06                	jmp    80117e <strcmp+0xb>
		p++, q++;
  801178:	ff 45 08             	incl   0x8(%ebp)
  80117b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	84 c0                	test   %al,%al
  801185:	74 0e                	je     801195 <strcmp+0x22>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 10                	mov    (%eax),%dl
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	38 c2                	cmp    %al,%dl
  801193:	74 e3                	je     801178 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f b6 d0             	movzbl %al,%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f b6 c0             	movzbl %al,%eax
  8011a5:	29 c2                	sub    %eax,%edx
  8011a7:	89 d0                	mov    %edx,%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011ae:	eb 09                	jmp    8011b9 <strncmp+0xe>
		n--, p++, q++;
  8011b0:	ff 4d 10             	decl   0x10(%ebp)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bd:	74 17                	je     8011d6 <strncmp+0x2b>
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	84 c0                	test   %al,%al
  8011c6:	74 0e                	je     8011d6 <strncmp+0x2b>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 10                	mov    (%eax),%dl
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	38 c2                	cmp    %al,%dl
  8011d4:	74 da                	je     8011b0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011da:	75 07                	jne    8011e3 <strncmp+0x38>
		return 0;
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	eb 14                	jmp    8011f7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	0f b6 d0             	movzbl %al,%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f b6 c0             	movzbl %al,%eax
  8011f3:	29 c2                	sub    %eax,%edx
  8011f5:	89 d0                	mov    %edx,%eax
}
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801205:	eb 12                	jmp    801219 <strchr+0x20>
		if (*s == c)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80120f:	75 05                	jne    801216 <strchr+0x1d>
			return (char *) s;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	eb 11                	jmp    801227 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801216:	ff 45 08             	incl   0x8(%ebp)
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	84 c0                	test   %al,%al
  801220:	75 e5                	jne    801207 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801235:	eb 0d                	jmp    801244 <strfind+0x1b>
		if (*s == c)
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80123f:	74 0e                	je     80124f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	84 c0                	test   %al,%al
  80124b:	75 ea                	jne    801237 <strfind+0xe>
  80124d:	eb 01                	jmp    801250 <strfind+0x27>
		if (*s == c)
			break;
  80124f:	90                   	nop
	return (char *) s;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801267:	eb 0e                	jmp    801277 <memset+0x22>
		*p++ = c;
  801269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126c:	8d 50 01             	lea    0x1(%eax),%edx
  80126f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801272:	8b 55 0c             	mov    0xc(%ebp),%edx
  801275:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801277:	ff 4d f8             	decl   -0x8(%ebp)
  80127a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80127e:	79 e9                	jns    801269 <memset+0x14>
		*p++ = c;

	return v;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801297:	eb 16                	jmp    8012af <memcpy+0x2a>
		*d++ = *s++;
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	8d 50 01             	lea    0x1(%eax),%edx
  80129f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012ab:	8a 12                	mov    (%edx),%dl
  8012ad:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	75 dd                	jne    801299 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d9:	73 50                	jae    80132b <memmove+0x6a>
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012e6:	76 43                	jbe    80132b <memmove+0x6a>
		s += n;
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012f4:	eb 10                	jmp    801306 <memmove+0x45>
			*--d = *--s;
  8012f6:	ff 4d f8             	decl   -0x8(%ebp)
  8012f9:	ff 4d fc             	decl   -0x4(%ebp)
  8012fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ff:	8a 10                	mov    (%eax),%dl
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130c:	89 55 10             	mov    %edx,0x10(%ebp)
  80130f:	85 c0                	test   %eax,%eax
  801311:	75 e3                	jne    8012f6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801313:	eb 23                	jmp    801338 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801318:	8d 50 01             	lea    0x1(%eax),%edx
  80131b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801321:	8d 4a 01             	lea    0x1(%edx),%ecx
  801324:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801327:	8a 12                	mov    (%edx),%dl
  801329:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 dd                	jne    801315 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80134f:	eb 2a                	jmp    80137b <memcmp+0x3e>
		if (*s1 != *s2)
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801354:	8a 10                	mov    (%eax),%dl
  801356:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	38 c2                	cmp    %al,%dl
  80135d:	74 16                	je     801375 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 d0             	movzbl %al,%edx
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f b6 c0             	movzbl %al,%eax
  80136f:	29 c2                	sub    %eax,%edx
  801371:	89 d0                	mov    %edx,%eax
  801373:	eb 18                	jmp    80138d <memcmp+0x50>
		s1++, s2++;
  801375:	ff 45 fc             	incl   -0x4(%ebp)
  801378:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801381:	89 55 10             	mov    %edx,0x10(%ebp)
  801384:	85 c0                	test   %eax,%eax
  801386:	75 c9                	jne    801351 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801395:	8b 55 08             	mov    0x8(%ebp),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 d0                	add    %edx,%eax
  80139d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013a0:	eb 15                	jmp    8013b7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f b6 d0             	movzbl %al,%edx
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	0f b6 c0             	movzbl %al,%eax
  8013b0:	39 c2                	cmp    %eax,%edx
  8013b2:	74 0d                	je     8013c1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013b4:	ff 45 08             	incl   0x8(%ebp)
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013bd:	72 e3                	jb     8013a2 <memfind+0x13>
  8013bf:	eb 01                	jmp    8013c2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013c1:	90                   	nop
	return (void *) s;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013db:	eb 03                	jmp    8013e0 <strtol+0x19>
		s++;
  8013dd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	3c 20                	cmp    $0x20,%al
  8013e7:	74 f4                	je     8013dd <strtol+0x16>
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 09                	cmp    $0x9,%al
  8013f0:	74 eb                	je     8013dd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 2b                	cmp    $0x2b,%al
  8013f9:	75 05                	jne    801400 <strtol+0x39>
		s++;
  8013fb:	ff 45 08             	incl   0x8(%ebp)
  8013fe:	eb 13                	jmp    801413 <strtol+0x4c>
	else if (*s == '-')
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	3c 2d                	cmp    $0x2d,%al
  801407:	75 0a                	jne    801413 <strtol+0x4c>
		s++, neg = 1;
  801409:	ff 45 08             	incl   0x8(%ebp)
  80140c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801413:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801417:	74 06                	je     80141f <strtol+0x58>
  801419:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80141d:	75 20                	jne    80143f <strtol+0x78>
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	3c 30                	cmp    $0x30,%al
  801426:	75 17                	jne    80143f <strtol+0x78>
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	40                   	inc    %eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 78                	cmp    $0x78,%al
  801430:	75 0d                	jne    80143f <strtol+0x78>
		s += 2, base = 16;
  801432:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801436:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80143d:	eb 28                	jmp    801467 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80143f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801443:	75 15                	jne    80145a <strtol+0x93>
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	3c 30                	cmp    $0x30,%al
  80144c:	75 0c                	jne    80145a <strtol+0x93>
		s++, base = 8;
  80144e:	ff 45 08             	incl   0x8(%ebp)
  801451:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801458:	eb 0d                	jmp    801467 <strtol+0xa0>
	else if (base == 0)
  80145a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145e:	75 07                	jne    801467 <strtol+0xa0>
		base = 10;
  801460:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	3c 2f                	cmp    $0x2f,%al
  80146e:	7e 19                	jle    801489 <strtol+0xc2>
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 39                	cmp    $0x39,%al
  801477:	7f 10                	jg     801489 <strtol+0xc2>
			dig = *s - '0';
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f be c0             	movsbl %al,%eax
  801481:	83 e8 30             	sub    $0x30,%eax
  801484:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801487:	eb 42                	jmp    8014cb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 60                	cmp    $0x60,%al
  801490:	7e 19                	jle    8014ab <strtol+0xe4>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	3c 7a                	cmp    $0x7a,%al
  801499:	7f 10                	jg     8014ab <strtol+0xe4>
			dig = *s - 'a' + 10;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	83 e8 57             	sub    $0x57,%eax
  8014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a9:	eb 20                	jmp    8014cb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 40                	cmp    $0x40,%al
  8014b2:	7e 39                	jle    8014ed <strtol+0x126>
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 5a                	cmp    $0x5a,%al
  8014bb:	7f 30                	jg     8014ed <strtol+0x126>
			dig = *s - 'A' + 10;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	83 e8 37             	sub    $0x37,%eax
  8014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014d1:	7d 19                	jge    8014ec <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014d3:	ff 45 08             	incl   0x8(%ebp)
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014dd:	89 c2                	mov    %eax,%edx
  8014df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014e7:	e9 7b ff ff ff       	jmp    801467 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ec:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f1:	74 08                	je     8014fb <strtol+0x134>
		*endptr = (char *) s;
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ff:	74 07                	je     801508 <strtol+0x141>
  801501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801504:	f7 d8                	neg    %eax
  801506:	eb 03                	jmp    80150b <strtol+0x144>
  801508:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <ltostr>:

void
ltostr(long value, char *str)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801513:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80151a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801525:	79 13                	jns    80153a <ltostr+0x2d>
	{
		neg = 1;
  801527:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801534:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801537:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801542:	99                   	cltd   
  801543:	f7 f9                	idiv   %ecx
  801545:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801548:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801551:	89 c2                	mov    %eax,%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	01 d0                	add    %edx,%eax
  801558:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80155b:	83 c2 30             	add    $0x30,%edx
  80155e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801563:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801568:	f7 e9                	imul   %ecx
  80156a:	c1 fa 02             	sar    $0x2,%edx
  80156d:	89 c8                	mov    %ecx,%eax
  80156f:	c1 f8 1f             	sar    $0x1f,%eax
  801572:	29 c2                	sub    %eax,%edx
  801574:	89 d0                	mov    %edx,%eax
  801576:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801581:	f7 e9                	imul   %ecx
  801583:	c1 fa 02             	sar    $0x2,%edx
  801586:	89 c8                	mov    %ecx,%eax
  801588:	c1 f8 1f             	sar    $0x1f,%eax
  80158b:	29 c2                	sub    %eax,%edx
  80158d:	89 d0                	mov    %edx,%eax
  80158f:	c1 e0 02             	shl    $0x2,%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	01 c0                	add    %eax,%eax
  801596:	29 c1                	sub    %eax,%ecx
  801598:	89 ca                	mov    %ecx,%edx
  80159a:	85 d2                	test   %edx,%edx
  80159c:	75 9c                	jne    80153a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80159e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a8:	48                   	dec    %eax
  8015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b0:	74 3d                	je     8015ef <ltostr+0xe2>
		start = 1 ;
  8015b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b9:	eb 34                	jmp    8015ef <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	01 c2                	add    %eax,%edx
  8015d0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	01 c8                	add    %ecx,%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	01 c2                	add    %eax,%edx
  8015e4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e7:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f5:	7c c4                	jl     8015bb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	01 d0                	add    %edx,%eax
  8015ff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801602:	90                   	nop
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 54 fa ff ff       	call   801067 <strlen>
  801613:	83 c4 04             	add    $0x4,%esp
  801616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	e8 46 fa ff ff       	call   801067 <strlen>
  801621:	83 c4 04             	add    $0x4,%esp
  801624:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801627:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80162e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801635:	eb 17                	jmp    80164e <strcconcat+0x49>
		final[s] = str1[s] ;
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	8b 45 10             	mov    0x10(%ebp),%eax
  80163d:	01 c2                	add    %eax,%edx
  80163f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	01 c8                	add    %ecx,%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80164b:	ff 45 fc             	incl   -0x4(%ebp)
  80164e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801651:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801654:	7c e1                	jl     801637 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801656:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80165d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801664:	eb 1f                	jmp    801685 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801669:	8d 50 01             	lea    0x1(%eax),%edx
  80166c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80166f:	89 c2                	mov    %eax,%edx
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	01 c2                	add    %eax,%edx
  801676:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167c:	01 c8                	add    %ecx,%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801682:	ff 45 f8             	incl   -0x8(%ebp)
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168b:	7c d9                	jl     801666 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80168d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	c6 00 00             	movb   $0x0,(%eax)
}
  801698:	90                   	nop
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016be:	eb 0c                	jmp    8016cc <strsplit+0x31>
			*string++ = 0;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8d 50 01             	lea    0x1(%eax),%edx
  8016c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	84 c0                	test   %al,%al
  8016d3:	74 18                	je     8016ed <strsplit+0x52>
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	0f be c0             	movsbl %al,%eax
  8016dd:	50                   	push   %eax
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	e8 13 fb ff ff       	call   8011f9 <strchr>
  8016e6:	83 c4 08             	add    $0x8,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	75 d3                	jne    8016c0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 5a                	je     801750 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f9:	8b 00                	mov    (%eax),%eax
  8016fb:	83 f8 0f             	cmp    $0xf,%eax
  8016fe:	75 07                	jne    801707 <strsplit+0x6c>
		{
			return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	eb 66                	jmp    80176d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801707:	8b 45 14             	mov    0x14(%ebp),%eax
  80170a:	8b 00                	mov    (%eax),%eax
  80170c:	8d 48 01             	lea    0x1(%eax),%ecx
  80170f:	8b 55 14             	mov    0x14(%ebp),%edx
  801712:	89 0a                	mov    %ecx,(%edx)
  801714:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 c2                	add    %eax,%edx
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801725:	eb 03                	jmp    80172a <strsplit+0x8f>
			string++;
  801727:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	84 c0                	test   %al,%al
  801731:	74 8b                	je     8016be <strsplit+0x23>
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	0f be c0             	movsbl %al,%eax
  80173b:	50                   	push   %eax
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 b5 fa ff ff       	call   8011f9 <strchr>
  801744:	83 c4 08             	add    $0x8,%esp
  801747:	85 c0                	test   %eax,%eax
  801749:	74 dc                	je     801727 <strsplit+0x8c>
			string++;
	}
  80174b:	e9 6e ff ff ff       	jmp    8016be <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801750:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801751:	8b 45 14             	mov    0x14(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175d:	8b 45 10             	mov    0x10(%ebp),%eax
  801760:	01 d0                	add    %edx,%eax
  801762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801768:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	57                   	push   %edi
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
  801775:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801781:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801784:	8b 7d 18             	mov    0x18(%ebp),%edi
  801787:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80178a:	cd 30                	int    $0x30
  80178c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	5b                   	pop    %ebx
  801796:	5e                   	pop    %esi
  801797:	5f                   	pop    %edi
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	52                   	push   %edx
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	50                   	push   %eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 b2 ff ff ff       	call   80176f <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 01                	push   $0x1
  8017d2:	e8 98 ff ff ff       	call   80176f <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 05                	push   $0x5
  8017ef:	e8 7b ff ff ff       	call   80176f <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	56                   	push   %esi
  8017fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017fe:	8b 75 18             	mov    0x18(%ebp),%esi
  801801:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801804:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	56                   	push   %esi
  80180e:	53                   	push   %ebx
  80180f:	51                   	push   %ecx
  801810:	52                   	push   %edx
  801811:	50                   	push   %eax
  801812:	6a 06                	push   $0x6
  801814:	e8 56 ff ff ff       	call   80176f <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801826:	8b 55 0c             	mov    0xc(%ebp),%edx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	6a 07                	push   $0x7
  801836:	e8 34 ff ff ff       	call   80176f <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	6a 08                	push   $0x8
  801851:	e8 19 ff ff ff       	call   80176f <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 09                	push   $0x9
  80186a:	e8 00 ff ff ff       	call   80176f <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 0a                	push   $0xa
  801883:	e8 e7 fe ff ff       	call   80176f <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 0b                	push   $0xb
  80189c:	e8 ce fe ff ff       	call   80176f <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 0f                	push   $0xf
  8018b7:	e8 b3 fe ff ff       	call   80176f <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
	return;
  8018bf:	90                   	nop
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 10                	push   $0x10
  8018d3:	e8 97 fe ff ff       	call   80176f <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018db:	90                   	nop
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 10             	pushl  0x10(%ebp)
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 11                	push   $0x11
  8018f0:	e8 7a fe ff ff       	call   80176f <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f8:	90                   	nop
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 0c                	push   $0xc
  80190a:	e8 60 fe ff ff       	call   80176f <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	ff 75 08             	pushl  0x8(%ebp)
  801922:	6a 0d                	push   $0xd
  801924:	e8 46 fe ff ff       	call   80176f <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 0e                	push   $0xe
  80193d:	e8 2d fe ff ff       	call   80176f <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 13                	push   $0x13
  801957:	e8 13 fe ff ff       	call   80176f <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 14                	push   $0x14
  801971:	e8 f9 fd ff ff       	call   80176f <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	90                   	nop
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_cputc>:


void
sys_cputc(const char c)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801988:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	50                   	push   %eax
  801995:	6a 15                	push   $0x15
  801997:	e8 d3 fd ff ff       	call   80176f <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	90                   	nop
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 16                	push   $0x16
  8019b1:	e8 b9 fd ff ff       	call   80176f <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	90                   	nop
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	6a 17                	push   $0x17
  8019ce:	e8 9c fd ff ff       	call   80176f <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 1a                	push   $0x1a
  8019eb:	e8 7f fd ff ff       	call   80176f <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	52                   	push   %edx
  801a05:	50                   	push   %eax
  801a06:	6a 18                	push   $0x18
  801a08:	e8 62 fd ff ff       	call   80176f <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	90                   	nop
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	52                   	push   %edx
  801a23:	50                   	push   %eax
  801a24:	6a 19                	push   $0x19
  801a26:	e8 44 fd ff ff       	call   80176f <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	51                   	push   %ecx
  801a4a:	52                   	push   %edx
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	50                   	push   %eax
  801a4f:	6a 1b                	push   $0x1b
  801a51:	e8 19 fd ff ff       	call   80176f <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	6a 1c                	push   $0x1c
  801a6e:	e8 fc fc ff ff       	call   80176f <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	51                   	push   %ecx
  801a89:	52                   	push   %edx
  801a8a:	50                   	push   %eax
  801a8b:	6a 1d                	push   $0x1d
  801a8d:	e8 dd fc ff ff       	call   80176f <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 1e                	push   $0x1e
  801aaa:	e8 c0 fc ff ff       	call   80176f <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 1f                	push   $0x1f
  801ac3:	e8 a7 fc ff ff       	call   80176f <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 14             	pushl  0x14(%ebp)
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	50                   	push   %eax
  801adf:	6a 20                	push   $0x20
  801ae1:	e8 89 fc ff ff       	call   80176f <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	50                   	push   %eax
  801afa:	6a 21                	push   $0x21
  801afc:	e8 6e fc ff ff       	call   80176f <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	50                   	push   %eax
  801b16:	6a 22                	push   $0x22
  801b18:	e8 52 fc ff ff       	call   80176f <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 02                	push   $0x2
  801b31:	e8 39 fc ff ff       	call   80176f <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 03                	push   $0x3
  801b4a:	e8 20 fc ff ff       	call   80176f <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 04                	push   $0x4
  801b63:	e8 07 fc ff ff       	call   80176f <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_exit_env>:


void sys_exit_env(void)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 23                	push   $0x23
  801b7c:	e8 ee fb ff ff       	call   80176f <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b90:	8d 50 04             	lea    0x4(%eax),%edx
  801b93:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 24                	push   $0x24
  801ba0:	e8 ca fb ff ff       	call   80176f <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb1:	89 01                	mov    %eax,(%ecx)
  801bb3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	c9                   	leave  
  801bba:	c2 04 00             	ret    $0x4

00801bbd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 10             	pushl  0x10(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	ff 75 08             	pushl  0x8(%ebp)
  801bcd:	6a 12                	push   $0x12
  801bcf:	e8 9b fb ff ff       	call   80176f <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd7:	90                   	nop
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_rcr2>:
uint32 sys_rcr2()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 25                	push   $0x25
  801be9:	e8 81 fb ff ff       	call   80176f <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	50                   	push   %eax
  801c0c:	6a 26                	push   $0x26
  801c0e:	e8 5c fb ff ff       	call   80176f <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return ;
  801c16:	90                   	nop
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <rsttst>:
void rsttst()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 28                	push   $0x28
  801c28:	e8 42 fb ff ff       	call   80176f <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 04             	sub    $0x4,%esp
  801c39:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c46:	52                   	push   %edx
  801c47:	50                   	push   %eax
  801c48:	ff 75 10             	pushl  0x10(%ebp)
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 27                	push   $0x27
  801c53:	e8 17 fb ff ff       	call   80176f <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <chktst>:
void chktst(uint32 n)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 08             	pushl  0x8(%ebp)
  801c6c:	6a 29                	push   $0x29
  801c6e:	e8 fc fa ff ff       	call   80176f <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return ;
  801c76:	90                   	nop
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <inctst>:

void inctst()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 2a                	push   $0x2a
  801c88:	e8 e2 fa ff ff       	call   80176f <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c90:	90                   	nop
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <gettst>:
uint32 gettst()
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 2b                	push   $0x2b
  801ca2:	e8 c8 fa ff ff       	call   80176f <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 2c                	push   $0x2c
  801cbe:	e8 ac fa ff ff       	call   80176f <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
  801cc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ccd:	75 07                	jne    801cd6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd4:	eb 05                	jmp    801cdb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 2c                	push   $0x2c
  801cef:	e8 7b fa ff ff       	call   80176f <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
  801cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cfa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfe:	75 07                	jne    801d07 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d00:	b8 01 00 00 00       	mov    $0x1,%eax
  801d05:	eb 05                	jmp    801d0c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 2c                	push   $0x2c
  801d20:	e8 4a fa ff ff       	call   80176f <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
  801d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d2b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2f:	75 07                	jne    801d38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	eb 05                	jmp    801d3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 2c                	push   $0x2c
  801d51:	e8 19 fa ff ff       	call   80176f <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
  801d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d60:	75 07                	jne    801d69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	eb 05                	jmp    801d6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	6a 2d                	push   $0x2d
  801d80:	e8 ea f9 ff ff       	call   80176f <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
	return ;
  801d88:	90                   	nop
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	53                   	push   %ebx
  801d9e:	51                   	push   %ecx
  801d9f:	52                   	push   %edx
  801da0:	50                   	push   %eax
  801da1:	6a 2e                	push   $0x2e
  801da3:	e8 c7 f9 ff ff       	call   80176f <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	52                   	push   %edx
  801dc0:	50                   	push   %eax
  801dc1:	6a 2f                	push   $0x2f
  801dc3:	e8 a7 f9 ff ff       	call   80176f <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    
  801dcd:	66 90                	xchg   %ax,%ax
  801dcf:	90                   	nop

00801dd0 <__udivdi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ddb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ddf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de7:	89 ca                	mov    %ecx,%edx
  801de9:	89 f8                	mov    %edi,%eax
  801deb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801def:	85 f6                	test   %esi,%esi
  801df1:	75 2d                	jne    801e20 <__udivdi3+0x50>
  801df3:	39 cf                	cmp    %ecx,%edi
  801df5:	77 65                	ja     801e5c <__udivdi3+0x8c>
  801df7:	89 fd                	mov    %edi,%ebp
  801df9:	85 ff                	test   %edi,%edi
  801dfb:	75 0b                	jne    801e08 <__udivdi3+0x38>
  801dfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801e02:	31 d2                	xor    %edx,%edx
  801e04:	f7 f7                	div    %edi
  801e06:	89 c5                	mov    %eax,%ebp
  801e08:	31 d2                	xor    %edx,%edx
  801e0a:	89 c8                	mov    %ecx,%eax
  801e0c:	f7 f5                	div    %ebp
  801e0e:	89 c1                	mov    %eax,%ecx
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	f7 f5                	div    %ebp
  801e14:	89 cf                	mov    %ecx,%edi
  801e16:	89 fa                	mov    %edi,%edx
  801e18:	83 c4 1c             	add    $0x1c,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5f                   	pop    %edi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    
  801e20:	39 ce                	cmp    %ecx,%esi
  801e22:	77 28                	ja     801e4c <__udivdi3+0x7c>
  801e24:	0f bd fe             	bsr    %esi,%edi
  801e27:	83 f7 1f             	xor    $0x1f,%edi
  801e2a:	75 40                	jne    801e6c <__udivdi3+0x9c>
  801e2c:	39 ce                	cmp    %ecx,%esi
  801e2e:	72 0a                	jb     801e3a <__udivdi3+0x6a>
  801e30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e34:	0f 87 9e 00 00 00    	ja     801ed8 <__udivdi3+0x108>
  801e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3f:	89 fa                	mov    %edi,%edx
  801e41:	83 c4 1c             	add    $0x1c,%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5f                   	pop    %edi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    
  801e49:	8d 76 00             	lea    0x0(%esi),%esi
  801e4c:	31 ff                	xor    %edi,%edi
  801e4e:	31 c0                	xor    %eax,%eax
  801e50:	89 fa                	mov    %edi,%edx
  801e52:	83 c4 1c             	add    $0x1c,%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5f                   	pop    %edi
  801e58:	5d                   	pop    %ebp
  801e59:	c3                   	ret    
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	89 d8                	mov    %ebx,%eax
  801e5e:	f7 f7                	div    %edi
  801e60:	31 ff                	xor    %edi,%edi
  801e62:	89 fa                	mov    %edi,%edx
  801e64:	83 c4 1c             	add    $0x1c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
  801e6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e71:	89 eb                	mov    %ebp,%ebx
  801e73:	29 fb                	sub    %edi,%ebx
  801e75:	89 f9                	mov    %edi,%ecx
  801e77:	d3 e6                	shl    %cl,%esi
  801e79:	89 c5                	mov    %eax,%ebp
  801e7b:	88 d9                	mov    %bl,%cl
  801e7d:	d3 ed                	shr    %cl,%ebp
  801e7f:	89 e9                	mov    %ebp,%ecx
  801e81:	09 f1                	or     %esi,%ecx
  801e83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e87:	89 f9                	mov    %edi,%ecx
  801e89:	d3 e0                	shl    %cl,%eax
  801e8b:	89 c5                	mov    %eax,%ebp
  801e8d:	89 d6                	mov    %edx,%esi
  801e8f:	88 d9                	mov    %bl,%cl
  801e91:	d3 ee                	shr    %cl,%esi
  801e93:	89 f9                	mov    %edi,%ecx
  801e95:	d3 e2                	shl    %cl,%edx
  801e97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e9b:	88 d9                	mov    %bl,%cl
  801e9d:	d3 e8                	shr    %cl,%eax
  801e9f:	09 c2                	or     %eax,%edx
  801ea1:	89 d0                	mov    %edx,%eax
  801ea3:	89 f2                	mov    %esi,%edx
  801ea5:	f7 74 24 0c          	divl   0xc(%esp)
  801ea9:	89 d6                	mov    %edx,%esi
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	f7 e5                	mul    %ebp
  801eaf:	39 d6                	cmp    %edx,%esi
  801eb1:	72 19                	jb     801ecc <__udivdi3+0xfc>
  801eb3:	74 0b                	je     801ec0 <__udivdi3+0xf0>
  801eb5:	89 d8                	mov    %ebx,%eax
  801eb7:	31 ff                	xor    %edi,%edi
  801eb9:	e9 58 ff ff ff       	jmp    801e16 <__udivdi3+0x46>
  801ebe:	66 90                	xchg   %ax,%ax
  801ec0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ec4:	89 f9                	mov    %edi,%ecx
  801ec6:	d3 e2                	shl    %cl,%edx
  801ec8:	39 c2                	cmp    %eax,%edx
  801eca:	73 e9                	jae    801eb5 <__udivdi3+0xe5>
  801ecc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ecf:	31 ff                	xor    %edi,%edi
  801ed1:	e9 40 ff ff ff       	jmp    801e16 <__udivdi3+0x46>
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	31 c0                	xor    %eax,%eax
  801eda:	e9 37 ff ff ff       	jmp    801e16 <__udivdi3+0x46>
  801edf:	90                   	nop

00801ee0 <__umoddi3>:
  801ee0:	55                   	push   %ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 1c             	sub    $0x1c,%esp
  801ee7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eeb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ef3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ef7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801efb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eff:	89 f3                	mov    %esi,%ebx
  801f01:	89 fa                	mov    %edi,%edx
  801f03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f07:	89 34 24             	mov    %esi,(%esp)
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	75 1a                	jne    801f28 <__umoddi3+0x48>
  801f0e:	39 f7                	cmp    %esi,%edi
  801f10:	0f 86 a2 00 00 00    	jbe    801fb8 <__umoddi3+0xd8>
  801f16:	89 c8                	mov    %ecx,%eax
  801f18:	89 f2                	mov    %esi,%edx
  801f1a:	f7 f7                	div    %edi
  801f1c:	89 d0                	mov    %edx,%eax
  801f1e:	31 d2                	xor    %edx,%edx
  801f20:	83 c4 1c             	add    $0x1c,%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    
  801f28:	39 f0                	cmp    %esi,%eax
  801f2a:	0f 87 ac 00 00 00    	ja     801fdc <__umoddi3+0xfc>
  801f30:	0f bd e8             	bsr    %eax,%ebp
  801f33:	83 f5 1f             	xor    $0x1f,%ebp
  801f36:	0f 84 ac 00 00 00    	je     801fe8 <__umoddi3+0x108>
  801f3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f41:	29 ef                	sub    %ebp,%edi
  801f43:	89 fe                	mov    %edi,%esi
  801f45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	d3 e0                	shl    %cl,%eax
  801f4d:	89 d7                	mov    %edx,%edi
  801f4f:	89 f1                	mov    %esi,%ecx
  801f51:	d3 ef                	shr    %cl,%edi
  801f53:	09 c7                	or     %eax,%edi
  801f55:	89 e9                	mov    %ebp,%ecx
  801f57:	d3 e2                	shl    %cl,%edx
  801f59:	89 14 24             	mov    %edx,(%esp)
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	d3 e0                	shl    %cl,%eax
  801f60:	89 c2                	mov    %eax,%edx
  801f62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f66:	d3 e0                	shl    %cl,%eax
  801f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f70:	89 f1                	mov    %esi,%ecx
  801f72:	d3 e8                	shr    %cl,%eax
  801f74:	09 d0                	or     %edx,%eax
  801f76:	d3 eb                	shr    %cl,%ebx
  801f78:	89 da                	mov    %ebx,%edx
  801f7a:	f7 f7                	div    %edi
  801f7c:	89 d3                	mov    %edx,%ebx
  801f7e:	f7 24 24             	mull   (%esp)
  801f81:	89 c6                	mov    %eax,%esi
  801f83:	89 d1                	mov    %edx,%ecx
  801f85:	39 d3                	cmp    %edx,%ebx
  801f87:	0f 82 87 00 00 00    	jb     802014 <__umoddi3+0x134>
  801f8d:	0f 84 91 00 00 00    	je     802024 <__umoddi3+0x144>
  801f93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f97:	29 f2                	sub    %esi,%edx
  801f99:	19 cb                	sbb    %ecx,%ebx
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fa1:	d3 e0                	shl    %cl,%eax
  801fa3:	89 e9                	mov    %ebp,%ecx
  801fa5:	d3 ea                	shr    %cl,%edx
  801fa7:	09 d0                	or     %edx,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	d3 eb                	shr    %cl,%ebx
  801fad:	89 da                	mov    %ebx,%edx
  801faf:	83 c4 1c             	add    $0x1c,%esp
  801fb2:	5b                   	pop    %ebx
  801fb3:	5e                   	pop    %esi
  801fb4:	5f                   	pop    %edi
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    
  801fb7:	90                   	nop
  801fb8:	89 fd                	mov    %edi,%ebp
  801fba:	85 ff                	test   %edi,%edi
  801fbc:	75 0b                	jne    801fc9 <__umoddi3+0xe9>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	31 d2                	xor    %edx,%edx
  801fc5:	f7 f7                	div    %edi
  801fc7:	89 c5                	mov    %eax,%ebp
  801fc9:	89 f0                	mov    %esi,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	f7 f5                	div    %ebp
  801fcf:	89 c8                	mov    %ecx,%eax
  801fd1:	f7 f5                	div    %ebp
  801fd3:	89 d0                	mov    %edx,%eax
  801fd5:	e9 44 ff ff ff       	jmp    801f1e <__umoddi3+0x3e>
  801fda:	66 90                	xchg   %ax,%ax
  801fdc:	89 c8                	mov    %ecx,%eax
  801fde:	89 f2                	mov    %esi,%edx
  801fe0:	83 c4 1c             	add    $0x1c,%esp
  801fe3:	5b                   	pop    %ebx
  801fe4:	5e                   	pop    %esi
  801fe5:	5f                   	pop    %edi
  801fe6:	5d                   	pop    %ebp
  801fe7:	c3                   	ret    
  801fe8:	3b 04 24             	cmp    (%esp),%eax
  801feb:	72 06                	jb     801ff3 <__umoddi3+0x113>
  801fed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ff1:	77 0f                	ja     802002 <__umoddi3+0x122>
  801ff3:	89 f2                	mov    %esi,%edx
  801ff5:	29 f9                	sub    %edi,%ecx
  801ff7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ffb:	89 14 24             	mov    %edx,(%esp)
  801ffe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802002:	8b 44 24 04          	mov    0x4(%esp),%eax
  802006:	8b 14 24             	mov    (%esp),%edx
  802009:	83 c4 1c             	add    $0x1c,%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    
  802011:	8d 76 00             	lea    0x0(%esi),%esi
  802014:	2b 04 24             	sub    (%esp),%eax
  802017:	19 fa                	sbb    %edi,%edx
  802019:	89 d1                	mov    %edx,%ecx
  80201b:	89 c6                	mov    %eax,%esi
  80201d:	e9 71 ff ff ff       	jmp    801f93 <__umoddi3+0xb3>
  802022:	66 90                	xchg   %ax,%ax
  802024:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802028:	72 ea                	jb     802014 <__umoddi3+0x134>
  80202a:	89 d9                	mov    %ebx,%ecx
  80202c:	e9 62 ff ff ff       	jmp    801f93 <__umoddi3+0xb3>
