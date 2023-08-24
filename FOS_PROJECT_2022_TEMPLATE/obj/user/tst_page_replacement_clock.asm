
obj/user/tst_page_replacement_clock:     file format elf32-i386


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
  800031:	e8 9d 04 00 00       	call   8004d3 <libmain>
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
  80003b:	83 ec 68             	sub    $0x68,%esp
	
	

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 40 1f 80 00       	push   $0x801f40
  800065:	6a 15                	push   $0x15
  800067:	68 84 1f 80 00       	push   $0x801f84
  80006c:	e8 b1 05 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 40 1f 80 00       	push   $0x801f40
  80009b:	6a 16                	push   $0x16
  80009d:	68 84 1f 80 00       	push   $0x801f84
  8000a2:	e8 7b 05 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 40 1f 80 00       	push   $0x801f40
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 84 1f 80 00       	push   $0x801f84
  8000d8:	e8 45 05 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 40 1f 80 00       	push   $0x801f40
  800107:	6a 18                	push   $0x18
  800109:	68 84 1f 80 00       	push   $0x801f84
  80010e:	e8 0f 05 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 40 1f 80 00       	push   $0x801f40
  80013d:	6a 19                	push   $0x19
  80013f:	68 84 1f 80 00       	push   $0x801f84
  800144:	e8 d9 04 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80015c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 40 1f 80 00       	push   $0x801f40
  800173:	6a 1a                	push   $0x1a
  800175:	68 84 1f 80 00       	push   $0x801f84
  80017a:	e8 a3 04 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800194:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 40 1f 80 00       	push   $0x801f40
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 84 1f 80 00       	push   $0x801f84
  8001b2:	e8 6b 04 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 40 1f 80 00       	push   $0x801f40
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 84 1f 80 00       	push   $0x801f84
  8001ea:	e8 33 04 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800204:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 40 1f 80 00       	push   $0x801f40
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 84 1f 80 00       	push   $0x801f84
  800222:	e8 fb 03 00 00       	call   800622 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  800232:	85 c0                	test   %eax,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 a8 1f 80 00       	push   $0x801fa8
  80023e:	6a 1e                	push   $0x1e
  800240:	68 84 1f 80 00       	push   $0x801f84
  800245:	e8 d8 03 00 00       	call   800622 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80024a:	e8 fd 14 00 00       	call   80174c <sys_calculate_free_frames>
  80024f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800252:	e8 95 15 00 00       	call   8017ec <sys_pf_calculate_allocated_pages>
  800257:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80025a:	a0 5f 51 83 00       	mov    0x83515f,%al
  80025f:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800262:	a0 5f 61 83 00       	mov    0x83615f,%al
  800267:	88 45 c6             	mov    %al,-0x3a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80026a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800271:	eb 37                	jmp    8002aa <_main+0x272>
	{
		arr[i] = -1 ;
  800273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800276:	05 60 a1 82 00       	add    $0x82a160,%eax
  80027b:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  80027e:	a1 04 30 80 00       	mov    0x803004,%eax
  800283:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800289:	8a 12                	mov    (%edx),%dl
  80028b:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80028d:	a1 00 30 80 00       	mov    0x803000,%eax
  800292:	40                   	inc    %eax
  800293:	a3 00 30 80 00       	mov    %eax,0x803000
  800298:	a1 04 30 80 00       	mov    0x803004,%eax
  80029d:	40                   	inc    %eax
  80029e:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002a3:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002aa:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002b1:	7e c0                	jle    800273 <_main+0x23b>

	//===================

	//cprintf("Checking PAGE CLOCK algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8002b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b8:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8002be:	8b 00                	mov    (%eax),%eax
  8002c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8002c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002cb:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002d0:	74 14                	je     8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 f0 1f 80 00       	push   $0x801ff0
  8002da:	6a 3a                	push   $0x3a
  8002dc:	68 84 1f 80 00       	push   $0x801f84
  8002e1:	e8 3c 03 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8002f1:	83 c0 18             	add    $0x18,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8002f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800301:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800306:	74 14                	je     80031c <_main+0x2e4>
  800308:	83 ec 04             	sub    $0x4,%esp
  80030b:	68 f0 1f 80 00       	push   $0x801ff0
  800310:	6a 3b                	push   $0x3b
  800312:	68 84 1f 80 00       	push   $0x801f84
  800317:	e8 06 03 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80031c:	a1 20 30 80 00       	mov    0x803020,%eax
  800321:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800327:	83 c0 30             	add    $0x30,%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80032f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 f0 1f 80 00       	push   $0x801ff0
  800346:	6a 3c                	push   $0x3c
  800348:	68 84 1f 80 00       	push   $0x801f84
  80034d:	e8 d0 02 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80035d:	83 c0 48             	add    $0x48,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800365:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036d:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800372:	74 14                	je     800388 <_main+0x350>
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 f0 1f 80 00       	push   $0x801ff0
  80037c:	6a 3d                	push   $0x3d
  80037e:	68 84 1f 80 00       	push   $0x801f84
  800383:	e8 9a 02 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800393:	83 c0 60             	add    $0x60,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80039b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	3d 00 90 80 00       	cmp    $0x809000,%eax
  8003a8:	74 14                	je     8003be <_main+0x386>
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	68 f0 1f 80 00       	push   $0x801ff0
  8003b2:	6a 3e                	push   $0x3e
  8003b4:	68 84 1f 80 00       	push   $0x801f84
  8003b9:	e8 64 02 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003c9:	83 c0 78             	add    $0x78,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8003d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d9:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 f0 1f 80 00       	push   $0x801ff0
  8003e8:	6a 3f                	push   $0x3f
  8003ea:	68 84 1f 80 00       	push   $0x801f84
  8003ef:	e8 2e 02 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003ff:	05 90 00 00 00       	add    $0x90,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800409:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 f0 1f 80 00       	push   $0x801ff0
  800420:	6a 40                	push   $0x40
  800422:	68 84 1f 80 00       	push   $0x801f84
  800427:	e8 f6 01 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800437:	05 a8 00 00 00       	add    $0xa8,%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800441:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800449:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80044e:	74 14                	je     800464 <_main+0x42c>
  800450:	83 ec 04             	sub    $0x4,%esp
  800453:	68 f0 1f 80 00       	push   $0x801ff0
  800458:	6a 41                	push   $0x41
  80045a:	68 84 1f 80 00       	push   $0x801f84
  80045f:	e8 be 01 00 00       	call   800622 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800464:	a1 20 30 80 00       	mov    0x803020,%eax
  800469:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80046f:	05 c0 00 00 00       	add    $0xc0,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800479:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80047c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800481:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800486:	74 14                	je     80049c <_main+0x464>
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	68 f0 1f 80 00       	push   $0x801ff0
  800490:	6a 42                	push   $0x42
  800492:	68 84 1f 80 00       	push   $0x801f84
  800497:	e8 86 01 00 00       	call   800622 <_panic>

		if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  80049c:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a1:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8004a7:	83 f8 02             	cmp    $0x2,%eax
  8004aa:	74 14                	je     8004c0 <_main+0x488>
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	68 40 20 80 00       	push   $0x802040
  8004b4:	6a 44                	push   $0x44
  8004b6:	68 84 1f 80 00       	push   $0x801f84
  8004bb:	e8 62 01 00 00       	call   800622 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [CLOCK Alg.] is completed successfully.\n");
  8004c0:	83 ec 0c             	sub    $0xc,%esp
  8004c3:	68 60 20 80 00       	push   $0x802060
  8004c8:	e8 09 04 00 00       	call   8008d6 <cprintf>
  8004cd:	83 c4 10             	add    $0x10,%esp
	return;
  8004d0:	90                   	nop
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8004d9:	e8 4e 15 00 00       	call   801a2c <sys_getenvindex>
  8004de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8004e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e4:	89 d0                	mov    %edx,%eax
  8004e6:	01 c0                	add    %eax,%eax
  8004e8:	01 d0                	add    %edx,%eax
  8004ea:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004f1:	01 c8                	add    %ecx,%eax
  8004f3:	c1 e0 02             	shl    $0x2,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004ff:	01 c8                	add    %ecx,%eax
  800501:	c1 e0 02             	shl    $0x2,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800513:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800518:	a1 20 30 80 00       	mov    0x803020,%eax
  80051d:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800523:	84 c0                	test   %al,%al
  800525:	74 0f                	je     800536 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800527:	a1 20 30 80 00       	mov    0x803020,%eax
  80052c:	05 18 da 01 00       	add    $0x1da18,%eax
  800531:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80053a:	7e 0a                	jle    800546 <libmain+0x73>
		binaryname = argv[0];
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	ff 75 0c             	pushl  0xc(%ebp)
  80054c:	ff 75 08             	pushl  0x8(%ebp)
  80054f:	e8 e4 fa ff ff       	call   800038 <_main>
  800554:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800557:	e8 dd 12 00 00       	call   801839 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	68 cc 20 80 00       	push   $0x8020cc
  800564:	e8 6d 03 00 00       	call   8008d6 <cprintf>
  800569:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80056c:	a1 20 30 80 00       	mov    0x803020,%eax
  800571:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800577:	a1 20 30 80 00       	mov    0x803020,%eax
  80057c:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800582:	83 ec 04             	sub    $0x4,%esp
  800585:	52                   	push   %edx
  800586:	50                   	push   %eax
  800587:	68 f4 20 80 00       	push   $0x8020f4
  80058c:	e8 45 03 00 00       	call   8008d6 <cprintf>
  800591:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800594:	a1 20 30 80 00       	mov    0x803020,%eax
  800599:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80059f:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a4:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8005aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8005af:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8005b5:	51                   	push   %ecx
  8005b6:	52                   	push   %edx
  8005b7:	50                   	push   %eax
  8005b8:	68 1c 21 80 00       	push   $0x80211c
  8005bd:	e8 14 03 00 00       	call   8008d6 <cprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	50                   	push   %eax
  8005d4:	68 74 21 80 00       	push   $0x802174
  8005d9:	e8 f8 02 00 00       	call   8008d6 <cprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8005e1:	83 ec 0c             	sub    $0xc,%esp
  8005e4:	68 cc 20 80 00       	push   $0x8020cc
  8005e9:	e8 e8 02 00 00       	call   8008d6 <cprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f1:	e8 5d 12 00 00       	call   801853 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8005f6:	e8 19 00 00 00       	call   800614 <exit>
}
  8005fb:	90                   	nop
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800604:	83 ec 0c             	sub    $0xc,%esp
  800607:	6a 00                	push   $0x0
  800609:	e8 ea 13 00 00       	call   8019f8 <sys_destroy_env>
  80060e:	83 c4 10             	add    $0x10,%esp
}
  800611:	90                   	nop
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <exit>:

