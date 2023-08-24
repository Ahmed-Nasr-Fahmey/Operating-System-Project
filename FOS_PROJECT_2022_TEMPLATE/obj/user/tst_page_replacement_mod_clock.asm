
obj/user/tst_page_replacement_mod_clock:     file format elf32-i386


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
  800031:	e8 6d 05 00 00       	call   8005a3 <libmain>
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
  800060:	68 00 20 80 00       	push   $0x802000
  800065:	6a 15                	push   $0x15
  800067:	68 44 20 80 00       	push   $0x802044
  80006c:	e8 81 06 00 00       	call   8006f2 <_panic>
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
  800096:	68 00 20 80 00       	push   $0x802000
  80009b:	6a 16                	push   $0x16
  80009d:	68 44 20 80 00       	push   $0x802044
  8000a2:	e8 4b 06 00 00       	call   8006f2 <_panic>
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
  8000cc:	68 00 20 80 00       	push   $0x802000
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 44 20 80 00       	push   $0x802044
  8000d8:	e8 15 06 00 00       	call   8006f2 <_panic>
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
  800102:	68 00 20 80 00       	push   $0x802000
  800107:	6a 18                	push   $0x18
  800109:	68 44 20 80 00       	push   $0x802044
  80010e:	e8 df 05 00 00       	call   8006f2 <_panic>
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
  800138:	68 00 20 80 00       	push   $0x802000
  80013d:	6a 19                	push   $0x19
  80013f:	68 44 20 80 00       	push   $0x802044
  800144:	e8 a9 05 00 00       	call   8006f2 <_panic>
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
  80016e:	68 00 20 80 00       	push   $0x802000
  800173:	6a 1a                	push   $0x1a
  800175:	68 44 20 80 00       	push   $0x802044
  80017a:	e8 73 05 00 00       	call   8006f2 <_panic>
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
  8001a6:	68 00 20 80 00       	push   $0x802000
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 44 20 80 00       	push   $0x802044
  8001b2:	e8 3b 05 00 00       	call   8006f2 <_panic>
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
  8001de:	68 00 20 80 00       	push   $0x802000
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 44 20 80 00       	push   $0x802044
  8001ea:	e8 03 05 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800204:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 00 20 80 00       	push   $0x802000
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 44 20 80 00       	push   $0x802044
  800222:	e8 cb 04 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80023c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 00 20 80 00       	push   $0x802000
  800253:	6a 1e                	push   $0x1e
  800255:	68 44 20 80 00       	push   $0x802044
  80025a:	e8 93 04 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800274:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 00 20 80 00       	push   $0x802000
  80028b:	6a 1f                	push   $0x1f
  80028d:	68 44 20 80 00       	push   $0x802044
  800292:	e8 5b 04 00 00       	call   8006f2 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 6c 20 80 00       	push   $0x80206c
  8002ae:	6a 20                	push   $0x20
  8002b0:	68 44 20 80 00       	push   $0x802044
  8002b5:	e8 38 04 00 00       	call   8006f2 <_panic>
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8002ba:	a0 5f 51 83 00       	mov    0x83515f,%al
  8002bf:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002c2:	a0 5f 61 83 00       	mov    0x83615f,%al
  8002c7:	88 45 c6             	mov    %al,-0x3a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002d1:	eb 37                	jmp    80030a <_main+0x2d2>
	{
		arr[i] = -1 ;
  8002d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002d6:	05 60 a1 82 00       	add    $0x82a160,%eax
  8002db:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002de:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002e9:	8a 12                	mov    (%edx),%dl
  8002eb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002ed:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f2:	40                   	inc    %eax
  8002f3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002fd:	40                   	inc    %eax
  8002fe:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800303:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80030a:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800311:	7e c0                	jle    8002d3 <_main+0x29b>
		ptr++ ; ptr2++ ;
	}

	//===================
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x809000)  panic("modified clock algo failed");
  800313:	a1 20 30 80 00       	mov    0x803020,%eax
  800318:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800323:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032b:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 b2 20 80 00       	push   $0x8020b2
  80033a:	6a 36                	push   $0x36
  80033c:	68 44 20 80 00       	push   $0x802044
  800341:	e8 ac 03 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("modified clock algo failed");
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800351:	83 c0 18             	add    $0x18,%eax
  800354:	8b 00                	mov    (%eax),%eax
  800356:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800359:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80035c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800361:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800366:	74 14                	je     80037c <_main+0x344>
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	68 b2 20 80 00       	push   $0x8020b2
  800370:	6a 37                	push   $0x37
  800372:	68 44 20 80 00       	push   $0x802044
  800377:	e8 76 03 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x804000)  panic("modified clock algo failed");
  80037c:	a1 20 30 80 00       	mov    0x803020,%eax
  800381:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800387:	83 c0 30             	add    $0x30,%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80038f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800397:	3d 00 40 80 00       	cmp    $0x804000,%eax
  80039c:	74 14                	je     8003b2 <_main+0x37a>
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	68 b2 20 80 00       	push   $0x8020b2
  8003a6:	6a 38                	push   $0x38
  8003a8:	68 44 20 80 00       	push   $0x802044
  8003ad:	e8 40 03 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("modified clock algo failed");
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003bd:	83 c0 48             	add    $0x48,%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8003c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8003c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cd:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  8003d2:	74 14                	je     8003e8 <_main+0x3b0>
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	68 b2 20 80 00       	push   $0x8020b2
  8003dc:	6a 39                	push   $0x39
  8003de:	68 44 20 80 00       	push   $0x802044
  8003e3:	e8 0a 03 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("modified clock algo failed");
  8003e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ed:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003f3:	83 c0 60             	add    $0x60,%eax
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8003fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800403:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 b2 20 80 00       	push   $0x8020b2
  800412:	6a 3a                	push   $0x3a
  800414:	68 44 20 80 00       	push   $0x802044
  800419:	e8 d4 02 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("modified clock algo failed");
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800429:	83 c0 78             	add    $0x78,%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800431:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	3d 00 70 80 00       	cmp    $0x807000,%eax
  80043e:	74 14                	je     800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 b2 20 80 00       	push   $0x8020b2
  800448:	6a 3b                	push   $0x3b
  80044a:	68 44 20 80 00       	push   $0x802044
  80044f:	e8 9e 02 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("modified clock algo failed");
  800454:	a1 20 30 80 00       	mov    0x803020,%eax
  800459:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80045f:	05 90 00 00 00       	add    $0x90,%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800469:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80046c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800471:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 b2 20 80 00       	push   $0x8020b2
  800480:	6a 3c                	push   $0x3c
  800482:	68 44 20 80 00       	push   $0x802044
  800487:	e8 66 02 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("modified clock algo failed");
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800497:	05 a8 00 00 00       	add    $0xa8,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8004a1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a9:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004ae:	74 14                	je     8004c4 <_main+0x48c>
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	68 b2 20 80 00       	push   $0x8020b2
  8004b8:	6a 3d                	push   $0x3d
  8004ba:	68 44 20 80 00       	push   $0x802044
  8004bf:	e8 2e 02 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x808000)  panic("modified clock algo failed");
  8004c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8004cf:	05 c0 00 00 00       	add    $0xc0,%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8004d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e1:	3d 00 80 80 00       	cmp    $0x808000,%eax
  8004e6:	74 14                	je     8004fc <_main+0x4c4>
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 b2 20 80 00       	push   $0x8020b2
  8004f0:	6a 3e                	push   $0x3e
  8004f2:	68 44 20 80 00       	push   $0x802044
  8004f7:	e8 f6 01 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x803000)  panic("modified clock algo failed");
  8004fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800501:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800507:	05 d8 00 00 00       	add    $0xd8,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800511:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800514:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800519:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 b2 20 80 00       	push   $0x8020b2
  800528:	6a 3f                	push   $0x3f
  80052a:	68 44 20 80 00       	push   $0x802044
  80052f:	e8 be 01 00 00       	call   8006f2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("modified clock algo failed");
  800534:	a1 20 30 80 00       	mov    0x803020,%eax
  800539:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80053f:	05 f0 00 00 00       	add    $0xf0,%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 98             	mov    %eax,-0x68(%ebp)
  800549:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800551:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800556:	74 14                	je     80056c <_main+0x534>
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	68 b2 20 80 00       	push   $0x8020b2
  800560:	6a 40                	push   $0x40
  800562:	68 44 20 80 00       	push   $0x802044
  800567:	e8 86 01 00 00       	call   8006f2 <_panic>

		if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");
  80056c:	a1 20 30 80 00       	mov    0x803020,%eax
  800571:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  800577:	83 f8 05             	cmp    $0x5,%eax
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 d0 20 80 00       	push   $0x8020d0
  800584:	6a 42                	push   $0x42
  800586:	68 44 20 80 00       	push   $0x802044
  80058b:	e8 62 01 00 00       	call   8006f2 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [Modified CLOCK Alg.] is completed successfully.\n");
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	68 f0 20 80 00       	push   $0x8020f0
  800598:	e8 09 04 00 00       	call   8009a6 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
	return;
  8005a0:	90                   	nop
}
  8005a1:	c9                   	leave  
  8005a2:	c3                   	ret    

