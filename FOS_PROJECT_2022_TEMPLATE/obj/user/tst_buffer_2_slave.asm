
obj/user/tst_buffer_2_slave:     file format elf32-i386


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
  800031:	e8 7e 06 00 00       	call   8006b4 <libmain>
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
  80003b:	83 ec 68             	sub    $0x68,%esp



	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80004e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 21 80 00       	push   $0x8021c0
  800065:	6a 17                	push   $0x17
  800067:	68 08 22 80 00       	push   $0x802208
  80006c:	e8 92 07 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800084:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 c0 21 80 00       	push   $0x8021c0
  80009b:	6a 18                	push   $0x18
  80009d:	68 08 22 80 00       	push   $0x802208
  8000a2:	e8 5c 07 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 c0 21 80 00       	push   $0x8021c0
  8000d1:	6a 19                	push   $0x19
  8000d3:	68 08 22 80 00       	push   $0x802208
  8000d8:	e8 26 07 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8000f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 c0 21 80 00       	push   $0x8021c0
  800107:	6a 1a                	push   $0x1a
  800109:	68 08 22 80 00       	push   $0x802208
  80010e:	e8 f0 06 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800126:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 c0 21 80 00       	push   $0x8021c0
  80013d:	6a 1b                	push   $0x1b
  80013f:	68 08 22 80 00       	push   $0x802208
  800144:	e8 ba 06 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80015c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 c0 21 80 00       	push   $0x8021c0
  800173:	6a 1c                	push   $0x1c
  800175:	68 08 22 80 00       	push   $0x802208
  80017a:	e8 84 06 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800194:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 c0 21 80 00       	push   $0x8021c0
  8001ab:	6a 1d                	push   $0x1d
  8001ad:	68 08 22 80 00       	push   $0x802208
  8001b2:	e8 4c 06 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 c0 21 80 00       	push   $0x8021c0
  8001e3:	6a 1e                	push   $0x1e
  8001e5:	68 08 22 80 00       	push   $0x802208
  8001ea:	e8 14 06 00 00       	call   800803 <_panic>
		//if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800204:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 c0 21 80 00       	push   $0x8021c0
  80021b:	6a 20                	push   $0x20
  80021d:	68 08 22 80 00       	push   $0x802208
  800222:	e8 dc 05 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800232:	05 d8 00 00 00       	add    $0xd8,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80023c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 c0 21 80 00       	push   $0x8021c0
  800253:	6a 21                	push   $0x21
  800255:	68 08 22 80 00       	push   $0x802208
  80025a:	e8 a4 05 00 00       	call   800803 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026a:	05 f0 00 00 00       	add    $0xf0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800274:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 c0 21 80 00       	push   $0x8021c0
  80028b:	6a 22                	push   $0x22
  80028d:	68 08 22 80 00       	push   $0x802208
  800292:	e8 6c 05 00 00       	call   800803 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 14                	je     8002ba <_main+0x282>
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 24 22 80 00       	push   $0x802224
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 08 22 80 00       	push   $0x802208
  8002b5:	e8 49 05 00 00       	call   800803 <_panic>
	}

	int initModBufCnt = sys_calculate_modified_frames();
  8002ba:	e8 87 16 00 00       	call   801946 <sys_calculate_modified_frames>
  8002bf:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  8002c2:	e8 98 16 00 00       	call   80195f <sys_calculate_notmod_frames>
  8002c7:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 fe 16 00 00       	call   8019cd <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)

	//[1]Bring 7 pages and modify them (7 unmodified will be buffered)
	int i=0;
  8002d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum1 = 0;
  8002d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800303:	e8 57 16 00 00       	call   80195f <sys_calculate_notmod_frames>
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
	int dummy = 0;
	for(i=(PAGE_SIZE/4);i<arrSize;i+=PAGE_SIZE/4)
  80031c:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800323:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80032a:	7e c4                	jle    8002f0 <_main+0x2b8>
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}



	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80032c:	e8 2e 16 00 00       	call   80195f <sys_calculate_notmod_frames>
  800331:	89 c2                	mov    %eax,%edx
  800333:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800336:	29 c2                	sub    %eax,%edx
  800338:	89 d0                	mov    %edx,%eax
  80033a:	83 f8 07             	cmp    $0x7,%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 74 22 80 00       	push   $0x802274
  800347:	6a 37                	push   $0x37
  800349:	68 08 22 80 00       	push   $0x802208
  80034e:	e8 b0 04 00 00       	call   800803 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800353:	e8 ee 15 00 00       	call   801946 <sys_calculate_modified_frames>
  800358:	89 c2                	mov    %eax,%edx
  80035a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	74 14                	je     800375 <_main+0x33d>
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 d8 22 80 00       	push   $0x8022d8
  800369:	6a 38                	push   $0x38
  80036b:	68 08 22 80 00       	push   $0x802208
  800370:	e8 8e 04 00 00       	call   800803 <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  800375:	e8 e5 15 00 00       	call   80195f <sys_calculate_notmod_frames>
  80037a:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80037d:	e8 c4 15 00 00       	call   801946 <sys_calculate_modified_frames>
  800382:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003a2:	e8 b8 15 00 00       	call   80195f <sys_calculate_notmod_frames>
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	//cprintf("sys_calculate_notmod_frames()  - initFreeBufCnt = %d\n", sys_calculate_notmod_frames()  - initFreeBufCnt);
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  8003cb:	e8 8f 15 00 00       	call   80195f <sys_calculate_notmod_frames>
  8003d0:	89 c2                	mov    %eax,%edx
  8003d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d5:	39 c2                	cmp    %eax,%edx
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 74 22 80 00       	push   $0x802274
  8003e1:	6a 47                	push   $0x47
  8003e3:	68 08 22 80 00       	push   $0x802208
  8003e8:	e8 16 04 00 00       	call   800803 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  8003ed:	e8 54 15 00 00       	call   801946 <sys_calculate_modified_frames>
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	83 f8 07             	cmp    $0x7,%eax
  8003fe:	74 14                	je     800414 <_main+0x3dc>
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 d8 22 80 00       	push   $0x8022d8
  800408:	6a 48                	push   $0x48
  80040a:	68 08 22 80 00       	push   $0x802208
  80040f:	e8 ef 03 00 00       	call   800803 <_panic>
	initFreeBufCnt = sys_calculate_notmod_frames();
  800414:	e8 46 15 00 00       	call   80195f <sys_calculate_notmod_frames>
  800419:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  80041c:	e8 25 15 00 00       	call   801946 <sys_calculate_modified_frames>
  800421:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800448:	e8 12 15 00 00       	call   80195f <sys_calculate_notmod_frames>
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 40 4c             	mov    0x4c(%eax),%eax
  800457:	01 c2                	add    %eax,%edx
  800459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045c:	01 d0                	add    %edx,%eax
  80045e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	//[3]Bring the 7 modified pages again and ensure their values are correct (7 unmodified will be buffered)

	i = 0;
	int dstSum2 = 0 ;
	for(i=PAGE_SIZE/4;i<arrSize;i+=PAGE_SIZE/4)
  800461:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800468:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80046f:	7e ca                	jle    80043b <_main+0x403>
	{
		dstSum2 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800471:	e8 e9 14 00 00       	call   80195f <sys_calculate_notmod_frames>
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047b:	29 c2                	sub    %eax,%edx
  80047d:	89 d0                	mov    %edx,%eax
  80047f:	83 f8 07             	cmp    $0x7,%eax
  800482:	74 14                	je     800498 <_main+0x460>
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 74 22 80 00       	push   $0x802274
  80048c:	6a 56                	push   $0x56
  80048e:	68 08 22 80 00       	push   $0x802208
  800493:	e8 6b 03 00 00       	call   800803 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != -7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800498:	e8 a9 14 00 00       	call   801946 <sys_calculate_modified_frames>
  80049d:	89 c2                	mov    %eax,%edx
  80049f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004a2:	29 c2                	sub    %eax,%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8004a9:	74 14                	je     8004bf <_main+0x487>
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	68 d8 22 80 00       	push   $0x8022d8
  8004b3:	6a 57                	push   $0x57
  8004b5:	68 08 22 80 00       	push   $0x802208
  8004ba:	e8 44 03 00 00       	call   800803 <_panic>

	initFreeBufCnt = sys_calculate_notmod_frames();
  8004bf:	e8 9b 14 00 00       	call   80195f <sys_calculate_notmod_frames>
  8004c4:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8004c7:	e8 7a 14 00 00       	call   801946 <sys_calculate_modified_frames>
  8004cc:	89 45 ac             	mov    %eax,-0x54(%ebp)

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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004f3:	e8 67 14 00 00       	call   80195f <sys_calculate_notmod_frames>
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
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != -7)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  80051c:	e8 3e 14 00 00       	call   80195f <sys_calculate_notmod_frames>
  800521:	89 c2                	mov    %eax,%edx
  800523:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800526:	29 c2                	sub    %eax,%edx
  800528:	89 d0                	mov    %edx,%eax
  80052a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80052d:	74 14                	je     800543 <_main+0x50b>
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	68 74 22 80 00       	push   $0x802274
  800537:	6a 65                	push   $0x65
  800539:	68 08 22 80 00       	push   $0x802208
  80053e:	e8 c0 02 00 00       	call   800803 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800543:	e8 fe 13 00 00       	call   801946 <sys_calculate_modified_frames>
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	83 f8 07             	cmp    $0x7,%eax
  800554:	74 14                	je     80056a <_main+0x532>
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 d8 22 80 00       	push   $0x8022d8
  80055e:	6a 66                	push   $0x66
  800560:	68 08 22 80 00       	push   $0x802208
  800565:	e8 99 02 00 00       	call   800803 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  80056a:	e8 5e 14 00 00       	call   8019cd <sys_pf_calculate_allocated_pages>
  80056f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  800572:	74 14                	je     800588 <_main+0x550>
  800574:	83 ec 04             	sub    $0x4,%esp
  800577:	68 44 23 80 00       	push   $0x802344
  80057c:	6a 68                	push   $0x68
  80057e:	68 08 22 80 00       	push   $0x802208
  800583:	e8 7b 02 00 00       	call   800803 <_panic>

	if (srcSum1 != srcSum2 || dstSum1 != dstSum2) 	panic("Error in buffering/restoring modified/not modified pages") ;
  800588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80058b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80058e:	75 08                	jne    800598 <_main+0x560>
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800596:	74 14                	je     8005ac <_main+0x574>
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 b4 23 80 00       	push   $0x8023b4
  8005a0:	6a 6a                	push   $0x6a
  8005a2:	68 08 22 80 00       	push   $0x802208
  8005a7:	e8 57 02 00 00       	call   800803 <_panic>

	/*[5] BUSY-WAIT FOR A WHILE TILL FINISHING THE MASTER PROGRAM */
	env_sleep(5000);
  8005ac:	83 ec 0c             	sub    $0xc,%esp
  8005af:	68 88 13 00 00       	push   $0x1388
  8005b4:	e8 e6 18 00 00       	call   801e9f <env_sleep>
  8005b9:	83 c4 10             	add    $0x10,%esp

	/*[6] Read the modified pages of this slave program (after they have been written on page file) */
	initFreeBufCnt = sys_calculate_notmod_frames();
  8005bc:	e8 9e 13 00 00       	call   80195f <sys_calculate_notmod_frames>
  8005c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  8005c4:	e8 7d 13 00 00       	call   801946 <sys_calculate_modified_frames>
  8005c9:	89 45 ac             	mov    %eax,-0x54(%ebp)
	i = 0;
  8005cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int dstSum3 = 0 ;
  8005d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	dummy = 0;
  8005da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i=0;i<arrSize;i+=PAGE_SIZE/4)
  8005e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005e8:	eb 2d                	jmp    800617 <_main+0x5df>
	{
		dstSum3 += dst[i];
  8005ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ed:	8b 04 85 20 a2 82 00 	mov    0x82a220(,%eax,4),%eax
  8005f4:	01 45 dc             	add    %eax,-0x24(%ebp)
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005f7:	e8 63 13 00 00       	call   80195f <sys_calculate_notmod_frames>
  8005fc:	89 c2                	mov    %eax,%edx
  8005fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800603:	8b 40 4c             	mov    0x4c(%eax),%eax
  800606:	01 c2                	add    %eax,%edx
  800608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	initFreeBufCnt = sys_calculate_notmod_frames();
	initModBufCnt = sys_calculate_modified_frames();
	i = 0;
	int dstSum3 = 0 ;
	dummy = 0;
	for(i=0;i<arrSize;i+=PAGE_SIZE/4)
  800610:	81 45 f4 00 04 00 00 	addl   $0x400,-0xc(%ebp)
  800617:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80061e:	7e ca                	jle    8005ea <_main+0x5b2>
	{
		dstSum3 += dst[i];
		dummy += sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
	}

	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 0)  panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list");
  800620:	e8 3a 13 00 00       	call   80195f <sys_calculate_notmod_frames>
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	74 14                	je     800642 <_main+0x60a>
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	68 74 22 80 00       	push   $0x802274
  800636:	6a 7b                	push   $0x7b
  800638:	68 08 22 80 00       	push   $0x802208
  80063d:	e8 c1 01 00 00       	call   800803 <_panic>
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)  panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800642:	e8 ff 12 00 00       	call   801946 <sys_calculate_modified_frames>
  800647:	89 c2                	mov    %eax,%edx
  800649:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80064c:	39 c2                	cmp    %eax,%edx
  80064e:	74 14                	je     800664 <_main+0x62c>
  800650:	83 ec 04             	sub    $0x4,%esp
  800653:	68 d8 22 80 00       	push   $0x8022d8
  800658:	6a 7c                	push   $0x7c
  80065a:	68 08 22 80 00       	push   $0x802208
  80065f:	e8 9f 01 00 00       	call   800803 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add any new page to the page file");
  800664:	e8 64 13 00 00       	call   8019cd <sys_pf_calculate_allocated_pages>
  800669:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80066c:	74 14                	je     800682 <_main+0x64a>
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 44 23 80 00       	push   $0x802344
  800676:	6a 7e                	push   $0x7e
  800678:	68 08 22 80 00       	push   $0x802208
  80067d:	e8 81 01 00 00       	call   800803 <_panic>

	if (dstSum1 != dstSum3) 	panic("Error in buffering/restoring modified pages after freeing the modified list") ;
  800682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800688:	74 17                	je     8006a1 <_main+0x669>
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	68 f0 23 80 00       	push   $0x8023f0
  800692:	68 80 00 00 00       	push   $0x80
  800697:	68 08 22 80 00       	push   $0x802208
  80069c:	e8 62 01 00 00       	call   800803 <_panic>

	cprintf("Congratulations!! modified list is cleared and updated successfully.\n");
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	68 3c 24 80 00       	push   $0x80243c
  8006a9:	e8 09 04 00 00       	call   800ab7 <cprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp

	return;
  8006b1:	90                   	nop

}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006ba:	e8 4e 15 00 00       	call   801c0d <sys_getenvindex>
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8006c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c5:	89 d0                	mov    %edx,%eax
  8006c7:	01 c0                	add    %eax,%eax
  8006c9:	01 d0                	add    %edx,%eax
  8006cb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	c1 e0 02             	shl    $0x2,%eax
  8006d7:	01 d0                	add    %edx,%eax
  8006d9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006e0:	01 c8                	add    %ecx,%eax
  8006e2:	c1 e0 02             	shl    $0x2,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	c1 e0 02             	shl    $0x2,%eax
  8006ea:	01 d0                	add    %edx,%eax
  8006ec:	c1 e0 03             	shl    $0x3,%eax
  8006ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006f4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8006fe:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800704:	84 c0                	test   %al,%al
  800706:	74 0f                	je     800717 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800708:	a1 20 30 80 00       	mov    0x803020,%eax
  80070d:	05 18 da 01 00       	add    $0x1da18,%eax
  800712:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800717:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80071b:	7e 0a                	jle    800727 <libmain+0x73>
		binaryname = argv[0];
  80071d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	e8 03 f9 ff ff       	call   800038 <_main>
  800735:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800738:	e8 dd 12 00 00       	call   801a1a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80073d:	83 ec 0c             	sub    $0xc,%esp
  800740:	68 9c 24 80 00       	push   $0x80249c
  800745:	e8 6d 03 00 00       	call   800ab7 <cprintf>
  80074a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80074d:	a1 20 30 80 00       	mov    0x803020,%eax
  800752:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800758:	a1 20 30 80 00       	mov    0x803020,%eax
  80075d:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800763:	83 ec 04             	sub    $0x4,%esp
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	68 c4 24 80 00       	push   $0x8024c4
  80076d:	e8 45 03 00 00       	call   800ab7 <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800775:	a1 20 30 80 00       	mov    0x803020,%eax
  80077a:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800780:	a1 20 30 80 00       	mov    0x803020,%eax
  800785:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80078b:	a1 20 30 80 00       	mov    0x803020,%eax
  800790:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800796:	51                   	push   %ecx
  800797:	52                   	push   %edx
  800798:	50                   	push   %eax
  800799:	68 ec 24 80 00       	push   $0x8024ec
  80079e:	e8 14 03 00 00       	call   800ab7 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ab:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	50                   	push   %eax
  8007b5:	68 44 25 80 00       	push   $0x802544
  8007ba:	e8 f8 02 00 00       	call   800ab7 <cprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8007c2:	83 ec 0c             	sub    $0xc,%esp
  8007c5:	68 9c 24 80 00       	push   $0x80249c
  8007ca:	e8 e8 02 00 00       	call   800ab7 <cprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007d2:	e8 5d 12 00 00       	call   801a34 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8007d7:	e8 19 00 00 00       	call   8007f5 <exit>
}
  8007dc:	90                   	nop
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    