void
exit(void)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80061a:	e8 3f 14 00 00       	call   801a5e <sys_exit_env>
}
  80061f:	90                   	nop
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800628:	8d 45 10             	lea    0x10(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800631:	a1 58 62 83 00       	mov    0x836258,%eax
  800636:	85 c0                	test   %eax,%eax
  800638:	74 16                	je     800650 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80063a:	a1 58 62 83 00       	mov    0x836258,%eax
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	50                   	push   %eax
  800643:	68 88 21 80 00       	push   $0x802188
  800648:	e8 89 02 00 00       	call   8008d6 <cprintf>
  80064d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800650:	a1 08 30 80 00       	mov    0x803008,%eax
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 08             	pushl  0x8(%ebp)
  80065b:	50                   	push   %eax
  80065c:	68 8d 21 80 00       	push   $0x80218d
  800661:	e8 70 02 00 00       	call   8008d6 <cprintf>
  800666:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800669:	8b 45 10             	mov    0x10(%ebp),%eax
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	ff 75 f4             	pushl  -0xc(%ebp)
  800672:	50                   	push   %eax
  800673:	e8 f3 01 00 00       	call   80086b <vcprintf>
  800678:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	6a 00                	push   $0x0
  800680:	68 a9 21 80 00       	push   $0x8021a9
  800685:	e8 e1 01 00 00       	call   80086b <vcprintf>
  80068a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80068d:	e8 82 ff ff ff       	call   800614 <exit>

	// should not return here
	while (1) ;
  800692:	eb fe                	jmp    800692 <_panic+0x70>

00800694 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80069a:	a1 20 30 80 00       	mov    0x803020,%eax
  80069f:	8b 50 74             	mov    0x74(%eax),%edx
  8006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a5:	39 c2                	cmp    %eax,%edx
  8006a7:	74 14                	je     8006bd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	68 ac 21 80 00       	push   $0x8021ac
  8006b1:	6a 26                	push   $0x26
  8006b3:	68 f8 21 80 00       	push   $0x8021f8
  8006b8:	e8 65 ff ff ff       	call   800622 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8006bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8006c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006cb:	e9 c2 00 00 00       	jmp    800792 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	75 08                	jne    8006ed <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8006e5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8006e8:	e9 a2 00 00 00       	jmp    80078f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8006ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006fb:	eb 69                	jmp    800766 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800702:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800708:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80070b:	89 d0                	mov    %edx,%eax
  80070d:	01 c0                	add    %eax,%eax
  80070f:	01 d0                	add    %edx,%eax
  800711:	c1 e0 03             	shl    $0x3,%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	8a 40 04             	mov    0x4(%eax),%al
  800719:	84 c0                	test   %al,%al
  80071b:	75 46                	jne    800763 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80071d:	a1 20 30 80 00       	mov    0x803020,%eax
  800722:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800728:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80072b:	89 d0                	mov    %edx,%eax
  80072d:	01 c0                	add    %eax,%eax
  80072f:	01 d0                	add    %edx,%eax
  800731:	c1 e0 03             	shl    $0x3,%eax
  800734:	01 c8                	add    %ecx,%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80073e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800743:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800748:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800756:	39 c2                	cmp    %eax,%edx
  800758:	75 09                	jne    800763 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80075a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800761:	eb 12                	jmp    800775 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800763:	ff 45 e8             	incl   -0x18(%ebp)
  800766:	a1 20 30 80 00       	mov    0x803020,%eax
  80076b:	8b 50 74             	mov    0x74(%eax),%edx
  80076e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800771:	39 c2                	cmp    %eax,%edx
  800773:	77 88                	ja     8006fd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800779:	75 14                	jne    80078f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	68 04 22 80 00       	push   $0x802204
  800783:	6a 3a                	push   $0x3a
  800785:	68 f8 21 80 00       	push   $0x8021f8
  80078a:	e8 93 fe ff ff       	call   800622 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80078f:	ff 45 f0             	incl   -0x10(%ebp)
  800792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800795:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800798:	0f 8c 32 ff ff ff    	jl     8006d0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80079e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007ac:	eb 26                	jmp    8007d4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8007ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b3:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8a 40 04             	mov    0x4(%eax),%al
  8007ca:	3c 01                	cmp    $0x1,%al
  8007cc:	75 03                	jne    8007d1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8007ce:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007d1:	ff 45 e0             	incl   -0x20(%ebp)
  8007d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d9:	8b 50 74             	mov    0x74(%eax),%edx
  8007dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007df:	39 c2                	cmp    %eax,%edx
  8007e1:	77 cb                	ja     8007ae <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007e9:	74 14                	je     8007ff <CheckWSWithoutLastIndex+0x16b>
		panic(
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	68 58 22 80 00       	push   $0x802258
  8007f3:	6a 44                	push   $0x44
  8007f5:	68 f8 21 80 00       	push   $0x8021f8
  8007fa:	e8 23 fe ff ff       	call   800622 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007ff:	90                   	nop
  800800:	c9                   	leave  
  800801:	c3                   	ret    

00800802 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	8d 48 01             	lea    0x1(%eax),%ecx
  800810:	8b 55 0c             	mov    0xc(%ebp),%edx
  800813:	89 0a                	mov    %ecx,(%edx)
  800815:	8b 55 08             	mov    0x8(%ebp),%edx
  800818:	88 d1                	mov    %dl,%cl
  80081a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800821:	8b 45 0c             	mov    0xc(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	3d ff 00 00 00       	cmp    $0xff,%eax
  80082b:	75 2c                	jne    800859 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80082d:	a0 24 30 80 00       	mov    0x803024,%al
  800832:	0f b6 c0             	movzbl %al,%eax
  800835:	8b 55 0c             	mov    0xc(%ebp),%edx
  800838:	8b 12                	mov    (%edx),%edx
  80083a:	89 d1                	mov    %edx,%ecx
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083f:	83 c2 08             	add    $0x8,%edx
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	50                   	push   %eax
  800846:	51                   	push   %ecx
  800847:	52                   	push   %edx
  800848:	e8 3e 0e 00 00       	call   80168b <sys_cputs>
  80084d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800850:	8b 45 0c             	mov    0xc(%ebp),%eax
  800853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	8b 40 04             	mov    0x4(%eax),%eax
  80085f:	8d 50 01             	lea    0x1(%eax),%edx
  800862:	8b 45 0c             	mov    0xc(%ebp),%eax
  800865:	89 50 04             	mov    %edx,0x4(%eax)
}
  800868:	90                   	nop
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800874:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80087b:	00 00 00 
	b.cnt = 0;
  80087e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800885:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800894:	50                   	push   %eax
  800895:	68 02 08 80 00       	push   $0x800802
  80089a:	e8 11 02 00 00       	call   800ab0 <vprintfmt>
  80089f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8008a2:	a0 24 30 80 00       	mov    0x803024,%al
  8008a7:	0f b6 c0             	movzbl %al,%eax
  8008aa:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	50                   	push   %eax
  8008b4:	52                   	push   %edx
  8008b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008bb:	83 c0 08             	add    $0x8,%eax
  8008be:	50                   	push   %eax
  8008bf:	e8 c7 0d 00 00       	call   80168b <sys_cputs>
  8008c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008c7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8008ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008dc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8008e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f2:	50                   	push   %eax
  8008f3:	e8 73 ff ff ff       	call   80086b <vcprintf>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800901:	c9                   	leave  
  800902:	c3                   	ret    

00800903 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800909:	e8 2b 0f 00 00       	call   801839 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80090e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800911:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 f4             	pushl  -0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	e8 48 ff ff ff       	call   80086b <vcprintf>
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800929:	e8 25 0f 00 00       	call   801853 <sys_enable_interrupt>
	return cnt;
  80092e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	53                   	push   %ebx
  800937:	83 ec 14             	sub    $0x14,%esp
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800946:	8b 45 18             	mov    0x18(%ebp),%eax
  800949:	ba 00 00 00 00       	mov    $0x0,%edx
  80094e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800951:	77 55                	ja     8009a8 <printnum+0x75>
  800953:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800956:	72 05                	jb     80095d <printnum+0x2a>
  800958:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80095b:	77 4b                	ja     8009a8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80095d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800960:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800963:	8b 45 18             	mov    0x18(%ebp),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	52                   	push   %edx
  80096c:	50                   	push   %eax
  80096d:	ff 75 f4             	pushl  -0xc(%ebp)
  800970:	ff 75 f0             	pushl  -0x10(%ebp)
  800973:	e8 48 13 00 00       	call   801cc0 <__udivdi3>
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	83 ec 04             	sub    $0x4,%esp
  80097e:	ff 75 20             	pushl  0x20(%ebp)
  800981:	53                   	push   %ebx
  800982:	ff 75 18             	pushl  0x18(%ebp)
  800985:	52                   	push   %edx
  800986:	50                   	push   %eax
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	ff 75 08             	pushl  0x8(%ebp)
  80098d:	e8 a1 ff ff ff       	call   800933 <printnum>
  800992:	83 c4 20             	add    $0x20,%esp
  800995:	eb 1a                	jmp    8009b1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	ff 75 20             	pushl  0x20(%ebp)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a8:	ff 4d 1c             	decl   0x1c(%ebp)
  8009ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009af:	7f e6                	jg     800997 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009b1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	53                   	push   %ebx
  8009c0:	51                   	push   %ecx
  8009c1:	52                   	push   %edx
  8009c2:	50                   	push   %eax
  8009c3:	e8 08 14 00 00       	call   801dd0 <__umoddi3>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	05 d4 24 80 00       	add    $0x8024d4,%eax
  8009d0:	8a 00                	mov    (%eax),%al
  8009d2:	0f be c0             	movsbl %al,%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
}
  8009e4:	90                   	nop
  8009e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009f1:	7e 1c                	jle    800a0f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 00                	mov    (%eax),%eax
  8009f8:	8d 50 08             	lea    0x8(%eax),%edx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	89 10                	mov    %edx,(%eax)
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	83 e8 08             	sub    $0x8,%eax
  800a08:	8b 50 04             	mov    0x4(%eax),%edx
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	eb 40                	jmp    800a4f <getuint+0x65>
	else if (lflag)
  800a0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a13:	74 1e                	je     800a33 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	8d 50 04             	lea    0x4(%eax),%edx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	89 10                	mov    %edx,(%eax)
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 00                	mov    (%eax),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a31:	eb 1c                	jmp    800a4f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	8d 50 04             	lea    0x4(%eax),%edx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 10                	mov    %edx,(%eax)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a54:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a58:	7e 1c                	jle    800a76 <getint+0x25>
		return va_arg(*ap, long long);
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8b 00                	mov    (%eax),%eax
  800a5f:	8d 50 08             	lea    0x8(%eax),%edx
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	89 10                	mov    %edx,(%eax)
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	83 e8 08             	sub    $0x8,%eax
  800a6f:	8b 50 04             	mov    0x4(%eax),%edx
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	eb 38                	jmp    800aae <getint+0x5d>
	else if (lflag)
  800a76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7a:	74 1a                	je     800a96 <getint+0x45>
		return va_arg(*ap, long);
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	8d 50 04             	lea    0x4(%eax),%edx
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	89 10                	mov    %edx,(%eax)
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	99                   	cltd   
  800a94:	eb 18                	jmp    800aae <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	8d 50 04             	lea    0x4(%eax),%edx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	89 10                	mov    %edx,(%eax)
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	83 e8 04             	sub    $0x4,%eax
  800aab:	8b 00                	mov    (%eax),%eax
  800aad:	99                   	cltd   
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab8:	eb 17                	jmp    800ad1 <vprintfmt+0x21>
			if (ch == '\0')
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	0f 84 af 03 00 00    	je     800e71 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	8d 50 01             	lea    0x1(%eax),%edx
  800ad7:	89 55 10             	mov    %edx,0x10(%ebp)
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	0f b6 d8             	movzbl %al,%ebx
  800adf:	83 fb 25             	cmp    $0x25,%ebx
  800ae2:	75 d6                	jne    800aba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ae4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800aef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800afd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b04:	8b 45 10             	mov    0x10(%ebp),%eax
  800b07:	8d 50 01             	lea    0x1(%eax),%edx
  800b0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	0f b6 d8             	movzbl %al,%ebx
  800b12:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b15:	83 f8 55             	cmp    $0x55,%eax
  800b18:	0f 87 2b 03 00 00    	ja     800e49 <vprintfmt+0x399>
  800b1e:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  800b25:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b27:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b2b:	eb d7                	jmp    800b04 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b2d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b31:	eb d1                	jmp    800b04 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b33:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3d:	89 d0                	mov    %edx,%eax
  800b3f:	c1 e0 02             	shl    $0x2,%eax
  800b42:	01 d0                	add    %edx,%eax
  800b44:	01 c0                	add    %eax,%eax
  800b46:	01 d8                	add    %ebx,%eax
  800b48:	83 e8 30             	sub    $0x30,%eax
  800b4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b56:	83 fb 2f             	cmp    $0x2f,%ebx
  800b59:	7e 3e                	jle    800b99 <vprintfmt+0xe9>
  800b5b:	83 fb 39             	cmp    $0x39,%ebx
  800b5e:	7f 39                	jg     800b99 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b60:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b63:	eb d5                	jmp    800b3a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b65:	8b 45 14             	mov    0x14(%ebp),%eax
  800b68:	83 c0 04             	add    $0x4,%eax
  800b6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b71:	83 e8 04             	sub    $0x4,%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b79:	eb 1f                	jmp    800b9a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7f:	79 83                	jns    800b04 <vprintfmt+0x54>
				width = 0;
  800b81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b88:	e9 77 ff ff ff       	jmp    800b04 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b8d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b94:	e9 6b ff ff ff       	jmp    800b04 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b99:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	0f 89 60 ff ff ff    	jns    800b04 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800baa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bb1:	e9 4e ff ff ff       	jmp    800b04 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bb6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bb9:	e9 46 ff ff ff       	jmp    800b04 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	83 c0 04             	add    $0x4,%eax
  800bc4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	83 e8 04             	sub    $0x4,%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	ff d0                	call   *%eax
  800bdb:	83 c4 10             	add    $0x10,%esp
			break;
  800bde:	e9 89 02 00 00       	jmp    800e6c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800be3:	8b 45 14             	mov    0x14(%ebp),%eax
  800be6:	83 c0 04             	add    $0x4,%eax
  800be9:	89 45 14             	mov    %eax,0x14(%ebp)
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	83 e8 04             	sub    $0x4,%eax
  800bf2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bf4:	85 db                	test   %ebx,%ebx
  800bf6:	79 02                	jns    800bfa <vprintfmt+0x14a>
				err = -err;
  800bf8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bfa:	83 fb 64             	cmp    $0x64,%ebx
  800bfd:	7f 0b                	jg     800c0a <vprintfmt+0x15a>
  800bff:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  800c06:	85 f6                	test   %esi,%esi
  800c08:	75 19                	jne    800c23 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c0a:	53                   	push   %ebx
  800c0b:	68 e5 24 80 00       	push   $0x8024e5
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 08             	pushl  0x8(%ebp)
  800c16:	e8 5e 02 00 00       	call   800e79 <printfmt>
  800c1b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c1e:	e9 49 02 00 00       	jmp    800e6c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c23:	56                   	push   %esi
  800c24:	68 ee 24 80 00       	push   $0x8024ee
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 45 02 00 00       	call   800e79 <printfmt>
  800c34:	83 c4 10             	add    $0x10,%esp
			break;
  800c37:	e9 30 02 00 00       	jmp    800e6c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3f:	83 c0 04             	add    $0x4,%eax
  800c42:	89 45 14             	mov    %eax,0x14(%ebp)
  800c45:	8b 45 14             	mov    0x14(%ebp),%eax
  800c48:	83 e8 04             	sub    $0x4,%eax
  800c4b:	8b 30                	mov    (%eax),%esi
  800c4d:	85 f6                	test   %esi,%esi
  800c4f:	75 05                	jne    800c56 <vprintfmt+0x1a6>
				p = "(null)";
  800c51:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  800c56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5a:	7e 6d                	jle    800cc9 <vprintfmt+0x219>
  800c5c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c60:	74 67                	je     800cc9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	50                   	push   %eax
  800c69:	56                   	push   %esi
  800c6a:	e8 0c 03 00 00       	call   800f7b <strnlen>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c75:	eb 16                	jmp    800c8d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c77:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	50                   	push   %eax
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	ff d0                	call   *%eax
  800c87:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c91:	7f e4                	jg     800c77 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c93:	eb 34                	jmp    800cc9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c95:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c99:	74 1c                	je     800cb7 <vprintfmt+0x207>
  800c9b:	83 fb 1f             	cmp    $0x1f,%ebx
  800c9e:	7e 05                	jle    800ca5 <vprintfmt+0x1f5>
  800ca0:	83 fb 7e             	cmp    $0x7e,%ebx
  800ca3:	7e 12                	jle    800cb7 <vprintfmt+0x207>
					putch('?', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 3f                	push   $0x3f
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	eb 0f                	jmp    800cc6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	53                   	push   %ebx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	ff d0                	call   *%eax
  800cc3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc6:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc9:	89 f0                	mov    %esi,%eax
  800ccb:	8d 70 01             	lea    0x1(%eax),%esi
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	0f be d8             	movsbl %al,%ebx
  800cd3:	85 db                	test   %ebx,%ebx
  800cd5:	74 24                	je     800cfb <vprintfmt+0x24b>
  800cd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cdb:	78 b8                	js     800c95 <vprintfmt+0x1e5>
  800cdd:	ff 4d e0             	decl   -0x20(%ebp)
  800ce0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ce4:	79 af                	jns    800c95 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce6:	eb 13                	jmp    800cfb <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 20                	push   $0x20
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf8:	ff 4d e4             	decl   -0x1c(%ebp)
  800cfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cff:	7f e7                	jg     800ce8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d01:	e9 66 01 00 00       	jmp    800e6c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 e8             	pushl  -0x18(%ebp)
  800d0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0f:	50                   	push   %eax
  800d10:	e8 3c fd ff ff       	call   800a51 <getint>
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d24:	85 d2                	test   %edx,%edx
  800d26:	79 23                	jns    800d4b <vprintfmt+0x29b>
				putch('-', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 2d                	push   $0x2d
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3e:	f7 d8                	neg    %eax
  800d40:	83 d2 00             	adc    $0x0,%edx
  800d43:	f7 da                	neg    %edx
  800d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d52:	e9 bc 00 00 00       	jmp    800e13 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d5d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d60:	50                   	push   %eax
  800d61:	e8 84 fc ff ff       	call   8009ea <getuint>
  800d66:	83 c4 10             	add    $0x10,%esp
  800d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d76:	e9 98 00 00 00       	jmp    800e13 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d7b:	83 ec 08             	sub    $0x8,%esp
  800d7e:	ff 75 0c             	pushl  0xc(%ebp)
  800d81:	6a 58                	push   $0x58
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	ff d0                	call   *%eax
  800d88:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d8b:	83 ec 08             	sub    $0x8,%esp
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	6a 58                	push   $0x58
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	ff d0                	call   *%eax
  800d98:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d9b:	83 ec 08             	sub    $0x8,%esp
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	6a 58                	push   $0x58
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	ff d0                	call   *%eax
  800da8:	83 c4 10             	add    $0x10,%esp
			break;
  800dab:	e9 bc 00 00 00       	jmp    800e6c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	6a 30                	push   $0x30
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	ff d0                	call   *%eax
  800dbd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dc0:	83 ec 08             	sub    $0x8,%esp
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	6a 78                	push   $0x78
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	ff d0                	call   *%eax
  800dcd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd3:	83 c0 04             	add    $0x4,%eax
  800dd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddc:	83 e8 04             	sub    $0x4,%eax
  800ddf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800deb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800df2:	eb 1f                	jmp    800e13 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 e8             	pushl  -0x18(%ebp)
  800dfa:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfd:	50                   	push   %eax
  800dfe:	e8 e7 fb ff ff       	call   8009ea <getuint>
  800e03:	83 c4 10             	add    $0x10,%esp
  800e06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e09:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e0c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e13:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	52                   	push   %edx
  800e1e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e21:	50                   	push   %eax
  800e22:	ff 75 f4             	pushl  -0xc(%ebp)
  800e25:	ff 75 f0             	pushl  -0x10(%ebp)
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	ff 75 08             	pushl  0x8(%ebp)
  800e2e:	e8 00 fb ff ff       	call   800933 <printnum>
  800e33:	83 c4 20             	add    $0x20,%esp
			break;
  800e36:	eb 34                	jmp    800e6c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	53                   	push   %ebx
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	ff d0                	call   *%eax
  800e44:	83 c4 10             	add    $0x10,%esp
			break;
  800e47:	eb 23                	jmp    800e6c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	6a 25                	push   $0x25
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e59:	ff 4d 10             	decl   0x10(%ebp)
  800e5c:	eb 03                	jmp    800e61 <vprintfmt+0x3b1>
  800e5e:	ff 4d 10             	decl   0x10(%ebp)
  800e61:	8b 45 10             	mov    0x10(%ebp),%eax
  800e64:	48                   	dec    %eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	3c 25                	cmp    $0x25,%al
  800e69:	75 f3                	jne    800e5e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e6b:	90                   	nop
		}
	}
  800e6c:	e9 47 fc ff ff       	jmp    800ab8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e71:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e7f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e82:	83 c0 04             	add    $0x4,%eax
  800e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8e:	50                   	push   %eax
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 16 fc ff ff       	call   800ab0 <vprintfmt>
  800e9a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e9d:	90                   	nop
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	8b 40 08             	mov    0x8(%eax),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	8b 10                	mov    (%eax),%edx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8b 40 04             	mov    0x4(%eax),%eax
  800ebd:	39 c2                	cmp    %eax,%edx
  800ebf:	73 12                	jae    800ed3 <sprintputch+0x33>
		*b->buf++ = ch;
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8b 00                	mov    (%eax),%eax
  800ec6:	8d 48 01             	lea    0x1(%eax),%ecx
  800ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecc:	89 0a                	mov    %ecx,(%edx)
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	88 10                	mov    %dl,(%eax)
}
  800ed3:	90                   	nop
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efb:	74 06                	je     800f03 <vsnprintf+0x2d>
  800efd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f01:	7f 07                	jg     800f0a <vsnprintf+0x34>
		return -E_INVAL;
  800f03:	b8 03 00 00 00       	mov    $0x3,%eax
  800f08:	eb 20                	jmp    800f2a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f0a:	ff 75 14             	pushl  0x14(%ebp)
  800f0d:	ff 75 10             	pushl  0x10(%ebp)
  800f10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	68 a0 0e 80 00       	push   $0x800ea0
  800f19:	e8 92 fb ff ff       	call   800ab0 <vprintfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f24:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f32:	8d 45 10             	lea    0x10(%ebp),%eax
  800f35:	83 c0 04             	add    $0x4,%eax
  800f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f41:	50                   	push   %eax
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	ff 75 08             	pushl  0x8(%ebp)
  800f48:	e8 89 ff ff ff       	call   800ed6 <vsnprintf>
  800f4d:	83 c4 10             	add    $0x10,%esp
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f65:	eb 06                	jmp    800f6d <strlen+0x15>
		n++;
  800f67:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f6a:	ff 45 08             	incl   0x8(%ebp)
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	84 c0                	test   %al,%al
  800f74:	75 f1                	jne    800f67 <strlen+0xf>
		n++;
	return n;
  800f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f88:	eb 09                	jmp    800f93 <strnlen+0x18>
		n++;
  800f8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	ff 4d 0c             	decl   0xc(%ebp)
  800f93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f97:	74 09                	je     800fa2 <strnlen+0x27>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	84 c0                	test   %al,%al
  800fa0:	75 e8                	jne    800f8a <strnlen+0xf>
		n++;
	return n;
  800fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fb3:	90                   	nop
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8d 50 01             	lea    0x1(%eax),%edx
  800fba:	89 55 08             	mov    %edx,0x8(%ebp)
  800fbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc6:	8a 12                	mov    (%edx),%dl
  800fc8:	88 10                	mov    %dl,(%eax)
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	75 e4                	jne    800fb4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fe1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe8:	eb 1f                	jmp    801009 <strncpy+0x34>
		*dst++ = *src;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8d 50 01             	lea    0x1(%eax),%edx
  800ff0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff6:	8a 12                	mov    (%edx),%dl
  800ff8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	74 03                	je     801006 <strncpy+0x31>
			src++;
  801003:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801006:	ff 45 fc             	incl   -0x4(%ebp)
  801009:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100f:	72 d9                	jb     800fea <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801022:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801026:	74 30                	je     801058 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801028:	eb 16                	jmp    801040 <strlcpy+0x2a>
			*dst++ = *src++;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 08             	mov    %edx,0x8(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	8d 4a 01             	lea    0x1(%edx),%ecx
  801039:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80103c:	8a 12                	mov    (%edx),%dl
  80103e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801040:	ff 4d 10             	decl   0x10(%ebp)
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	74 09                	je     801052 <strlcpy+0x3c>
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	84 c0                	test   %al,%al
  801050:	75 d8                	jne    80102a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105e:	29 c2                	sub    %eax,%edx
  801060:	89 d0                	mov    %edx,%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801067:	eb 06                	jmp    80106f <strcmp+0xb>
		p++, q++;
  801069:	ff 45 08             	incl   0x8(%ebp)
  80106c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	84 c0                	test   %al,%al
  801076:	74 0e                	je     801086 <strcmp+0x22>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 10                	mov    (%eax),%dl
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	38 c2                	cmp    %al,%dl
  801084:	74 e3                	je     801069 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	0f b6 d0             	movzbl %al,%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	0f b6 c0             	movzbl %al,%eax
  801096:	29 c2                	sub    %eax,%edx
  801098:	89 d0                	mov    %edx,%eax
}
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80109f:	eb 09                	jmp    8010aa <strncmp+0xe>
		n--, p++, q++;
  8010a1:	ff 4d 10             	decl   0x10(%ebp)
  8010a4:	ff 45 08             	incl   0x8(%ebp)
  8010a7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ae:	74 17                	je     8010c7 <strncmp+0x2b>
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	84 c0                	test   %al,%al
  8010b7:	74 0e                	je     8010c7 <strncmp+0x2b>
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 da                	je     8010a1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cb:	75 07                	jne    8010d4 <strncmp+0x38>
		return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d2:	eb 14                	jmp    8010e8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f b6 d0             	movzbl %al,%edx
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	0f b6 c0             	movzbl %al,%eax
  8010e4:	29 c2                	sub    %eax,%edx
  8010e6:	89 d0                	mov    %edx,%eax
}
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010f6:	eb 12                	jmp    80110a <strchr+0x20>
		if (*s == c)
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801100:	75 05                	jne    801107 <strchr+0x1d>
			return (char *) s;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	eb 11                	jmp    801118 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	84 c0                	test   %al,%al
  801111:	75 e5                	jne    8010f8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801126:	eb 0d                	jmp    801135 <strfind+0x1b>
		if (*s == c)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801130:	74 0e                	je     801140 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	84 c0                	test   %al,%al
  80113c:	75 ea                	jne    801128 <strfind+0xe>
  80113e:	eb 01                	jmp    801141 <strfind+0x27>
		if (*s == c)
			break;
  801140:	90                   	nop
	return (char *) s;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801152:	8b 45 10             	mov    0x10(%ebp),%eax
  801155:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801158:	eb 0e                	jmp    801168 <memset+0x22>
		*p++ = c;
  80115a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115d:	8d 50 01             	lea    0x1(%eax),%edx
  801160:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801163:	8b 55 0c             	mov    0xc(%ebp),%edx
  801166:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801168:	ff 4d f8             	decl   -0x8(%ebp)
  80116b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80116f:	79 e9                	jns    80115a <memset+0x14>
		*p++ = c;

	return v;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801188:	eb 16                	jmp    8011a0 <memcpy+0x2a>
		*d++ = *s++;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801193:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801196:	8d 4a 01             	lea    0x1(%edx),%ecx
  801199:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119c:	8a 12                	mov    (%edx),%dl
  80119e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 dd                	jne    80118a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011ca:	73 50                	jae    80121c <memmove+0x6a>
  8011cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011d7:	76 43                	jbe    80121c <memmove+0x6a>
		s += n;
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011df:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011e5:	eb 10                	jmp    8011f7 <memmove+0x45>
			*--d = *--s;
  8011e7:	ff 4d f8             	decl   -0x8(%ebp)
  8011ea:	ff 4d fc             	decl   -0x4(%ebp)
  8011ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f0:	8a 10                	mov    (%eax),%dl
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801200:	85 c0                	test   %eax,%eax
  801202:	75 e3                	jne    8011e7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801204:	eb 23                	jmp    801229 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801212:	8d 4a 01             	lea    0x1(%edx),%ecx
  801215:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801218:	8a 12                	mov    (%edx),%dl
  80121a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801222:	89 55 10             	mov    %edx,0x10(%ebp)
  801225:	85 c0                	test   %eax,%eax
  801227:	75 dd                	jne    801206 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801240:	eb 2a                	jmp    80126c <memcmp+0x3e>
		if (*s1 != *s2)
  801242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801245:	8a 10                	mov    (%eax),%dl
  801247:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	38 c2                	cmp    %al,%dl
  80124e:	74 16                	je     801266 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	0f b6 d0             	movzbl %al,%edx
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f b6 c0             	movzbl %al,%eax
  801260:	29 c2                	sub    %eax,%edx
  801262:	89 d0                	mov    %edx,%eax
  801264:	eb 18                	jmp    80127e <memcmp+0x50>
		s1++, s2++;
  801266:	ff 45 fc             	incl   -0x4(%ebp)
  801269:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801272:	89 55 10             	mov    %edx,0x10(%ebp)
  801275:	85 c0                	test   %eax,%eax
  801277:	75 c9                	jne    801242 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801286:	8b 55 08             	mov    0x8(%ebp),%edx
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801291:	eb 15                	jmp    8012a8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f b6 d0             	movzbl %al,%edx
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	0f b6 c0             	movzbl %al,%eax
  8012a1:	39 c2                	cmp    %eax,%edx
  8012a3:	74 0d                	je     8012b2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012a5:	ff 45 08             	incl   0x8(%ebp)
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012ae:	72 e3                	jb     801293 <memfind+0x13>
  8012b0:	eb 01                	jmp    8012b3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012b2:	90                   	nop
	return (void *) s;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012cc:	eb 03                	jmp    8012d1 <strtol+0x19>
		s++;
  8012ce:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 20                	cmp    $0x20,%al
  8012d8:	74 f4                	je     8012ce <strtol+0x16>
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 09                	cmp    $0x9,%al
  8012e1:	74 eb                	je     8012ce <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 2b                	cmp    $0x2b,%al
  8012ea:	75 05                	jne    8012f1 <strtol+0x39>
		s++;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	eb 13                	jmp    801304 <strtol+0x4c>
	else if (*s == '-')
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	3c 2d                	cmp    $0x2d,%al
  8012f8:	75 0a                	jne    801304 <strtol+0x4c>
		s++, neg = 1;
  8012fa:	ff 45 08             	incl   0x8(%ebp)
  8012fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801308:	74 06                	je     801310 <strtol+0x58>
  80130a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80130e:	75 20                	jne    801330 <strtol+0x78>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 30                	cmp    $0x30,%al
  801317:	75 17                	jne    801330 <strtol+0x78>
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	40                   	inc    %eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 78                	cmp    $0x78,%al
  801321:	75 0d                	jne    801330 <strtol+0x78>
		s += 2, base = 16;
  801323:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801327:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80132e:	eb 28                	jmp    801358 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801334:	75 15                	jne    80134b <strtol+0x93>
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 30                	cmp    $0x30,%al
  80133d:	75 0c                	jne    80134b <strtol+0x93>
		s++, base = 8;
  80133f:	ff 45 08             	incl   0x8(%ebp)
  801342:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801349:	eb 0d                	jmp    801358 <strtol+0xa0>
	else if (base == 0)
  80134b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80134f:	75 07                	jne    801358 <strtol+0xa0>
		base = 10;
  801351:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	3c 2f                	cmp    $0x2f,%al
  80135f:	7e 19                	jle    80137a <strtol+0xc2>
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	3c 39                	cmp    $0x39,%al
  801368:	7f 10                	jg     80137a <strtol+0xc2>
			dig = *s - '0';
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	0f be c0             	movsbl %al,%eax
  801372:	83 e8 30             	sub    $0x30,%eax
  801375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801378:	eb 42                	jmp    8013bc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	3c 60                	cmp    $0x60,%al
  801381:	7e 19                	jle    80139c <strtol+0xe4>
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	3c 7a                	cmp    $0x7a,%al
  80138a:	7f 10                	jg     80139c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	0f be c0             	movsbl %al,%eax
  801394:	83 e8 57             	sub    $0x57,%eax
  801397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80139a:	eb 20                	jmp    8013bc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 40                	cmp    $0x40,%al
  8013a3:	7e 39                	jle    8013de <strtol+0x126>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	3c 5a                	cmp    $0x5a,%al
  8013ac:	7f 30                	jg     8013de <strtol+0x126>
			dig = *s - 'A' + 10;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	0f be c0             	movsbl %al,%eax
  8013b6:	83 e8 37             	sub    $0x37,%eax
  8013b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013c2:	7d 19                	jge    8013dd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013c4:	ff 45 08             	incl   0x8(%ebp)
  8013c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ca:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013ce:	89 c2                	mov    %eax,%edx
  8013d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d3:	01 d0                	add    %edx,%eax
  8013d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013d8:	e9 7b ff ff ff       	jmp    801358 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013dd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e2:	74 08                	je     8013ec <strtol+0x134>
		*endptr = (char *) s;
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ea:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f0:	74 07                	je     8013f9 <strtol+0x141>
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	f7 d8                	neg    %eax
  8013f7:	eb 03                	jmp    8013fc <strtol+0x144>
  8013f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <ltostr>:

void
ltostr(long value, char *str)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80140b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801412:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801416:	79 13                	jns    80142b <ltostr+0x2d>
	{
		neg = 1;
  801418:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801425:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801428:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801433:	99                   	cltd   
  801434:	f7 f9                	idiv   %ecx
  801436:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801442:	89 c2                	mov    %eax,%edx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	01 d0                	add    %edx,%eax
  801449:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144c:	83 c2 30             	add    $0x30,%edx
  80144f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801454:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801459:	f7 e9                	imul   %ecx
  80145b:	c1 fa 02             	sar    $0x2,%edx
  80145e:	89 c8                	mov    %ecx,%eax
  801460:	c1 f8 1f             	sar    $0x1f,%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
  801467:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80146a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80146d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801472:	f7 e9                	imul   %ecx
  801474:	c1 fa 02             	sar    $0x2,%edx
  801477:	89 c8                	mov    %ecx,%eax
  801479:	c1 f8 1f             	sar    $0x1f,%eax
  80147c:	29 c2                	sub    %eax,%edx
  80147e:	89 d0                	mov    %edx,%eax
  801480:	c1 e0 02             	shl    $0x2,%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	01 c0                	add    %eax,%eax
  801487:	29 c1                	sub    %eax,%ecx
  801489:	89 ca                	mov    %ecx,%edx
  80148b:	85 d2                	test   %edx,%edx
  80148d:	75 9c                	jne    80142b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80148f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801499:	48                   	dec    %eax
  80149a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80149d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014a1:	74 3d                	je     8014e0 <ltostr+0xe2>
		start = 1 ;
  8014a3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014aa:	eb 34                	jmp    8014e0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8014ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	01 d0                	add    %edx,%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	01 c2                	add    %eax,%edx
  8014c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	01 c8                	add    %ecx,%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	01 c2                	add    %eax,%edx
  8014d5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014d8:	88 02                	mov    %al,(%edx)
		start++ ;
  8014da:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014dd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e6:	7c c4                	jl     8014ac <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ee:	01 d0                	add    %edx,%eax
  8014f0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014fc:	ff 75 08             	pushl  0x8(%ebp)
  8014ff:	e8 54 fa ff ff       	call   800f58 <strlen>
  801504:	83 c4 04             	add    $0x4,%esp
  801507:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	e8 46 fa ff ff       	call   800f58 <strlen>
  801512:	83 c4 04             	add    $0x4,%esp
  801515:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801526:	eb 17                	jmp    80153f <strcconcat+0x49>
		final[s] = str1[s] ;
  801528:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152b:	8b 45 10             	mov    0x10(%ebp),%eax
  80152e:	01 c2                	add    %eax,%edx
  801530:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	01 c8                	add    %ecx,%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80153c:	ff 45 fc             	incl   -0x4(%ebp)
  80153f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801542:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801545:	7c e1                	jl     801528 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801547:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80154e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801555:	eb 1f                	jmp    801576 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801557:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155a:	8d 50 01             	lea    0x1(%eax),%edx
  80155d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801560:	89 c2                	mov    %eax,%edx
  801562:	8b 45 10             	mov    0x10(%ebp),%eax
  801565:	01 c2                	add    %eax,%edx
  801567:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	01 c8                	add    %ecx,%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801579:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80157c:	7c d9                	jl     801557 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80157e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801581:	8b 45 10             	mov    0x10(%ebp),%eax
  801584:	01 d0                	add    %edx,%eax
  801586:	c6 00 00             	movb   $0x0,(%eax)
}
  801589:	90                   	nop
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801598:	8b 45 14             	mov    0x14(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a7:	01 d0                	add    %edx,%eax
  8015a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015af:	eb 0c                	jmp    8015bd <strsplit+0x31>
			*string++ = 0;
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8d 50 01             	lea    0x1(%eax),%edx
  8015b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ba:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8a 00                	mov    (%eax),%al
  8015c2:	84 c0                	test   %al,%al
  8015c4:	74 18                	je     8015de <strsplit+0x52>
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	0f be c0             	movsbl %al,%eax
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	e8 13 fb ff ff       	call   8010ea <strchr>
  8015d7:	83 c4 08             	add    $0x8,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	75 d3                	jne    8015b1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	84 c0                	test   %al,%al
  8015e5:	74 5a                	je     801641 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	83 f8 0f             	cmp    $0xf,%eax
  8015ef:	75 07                	jne    8015f8 <strsplit+0x6c>
		{
			return 0;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	eb 66                	jmp    80165e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fb:	8b 00                	mov    (%eax),%eax
  8015fd:	8d 48 01             	lea    0x1(%eax),%ecx
  801600:	8b 55 14             	mov    0x14(%ebp),%edx
  801603:	89 0a                	mov    %ecx,(%edx)
  801605:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	01 c2                	add    %eax,%edx
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801616:	eb 03                	jmp    80161b <strsplit+0x8f>
			string++;
  801618:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	74 8b                	je     8015af <strsplit+0x23>
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	0f be c0             	movsbl %al,%eax
  80162c:	50                   	push   %eax
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	e8 b5 fa ff ff       	call   8010ea <strchr>
  801635:	83 c4 08             	add    $0x8,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	74 dc                	je     801618 <strsplit+0x8c>
			string++;
	}
  80163c:	e9 6e ff ff ff       	jmp    8015af <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801641:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801642:	8b 45 14             	mov    0x14(%ebp),%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80164e:	8b 45 10             	mov    0x10(%ebp),%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801659:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	57                   	push   %edi
  801664:	56                   	push   %esi
  801665:	53                   	push   %ebx
  801666:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801672:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801675:	8b 7d 18             	mov    0x18(%ebp),%edi
  801678:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80167b:	cd 30                	int    $0x30
  80167d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	8b 45 10             	mov    0x10(%ebp),%eax
  801694:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801697:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	52                   	push   %edx
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	50                   	push   %eax
  8016a7:	6a 00                	push   $0x0
  8016a9:	e8 b2 ff ff ff       	call   801660 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	90                   	nop
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 01                	push   $0x1
  8016c3:	e8 98 ff ff ff       	call   801660 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	6a 05                	push   $0x5
  8016e0:	e8 7b ff ff ff       	call   801660 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
  801700:	51                   	push   %ecx
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 06                	push   $0x6
  801705:	e8 56 ff ff ff       	call   801660 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801710:	5b                   	pop    %ebx
  801711:	5e                   	pop    %esi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	52                   	push   %edx
  801724:	50                   	push   %eax
  801725:	6a 07                	push   $0x7
  801727:	e8 34 ff ff ff       	call   801660 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	ff 75 0c             	pushl  0xc(%ebp)
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	6a 08                	push   $0x8
  801742:	e8 19 ff ff ff       	call   801660 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 09                	push   $0x9
  80175b:	e8 00 ff ff ff       	call   801660 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 0a                	push   $0xa
  801774:	e8 e7 fe ff ff       	call   801660 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 0b                	push   $0xb
  80178d:	e8 ce fe ff ff       	call   801660 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	6a 0f                	push   $0xf
  8017a8:	e8 b3 fe ff ff       	call   801660 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 10                	push   $0x10
  8017c4:	e8 97 fe ff ff       	call   801660 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 10             	pushl  0x10(%ebp)
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 11                	push   $0x11
  8017e1:	e8 7a fe ff ff       	call   801660 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e9:	90                   	nop
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 0c                	push   $0xc
  8017fb:	e8 60 fe ff ff       	call   801660 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 0d                	push   $0xd
  801815:	e8 46 fe ff ff       	call   801660 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 0e                	push   $0xe
  80182e:	e8 2d fe ff ff       	call   801660 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 13                	push   $0x13
  801848:	e8 13 fe ff ff       	call   801660 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 14                	push   $0x14
  801862:	e8 f9 fd ff ff       	call   801660 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	90                   	nop
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_cputc>:


void
sys_cputc(const char c)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801879:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 15                	push   $0x15
  801888:	e8 d3 fd ff ff       	call   801660 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 16                	push   $0x16
  8018a2:	e8 b9 fd ff ff       	call   801660 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	90                   	nop
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	50                   	push   %eax
  8018bd:	6a 17                	push   $0x17
  8018bf:	e8 9c fd ff ff       	call   801660 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 1a                	push   $0x1a
  8018dc:	e8 7f fd ff ff       	call   801660 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 18                	push   $0x18
  8018f9:	e8 62 fd ff ff       	call   801660 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	90                   	nop
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 19                	push   $0x19
  801917:	e8 44 fd ff ff       	call   801660 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	8b 45 10             	mov    0x10(%ebp),%eax
  80192b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80192e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801931:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	51                   	push   %ecx
  80193b:	52                   	push   %edx
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	50                   	push   %eax
  801940:	6a 1b                	push   $0x1b
  801942:	e8 19 fd ff ff       	call   801660 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80194f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	6a 1c                	push   $0x1c
  80195f:	e8 fc fc ff ff       	call   801660 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80196c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	51                   	push   %ecx
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 1d                	push   $0x1d
  80197e:	e8 dd fc ff ff       	call   801660 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 1e                	push   $0x1e
  80199b:	e8 c0 fc ff ff       	call   801660 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 1f                	push   $0x1f
  8019b4:	e8 a7 fc ff ff       	call   801660 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 14             	pushl  0x14(%ebp)
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	50                   	push   %eax
  8019d0:	6a 20                	push   $0x20
  8019d2:	e8 89 fc ff ff       	call   801660 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	50                   	push   %eax
  8019eb:	6a 21                	push   $0x21
  8019ed:	e8 6e fc ff ff       	call   801660 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	50                   	push   %eax
  801a07:	6a 22                	push   $0x22
  801a09:	e8 52 fc ff ff       	call   801660 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 02                	push   $0x2
  801a22:	e8 39 fc ff ff       	call   801660 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 03                	push   $0x3
  801a3b:	e8 20 fc ff ff       	call   801660 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 04                	push   $0x4
  801a54:	e8 07 fc ff ff       	call   801660 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_exit_env>:


void sys_exit_env(void)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 23                	push   $0x23
  801a6d:	e8 ee fb ff ff       	call   801660 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a81:	8d 50 04             	lea    0x4(%eax),%edx
  801a84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	52                   	push   %edx
  801a8e:	50                   	push   %eax
  801a8f:	6a 24                	push   $0x24
  801a91:	e8 ca fb ff ff       	call   801660 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
	return result;
  801a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa2:	89 01                	mov    %eax,(%ecx)
  801aa4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	c9                   	leave  
  801aab:	c2 04 00             	ret    $0x4

00801aae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 12                	push   $0x12
  801ac0:	e8 9b fb ff ff       	call   801660 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_rcr2>:
uint32 sys_rcr2()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 25                	push   $0x25
  801ada:	e8 81 fb ff ff       	call   801660 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	50                   	push   %eax
  801afd:	6a 26                	push   $0x26
  801aff:	e8 5c fb ff ff       	call   801660 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return ;
  801b07:	90                   	nop
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <rsttst>:
void rsttst()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 28                	push   $0x28
  801b19:	e8 42 fb ff ff       	call   801660 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b30:	8b 55 18             	mov    0x18(%ebp),%edx
  801b33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	ff 75 10             	pushl  0x10(%ebp)
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	6a 27                	push   $0x27
  801b44:	e8 17 fb ff ff       	call   801660 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <chktst>:
void chktst(uint32 n)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	6a 29                	push   $0x29
  801b5f:	e8 fc fa ff ff       	call   801660 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
	return ;
  801b67:	90                   	nop
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <inctst>:

void inctst()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 2a                	push   $0x2a
  801b79:	e8 e2 fa ff ff       	call   801660 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <gettst>:
uint32 gettst()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 2b                	push   $0x2b
  801b93:	e8 c8 fa ff ff       	call   801660 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 2c                	push   $0x2c
  801baf:	e8 ac fa ff ff       	call   801660 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
  801bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bbe:	75 07                	jne    801bc7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc5:	eb 05                	jmp    801bcc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 2c                	push   $0x2c
  801be0:	e8 7b fa ff ff       	call   801660 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
  801be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801beb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bef:	75 07                	jne    801bf8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	eb 05                	jmp    801bfd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 2c                	push   $0x2c
  801c11:	e8 4a fa ff ff       	call   801660 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
  801c19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c1c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c20:	75 07                	jne    801c29 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	eb 05                	jmp    801c2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 2c                	push   $0x2c
  801c42:	e8 19 fa ff ff       	call   801660 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
  801c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c51:	75 07                	jne    801c5a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c53:	b8 01 00 00 00       	mov    $0x1,%eax
  801c58:	eb 05                	jmp    801c5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	ff 75 08             	pushl  0x8(%ebp)
  801c6f:	6a 2d                	push   $0x2d
  801c71:	e8 ea f9 ff ff       	call   801660 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
	return ;
  801c79:	90                   	nop
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	53                   	push   %ebx
  801c8f:	51                   	push   %ecx
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 2e                	push   $0x2e
  801c94:	e8 c7 f9 ff ff       	call   801660 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 2f                	push   $0x2f
  801cb4:	e8 a7 f9 ff ff       	call   801660 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__udivdi3>:
  801cc0:	55                   	push   %ebp
  801cc1:	57                   	push   %edi
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 1c             	sub    $0x1c,%esp
  801cc7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ccb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd7:	89 ca                	mov    %ecx,%edx
  801cd9:	89 f8                	mov    %edi,%eax
  801cdb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cdf:	85 f6                	test   %esi,%esi
  801ce1:	75 2d                	jne    801d10 <__udivdi3+0x50>
  801ce3:	39 cf                	cmp    %ecx,%edi
  801ce5:	77 65                	ja     801d4c <__udivdi3+0x8c>
  801ce7:	89 fd                	mov    %edi,%ebp
  801ce9:	85 ff                	test   %edi,%edi
  801ceb:	75 0b                	jne    801cf8 <__udivdi3+0x38>
  801ced:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf2:	31 d2                	xor    %edx,%edx
  801cf4:	f7 f7                	div    %edi
  801cf6:	89 c5                	mov    %eax,%ebp
  801cf8:	31 d2                	xor    %edx,%edx
  801cfa:	89 c8                	mov    %ecx,%eax
  801cfc:	f7 f5                	div    %ebp
  801cfe:	89 c1                	mov    %eax,%ecx
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	f7 f5                	div    %ebp
  801d04:	89 cf                	mov    %ecx,%edi
  801d06:	89 fa                	mov    %edi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	39 ce                	cmp    %ecx,%esi
  801d12:	77 28                	ja     801d3c <__udivdi3+0x7c>
  801d14:	0f bd fe             	bsr    %esi,%edi
  801d17:	83 f7 1f             	xor    $0x1f,%edi
  801d1a:	75 40                	jne    801d5c <__udivdi3+0x9c>
  801d1c:	39 ce                	cmp    %ecx,%esi
  801d1e:	72 0a                	jb     801d2a <__udivdi3+0x6a>
  801d20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d24:	0f 87 9e 00 00 00    	ja     801dc8 <__udivdi3+0x108>
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	89 fa                	mov    %edi,%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d 76 00             	lea    0x0(%esi),%esi
  801d3c:	31 ff                	xor    %edi,%edi
  801d3e:	31 c0                	xor    %eax,%eax
  801d40:	89 fa                	mov    %edi,%edx
  801d42:	83 c4 1c             	add    $0x1c,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	f7 f7                	div    %edi
  801d50:	31 ff                	xor    %edi,%edi
  801d52:	89 fa                	mov    %edi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d61:	89 eb                	mov    %ebp,%ebx
  801d63:	29 fb                	sub    %edi,%ebx
  801d65:	89 f9                	mov    %edi,%ecx
  801d67:	d3 e6                	shl    %cl,%esi
  801d69:	89 c5                	mov    %eax,%ebp
  801d6b:	88 d9                	mov    %bl,%cl
  801d6d:	d3 ed                	shr    %cl,%ebp
  801d6f:	89 e9                	mov    %ebp,%ecx
  801d71:	09 f1                	or     %esi,%ecx
  801d73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d77:	89 f9                	mov    %edi,%ecx
  801d79:	d3 e0                	shl    %cl,%eax
  801d7b:	89 c5                	mov    %eax,%ebp
  801d7d:	89 d6                	mov    %edx,%esi
  801d7f:	88 d9                	mov    %bl,%cl
  801d81:	d3 ee                	shr    %cl,%esi
  801d83:	89 f9                	mov    %edi,%ecx
  801d85:	d3 e2                	shl    %cl,%edx
  801d87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d8b:	88 d9                	mov    %bl,%cl
  801d8d:	d3 e8                	shr    %cl,%eax
  801d8f:	09 c2                	or     %eax,%edx
  801d91:	89 d0                	mov    %edx,%eax
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	f7 74 24 0c          	divl   0xc(%esp)
  801d99:	89 d6                	mov    %edx,%esi
  801d9b:	89 c3                	mov    %eax,%ebx
  801d9d:	f7 e5                	mul    %ebp
  801d9f:	39 d6                	cmp    %edx,%esi
  801da1:	72 19                	jb     801dbc <__udivdi3+0xfc>
  801da3:	74 0b                	je     801db0 <__udivdi3+0xf0>
  801da5:	89 d8                	mov    %ebx,%eax
  801da7:	31 ff                	xor    %edi,%edi
  801da9:	e9 58 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801dae:	66 90                	xchg   %ax,%ax
  801db0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801db4:	89 f9                	mov    %edi,%ecx
  801db6:	d3 e2                	shl    %cl,%edx
  801db8:	39 c2                	cmp    %eax,%edx
  801dba:	73 e9                	jae    801da5 <__udivdi3+0xe5>
  801dbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dbf:	31 ff                	xor    %edi,%edi
  801dc1:	e9 40 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	31 c0                	xor    %eax,%eax
  801dca:	e9 37 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801dcf:	90                   	nop

00801dd0 <__umoddi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ddb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ddf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801de7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801deb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801def:	89 f3                	mov    %esi,%ebx
  801df1:	89 fa                	mov    %edi,%edx
  801df3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801df7:	89 34 24             	mov    %esi,(%esp)
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	75 1a                	jne    801e18 <__umoddi3+0x48>
  801dfe:	39 f7                	cmp    %esi,%edi
  801e00:	0f 86 a2 00 00 00    	jbe    801ea8 <__umoddi3+0xd8>
  801e06:	89 c8                	mov    %ecx,%eax
  801e08:	89 f2                	mov    %esi,%edx
  801e0a:	f7 f7                	div    %edi
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	31 d2                	xor    %edx,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	39 f0                	cmp    %esi,%eax
  801e1a:	0f 87 ac 00 00 00    	ja     801ecc <__umoddi3+0xfc>
  801e20:	0f bd e8             	bsr    %eax,%ebp
  801e23:	83 f5 1f             	xor    $0x1f,%ebp
  801e26:	0f 84 ac 00 00 00    	je     801ed8 <__umoddi3+0x108>
  801e2c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e31:	29 ef                	sub    %ebp,%edi
  801e33:	89 fe                	mov    %edi,%esi
  801e35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e39:	89 e9                	mov    %ebp,%ecx
  801e3b:	d3 e0                	shl    %cl,%eax
  801e3d:	89 d7                	mov    %edx,%edi
  801e3f:	89 f1                	mov    %esi,%ecx
  801e41:	d3 ef                	shr    %cl,%edi
  801e43:	09 c7                	or     %eax,%edi
  801e45:	89 e9                	mov    %ebp,%ecx
  801e47:	d3 e2                	shl    %cl,%edx
  801e49:	89 14 24             	mov    %edx,(%esp)
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	d3 e0                	shl    %cl,%eax
  801e50:	89 c2                	mov    %eax,%edx
  801e52:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e56:	d3 e0                	shl    %cl,%eax
  801e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e60:	89 f1                	mov    %esi,%ecx
  801e62:	d3 e8                	shr    %cl,%eax
  801e64:	09 d0                	or     %edx,%eax
  801e66:	d3 eb                	shr    %cl,%ebx
  801e68:	89 da                	mov    %ebx,%edx
  801e6a:	f7 f7                	div    %edi
  801e6c:	89 d3                	mov    %edx,%ebx
  801e6e:	f7 24 24             	mull   (%esp)
  801e71:	89 c6                	mov    %eax,%esi
  801e73:	89 d1                	mov    %edx,%ecx
  801e75:	39 d3                	cmp    %edx,%ebx
  801e77:	0f 82 87 00 00 00    	jb     801f04 <__umoddi3+0x134>
  801e7d:	0f 84 91 00 00 00    	je     801f14 <__umoddi3+0x144>
  801e83:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e87:	29 f2                	sub    %esi,%edx
  801e89:	19 cb                	sbb    %ecx,%ebx
  801e8b:	89 d8                	mov    %ebx,%eax
  801e8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e91:	d3 e0                	shl    %cl,%eax
  801e93:	89 e9                	mov    %ebp,%ecx
  801e95:	d3 ea                	shr    %cl,%edx
  801e97:	09 d0                	or     %edx,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	d3 eb                	shr    %cl,%ebx
  801e9d:	89 da                	mov    %ebx,%edx
  801e9f:	83 c4 1c             	add    $0x1c,%esp
  801ea2:	5b                   	pop    %ebx
  801ea3:	5e                   	pop    %esi
  801ea4:	5f                   	pop    %edi
  801ea5:	5d                   	pop    %ebp
  801ea6:	c3                   	ret    
  801ea7:	90                   	nop
  801ea8:	89 fd                	mov    %edi,%ebp
  801eaa:	85 ff                	test   %edi,%edi
  801eac:	75 0b                	jne    801eb9 <__umoddi3+0xe9>
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	31 d2                	xor    %edx,%edx
  801eb5:	f7 f7                	div    %edi
  801eb7:	89 c5                	mov    %eax,%ebp
  801eb9:	89 f0                	mov    %esi,%eax
  801ebb:	31 d2                	xor    %edx,%edx
  801ebd:	f7 f5                	div    %ebp
  801ebf:	89 c8                	mov    %ecx,%eax
  801ec1:	f7 f5                	div    %ebp
  801ec3:	89 d0                	mov    %edx,%eax
  801ec5:	e9 44 ff ff ff       	jmp    801e0e <__umoddi3+0x3e>
  801eca:	66 90                	xchg   %ax,%ax
  801ecc:	89 c8                	mov    %ecx,%eax
  801ece:	89 f2                	mov    %esi,%edx
  801ed0:	83 c4 1c             	add    $0x1c,%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	3b 04 24             	cmp    (%esp),%eax
  801edb:	72 06                	jb     801ee3 <__umoddi3+0x113>
  801edd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ee1:	77 0f                	ja     801ef2 <__umoddi3+0x122>
  801ee3:	89 f2                	mov    %esi,%edx
  801ee5:	29 f9                	sub    %edi,%ecx
  801ee7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801eeb:	89 14 24             	mov    %edx,(%esp)
  801eee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ef2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ef6:	8b 14 24             	mov    (%esp),%edx
  801ef9:	83 c4 1c             	add    $0x1c,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    
  801f01:	8d 76 00             	lea    0x0(%esi),%esi
  801f04:	2b 04 24             	sub    (%esp),%eax
  801f07:	19 fa                	sbb    %edi,%edx
  801f09:	89 d1                	mov    %edx,%ecx
  801f0b:	89 c6                	mov    %eax,%esi
  801f0d:	e9 71 ff ff ff       	jmp    801e83 <__umoddi3+0xb3>
  801f12:	66 90                	xchg   %ax,%ax
  801f14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f18:	72 ea                	jb     801f04 <__umoddi3+0x134>
  801f1a:	89 d9                	mov    %ebx,%ecx
  801f1c:	e9 62 ff ff ff       	jmp    801e83 <__umoddi3+0xb3>