008005a3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005a9:	e8 4e 15 00 00       	call   801afc <sys_getenvindex>
  8005ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	c1 e0 02             	shl    $0x2,%eax
  8005c6:	01 d0                	add    %edx,%eax
  8005c8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005cf:	01 c8                	add    %ecx,%eax
  8005d1:	c1 e0 02             	shl    $0x2,%eax
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	c1 e0 02             	shl    $0x2,%eax
  8005d9:	01 d0                	add    %edx,%eax
  8005db:	c1 e0 03             	shl    $0x3,%eax
  8005de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005e3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ed:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8005f3:	84 c0                	test   %al,%al
  8005f5:	74 0f                	je     800606 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8005f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fc:	05 18 da 01 00       	add    $0x1da18,%eax
  800601:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800606:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80060a:	7e 0a                	jle    800616 <libmain+0x73>
		binaryname = argv[0];
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 14 fa ff ff       	call   800038 <_main>
  800624:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800627:	e8 dd 12 00 00       	call   801909 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	68 64 21 80 00       	push   $0x802164
  800634:	e8 6d 03 00 00       	call   8009a6 <cprintf>
  800639:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80063c:	a1 20 30 80 00       	mov    0x803020,%eax
  800641:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800647:	a1 20 30 80 00       	mov    0x803020,%eax
  80064c:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800652:	83 ec 04             	sub    $0x4,%esp
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	68 8c 21 80 00       	push   $0x80218c
  80065c:	e8 45 03 00 00       	call   8009a6 <cprintf>
  800661:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800664:	a1 20 30 80 00       	mov    0x803020,%eax
  800669:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80066f:	a1 20 30 80 00       	mov    0x803020,%eax
  800674:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80067a:	a1 20 30 80 00       	mov    0x803020,%eax
  80067f:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800685:	51                   	push   %ecx
  800686:	52                   	push   %edx
  800687:	50                   	push   %eax
  800688:	68 b4 21 80 00       	push   $0x8021b4
  80068d:	e8 14 03 00 00       	call   8009a6 <cprintf>
  800692:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800695:	a1 20 30 80 00       	mov    0x803020,%eax
  80069a:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	50                   	push   %eax
  8006a4:	68 0c 22 80 00       	push   $0x80220c
  8006a9:	e8 f8 02 00 00       	call   8009a6 <cprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	68 64 21 80 00       	push   $0x802164
  8006b9:	e8 e8 02 00 00       	call   8009a6 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006c1:	e8 5d 12 00 00       	call   801923 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006c6:	e8 19 00 00 00       	call   8006e4 <exit>
}
  8006cb:	90                   	nop
  8006cc:	c9                   	leave  
  8006cd:	c3                   	ret    

008006ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006d4:	83 ec 0c             	sub    $0xc,%esp
  8006d7:	6a 00                	push   $0x0
  8006d9:	e8 ea 13 00 00       	call   801ac8 <sys_destroy_env>
  8006de:	83 c4 10             	add    $0x10,%esp
}
  8006e1:	90                   	nop
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <exit>:

void
exit(void)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ea:	e8 3f 14 00 00       	call   801b2e <sys_exit_env>
}
  8006ef:	90                   	nop
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    

008006f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8006fb:	83 c0 04             	add    $0x4,%eax
  8006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800701:	a1 58 62 83 00       	mov    0x836258,%eax
  800706:	85 c0                	test   %eax,%eax
  800708:	74 16                	je     800720 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80070a:	a1 58 62 83 00       	mov    0x836258,%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	50                   	push   %eax
  800713:	68 20 22 80 00       	push   $0x802220
  800718:	e8 89 02 00 00       	call   8009a6 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800720:	a1 08 30 80 00       	mov    0x803008,%eax
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	ff 75 08             	pushl  0x8(%ebp)
  80072b:	50                   	push   %eax
  80072c:	68 25 22 80 00       	push   $0x802225
  800731:	e8 70 02 00 00       	call   8009a6 <cprintf>
  800736:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800739:	8b 45 10             	mov    0x10(%ebp),%eax
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	50                   	push   %eax
  800743:	e8 f3 01 00 00       	call   80093b <vcprintf>
  800748:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	6a 00                	push   $0x0
  800750:	68 41 22 80 00       	push   $0x802241
  800755:	e8 e1 01 00 00       	call   80093b <vcprintf>
  80075a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80075d:	e8 82 ff ff ff       	call   8006e4 <exit>

	// should not return here
	while (1) ;
  800762:	eb fe                	jmp    800762 <_panic+0x70>