008007df <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	6a 00                	push   $0x0
  8007ea:	e8 ea 13 00 00       	call   801bd9 <sys_destroy_env>
  8007ef:	83 c4 10             	add    $0x10,%esp
}
  8007f2:	90                   	nop
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <exit>:

void
exit(void)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007fb:	e8 3f 14 00 00       	call   801c3f <sys_exit_env>
}
  800800:	90                   	nop
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800809:	8d 45 10             	lea    0x10(%ebp),%eax
  80080c:	83 c0 04             	add    $0x4,%eax
  80080f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800812:	a1 74 a2 83 00       	mov    0x83a274,%eax
  800817:	85 c0                	test   %eax,%eax
  800819:	74 16                	je     800831 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80081b:	a1 74 a2 83 00       	mov    0x83a274,%eax
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	50                   	push   %eax
  800824:	68 58 25 80 00       	push   $0x802558
  800829:	e8 89 02 00 00       	call   800ab7 <cprintf>
  80082e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800831:	a1 00 30 80 00       	mov    0x803000,%eax
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	ff 75 08             	pushl  0x8(%ebp)
  80083c:	50                   	push   %eax
  80083d:	68 5d 25 80 00       	push   $0x80255d
  800842:	e8 70 02 00 00       	call   800ab7 <cprintf>
  800847:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	50                   	push   %eax
  800854:	e8 f3 01 00 00       	call   800a4c <vcprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	6a 00                	push   $0x0
  800861:	68 79 25 80 00       	push   $0x802579
  800866:	e8 e1 01 00 00       	call   800a4c <vcprintf>
  80086b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80086e:	e8 82 ff ff ff       	call   8007f5 <exit>

	// should not return here
	while (1) ;
  800873:	eb fe                	jmp    800873 <_panic+0x70>

