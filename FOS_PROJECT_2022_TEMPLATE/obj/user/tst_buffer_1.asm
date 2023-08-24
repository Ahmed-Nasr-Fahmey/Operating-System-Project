
obj/user/tst_buffer_1:     file format elf32-i386


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
  800031:	e8 89 05 00 00       	call   8005bf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#define arrSize PAGE_SIZE*8 / 4
int src[arrSize];
int dst[arrSize];

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80004e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 20 20 80 00       	push   $0x802020
  800065:	6a 16                	push   $0x16
  800067:	68 68 20 80 00       	push   $0x802068
  80006c:	e8 9d 06 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800084:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 20 20 80 00       	push   $0x802020
  80009b:	6a 17                	push   $0x17
  80009d:	68 68 20 80 00       	push   $0x802068
  8000a2:	e8 67 06 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 20 20 80 00       	push   $0x802020
  8000d1:	6a 18                	push   $0x18
  8000d3:	68 68 20 80 00       	push   $0x802068
  8000d8:	e8 31 06 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 20 20 80 00       	push   $0x802020
  800107:	6a 19                	push   $0x19
  800109:	68 68 20 80 00       	push   $0x802068
  80010e:	e8 fb 05 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800126:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 20 20 80 00       	push   $0x802020
  80013d:	6a 1a                	push   $0x1a
  80013f:	68 68 20 80 00       	push   $0x802068
  800144:	e8 c5 05 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80015c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 20 20 80 00       	push   $0x802020
  800173:	6a 1b                	push   $0x1b
  800175:	68 68 20 80 00       	push   $0x802068
  80017a:	e8 8f 05 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800194:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 20 20 80 00       	push   $0x802020
  8001ab:	6a 1c                	push   $0x1c
  8001ad:	68 68 20 80 00       	push   $0x802068
  8001b2:	e8 57 05 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 20 20 80 00       	push   $0x802020
  8001e3:	6a 1d                	push   $0x1d
  8001e5:	68 68 20 80 00       	push   $0x802068
  8001ea:	e8 1f 05 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800204:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 20 20 80 00       	push   $0x802020
  80021b:	6a 1e                	push   $0x1e
  80021d:	68 68 20 80 00       	push   $0x802068
  800222:	e8 e7 04 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80023c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 20 20 80 00       	push   $0x802020
  800253:	6a 1f                	push   $0x1f
  800255:	68 68 20 80 00       	push   $0x802068
  80025a:	e8 af 04 00 00       	call   80070e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800274:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 20 20 80 00       	push   $0x802020
  80028b:	6a 20                	push   $0x20
  80028d:	68 68 20 80 00       	push   $0x802068
  800292:	e8 77 04 00 00       	call   80070e <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 7c 20 80 00       	push   $0x80207c
  8002ae:	6a 21                	push   $0x21
  8002b0:	68 68 20 80 00       	push   $0x802068
  8002b5:	e8 54 04 00 00       	call   80070e <_panic>
	}

	int initModBufCnt = sys_calculate_modified_frames();
  8002ba:	e8 92 15 00 00       	call   801851 <sys_calculate_modified_frames>
  8002bf:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  8002c2:	e8 a3 15 00 00       	call   80186a <sys_calculate_notmod_frames>
  8002c7:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 09 16 00 00       	call   8018d8 <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 a8             	mov    %eax,-0x58(%ebp)

	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
  8002d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum1 = 0;
  8002d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	//cprintf("not modified frames= %d\n", sys_calculate_notmod_frames());
	int dummy = 0;
  8002e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  8002e7:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  8002ee:	eb 33                	jmp    800323 <_main+0x2eb>
	{
		dst[i] = i;
  8002f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f6:	89 14 85 20 a2 82 00 	mov    %edx,0x82a220(,%eax,4)
		dstSum1 += i;
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	01 45 f0             	add    %eax,-0x10(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  800303:	e8 62 15 00 00       	call   80186a <sys_calculate_notmod_frames>
  800308:	89 c2                	mov    %eax,%edx
  80030a:	a1 20 30 80 00       	mov    0x803020,%eax
  80030f:	8b 40 4c             	mov    0x4c(%eax),%eax
  800312:	01 c2                	add    %eax,%edx
  800314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
	int dstSum1 = 0;
	//cprintf("not modified frames= %d\n", sys_calculate_notmod_frames());
	int dummy = 0;
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  80031c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800323:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80032a:	7e c4                	jle    8002f0 <_main+0x2b8>
		dstSum1 += i;
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}


	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80032c:	e8 39 15 00 00       	call   80186a <sys_calculate_notmod_frames>
  800331:	89 c2                	mov    %eax,%edx
  800333:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800336:	29 c2                	sub    %eax,%edx
  800338:	89 d0                	mov    %edx,%eax
  80033a:	83 f8 07             	cmp    $0x7,%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 cc 20 80 00       	push   $0x8020cc
  800347:	6a 35                	push   $0x35
  800349:	68 68 20 80 00       	push   $0x802068
  80034e:	e8 bb 03 00 00       	call   80070e <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800353:	e8 f9 14 00 00       	call   801851 <sys_calculate_modified_frames>
  800358:	89 c2                	mov    %eax,%edx
  80035a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	74 14                	je     800375 <_main+0x33d>
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 30 21 80 00       	push   $0x802130
  800369:	6a 36                	push   $0x36
  80036b:	68 68 20 80 00       	push   $0x802068
  800370:	e8 99 03 00 00       	call   80070e <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  800375:	e8 f0 14 00 00       	call   80186a <sys_calculate_notmod_frames>
  80037a:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80037d:	e8 cf 14 00 00       	call   801851 <sys_calculate_modified_frames>
  800382:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[2]Bring 7 unmodified pages (7 modified will be buffered)
	int srcSum1 = 0 ;
  800385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	i = PAGE_SIZE/4;
  80038c:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
	for(;i<arrSize;i+=PAGE_SIZE/4)
  800393:	eb 2d                	jmp    8003c2 <_main+0x38a>
	{
		srcSum1 += src[i];
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800398:	8b 04 85 60 22 83 00 	mov    0x832260(,%eax,4),%eax
  80039f:	01 45 e8             	add    %eax,-0x18(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  8003a2:	e8 c3 14 00 00       	call   80186a <sys_calculate_notmod_frames>
  8003a7:	89 c2                	mov    %eax,%edx
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003b1:	01 c2                	add    %eax,%edx
  8003b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[2]Bring 7 unmodified pages (7 modified will be buffered)
	int srcSum1 = 0 ;
	i = PAGE_SIZE/4;
	for(;i<arrSize;i+=PAGE_SIZE/4)
  8003bb:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  8003c2:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8003c9:	7e ca                	jle    800395 <_main+0x35d>
		srcSum1 += src[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	//cprintf("sys_calculate_notmod_frames()  - initFreeBufCnt = %d\n", sys_calculate_notmod_frames()  - initFreeBufCnt);
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  8003cb:	e8 9a 14 00 00       	call   80186a <sys_calculate_notmod_frames>
  8003d0:	89 c2                	mov    %eax,%edx
  8003d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003d5:	39 c2                	cmp    %eax,%edx
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 cc 20 80 00       	push   $0x8020cc
  8003e1:	6a 45                	push   $0x45
  8003e3:	68 68 20 80 00       	push   $0x802068
  8003e8:	e8 21 03 00 00       	call   80070e <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  8003ed:	e8 5f 14 00 00       	call   801851 <sys_calculate_modified_frames>
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	83 f8 07             	cmp    $0x7,%eax
  8003fe:	74 14                	je     800414 <_main+0x3dc>
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 30 21 80 00       	push   $0x802130
  800408:	6a 46                	push   $0x46
  80040a:	68 68 20 80 00       	push   $0x802068
  80040f:	e8 fa 02 00 00       	call   80070e <_panic>
	initFreeBufCnt = sys_calculate_notmod_frames();
  800414:	e8 51 14 00 00       	call   80186a <sys_calculate_notmod_frames>
  800419:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80041c:	e8 30 14 00 00       	call   801851 <sys_calculate_modified_frames>
  800421:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)
	i = 0;
  800424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum2 = 0 ;
  80042b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800432:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  800439:	eb 2d                	jmp    800468 <_main+0x430>
	{
		dstSum2 += dst[i];
  80043b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043e:	8b 04 85 20 a2 82 00 	mov    0x82a220(,%eax,4),%eax
  800445:	01 45 e4             	add    %eax,-0x1c(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  800448:	e8 1d 14 00 00       	call   80186a <sys_calculate_notmod_frames>
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 40 4c             	mov    0x4c(%eax),%eax
  800457:	01 c2                	add    %eax,%edx
  800459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045c:	01 d0                	add    %edx,%eax
  80045e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)
	i = 0;
	int dstSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800461:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800468:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80046f:	7e ca                	jle    80043b <_main+0x403>
	{
		dstSum2 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800471:	e8 f4 13 00 00       	call   80186a <sys_calculate_notmod_frames>
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80047b:	29 c2                	sub    %eax,%edx
  80047d:	89 d0                	mov    %edx,%eax
  80047f:	83 f8 07             	cmp    $0x7,%eax
  800482:	74 14                	je     800498 <_main+0x460>
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 cc 20 80 00       	push   $0x8020cc
  80048c:	6a 53                	push   $0x53
  80048e:	68 68 20 80 00       	push   $0x802068
  800493:	e8 76 02 00 00       	call   80070e <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != -7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800498:	e8 b4 13 00 00       	call   801851 <sys_calculate_modified_frames>
  80049d:	89 c2                	mov    %eax,%edx
  80049f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8004a2:	29 c2                	sub    %eax,%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8004a9:	74 14                	je     8004bf <_main+0x487>
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	68 30 21 80 00       	push   $0x802130
  8004b3:	6a 54                	push   $0x54
  8004b5:	68 68 20 80 00       	push   $0x802068
  8004ba:	e8 4f 02 00 00       	call   80070e <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  8004bf:	e8 a6 13 00 00       	call   80186a <sys_calculate_notmod_frames>
  8004c4:	89 45 ac             	mov    %eax,-0x54(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8004c7:	e8 85 13 00 00       	call   801851 <sys_calculate_modified_frames>
  8004cc:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//[4]Bring the 7 unmodified pages again and ensure their values are correct (7 modified will be buffered)
	i = 0;
  8004cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int srcSum2 = 0 ;
  8004d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  8004dd:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  8004e4:	eb 2d                	jmp    800513 <_main+0x4db>
	{
		srcSum2 += src[i];
  8004e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e9:	8b 04 85 60 22 83 00 	mov    0x832260(,%eax,4),%eax
  8004f0:	01 45 e0             	add    %eax,-0x20(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
  8004f3:	e8 72 13 00 00       	call   80186a <sys_calculate_notmod_frames>
  8004f8:	89 c2                	mov    %eax,%edx
  8004fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ff:	8b 40 4c             	mov    0x4c(%eax),%eax
  800502:	01 c2                	add    %eax,%edx
  800504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800507:	01 d0                	add    %edx,%eax
  800509:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initModBufCnt = sys_calculate_modified_frames();

	//[4]Bring the 7 unmodified pages again and ensure their values are correct (7 modified will be buffered)
	i = 0;
	int srcSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  80050c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800513:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80051a:	7e ca                	jle    8004e6 <_main+0x4ae>
	{
		srcSum2 += src[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id; //Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != -7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80051c:	e8 49 13 00 00       	call   80186a <sys_calculate_notmod_frames>
  800521:	89 c2                	mov    %eax,%edx
  800523:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800526:	29 c2                	sub    %eax,%edx
  800528:	89 d0                	mov    %edx,%eax
  80052a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80052d:	74 14                	je     800543 <_main+0x50b>
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	68 cc 20 80 00       	push   $0x8020cc
  800537:	6a 62                	push   $0x62
  800539:	68 68 20 80 00       	push   $0x802068
  80053e:	e8 cb 01 00 00       	call   80070e <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800543:	e8 09 13 00 00       	call   801851 <sys_calculate_modified_frames>
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	83 f8 07             	cmp    $0x7,%eax
  800554:	74 14                	je     80056a <_main+0x532>
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 30 21 80 00       	push   $0x802130
  80055e:	6a 63                	push   $0x63
  800560:	68 68 20 80 00       	push   $0x802068
  800565:	e8 a4 01 00 00       	call   80070e <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  80056a:	e8 69 13 00 00       	call   8018d8 <sys_pf_calculate_allocated_pages>
  80056f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  800572:	74 14                	je     800588 <_main+0x550>
  800574:	83 ec 04             	sub    $0x4,%esp
  800577:	68 9c 21 80 00       	push   $0x80219c
  80057c:	6a 65                	push   $0x65
  80057e:	68 68 20 80 00       	push   $0x802068
  800583:	e8 86 01 00 00       	call   80070e <_panic>

	if (srcSum1 != srcSum2 || dstSum1 != dstSum2) 	panic("Error in buffering/restoring modified/not modified pages") ;
  800588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80058b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80058e:	75 08                	jne    800598 <_main+0x560>
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800596:	74 14                	je     8005ac <_main+0x574>
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 0c 22 80 00       	push   $0x80220c
  8005a0:	6a 67                	push   $0x67
  8005a2:	68 68 20 80 00       	push   $0x802068
  8005a7:	e8 62 01 00 00       	call   80070e <_panic>

	cprintf("Congratulations!! test buffered pages inside REPLACEMENT is completed successfully.\n");
  8005ac:	83 ec 0c             	sub    $0xc,%esp
  8005af:	68 48 22 80 00       	push   $0x802248
  8005b4:	e8 09 04 00 00       	call   8009c2 <cprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
	return;
  8005bc:	90                   	nop

}
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005c5:	e8 4e 15 00 00       	call   801b18 <sys_getenvindex>
  8005ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d0:	89 d0                	mov    %edx,%eax
  8005d2:	01 c0                	add    %eax,%eax
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005dd:	01 c8                	add    %ecx,%eax
  8005df:	c1 e0 02             	shl    $0x2,%eax
  8005e2:	01 d0                	add    %edx,%eax
  8005e4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	c1 e0 02             	shl    $0x2,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	c1 e0 02             	shl    $0x2,%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	c1 e0 03             	shl    $0x3,%eax
  8005fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ff:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800604:	a1 20 30 80 00       	mov    0x803020,%eax
  800609:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80060f:	84 c0                	test   %al,%al
  800611:	74 0f                	je     800622 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800613:	a1 20 30 80 00       	mov    0x803020,%eax
  800618:	05 18 da 01 00       	add    $0x1da18,%eax
  80061d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800622:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800626:	7e 0a                	jle    800632 <libmain+0x73>
		binaryname = argv[0];
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	e8 f8 f9 ff ff       	call   800038 <_main>
  800640:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800643:	e8 dd 12 00 00       	call   801925 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	68 b8 22 80 00       	push   $0x8022b8
  800650:	e8 6d 03 00 00       	call   8009c2 <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800658:	a1 20 30 80 00       	mov    0x803020,%eax
  80065d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800663:	a1 20 30 80 00       	mov    0x803020,%eax
  800668:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	68 e0 22 80 00       	push   $0x8022e0
  800678:	e8 45 03 00 00       	call   8009c2 <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80068b:	a1 20 30 80 00       	mov    0x803020,%eax
  800690:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800696:	a1 20 30 80 00       	mov    0x803020,%eax
  80069b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8006a1:	51                   	push   %ecx
  8006a2:	52                   	push   %edx
  8006a3:	50                   	push   %eax
  8006a4:	68 08 23 80 00       	push   $0x802308
  8006a9:	e8 14 03 00 00       	call   8009c2 <cprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b6:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	50                   	push   %eax
  8006c0:	68 60 23 80 00       	push   $0x802360
  8006c5:	e8 f8 02 00 00       	call   8009c2 <cprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	68 b8 22 80 00       	push   $0x8022b8
  8006d5:	e8 e8 02 00 00       	call   8009c2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006dd:	e8 5d 12 00 00       	call   80193f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006e2:	e8 19 00 00 00       	call   800700 <exit>
}
  8006e7:	90                   	nop
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	6a 00                	push   $0x0
  8006f5:	e8 ea 13 00 00       	call   801ae4 <sys_destroy_env>
  8006fa:	83 c4 10             	add    $0x10,%esp
}
  8006fd:	90                   	nop
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <exit>:

void
exit(void)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800706:	e8 3f 14 00 00       	call   801b4a <sys_exit_env>
}
  80070b:	90                   	nop
  80070c:	c9                   	leave  
  80070d:	c3                   	ret    

0080070e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800714:	8d 45 10             	lea    0x10(%ebp),%eax
  800717:	83 c0 04             	add    $0x4,%eax
  80071a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80071d:	a1 74 a2 83 00       	mov    0x83a274,%eax
  800722:	85 c0                	test   %eax,%eax
  800724:	74 16                	je     80073c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800726:	a1 74 a2 83 00       	mov    0x83a274,%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	50                   	push   %eax
  80072f:	68 74 23 80 00       	push   $0x802374
  800734:	e8 89 02 00 00       	call   8009c2 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80073c:	a1 00 30 80 00       	mov    0x803000,%eax
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	ff 75 08             	pushl  0x8(%ebp)
  800747:	50                   	push   %eax
  800748:	68 79 23 80 00       	push   $0x802379
  80074d:	e8 70 02 00 00       	call   8009c2 <cprintf>
  800752:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800755:	8b 45 10             	mov    0x10(%ebp),%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 f4             	pushl  -0xc(%ebp)
  80075e:	50                   	push   %eax
  80075f:	e8 f3 01 00 00       	call   800957 <vcprintf>
  800764:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	6a 00                	push   $0x0
  80076c:	68 95 23 80 00       	push   $0x802395
  800771:	e8 e1 01 00 00       	call   800957 <vcprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800779:	e8 82 ff ff ff       	call   800700 <exit>

	// should not return here
	while (1) ;
  80077e:	eb fe                	jmp    80077e <_panic+0x70>

00800780 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800786:	a1 20 30 80 00       	mov    0x803020,%eax
  80078b:	8b 50 74             	mov    0x74(%eax),%edx
  80078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800791:	39 c2                	cmp    %eax,%edx
  800793:	74 14                	je     8007a9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800795:	83 ec 04             	sub    $0x4,%esp
  800798:	68 98 23 80 00       	push   $0x802398
  80079d:	6a 26                	push   $0x26
  80079f:	68 e4 23 80 00       	push   $0x8023e4
  8007a4:	e8 65 ff ff ff       	call   80070e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	e9 c2 00 00 00       	jmp    80087e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	01 d0                	add    %edx,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	85 c0                	test   %eax,%eax
  8007cf:	75 08                	jne    8007d9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007d1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007d4:	e9 a2 00 00 00       	jmp    80087b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007e7:	eb 69                	jmp    800852 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ee:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f7:	89 d0                	mov    %edx,%eax
  8007f9:	01 c0                	add    %eax,%eax
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	c1 e0 03             	shl    $0x3,%eax
  800800:	01 c8                	add    %ecx,%eax
  800802:	8a 40 04             	mov    0x4(%eax),%al
  800805:	84 c0                	test   %al,%al
  800807:	75 46                	jne    80084f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800809:	a1 20 30 80 00       	mov    0x803020,%eax
  80080e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800817:	89 d0                	mov    %edx,%eax
  800819:	01 c0                	add    %eax,%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	c1 e0 03             	shl    $0x3,%eax
  800820:	01 c8                	add    %ecx,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800827:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80082a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80082f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800834:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	01 c8                	add    %ecx,%eax
  800840:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800842:	39 c2                	cmp    %eax,%edx
  800844:	75 09                	jne    80084f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800846:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80084d:	eb 12                	jmp    800861 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084f:	ff 45 e8             	incl   -0x18(%ebp)
  800852:	a1 20 30 80 00       	mov    0x803020,%eax
  800857:	8b 50 74             	mov    0x74(%eax),%edx
  80085a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085d:	39 c2                	cmp    %eax,%edx
  80085f:	77 88                	ja     8007e9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800861:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800865:	75 14                	jne    80087b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800867:	83 ec 04             	sub    $0x4,%esp
  80086a:	68 f0 23 80 00       	push   $0x8023f0
  80086f:	6a 3a                	push   $0x3a
  800871:	68 e4 23 80 00       	push   $0x8023e4
  800876:	e8 93 fe ff ff       	call   80070e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80087b:	ff 45 f0             	incl   -0x10(%ebp)
  80087e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800881:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800884:	0f 8c 32 ff ff ff    	jl     8007bc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80088a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800891:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800898:	eb 26                	jmp    8008c0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80089a:	a1 20 30 80 00       	mov    0x803020,%eax
  80089f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a8:	89 d0                	mov    %edx,%eax
  8008aa:	01 c0                	add    %eax,%eax
  8008ac:	01 d0                	add    %edx,%eax
  8008ae:	c1 e0 03             	shl    $0x3,%eax
  8008b1:	01 c8                	add    %ecx,%eax
  8008b3:	8a 40 04             	mov    0x4(%eax),%al
  8008b6:	3c 01                	cmp    $0x1,%al
  8008b8:	75 03                	jne    8008bd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ba:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008bd:	ff 45 e0             	incl   -0x20(%ebp)
  8008c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008c5:	8b 50 74             	mov    0x74(%eax),%edx
  8008c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	77 cb                	ja     80089a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008d5:	74 14                	je     8008eb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008d7:	83 ec 04             	sub    $0x4,%esp
  8008da:	68 44 24 80 00       	push   $0x802444
  8008df:	6a 44                	push   $0x44
  8008e1:	68 e4 23 80 00       	push   $0x8023e4
  8008e6:	e8 23 fe ff ff       	call   80070e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008eb:	90                   	nop
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ff:	89 0a                	mov    %ecx,(%edx)
  800901:	8b 55 08             	mov    0x8(%ebp),%edx
  800904:	88 d1                	mov    %dl,%cl
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
  800909:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80090d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	3d ff 00 00 00       	cmp    $0xff,%eax
  800917:	75 2c                	jne    800945 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800919:	a0 24 30 80 00       	mov    0x803024,%al
  80091e:	0f b6 c0             	movzbl %al,%eax
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
  800924:	8b 12                	mov    (%edx),%edx
  800926:	89 d1                	mov    %edx,%ecx
  800928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092b:	83 c2 08             	add    $0x8,%edx
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	50                   	push   %eax
  800932:	51                   	push   %ecx
  800933:	52                   	push   %edx
  800934:	e8 3e 0e 00 00       	call   801777 <sys_cputs>
  800939:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	8b 40 04             	mov    0x4(%eax),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	89 50 04             	mov    %edx,0x4(%eax)
}
  800954:	90                   	nop
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800960:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800967:	00 00 00 
	b.cnt = 0;
  80096a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800971:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800980:	50                   	push   %eax
  800981:	68 ee 08 80 00       	push   $0x8008ee
  800986:	e8 11 02 00 00       	call   800b9c <vprintfmt>
  80098b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80098e:	a0 24 30 80 00       	mov    0x803024,%al
  800993:	0f b6 c0             	movzbl %al,%eax
  800996:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80099c:	83 ec 04             	sub    $0x4,%esp
  80099f:	50                   	push   %eax
  8009a0:	52                   	push   %edx
  8009a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009a7:	83 c0 08             	add    $0x8,%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 c7 0d 00 00       	call   801777 <sys_cputs>
  8009b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009b3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009c8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 f4             	pushl  -0xc(%ebp)
  8009de:	50                   	push   %eax
  8009df:	e8 73 ff ff ff       	call   800957 <vcprintf>
  8009e4:	83 c4 10             	add    $0x10,%esp
  8009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009f5:	e8 2b 0f 00 00       	call   801925 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 f4             	pushl  -0xc(%ebp)
  800a09:	50                   	push   %eax
  800a0a:	e8 48 ff ff ff       	call   800957 <vcprintf>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a15:	e8 25 0f 00 00       	call   80193f <sys_enable_interrupt>
	return cnt;
  800a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	53                   	push   %ebx
  800a23:	83 ec 14             	sub    $0x14,%esp
  800a26:	8b 45 10             	mov    0x10(%ebp),%eax
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a32:	8b 45 18             	mov    0x18(%ebp),%eax
  800a35:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a3d:	77 55                	ja     800a94 <printnum+0x75>
  800a3f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a42:	72 05                	jb     800a49 <printnum+0x2a>
  800a44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a47:	77 4b                	ja     800a94 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a49:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a4c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a4f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a52:	ba 00 00 00 00       	mov    $0x0,%edx
  800a57:	52                   	push   %edx
  800a58:	50                   	push   %eax
  800a59:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a5f:	e8 48 13 00 00       	call   801dac <__udivdi3>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	ff 75 20             	pushl  0x20(%ebp)
  800a6d:	53                   	push   %ebx
  800a6e:	ff 75 18             	pushl  0x18(%ebp)
  800a71:	52                   	push   %edx
  800a72:	50                   	push   %eax
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	ff 75 08             	pushl  0x8(%ebp)
  800a79:	e8 a1 ff ff ff       	call   800a1f <printnum>
  800a7e:	83 c4 20             	add    $0x20,%esp
  800a81:	eb 1a                	jmp    800a9d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	ff 75 20             	pushl  0x20(%ebp)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a94:	ff 4d 1c             	decl   0x1c(%ebp)
  800a97:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a9b:	7f e6                	jg     800a83 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a9d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aab:	53                   	push   %ebx
  800aac:	51                   	push   %ecx
  800aad:	52                   	push   %edx
  800aae:	50                   	push   %eax
  800aaf:	e8 08 14 00 00       	call   801ebc <__umoddi3>
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	05 b4 26 80 00       	add    $0x8026b4,%eax
  800abc:	8a 00                	mov    (%eax),%al
  800abe:	0f be c0             	movsbl %al,%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
}
  800ad0:	90                   	nop
  800ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ad9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800add:	7e 1c                	jle    800afb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	8d 50 08             	lea    0x8(%eax),%edx
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	89 10                	mov    %edx,(%eax)
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	83 e8 08             	sub    $0x8,%eax
  800af4:	8b 50 04             	mov    0x4(%eax),%edx
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	eb 40                	jmp    800b3b <getuint+0x65>
	else if (lflag)
  800afb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aff:	74 1e                	je     800b1f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	8d 50 04             	lea    0x4(%eax),%edx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	89 10                	mov    %edx,(%eax)
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	83 e8 04             	sub    $0x4,%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1d:	eb 1c                	jmp    800b3b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	8d 50 04             	lea    0x4(%eax),%edx
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 10                	mov    %edx,(%eax)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	83 e8 04             	sub    $0x4,%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b40:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b44:	7e 1c                	jle    800b62 <getint+0x25>
		return va_arg(*ap, long long);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	8d 50 08             	lea    0x8(%eax),%edx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	89 10                	mov    %edx,(%eax)
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	83 e8 08             	sub    $0x8,%eax
  800b5b:	8b 50 04             	mov    0x4(%eax),%edx
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	eb 38                	jmp    800b9a <getint+0x5d>
	else if (lflag)
  800b62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b66:	74 1a                	je     800b82 <getint+0x45>
		return va_arg(*ap, long);
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	8d 50 04             	lea    0x4(%eax),%edx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 10                	mov    %edx,(%eax)
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	83 e8 04             	sub    $0x4,%eax
  800b7d:	8b 00                	mov    (%eax),%eax
  800b7f:	99                   	cltd   
  800b80:	eb 18                	jmp    800b9a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	8d 50 04             	lea    0x4(%eax),%edx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 10                	mov    %edx,(%eax)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	83 e8 04             	sub    $0x4,%eax
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	99                   	cltd   
}
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ba4:	eb 17                	jmp    800bbd <vprintfmt+0x21>
			if (ch == '\0')
  800ba6:	85 db                	test   %ebx,%ebx
  800ba8:	0f 84 af 03 00 00    	je     800f5d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	53                   	push   %ebx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8d 50 01             	lea    0x1(%eax),%edx
  800bc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	0f b6 d8             	movzbl %al,%ebx
  800bcb:	83 fb 25             	cmp    $0x25,%ebx
  800bce:	75 d6                	jne    800ba6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bd0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bd4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bdb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800be2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800be9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf3:	8d 50 01             	lea    0x1(%eax),%edx
  800bf6:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	0f b6 d8             	movzbl %al,%ebx
  800bfe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c01:	83 f8 55             	cmp    $0x55,%eax
  800c04:	0f 87 2b 03 00 00    	ja     800f35 <vprintfmt+0x399>
  800c0a:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  800c11:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c13:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c17:	eb d7                	jmp    800bf0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c19:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c1d:	eb d1                	jmp    800bf0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c29:	89 d0                	mov    %edx,%eax
  800c2b:	c1 e0 02             	shl    $0x2,%eax
  800c2e:	01 d0                	add    %edx,%eax
  800c30:	01 c0                	add    %eax,%eax
  800c32:	01 d8                	add    %ebx,%eax
  800c34:	83 e8 30             	sub    $0x30,%eax
  800c37:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c42:	83 fb 2f             	cmp    $0x2f,%ebx
  800c45:	7e 3e                	jle    800c85 <vprintfmt+0xe9>
  800c47:	83 fb 39             	cmp    $0x39,%ebx
  800c4a:	7f 39                	jg     800c85 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c4c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c4f:	eb d5                	jmp    800c26 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5d:	83 e8 04             	sub    $0x4,%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c65:	eb 1f                	jmp    800c86 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6b:	79 83                	jns    800bf0 <vprintfmt+0x54>
				width = 0;
  800c6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c74:	e9 77 ff ff ff       	jmp    800bf0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c79:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c80:	e9 6b ff ff ff       	jmp    800bf0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c85:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8a:	0f 89 60 ff ff ff    	jns    800bf0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c96:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c9d:	e9 4e ff ff ff       	jmp    800bf0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ca5:	e9 46 ff ff ff       	jmp    800bf0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	50                   	push   %eax
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
			break;
  800cca:	e9 89 02 00 00       	jmp    800f58 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ccf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd2:	83 c0 04             	add    $0x4,%eax
  800cd5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdb:	83 e8 04             	sub    $0x4,%eax
  800cde:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ce0:	85 db                	test   %ebx,%ebx
  800ce2:	79 02                	jns    800ce6 <vprintfmt+0x14a>
				err = -err;
  800ce4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ce6:	83 fb 64             	cmp    $0x64,%ebx
  800ce9:	7f 0b                	jg     800cf6 <vprintfmt+0x15a>
  800ceb:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  800cf2:	85 f6                	test   %esi,%esi
  800cf4:	75 19                	jne    800d0f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf6:	53                   	push   %ebx
  800cf7:	68 c5 26 80 00       	push   $0x8026c5
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	ff 75 08             	pushl  0x8(%ebp)
  800d02:	e8 5e 02 00 00       	call   800f65 <printfmt>
  800d07:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d0a:	e9 49 02 00 00       	jmp    800f58 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d0f:	56                   	push   %esi
  800d10:	68 ce 26 80 00       	push   $0x8026ce
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	ff 75 08             	pushl  0x8(%ebp)
  800d1b:	e8 45 02 00 00       	call   800f65 <printfmt>
  800d20:	83 c4 10             	add    $0x10,%esp
			break;
  800d23:	e9 30 02 00 00       	jmp    800f58 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d28:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2b:	83 c0 04             	add    $0x4,%eax
  800d2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d31:	8b 45 14             	mov    0x14(%ebp),%eax
  800d34:	83 e8 04             	sub    $0x4,%eax
  800d37:	8b 30                	mov    (%eax),%esi
  800d39:	85 f6                	test   %esi,%esi
  800d3b:	75 05                	jne    800d42 <vprintfmt+0x1a6>
				p = "(null)";
  800d3d:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800d42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d46:	7e 6d                	jle    800db5 <vprintfmt+0x219>
  800d48:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d4c:	74 67                	je     800db5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	50                   	push   %eax
  800d55:	56                   	push   %esi
  800d56:	e8 0c 03 00 00       	call   801067 <strnlen>
  800d5b:	83 c4 10             	add    $0x10,%esp
  800d5e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d61:	eb 16                	jmp    800d79 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d63:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	ff 75 0c             	pushl  0xc(%ebp)
  800d6d:	50                   	push   %eax
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	ff d0                	call   *%eax
  800d73:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d76:	ff 4d e4             	decl   -0x1c(%ebp)
  800d79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7d:	7f e4                	jg     800d63 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d7f:	eb 34                	jmp    800db5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d81:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d85:	74 1c                	je     800da3 <vprintfmt+0x207>
  800d87:	83 fb 1f             	cmp    $0x1f,%ebx
  800d8a:	7e 05                	jle    800d91 <vprintfmt+0x1f5>
  800d8c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d8f:	7e 12                	jle    800da3 <vprintfmt+0x207>
					putch('?', putdat);
  800d91:	83 ec 08             	sub    $0x8,%esp
  800d94:	ff 75 0c             	pushl  0xc(%ebp)
  800d97:	6a 3f                	push   $0x3f
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	ff d0                	call   *%eax
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	eb 0f                	jmp    800db2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	53                   	push   %ebx
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	ff d0                	call   *%eax
  800daf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db2:	ff 4d e4             	decl   -0x1c(%ebp)
  800db5:	89 f0                	mov    %esi,%eax
  800db7:	8d 70 01             	lea    0x1(%eax),%esi
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	0f be d8             	movsbl %al,%ebx
  800dbf:	85 db                	test   %ebx,%ebx
  800dc1:	74 24                	je     800de7 <vprintfmt+0x24b>
  800dc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc7:	78 b8                	js     800d81 <vprintfmt+0x1e5>
  800dc9:	ff 4d e0             	decl   -0x20(%ebp)
  800dcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd0:	79 af                	jns    800d81 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd2:	eb 13                	jmp    800de7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	6a 20                	push   $0x20
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	ff d0                	call   *%eax
  800de1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de4:	ff 4d e4             	decl   -0x1c(%ebp)
  800de7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800deb:	7f e7                	jg     800dd4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ded:	e9 66 01 00 00       	jmp    800f58 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800df2:	83 ec 08             	sub    $0x8,%esp
  800df5:	ff 75 e8             	pushl  -0x18(%ebp)
  800df8:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfb:	50                   	push   %eax
  800dfc:	e8 3c fd ff ff       	call   800b3d <getint>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e10:	85 d2                	test   %edx,%edx
  800e12:	79 23                	jns    800e37 <vprintfmt+0x29b>
				putch('-', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 2d                	push   $0x2d
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2a:	f7 d8                	neg    %eax
  800e2c:	83 d2 00             	adc    $0x0,%edx
  800e2f:	f7 da                	neg    %edx
  800e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e3e:	e9 bc 00 00 00       	jmp    800eff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e43:	83 ec 08             	sub    $0x8,%esp
  800e46:	ff 75 e8             	pushl  -0x18(%ebp)
  800e49:	8d 45 14             	lea    0x14(%ebp),%eax
  800e4c:	50                   	push   %eax
  800e4d:	e8 84 fc ff ff       	call   800ad6 <getuint>
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e5b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e62:	e9 98 00 00 00       	jmp    800eff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e67:	83 ec 08             	sub    $0x8,%esp
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	6a 58                	push   $0x58
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			break;
  800e97:	e9 bc 00 00 00       	jmp    800f58 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e9c:	83 ec 08             	sub    $0x8,%esp
  800e9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ea2:	6a 30                	push   $0x30
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	ff d0                	call   *%eax
  800ea9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 78                	push   $0x78
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ebc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebf:	83 c0 04             	add    $0x4,%eax
  800ec2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec8:	83 e8 04             	sub    $0x4,%eax
  800ecb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ed7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ede:	eb 1f                	jmp    800eff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee9:	50                   	push   %eax
  800eea:	e8 e7 fb ff ff       	call   800ad6 <getuint>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ef8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f06:	83 ec 04             	sub    $0x4,%esp
  800f09:	52                   	push   %edx
  800f0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f0d:	50                   	push   %eax
  800f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f11:	ff 75 f0             	pushl  -0x10(%ebp)
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	ff 75 08             	pushl  0x8(%ebp)
  800f1a:	e8 00 fb ff ff       	call   800a1f <printnum>
  800f1f:	83 c4 20             	add    $0x20,%esp
			break;
  800f22:	eb 34                	jmp    800f58 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	53                   	push   %ebx
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	ff d0                	call   *%eax
  800f30:	83 c4 10             	add    $0x10,%esp
			break;
  800f33:	eb 23                	jmp    800f58 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 25                	push   $0x25
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f45:	ff 4d 10             	decl   0x10(%ebp)
  800f48:	eb 03                	jmp    800f4d <vprintfmt+0x3b1>
  800f4a:	ff 4d 10             	decl   0x10(%ebp)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	48                   	dec    %eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 25                	cmp    $0x25,%al
  800f55:	75 f3                	jne    800f4a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f57:	90                   	nop
		}
	}
  800f58:	e9 47 fc ff ff       	jmp    800ba4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f5d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f6e:	83 c0 04             	add    $0x4,%eax
  800f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f74:	8b 45 10             	mov    0x10(%ebp),%eax
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 16 fc ff ff       	call   800b9c <vprintfmt>
  800f86:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f89:	90                   	nop
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8b 40 08             	mov    0x8(%eax),%eax
  800f95:	8d 50 01             	lea    0x1(%eax),%edx
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	8b 10                	mov    (%eax),%edx
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8b 40 04             	mov    0x4(%eax),%eax
  800fa9:	39 c2                	cmp    %eax,%edx
  800fab:	73 12                	jae    800fbf <sprintputch+0x33>
		*b->buf++ = ch;
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8b 00                	mov    (%eax),%eax
  800fb2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb8:	89 0a                	mov    %ecx,(%edx)
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	88 10                	mov    %dl,(%eax)
}
  800fbf:	90                   	nop
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	01 d0                	add    %edx,%eax
  800fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fe3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe7:	74 06                	je     800fef <vsnprintf+0x2d>
  800fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fed:	7f 07                	jg     800ff6 <vsnprintf+0x34>
		return -E_INVAL;
  800fef:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff4:	eb 20                	jmp    801016 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ff6:	ff 75 14             	pushl  0x14(%ebp)
  800ff9:	ff 75 10             	pushl  0x10(%ebp)
  800ffc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fff:	50                   	push   %eax
  801000:	68 8c 0f 80 00       	push   $0x800f8c
  801005:	e8 92 fb ff ff       	call   800b9c <vprintfmt>
  80100a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80100d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801010:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801013:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80101e:	8d 45 10             	lea    0x10(%ebp),%eax
  801021:	83 c0 04             	add    $0x4,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	ff 75 f4             	pushl  -0xc(%ebp)
  80102d:	50                   	push   %eax
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 89 ff ff ff       	call   800fc2 <vsnprintf>
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80103f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801051:	eb 06                	jmp    801059 <strlen+0x15>
		n++;
  801053:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	84 c0                	test   %al,%al
  801060:	75 f1                	jne    801053 <strlen+0xf>
		n++;
	return n;
  801062:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801074:	eb 09                	jmp    80107f <strnlen+0x18>
		n++;
  801076:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801079:	ff 45 08             	incl   0x8(%ebp)
  80107c:	ff 4d 0c             	decl   0xc(%ebp)
  80107f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801083:	74 09                	je     80108e <strnlen+0x27>
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	84 c0                	test   %al,%al
  80108c:	75 e8                	jne    801076 <strnlen+0xf>
		n++;
	return n;
  80108e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80109f:	90                   	nop
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8d 50 01             	lea    0x1(%eax),%edx
  8010a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b2:	8a 12                	mov    (%edx),%dl
  8010b4:	88 10                	mov    %dl,(%eax)
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 e4                	jne    8010a0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d4:	eb 1f                	jmp    8010f5 <strncpy+0x34>
		*dst++ = *src;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8010df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e2:	8a 12                	mov    (%edx),%dl
  8010e4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	74 03                	je     8010f2 <strncpy+0x31>
			src++;
  8010ef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f2:	ff 45 fc             	incl   -0x4(%ebp)
  8010f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010fb:	72 d9                	jb     8010d6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80110e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801112:	74 30                	je     801144 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801114:	eb 16                	jmp    80112c <strlcpy+0x2a>
			*dst++ = *src++;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8d 50 01             	lea    0x1(%eax),%edx
  80111c:	89 55 08             	mov    %edx,0x8(%ebp)
  80111f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801122:	8d 4a 01             	lea    0x1(%edx),%ecx
  801125:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801128:	8a 12                	mov    (%edx),%dl
  80112a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80112c:	ff 4d 10             	decl   0x10(%ebp)
  80112f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801133:	74 09                	je     80113e <strlcpy+0x3c>
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	84 c0                	test   %al,%al
  80113c:	75 d8                	jne    801116 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801144:	8b 55 08             	mov    0x8(%ebp),%edx
  801147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114a:	29 c2                	sub    %eax,%edx
  80114c:	89 d0                	mov    %edx,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801153:	eb 06                	jmp    80115b <strcmp+0xb>
		p++, q++;
  801155:	ff 45 08             	incl   0x8(%ebp)
  801158:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	84 c0                	test   %al,%al
  801162:	74 0e                	je     801172 <strcmp+0x22>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 10                	mov    (%eax),%dl
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	38 c2                	cmp    %al,%dl
  801170:	74 e3                	je     801155 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f b6 d0             	movzbl %al,%edx
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 c0             	movzbl %al,%eax
  801182:	29 c2                	sub    %eax,%edx
  801184:	89 d0                	mov    %edx,%eax
}
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80118b:	eb 09                	jmp    801196 <strncmp+0xe>
		n--, p++, q++;
  80118d:	ff 4d 10             	decl   0x10(%ebp)
  801190:	ff 45 08             	incl   0x8(%ebp)
  801193:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801196:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119a:	74 17                	je     8011b3 <strncmp+0x2b>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	74 0e                	je     8011b3 <strncmp+0x2b>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 10                	mov    (%eax),%dl
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	38 c2                	cmp    %al,%dl
  8011b1:	74 da                	je     80118d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b7:	75 07                	jne    8011c0 <strncmp+0x38>
		return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011be:	eb 14                	jmp    8011d4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	0f b6 d0             	movzbl %al,%edx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	0f b6 c0             	movzbl %al,%eax
  8011d0:	29 c2                	sub    %eax,%edx
  8011d2:	89 d0                	mov    %edx,%eax
}
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e2:	eb 12                	jmp    8011f6 <strchr+0x20>
		if (*s == c)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ec:	75 05                	jne    8011f3 <strchr+0x1d>
			return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	eb 11                	jmp    801204 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	75 e5                	jne    8011e4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801212:	eb 0d                	jmp    801221 <strfind+0x1b>
		if (*s == c)
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80121c:	74 0e                	je     80122c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80121e:	ff 45 08             	incl   0x8(%ebp)
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	75 ea                	jne    801214 <strfind+0xe>
  80122a:	eb 01                	jmp    80122d <strfind+0x27>
		if (*s == c)
			break;
  80122c:	90                   	nop
	return (char *) s;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801244:	eb 0e                	jmp    801254 <memset+0x22>
		*p++ = c;
  801246:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801249:	8d 50 01             	lea    0x1(%eax),%edx
  80124c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801252:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801254:	ff 4d f8             	decl   -0x8(%ebp)
  801257:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80125b:	79 e9                	jns    801246 <memset+0x14>
		*p++ = c;

	return v;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801274:	eb 16                	jmp    80128c <memcpy+0x2a>
		*d++ = *s++;
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	8d 50 01             	lea    0x1(%eax),%edx
  80127c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80127f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801282:	8d 4a 01             	lea    0x1(%edx),%ecx
  801285:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801288:	8a 12                	mov    (%edx),%dl
  80128a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801292:	89 55 10             	mov    %edx,0x10(%ebp)
  801295:	85 c0                	test   %eax,%eax
  801297:	75 dd                	jne    801276 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b6:	73 50                	jae    801308 <memmove+0x6a>
  8012b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c3:	76 43                	jbe    801308 <memmove+0x6a>
		s += n;
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d1:	eb 10                	jmp    8012e3 <memmove+0x45>
			*--d = *--s;
  8012d3:	ff 4d f8             	decl   -0x8(%ebp)
  8012d6:	ff 4d fc             	decl   -0x4(%ebp)
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	8a 10                	mov    (%eax),%dl
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	75 e3                	jne    8012d3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012f0:	eb 23                	jmp    801315 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f5:	8d 50 01             	lea    0x1(%eax),%edx
  8012f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801301:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801304:	8a 12                	mov    (%edx),%dl
  801306:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801308:	8b 45 10             	mov    0x10(%ebp),%eax
  80130b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130e:	89 55 10             	mov    %edx,0x10(%ebp)
  801311:	85 c0                	test   %eax,%eax
  801313:	75 dd                	jne    8012f2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80132c:	eb 2a                	jmp    801358 <memcmp+0x3e>
		if (*s1 != *s2)
  80132e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801331:	8a 10                	mov    (%eax),%dl
  801333:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	38 c2                	cmp    %al,%dl
  80133a:	74 16                	je     801352 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	0f b6 d0             	movzbl %al,%edx
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801347:	8a 00                	mov    (%eax),%al
  801349:	0f b6 c0             	movzbl %al,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	eb 18                	jmp    80136a <memcmp+0x50>
		s1++, s2++;
  801352:	ff 45 fc             	incl   -0x4(%ebp)
  801355:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135e:	89 55 10             	mov    %edx,0x10(%ebp)
  801361:	85 c0                	test   %eax,%eax
  801363:	75 c9                	jne    80132e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801372:	8b 55 08             	mov    0x8(%ebp),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80137d:	eb 15                	jmp    801394 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	0f b6 d0             	movzbl %al,%edx
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	0f b6 c0             	movzbl %al,%eax
  80138d:	39 c2                	cmp    %eax,%edx
  80138f:	74 0d                	je     80139e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801391:	ff 45 08             	incl   0x8(%ebp)
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80139a:	72 e3                	jb     80137f <memfind+0x13>
  80139c:	eb 01                	jmp    80139f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80139e:	90                   	nop
	return (void *) s;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b8:	eb 03                	jmp    8013bd <strtol+0x19>
		s++;
  8013ba:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 20                	cmp    $0x20,%al
  8013c4:	74 f4                	je     8013ba <strtol+0x16>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	3c 09                	cmp    $0x9,%al
  8013cd:	74 eb                	je     8013ba <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 2b                	cmp    $0x2b,%al
  8013d6:	75 05                	jne    8013dd <strtol+0x39>
		s++;
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	eb 13                	jmp    8013f0 <strtol+0x4c>
	else if (*s == '-')
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	3c 2d                	cmp    $0x2d,%al
  8013e4:	75 0a                	jne    8013f0 <strtol+0x4c>
		s++, neg = 1;
  8013e6:	ff 45 08             	incl   0x8(%ebp)
  8013e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f4:	74 06                	je     8013fc <strtol+0x58>
  8013f6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013fa:	75 20                	jne    80141c <strtol+0x78>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	3c 30                	cmp    $0x30,%al
  801403:	75 17                	jne    80141c <strtol+0x78>
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	40                   	inc    %eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	3c 78                	cmp    $0x78,%al
  80140d:	75 0d                	jne    80141c <strtol+0x78>
		s += 2, base = 16;
  80140f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801413:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80141a:	eb 28                	jmp    801444 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80141c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801420:	75 15                	jne    801437 <strtol+0x93>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	3c 30                	cmp    $0x30,%al
  801429:	75 0c                	jne    801437 <strtol+0x93>
		s++, base = 8;
  80142b:	ff 45 08             	incl   0x8(%ebp)
  80142e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801435:	eb 0d                	jmp    801444 <strtol+0xa0>
	else if (base == 0)
  801437:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143b:	75 07                	jne    801444 <strtol+0xa0>
		base = 10;
  80143d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	3c 2f                	cmp    $0x2f,%al
  80144b:	7e 19                	jle    801466 <strtol+0xc2>
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	3c 39                	cmp    $0x39,%al
  801454:	7f 10                	jg     801466 <strtol+0xc2>
			dig = *s - '0';
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	0f be c0             	movsbl %al,%eax
  80145e:	83 e8 30             	sub    $0x30,%eax
  801461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801464:	eb 42                	jmp    8014a8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 60                	cmp    $0x60,%al
  80146d:	7e 19                	jle    801488 <strtol+0xe4>
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 7a                	cmp    $0x7a,%al
  801476:	7f 10                	jg     801488 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	0f be c0             	movsbl %al,%eax
  801480:	83 e8 57             	sub    $0x57,%eax
  801483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801486:	eb 20                	jmp    8014a8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 40                	cmp    $0x40,%al
  80148f:	7e 39                	jle    8014ca <strtol+0x126>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3c 5a                	cmp    $0x5a,%al
  801498:	7f 30                	jg     8014ca <strtol+0x126>
			dig = *s - 'A' + 10;
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 37             	sub    $0x37,%eax
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ab:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ae:	7d 19                	jge    8014c9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014b0:	ff 45 08             	incl   0x8(%ebp)
  8014b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bf:	01 d0                	add    %edx,%eax
  8014c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014c4:	e9 7b ff ff ff       	jmp    801444 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014c9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ce:	74 08                	je     8014d8 <strtol+0x134>
		*endptr = (char *) s;
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014dc:	74 07                	je     8014e5 <strtol+0x141>
  8014de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e1:	f7 d8                	neg    %eax
  8014e3:	eb 03                	jmp    8014e8 <strtol+0x144>
  8014e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <ltostr>:

void
ltostr(long value, char *str)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801502:	79 13                	jns    801517 <ltostr+0x2d>
	{
		neg = 1;
  801504:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801511:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801514:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80151f:	99                   	cltd   
  801520:	f7 f9                	idiv   %ecx
  801522:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801525:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801528:	8d 50 01             	lea    0x1(%eax),%edx
  80152b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80152e:	89 c2                	mov    %eax,%edx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801538:	83 c2 30             	add    $0x30,%edx
  80153b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80153d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801540:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801545:	f7 e9                	imul   %ecx
  801547:	c1 fa 02             	sar    $0x2,%edx
  80154a:	89 c8                	mov    %ecx,%eax
  80154c:	c1 f8 1f             	sar    $0x1f,%eax
  80154f:	29 c2                	sub    %eax,%edx
  801551:	89 d0                	mov    %edx,%eax
  801553:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801556:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801559:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80155e:	f7 e9                	imul   %ecx
  801560:	c1 fa 02             	sar    $0x2,%edx
  801563:	89 c8                	mov    %ecx,%eax
  801565:	c1 f8 1f             	sar    $0x1f,%eax
  801568:	29 c2                	sub    %eax,%edx
  80156a:	89 d0                	mov    %edx,%eax
  80156c:	c1 e0 02             	shl    $0x2,%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	01 c0                	add    %eax,%eax
  801573:	29 c1                	sub    %eax,%ecx
  801575:	89 ca                	mov    %ecx,%edx
  801577:	85 d2                	test   %edx,%edx
  801579:	75 9c                	jne    801517 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80157b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801582:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801585:	48                   	dec    %eax
  801586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801589:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158d:	74 3d                	je     8015cc <ltostr+0xe2>
		start = 1 ;
  80158f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801596:	eb 34                	jmp    8015cc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159e:	01 d0                	add    %edx,%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ab:	01 c2                	add    %eax,%edx
  8015ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	01 c8                	add    %ecx,%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015c4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015c6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015c9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015d2:	7c c4                	jl     801598 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	e8 54 fa ff ff       	call   801044 <strlen>
  8015f0:	83 c4 04             	add    $0x4,%esp
  8015f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	e8 46 fa ff ff       	call   801044 <strlen>
  8015fe:	83 c4 04             	add    $0x4,%esp
  801601:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801604:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80160b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801612:	eb 17                	jmp    80162b <strcconcat+0x49>
		final[s] = str1[s] ;
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	01 c2                	add    %eax,%edx
  80161c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	01 c8                	add    %ecx,%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801631:	7c e1                	jl     801614 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801633:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801641:	eb 1f                	jmp    801662 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801643:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801646:	8d 50 01             	lea    0x1(%eax),%edx
  801649:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80164c:	89 c2                	mov    %eax,%edx
  80164e:	8b 45 10             	mov    0x10(%ebp),%eax
  801651:	01 c2                	add    %eax,%edx
  801653:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c8                	add    %ecx,%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80165f:	ff 45 f8             	incl   -0x8(%ebp)
  801662:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801665:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801668:	7c d9                	jl     801643 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80166a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166d:	8b 45 10             	mov    0x10(%ebp),%eax
  801670:	01 d0                	add    %edx,%eax
  801672:	c6 00 00             	movb   $0x0,(%eax)
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80167b:	8b 45 14             	mov    0x14(%ebp),%eax
  80167e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801684:	8b 45 14             	mov    0x14(%ebp),%eax
  801687:	8b 00                	mov    (%eax),%eax
  801689:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169b:	eb 0c                	jmp    8016a9 <strsplit+0x31>
			*string++ = 0;
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8d 50 01             	lea    0x1(%eax),%edx
  8016a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016a6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8a 00                	mov    (%eax),%al
  8016ae:	84 c0                	test   %al,%al
  8016b0:	74 18                	je     8016ca <strsplit+0x52>
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	0f be c0             	movsbl %al,%eax
  8016ba:	50                   	push   %eax
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	e8 13 fb ff ff       	call   8011d6 <strchr>
  8016c3:	83 c4 08             	add    $0x8,%esp
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	75 d3                	jne    80169d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	84 c0                	test   %al,%al
  8016d1:	74 5a                	je     80172d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	83 f8 0f             	cmp    $0xf,%eax
  8016db:	75 07                	jne    8016e4 <strsplit+0x6c>
		{
			return 0;
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	eb 66                	jmp    80174a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e7:	8b 00                	mov    (%eax),%eax
  8016e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ec:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ef:	89 0a                	mov    %ecx,(%edx)
  8016f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fb:	01 c2                	add    %eax,%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801702:	eb 03                	jmp    801707 <strsplit+0x8f>
			string++;
  801704:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	84 c0                	test   %al,%al
  80170e:	74 8b                	je     80169b <strsplit+0x23>
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f be c0             	movsbl %al,%eax
  801718:	50                   	push   %eax
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	e8 b5 fa ff ff       	call   8011d6 <strchr>
  801721:	83 c4 08             	add    $0x8,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	74 dc                	je     801704 <strsplit+0x8c>
			string++;
	}
  801728:	e9 6e ff ff ff       	jmp    80169b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80172d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	8b 00                	mov    (%eax),%eax
  801733:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173a:	8b 45 10             	mov    0x10(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801745:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	57                   	push   %edi
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801761:	8b 7d 18             	mov    0x18(%ebp),%edi
  801764:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801767:	cd 30                	int    $0x30
  801769:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	5b                   	pop    %ebx
  801773:	5e                   	pop    %esi
  801774:	5f                   	pop    %edi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801783:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	52                   	push   %edx
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	50                   	push   %eax
  801793:	6a 00                	push   $0x0
  801795:	e8 b2 ff ff ff       	call   80174c <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	90                   	nop
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 01                	push   $0x1
  8017af:	e8 98 ff ff ff       	call   80174c <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	6a 05                	push   $0x5
  8017cc:	e8 7b ff ff ff       	call   80174c <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017db:	8b 75 18             	mov    0x18(%ebp),%esi
  8017de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	51                   	push   %ecx
  8017ed:	52                   	push   %edx
  8017ee:	50                   	push   %eax
  8017ef:	6a 06                	push   $0x6
  8017f1:	e8 56 ff ff ff       	call   80174c <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 07                	push   $0x7
  801813:	e8 34 ff ff ff       	call   80174c <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	6a 08                	push   $0x8
  80182e:	e8 19 ff ff ff       	call   80174c <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 09                	push   $0x9
  801847:	e8 00 ff ff ff       	call   80174c <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 0a                	push   $0xa
  801860:	e8 e7 fe ff ff       	call   80174c <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 0b                	push   $0xb
  801879:	e8 ce fe ff ff       	call   80174c <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 0f                	push   $0xf
  801894:	e8 b3 fe ff ff       	call   80174c <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
	return;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	6a 10                	push   $0x10
  8018b0:	e8 97 fe ff ff       	call   80174c <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b8:	90                   	nop
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 10             	pushl  0x10(%ebp)
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 11                	push   $0x11
  8018cd:	e8 7a fe ff ff       	call   80174c <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 0c                	push   $0xc
  8018e7:	e8 60 fe ff ff       	call   80174c <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 0d                	push   $0xd
  801901:	e8 46 fe ff ff       	call   80174c <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 0e                	push   $0xe
  80191a:	e8 2d fe ff ff       	call   80174c <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	90                   	nop
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 13                	push   $0x13
  801934:	e8 13 fe ff ff       	call   80174c <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 14                	push   $0x14
  80194e:	e8 f9 fd ff ff       	call   80174c <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_cputc>:


void
sys_cputc(const char c)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801965:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	50                   	push   %eax
  801972:	6a 15                	push   $0x15
  801974:	e8 d3 fd ff ff       	call   80174c <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 16                	push   $0x16
  80198e:	e8 b9 fd ff ff       	call   80174c <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	50                   	push   %eax
  8019a9:	6a 17                	push   $0x17
  8019ab:	e8 9c fd ff ff       	call   80174c <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	6a 1a                	push   $0x1a
  8019c8:	e8 7f fd ff ff       	call   80174c <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 18                	push   $0x18
  8019e5:	e8 62 fd ff ff       	call   80174c <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 19                	push   $0x19
  801a03:	e8 44 fd ff ff       	call   80174c <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a1a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a1d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	51                   	push   %ecx
  801a27:	52                   	push   %edx
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	6a 1b                	push   $0x1b
  801a2e:	e8 19 fd ff ff       	call   80174c <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 1c                	push   $0x1c
  801a4b:	e8 fc fc ff ff       	call   80174c <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	51                   	push   %ecx
  801a66:	52                   	push   %edx
  801a67:	50                   	push   %eax
  801a68:	6a 1d                	push   $0x1d
  801a6a:	e8 dd fc ff ff       	call   80174c <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1e                	push   $0x1e
  801a87:	e8 c0 fc ff ff       	call   80174c <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 1f                	push   $0x1f
  801aa0:	e8 a7 fc ff ff       	call   80174c <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 14             	pushl  0x14(%ebp)
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	50                   	push   %eax
  801abc:	6a 20                	push   $0x20
  801abe:	e8 89 fc ff ff       	call   80174c <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	50                   	push   %eax
  801ad7:	6a 21                	push   $0x21
  801ad9:	e8 6e fc ff ff       	call   80174c <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	50                   	push   %eax
  801af3:	6a 22                	push   $0x22
  801af5:	e8 52 fc ff ff       	call   80174c <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 02                	push   $0x2
  801b0e:	e8 39 fc ff ff       	call   80174c <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 03                	push   $0x3
  801b27:	e8 20 fc ff ff       	call   80174c <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 04                	push   $0x4
  801b40:	e8 07 fc ff ff       	call   80174c <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_exit_env>:


void sys_exit_env(void)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 23                	push   $0x23
  801b59:	e8 ee fb ff ff       	call   80174c <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b6a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6d:	8d 50 04             	lea    0x4(%eax),%edx
  801b70:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 24                	push   $0x24
  801b7d:	e8 ca fb ff ff       	call   80174c <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return result;
  801b85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8e:	89 01                	mov    %eax,(%ecx)
  801b90:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	c9                   	leave  
  801b97:	c2 04 00             	ret    $0x4

00801b9a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	ff 75 10             	pushl  0x10(%ebp)
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	6a 12                	push   $0x12
  801bac:	e8 9b fb ff ff       	call   80174c <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 25                	push   $0x25
  801bc6:	e8 81 fb ff ff       	call   80174c <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bdc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	50                   	push   %eax
  801be9:	6a 26                	push   $0x26
  801beb:	e8 5c fb ff ff       	call   80174c <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf3:	90                   	nop
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <rsttst>:
void rsttst()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 28                	push   $0x28
  801c05:	e8 42 fb ff ff       	call   80174c <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0d:	90                   	nop
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 04             	sub    $0x4,%esp
  801c16:	8b 45 14             	mov    0x14(%ebp),%eax
  801c19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c1c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c1f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	ff 75 10             	pushl  0x10(%ebp)
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	6a 27                	push   $0x27
  801c30:	e8 17 fb ff ff       	call   80174c <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
	return ;
  801c38:	90                   	nop
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <chktst>:
void chktst(uint32 n)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	6a 29                	push   $0x29
  801c4b:	e8 fc fa ff ff       	call   80174c <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return ;
  801c53:	90                   	nop
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <inctst>:

void inctst()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 2a                	push   $0x2a
  801c65:	e8 e2 fa ff ff       	call   80174c <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6d:	90                   	nop
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <gettst>:
uint32 gettst()
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 2b                	push   $0x2b
  801c7f:	e8 c8 fa ff ff       	call   80174c <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 2c                	push   $0x2c
  801c9b:	e8 ac fa ff ff       	call   80174c <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
  801ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ca6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801caa:	75 07                	jne    801cb3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cac:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb1:	eb 05                	jmp    801cb8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 2c                	push   $0x2c
  801ccc:	e8 7b fa ff ff       	call   80174c <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
  801cd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cd7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cdb:	75 07                	jne    801ce4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	eb 05                	jmp    801ce9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 2c                	push   $0x2c
  801cfd:	e8 4a fa ff ff       	call   80174c <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
  801d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d08:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d0c:	75 07                	jne    801d15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	eb 05                	jmp    801d1a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 2c                	push   $0x2c
  801d2e:	e8 19 fa ff ff       	call   80174c <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
  801d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d39:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d3d:	75 07                	jne    801d46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d44:	eb 05                	jmp    801d4b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 2d                	push   $0x2d
  801d5d:	e8 ea f9 ff ff       	call   80174c <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	53                   	push   %ebx
  801d7b:	51                   	push   %ecx
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 2e                	push   $0x2e
  801d80:	e8 c7 f9 ff ff       	call   80174c <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 2f                	push   $0x2f
  801da0:	e8 a7 f9 ff ff       	call   80174c <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    
  801daa:	66 90                	xchg   %ax,%ax

00801dac <__udivdi3>:
  801dac:	55                   	push   %ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
  801db3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801db7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dc3:	89 ca                	mov    %ecx,%edx
  801dc5:	89 f8                	mov    %edi,%eax
  801dc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dcb:	85 f6                	test   %esi,%esi
  801dcd:	75 2d                	jne    801dfc <__udivdi3+0x50>
  801dcf:	39 cf                	cmp    %ecx,%edi
  801dd1:	77 65                	ja     801e38 <__udivdi3+0x8c>
  801dd3:	89 fd                	mov    %edi,%ebp
  801dd5:	85 ff                	test   %edi,%edi
  801dd7:	75 0b                	jne    801de4 <__udivdi3+0x38>
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	31 d2                	xor    %edx,%edx
  801de0:	f7 f7                	div    %edi
  801de2:	89 c5                	mov    %eax,%ebp
  801de4:	31 d2                	xor    %edx,%edx
  801de6:	89 c8                	mov    %ecx,%eax
  801de8:	f7 f5                	div    %ebp
  801dea:	89 c1                	mov    %eax,%ecx
  801dec:	89 d8                	mov    %ebx,%eax
  801dee:	f7 f5                	div    %ebp
  801df0:	89 cf                	mov    %ecx,%edi
  801df2:	89 fa                	mov    %edi,%edx
  801df4:	83 c4 1c             	add    $0x1c,%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5f                   	pop    %edi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    
  801dfc:	39 ce                	cmp    %ecx,%esi
  801dfe:	77 28                	ja     801e28 <__udivdi3+0x7c>
  801e00:	0f bd fe             	bsr    %esi,%edi
  801e03:	83 f7 1f             	xor    $0x1f,%edi
  801e06:	75 40                	jne    801e48 <__udivdi3+0x9c>
  801e08:	39 ce                	cmp    %ecx,%esi
  801e0a:	72 0a                	jb     801e16 <__udivdi3+0x6a>
  801e0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e10:	0f 87 9e 00 00 00    	ja     801eb4 <__udivdi3+0x108>
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	89 fa                	mov    %edi,%edx
  801e1d:	83 c4 1c             	add    $0x1c,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    
  801e25:	8d 76 00             	lea    0x0(%esi),%esi
  801e28:	31 ff                	xor    %edi,%edi
  801e2a:	31 c0                	xor    %eax,%eax
  801e2c:	89 fa                	mov    %edi,%edx
  801e2e:	83 c4 1c             	add    $0x1c,%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5f                   	pop    %edi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    
  801e36:	66 90                	xchg   %ax,%ax
  801e38:	89 d8                	mov    %ebx,%eax
  801e3a:	f7 f7                	div    %edi
  801e3c:	31 ff                	xor    %edi,%edi
  801e3e:	89 fa                	mov    %edi,%edx
  801e40:	83 c4 1c             	add    $0x1c,%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
  801e48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e4d:	89 eb                	mov    %ebp,%ebx
  801e4f:	29 fb                	sub    %edi,%ebx
  801e51:	89 f9                	mov    %edi,%ecx
  801e53:	d3 e6                	shl    %cl,%esi
  801e55:	89 c5                	mov    %eax,%ebp
  801e57:	88 d9                	mov    %bl,%cl
  801e59:	d3 ed                	shr    %cl,%ebp
  801e5b:	89 e9                	mov    %ebp,%ecx
  801e5d:	09 f1                	or     %esi,%ecx
  801e5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e63:	89 f9                	mov    %edi,%ecx
  801e65:	d3 e0                	shl    %cl,%eax
  801e67:	89 c5                	mov    %eax,%ebp
  801e69:	89 d6                	mov    %edx,%esi
  801e6b:	88 d9                	mov    %bl,%cl
  801e6d:	d3 ee                	shr    %cl,%esi
  801e6f:	89 f9                	mov    %edi,%ecx
  801e71:	d3 e2                	shl    %cl,%edx
  801e73:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e77:	88 d9                	mov    %bl,%cl
  801e79:	d3 e8                	shr    %cl,%eax
  801e7b:	09 c2                	or     %eax,%edx
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	f7 74 24 0c          	divl   0xc(%esp)
  801e85:	89 d6                	mov    %edx,%esi
  801e87:	89 c3                	mov    %eax,%ebx
  801e89:	f7 e5                	mul    %ebp
  801e8b:	39 d6                	cmp    %edx,%esi
  801e8d:	72 19                	jb     801ea8 <__udivdi3+0xfc>
  801e8f:	74 0b                	je     801e9c <__udivdi3+0xf0>
  801e91:	89 d8                	mov    %ebx,%eax
  801e93:	31 ff                	xor    %edi,%edi
  801e95:	e9 58 ff ff ff       	jmp    801df2 <__udivdi3+0x46>
  801e9a:	66 90                	xchg   %ax,%ax
  801e9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ea0:	89 f9                	mov    %edi,%ecx
  801ea2:	d3 e2                	shl    %cl,%edx
  801ea4:	39 c2                	cmp    %eax,%edx
  801ea6:	73 e9                	jae    801e91 <__udivdi3+0xe5>
  801ea8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eab:	31 ff                	xor    %edi,%edi
  801ead:	e9 40 ff ff ff       	jmp    801df2 <__udivdi3+0x46>
  801eb2:	66 90                	xchg   %ax,%ax
  801eb4:	31 c0                	xor    %eax,%eax
  801eb6:	e9 37 ff ff ff       	jmp    801df2 <__udivdi3+0x46>
  801ebb:	90                   	nop

00801ebc <__umoddi3>:
  801ebc:	55                   	push   %ebp
  801ebd:	57                   	push   %edi
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 1c             	sub    $0x1c,%esp
  801ec3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ec7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ecf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ed7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801edb:	89 f3                	mov    %esi,%ebx
  801edd:	89 fa                	mov    %edi,%edx
  801edf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ee3:	89 34 24             	mov    %esi,(%esp)
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 1a                	jne    801f04 <__umoddi3+0x48>
  801eea:	39 f7                	cmp    %esi,%edi
  801eec:	0f 86 a2 00 00 00    	jbe    801f94 <__umoddi3+0xd8>
  801ef2:	89 c8                	mov    %ecx,%eax
  801ef4:	89 f2                	mov    %esi,%edx
  801ef6:	f7 f7                	div    %edi
  801ef8:	89 d0                	mov    %edx,%eax
  801efa:	31 d2                	xor    %edx,%edx
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    
  801f04:	39 f0                	cmp    %esi,%eax
  801f06:	0f 87 ac 00 00 00    	ja     801fb8 <__umoddi3+0xfc>
  801f0c:	0f bd e8             	bsr    %eax,%ebp
  801f0f:	83 f5 1f             	xor    $0x1f,%ebp
  801f12:	0f 84 ac 00 00 00    	je     801fc4 <__umoddi3+0x108>
  801f18:	bf 20 00 00 00       	mov    $0x20,%edi
  801f1d:	29 ef                	sub    %ebp,%edi
  801f1f:	89 fe                	mov    %edi,%esi
  801f21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f25:	89 e9                	mov    %ebp,%ecx
  801f27:	d3 e0                	shl    %cl,%eax
  801f29:	89 d7                	mov    %edx,%edi
  801f2b:	89 f1                	mov    %esi,%ecx
  801f2d:	d3 ef                	shr    %cl,%edi
  801f2f:	09 c7                	or     %eax,%edi
  801f31:	89 e9                	mov    %ebp,%ecx
  801f33:	d3 e2                	shl    %cl,%edx
  801f35:	89 14 24             	mov    %edx,(%esp)
  801f38:	89 d8                	mov    %ebx,%eax
  801f3a:	d3 e0                	shl    %cl,%eax
  801f3c:	89 c2                	mov    %eax,%edx
  801f3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f42:	d3 e0                	shl    %cl,%eax
  801f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f4c:	89 f1                	mov    %esi,%ecx
  801f4e:	d3 e8                	shr    %cl,%eax
  801f50:	09 d0                	or     %edx,%eax
  801f52:	d3 eb                	shr    %cl,%ebx
  801f54:	89 da                	mov    %ebx,%edx
  801f56:	f7 f7                	div    %edi
  801f58:	89 d3                	mov    %edx,%ebx
  801f5a:	f7 24 24             	mull   (%esp)
  801f5d:	89 c6                	mov    %eax,%esi
  801f5f:	89 d1                	mov    %edx,%ecx
  801f61:	39 d3                	cmp    %edx,%ebx
  801f63:	0f 82 87 00 00 00    	jb     801ff0 <__umoddi3+0x134>
  801f69:	0f 84 91 00 00 00    	je     802000 <__umoddi3+0x144>
  801f6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f73:	29 f2                	sub    %esi,%edx
  801f75:	19 cb                	sbb    %ecx,%ebx
  801f77:	89 d8                	mov    %ebx,%eax
  801f79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f7d:	d3 e0                	shl    %cl,%eax
  801f7f:	89 e9                	mov    %ebp,%ecx
  801f81:	d3 ea                	shr    %cl,%edx
  801f83:	09 d0                	or     %edx,%eax
  801f85:	89 e9                	mov    %ebp,%ecx
  801f87:	d3 eb                	shr    %cl,%ebx
  801f89:	89 da                	mov    %ebx,%edx
  801f8b:	83 c4 1c             	add    $0x1c,%esp
  801f8e:	5b                   	pop    %ebx
  801f8f:	5e                   	pop    %esi
  801f90:	5f                   	pop    %edi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    
  801f93:	90                   	nop
  801f94:	89 fd                	mov    %edi,%ebp
  801f96:	85 ff                	test   %edi,%edi
  801f98:	75 0b                	jne    801fa5 <__umoddi3+0xe9>
  801f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9f:	31 d2                	xor    %edx,%edx
  801fa1:	f7 f7                	div    %edi
  801fa3:	89 c5                	mov    %eax,%ebp
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	31 d2                	xor    %edx,%edx
  801fa9:	f7 f5                	div    %ebp
  801fab:	89 c8                	mov    %ecx,%eax
  801fad:	f7 f5                	div    %ebp
  801faf:	89 d0                	mov    %edx,%eax
  801fb1:	e9 44 ff ff ff       	jmp    801efa <__umoddi3+0x3e>
  801fb6:	66 90                	xchg   %ax,%ax
  801fb8:	89 c8                	mov    %ecx,%eax
  801fba:	89 f2                	mov    %esi,%edx
  801fbc:	83 c4 1c             	add    $0x1c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    
  801fc4:	3b 04 24             	cmp    (%esp),%eax
  801fc7:	72 06                	jb     801fcf <__umoddi3+0x113>
  801fc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fcd:	77 0f                	ja     801fde <__umoddi3+0x122>
  801fcf:	89 f2                	mov    %esi,%edx
  801fd1:	29 f9                	sub    %edi,%ecx
  801fd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fd7:	89 14 24             	mov    %edx,(%esp)
  801fda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fde:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fe2:	8b 14 24             	mov    (%esp),%edx
  801fe5:	83 c4 1c             	add    $0x1c,%esp
  801fe8:	5b                   	pop    %ebx
  801fe9:	5e                   	pop    %esi
  801fea:	5f                   	pop    %edi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    
  801fed:	8d 76 00             	lea    0x0(%esi),%esi
  801ff0:	2b 04 24             	sub    (%esp),%eax
  801ff3:	19 fa                	sbb    %edi,%edx
  801ff5:	89 d1                	mov    %edx,%ecx
  801ff7:	89 c6                	mov    %eax,%esi
  801ff9:	e9 71 ff ff ff       	jmp    801f6f <__umoddi3+0xb3>
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802004:	72 ea                	jb     801ff0 <__umoddi3+0x134>
  802006:	89 d9                	mov    %ebx,%ecx
  802008:	e9 62 ff ff ff       	jmp    801f6f <__umoddi3+0xb3>