00800764 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80076a:	a1 20 30 80 00       	mov    0x803020,%eax
  80076f:	8b 50 74             	mov    0x74(%eax),%edx
  800772:	8b 45 0c             	mov    0xc(%ebp),%eax
  800775:	39 c2                	cmp    %eax,%edx
  800777:	74 14                	je     80078d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800779:	83 ec 04             	sub    $0x4,%esp
  80077c:	68 44 22 80 00       	push   $0x802244
  800781:	6a 26                	push   $0x26
  800783:	68 90 22 80 00       	push   $0x802290
  800788:	e8 65 ff ff ff       	call   8006f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80078d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80079b:	e9 c2 00 00 00       	jmp    800862 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	01 d0                	add    %edx,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	75 08                	jne    8007bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007b8:	e9 a2 00 00 00       	jmp    80085f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007cb:	eb 69                	jmp    800836 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007db:	89 d0                	mov    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	c1 e0 03             	shl    $0x3,%eax
  8007e4:	01 c8                	add    %ecx,%eax
  8007e6:	8a 40 04             	mov    0x4(%eax),%al
  8007e9:	84 c0                	test   %al,%al
  8007eb:	75 46                	jne    800833 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8007f2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007fb:	89 d0                	mov    %edx,%eax
  8007fd:	01 c0                	add    %eax,%eax
  8007ff:	01 d0                	add    %edx,%eax
  800801:	c1 e0 03             	shl    $0x3,%eax
  800804:	01 c8                	add    %ecx,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80080b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80080e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800813:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800818:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	01 c8                	add    %ecx,%eax
  800824:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800826:	39 c2                	cmp    %eax,%edx
  800828:	75 09                	jne    800833 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80082a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800831:	eb 12                	jmp    800845 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800833:	ff 45 e8             	incl   -0x18(%ebp)
  800836:	a1 20 30 80 00       	mov    0x803020,%eax
  80083b:	8b 50 74             	mov    0x74(%eax),%edx
  80083e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800841:	39 c2                	cmp    %eax,%edx
  800843:	77 88                	ja     8007cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800845:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800849:	75 14                	jne    80085f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	68 9c 22 80 00       	push   $0x80229c
  800853:	6a 3a                	push   $0x3a
  800855:	68 90 22 80 00       	push   $0x802290
  80085a:	e8 93 fe ff ff       	call   8006f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80085f:	ff 45 f0             	incl   -0x10(%ebp)
  800862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800865:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800868:	0f 8c 32 ff ff ff    	jl     8007a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80086e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800875:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80087c:	eb 26                	jmp    8008a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80087e:	a1 20 30 80 00       	mov    0x803020,%eax
  800883:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80088c:	89 d0                	mov    %edx,%eax
  80088e:	01 c0                	add    %eax,%eax
  800890:	01 d0                	add    %edx,%eax
  800892:	c1 e0 03             	shl    $0x3,%eax
  800895:	01 c8                	add    %ecx,%eax
  800897:	8a 40 04             	mov    0x4(%eax),%al
  80089a:	3c 01                	cmp    $0x1,%al
  80089c:	75 03                	jne    8008a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80089e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	ff 45 e0             	incl   -0x20(%ebp)
  8008a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8008a9:	8b 50 74             	mov    0x74(%eax),%edx
  8008ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	77 cb                	ja     80087e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008b9:	74 14                	je     8008cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008bb:	83 ec 04             	sub    $0x4,%esp
  8008be:	68 f0 22 80 00       	push   $0x8022f0
  8008c3:	6a 44                	push   $0x44
  8008c5:	68 90 22 80 00       	push   $0x802290
  8008ca:	e8 23 fe ff ff       	call   8006f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008cf:	90                   	nop
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e3:	89 0a                	mov    %ecx,(%edx)
  8008e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e8:	88 d1                	mov    %dl,%cl
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008fb:	75 2c                	jne    800929 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008fd:	a0 24 30 80 00       	mov    0x803024,%al
  800902:	0f b6 c0             	movzbl %al,%eax
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
  800908:	8b 12                	mov    (%edx),%edx
  80090a:	89 d1                	mov    %edx,%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	83 c2 08             	add    $0x8,%edx
  800912:	83 ec 04             	sub    $0x4,%esp
  800915:	50                   	push   %eax
  800916:	51                   	push   %ecx
  800917:	52                   	push   %edx
  800918:	e8 3e 0e 00 00       	call   80175b <sys_cputs>
  80091d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
  800923:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	8d 50 01             	lea    0x1(%eax),%edx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	89 50 04             	mov    %edx,0x4(%eax)
}
  800938:	90                   	nop
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800944:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80094b:	00 00 00 
	b.cnt = 0;
  80094e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800955:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	68 d2 08 80 00       	push   $0x8008d2
  80096a:	e8 11 02 00 00       	call   800b80 <vprintfmt>
  80096f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800972:	a0 24 30 80 00       	mov    0x803024,%al
  800977:	0f b6 c0             	movzbl %al,%eax
  80097a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800980:	83 ec 04             	sub    $0x4,%esp
  800983:	50                   	push   %eax
  800984:	52                   	push   %edx
  800985:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80098b:	83 c0 08             	add    $0x8,%eax
  80098e:	50                   	push   %eax
  80098f:	e8 c7 0d 00 00       	call   80175b <sys_cputs>
  800994:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800997:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80099e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009ac:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c2:	50                   	push   %eax
  8009c3:	e8 73 ff ff ff       	call   80093b <vcprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009d9:	e8 2b 0f 00 00       	call   801909 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ed:	50                   	push   %eax
  8009ee:	e8 48 ff ff ff       	call   80093b <vcprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009f9:	e8 25 0f 00 00       	call   801923 <sys_enable_interrupt>
	return cnt;
  8009fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	53                   	push   %ebx
  800a07:	83 ec 14             	sub    $0x14,%esp
  800a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a16:	8b 45 18             	mov    0x18(%ebp),%eax
  800a19:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a21:	77 55                	ja     800a78 <printnum+0x75>
  800a23:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a26:	72 05                	jb     800a2d <printnum+0x2a>
  800a28:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a2b:	77 4b                	ja     800a78 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a2d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a30:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a33:	8b 45 18             	mov    0x18(%ebp),%eax
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	52                   	push   %edx
  800a3c:	50                   	push   %eax
  800a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a40:	ff 75 f0             	pushl  -0x10(%ebp)
  800a43:	e8 48 13 00 00       	call   801d90 <__udivdi3>
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	83 ec 04             	sub    $0x4,%esp
  800a4e:	ff 75 20             	pushl  0x20(%ebp)
  800a51:	53                   	push   %ebx
  800a52:	ff 75 18             	pushl  0x18(%ebp)
  800a55:	52                   	push   %edx
  800a56:	50                   	push   %eax
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 08             	pushl  0x8(%ebp)
  800a5d:	e8 a1 ff ff ff       	call   800a03 <printnum>
  800a62:	83 c4 20             	add    $0x20,%esp
  800a65:	eb 1a                	jmp    800a81 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	ff 75 20             	pushl  0x20(%ebp)
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a78:	ff 4d 1c             	decl   0x1c(%ebp)
  800a7b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a7f:	7f e6                	jg     800a67 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a81:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8f:	53                   	push   %ebx
  800a90:	51                   	push   %ecx
  800a91:	52                   	push   %edx
  800a92:	50                   	push   %eax
  800a93:	e8 08 14 00 00       	call   801ea0 <__umoddi3>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	05 54 25 80 00       	add    $0x802554,%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be c0             	movsbl %al,%eax
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	50                   	push   %eax
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
}
  800ab4:	90                   	nop
  800ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800abd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac1:	7e 1c                	jle    800adf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	8d 50 08             	lea    0x8(%eax),%edx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	89 10                	mov    %edx,(%eax)
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 00                	mov    (%eax),%eax
  800ad5:	83 e8 08             	sub    $0x8,%eax
  800ad8:	8b 50 04             	mov    0x4(%eax),%edx
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	eb 40                	jmp    800b1f <getuint+0x65>
	else if (lflag)
  800adf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae3:	74 1e                	je     800b03 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	8d 50 04             	lea    0x4(%eax),%edx
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	89 10                	mov    %edx,(%eax)
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 e8 04             	sub    $0x4,%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	ba 00 00 00 00       	mov    $0x0,%edx
  800b01:	eb 1c                	jmp    800b1f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	8d 50 04             	lea    0x4(%eax),%edx
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	89 10                	mov    %edx,(%eax)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	83 e8 04             	sub    $0x4,%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getint+0x25>
		return va_arg(*ap, long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 38                	jmp    800b7e <getint+0x5d>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1a                	je     800b66 <getint+0x45>
		return va_arg(*ap, long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	99                   	cltd   
  800b64:	eb 18                	jmp    800b7e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	8d 50 04             	lea    0x4(%eax),%edx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	89 10                	mov    %edx,(%eax)
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	83 e8 04             	sub    $0x4,%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	99                   	cltd   
}
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
  800b85:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b88:	eb 17                	jmp    800ba1 <vprintfmt+0x21>
			if (ch == '\0')
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	0f 84 af 03 00 00    	je     800f41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	8d 50 01             	lea    0x1(%eax),%edx
  800ba7:	89 55 10             	mov    %edx,0x10(%ebp)
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	0f b6 d8             	movzbl %al,%ebx
  800baf:	83 fb 25             	cmp    $0x25,%ebx
  800bb2:	75 d6                	jne    800b8a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bb4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bb8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bbf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bc6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bcd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	8d 50 01             	lea    0x1(%eax),%edx
  800bda:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	0f b6 d8             	movzbl %al,%ebx
  800be2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800be5:	83 f8 55             	cmp    $0x55,%eax
  800be8:	0f 87 2b 03 00 00    	ja     800f19 <vprintfmt+0x399>
  800bee:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800bf5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bf7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bfb:	eb d7                	jmp    800bd4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bfd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c01:	eb d1                	jmp    800bd4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c0d:	89 d0                	mov    %edx,%eax
  800c0f:	c1 e0 02             	shl    $0x2,%eax
  800c12:	01 d0                	add    %edx,%eax
  800c14:	01 c0                	add    %eax,%eax
  800c16:	01 d8                	add    %ebx,%eax
  800c18:	83 e8 30             	sub    $0x30,%eax
  800c1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c26:	83 fb 2f             	cmp    $0x2f,%ebx
  800c29:	7e 3e                	jle    800c69 <vprintfmt+0xe9>
  800c2b:	83 fb 39             	cmp    $0x39,%ebx
  800c2e:	7f 39                	jg     800c69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c33:	eb d5                	jmp    800c0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c35:	8b 45 14             	mov    0x14(%ebp),%eax
  800c38:	83 c0 04             	add    $0x4,%eax
  800c3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c41:	83 e8 04             	sub    $0x4,%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c49:	eb 1f                	jmp    800c6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4f:	79 83                	jns    800bd4 <vprintfmt+0x54>
				width = 0;
  800c51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c58:	e9 77 ff ff ff       	jmp    800bd4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c64:	e9 6b ff ff ff       	jmp    800bd4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6e:	0f 89 60 ff ff ff    	jns    800bd4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c81:	e9 4e ff ff ff       	jmp    800bd4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c89:	e9 46 ff ff ff       	jmp    800bd4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 14             	mov    %eax,0x14(%ebp)
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 e8 04             	sub    $0x4,%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	50                   	push   %eax
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	e9 89 02 00 00       	jmp    800f3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 c0 04             	add    $0x4,%eax
  800cb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 e8 04             	sub    $0x4,%eax
  800cc2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cc4:	85 db                	test   %ebx,%ebx
  800cc6:	79 02                	jns    800cca <vprintfmt+0x14a>
				err = -err;
  800cc8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cca:	83 fb 64             	cmp    $0x64,%ebx
  800ccd:	7f 0b                	jg     800cda <vprintfmt+0x15a>
  800ccf:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800cd6:	85 f6                	test   %esi,%esi
  800cd8:	75 19                	jne    800cf3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cda:	53                   	push   %ebx
  800cdb:	68 65 25 80 00       	push   $0x802565
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	ff 75 08             	pushl  0x8(%ebp)
  800ce6:	e8 5e 02 00 00       	call   800f49 <printfmt>
  800ceb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cee:	e9 49 02 00 00       	jmp    800f3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cf3:	56                   	push   %esi
  800cf4:	68 6e 25 80 00       	push   $0x80256e
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	ff 75 08             	pushl  0x8(%ebp)
  800cff:	e8 45 02 00 00       	call   800f49 <printfmt>
  800d04:	83 c4 10             	add    $0x10,%esp
			break;
  800d07:	e9 30 02 00 00       	jmp    800f3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 14             	mov    %eax,0x14(%ebp)
  800d15:	8b 45 14             	mov    0x14(%ebp),%eax
  800d18:	83 e8 04             	sub    $0x4,%eax
  800d1b:	8b 30                	mov    (%eax),%esi
  800d1d:	85 f6                	test   %esi,%esi
  800d1f:	75 05                	jne    800d26 <vprintfmt+0x1a6>
				p = "(null)";
  800d21:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800d26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2a:	7e 6d                	jle    800d99 <vprintfmt+0x219>
  800d2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d30:	74 67                	je     800d99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	50                   	push   %eax
  800d39:	56                   	push   %esi
  800d3a:	e8 0c 03 00 00       	call   80104b <strnlen>
  800d3f:	83 c4 10             	add    $0x10,%esp
  800d42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d45:	eb 16                	jmp    800d5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d4b:	83 ec 08             	sub    $0x8,%esp
  800d4e:	ff 75 0c             	pushl  0xc(%ebp)
  800d51:	50                   	push   %eax
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	ff d0                	call   *%eax
  800d57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d61:	7f e4                	jg     800d47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d63:	eb 34                	jmp    800d99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d69:	74 1c                	je     800d87 <vprintfmt+0x207>
  800d6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d6e:	7e 05                	jle    800d75 <vprintfmt+0x1f5>
  800d70:	83 fb 7e             	cmp    $0x7e,%ebx
  800d73:	7e 12                	jle    800d87 <vprintfmt+0x207>
					putch('?', putdat);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	6a 3f                	push   $0x3f
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
  800d85:	eb 0f                	jmp    800d96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d87:	83 ec 08             	sub    $0x8,%esp
  800d8a:	ff 75 0c             	pushl  0xc(%ebp)
  800d8d:	53                   	push   %ebx
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d96:	ff 4d e4             	decl   -0x1c(%ebp)
  800d99:	89 f0                	mov    %esi,%eax
  800d9b:	8d 70 01             	lea    0x1(%eax),%esi
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f be d8             	movsbl %al,%ebx
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	74 24                	je     800dcb <vprintfmt+0x24b>
  800da7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dab:	78 b8                	js     800d65 <vprintfmt+0x1e5>
  800dad:	ff 4d e0             	decl   -0x20(%ebp)
  800db0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800db4:	79 af                	jns    800d65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db6:	eb 13                	jmp    800dcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	6a 20                	push   $0x20
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	ff d0                	call   *%eax
  800dc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dcf:	7f e7                	jg     800db8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dd1:	e9 66 01 00 00       	jmp    800f3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ddc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ddf:	50                   	push   %eax
  800de0:	e8 3c fd ff ff       	call   800b21 <getint>
  800de5:	83 c4 10             	add    $0x10,%esp
  800de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800deb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df4:	85 d2                	test   %edx,%edx
  800df6:	79 23                	jns    800e1b <vprintfmt+0x29b>
				putch('-', putdat);
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	6a 2d                	push   $0x2d
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	ff d0                	call   *%eax
  800e05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0e:	f7 d8                	neg    %eax
  800e10:	83 d2 00             	adc    $0x0,%edx
  800e13:	f7 da                	neg    %edx
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e22:	e9 bc 00 00 00       	jmp    800ee3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e30:	50                   	push   %eax
  800e31:	e8 84 fc ff ff       	call   800aba <getuint>
  800e36:	83 c4 10             	add    $0x10,%esp
  800e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e46:	e9 98 00 00 00       	jmp    800ee3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e4b:	83 ec 08             	sub    $0x8,%esp
  800e4e:	ff 75 0c             	pushl  0xc(%ebp)
  800e51:	6a 58                	push   $0x58
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	ff d0                	call   *%eax
  800e58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 0c             	pushl  0xc(%ebp)
  800e61:	6a 58                	push   $0x58
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	6a 58                	push   $0x58
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
			break;
  800e7b:	e9 bc 00 00 00       	jmp    800f3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e80:	83 ec 08             	sub    $0x8,%esp
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	6a 30                	push   $0x30
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	ff d0                	call   *%eax
  800e8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 78                	push   $0x78
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ea0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea3:	83 c0 04             	add    $0x4,%eax
  800ea6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	83 e8 04             	sub    $0x4,%eax
  800eaf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ebb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ec2:	eb 1f                	jmp    800ee3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecd:	50                   	push   %eax
  800ece:	e8 e7 fb ff ff       	call   800aba <getuint>
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800edc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ee3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eea:	83 ec 04             	sub    $0x4,%esp
  800eed:	52                   	push   %edx
  800eee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ef1:	50                   	push   %eax
  800ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	ff 75 08             	pushl  0x8(%ebp)
  800efe:	e8 00 fb ff ff       	call   800a03 <printnum>
  800f03:	83 c4 20             	add    $0x20,%esp
			break;
  800f06:	eb 34                	jmp    800f3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	53                   	push   %ebx
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	ff d0                	call   *%eax
  800f14:	83 c4 10             	add    $0x10,%esp
			break;
  800f17:	eb 23                	jmp    800f3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	ff 75 0c             	pushl  0xc(%ebp)
  800f1f:	6a 25                	push   $0x25
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	ff d0                	call   *%eax
  800f26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f29:	ff 4d 10             	decl   0x10(%ebp)
  800f2c:	eb 03                	jmp    800f31 <vprintfmt+0x3b1>
  800f2e:	ff 4d 10             	decl   0x10(%ebp)
  800f31:	8b 45 10             	mov    0x10(%ebp),%eax
  800f34:	48                   	dec    %eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 25                	cmp    $0x25,%al
  800f39:	75 f3                	jne    800f2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f3b:	90                   	nop
		}
	}
  800f3c:	e9 47 fc ff ff       	jmp    800b88 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f52:	83 c0 04             	add    $0x4,%eax
  800f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5e:	50                   	push   %eax
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 16 fc ff ff       	call   800b80 <vprintfmt>
  800f6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f6d:	90                   	nop
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8b 40 08             	mov    0x8(%eax),%eax
  800f79:	8d 50 01             	lea    0x1(%eax),%edx
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	8b 10                	mov    (%eax),%edx
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8b 40 04             	mov    0x4(%eax),%eax
  800f8d:	39 c2                	cmp    %eax,%edx
  800f8f:	73 12                	jae    800fa3 <sprintputch+0x33>
		*b->buf++ = ch;
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	8b 00                	mov    (%eax),%eax
  800f96:	8d 48 01             	lea    0x1(%eax),%ecx
  800f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9c:	89 0a                	mov    %ecx,(%edx)
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	88 10                	mov    %dl,(%eax)
}
  800fa3:	90                   	nop
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	01 d0                	add    %edx,%eax
  800fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fcb:	74 06                	je     800fd3 <vsnprintf+0x2d>
  800fcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd1:	7f 07                	jg     800fda <vsnprintf+0x34>
		return -E_INVAL;
  800fd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd8:	eb 20                	jmp    800ffa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fda:	ff 75 14             	pushl  0x14(%ebp)
  800fdd:	ff 75 10             	pushl  0x10(%ebp)
  800fe0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	68 70 0f 80 00       	push   $0x800f70
  800fe9:	e8 92 fb ff ff       	call   800b80 <vprintfmt>
  800fee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ff4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801002:	8d 45 10             	lea    0x10(%ebp),%eax
  801005:	83 c0 04             	add    $0x4,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	ff 75 f4             	pushl  -0xc(%ebp)
  801011:	50                   	push   %eax
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	ff 75 08             	pushl  0x8(%ebp)
  801018:	e8 89 ff ff ff       	call   800fa6 <vsnprintf>
  80101d:	83 c4 10             	add    $0x10,%esp
  801020:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801023:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 06                	jmp    80103d <strlen+0x15>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	75 f1                	jne    801037 <strlen+0xf>
		n++;
	return n;
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801058:	eb 09                	jmp    801063 <strnlen+0x18>
		n++;
  80105a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	ff 4d 0c             	decl   0xc(%ebp)
  801063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801067:	74 09                	je     801072 <strnlen+0x27>
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 e8                	jne    80105a <strnlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801083:	90                   	nop
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8d 50 01             	lea    0x1(%eax),%edx
  80108a:	89 55 08             	mov    %edx,0x8(%ebp)
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	8d 4a 01             	lea    0x1(%edx),%ecx
  801093:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801096:	8a 12                	mov    (%edx),%dl
  801098:	88 10                	mov    %dl,(%eax)
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e4                	jne    801084 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b8:	eb 1f                	jmp    8010d9 <strncpy+0x34>
		*dst++ = *src;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c6:	8a 12                	mov    (%edx),%dl
  8010c8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	74 03                	je     8010d6 <strncpy+0x31>
			src++;
  8010d3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d6:	ff 45 fc             	incl   -0x4(%ebp)
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010df:	72 d9                	jb     8010ba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f6:	74 30                	je     801128 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010f8:	eb 16                	jmp    801110 <strlcpy+0x2a>
			*dst++ = *src++;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 08             	mov    %edx,0x8(%ebp)
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	8d 4a 01             	lea    0x1(%edx),%ecx
  801109:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80110c:	8a 12                	mov    (%edx),%dl
  80110e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801110:	ff 4d 10             	decl   0x10(%ebp)
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	74 09                	je     801122 <strlcpy+0x3c>
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	84 c0                	test   %al,%al
  801120:	75 d8                	jne    8010fa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801128:	8b 55 08             	mov    0x8(%ebp),%edx
  80112b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112e:	29 c2                	sub    %eax,%edx
  801130:	89 d0                	mov    %edx,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801137:	eb 06                	jmp    80113f <strcmp+0xb>
		p++, q++;
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	84 c0                	test   %al,%al
  801146:	74 0e                	je     801156 <strcmp+0x22>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 10                	mov    (%eax),%dl
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	38 c2                	cmp    %al,%dl
  801154:	74 e3                	je     801139 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f b6 d0             	movzbl %al,%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f b6 c0             	movzbl %al,%eax
  801166:	29 c2                	sub    %eax,%edx
  801168:	89 d0                	mov    %edx,%eax
}
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80116f:	eb 09                	jmp    80117a <strncmp+0xe>
		n--, p++, q++;
  801171:	ff 4d 10             	decl   0x10(%ebp)
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 17                	je     801197 <strncmp+0x2b>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	74 0e                	je     801197 <strncmp+0x2b>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 10                	mov    (%eax),%dl
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	38 c2                	cmp    %al,%dl
  801195:	74 da                	je     801171 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 07                	jne    8011a4 <strncmp+0x38>
		return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	eb 14                	jmp    8011b8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f b6 d0             	movzbl %al,%edx
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f b6 c0             	movzbl %al,%eax
  8011b4:	29 c2                	sub    %eax,%edx
  8011b6:	89 d0                	mov    %edx,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 04             	sub    $0x4,%esp
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c6:	eb 12                	jmp    8011da <strchr+0x20>
		if (*s == c)
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d0:	75 05                	jne    8011d7 <strchr+0x1d>
			return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	eb 11                	jmp    8011e8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d7:	ff 45 08             	incl   0x8(%ebp)
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	84 c0                	test   %al,%al
  8011e1:	75 e5                	jne    8011c8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 04             	sub    $0x4,%esp
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f6:	eb 0d                	jmp    801205 <strfind+0x1b>
		if (*s == c)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801200:	74 0e                	je     801210 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801202:	ff 45 08             	incl   0x8(%ebp)
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	84 c0                	test   %al,%al
  80120c:	75 ea                	jne    8011f8 <strfind+0xe>
  80120e:	eb 01                	jmp    801211 <strfind+0x27>
		if (*s == c)
			break;
  801210:	90                   	nop
	return (char *) s;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801228:	eb 0e                	jmp    801238 <memset+0x22>
		*p++ = c;
  80122a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122d:	8d 50 01             	lea    0x1(%eax),%edx
  801230:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801233:	8b 55 0c             	mov    0xc(%ebp),%edx
  801236:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801238:	ff 4d f8             	decl   -0x8(%ebp)
  80123b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80123f:	79 e9                	jns    80122a <memset+0x14>
		*p++ = c;

	return v;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801258:	eb 16                	jmp    801270 <memcpy+0x2a>
		*d++ = *s++;
  80125a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125d:	8d 50 01             	lea    0x1(%eax),%edx
  801260:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801266:	8d 4a 01             	lea    0x1(%edx),%ecx
  801269:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80126c:	8a 12                	mov    (%edx),%dl
  80126e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	8d 50 ff             	lea    -0x1(%eax),%edx
  801276:	89 55 10             	mov    %edx,0x10(%ebp)
  801279:	85 c0                	test   %eax,%eax
  80127b:	75 dd                	jne    80125a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801294:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801297:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80129a:	73 50                	jae    8012ec <memmove+0x6a>
  80129c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a7:	76 43                	jbe    8012ec <memmove+0x6a>
		s += n;
  8012a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b5:	eb 10                	jmp    8012c7 <memmove+0x45>
			*--d = *--s;
  8012b7:	ff 4d f8             	decl   -0x8(%ebp)
  8012ba:	ff 4d fc             	decl   -0x4(%ebp)
  8012bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c0:	8a 10                	mov    (%eax),%dl
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	75 e3                	jne    8012b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012d4:	eb 23                	jmp    8012f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d9:	8d 50 01             	lea    0x1(%eax),%edx
  8012dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e8:	8a 12                	mov    (%edx),%dl
  8012ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	75 dd                	jne    8012d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801310:	eb 2a                	jmp    80133c <memcmp+0x3e>
		if (*s1 != *s2)
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	8a 10                	mov    (%eax),%dl
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	38 c2                	cmp    %al,%dl
  80131e:	74 16                	je     801336 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801320:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	0f b6 d0             	movzbl %al,%edx
  801328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f b6 c0             	movzbl %al,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	eb 18                	jmp    80134e <memcmp+0x50>
		s1++, s2++;
  801336:	ff 45 fc             	incl   -0x4(%ebp)
  801339:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801342:	89 55 10             	mov    %edx,0x10(%ebp)
  801345:	85 c0                	test   %eax,%eax
  801347:	75 c9                	jne    801312 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801356:	8b 55 08             	mov    0x8(%ebp),%edx
  801359:	8b 45 10             	mov    0x10(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801361:	eb 15                	jmp    801378 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	0f b6 d0             	movzbl %al,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	0f b6 c0             	movzbl %al,%eax
  801371:	39 c2                	cmp    %eax,%edx
  801373:	74 0d                	je     801382 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80137e:	72 e3                	jb     801363 <memfind+0x13>
  801380:	eb 01                	jmp    801383 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801382:	90                   	nop
	return (void *) s;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80138e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801395:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139c:	eb 03                	jmp    8013a1 <strtol+0x19>
		s++;
  80139e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 20                	cmp    $0x20,%al
  8013a8:	74 f4                	je     80139e <strtol+0x16>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	3c 09                	cmp    $0x9,%al
  8013b1:	74 eb                	je     80139e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	3c 2b                	cmp    $0x2b,%al
  8013ba:	75 05                	jne    8013c1 <strtol+0x39>
		s++;
  8013bc:	ff 45 08             	incl   0x8(%ebp)
  8013bf:	eb 13                	jmp    8013d4 <strtol+0x4c>
	else if (*s == '-')
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	3c 2d                	cmp    $0x2d,%al
  8013c8:	75 0a                	jne    8013d4 <strtol+0x4c>
		s++, neg = 1;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
  8013cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d8:	74 06                	je     8013e0 <strtol+0x58>
  8013da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013de:	75 20                	jne    801400 <strtol+0x78>
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	3c 30                	cmp    $0x30,%al
  8013e7:	75 17                	jne    801400 <strtol+0x78>
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	40                   	inc    %eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	3c 78                	cmp    $0x78,%al
  8013f1:	75 0d                	jne    801400 <strtol+0x78>
		s += 2, base = 16;
  8013f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013fe:	eb 28                	jmp    801428 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	75 15                	jne    80141b <strtol+0x93>
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	3c 30                	cmp    $0x30,%al
  80140d:	75 0c                	jne    80141b <strtol+0x93>
		s++, base = 8;
  80140f:	ff 45 08             	incl   0x8(%ebp)
  801412:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801419:	eb 0d                	jmp    801428 <strtol+0xa0>
	else if (base == 0)
  80141b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141f:	75 07                	jne    801428 <strtol+0xa0>
		base = 10;
  801421:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2f                	cmp    $0x2f,%al
  80142f:	7e 19                	jle    80144a <strtol+0xc2>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 39                	cmp    $0x39,%al
  801438:	7f 10                	jg     80144a <strtol+0xc2>
			dig = *s - '0';
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	0f be c0             	movsbl %al,%eax
  801442:	83 e8 30             	sub    $0x30,%eax
  801445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801448:	eb 42                	jmp    80148c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 60                	cmp    $0x60,%al
  801451:	7e 19                	jle    80146c <strtol+0xe4>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 7a                	cmp    $0x7a,%al
  80145a:	7f 10                	jg     80146c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f be c0             	movsbl %al,%eax
  801464:	83 e8 57             	sub    $0x57,%eax
  801467:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80146a:	eb 20                	jmp    80148c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3c 40                	cmp    $0x40,%al
  801473:	7e 39                	jle    8014ae <strtol+0x126>
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 5a                	cmp    $0x5a,%al
  80147c:	7f 30                	jg     8014ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	0f be c0             	movsbl %al,%eax
  801486:	83 e8 37             	sub    $0x37,%eax
  801489:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801492:	7d 19                	jge    8014ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014a8:	e9 7b ff ff ff       	jmp    801428 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014b2:	74 08                	je     8014bc <strtol+0x134>
		*endptr = (char *) s;
  8014b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014c0:	74 07                	je     8014c9 <strtol+0x141>
  8014c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c5:	f7 d8                	neg    %eax
  8014c7:	eb 03                	jmp    8014cc <strtol+0x144>
  8014c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <ltostr>:

void
ltostr(long value, char *str)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e6:	79 13                	jns    8014fb <ltostr+0x2d>
	{
		neg = 1;
  8014e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801503:	99                   	cltd   
  801504:	f7 f9                	idiv   %ecx
  801506:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150c:	8d 50 01             	lea    0x1(%eax),%edx
  80150f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801512:	89 c2                	mov    %eax,%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151c:	83 c2 30             	add    $0x30,%edx
  80151f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801524:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801529:	f7 e9                	imul   %ecx
  80152b:	c1 fa 02             	sar    $0x2,%edx
  80152e:	89 c8                	mov    %ecx,%eax
  801530:	c1 f8 1f             	sar    $0x1f,%eax
  801533:	29 c2                	sub    %eax,%edx
  801535:	89 d0                	mov    %edx,%eax
  801537:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801542:	f7 e9                	imul   %ecx
  801544:	c1 fa 02             	sar    $0x2,%edx
  801547:	89 c8                	mov    %ecx,%eax
  801549:	c1 f8 1f             	sar    $0x1f,%eax
  80154c:	29 c2                	sub    %eax,%edx
  80154e:	89 d0                	mov    %edx,%eax
  801550:	c1 e0 02             	shl    $0x2,%eax
  801553:	01 d0                	add    %edx,%eax
  801555:	01 c0                	add    %eax,%eax
  801557:	29 c1                	sub    %eax,%ecx
  801559:	89 ca                	mov    %ecx,%edx
  80155b:	85 d2                	test   %edx,%edx
  80155d:	75 9c                	jne    8014fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80155f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	48                   	dec    %eax
  80156a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80156d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801571:	74 3d                	je     8015b0 <ltostr+0xe2>
		start = 1 ;
  801573:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80157a:	eb 34                	jmp    8015b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80157c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	01 d0                	add    %edx,%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	01 c2                	add    %eax,%edx
  801591:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	01 c8                	add    %ecx,%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80159d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a3:	01 c2                	add    %eax,%edx
  8015a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8015aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b6:	7c c4                	jl     80157c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	01 d0                	add    %edx,%eax
  8015c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015c3:	90                   	nop
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	e8 54 fa ff ff       	call   801028 <strlen>
  8015d4:	83 c4 04             	add    $0x4,%esp
  8015d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	e8 46 fa ff ff       	call   801028 <strlen>
  8015e2:	83 c4 04             	add    $0x4,%esp
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f6:	eb 17                	jmp    80160f <strcconcat+0x49>
		final[s] = str1[s] ;
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 c2                	add    %eax,%edx
  801600:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	01 c8                	add    %ecx,%eax
  801608:	8a 00                	mov    (%eax),%al
  80160a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80160c:	ff 45 fc             	incl   -0x4(%ebp)
  80160f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801612:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801615:	7c e1                	jl     8015f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801617:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80161e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801625:	eb 1f                	jmp    801646 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801627:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162a:	8d 50 01             	lea    0x1(%eax),%edx
  80162d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	01 c2                	add    %eax,%edx
  801637:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	01 c8                	add    %ecx,%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801643:	ff 45 f8             	incl   -0x8(%ebp)
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801649:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164c:	7c d9                	jl     801627 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c6 00 00             	movb   $0x0,(%eax)
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80165f:	8b 45 14             	mov    0x14(%ebp),%eax
  801662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801668:	8b 45 14             	mov    0x14(%ebp),%eax
  80166b:	8b 00                	mov    (%eax),%eax
  80166d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167f:	eb 0c                	jmp    80168d <strsplit+0x31>
			*string++ = 0;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8d 50 01             	lea    0x1(%eax),%edx
  801687:	89 55 08             	mov    %edx,0x8(%ebp)
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	84 c0                	test   %al,%al
  801694:	74 18                	je     8016ae <strsplit+0x52>
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	50                   	push   %eax
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	e8 13 fb ff ff       	call   8011ba <strchr>
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	75 d3                	jne    801681 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	74 5a                	je     801711 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	83 f8 0f             	cmp    $0xf,%eax
  8016bf:	75 07                	jne    8016c8 <strsplit+0x6c>
		{
			return 0;
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	eb 66                	jmp    80172e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8016d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8016d3:	89 0a                	mov    %ecx,(%edx)
  8016d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	01 c2                	add    %eax,%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e6:	eb 03                	jmp    8016eb <strsplit+0x8f>
			string++;
  8016e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	84 c0                	test   %al,%al
  8016f2:	74 8b                	je     80167f <strsplit+0x23>
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	0f be c0             	movsbl %al,%eax
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	e8 b5 fa ff ff       	call   8011ba <strchr>
  801705:	83 c4 08             	add    $0x8,%esp
  801708:	85 c0                	test   %eax,%eax
  80170a:	74 dc                	je     8016e8 <strsplit+0x8c>
			string++;
	}
  80170c:	e9 6e ff ff ff       	jmp    80167f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801711:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801712:	8b 45 14             	mov    0x14(%ebp),%eax
  801715:	8b 00                	mov    (%eax),%eax
  801717:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	01 d0                	add    %edx,%eax
  801723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801729:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	57                   	push   %edi
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801742:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801745:	8b 7d 18             	mov    0x18(%ebp),%edi
  801748:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80174b:	cd 30                	int    $0x30
  80174d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5f                   	pop    %edi
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	8b 45 10             	mov    0x10(%ebp),%eax
  801764:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801767:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	50                   	push   %eax
  801777:	6a 00                	push   $0x0
  801779:	e8 b2 ff ff ff       	call   801730 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	90                   	nop
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_cgetc>:

int
sys_cgetc(void)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 01                	push   $0x1
  801793:	e8 98 ff ff ff       	call   801730 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	52                   	push   %edx
  8017ad:	50                   	push   %eax
  8017ae:	6a 05                	push   $0x5
  8017b0:	e8 7b ff ff ff       	call   801730 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
  8017d0:	51                   	push   %ecx
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	6a 06                	push   $0x6
  8017d5:	e8 56 ff ff ff       	call   801730 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	52                   	push   %edx
  8017f4:	50                   	push   %eax
  8017f5:	6a 07                	push   $0x7
  8017f7:	e8 34 ff ff ff       	call   801730 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 0c             	pushl  0xc(%ebp)
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	6a 08                	push   $0x8
  801812:	e8 19 ff ff ff       	call   801730 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 09                	push   $0x9
  80182b:	e8 00 ff ff ff       	call   801730 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 0a                	push   $0xa
  801844:	e8 e7 fe ff ff       	call   801730 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 0b                	push   $0xb
  80185d:	e8 ce fe ff ff       	call   801730 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	6a 0f                	push   $0xf
  801878:	e8 b3 fe ff ff       	call   801730 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 10                	push   $0x10
  801894:	e8 97 fe ff ff       	call   801730 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
	return ;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 10             	pushl  0x10(%ebp)
  8018a9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	6a 11                	push   $0x11
  8018b1:	e8 7a fe ff ff       	call   801730 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 0c                	push   $0xc
  8018cb:	e8 60 fe ff ff       	call   801730 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	ff 75 08             	pushl  0x8(%ebp)
  8018e3:	6a 0d                	push   $0xd
  8018e5:	e8 46 fe ff ff       	call   801730 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 0e                	push   $0xe
  8018fe:	e8 2d fe ff ff       	call   801730 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	90                   	nop
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 13                	push   $0x13
  801918:	e8 13 fe ff ff       	call   801730 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 14                	push   $0x14
  801932:	e8 f9 fd ff ff       	call   801730 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_cputc>:


void
sys_cputc(const char c)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801949:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	50                   	push   %eax
  801956:	6a 15                	push   $0x15
  801958:	e8 d3 fd ff ff       	call   801730 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	90                   	nop
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 16                	push   $0x16
  801972:	e8 b9 fd ff ff       	call   801730 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	50                   	push   %eax
  80198d:	6a 17                	push   $0x17
  80198f:	e8 9c fd ff ff       	call   801730 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 1a                	push   $0x1a
  8019ac:	e8 7f fd ff ff       	call   801730 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 18                	push   $0x18
  8019c9:	e8 62 fd ff ff       	call   801730 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 19                	push   $0x19
  8019e7:	e8 44 fd ff ff       	call   801730 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a01:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	51                   	push   %ecx
  801a0b:	52                   	push   %edx
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	50                   	push   %eax
  801a10:	6a 1b                	push   $0x1b
  801a12:	e8 19 fd ff ff       	call   801730 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 1c                	push   $0x1c
  801a2f:	e8 fc fc ff ff       	call   801730 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	51                   	push   %ecx
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 1d                	push   $0x1d
  801a4e:	e8 dd fc ff ff       	call   801730 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 1e                	push   $0x1e
  801a6b:	e8 c0 fc ff ff       	call   801730 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 1f                	push   $0x1f
  801a84:	e8 a7 fc ff ff       	call   801730 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 14             	pushl  0x14(%ebp)
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	50                   	push   %eax
  801aa0:	6a 20                	push   $0x20
  801aa2:	e8 89 fc ff ff       	call   801730 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	50                   	push   %eax
  801abb:	6a 21                	push   $0x21
  801abd:	e8 6e fc ff ff       	call   801730 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	50                   	push   %eax
  801ad7:	6a 22                	push   $0x22
  801ad9:	e8 52 fc ff ff       	call   801730 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 02                	push   $0x2
  801af2:	e8 39 fc ff ff       	call   801730 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 03                	push   $0x3
  801b0b:	e8 20 fc ff ff       	call   801730 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 04                	push   $0x4
  801b24:	e8 07 fc ff ff       	call   801730 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_exit_env>:


void sys_exit_env(void)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 23                	push   $0x23
  801b3d:	e8 ee fb ff ff       	call   801730 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b51:	8d 50 04             	lea    0x4(%eax),%edx
  801b54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 24                	push   $0x24
  801b61:	e8 ca fb ff ff       	call   801730 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return result;
  801b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b72:	89 01                	mov    %eax,(%ecx)
  801b74:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	c9                   	leave  
  801b7b:	c2 04 00             	ret    $0x4

00801b7e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	ff 75 10             	pushl  0x10(%ebp)
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	6a 12                	push   $0x12
  801b90:	e8 9b fb ff ff       	call   801730 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
	return ;
  801b98:	90                   	nop
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_rcr2>:
uint32 sys_rcr2()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 25                	push   $0x25
  801baa:	e8 81 fb ff ff       	call   801730 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	50                   	push   %eax
  801bcd:	6a 26                	push   $0x26
  801bcf:	e8 5c fb ff ff       	call   801730 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd7:	90                   	nop
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <rsttst>:
void rsttst()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 28                	push   $0x28
  801be9:	e8 42 fb ff ff       	call   801730 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf1:	90                   	nop
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c00:	8b 55 18             	mov    0x18(%ebp),%edx
  801c03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	ff 75 10             	pushl  0x10(%ebp)
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 27                	push   $0x27
  801c14:	e8 17 fb ff ff       	call   801730 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <chktst>:
void chktst(uint32 n)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 29                	push   $0x29
  801c2f:	e8 fc fa ff ff       	call   801730 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return ;
  801c37:	90                   	nop
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <inctst>:

void inctst()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 2a                	push   $0x2a
  801c49:	e8 e2 fa ff ff       	call   801730 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c51:	90                   	nop
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <gettst>:
uint32 gettst()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 2b                	push   $0x2b
  801c63:	e8 c8 fa ff ff       	call   801730 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 2c                	push   $0x2c
  801c7f:	e8 ac fa ff ff       	call   801730 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
  801c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c8a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c8e:	75 07                	jne    801c97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c90:	b8 01 00 00 00       	mov    $0x1,%eax
  801c95:	eb 05                	jmp    801c9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 2c                	push   $0x2c
  801cb0:	e8 7b fa ff ff       	call   801730 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
  801cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cbb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cbf:	75 07                	jne    801cc8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc6:	eb 05                	jmp    801ccd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 2c                	push   $0x2c
  801ce1:	e8 4a fa ff ff       	call   801730 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
  801ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cec:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cf0:	75 07                	jne    801cf9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	eb 05                	jmp    801cfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 2c                	push   $0x2c
  801d12:	e8 19 fa ff ff       	call   801730 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
  801d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d1d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d21:	75 07                	jne    801d2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d23:	b8 01 00 00 00       	mov    $0x1,%eax
  801d28:	eb 05                	jmp    801d2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	ff 75 08             	pushl  0x8(%ebp)
  801d3f:	6a 2d                	push   $0x2d
  801d41:	e8 ea f9 ff ff       	call   801730 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return ;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d50:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	53                   	push   %ebx
  801d5f:	51                   	push   %ecx
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	6a 2e                	push   $0x2e
  801d64:	e8 c7 f9 ff ff       	call   801730 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	6a 2f                	push   $0x2f
  801d84:	e8 a7 f9 ff ff       	call   801730 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    
  801d8e:	66 90                	xchg   %ax,%ax

00801d90 <__udivdi3>:
  801d90:	55                   	push   %ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 1c             	sub    $0x1c,%esp
  801d97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da7:	89 ca                	mov    %ecx,%edx
  801da9:	89 f8                	mov    %edi,%eax
  801dab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801daf:	85 f6                	test   %esi,%esi
  801db1:	75 2d                	jne    801de0 <__udivdi3+0x50>
  801db3:	39 cf                	cmp    %ecx,%edi
  801db5:	77 65                	ja     801e1c <__udivdi3+0x8c>
  801db7:	89 fd                	mov    %edi,%ebp
  801db9:	85 ff                	test   %edi,%edi
  801dbb:	75 0b                	jne    801dc8 <__udivdi3+0x38>
  801dbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc2:	31 d2                	xor    %edx,%edx
  801dc4:	f7 f7                	div    %edi
  801dc6:	89 c5                	mov    %eax,%ebp
  801dc8:	31 d2                	xor    %edx,%edx
  801dca:	89 c8                	mov    %ecx,%eax
  801dcc:	f7 f5                	div    %ebp
  801dce:	89 c1                	mov    %eax,%ecx
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	f7 f5                	div    %ebp
  801dd4:	89 cf                	mov    %ecx,%edi
  801dd6:	89 fa                	mov    %edi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	39 ce                	cmp    %ecx,%esi
  801de2:	77 28                	ja     801e0c <__udivdi3+0x7c>
  801de4:	0f bd fe             	bsr    %esi,%edi
  801de7:	83 f7 1f             	xor    $0x1f,%edi
  801dea:	75 40                	jne    801e2c <__udivdi3+0x9c>
  801dec:	39 ce                	cmp    %ecx,%esi
  801dee:	72 0a                	jb     801dfa <__udivdi3+0x6a>
  801df0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801df4:	0f 87 9e 00 00 00    	ja     801e98 <__udivdi3+0x108>
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	89 fa                	mov    %edi,%edx
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	8d 76 00             	lea    0x0(%esi),%esi
  801e0c:	31 ff                	xor    %edi,%edi
  801e0e:	31 c0                	xor    %eax,%eax
  801e10:	89 fa                	mov    %edi,%edx
  801e12:	83 c4 1c             	add    $0x1c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	89 d8                	mov    %ebx,%eax
  801e1e:	f7 f7                	div    %edi
  801e20:	31 ff                	xor    %edi,%edi
  801e22:	89 fa                	mov    %edi,%edx
  801e24:	83 c4 1c             	add    $0x1c,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5f                   	pop    %edi
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    
  801e2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e31:	89 eb                	mov    %ebp,%ebx
  801e33:	29 fb                	sub    %edi,%ebx
  801e35:	89 f9                	mov    %edi,%ecx
  801e37:	d3 e6                	shl    %cl,%esi
  801e39:	89 c5                	mov    %eax,%ebp
  801e3b:	88 d9                	mov    %bl,%cl
  801e3d:	d3 ed                	shr    %cl,%ebp
  801e3f:	89 e9                	mov    %ebp,%ecx
  801e41:	09 f1                	or     %esi,%ecx
  801e43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e47:	89 f9                	mov    %edi,%ecx
  801e49:	d3 e0                	shl    %cl,%eax
  801e4b:	89 c5                	mov    %eax,%ebp
  801e4d:	89 d6                	mov    %edx,%esi
  801e4f:	88 d9                	mov    %bl,%cl
  801e51:	d3 ee                	shr    %cl,%esi
  801e53:	89 f9                	mov    %edi,%ecx
  801e55:	d3 e2                	shl    %cl,%edx
  801e57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e5b:	88 d9                	mov    %bl,%cl
  801e5d:	d3 e8                	shr    %cl,%eax
  801e5f:	09 c2                	or     %eax,%edx
  801e61:	89 d0                	mov    %edx,%eax
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	f7 74 24 0c          	divl   0xc(%esp)
  801e69:	89 d6                	mov    %edx,%esi
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	f7 e5                	mul    %ebp
  801e6f:	39 d6                	cmp    %edx,%esi
  801e71:	72 19                	jb     801e8c <__udivdi3+0xfc>
  801e73:	74 0b                	je     801e80 <__udivdi3+0xf0>
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	31 ff                	xor    %edi,%edi
  801e79:	e9 58 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e7e:	66 90                	xchg   %ax,%ax
  801e80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e84:	89 f9                	mov    %edi,%ecx
  801e86:	d3 e2                	shl    %cl,%edx
  801e88:	39 c2                	cmp    %eax,%edx
  801e8a:	73 e9                	jae    801e75 <__udivdi3+0xe5>
  801e8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e8f:	31 ff                	xor    %edi,%edi
  801e91:	e9 40 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e96:	66 90                	xchg   %ax,%ax
  801e98:	31 c0                	xor    %eax,%eax
  801e9a:	e9 37 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e9f:	90                   	nop

00801ea0 <__umoddi3>:
  801ea0:	55                   	push   %ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ebb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ebf:	89 f3                	mov    %esi,%ebx
  801ec1:	89 fa                	mov    %edi,%edx
  801ec3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec7:	89 34 24             	mov    %esi,(%esp)
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	75 1a                	jne    801ee8 <__umoddi3+0x48>
  801ece:	39 f7                	cmp    %esi,%edi
  801ed0:	0f 86 a2 00 00 00    	jbe    801f78 <__umoddi3+0xd8>
  801ed6:	89 c8                	mov    %ecx,%eax
  801ed8:	89 f2                	mov    %esi,%edx
  801eda:	f7 f7                	div    %edi
  801edc:	89 d0                	mov    %edx,%eax
  801ede:	31 d2                	xor    %edx,%edx
  801ee0:	83 c4 1c             	add    $0x1c,%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    
  801ee8:	39 f0                	cmp    %esi,%eax
  801eea:	0f 87 ac 00 00 00    	ja     801f9c <__umoddi3+0xfc>
  801ef0:	0f bd e8             	bsr    %eax,%ebp
  801ef3:	83 f5 1f             	xor    $0x1f,%ebp
  801ef6:	0f 84 ac 00 00 00    	je     801fa8 <__umoddi3+0x108>
  801efc:	bf 20 00 00 00       	mov    $0x20,%edi
  801f01:	29 ef                	sub    %ebp,%edi
  801f03:	89 fe                	mov    %edi,%esi
  801f05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	d3 e0                	shl    %cl,%eax
  801f0d:	89 d7                	mov    %edx,%edi
  801f0f:	89 f1                	mov    %esi,%ecx
  801f11:	d3 ef                	shr    %cl,%edi
  801f13:	09 c7                	or     %eax,%edi
  801f15:	89 e9                	mov    %ebp,%ecx
  801f17:	d3 e2                	shl    %cl,%edx
  801f19:	89 14 24             	mov    %edx,(%esp)
  801f1c:	89 d8                	mov    %ebx,%eax
  801f1e:	d3 e0                	shl    %cl,%eax
  801f20:	89 c2                	mov    %eax,%edx
  801f22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f26:	d3 e0                	shl    %cl,%eax
  801f28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f30:	89 f1                	mov    %esi,%ecx
  801f32:	d3 e8                	shr    %cl,%eax
  801f34:	09 d0                	or     %edx,%eax
  801f36:	d3 eb                	shr    %cl,%ebx
  801f38:	89 da                	mov    %ebx,%edx
  801f3a:	f7 f7                	div    %edi
  801f3c:	89 d3                	mov    %edx,%ebx
  801f3e:	f7 24 24             	mull   (%esp)
  801f41:	89 c6                	mov    %eax,%esi
  801f43:	89 d1                	mov    %edx,%ecx
  801f45:	39 d3                	cmp    %edx,%ebx
  801f47:	0f 82 87 00 00 00    	jb     801fd4 <__umoddi3+0x134>
  801f4d:	0f 84 91 00 00 00    	je     801fe4 <__umoddi3+0x144>
  801f53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f57:	29 f2                	sub    %esi,%edx
  801f59:	19 cb                	sbb    %ecx,%ebx
  801f5b:	89 d8                	mov    %ebx,%eax
  801f5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f61:	d3 e0                	shl    %cl,%eax
  801f63:	89 e9                	mov    %ebp,%ecx
  801f65:	d3 ea                	shr    %cl,%edx
  801f67:	09 d0                	or     %edx,%eax
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	d3 eb                	shr    %cl,%ebx
  801f6d:	89 da                	mov    %ebx,%edx
  801f6f:	83 c4 1c             	add    $0x1c,%esp
  801f72:	5b                   	pop    %ebx
  801f73:	5e                   	pop    %esi
  801f74:	5f                   	pop    %edi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    
  801f77:	90                   	nop
  801f78:	89 fd                	mov    %edi,%ebp
  801f7a:	85 ff                	test   %edi,%edi
  801f7c:	75 0b                	jne    801f89 <__umoddi3+0xe9>
  801f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f83:	31 d2                	xor    %edx,%edx
  801f85:	f7 f7                	div    %edi
  801f87:	89 c5                	mov    %eax,%ebp
  801f89:	89 f0                	mov    %esi,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	f7 f5                	div    %ebp
  801f8f:	89 c8                	mov    %ecx,%eax
  801f91:	f7 f5                	div    %ebp
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	e9 44 ff ff ff       	jmp    801ede <__umoddi3+0x3e>
  801f9a:	66 90                	xchg   %ax,%ax
  801f9c:	89 c8                	mov    %ecx,%eax
  801f9e:	89 f2                	mov    %esi,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	3b 04 24             	cmp    (%esp),%eax
  801fab:	72 06                	jb     801fb3 <__umoddi3+0x113>
  801fad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fb1:	77 0f                	ja     801fc2 <__umoddi3+0x122>
  801fb3:	89 f2                	mov    %esi,%edx
  801fb5:	29 f9                	sub    %edi,%ecx
  801fb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fbb:	89 14 24             	mov    %edx,(%esp)
  801fbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc6:	8b 14 24             	mov    (%esp),%edx
  801fc9:	83 c4 1c             	add    $0x1c,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	8d 76 00             	lea    0x0(%esi),%esi
  801fd4:	2b 04 24             	sub    (%esp),%eax
  801fd7:	19 fa                	sbb    %edi,%edx
  801fd9:	89 d1                	mov    %edx,%ecx
  801fdb:	89 c6                	mov    %eax,%esi
  801fdd:	e9 71 ff ff ff       	jmp    801f53 <__umoddi3+0xb3>
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fe8:	72 ea                	jb     801fd4 <__umoddi3+0x134>
  801fea:	89 d9                	mov    %ebx,%ecx
  801fec:	e9 62 ff ff ff       	jmp    801f53 <__umoddi3+0xb3>