00800875 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80087b:	a1 20 30 80 00       	mov    0x803020,%eax
  800880:	8b 50 74             	mov    0x74(%eax),%edx
  800883:	8b 45 0c             	mov    0xc(%ebp),%eax
  800886:	39 c2                	cmp    %eax,%edx
  800888:	74 14                	je     80089e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80088a:	83 ec 04             	sub    $0x4,%esp
  80088d:	68 7c 25 80 00       	push   $0x80257c
  800892:	6a 26                	push   $0x26
  800894:	68 c8 25 80 00       	push   $0x8025c8
  800899:	e8 65 ff ff ff       	call   800803 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008ac:	e9 c2 00 00 00       	jmp    800973 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	01 d0                	add    %edx,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	85 c0                	test   %eax,%eax
  8008c4:	75 08                	jne    8008ce <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8008c6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008c9:	e9 a2 00 00 00       	jmp    800970 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8008ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008dc:	eb 69                	jmp    800947 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008de:	a1 20 30 80 00       	mov    0x803020,%eax
  8008e3:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ec:	89 d0                	mov    %edx,%eax
  8008ee:	01 c0                	add    %eax,%eax
  8008f0:	01 d0                	add    %edx,%eax
  8008f2:	c1 e0 03             	shl    $0x3,%eax
  8008f5:	01 c8                	add    %ecx,%eax
  8008f7:	8a 40 04             	mov    0x4(%eax),%al
  8008fa:	84 c0                	test   %al,%al
  8008fc:	75 46                	jne    800944 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800903:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800909:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80090c:	89 d0                	mov    %edx,%eax
  80090e:	01 c0                	add    %eax,%eax
  800910:	01 d0                	add    %edx,%eax
  800912:	c1 e0 03             	shl    $0x3,%eax
  800915:	01 c8                	add    %ecx,%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80091c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80091f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800924:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800929:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	01 c8                	add    %ecx,%eax
  800935:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800937:	39 c2                	cmp    %eax,%edx
  800939:	75 09                	jne    800944 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80093b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800942:	eb 12                	jmp    800956 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800944:	ff 45 e8             	incl   -0x18(%ebp)
  800947:	a1 20 30 80 00       	mov    0x803020,%eax
  80094c:	8b 50 74             	mov    0x74(%eax),%edx
  80094f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800952:	39 c2                	cmp    %eax,%edx
  800954:	77 88                	ja     8008de <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800956:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80095a:	75 14                	jne    800970 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 d4 25 80 00       	push   $0x8025d4
  800964:	6a 3a                	push   $0x3a
  800966:	68 c8 25 80 00       	push   $0x8025c8
  80096b:	e8 93 fe ff ff       	call   800803 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800970:	ff 45 f0             	incl   -0x10(%ebp)
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800979:	0f 8c 32 ff ff ff    	jl     8008b1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80097f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800986:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80098d:	eb 26                	jmp    8009b5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80098f:	a1 20 30 80 00       	mov    0x803020,%eax
  800994:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80099a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	01 c0                	add    %eax,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	c1 e0 03             	shl    $0x3,%eax
  8009a6:	01 c8                	add    %ecx,%eax
  8009a8:	8a 40 04             	mov    0x4(%eax),%al
  8009ab:	3c 01                	cmp    $0x1,%al
  8009ad:	75 03                	jne    8009b2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8009af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009b2:	ff 45 e0             	incl   -0x20(%ebp)
  8009b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8009ba:	8b 50 74             	mov    0x74(%eax),%edx
  8009bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	77 cb                	ja     80098f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ca:	74 14                	je     8009e0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8009cc:	83 ec 04             	sub    $0x4,%esp
  8009cf:	68 28 26 80 00       	push   $0x802628
  8009d4:	6a 44                	push   $0x44
  8009d6:	68 c8 25 80 00       	push   $0x8025c8
  8009db:	e8 23 fe ff ff       	call   800803 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009e0:	90                   	nop
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	89 0a                	mov    %ecx,(%edx)
  8009f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f9:	88 d1                	mov    %dl,%cl
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fe:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a0c:	75 2c                	jne    800a3a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a0e:	a0 24 30 80 00       	mov    0x803024,%al
  800a13:	0f b6 c0             	movzbl %al,%eax
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	8b 12                	mov    (%edx),%edx
  800a1b:	89 d1                	mov    %edx,%ecx
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a20:	83 c2 08             	add    $0x8,%edx
  800a23:	83 ec 04             	sub    $0x4,%esp
  800a26:	50                   	push   %eax
  800a27:	51                   	push   %ecx
  800a28:	52                   	push   %edx
  800a29:	e8 3e 0e 00 00       	call   80186c <sys_cputs>
  800a2e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 40 04             	mov    0x4(%eax),%eax
  800a40:	8d 50 01             	lea    0x1(%eax),%edx
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a49:	90                   	nop
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a55:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a5c:	00 00 00 
	b.cnt = 0;
  800a5f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a66:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a75:	50                   	push   %eax
  800a76:	68 e3 09 80 00       	push   $0x8009e3
  800a7b:	e8 11 02 00 00       	call   800c91 <vprintfmt>
  800a80:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a83:	a0 24 30 80 00       	mov    0x803024,%al
  800a88:	0f b6 c0             	movzbl %al,%eax
  800a8b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	50                   	push   %eax
  800a95:	52                   	push   %edx
  800a96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a9c:	83 c0 08             	add    $0x8,%eax
  800a9f:	50                   	push   %eax
  800aa0:	e8 c7 0d 00 00       	call   80186c <sys_cputs>
  800aa5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800aa8:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800aaf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800abd:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ac4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	e8 73 ff ff ff       	call   800a4c <vcprintf>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aea:	e8 2b 0f 00 00       	call   801a1a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aef:	8d 45 0c             	lea    0xc(%ebp),%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 f4             	pushl  -0xc(%ebp)
  800afe:	50                   	push   %eax
  800aff:	e8 48 ff ff ff       	call   800a4c <vcprintf>
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b0a:	e8 25 0f 00 00       	call   801a34 <sys_enable_interrupt>
	return cnt;
  800b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	53                   	push   %ebx
  800b18:	83 ec 14             	sub    $0x14,%esp
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b27:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b32:	77 55                	ja     800b89 <printnum+0x75>
  800b34:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b37:	72 05                	jb     800b3e <printnum+0x2a>
  800b39:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3c:	77 4b                	ja     800b89 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b3e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b44:	8b 45 18             	mov    0x18(%ebp),%eax
  800b47:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4c:	52                   	push   %edx
  800b4d:	50                   	push   %eax
  800b4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b51:	ff 75 f0             	pushl  -0x10(%ebp)
  800b54:	e8 fb 13 00 00       	call   801f54 <__udivdi3>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	83 ec 04             	sub    $0x4,%esp
  800b5f:	ff 75 20             	pushl  0x20(%ebp)
  800b62:	53                   	push   %ebx
  800b63:	ff 75 18             	pushl  0x18(%ebp)
  800b66:	52                   	push   %edx
  800b67:	50                   	push   %eax
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 a1 ff ff ff       	call   800b14 <printnum>
  800b73:	83 c4 20             	add    $0x20,%esp
  800b76:	eb 1a                	jmp    800b92 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 20             	pushl  0x20(%ebp)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b89:	ff 4d 1c             	decl   0x1c(%ebp)
  800b8c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b90:	7f e6                	jg     800b78 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b92:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba0:	53                   	push   %ebx
  800ba1:	51                   	push   %ecx
  800ba2:	52                   	push   %edx
  800ba3:	50                   	push   %eax
  800ba4:	e8 bb 14 00 00       	call   802064 <__umoddi3>
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	05 94 28 80 00       	add    $0x802894,%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f be c0             	movsbl %al,%eax
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	ff 75 0c             	pushl  0xc(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	ff d0                	call   *%eax
  800bc2:	83 c4 10             	add    $0x10,%esp
}
  800bc5:	90                   	nop
  800bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bce:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd2:	7e 1c                	jle    800bf0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 50 08             	lea    0x8(%eax),%edx
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	89 10                	mov    %edx,(%eax)
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	8b 00                	mov    (%eax),%eax
  800be6:	83 e8 08             	sub    $0x8,%eax
  800be9:	8b 50 04             	mov    0x4(%eax),%edx
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	eb 40                	jmp    800c30 <getuint+0x65>
	else if (lflag)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 1e                	je     800c14 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8b 00                	mov    (%eax),%eax
  800bfb:	8d 50 04             	lea    0x4(%eax),%edx
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	89 10                	mov    %edx,(%eax)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 00                	mov    (%eax),%eax
  800c08:	83 e8 04             	sub    $0x4,%eax
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	eb 1c                	jmp    800c30 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	8d 50 04             	lea    0x4(%eax),%edx
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 10                	mov    %edx,(%eax)
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	83 e8 04             	sub    $0x4,%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c35:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c39:	7e 1c                	jle    800c57 <getint+0x25>
		return va_arg(*ap, long long);
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	8d 50 08             	lea    0x8(%eax),%edx
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 10                	mov    %edx,(%eax)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	83 e8 08             	sub    $0x8,%eax
  800c50:	8b 50 04             	mov    0x4(%eax),%edx
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	eb 38                	jmp    800c8f <getint+0x5d>
	else if (lflag)
  800c57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5b:	74 1a                	je     800c77 <getint+0x45>
		return va_arg(*ap, long);
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	8d 50 04             	lea    0x4(%eax),%edx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 10                	mov    %edx,(%eax)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	83 e8 04             	sub    $0x4,%eax
  800c72:	8b 00                	mov    (%eax),%eax
  800c74:	99                   	cltd   
  800c75:	eb 18                	jmp    800c8f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	8d 50 04             	lea    0x4(%eax),%edx
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 10                	mov    %edx,(%eax)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8b 00                	mov    (%eax),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	99                   	cltd   
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c99:	eb 17                	jmp    800cb2 <vprintfmt+0x21>
			if (ch == '\0')
  800c9b:	85 db                	test   %ebx,%ebx
  800c9d:	0f 84 af 03 00 00    	je     801052 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	53                   	push   %ebx
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	ff d0                	call   *%eax
  800caf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	8d 50 01             	lea    0x1(%eax),%edx
  800cb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 d8             	movzbl %al,%ebx
  800cc0:	83 fb 25             	cmp    $0x25,%ebx
  800cc3:	75 d6                	jne    800c9b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cc5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cc9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cd0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cd7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cde:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	8d 50 01             	lea    0x1(%eax),%edx
  800ceb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 d8             	movzbl %al,%ebx
  800cf3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cf6:	83 f8 55             	cmp    $0x55,%eax
  800cf9:	0f 87 2b 03 00 00    	ja     80102a <vprintfmt+0x399>
  800cff:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  800d06:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d08:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d0c:	eb d7                	jmp    800ce5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d0e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d12:	eb d1                	jmp    800ce5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d1e:	89 d0                	mov    %edx,%eax
  800d20:	c1 e0 02             	shl    $0x2,%eax
  800d23:	01 d0                	add    %edx,%eax
  800d25:	01 c0                	add    %eax,%eax
  800d27:	01 d8                	add    %ebx,%eax
  800d29:	83 e8 30             	sub    $0x30,%eax
  800d2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d37:	83 fb 2f             	cmp    $0x2f,%ebx
  800d3a:	7e 3e                	jle    800d7a <vprintfmt+0xe9>
  800d3c:	83 fb 39             	cmp    $0x39,%ebx
  800d3f:	7f 39                	jg     800d7a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d41:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d44:	eb d5                	jmp    800d1b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d46:	8b 45 14             	mov    0x14(%ebp),%eax
  800d49:	83 c0 04             	add    $0x4,%eax
  800d4c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d52:	83 e8 04             	sub    $0x4,%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d5a:	eb 1f                	jmp    800d7b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d60:	79 83                	jns    800ce5 <vprintfmt+0x54>
				width = 0;
  800d62:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d69:	e9 77 ff ff ff       	jmp    800ce5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d6e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d75:	e9 6b ff ff ff       	jmp    800ce5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d7a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7f:	0f 89 60 ff ff ff    	jns    800ce5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d8b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d92:	e9 4e ff ff ff       	jmp    800ce5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d97:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d9a:	e9 46 ff ff ff       	jmp    800ce5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800da2:	83 c0 04             	add    $0x4,%eax
  800da5:	89 45 14             	mov    %eax,0x14(%ebp)
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	83 e8 04             	sub    $0x4,%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	ff d0                	call   *%eax
  800dbc:	83 c4 10             	add    $0x10,%esp
			break;
  800dbf:	e9 89 02 00 00       	jmp    80104d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc7:	83 c0 04             	add    $0x4,%eax
  800dca:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	83 e8 04             	sub    $0x4,%eax
  800dd3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dd5:	85 db                	test   %ebx,%ebx
  800dd7:	79 02                	jns    800ddb <vprintfmt+0x14a>
				err = -err;
  800dd9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ddb:	83 fb 64             	cmp    $0x64,%ebx
  800dde:	7f 0b                	jg     800deb <vprintfmt+0x15a>
  800de0:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 19                	jne    800e04 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800deb:	53                   	push   %ebx
  800dec:	68 a5 28 80 00       	push   $0x8028a5
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	ff 75 08             	pushl  0x8(%ebp)
  800df7:	e8 5e 02 00 00       	call   80105a <printfmt>
  800dfc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dff:	e9 49 02 00 00       	jmp    80104d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e04:	56                   	push   %esi
  800e05:	68 ae 28 80 00       	push   $0x8028ae
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	ff 75 08             	pushl  0x8(%ebp)
  800e10:	e8 45 02 00 00       	call   80105a <printfmt>
  800e15:	83 c4 10             	add    $0x10,%esp
			break;
  800e18:	e9 30 02 00 00       	jmp    80104d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	83 c0 04             	add    $0x4,%eax
  800e23:	89 45 14             	mov    %eax,0x14(%ebp)
  800e26:	8b 45 14             	mov    0x14(%ebp),%eax
  800e29:	83 e8 04             	sub    $0x4,%eax
  800e2c:	8b 30                	mov    (%eax),%esi
  800e2e:	85 f6                	test   %esi,%esi
  800e30:	75 05                	jne    800e37 <vprintfmt+0x1a6>
				p = "(null)";
  800e32:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800e37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e3b:	7e 6d                	jle    800eaa <vprintfmt+0x219>
  800e3d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e41:	74 67                	je     800eaa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	50                   	push   %eax
  800e4a:	56                   	push   %esi
  800e4b:	e8 0c 03 00 00       	call   80115c <strnlen>
  800e50:	83 c4 10             	add    $0x10,%esp
  800e53:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e56:	eb 16                	jmp    800e6e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e58:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	50                   	push   %eax
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e72:	7f e4                	jg     800e58 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e74:	eb 34                	jmp    800eaa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e7a:	74 1c                	je     800e98 <vprintfmt+0x207>
  800e7c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e7f:	7e 05                	jle    800e86 <vprintfmt+0x1f5>
  800e81:	83 fb 7e             	cmp    $0x7e,%ebx
  800e84:	7e 12                	jle    800e98 <vprintfmt+0x207>
					putch('?', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 3f                	push   $0x3f
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
  800e96:	eb 0f                	jmp    800ea7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e98:	83 ec 08             	sub    $0x8,%esp
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	53                   	push   %ebx
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea7:	ff 4d e4             	decl   -0x1c(%ebp)
  800eaa:	89 f0                	mov    %esi,%eax
  800eac:	8d 70 01             	lea    0x1(%eax),%esi
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f be d8             	movsbl %al,%ebx
  800eb4:	85 db                	test   %ebx,%ebx
  800eb6:	74 24                	je     800edc <vprintfmt+0x24b>
  800eb8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ebc:	78 b8                	js     800e76 <vprintfmt+0x1e5>
  800ebe:	ff 4d e0             	decl   -0x20(%ebp)
  800ec1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec5:	79 af                	jns    800e76 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec7:	eb 13                	jmp    800edc <vprintfmt+0x24b>
				putch(' ', putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	6a 20                	push   $0x20
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	ff d0                	call   *%eax
  800ed6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed9:	ff 4d e4             	decl   -0x1c(%ebp)
  800edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee0:	7f e7                	jg     800ec9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ee2:	e9 66 01 00 00       	jmp    80104d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 e8             	pushl  -0x18(%ebp)
  800eed:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef0:	50                   	push   %eax
  800ef1:	e8 3c fd ff ff       	call   800c32 <getint>
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f05:	85 d2                	test   %edx,%edx
  800f07:	79 23                	jns    800f2c <vprintfmt+0x29b>
				putch('-', putdat);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	6a 2d                	push   $0x2d
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	ff d0                	call   *%eax
  800f16:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1f:	f7 d8                	neg    %eax
  800f21:	83 d2 00             	adc    $0x0,%edx
  800f24:	f7 da                	neg    %edx
  800f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f33:	e9 bc 00 00 00       	jmp    800ff4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f38:	83 ec 08             	sub    $0x8,%esp
  800f3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f41:	50                   	push   %eax
  800f42:	e8 84 fc ff ff       	call   800bcb <getuint>
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f50:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f57:	e9 98 00 00 00       	jmp    800ff4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	6a 58                	push   $0x58
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	ff d0                	call   *%eax
  800f69:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	6a 58                	push   $0x58
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	ff d0                	call   *%eax
  800f79:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 0c             	pushl  0xc(%ebp)
  800f82:	6a 58                	push   $0x58
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	ff d0                	call   *%eax
  800f89:	83 c4 10             	add    $0x10,%esp
			break;
  800f8c:	e9 bc 00 00 00       	jmp    80104d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	6a 30                	push   $0x30
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	ff d0                	call   *%eax
  800f9e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	6a 78                	push   $0x78
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	ff d0                	call   *%eax
  800fae:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb4:	83 c0 04             	add    $0x4,%eax
  800fb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fba:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbd:	83 e8 04             	sub    $0x4,%eax
  800fc0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fcc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fd3:	eb 1f                	jmp    800ff4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fde:	50                   	push   %eax
  800fdf:	e8 e7 fb ff ff       	call   800bcb <getuint>
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fed:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ff4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	52                   	push   %edx
  800fff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801002:	50                   	push   %eax
  801003:	ff 75 f4             	pushl  -0xc(%ebp)
  801006:	ff 75 f0             	pushl  -0x10(%ebp)
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	ff 75 08             	pushl  0x8(%ebp)
  80100f:	e8 00 fb ff ff       	call   800b14 <printnum>
  801014:	83 c4 20             	add    $0x20,%esp
			break;
  801017:	eb 34                	jmp    80104d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	53                   	push   %ebx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	ff d0                	call   *%eax
  801025:	83 c4 10             	add    $0x10,%esp
			break;
  801028:	eb 23                	jmp    80104d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	ff 75 0c             	pushl  0xc(%ebp)
  801030:	6a 25                	push   $0x25
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	ff d0                	call   *%eax
  801037:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80103a:	ff 4d 10             	decl   0x10(%ebp)
  80103d:	eb 03                	jmp    801042 <vprintfmt+0x3b1>
  80103f:	ff 4d 10             	decl   0x10(%ebp)
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	48                   	dec    %eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	3c 25                	cmp    $0x25,%al
  80104a:	75 f3                	jne    80103f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80104c:	90                   	nop
		}
	}
  80104d:	e9 47 fc ff ff       	jmp    800c99 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801052:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801053:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801060:	8d 45 10             	lea    0x10(%ebp),%eax
  801063:	83 c0 04             	add    $0x4,%eax
  801066:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	ff 75 f4             	pushl  -0xc(%ebp)
  80106f:	50                   	push   %eax
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 16 fc ff ff       	call   800c91 <vprintfmt>
  80107b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80107e:	90                   	nop
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8b 40 08             	mov    0x8(%eax),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 10                	mov    (%eax),%edx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8b 40 04             	mov    0x4(%eax),%eax
  80109e:	39 c2                	cmp    %eax,%edx
  8010a0:	73 12                	jae    8010b4 <sprintputch+0x33>
		*b->buf++ = ch;
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	89 0a                	mov    %ecx,(%edx)
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	88 10                	mov    %dl,(%eax)
}
  8010b4:	90                   	nop
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dc:	74 06                	je     8010e4 <vsnprintf+0x2d>
  8010de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e2:	7f 07                	jg     8010eb <vsnprintf+0x34>
		return -E_INVAL;
  8010e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e9:	eb 20                	jmp    80110b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010eb:	ff 75 14             	pushl  0x14(%ebp)
  8010ee:	ff 75 10             	pushl  0x10(%ebp)
  8010f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010f4:	50                   	push   %eax
  8010f5:	68 81 10 80 00       	push   $0x801081
  8010fa:	e8 92 fb ff ff       	call   800c91 <vprintfmt>
  8010ff:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801105:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801113:	8d 45 10             	lea    0x10(%ebp),%eax
  801116:	83 c0 04             	add    $0x4,%eax
  801119:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	ff 75 f4             	pushl  -0xc(%ebp)
  801122:	50                   	push   %eax
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 89 ff ff ff       	call   8010b7 <vsnprintf>
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801134:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80113f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801146:	eb 06                	jmp    80114e <strlen+0x15>
		n++;
  801148:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80114b:	ff 45 08             	incl   0x8(%ebp)
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	84 c0                	test   %al,%al
  801155:	75 f1                	jne    801148 <strlen+0xf>
		n++;
	return n;
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801169:	eb 09                	jmp    801174 <strnlen+0x18>
		n++;
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	ff 4d 0c             	decl   0xc(%ebp)
  801174:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801178:	74 09                	je     801183 <strnlen+0x27>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	84 c0                	test   %al,%al
  801181:	75 e8                	jne    80116b <strnlen+0xf>
		n++;
	return n;
  801183:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801194:	90                   	nop
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 08             	mov    %edx,0x8(%ebp)
  80119e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011a7:	8a 12                	mov    (%edx),%dl
  8011a9:	88 10                	mov    %dl,(%eax)
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 e4                	jne    801195 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c9:	eb 1f                	jmp    8011ea <strncpy+0x34>
		*dst++ = *src;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8d 50 01             	lea    0x1(%eax),%edx
  8011d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d7:	8a 12                	mov    (%edx),%dl
  8011d9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 03                	je     8011e7 <strncpy+0x31>
			src++;
  8011e4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011e7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011f0:	72 d9                	jb     8011cb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801203:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801207:	74 30                	je     801239 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801209:	eb 16                	jmp    801221 <strlcpy+0x2a>
			*dst++ = *src++;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 08             	mov    %edx,0x8(%ebp)
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	8d 4a 01             	lea    0x1(%edx),%ecx
  80121a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80121d:	8a 12                	mov    (%edx),%dl
  80121f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801221:	ff 4d 10             	decl   0x10(%ebp)
  801224:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801228:	74 09                	je     801233 <strlcpy+0x3c>
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	84 c0                	test   %al,%al
  801231:	75 d8                	jne    80120b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	29 c2                	sub    %eax,%edx
  801241:	89 d0                	mov    %edx,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801248:	eb 06                	jmp    801250 <strcmp+0xb>
		p++, q++;
  80124a:	ff 45 08             	incl   0x8(%ebp)
  80124d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	84 c0                	test   %al,%al
  801257:	74 0e                	je     801267 <strcmp+0x22>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 10                	mov    (%eax),%dl
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	38 c2                	cmp    %al,%dl
  801265:	74 e3                	je     80124a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f b6 d0             	movzbl %al,%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	0f b6 c0             	movzbl %al,%eax
  801277:	29 c2                	sub    %eax,%edx
  801279:	89 d0                	mov    %edx,%eax
}
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801280:	eb 09                	jmp    80128b <strncmp+0xe>
		n--, p++, q++;
  801282:	ff 4d 10             	decl   0x10(%ebp)
  801285:	ff 45 08             	incl   0x8(%ebp)
  801288:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	74 17                	je     8012a8 <strncmp+0x2b>
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	84 c0                	test   %al,%al
  801298:	74 0e                	je     8012a8 <strncmp+0x2b>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	38 c2                	cmp    %al,%dl
  8012a6:	74 da                	je     801282 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ac:	75 07                	jne    8012b5 <strncmp+0x38>
		return 0;
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	eb 14                	jmp    8012c9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f b6 d0             	movzbl %al,%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	0f b6 c0             	movzbl %al,%eax
  8012c5:	29 c2                	sub    %eax,%edx
  8012c7:	89 d0                	mov    %edx,%eax
}
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012d7:	eb 12                	jmp    8012eb <strchr+0x20>
		if (*s == c)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012e1:	75 05                	jne    8012e8 <strchr+0x1d>
			return (char *) s;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	eb 11                	jmp    8012f9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e8:	ff 45 08             	incl   0x8(%ebp)
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	84 c0                	test   %al,%al
  8012f2:	75 e5                	jne    8012d9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801307:	eb 0d                	jmp    801316 <strfind+0x1b>
		if (*s == c)
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801311:	74 0e                	je     801321 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801313:	ff 45 08             	incl   0x8(%ebp)
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	75 ea                	jne    801309 <strfind+0xe>
  80131f:	eb 01                	jmp    801322 <strfind+0x27>
		if (*s == c)
			break;
  801321:	90                   	nop
	return (char *) s;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801339:	eb 0e                	jmp    801349 <memset+0x22>
		*p++ = c;
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133e:	8d 50 01             	lea    0x1(%eax),%edx
  801341:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801344:	8b 55 0c             	mov    0xc(%ebp),%edx
  801347:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801349:	ff 4d f8             	decl   -0x8(%ebp)
  80134c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801350:	79 e9                	jns    80133b <memset+0x14>
		*p++ = c;

	return v;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801369:	eb 16                	jmp    801381 <memcpy+0x2a>
		*d++ = *s++;
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	8d 50 01             	lea    0x1(%eax),%edx
  801371:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801374:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801377:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80137d:	8a 12                	mov    (%edx),%dl
  80137f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801381:	8b 45 10             	mov    0x10(%ebp),%eax
  801384:	8d 50 ff             	lea    -0x1(%eax),%edx
  801387:	89 55 10             	mov    %edx,0x10(%ebp)
  80138a:	85 c0                	test   %eax,%eax
  80138c:	75 dd                	jne    80136b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ab:	73 50                	jae    8013fd <memmove+0x6a>
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013b8:	76 43                	jbe    8013fd <memmove+0x6a>
		s += n;
  8013ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013c6:	eb 10                	jmp    8013d8 <memmove+0x45>
			*--d = *--s;
  8013c8:	ff 4d f8             	decl   -0x8(%ebp)
  8013cb:	ff 4d fc             	decl   -0x4(%ebp)
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8a 10                	mov    (%eax),%dl
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013de:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	75 e3                	jne    8013c8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013e5:	eb 23                	jmp    80140a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ea:	8d 50 01             	lea    0x1(%eax),%edx
  8013ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013f9:	8a 12                	mov    (%edx),%dl
  8013fb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	8d 50 ff             	lea    -0x1(%eax),%edx
  801403:	89 55 10             	mov    %edx,0x10(%ebp)
  801406:	85 c0                	test   %eax,%eax
  801408:	75 dd                	jne    8013e7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801421:	eb 2a                	jmp    80144d <memcmp+0x3e>
		if (*s1 != *s2)
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801426:	8a 10                	mov    (%eax),%dl
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	38 c2                	cmp    %al,%dl
  80142f:	74 16                	je     801447 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	0f b6 d0             	movzbl %al,%edx
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f b6 c0             	movzbl %al,%eax
  801441:	29 c2                	sub    %eax,%edx
  801443:	89 d0                	mov    %edx,%eax
  801445:	eb 18                	jmp    80145f <memcmp+0x50>
		s1++, s2++;
  801447:	ff 45 fc             	incl   -0x4(%ebp)
  80144a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80144d:	8b 45 10             	mov    0x10(%ebp),%eax
  801450:	8d 50 ff             	lea    -0x1(%eax),%edx
  801453:	89 55 10             	mov    %edx,0x10(%ebp)
  801456:	85 c0                	test   %eax,%eax
  801458:	75 c9                	jne    801423 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801467:	8b 55 08             	mov    0x8(%ebp),%edx
  80146a:	8b 45 10             	mov    0x10(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801472:	eb 15                	jmp    801489 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	0f b6 d0             	movzbl %al,%edx
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	39 c2                	cmp    %eax,%edx
  801484:	74 0d                	je     801493 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80148f:	72 e3                	jb     801474 <memfind+0x13>
  801491:	eb 01                	jmp    801494 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801493:	90                   	nop
	return (void *) s;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80149f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ad:	eb 03                	jmp    8014b2 <strtol+0x19>
		s++;
  8014af:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	3c 20                	cmp    $0x20,%al
  8014b9:	74 f4                	je     8014af <strtol+0x16>
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	3c 09                	cmp    $0x9,%al
  8014c2:	74 eb                	je     8014af <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3c 2b                	cmp    $0x2b,%al
  8014cb:	75 05                	jne    8014d2 <strtol+0x39>
		s++;
  8014cd:	ff 45 08             	incl   0x8(%ebp)
  8014d0:	eb 13                	jmp    8014e5 <strtol+0x4c>
	else if (*s == '-')
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	3c 2d                	cmp    $0x2d,%al
  8014d9:	75 0a                	jne    8014e5 <strtol+0x4c>
		s++, neg = 1;
  8014db:	ff 45 08             	incl   0x8(%ebp)
  8014de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	74 06                	je     8014f1 <strtol+0x58>
  8014eb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014ef:	75 20                	jne    801511 <strtol+0x78>
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 30                	cmp    $0x30,%al
  8014f8:	75 17                	jne    801511 <strtol+0x78>
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	40                   	inc    %eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 78                	cmp    $0x78,%al
  801502:	75 0d                	jne    801511 <strtol+0x78>
		s += 2, base = 16;
  801504:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801508:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80150f:	eb 28                	jmp    801539 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801511:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801515:	75 15                	jne    80152c <strtol+0x93>
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	3c 30                	cmp    $0x30,%al
  80151e:	75 0c                	jne    80152c <strtol+0x93>
		s++, base = 8;
  801520:	ff 45 08             	incl   0x8(%ebp)
  801523:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80152a:	eb 0d                	jmp    801539 <strtol+0xa0>
	else if (base == 0)
  80152c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801530:	75 07                	jne    801539 <strtol+0xa0>
		base = 10;
  801532:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	3c 2f                	cmp    $0x2f,%al
  801540:	7e 19                	jle    80155b <strtol+0xc2>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	3c 39                	cmp    $0x39,%al
  801549:	7f 10                	jg     80155b <strtol+0xc2>
			dig = *s - '0';
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	0f be c0             	movsbl %al,%eax
  801553:	83 e8 30             	sub    $0x30,%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801559:	eb 42                	jmp    80159d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	3c 60                	cmp    $0x60,%al
  801562:	7e 19                	jle    80157d <strtol+0xe4>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	3c 7a                	cmp    $0x7a,%al
  80156b:	7f 10                	jg     80157d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	0f be c0             	movsbl %al,%eax
  801575:	83 e8 57             	sub    $0x57,%eax
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	eb 20                	jmp    80159d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	3c 40                	cmp    $0x40,%al
  801584:	7e 39                	jle    8015bf <strtol+0x126>
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8a 00                	mov    (%eax),%al
  80158b:	3c 5a                	cmp    $0x5a,%al
  80158d:	7f 30                	jg     8015bf <strtol+0x126>
			dig = *s - 'A' + 10;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f be c0             	movsbl %al,%eax
  801597:	83 e8 37             	sub    $0x37,%eax
  80159a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015a3:	7d 19                	jge    8015be <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
  8015a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ab:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015af:	89 c2                	mov    %eax,%edx
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b4:	01 d0                	add    %edx,%eax
  8015b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015b9:	e9 7b ff ff ff       	jmp    801539 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015be:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c3:	74 08                	je     8015cd <strtol+0x134>
		*endptr = (char *) s;
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d1:	74 07                	je     8015da <strtol+0x141>
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	f7 d8                	neg    %eax
  8015d8:	eb 03                	jmp    8015dd <strtol+0x144>
  8015da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <ltostr>:

void
ltostr(long value, char *str)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f7:	79 13                	jns    80160c <ltostr+0x2d>
	{
		neg = 1;
  8015f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801606:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801609:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801614:	99                   	cltd   
  801615:	f7 f9                	idiv   %ecx
  801617:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80161a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161d:	8d 50 01             	lea    0x1(%eax),%edx
  801620:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801623:	89 c2                	mov    %eax,%edx
  801625:	8b 45 0c             	mov    0xc(%ebp),%eax
  801628:	01 d0                	add    %edx,%eax
  80162a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80162d:	83 c2 30             	add    $0x30,%edx
  801630:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801632:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801635:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80163a:	f7 e9                	imul   %ecx
  80163c:	c1 fa 02             	sar    $0x2,%edx
  80163f:	89 c8                	mov    %ecx,%eax
  801641:	c1 f8 1f             	sar    $0x1f,%eax
  801644:	29 c2                	sub    %eax,%edx
  801646:	89 d0                	mov    %edx,%eax
  801648:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80164b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801653:	f7 e9                	imul   %ecx
  801655:	c1 fa 02             	sar    $0x2,%edx
  801658:	89 c8                	mov    %ecx,%eax
  80165a:	c1 f8 1f             	sar    $0x1f,%eax
  80165d:	29 c2                	sub    %eax,%edx
  80165f:	89 d0                	mov    %edx,%eax
  801661:	c1 e0 02             	shl    $0x2,%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	01 c0                	add    %eax,%eax
  801668:	29 c1                	sub    %eax,%ecx
  80166a:	89 ca                	mov    %ecx,%edx
  80166c:	85 d2                	test   %edx,%edx
  80166e:	75 9c                	jne    80160c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801677:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167a:	48                   	dec    %eax
  80167b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80167e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801682:	74 3d                	je     8016c1 <ltostr+0xe2>
		start = 1 ;
  801684:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80168b:	eb 34                	jmp    8016c1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80168d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801690:	8b 45 0c             	mov    0xc(%ebp),%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80169a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a8:	01 c8                	add    %ecx,%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b4:	01 c2                	add    %eax,%edx
  8016b6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016b9:	88 02                	mov    %al,(%edx)
		start++ ;
  8016bb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016be:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c7:	7c c4                	jl     80168d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016d4:	90                   	nop
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 54 fa ff ff       	call   801139 <strlen>
  8016e5:	83 c4 04             	add    $0x4,%esp
  8016e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	e8 46 fa ff ff       	call   801139 <strlen>
  8016f3:	83 c4 04             	add    $0x4,%esp
  8016f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801700:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801707:	eb 17                	jmp    801720 <strcconcat+0x49>
		final[s] = str1[s] ;
  801709:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	01 c2                	add    %eax,%edx
  801711:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	01 c8                	add    %ecx,%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80171d:	ff 45 fc             	incl   -0x4(%ebp)
  801720:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801723:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801726:	7c e1                	jl     801709 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801728:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80172f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801736:	eb 1f                	jmp    801757 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173b:	8d 50 01             	lea    0x1(%eax),%edx
  80173e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801741:	89 c2                	mov    %eax,%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	01 c8                	add    %ecx,%eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801754:	ff 45 f8             	incl   -0x8(%ebp)
  801757:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80175d:	7c d9                	jl     801738 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80175f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801762:	8b 45 10             	mov    0x10(%ebp),%eax
  801765:	01 d0                	add    %edx,%eax
  801767:	c6 00 00             	movb   $0x0,(%eax)
}
  80176a:	90                   	nop
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801770:	8b 45 14             	mov    0x14(%ebp),%eax
  801773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801790:	eb 0c                	jmp    80179e <strsplit+0x31>
			*string++ = 0;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8d 50 01             	lea    0x1(%eax),%edx
  801798:	89 55 08             	mov    %edx,0x8(%ebp)
  80179b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	84 c0                	test   %al,%al
  8017a5:	74 18                	je     8017bf <strsplit+0x52>
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	0f be c0             	movsbl %al,%eax
  8017af:	50                   	push   %eax
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	e8 13 fb ff ff       	call   8012cb <strchr>
  8017b8:	83 c4 08             	add    $0x8,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	75 d3                	jne    801792 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	84 c0                	test   %al,%al
  8017c6:	74 5a                	je     801822 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cb:	8b 00                	mov    (%eax),%eax
  8017cd:	83 f8 0f             	cmp    $0xf,%eax
  8017d0:	75 07                	jne    8017d9 <strsplit+0x6c>
		{
			return 0;
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d7:	eb 66                	jmp    80183f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017dc:	8b 00                	mov    (%eax),%eax
  8017de:	8d 48 01             	lea    0x1(%eax),%ecx
  8017e1:	8b 55 14             	mov    0x14(%ebp),%edx
  8017e4:	89 0a                	mov    %ecx,(%edx)
  8017e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f0:	01 c2                	add    %eax,%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017f7:	eb 03                	jmp    8017fc <strsplit+0x8f>
			string++;
  8017f9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	84 c0                	test   %al,%al
  801803:	74 8b                	je     801790 <strsplit+0x23>
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8a 00                	mov    (%eax),%al
  80180a:	0f be c0             	movsbl %al,%eax
  80180d:	50                   	push   %eax
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	e8 b5 fa ff ff       	call   8012cb <strchr>
  801816:	83 c4 08             	add    $0x8,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	74 dc                	je     8017f9 <strsplit+0x8c>
			string++;
	}
  80181d:	e9 6e ff ff ff       	jmp    801790 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801822:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801823:	8b 45 14             	mov    0x14(%ebp),%eax
  801826:	8b 00                	mov    (%eax),%eax
  801828:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	01 d0                	add    %edx,%eax
  801834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80183a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	57                   	push   %edi
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801853:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801856:	8b 7d 18             	mov    0x18(%ebp),%edi
  801859:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80185c:	cd 30                	int    $0x30
  80185e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	8b 45 10             	mov    0x10(%ebp),%eax
  801875:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801878:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	52                   	push   %edx
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	6a 00                	push   $0x0
  80188a:	e8 b2 ff ff ff       	call   801841 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_cgetc>:

int
sys_cgetc(void)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 01                	push   $0x1
  8018a4:	e8 98 ff ff ff       	call   801841 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 05                	push   $0x5
  8018c1:	e8 7b ff ff ff       	call   801841 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	51                   	push   %ecx
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 06                	push   $0x6
  8018e6:	e8 56 ff ff ff       	call   801841 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	52                   	push   %edx
  801905:	50                   	push   %eax
  801906:	6a 07                	push   $0x7
  801908:	e8 34 ff ff ff       	call   801841 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 08                	push   $0x8
  801923:	e8 19 ff ff ff       	call   801841 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 09                	push   $0x9
  80193c:	e8 00 ff ff ff       	call   801841 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 0a                	push   $0xa
  801955:	e8 e7 fe ff ff       	call   801841 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 0b                	push   $0xb
  80196e:	e8 ce fe ff ff       	call   801841 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	ff 75 08             	pushl  0x8(%ebp)
  801987:	6a 0f                	push   $0xf
  801989:	e8 b3 fe ff ff       	call   801841 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	6a 10                	push   $0x10
  8019a5:	e8 97 fe ff ff       	call   801841 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ad:	90                   	nop
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 10             	pushl  0x10(%ebp)
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	6a 11                	push   $0x11
  8019c2:	e8 7a fe ff ff       	call   801841 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ca:	90                   	nop
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 0c                	push   $0xc
  8019dc:	e8 60 fe ff ff       	call   801841 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 0d                	push   $0xd
  8019f6:	e8 46 fe ff ff       	call   801841 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 0e                	push   $0xe
  801a0f:	e8 2d fe ff ff       	call   801841 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	90                   	nop
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 13                	push   $0x13
  801a29:	e8 13 fe ff ff       	call   801841 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	90                   	nop
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 14                	push   $0x14
  801a43:	e8 f9 fd ff ff       	call   801841 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	90                   	nop
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	50                   	push   %eax
  801a67:	6a 15                	push   $0x15
  801a69:	e8 d3 fd ff ff       	call   801841 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 16                	push   $0x16
  801a83:	e8 b9 fd ff ff       	call   801841 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	50                   	push   %eax
  801a9e:	6a 17                	push   $0x17
  801aa0:	e8 9c fd ff ff       	call   801841 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	52                   	push   %edx
  801aba:	50                   	push   %eax
  801abb:	6a 1a                	push   $0x1a
  801abd:	e8 7f fd ff ff       	call   801841 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 18                	push   $0x18
  801ada:	e8 62 fd ff ff       	call   801841 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 19                	push   $0x19
  801af8:	e8 44 fd ff ff       	call   801841 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b0f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b12:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	51                   	push   %ecx
  801b1c:	52                   	push   %edx
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	50                   	push   %eax
  801b21:	6a 1b                	push   $0x1b
  801b23:	e8 19 fd ff ff       	call   801841 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 1c                	push   $0x1c
  801b40:	e8 fc fc ff ff       	call   801841 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	51                   	push   %ecx
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 1d                	push   $0x1d
  801b5f:	e8 dd fc ff ff       	call   801841 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	52                   	push   %edx
  801b79:	50                   	push   %eax
  801b7a:	6a 1e                	push   $0x1e
  801b7c:	e8 c0 fc ff ff       	call   801841 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 1f                	push   $0x1f
  801b95:	e8 a7 fc ff ff       	call   801841 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	ff 75 14             	pushl  0x14(%ebp)
  801baa:	ff 75 10             	pushl  0x10(%ebp)
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	50                   	push   %eax
  801bb1:	6a 20                	push   $0x20
  801bb3:	e8 89 fc ff ff       	call   801841 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	50                   	push   %eax
  801bcc:	6a 21                	push   $0x21
  801bce:	e8 6e fc ff ff       	call   801841 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	50                   	push   %eax
  801be8:	6a 22                	push   $0x22
  801bea:	e8 52 fc ff ff       	call   801841 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 02                	push   $0x2
  801c03:	e8 39 fc ff ff       	call   801841 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 03                	push   $0x3
  801c1c:	e8 20 fc ff ff       	call   801841 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 04                	push   $0x4
  801c35:	e8 07 fc ff ff       	call   801841 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_exit_env>:


void sys_exit_env(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 23                	push   $0x23
  801c4e:	e8 ee fb ff ff       	call   801841 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	90                   	nop
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c62:	8d 50 04             	lea    0x4(%eax),%edx
  801c65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 24                	push   $0x24
  801c72:	e8 ca fb ff ff       	call   801841 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return result;
  801c7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c83:	89 01                	mov    %eax,(%ecx)
  801c85:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	c9                   	leave  
  801c8c:	c2 04 00             	ret    $0x4

00801c8f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 10             	pushl  0x10(%ebp)
  801c99:	ff 75 0c             	pushl  0xc(%ebp)
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	6a 12                	push   $0x12
  801ca1:	e8 9b fb ff ff       	call   801841 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_rcr2>:
uint32 sys_rcr2()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 25                	push   $0x25
  801cbb:	e8 81 fb ff ff       	call   801841 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	50                   	push   %eax
  801cde:	6a 26                	push   $0x26
  801ce0:	e8 5c fb ff ff       	call   801841 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce8:	90                   	nop
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <rsttst>:
void rsttst()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 28                	push   $0x28
  801cfa:	e8 42 fb ff ff       	call   801841 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
	return ;
  801d02:	90                   	nop
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d11:	8b 55 18             	mov    0x18(%ebp),%edx
  801d14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d18:	52                   	push   %edx
  801d19:	50                   	push   %eax
  801d1a:	ff 75 10             	pushl  0x10(%ebp)
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	6a 27                	push   $0x27
  801d25:	e8 17 fb ff ff       	call   801841 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2d:	90                   	nop
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <chktst>:
void chktst(uint32 n)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 08             	pushl  0x8(%ebp)
  801d3e:	6a 29                	push   $0x29
  801d40:	e8 fc fa ff ff       	call   801841 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
	return ;
  801d48:	90                   	nop
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <inctst>:

void inctst()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 2a                	push   $0x2a
  801d5a:	e8 e2 fa ff ff       	call   801841 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <gettst>:
uint32 gettst()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 2b                	push   $0x2b
  801d74:	e8 c8 fa ff ff       	call   801841 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 2c                	push   $0x2c
  801d90:	e8 ac fa ff ff       	call   801841 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d9b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9f:	75 07                	jne    801da8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da1:	b8 01 00 00 00       	mov    $0x1,%eax
  801da6:	eb 05                	jmp    801dad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 2c                	push   $0x2c
  801dc1:	e8 7b fa ff ff       	call   801841 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
  801dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dcc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd0:	75 07                	jne    801dd9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	eb 05                	jmp    801dde <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 2c                	push   $0x2c
  801df2:	e8 4a fa ff ff       	call   801841 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
  801dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dfd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e01:	75 07                	jne    801e0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e03:	b8 01 00 00 00       	mov    $0x1,%eax
  801e08:	eb 05                	jmp    801e0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 2c                	push   $0x2c
  801e23:	e8 19 fa ff ff       	call   801841 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
  801e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e32:	75 07                	jne    801e3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e34:	b8 01 00 00 00       	mov    $0x1,%eax
  801e39:	eb 05                	jmp    801e40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	6a 2d                	push   $0x2d
  801e52:	e8 ea f9 ff ff       	call   801841 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5a:	90                   	nop
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	6a 00                	push   $0x0
  801e6f:	53                   	push   %ebx
  801e70:	51                   	push   %ecx
  801e71:	52                   	push   %edx
  801e72:	50                   	push   %eax
  801e73:	6a 2e                	push   $0x2e
  801e75:	e8 c7 f9 ff ff       	call   801841 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 2f                	push   $0x2f
  801e95:	e8 a7 f9 ff ff       	call   801841 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	c1 e0 02             	shl    $0x2,%eax
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eb6:	01 d0                	add    %edx,%eax
  801eb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ebf:	01 d0                	add    %edx,%eax
  801ec1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	c1 e0 04             	shl    $0x4,%eax
  801ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ed0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801ed7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	50                   	push   %eax
  801ede:	e8 76 fd ff ff       	call   801c59 <sys_get_virtual_time>
  801ee3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801ee6:	eb 41                	jmp    801f29 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ee8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	50                   	push   %eax
  801eef:	e8 65 fd ff ff       	call   801c59 <sys_get_virtual_time>
  801ef4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801efd:	29 c2                	sub    %eax,%edx
  801eff:	89 d0                	mov    %edx,%eax
  801f01:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	89 d1                	mov    %edx,%ecx
  801f0c:	29 c1                	sub    %eax,%ecx
  801f0e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f14:	39 c2                	cmp    %eax,%edx
  801f16:	0f 97 c0             	seta   %al
  801f19:	0f b6 c0             	movzbl %al,%eax
  801f1c:	29 c1                	sub    %eax,%ecx
  801f1e:	89 c8                	mov    %ecx,%eax
  801f20:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f2f:	72 b7                	jb     801ee8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f41:	eb 03                	jmp    801f46 <busy_wait+0x12>
  801f43:	ff 45 fc             	incl   -0x4(%ebp)
  801f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f49:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f4c:	72 f5                	jb     801f43 <busy_wait+0xf>
	return i;
  801f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    
  801f53:	90                   	nop

00801f54 <__udivdi3>:
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f6b:	89 ca                	mov    %ecx,%edx
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f73:	85 f6                	test   %esi,%esi
  801f75:	75 2d                	jne    801fa4 <__udivdi3+0x50>
  801f77:	39 cf                	cmp    %ecx,%edi
  801f79:	77 65                	ja     801fe0 <__udivdi3+0x8c>
  801f7b:	89 fd                	mov    %edi,%ebp
  801f7d:	85 ff                	test   %edi,%edi
  801f7f:	75 0b                	jne    801f8c <__udivdi3+0x38>
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
  801f86:	31 d2                	xor    %edx,%edx
  801f88:	f7 f7                	div    %edi
  801f8a:	89 c5                	mov    %eax,%ebp
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	89 c8                	mov    %ecx,%eax
  801f90:	f7 f5                	div    %ebp
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	f7 f5                	div    %ebp
  801f98:	89 cf                	mov    %ecx,%edi
  801f9a:	89 fa                	mov    %edi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	39 ce                	cmp    %ecx,%esi
  801fa6:	77 28                	ja     801fd0 <__udivdi3+0x7c>
  801fa8:	0f bd fe             	bsr    %esi,%edi
  801fab:	83 f7 1f             	xor    $0x1f,%edi
  801fae:	75 40                	jne    801ff0 <__udivdi3+0x9c>
  801fb0:	39 ce                	cmp    %ecx,%esi
  801fb2:	72 0a                	jb     801fbe <__udivdi3+0x6a>
  801fb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fb8:	0f 87 9e 00 00 00    	ja     80205c <__udivdi3+0x108>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	89 fa                	mov    %edi,%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	31 c0                	xor    %eax,%eax
  801fd4:	89 fa                	mov    %edi,%edx
  801fd6:	83 c4 1c             	add    $0x1c,%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5f                   	pop    %edi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	f7 f7                	div    %edi
  801fe4:	31 ff                	xor    %edi,%edi
  801fe6:	89 fa                	mov    %edi,%edx
  801fe8:	83 c4 1c             	add    $0x1c,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
  801ff0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ff5:	89 eb                	mov    %ebp,%ebx
  801ff7:	29 fb                	sub    %edi,%ebx
  801ff9:	89 f9                	mov    %edi,%ecx
  801ffb:	d3 e6                	shl    %cl,%esi
  801ffd:	89 c5                	mov    %eax,%ebp
  801fff:	88 d9                	mov    %bl,%cl
  802001:	d3 ed                	shr    %cl,%ebp
  802003:	89 e9                	mov    %ebp,%ecx
  802005:	09 f1                	or     %esi,%ecx
  802007:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e0                	shl    %cl,%eax
  80200f:	89 c5                	mov    %eax,%ebp
  802011:	89 d6                	mov    %edx,%esi
  802013:	88 d9                	mov    %bl,%cl
  802015:	d3 ee                	shr    %cl,%esi
  802017:	89 f9                	mov    %edi,%ecx
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80201f:	88 d9                	mov    %bl,%cl
  802021:	d3 e8                	shr    %cl,%eax
  802023:	09 c2                	or     %eax,%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	89 f2                	mov    %esi,%edx
  802029:	f7 74 24 0c          	divl   0xc(%esp)
  80202d:	89 d6                	mov    %edx,%esi
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	f7 e5                	mul    %ebp
  802033:	39 d6                	cmp    %edx,%esi
  802035:	72 19                	jb     802050 <__udivdi3+0xfc>
  802037:	74 0b                	je     802044 <__udivdi3+0xf0>
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	31 ff                	xor    %edi,%edi
  80203d:	e9 58 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802042:	66 90                	xchg   %ax,%ax
  802044:	8b 54 24 08          	mov    0x8(%esp),%edx
  802048:	89 f9                	mov    %edi,%ecx
  80204a:	d3 e2                	shl    %cl,%edx
  80204c:	39 c2                	cmp    %eax,%edx
  80204e:	73 e9                	jae    802039 <__udivdi3+0xe5>
  802050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802053:	31 ff                	xor    %edi,%edi
  802055:	e9 40 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	31 c0                	xor    %eax,%eax
  80205e:	e9 37 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802063:	90                   	nop

00802064 <__umoddi3>:
  802064:	55                   	push   %ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80206f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802083:	89 f3                	mov    %esi,%ebx
  802085:	89 fa                	mov    %edi,%edx
  802087:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80208b:	89 34 24             	mov    %esi,(%esp)
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 1a                	jne    8020ac <__umoddi3+0x48>
  802092:	39 f7                	cmp    %esi,%edi
  802094:	0f 86 a2 00 00 00    	jbe    80213c <__umoddi3+0xd8>
  80209a:	89 c8                	mov    %ecx,%eax
  80209c:	89 f2                	mov    %esi,%edx
  80209e:	f7 f7                	div    %edi
  8020a0:	89 d0                	mov    %edx,%eax
  8020a2:	31 d2                	xor    %edx,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	39 f0                	cmp    %esi,%eax
  8020ae:	0f 87 ac 00 00 00    	ja     802160 <__umoddi3+0xfc>
  8020b4:	0f bd e8             	bsr    %eax,%ebp
  8020b7:	83 f5 1f             	xor    $0x1f,%ebp
  8020ba:	0f 84 ac 00 00 00    	je     80216c <__umoddi3+0x108>
  8020c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020c5:	29 ef                	sub    %ebp,%edi
  8020c7:	89 fe                	mov    %edi,%esi
  8020c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020cd:	89 e9                	mov    %ebp,%ecx
  8020cf:	d3 e0                	shl    %cl,%eax
  8020d1:	89 d7                	mov    %edx,%edi
  8020d3:	89 f1                	mov    %esi,%ecx
  8020d5:	d3 ef                	shr    %cl,%edi
  8020d7:	09 c7                	or     %eax,%edi
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	d3 e2                	shl    %cl,%edx
  8020dd:	89 14 24             	mov    %edx,(%esp)
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	d3 e0                	shl    %cl,%eax
  8020e4:	89 c2                	mov    %eax,%edx
  8020e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ea:	d3 e0                	shl    %cl,%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f4:	89 f1                	mov    %esi,%ecx
  8020f6:	d3 e8                	shr    %cl,%eax
  8020f8:	09 d0                	or     %edx,%eax
  8020fa:	d3 eb                	shr    %cl,%ebx
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	f7 f7                	div    %edi
  802100:	89 d3                	mov    %edx,%ebx
  802102:	f7 24 24             	mull   (%esp)
  802105:	89 c6                	mov    %eax,%esi
  802107:	89 d1                	mov    %edx,%ecx
  802109:	39 d3                	cmp    %edx,%ebx
  80210b:	0f 82 87 00 00 00    	jb     802198 <__umoddi3+0x134>
  802111:	0f 84 91 00 00 00    	je     8021a8 <__umoddi3+0x144>
  802117:	8b 54 24 04          	mov    0x4(%esp),%edx
  80211b:	29 f2                	sub    %esi,%edx
  80211d:	19 cb                	sbb    %ecx,%ebx
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802125:	d3 e0                	shl    %cl,%eax
  802127:	89 e9                	mov    %ebp,%ecx
  802129:	d3 ea                	shr    %cl,%edx
  80212b:	09 d0                	or     %edx,%eax
  80212d:	89 e9                	mov    %ebp,%ecx
  80212f:	d3 eb                	shr    %cl,%ebx
  802131:	89 da                	mov    %ebx,%edx
  802133:	83 c4 1c             	add    $0x1c,%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5f                   	pop    %edi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    
  80213b:	90                   	nop
  80213c:	89 fd                	mov    %edi,%ebp
  80213e:	85 ff                	test   %edi,%edi
  802140:	75 0b                	jne    80214d <__umoddi3+0xe9>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	31 d2                	xor    %edx,%edx
  802149:	f7 f7                	div    %edi
  80214b:	89 c5                	mov    %eax,%ebp
  80214d:	89 f0                	mov    %esi,%eax
  80214f:	31 d2                	xor    %edx,%edx
  802151:	f7 f5                	div    %ebp
  802153:	89 c8                	mov    %ecx,%eax
  802155:	f7 f5                	div    %ebp
  802157:	89 d0                	mov    %edx,%eax
  802159:	e9 44 ff ff ff       	jmp    8020a2 <__umoddi3+0x3e>
  80215e:	66 90                	xchg   %ax,%ax
  802160:	89 c8                	mov    %ecx,%eax
  802162:	89 f2                	mov    %esi,%edx
  802164:	83 c4 1c             	add    $0x1c,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	3b 04 24             	cmp    (%esp),%eax
  80216f:	72 06                	jb     802177 <__umoddi3+0x113>
  802171:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802175:	77 0f                	ja     802186 <__umoddi3+0x122>
  802177:	89 f2                	mov    %esi,%edx
  802179:	29 f9                	sub    %edi,%ecx
  80217b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80217f:	89 14 24             	mov    %edx,(%esp)
  802182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802186:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218a:	8b 14 24             	mov    (%esp),%edx
  80218d:	83 c4 1c             	add    $0x1c,%esp
  802190:	5b                   	pop    %ebx
  802191:	5e                   	pop    %esi
  802192:	5f                   	pop    %edi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
  802195:	8d 76 00             	lea    0x0(%esi),%esi
  802198:	2b 04 24             	sub    (%esp),%eax
  80219b:	19 fa                	sbb    %edi,%edx
  80219d:	89 d1                	mov    %edx,%ecx
  80219f:	89 c6                	mov    %eax,%esi
  8021a1:	e9 71 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021ac:	72 ea                	jb     802198 <__umoddi3+0x134>
  8021ae:	89 d9                	mov    %ebx,%ecx
  8021b0:	e9 62 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
