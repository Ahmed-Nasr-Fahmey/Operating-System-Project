
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 1d 14 00 00       	call   801453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 7c 25 00 00       	call   8025fa <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 e0 2f 80 00       	push   $0x802fe0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 21 30 80 00       	push   $0x803021
  8000af:	e8 ee 14 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 e0 2f 80 00       	push   $0x802fe0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 21 30 80 00       	push   $0x803021
  8000e5:	e8 b8 14 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ef:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 e0 2f 80 00       	push   $0x802fe0
  800114:	6a 22                	push   $0x22
  800116:	68 21 30 80 00       	push   $0x803021
  80011b:	e8 82 14 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 40 80 00       	mov    0x804020,%eax
  800125:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 e0 2f 80 00       	push   $0x802fe0
  80014a:	6a 23                	push   $0x23
  80014c:	68 21 30 80 00       	push   $0x803021
  800151:	e8 4c 14 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 40 80 00       	mov    0x804020,%eax
  80015b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 e0 2f 80 00       	push   $0x802fe0
  800180:	6a 24                	push   $0x24
  800182:	68 21 30 80 00       	push   $0x803021
  800187:	e8 16 14 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 40 80 00       	mov    0x804020,%eax
  800191:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e0 2f 80 00       	push   $0x802fe0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 21 30 80 00       	push   $0x803021
  8001bd:	e8 e0 13 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 e0 2f 80 00       	push   $0x802fe0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 21 30 80 00       	push   $0x803021
  8001f5:	e8 a8 13 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ff:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 e0 2f 80 00       	push   $0x802fe0
  800226:	6a 27                	push   $0x27
  800228:	68 21 30 80 00       	push   $0x803021
  80022d:	e8 70 13 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 40 80 00       	mov    0x804020,%eax
  800237:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 e0 2f 80 00       	push   $0x802fe0
  80025e:	6a 28                	push   $0x28
  800260:	68 21 30 80 00       	push   $0x803021
  800265:	e8 38 13 00 00       	call   8015a2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 e0 2f 80 00       	push   $0x802fe0
  800296:	6a 29                	push   $0x29
  800298:	68 21 30 80 00       	push   $0x803021
  80029d:	e8 00 13 00 00       	call   8015a2 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 34 30 80 00       	push   $0x803034
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 21 30 80 00       	push   $0x803021
  8002c0:	e8 dd 12 00 00       	call   8015a2 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 3f 25 00 00       	call   802809 <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 c3 25 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 00 23 00 00       	call   8025fa <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 7c 30 80 00       	push   $0x80307c
  800322:	6a 39                	push   $0x39
  800324:	68 21 30 80 00       	push   $0x803021
  800329:	e8 74 12 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 76 25 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 e4 30 80 00       	push   $0x8030e4
  800345:	6a 3a                	push   $0x3a
  800347:	68 21 30 80 00       	push   $0x803021
  80034c:	e8 51 12 00 00       	call   8015a2 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 53 25 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 8c 22 00 00       	call   8025fa <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 7c 30 80 00       	push   $0x80307c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 21 30 80 00       	push   $0x803021
  8003b2:	e8 eb 11 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 ed 24 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 e4 30 80 00       	push   $0x8030e4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 21 30 80 00       	push   $0x803021
  8003e9:	e8 b4 11 00 00       	call   8015a2 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 b6 24 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 f2 21 00 00       	call   8025fa <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 7c 30 80 00       	push   $0x80307c
  80044f:	6a 47                	push   $0x47
  800451:	68 21 30 80 00       	push   $0x803021
  800456:	e8 47 11 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 49 24 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 e4 30 80 00       	push   $0x8030e4
  800483:	6a 48                	push   $0x48
  800485:	68 21 30 80 00       	push   $0x803021
  80048a:	e8 13 11 00 00       	call   8015a2 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 15 24 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 4a 21 00 00       	call   8025fa <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 7c 30 80 00       	push   $0x80307c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 21 30 80 00       	push   $0x803021
  800506:	e8 97 10 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 99 23 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 e4 30 80 00       	push   $0x8030e4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 21 30 80 00       	push   $0x803021
  800541:	e8 5c 10 00 00       	call   8015a2 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 be 22 00 00       	call   802809 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 cf 22 00 00       	call   802822 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 f5 21 00 00       	call   802809 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 07 22 00 00       	call   802822 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 14 31 80 00       	push   $0x803114
  80062e:	6a 67                	push   $0x67
  800630:	68 21 30 80 00       	push   $0x803021
  800635:	e8 68 0f 00 00       	call   8015a2 <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 78                	jmp    8006c2 <_main+0x68a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b5:	8b 50 74             	mov    0x74(%eax),%edx
  8006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	77 94                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c6:	7e 82                	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006c8:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006cc:	74 14                	je     8006e2 <_main+0x6aa>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 58 31 80 00       	push   $0x803158
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 21 30 80 00       	push   $0x803021
  8006dd:	e8 c0 0e 00 00       	call   8015a2 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 22 21 00 00       	call   802809 <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 33 21 00 00       	call   802822 <sys_calculate_modified_frames>
  8006ef:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	c1 e0 03             	shl    $0x3,%eax
  8006f8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8006fb:	d1 e8                	shr    %eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  800704:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	c1 ea 1f             	shr    $0x1f,%edx
  80070f:	01 d0                	add    %edx,%eax
  800711:	d1 f8                	sar    %eax
  800713:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800719:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800728:	f7 e9                	imul   %ecx
  80072a:	c1 f9 1f             	sar    $0x1f,%ecx
  80072d:	89 d0                	mov    %edx,%eax
  80072f:	29 c8                	sub    %ecx,%eax
  800731:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  800737:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	01 d2                	add    %edx,%edx
  800741:	01 d0                	add    %edx,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	79 03                	jns    80074a <_main+0x712>
  800747:	83 c0 03             	add    $0x3,%eax
  80074a:	c1 f8 02             	sar    $0x2,%eax
  80074d:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  800753:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800759:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  80075f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be c0             	movsbl %al,%eax
  800774:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  800777:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  80077d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  800783:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800791:	eb 20                	jmp    8007b3 <_main+0x77b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007a7:	01 d0                	add    %edx,%eax
  8007a9:	66 8b 00             	mov    (%eax),%ax
  8007ac:	98                   	cwtl   
  8007ad:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007b7:	7e da                	jle    800793 <_main+0x75b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007b9:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c0:	eb 20                	jmp    8007e2 <_main+0x7aa>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c5:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007d6:	01 c2                	add    %eax,%edx
  8007d8:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007dc:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007df:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007e6:	7e da                	jle    8007c2 <_main+0x78a>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007e8:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007eb:	e8 19 20 00 00       	call   802809 <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 14 31 80 00       	push   $0x803114
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 21 30 80 00       	push   $0x803021
  80080b:	e8 92 0d 00 00       	call   8015a2 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 0a 20 00 00       	call   802822 <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 14 31 80 00       	push   $0x803114
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 21 30 80 00       	push   $0x803021
  800833:	e8 6a 0d 00 00       	call   8015a2 <_panic>
		found = 0;
  800838:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  80083f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800846:	eb 7a                	jmp    8008c2 <_main+0x88a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800848:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80084f:	eb 5f                	jmp    8008b0 <_main+0x878>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800851:	a1 20 40 80 00       	mov    0x804020,%eax
  800856:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d0                	add    %edx,%eax
  800865:	c1 e0 03             	shl    $0x3,%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800872:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80089b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	75 03                	jne    8008ad <_main+0x875>
				{
					found++;
  8008aa:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 92                	ja     800851 <_main+0x819>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c6:	7e 80                	jle    800848 <_main+0x810>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008c8:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 58 31 80 00       	push   $0x803158
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 21 30 80 00       	push   $0x803021
  8008e0:	e8 bd 0c 00 00       	call   8015a2 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 1f 1f 00 00       	call   802809 <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 30 1f 00 00       	call   802822 <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 af 1f 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 2f 1d 00 00       	call   80263b <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 95 1f 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800914:	8b 55 90             	mov    -0x70(%ebp),%edx
  800917:	89 d1                	mov    %edx,%ecx
  800919:	29 c1                	sub    %eax,%ecx
  80091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	01 d2                	add    %edx,%edx
  800922:	01 d0                	add    %edx,%eax
  800924:	85 c0                	test   %eax,%eax
  800926:	79 05                	jns    80092d <_main+0x8f5>
  800928:	05 ff 0f 00 00       	add    $0xfff,%eax
  80092d:	c1 f8 0c             	sar    $0xc,%eax
  800930:	39 c1                	cmp    %eax,%ecx
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 78 31 80 00       	push   $0x803178
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 21 30 80 00       	push   $0x803021
  800946:	e8 57 0c 00 00       	call   8015a2 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 b9 1e 00 00       	call   802809 <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 b4 31 80 00       	push   $0x8031b4
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 21 30 80 00       	push   $0x803021
  800970:	e8 2d 0c 00 00       	call   8015a2 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 a8 1e 00 00       	call   802822 <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 08 32 80 00       	push   $0x803208
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 21 30 80 00       	push   $0x803021
  80099a:	e8 03 0c 00 00       	call   8015a2 <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80099f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a6:	e9 8c 00 00 00       	jmp    800a37 <_main+0x9ff>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b2:	eb 71                	jmp    800a25 <_main+0x9ed>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8009b9:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	c1 e0 03             	shl    $0x3,%eax
  8009cb:	01 c8                	add    %ecx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009d5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009ec:	89 c1                	mov    %eax,%ecx
  8009ee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009f4:	01 c8                	add    %ecx,%eax
  8009f6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8009fc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	75 17                	jne    800a22 <_main+0x9ea>
				{
					panic("free: page is not removed from WS");
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 40 32 80 00       	push   $0x803240
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 21 30 80 00       	push   $0x803021
  800a1d:	e8 80 0b 00 00       	call   8015a2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a22:	ff 45 e0             	incl   -0x20(%ebp)
  800a25:	a1 20 40 80 00       	mov    0x804020,%eax
  800a2a:	8b 50 74             	mov    0x74(%eax),%edx
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	77 80                	ja     8009b4 <_main+0x97c>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a34:	ff 45 e4             	incl   -0x1c(%ebp)
  800a37:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3b:	0f 8e 6a ff ff ff    	jle    8009ab <_main+0x973>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a41:	e8 c3 1d 00 00       	call   802809 <sys_calculate_free_frames>
  800a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a49:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a5d:	d1 e8                	shr    %eax
  800a5f:	48                   	dec    %eax
  800a60:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a66:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a72:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a78:	01 c0                	add    %eax,%eax
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a82:	01 c2                	add    %eax,%edx
  800a84:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a88:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8b:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800a8e:	e8 76 1d 00 00       	call   802809 <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 14 31 80 00       	push   $0x803114
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 21 30 80 00       	push   $0x803021
  800aae:	e8 ef 0a 00 00       	call   8015a2 <_panic>
		found = 0;
  800ab3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac1:	e9 a7 00 00 00       	jmp    800b6d <_main+0xb35>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac6:	a1 20 40 80 00       	mov    0x804020,%eax
  800acb:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	01 c0                	add    %eax,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	c1 e0 03             	shl    $0x3,%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800afa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b00:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	75 03                	jne    800b12 <_main+0xada>
				found++;
  800b0f:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b12:	a1 20 40 80 00       	mov    0x804020,%eax
  800b17:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	01 c0                	add    %eax,%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	c1 e0 03             	shl    $0x3,%eax
  800b29:	01 c8                	add    %ecx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b33:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b46:	01 c0                	add    %eax,%eax
  800b48:	89 c1                	mov    %eax,%ecx
  800b4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b50:	01 c8                	add    %ecx,%eax
  800b52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	75 03                	jne    800b6a <_main+0xb32>
				found++;
  800b67:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b6a:	ff 45 e4             	incl   -0x1c(%ebp)
  800b6d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b72:	8b 50 74             	mov    0x74(%eax),%edx
  800b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	0f 87 46 ff ff ff    	ja     800ac6 <_main+0xa8e>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 58 31 80 00       	push   $0x803158
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 21 30 80 00       	push   $0x803021
  800b98:	e8 05 0a 00 00       	call   8015a2 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 07 1d 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ba8:	01 c0                	add    %eax,%eax
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	e8 47 1a 00 00       	call   8025fa <malloc>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bbc:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bc7:	c1 e0 02             	shl    $0x2,%eax
  800bca:	05 00 00 00 80       	add    $0x80000000,%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	72 17                	jb     800bea <_main+0xbb2>
  800bd3:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bde:	c1 e0 02             	shl    $0x2,%eax
  800be1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 17                	jbe    800c01 <_main+0xbc9>
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	68 7c 30 80 00       	push   $0x80307c
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 21 30 80 00       	push   $0x803021
  800bfc:	e8 a1 09 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 a3 1c 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 e4 30 80 00       	push   $0x8030e4
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 21 30 80 00       	push   $0x803021
  800c20:	e8 7d 09 00 00       	call   8015a2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 df 1b 00 00       	call   802809 <sys_calculate_free_frames>
  800c2a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c2d:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c33:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	c1 e8 02             	shr    $0x2,%eax
  800c41:	48                   	dec    %eax
  800c42:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c48:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c51:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	01 c2                	add    %eax,%edx
  800c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6b:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c6d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c70:	e8 94 1b 00 00       	call   802809 <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 14 31 80 00       	push   $0x803114
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 21 30 80 00       	push   $0x803021
  800c90:	e8 0d 09 00 00       	call   8015a2 <_panic>
		found = 0;
  800c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ca3:	e9 aa 00 00 00       	jmp    800d52 <_main+0xd1a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca8:	a1 20 40 80 00       	mov    0x804020,%eax
  800cad:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	01 c0                	add    %eax,%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	c1 e0 03             	shl    $0x3,%eax
  800cbf:	01 c8                	add    %ecx,%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800cc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cdc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ce2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ced:	39 c2                	cmp    %eax,%edx
  800cef:	75 03                	jne    800cf4 <_main+0xcbc>
				found++;
  800cf1:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800cf4:	a1 20 40 80 00       	mov    0x804020,%eax
  800cf9:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	01 c0                	add    %eax,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	c1 e0 03             	shl    $0x3,%eax
  800d0b:	01 c8                	add    %ecx,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d15:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d20:	89 c2                	mov    %eax,%edx
  800d22:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d2f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	75 03                	jne    800d4f <_main+0xd17>
				found++;
  800d4c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d4f:	ff 45 e4             	incl   -0x1c(%ebp)
  800d52:	a1 20 40 80 00       	mov    0x804020,%eax
  800d57:	8b 50 74             	mov    0x74(%eax),%edx
  800d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	0f 87 43 ff ff ff    	ja     800ca8 <_main+0xc70>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d65:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d69:	74 17                	je     800d82 <_main+0xd4a>
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	68 58 31 80 00       	push   $0x803158
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 21 30 80 00       	push   $0x803021
  800d7d:	e8 20 08 00 00       	call   8015a2 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 82 1a 00 00       	call   802809 <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 1a 1b 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800d8f:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	e8 5a 18 00 00       	call   8025fa <malloc>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800da9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	89 c1                	mov    %eax,%ecx
  800db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 c8                	add    %ecx,%eax
  800dc1:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	72 21                	jb     800deb <_main+0xdb3>
  800dca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ddd:	c1 e0 02             	shl    $0x2,%eax
  800de0:	01 c8                	add    %ecx,%eax
  800de2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800de7:	39 c2                	cmp    %eax,%edx
  800de9:	76 17                	jbe    800e02 <_main+0xdca>
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	68 7c 30 80 00       	push   $0x80307c
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 21 30 80 00       	push   $0x803021
  800dfd:	e8 a0 07 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 a2 1a 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 e4 30 80 00       	push   $0x8030e4
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 21 30 80 00       	push   $0x803021
  800e21:	e8 7c 07 00 00       	call   8015a2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 7e 1a 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800e2b:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	01 c0                	add    %eax,%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	e8 b6 17 00 00       	call   8025fa <malloc>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e4d:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e58:	c1 e0 02             	shl    $0x2,%eax
  800e5b:	89 c1                	mov    %eax,%ecx
  800e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e60:	c1 e0 03             	shl    $0x3,%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	05 00 00 00 80       	add    $0x80000000,%eax
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	72 21                	jb     800e8f <_main+0xe57>
  800e6e:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e79:	c1 e0 02             	shl    $0x2,%eax
  800e7c:	89 c1                	mov    %eax,%ecx
  800e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e81:	c1 e0 03             	shl    $0x3,%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 17                	jbe    800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 7c 30 80 00       	push   $0x80307c
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 21 30 80 00       	push   $0x803021
  800ea1:	e8 fc 06 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 fe 19 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 e4 30 80 00       	push   $0x8030e4
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 21 30 80 00       	push   $0x803021
  800ec5:	e8 d8 06 00 00       	call   8015a2 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 3a 19 00 00       	call   802809 <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 d2 19 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800ed7:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	01 d2                	add    %edx,%edx
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	e8 0b 17 00 00       	call   8025fa <malloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800ef8:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f03:	c1 e0 02             	shl    $0x2,%eax
  800f06:	89 c1                	mov    %eax,%ecx
  800f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f0b:	c1 e0 04             	shl    $0x4,%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	05 00 00 00 80       	add    $0x80000000,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	72 21                	jb     800f3a <_main+0xf02>
  800f19:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f24:	c1 e0 02             	shl    $0x2,%eax
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f2c:	c1 e0 04             	shl    $0x4,%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f36:	39 c2                	cmp    %eax,%edx
  800f38:	76 17                	jbe    800f51 <_main+0xf19>
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 7c 30 80 00       	push   $0x80307c
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 21 30 80 00       	push   $0x803021
  800f4c:	e8 51 06 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 53 19 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800f56:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5e:	89 c1                	mov    %eax,%ecx
  800f60:	01 c9                	add    %ecx,%ecx
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 05                	jns    800f6d <_main+0xf35>
  800f68:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f6d:	c1 f8 0c             	sar    $0xc,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 17                	je     800f8b <_main+0xf53>
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 e4 30 80 00       	push   $0x8030e4
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 21 30 80 00       	push   $0x803021
  800f86:	e8 17 06 00 00       	call   8015a2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 19 19 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  800f90:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	01 c0                	add    %eax,%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	01 c0                	add    %eax,%eax
  800f9e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	e8 50 16 00 00       	call   8025fa <malloc>
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fb3:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	01 c0                	add    %eax,%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	01 c0                	add    %eax,%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcd:	c1 e0 04             	shl    $0x4,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	05 00 00 00 80       	add    $0x80000000,%eax
  800fd7:	39 c1                	cmp    %eax,%ecx
  800fd9:	72 28                	jb     801003 <_main+0xfcb>
  800fdb:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	01 c0                	add    %eax,%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ff5:	c1 e0 04             	shl    $0x4,%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800fff:	39 c1                	cmp    %eax,%ecx
  801001:	76 17                	jbe    80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 7c 30 80 00       	push   $0x80307c
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 21 30 80 00       	push   $0x803021
  801015:	e8 88 05 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 8a 18 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  80101f:	2b 45 90             	sub    -0x70(%ebp),%eax
  801022:	89 c1                	mov    %eax,%ecx
  801024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	01 c0                	add    %eax,%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	01 c0                	add    %eax,%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	79 05                	jns    801038 <_main+0x1000>
  801033:	05 ff 0f 00 00       	add    $0xfff,%eax
  801038:	c1 f8 0c             	sar    $0xc,%eax
  80103b:	39 c1                	cmp    %eax,%ecx
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 e4 30 80 00       	push   $0x8030e4
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 21 30 80 00       	push   $0x803021
  801051:	e8 4c 05 00 00       	call   8015a2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 ae 17 00 00       	call   802809 <sys_calculate_free_frames>
  80105b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  80105e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801061:	89 d0                	mov    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80106c:	48                   	dec    %eax
  80106d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801073:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801079:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80107f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801085:	8a 55 cf             	mov    -0x31(%ebp),%dl
  801088:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80108a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	c1 ea 1f             	shr    $0x1f,%edx
  801095:	01 d0                	add    %edx,%eax
  801097:	d1 f8                	sar    %eax
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010a6:	88 c1                	mov    %al,%cl
  8010a8:	c0 e9 07             	shr    $0x7,%cl
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	d0 f8                	sar    %al
  8010af:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010b1:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010b7:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010c4:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010c7:	e8 3d 17 00 00       	call   802809 <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 14 31 80 00       	push   $0x803114
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 21 30 80 00       	push   $0x803021
  8010e7:	e8 b6 04 00 00       	call   8015a2 <_panic>
		found = 0;
  8010ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010fa:	e9 02 01 00 00       	jmp    801201 <_main+0x11c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010ff:	a1 20 40 80 00       	mov    0x804020,%eax
  801104:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	01 c0                	add    %eax,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c1 e0 03             	shl    $0x3,%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801120:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801133:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801139:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80113f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	75 03                	jne    80114b <_main+0x1113>
				found++;
  801148:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80114b:	a1 20 40 80 00       	mov    0x804020,%eax
  801150:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	01 c0                	add    %eax,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c1 e0 03             	shl    $0x3,%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	c1 e9 1f             	shr    $0x1f,%ecx
  801184:	01 c8                	add    %ecx,%eax
  801186:	d1 f8                	sar    %eax
  801188:	89 c1                	mov    %eax,%ecx
  80118a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801190:	01 c8                	add    %ecx,%eax
  801192:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  801198:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 03                	jne    8011aa <_main+0x1172>
				found++;
  8011a7:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8011af:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8011b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	01 c0                	add    %eax,%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	c1 e0 03             	shl    $0x3,%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011cb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	89 c1                	mov    %eax,%ecx
  8011d8:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011de:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8011ec:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8011f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f7:	39 c1                	cmp    %eax,%ecx
  8011f9:	75 03                	jne    8011fe <_main+0x11c6>
				found++;
  8011fb:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801201:	a1 20 40 80 00       	mov    0x804020,%eax
  801206:	8b 50 74             	mov    0x74(%eax),%edx
  801209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	0f 87 eb fe ff ff    	ja     8010ff <_main+0x10c7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801214:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801218:	74 17                	je     801231 <_main+0x11f9>
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 58 31 80 00       	push   $0x803158
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 21 30 80 00       	push   $0x803021
  80122c:	e8 71 03 00 00       	call   8015a2 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 73 16 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  801236:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	01 c0                	add    %eax,%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	01 c0                	add    %eax,%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	01 c0                	add    %eax,%eax
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	e8 a9 13 00 00       	call   8025fa <malloc>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80125a:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 02             	shl    $0x2,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801275:	c1 e0 04             	shl    $0x4,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	05 00 00 00 80       	add    $0x80000000,%eax
  80127f:	39 c1                	cmp    %eax,%ecx
  801281:	72 29                	jb     8012ac <_main+0x1274>
  801283:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801289:	89 c1                	mov    %eax,%ecx
  80128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	01 c0                	add    %eax,%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c1 e0 02             	shl    $0x2,%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80129e:	c1 e0 04             	shl    $0x4,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012a8:	39 c1                	cmp    %eax,%ecx
  8012aa:	76 17                	jbe    8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 7c 30 80 00       	push   $0x80307c
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 21 30 80 00       	push   $0x803021
  8012be:	e8 df 02 00 00       	call   8015a2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 e1 15 00 00       	call   8028a9 <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 e4 30 80 00       	push   $0x8030e4
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 21 30 80 00       	push   $0x803021
  8012e2:	e8 bb 02 00 00       	call   8015a2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 1d 15 00 00       	call   802809 <sys_calculate_free_frames>
  8012ec:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012ef:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012f5:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	01 c0                	add    %eax,%eax
  80130a:	d1 e8                	shr    %eax
  80130c:	48                   	dec    %eax
  80130d:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801313:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80131c:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80131f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801325:	01 c0                	add    %eax,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801335:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801338:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  80133b:	e8 c9 14 00 00       	call   802809 <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 14 31 80 00       	push   $0x803114
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 21 30 80 00       	push   $0x803021
  80135b:	e8 42 02 00 00       	call   8015a2 <_panic>
		found = 0;
  801360:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80136e:	e9 a7 00 00 00       	jmp    80141a <_main+0x13e2>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801373:	a1 20 40 80 00       	mov    0x804020,%eax
  801378:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801381:	89 d0                	mov    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c1 e0 03             	shl    $0x3,%eax
  80138a:	01 c8                	add    %ecx,%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801394:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013a7:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013ad:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	39 c2                	cmp    %eax,%edx
  8013ba:	75 03                	jne    8013bf <_main+0x1387>
				found++;
  8013bc:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8013c4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	01 c0                	add    %eax,%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c1 e0 03             	shl    $0x3,%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013e0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8013e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8013f3:	01 c0                	add    %eax,%eax
  8013f5:	89 c1                	mov    %eax,%ecx
  8013f7:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801405:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	39 c2                	cmp    %eax,%edx
  801412:	75 03                	jne    801417 <_main+0x13df>
				found++;
  801414:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
  80141a:	a1 20 40 80 00       	mov    0x804020,%eax
  80141f:	8b 50 74             	mov    0x74(%eax),%edx
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	39 c2                	cmp    %eax,%edx
  801427:	0f 87 46 ff ff ff    	ja     801373 <_main+0x133b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80142d:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801431:	74 17                	je     80144a <_main+0x1412>
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 58 31 80 00       	push   $0x803158
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 21 30 80 00       	push   $0x803021
  801445:	e8 58 01 00 00       	call   8015a2 <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80144a:	90                   	nop
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801459:	e8 8b 16 00 00       	call   802ae9 <sys_getenvindex>
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	01 c0                	add    %eax,%eax
  801468:	01 d0                	add    %edx,%eax
  80146a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801471:	01 c8                	add    %ecx,%eax
  801473:	c1 e0 02             	shl    $0x2,%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80147f:	01 c8                	add    %ecx,%eax
  801481:	c1 e0 02             	shl    $0x2,%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	c1 e0 02             	shl    $0x2,%eax
  801489:	01 d0                	add    %edx,%eax
  80148b:	c1 e0 03             	shl    $0x3,%eax
  80148e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801493:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801498:	a1 20 40 80 00       	mov    0x804020,%eax
  80149d:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8014a3:	84 c0                	test   %al,%al
  8014a5:	74 0f                	je     8014b6 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8014a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8014ac:	05 18 da 01 00       	add    $0x1da18,%eax
  8014b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ba:	7e 0a                	jle    8014c6 <libmain+0x73>
		binaryname = argv[0];
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	8b 00                	mov    (%eax),%eax
  8014c1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 64 eb ff ff       	call   800038 <_main>
  8014d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8014d7:	e8 1a 14 00 00       	call   8028f6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	68 7c 32 80 00       	push   $0x80327c
  8014e4:	e8 6d 03 00 00       	call   801856 <cprintf>
  8014e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8014f1:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8014f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8014fc:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	52                   	push   %edx
  801506:	50                   	push   %eax
  801507:	68 a4 32 80 00       	push   $0x8032a4
  80150c:	e8 45 03 00 00       	call   801856 <cprintf>
  801511:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801514:	a1 20 40 80 00       	mov    0x804020,%eax
  801519:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80151f:	a1 20 40 80 00       	mov    0x804020,%eax
  801524:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80152a:	a1 20 40 80 00       	mov    0x804020,%eax
  80152f:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  801535:	51                   	push   %ecx
  801536:	52                   	push   %edx
  801537:	50                   	push   %eax
  801538:	68 cc 32 80 00       	push   $0x8032cc
  80153d:	e8 14 03 00 00       	call   801856 <cprintf>
  801542:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801545:	a1 20 40 80 00       	mov    0x804020,%eax
  80154a:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	50                   	push   %eax
  801554:	68 24 33 80 00       	push   $0x803324
  801559:	e8 f8 02 00 00       	call   801856 <cprintf>
  80155e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	68 7c 32 80 00       	push   $0x80327c
  801569:	e8 e8 02 00 00       	call   801856 <cprintf>
  80156e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801571:	e8 9a 13 00 00       	call   802910 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801576:	e8 19 00 00 00       	call   801594 <exit>
}
  80157b:	90                   	nop
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	6a 00                	push   $0x0
  801589:	e8 27 15 00 00       	call   802ab5 <sys_destroy_env>
  80158e:	83 c4 10             	add    $0x10,%esp
}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <exit>:

void
exit(void)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80159a:	e8 7c 15 00 00       	call   802b1b <sys_exit_env>
}
  80159f:	90                   	nop
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8015ab:	83 c0 04             	add    $0x4,%eax
  8015ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015b1:	a1 58 b2 82 00       	mov    0x82b258,%eax
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 16                	je     8015d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015ba:	a1 58 b2 82 00       	mov    0x82b258,%eax
  8015bf:	83 ec 08             	sub    $0x8,%esp
  8015c2:	50                   	push   %eax
  8015c3:	68 38 33 80 00       	push   $0x803338
  8015c8:	e8 89 02 00 00       	call   801856 <cprintf>
  8015cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015d0:	a1 00 40 80 00       	mov    0x804000,%eax
  8015d5:	ff 75 0c             	pushl  0xc(%ebp)
  8015d8:	ff 75 08             	pushl  0x8(%ebp)
  8015db:	50                   	push   %eax
  8015dc:	68 3d 33 80 00       	push   $0x80333d
  8015e1:	e8 70 02 00 00       	call   801856 <cprintf>
  8015e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	83 ec 08             	sub    $0x8,%esp
  8015ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	e8 f3 01 00 00       	call   8017eb <vcprintf>
  8015f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	6a 00                	push   $0x0
  801600:	68 59 33 80 00       	push   $0x803359
  801605:	e8 e1 01 00 00       	call   8017eb <vcprintf>
  80160a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80160d:	e8 82 ff ff ff       	call   801594 <exit>

	// should not return here
	while (1) ;
  801612:	eb fe                	jmp    801612 <_panic+0x70>

00801614 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80161a:	a1 20 40 80 00       	mov    0x804020,%eax
  80161f:	8b 50 74             	mov    0x74(%eax),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	39 c2                	cmp    %eax,%edx
  801627:	74 14                	je     80163d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 5c 33 80 00       	push   $0x80335c
  801631:	6a 26                	push   $0x26
  801633:	68 a8 33 80 00       	push   $0x8033a8
  801638:	e8 65 ff ff ff       	call   8015a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801644:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80164b:	e9 c2 00 00 00       	jmp    801712 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	85 c0                	test   %eax,%eax
  801663:	75 08                	jne    80166d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801665:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801668:	e9 a2 00 00 00       	jmp    80170f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80166d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801674:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80167b:	eb 69                	jmp    8016e6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80167d:	a1 20 40 80 00       	mov    0x804020,%eax
  801682:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801688:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80168b:	89 d0                	mov    %edx,%eax
  80168d:	01 c0                	add    %eax,%eax
  80168f:	01 d0                	add    %edx,%eax
  801691:	c1 e0 03             	shl    $0x3,%eax
  801694:	01 c8                	add    %ecx,%eax
  801696:	8a 40 04             	mov    0x4(%eax),%al
  801699:	84 c0                	test   %al,%al
  80169b:	75 46                	jne    8016e3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80169d:	a1 20 40 80 00       	mov    0x804020,%eax
  8016a2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8016a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ab:	89 d0                	mov    %edx,%eax
  8016ad:	01 c0                	add    %eax,%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	c1 e0 03             	shl    $0x3,%eax
  8016b4:	01 c8                	add    %ecx,%eax
  8016b6:	8b 00                	mov    (%eax),%eax
  8016b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	01 c8                	add    %ecx,%eax
  8016d4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016d6:	39 c2                	cmp    %eax,%edx
  8016d8:	75 09                	jne    8016e3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8016da:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016e1:	eb 12                	jmp    8016f5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016e3:	ff 45 e8             	incl   -0x18(%ebp)
  8016e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8016eb:	8b 50 74             	mov    0x74(%eax),%edx
  8016ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f1:	39 c2                	cmp    %eax,%edx
  8016f3:	77 88                	ja     80167d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f9:	75 14                	jne    80170f <CheckWSWithoutLastIndex+0xfb>
			panic(
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 b4 33 80 00       	push   $0x8033b4
  801703:	6a 3a                	push   $0x3a
  801705:	68 a8 33 80 00       	push   $0x8033a8
  80170a:	e8 93 fe ff ff       	call   8015a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80170f:	ff 45 f0             	incl   -0x10(%ebp)
  801712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801715:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801718:	0f 8c 32 ff ff ff    	jl     801650 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80171e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801725:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80172c:	eb 26                	jmp    801754 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80172e:	a1 20 40 80 00       	mov    0x804020,%eax
  801733:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801739:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80173c:	89 d0                	mov    %edx,%eax
  80173e:	01 c0                	add    %eax,%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	c1 e0 03             	shl    $0x3,%eax
  801745:	01 c8                	add    %ecx,%eax
  801747:	8a 40 04             	mov    0x4(%eax),%al
  80174a:	3c 01                	cmp    $0x1,%al
  80174c:	75 03                	jne    801751 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80174e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801751:	ff 45 e0             	incl   -0x20(%ebp)
  801754:	a1 20 40 80 00       	mov    0x804020,%eax
  801759:	8b 50 74             	mov    0x74(%eax),%edx
  80175c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175f:	39 c2                	cmp    %eax,%edx
  801761:	77 cb                	ja     80172e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801769:	74 14                	je     80177f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	68 08 34 80 00       	push   $0x803408
  801773:	6a 44                	push   $0x44
  801775:	68 a8 33 80 00       	push   $0x8033a8
  80177a:	e8 23 fe ff ff       	call   8015a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80177f:	90                   	nop
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	8b 00                	mov    (%eax),%eax
  80178d:	8d 48 01             	lea    0x1(%eax),%ecx
  801790:	8b 55 0c             	mov    0xc(%ebp),%edx
  801793:	89 0a                	mov    %ecx,(%edx)
  801795:	8b 55 08             	mov    0x8(%ebp),%edx
  801798:	88 d1                	mov    %dl,%cl
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	8b 00                	mov    (%eax),%eax
  8017a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017ab:	75 2c                	jne    8017d9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8017ad:	a0 24 40 80 00       	mov    0x804024,%al
  8017b2:	0f b6 c0             	movzbl %al,%eax
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 12                	mov    (%edx),%edx
  8017ba:	89 d1                	mov    %edx,%ecx
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	83 c2 08             	add    $0x8,%edx
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	50                   	push   %eax
  8017c6:	51                   	push   %ecx
  8017c7:	52                   	push   %edx
  8017c8:	e8 7b 0f 00 00       	call   802748 <sys_cputs>
  8017cd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	8b 40 04             	mov    0x4(%eax),%eax
  8017df:	8d 50 01             	lea    0x1(%eax),%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017fb:	00 00 00 
	b.cnt = 0;
  8017fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801805:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	68 82 17 80 00       	push   $0x801782
  80181a:	e8 11 02 00 00       	call   801a30 <vprintfmt>
  80181f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801822:	a0 24 40 80 00       	mov    0x804024,%al
  801827:	0f b6 c0             	movzbl %al,%eax
  80182a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	50                   	push   %eax
  801834:	52                   	push   %edx
  801835:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80183b:	83 c0 08             	add    $0x8,%eax
  80183e:	50                   	push   %eax
  80183f:	e8 04 0f 00 00       	call   802748 <sys_cputs>
  801844:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801847:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80184e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <cprintf>:

int cprintf(const char *fmt, ...) {
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80185c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801863:	8d 45 0c             	lea    0xc(%ebp),%eax
  801866:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	ff 75 f4             	pushl  -0xc(%ebp)
  801872:	50                   	push   %eax
  801873:	e8 73 ff ff ff       	call   8017eb <vcprintf>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801889:	e8 68 10 00 00       	call   8028f6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80188e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	ff 75 f4             	pushl  -0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	e8 48 ff ff ff       	call   8017eb <vcprintf>
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8018a9:	e8 62 10 00 00       	call   802910 <sys_enable_interrupt>
	return cnt;
  8018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 14             	sub    $0x14,%esp
  8018ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018d1:	77 55                	ja     801928 <printnum+0x75>
  8018d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018d6:	72 05                	jb     8018dd <printnum+0x2a>
  8018d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018db:	77 4b                	ja     801928 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018dd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018e0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8018e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f3:	e8 84 14 00 00       	call   802d7c <__udivdi3>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	ff 75 20             	pushl  0x20(%ebp)
  801901:	53                   	push   %ebx
  801902:	ff 75 18             	pushl  0x18(%ebp)
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	e8 a1 ff ff ff       	call   8018b3 <printnum>
  801912:	83 c4 20             	add    $0x20,%esp
  801915:	eb 1a                	jmp    801931 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801917:	83 ec 08             	sub    $0x8,%esp
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 20             	pushl  0x20(%ebp)
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	ff d0                	call   *%eax
  801925:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801928:	ff 4d 1c             	decl   0x1c(%ebp)
  80192b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80192f:	7f e6                	jg     801917 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801931:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801934:	bb 00 00 00 00       	mov    $0x0,%ebx
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193f:	53                   	push   %ebx
  801940:	51                   	push   %ecx
  801941:	52                   	push   %edx
  801942:	50                   	push   %eax
  801943:	e8 44 15 00 00       	call   802e8c <__umoddi3>
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	05 74 36 80 00       	add    $0x803674,%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	0f be c0             	movsbl %al,%eax
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	50                   	push   %eax
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	ff d0                	call   *%eax
  801961:	83 c4 10             	add    $0x10,%esp
}
  801964:	90                   	nop
  801965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80196d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801971:	7e 1c                	jle    80198f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8b 00                	mov    (%eax),%eax
  801978:	8d 50 08             	lea    0x8(%eax),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	89 10                	mov    %edx,(%eax)
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	8b 00                	mov    (%eax),%eax
  801985:	83 e8 08             	sub    $0x8,%eax
  801988:	8b 50 04             	mov    0x4(%eax),%edx
  80198b:	8b 00                	mov    (%eax),%eax
  80198d:	eb 40                	jmp    8019cf <getuint+0x65>
	else if (lflag)
  80198f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801993:	74 1e                	je     8019b3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	8d 50 04             	lea    0x4(%eax),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	89 10                	mov    %edx,(%eax)
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	83 e8 04             	sub    $0x4,%eax
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b1:	eb 1c                	jmp    8019cf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	8b 00                	mov    (%eax),%eax
  8019b8:	8d 50 04             	lea    0x4(%eax),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	89 10                	mov    %edx,(%eax)
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	8b 00                	mov    (%eax),%eax
  8019c5:	83 e8 04             	sub    $0x4,%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019d8:	7e 1c                	jle    8019f6 <getint+0x25>
		return va_arg(*ap, long long);
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8b 00                	mov    (%eax),%eax
  8019df:	8d 50 08             	lea    0x8(%eax),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	89 10                	mov    %edx,(%eax)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8b 00                	mov    (%eax),%eax
  8019ec:	83 e8 08             	sub    $0x8,%eax
  8019ef:	8b 50 04             	mov    0x4(%eax),%edx
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	eb 38                	jmp    801a2e <getint+0x5d>
	else if (lflag)
  8019f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019fa:	74 1a                	je     801a16 <getint+0x45>
		return va_arg(*ap, long);
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	8d 50 04             	lea    0x4(%eax),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	89 10                	mov    %edx,(%eax)
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	83 e8 04             	sub    $0x4,%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	99                   	cltd   
  801a14:	eb 18                	jmp    801a2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	8d 50 04             	lea    0x4(%eax),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	89 10                	mov    %edx,(%eax)
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8b 00                	mov    (%eax),%eax
  801a28:	83 e8 04             	sub    $0x4,%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	99                   	cltd   
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	56                   	push   %esi
  801a34:	53                   	push   %ebx
  801a35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a38:	eb 17                	jmp    801a51 <vprintfmt+0x21>
			if (ch == '\0')
  801a3a:	85 db                	test   %ebx,%ebx
  801a3c:	0f 84 af 03 00 00    	je     801df1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a42:	83 ec 08             	sub    $0x8,%esp
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	53                   	push   %ebx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	ff d0                	call   *%eax
  801a4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a51:	8b 45 10             	mov    0x10(%ebp),%eax
  801a54:	8d 50 01             	lea    0x1(%eax),%edx
  801a57:	89 55 10             	mov    %edx,0x10(%ebp)
  801a5a:	8a 00                	mov    (%eax),%al
  801a5c:	0f b6 d8             	movzbl %al,%ebx
  801a5f:	83 fb 25             	cmp    $0x25,%ebx
  801a62:	75 d6                	jne    801a3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a84:	8b 45 10             	mov    0x10(%ebp),%eax
  801a87:	8d 50 01             	lea    0x1(%eax),%edx
  801a8a:	89 55 10             	mov    %edx,0x10(%ebp)
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	0f b6 d8             	movzbl %al,%ebx
  801a92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a95:	83 f8 55             	cmp    $0x55,%eax
  801a98:	0f 87 2b 03 00 00    	ja     801dc9 <vprintfmt+0x399>
  801a9e:	8b 04 85 98 36 80 00 	mov    0x803698(,%eax,4),%eax
  801aa5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801aa7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801aab:	eb d7                	jmp    801a84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801aad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ab1:	eb d1                	jmp    801a84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ab3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801aba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abd:	89 d0                	mov    %edx,%eax
  801abf:	c1 e0 02             	shl    $0x2,%eax
  801ac2:	01 d0                	add    %edx,%eax
  801ac4:	01 c0                	add    %eax,%eax
  801ac6:	01 d8                	add    %ebx,%eax
  801ac8:	83 e8 30             	sub    $0x30,%eax
  801acb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801ace:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ad6:	83 fb 2f             	cmp    $0x2f,%ebx
  801ad9:	7e 3e                	jle    801b19 <vprintfmt+0xe9>
  801adb:	83 fb 39             	cmp    $0x39,%ebx
  801ade:	7f 39                	jg     801b19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ae0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ae3:	eb d5                	jmp    801aba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae8:	83 c0 04             	add    $0x4,%eax
  801aeb:	89 45 14             	mov    %eax,0x14(%ebp)
  801aee:	8b 45 14             	mov    0x14(%ebp),%eax
  801af1:	83 e8 04             	sub    $0x4,%eax
  801af4:	8b 00                	mov    (%eax),%eax
  801af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801af9:	eb 1f                	jmp    801b1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aff:	79 83                	jns    801a84 <vprintfmt+0x54>
				width = 0;
  801b01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b08:	e9 77 ff ff ff       	jmp    801a84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b14:	e9 6b ff ff ff       	jmp    801a84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b1e:	0f 89 60 ff ff ff    	jns    801a84 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b31:	e9 4e ff ff ff       	jmp    801a84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b39:	e9 46 ff ff ff       	jmp    801a84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b41:	83 c0 04             	add    $0x4,%eax
  801b44:	89 45 14             	mov    %eax,0x14(%ebp)
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	83 e8 04             	sub    $0x4,%eax
  801b4d:	8b 00                	mov    (%eax),%eax
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	ff d0                	call   *%eax
  801b5b:	83 c4 10             	add    $0x10,%esp
			break;
  801b5e:	e9 89 02 00 00       	jmp    801dec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b63:	8b 45 14             	mov    0x14(%ebp),%eax
  801b66:	83 c0 04             	add    $0x4,%eax
  801b69:	89 45 14             	mov    %eax,0x14(%ebp)
  801b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6f:	83 e8 04             	sub    $0x4,%eax
  801b72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b74:	85 db                	test   %ebx,%ebx
  801b76:	79 02                	jns    801b7a <vprintfmt+0x14a>
				err = -err;
  801b78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b7a:	83 fb 64             	cmp    $0x64,%ebx
  801b7d:	7f 0b                	jg     801b8a <vprintfmt+0x15a>
  801b7f:	8b 34 9d e0 34 80 00 	mov    0x8034e0(,%ebx,4),%esi
  801b86:	85 f6                	test   %esi,%esi
  801b88:	75 19                	jne    801ba3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b8a:	53                   	push   %ebx
  801b8b:	68 85 36 80 00       	push   $0x803685
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	e8 5e 02 00 00       	call   801df9 <printfmt>
  801b9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b9e:	e9 49 02 00 00       	jmp    801dec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ba3:	56                   	push   %esi
  801ba4:	68 8e 36 80 00       	push   $0x80368e
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	ff 75 08             	pushl  0x8(%ebp)
  801baf:	e8 45 02 00 00       	call   801df9 <printfmt>
  801bb4:	83 c4 10             	add    $0x10,%esp
			break;
  801bb7:	e9 30 02 00 00       	jmp    801dec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bbc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbf:	83 c0 04             	add    $0x4,%eax
  801bc2:	89 45 14             	mov    %eax,0x14(%ebp)
  801bc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc8:	83 e8 04             	sub    $0x4,%eax
  801bcb:	8b 30                	mov    (%eax),%esi
  801bcd:	85 f6                	test   %esi,%esi
  801bcf:	75 05                	jne    801bd6 <vprintfmt+0x1a6>
				p = "(null)";
  801bd1:	be 91 36 80 00       	mov    $0x803691,%esi
			if (width > 0 && padc != '-')
  801bd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bda:	7e 6d                	jle    801c49 <vprintfmt+0x219>
  801bdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801be0:	74 67                	je     801c49 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	50                   	push   %eax
  801be9:	56                   	push   %esi
  801bea:	e8 0c 03 00 00       	call   801efb <strnlen>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801bf5:	eb 16                	jmp    801c0d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801bf7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	50                   	push   %eax
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	ff d0                	call   *%eax
  801c07:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c0a:	ff 4d e4             	decl   -0x1c(%ebp)
  801c0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c11:	7f e4                	jg     801bf7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c13:	eb 34                	jmp    801c49 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c19:	74 1c                	je     801c37 <vprintfmt+0x207>
  801c1b:	83 fb 1f             	cmp    $0x1f,%ebx
  801c1e:	7e 05                	jle    801c25 <vprintfmt+0x1f5>
  801c20:	83 fb 7e             	cmp    $0x7e,%ebx
  801c23:	7e 12                	jle    801c37 <vprintfmt+0x207>
					putch('?', putdat);
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	6a 3f                	push   $0x3f
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	ff d0                	call   *%eax
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	eb 0f                	jmp    801c46 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	53                   	push   %ebx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	ff d0                	call   *%eax
  801c43:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c46:	ff 4d e4             	decl   -0x1c(%ebp)
  801c49:	89 f0                	mov    %esi,%eax
  801c4b:	8d 70 01             	lea    0x1(%eax),%esi
  801c4e:	8a 00                	mov    (%eax),%al
  801c50:	0f be d8             	movsbl %al,%ebx
  801c53:	85 db                	test   %ebx,%ebx
  801c55:	74 24                	je     801c7b <vprintfmt+0x24b>
  801c57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c5b:	78 b8                	js     801c15 <vprintfmt+0x1e5>
  801c5d:	ff 4d e0             	decl   -0x20(%ebp)
  801c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c64:	79 af                	jns    801c15 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c66:	eb 13                	jmp    801c7b <vprintfmt+0x24b>
				putch(' ', putdat);
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	6a 20                	push   $0x20
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	ff d0                	call   *%eax
  801c75:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c78:	ff 4d e4             	decl   -0x1c(%ebp)
  801c7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c7f:	7f e7                	jg     801c68 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c81:	e9 66 01 00 00       	jmp    801dec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c86:	83 ec 08             	sub    $0x8,%esp
  801c89:	ff 75 e8             	pushl  -0x18(%ebp)
  801c8c:	8d 45 14             	lea    0x14(%ebp),%eax
  801c8f:	50                   	push   %eax
  801c90:	e8 3c fd ff ff       	call   8019d1 <getint>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca4:	85 d2                	test   %edx,%edx
  801ca6:	79 23                	jns    801ccb <vprintfmt+0x29b>
				putch('-', putdat);
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	6a 2d                	push   $0x2d
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	ff d0                	call   *%eax
  801cb5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbe:	f7 d8                	neg    %eax
  801cc0:	83 d2 00             	adc    $0x0,%edx
  801cc3:	f7 da                	neg    %edx
  801cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801ccb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cd2:	e9 bc 00 00 00       	jmp    801d93 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	ff 75 e8             	pushl  -0x18(%ebp)
  801cdd:	8d 45 14             	lea    0x14(%ebp),%eax
  801ce0:	50                   	push   %eax
  801ce1:	e8 84 fc ff ff       	call   80196a <getuint>
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cf6:	e9 98 00 00 00       	jmp    801d93 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	6a 58                	push   $0x58
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	ff d0                	call   *%eax
  801d08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d0b:	83 ec 08             	sub    $0x8,%esp
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	6a 58                	push   $0x58
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	ff d0                	call   *%eax
  801d18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d1b:	83 ec 08             	sub    $0x8,%esp
  801d1e:	ff 75 0c             	pushl  0xc(%ebp)
  801d21:	6a 58                	push   $0x58
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	ff d0                	call   *%eax
  801d28:	83 c4 10             	add    $0x10,%esp
			break;
  801d2b:	e9 bc 00 00 00       	jmp    801dec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d30:	83 ec 08             	sub    $0x8,%esp
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	6a 30                	push   $0x30
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	ff d0                	call   *%eax
  801d3d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	6a 78                	push   $0x78
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	ff d0                	call   *%eax
  801d4d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	83 c0 04             	add    $0x4,%eax
  801d56:	89 45 14             	mov    %eax,0x14(%ebp)
  801d59:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5c:	83 e8 04             	sub    $0x4,%eax
  801d5f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d72:	eb 1f                	jmp    801d93 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d74:	83 ec 08             	sub    $0x8,%esp
  801d77:	ff 75 e8             	pushl  -0x18(%ebp)
  801d7a:	8d 45 14             	lea    0x14(%ebp),%eax
  801d7d:	50                   	push   %eax
  801d7e:	e8 e7 fb ff ff       	call   80196a <getuint>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d93:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	52                   	push   %edx
  801d9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801da1:	50                   	push   %eax
  801da2:	ff 75 f4             	pushl  -0xc(%ebp)
  801da5:	ff 75 f0             	pushl  -0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	e8 00 fb ff ff       	call   8018b3 <printnum>
  801db3:	83 c4 20             	add    $0x20,%esp
			break;
  801db6:	eb 34                	jmp    801dec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801db8:	83 ec 08             	sub    $0x8,%esp
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	53                   	push   %ebx
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	ff d0                	call   *%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
			break;
  801dc7:	eb 23                	jmp    801dec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	6a 25                	push   $0x25
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dd9:	ff 4d 10             	decl   0x10(%ebp)
  801ddc:	eb 03                	jmp    801de1 <vprintfmt+0x3b1>
  801dde:	ff 4d 10             	decl   0x10(%ebp)
  801de1:	8b 45 10             	mov    0x10(%ebp),%eax
  801de4:	48                   	dec    %eax
  801de5:	8a 00                	mov    (%eax),%al
  801de7:	3c 25                	cmp    $0x25,%al
  801de9:	75 f3                	jne    801dde <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801deb:	90                   	nop
		}
	}
  801dec:	e9 47 fc ff ff       	jmp    801a38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801df1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dff:	8d 45 10             	lea    0x10(%ebp),%eax
  801e02:	83 c0 04             	add    $0x4,%eax
  801e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e08:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0e:	50                   	push   %eax
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	e8 16 fc ff ff       	call   801a30 <vprintfmt>
  801e1a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e1d:	90                   	nop
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e26:	8b 40 08             	mov    0x8(%eax),%eax
  801e29:	8d 50 01             	lea    0x1(%eax),%edx
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e35:	8b 10                	mov    (%eax),%edx
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	8b 40 04             	mov    0x4(%eax),%eax
  801e3d:	39 c2                	cmp    %eax,%edx
  801e3f:	73 12                	jae    801e53 <sprintputch+0x33>
		*b->buf++ = ch;
  801e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	8d 48 01             	lea    0x1(%eax),%ecx
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	89 0a                	mov    %ecx,(%edx)
  801e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e51:	88 10                	mov    %dl,(%eax)
}
  801e53:	90                   	nop
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	01 d0                	add    %edx,%eax
  801e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e7b:	74 06                	je     801e83 <vsnprintf+0x2d>
  801e7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e81:	7f 07                	jg     801e8a <vsnprintf+0x34>
		return -E_INVAL;
  801e83:	b8 03 00 00 00       	mov    $0x3,%eax
  801e88:	eb 20                	jmp    801eaa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e8a:	ff 75 14             	pushl  0x14(%ebp)
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e93:	50                   	push   %eax
  801e94:	68 20 1e 80 00       	push   $0x801e20
  801e99:	e8 92 fb ff ff       	call   801a30 <vprintfmt>
  801e9e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801eb2:	8d 45 10             	lea    0x10(%ebp),%eax
  801eb5:	83 c0 04             	add    $0x4,%eax
  801eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebe:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	ff 75 08             	pushl  0x8(%ebp)
  801ec8:	e8 89 ff ff ff       	call   801e56 <vsnprintf>
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ee5:	eb 06                	jmp    801eed <strlen+0x15>
		n++;
  801ee7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801eea:	ff 45 08             	incl   0x8(%ebp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8a 00                	mov    (%eax),%al
  801ef2:	84 c0                	test   %al,%al
  801ef4:	75 f1                	jne    801ee7 <strlen+0xf>
		n++;
	return n;
  801ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f08:	eb 09                	jmp    801f13 <strnlen+0x18>
		n++;
  801f0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f0d:	ff 45 08             	incl   0x8(%ebp)
  801f10:	ff 4d 0c             	decl   0xc(%ebp)
  801f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f17:	74 09                	je     801f22 <strnlen+0x27>
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8a 00                	mov    (%eax),%al
  801f1e:	84 c0                	test   %al,%al
  801f20:	75 e8                	jne    801f0a <strnlen+0xf>
		n++;
	return n;
  801f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f33:	90                   	nop
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	8d 50 01             	lea    0x1(%eax),%edx
  801f3a:	89 55 08             	mov    %edx,0x8(%ebp)
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f46:	8a 12                	mov    (%edx),%dl
  801f48:	88 10                	mov    %dl,(%eax)
  801f4a:	8a 00                	mov    (%eax),%al
  801f4c:	84 c0                	test   %al,%al
  801f4e:	75 e4                	jne    801f34 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f68:	eb 1f                	jmp    801f89 <strncpy+0x34>
		*dst++ = *src;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8d 50 01             	lea    0x1(%eax),%edx
  801f70:	89 55 08             	mov    %edx,0x8(%ebp)
  801f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f76:	8a 12                	mov    (%edx),%dl
  801f78:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7d:	8a 00                	mov    (%eax),%al
  801f7f:	84 c0                	test   %al,%al
  801f81:	74 03                	je     801f86 <strncpy+0x31>
			src++;
  801f83:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f86:	ff 45 fc             	incl   -0x4(%ebp)
  801f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f8f:	72 d9                	jb     801f6a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa6:	74 30                	je     801fd8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fa8:	eb 16                	jmp    801fc0 <strlcpy+0x2a>
			*dst++ = *src++;
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	8d 50 01             	lea    0x1(%eax),%edx
  801fb0:	89 55 08             	mov    %edx,0x8(%ebp)
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fbc:	8a 12                	mov    (%edx),%dl
  801fbe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fc0:	ff 4d 10             	decl   0x10(%ebp)
  801fc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fc7:	74 09                	je     801fd2 <strlcpy+0x3c>
  801fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcc:	8a 00                	mov    (%eax),%al
  801fce:	84 c0                	test   %al,%al
  801fd0:	75 d8                	jne    801faa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fde:	29 c2                	sub    %eax,%edx
  801fe0:	89 d0                	mov    %edx,%eax
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fe7:	eb 06                	jmp    801fef <strcmp+0xb>
		p++, q++;
  801fe9:	ff 45 08             	incl   0x8(%ebp)
  801fec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	8a 00                	mov    (%eax),%al
  801ff4:	84 c0                	test   %al,%al
  801ff6:	74 0e                	je     802006 <strcmp+0x22>
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	8a 10                	mov    (%eax),%dl
  801ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802000:	8a 00                	mov    (%eax),%al
  802002:	38 c2                	cmp    %al,%dl
  802004:	74 e3                	je     801fe9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8a 00                	mov    (%eax),%al
  80200b:	0f b6 d0             	movzbl %al,%edx
  80200e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802011:	8a 00                	mov    (%eax),%al
  802013:	0f b6 c0             	movzbl %al,%eax
  802016:	29 c2                	sub    %eax,%edx
  802018:	89 d0                	mov    %edx,%eax
}
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80201f:	eb 09                	jmp    80202a <strncmp+0xe>
		n--, p++, q++;
  802021:	ff 4d 10             	decl   0x10(%ebp)
  802024:	ff 45 08             	incl   0x8(%ebp)
  802027:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80202a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80202e:	74 17                	je     802047 <strncmp+0x2b>
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	8a 00                	mov    (%eax),%al
  802035:	84 c0                	test   %al,%al
  802037:	74 0e                	je     802047 <strncmp+0x2b>
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8a 10                	mov    (%eax),%dl
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	8a 00                	mov    (%eax),%al
  802043:	38 c2                	cmp    %al,%dl
  802045:	74 da                	je     802021 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802047:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80204b:	75 07                	jne    802054 <strncmp+0x38>
		return 0;
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
  802052:	eb 14                	jmp    802068 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8a 00                	mov    (%eax),%al
  802059:	0f b6 d0             	movzbl %al,%edx
  80205c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205f:	8a 00                	mov    (%eax),%al
  802061:	0f b6 c0             	movzbl %al,%eax
  802064:	29 c2                	sub    %eax,%edx
  802066:	89 d0                	mov    %edx,%eax
}
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    

0080206a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802076:	eb 12                	jmp    80208a <strchr+0x20>
		if (*s == c)
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8a 00                	mov    (%eax),%al
  80207d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802080:	75 05                	jne    802087 <strchr+0x1d>
			return (char *) s;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	eb 11                	jmp    802098 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802087:	ff 45 08             	incl   0x8(%ebp)
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8a 00                	mov    (%eax),%al
  80208f:	84 c0                	test   %al,%al
  802091:	75 e5                	jne    802078 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020a6:	eb 0d                	jmp    8020b5 <strfind+0x1b>
		if (*s == c)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8a 00                	mov    (%eax),%al
  8020ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020b0:	74 0e                	je     8020c0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020b2:	ff 45 08             	incl   0x8(%ebp)
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8a 00                	mov    (%eax),%al
  8020ba:	84 c0                	test   %al,%al
  8020bc:	75 ea                	jne    8020a8 <strfind+0xe>
  8020be:	eb 01                	jmp    8020c1 <strfind+0x27>
		if (*s == c)
			break;
  8020c0:	90                   	nop
	return (char *) s;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020d8:	eb 0e                	jmp    8020e8 <memset+0x22>
		*p++ = c;
  8020da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020dd:	8d 50 01             	lea    0x1(%eax),%edx
  8020e0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8020e8:	ff 4d f8             	decl   -0x8(%ebp)
  8020eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8020ef:	79 e9                	jns    8020da <memset+0x14>
		*p++ = c;

	return v;
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8020fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802108:	eb 16                	jmp    802120 <memcpy+0x2a>
		*d++ = *s++;
  80210a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80210d:	8d 50 01             	lea    0x1(%eax),%edx
  802110:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802113:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802116:	8d 4a 01             	lea    0x1(%edx),%ecx
  802119:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80211c:	8a 12                	mov    (%edx),%dl
  80211e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802120:	8b 45 10             	mov    0x10(%ebp),%eax
  802123:	8d 50 ff             	lea    -0x1(%eax),%edx
  802126:	89 55 10             	mov    %edx,0x10(%ebp)
  802129:	85 c0                	test   %eax,%eax
  80212b:	75 dd                	jne    80210a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802147:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80214a:	73 50                	jae    80219c <memmove+0x6a>
  80214c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214f:	8b 45 10             	mov    0x10(%ebp),%eax
  802152:	01 d0                	add    %edx,%eax
  802154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802157:	76 43                	jbe    80219c <memmove+0x6a>
		s += n;
  802159:	8b 45 10             	mov    0x10(%ebp),%eax
  80215c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80215f:	8b 45 10             	mov    0x10(%ebp),%eax
  802162:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802165:	eb 10                	jmp    802177 <memmove+0x45>
			*--d = *--s;
  802167:	ff 4d f8             	decl   -0x8(%ebp)
  80216a:	ff 4d fc             	decl   -0x4(%ebp)
  80216d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802170:	8a 10                	mov    (%eax),%dl
  802172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802175:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802177:	8b 45 10             	mov    0x10(%ebp),%eax
  80217a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80217d:	89 55 10             	mov    %edx,0x10(%ebp)
  802180:	85 c0                	test   %eax,%eax
  802182:	75 e3                	jne    802167 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802184:	eb 23                	jmp    8021a9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802189:	8d 50 01             	lea    0x1(%eax),%edx
  80218c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80218f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802192:	8d 4a 01             	lea    0x1(%edx),%ecx
  802195:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802198:	8a 12                	mov    (%edx),%dl
  80219a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80219c:	8b 45 10             	mov    0x10(%ebp),%eax
  80219f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 dd                	jne    802186 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021c0:	eb 2a                	jmp    8021ec <memcmp+0x3e>
		if (*s1 != *s2)
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c5:	8a 10                	mov    (%eax),%dl
  8021c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ca:	8a 00                	mov    (%eax),%al
  8021cc:	38 c2                	cmp    %al,%dl
  8021ce:	74 16                	je     8021e6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d3:	8a 00                	mov    (%eax),%al
  8021d5:	0f b6 d0             	movzbl %al,%edx
  8021d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021db:	8a 00                	mov    (%eax),%al
  8021dd:	0f b6 c0             	movzbl %al,%eax
  8021e0:	29 c2                	sub    %eax,%edx
  8021e2:	89 d0                	mov    %edx,%eax
  8021e4:	eb 18                	jmp    8021fe <memcmp+0x50>
		s1++, s2++;
  8021e6:	ff 45 fc             	incl   -0x4(%ebp)
  8021e9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	75 c9                	jne    8021c2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802206:	8b 55 08             	mov    0x8(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802211:	eb 15                	jmp    802228 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8a 00                	mov    (%eax),%al
  802218:	0f b6 d0             	movzbl %al,%edx
  80221b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221e:	0f b6 c0             	movzbl %al,%eax
  802221:	39 c2                	cmp    %eax,%edx
  802223:	74 0d                	je     802232 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802225:	ff 45 08             	incl   0x8(%ebp)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80222e:	72 e3                	jb     802213 <memfind+0x13>
  802230:	eb 01                	jmp    802233 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802232:	90                   	nop
	return (void *) s;
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80223e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802245:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80224c:	eb 03                	jmp    802251 <strtol+0x19>
		s++;
  80224e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	8a 00                	mov    (%eax),%al
  802256:	3c 20                	cmp    $0x20,%al
  802258:	74 f4                	je     80224e <strtol+0x16>
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8a 00                	mov    (%eax),%al
  80225f:	3c 09                	cmp    $0x9,%al
  802261:	74 eb                	je     80224e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8a 00                	mov    (%eax),%al
  802268:	3c 2b                	cmp    $0x2b,%al
  80226a:	75 05                	jne    802271 <strtol+0x39>
		s++;
  80226c:	ff 45 08             	incl   0x8(%ebp)
  80226f:	eb 13                	jmp    802284 <strtol+0x4c>
	else if (*s == '-')
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8a 00                	mov    (%eax),%al
  802276:	3c 2d                	cmp    $0x2d,%al
  802278:	75 0a                	jne    802284 <strtol+0x4c>
		s++, neg = 1;
  80227a:	ff 45 08             	incl   0x8(%ebp)
  80227d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802284:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802288:	74 06                	je     802290 <strtol+0x58>
  80228a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80228e:	75 20                	jne    8022b0 <strtol+0x78>
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	8a 00                	mov    (%eax),%al
  802295:	3c 30                	cmp    $0x30,%al
  802297:	75 17                	jne    8022b0 <strtol+0x78>
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	40                   	inc    %eax
  80229d:	8a 00                	mov    (%eax),%al
  80229f:	3c 78                	cmp    $0x78,%al
  8022a1:	75 0d                	jne    8022b0 <strtol+0x78>
		s += 2, base = 16;
  8022a3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022a7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022ae:	eb 28                	jmp    8022d8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b4:	75 15                	jne    8022cb <strtol+0x93>
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8a 00                	mov    (%eax),%al
  8022bb:	3c 30                	cmp    $0x30,%al
  8022bd:	75 0c                	jne    8022cb <strtol+0x93>
		s++, base = 8;
  8022bf:	ff 45 08             	incl   0x8(%ebp)
  8022c2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022c9:	eb 0d                	jmp    8022d8 <strtol+0xa0>
	else if (base == 0)
  8022cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022cf:	75 07                	jne    8022d8 <strtol+0xa0>
		base = 10;
  8022d1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8a 00                	mov    (%eax),%al
  8022dd:	3c 2f                	cmp    $0x2f,%al
  8022df:	7e 19                	jle    8022fa <strtol+0xc2>
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8a 00                	mov    (%eax),%al
  8022e6:	3c 39                	cmp    $0x39,%al
  8022e8:	7f 10                	jg     8022fa <strtol+0xc2>
			dig = *s - '0';
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8a 00                	mov    (%eax),%al
  8022ef:	0f be c0             	movsbl %al,%eax
  8022f2:	83 e8 30             	sub    $0x30,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f8:	eb 42                	jmp    80233c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8a 00                	mov    (%eax),%al
  8022ff:	3c 60                	cmp    $0x60,%al
  802301:	7e 19                	jle    80231c <strtol+0xe4>
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	8a 00                	mov    (%eax),%al
  802308:	3c 7a                	cmp    $0x7a,%al
  80230a:	7f 10                	jg     80231c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8a 00                	mov    (%eax),%al
  802311:	0f be c0             	movsbl %al,%eax
  802314:	83 e8 57             	sub    $0x57,%eax
  802317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231a:	eb 20                	jmp    80233c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8a 00                	mov    (%eax),%al
  802321:	3c 40                	cmp    $0x40,%al
  802323:	7e 39                	jle    80235e <strtol+0x126>
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8a 00                	mov    (%eax),%al
  80232a:	3c 5a                	cmp    $0x5a,%al
  80232c:	7f 30                	jg     80235e <strtol+0x126>
			dig = *s - 'A' + 10;
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8a 00                	mov    (%eax),%al
  802333:	0f be c0             	movsbl %al,%eax
  802336:	83 e8 37             	sub    $0x37,%eax
  802339:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802342:	7d 19                	jge    80235d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802344:	ff 45 08             	incl   0x8(%ebp)
  802347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80234a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80234e:	89 c2                	mov    %eax,%edx
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	01 d0                	add    %edx,%eax
  802355:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802358:	e9 7b ff ff ff       	jmp    8022d8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80235d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80235e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802362:	74 08                	je     80236c <strtol+0x134>
		*endptr = (char *) s;
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80236c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802370:	74 07                	je     802379 <strtol+0x141>
  802372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802375:	f7 d8                	neg    %eax
  802377:	eb 03                	jmp    80237c <strtol+0x144>
  802379:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <ltostr>:

void
ltostr(long value, char *str)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80238b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802396:	79 13                	jns    8023ab <ltostr+0x2d>
	{
		neg = 1;
  802398:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80239f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023a5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023a8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023b3:	99                   	cltd   
  8023b4:	f7 f9                	idiv   %ecx
  8023b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023bc:	8d 50 01             	lea    0x1(%eax),%edx
  8023bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023c2:	89 c2                	mov    %eax,%edx
  8023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c7:	01 d0                	add    %edx,%eax
  8023c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023cc:	83 c2 30             	add    $0x30,%edx
  8023cf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023d9:	f7 e9                	imul   %ecx
  8023db:	c1 fa 02             	sar    $0x2,%edx
  8023de:	89 c8                	mov    %ecx,%eax
  8023e0:	c1 f8 1f             	sar    $0x1f,%eax
  8023e3:	29 c2                	sub    %eax,%edx
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8023ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023f2:	f7 e9                	imul   %ecx
  8023f4:	c1 fa 02             	sar    $0x2,%edx
  8023f7:	89 c8                	mov    %ecx,%eax
  8023f9:	c1 f8 1f             	sar    $0x1f,%eax
  8023fc:	29 c2                	sub    %eax,%edx
  8023fe:	89 d0                	mov    %edx,%eax
  802400:	c1 e0 02             	shl    $0x2,%eax
  802403:	01 d0                	add    %edx,%eax
  802405:	01 c0                	add    %eax,%eax
  802407:	29 c1                	sub    %eax,%ecx
  802409:	89 ca                	mov    %ecx,%edx
  80240b:	85 d2                	test   %edx,%edx
  80240d:	75 9c                	jne    8023ab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80240f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802416:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802419:	48                   	dec    %eax
  80241a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80241d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802421:	74 3d                	je     802460 <ltostr+0xe2>
		start = 1 ;
  802423:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80242a:	eb 34                	jmp    802460 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80242c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802432:	01 d0                	add    %edx,%eax
  802434:	8a 00                	mov    (%eax),%al
  802436:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	01 c2                	add    %eax,%edx
  802441:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802444:	8b 45 0c             	mov    0xc(%ebp),%eax
  802447:	01 c8                	add    %ecx,%eax
  802449:	8a 00                	mov    (%eax),%al
  80244b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80244d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802450:	8b 45 0c             	mov    0xc(%ebp),%eax
  802453:	01 c2                	add    %eax,%edx
  802455:	8a 45 eb             	mov    -0x15(%ebp),%al
  802458:	88 02                	mov    %al,(%edx)
		start++ ;
  80245a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80245d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802466:	7c c4                	jl     80242c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802468:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80246b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246e:	01 d0                	add    %edx,%eax
  802470:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802473:	90                   	nop
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80247c:	ff 75 08             	pushl  0x8(%ebp)
  80247f:	e8 54 fa ff ff       	call   801ed8 <strlen>
  802484:	83 c4 04             	add    $0x4,%esp
  802487:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	e8 46 fa ff ff       	call   801ed8 <strlen>
  802492:	83 c4 04             	add    $0x4,%esp
  802495:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80249f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024a6:	eb 17                	jmp    8024bf <strcconcat+0x49>
		final[s] = str1[s] ;
  8024a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ae:	01 c2                	add    %eax,%edx
  8024b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	01 c8                	add    %ecx,%eax
  8024b8:	8a 00                	mov    (%eax),%al
  8024ba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024bc:	ff 45 fc             	incl   -0x4(%ebp)
  8024bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024c5:	7c e1                	jl     8024a8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024d5:	eb 1f                	jmp    8024f6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024da:	8d 50 01             	lea    0x1(%eax),%edx
  8024dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024e0:	89 c2                	mov    %eax,%edx
  8024e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e5:	01 c2                	add    %eax,%edx
  8024e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ed:	01 c8                	add    %ecx,%eax
  8024ef:	8a 00                	mov    (%eax),%al
  8024f1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024f3:	ff 45 f8             	incl   -0x8(%ebp)
  8024f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024fc:	7c d9                	jl     8024d7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802501:	8b 45 10             	mov    0x10(%ebp),%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	c6 00 00             	movb   $0x0,(%eax)
}
  802509:	90                   	nop
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80250f:	8b 45 14             	mov    0x14(%ebp),%eax
  802512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802518:	8b 45 14             	mov    0x14(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	01 d0                	add    %edx,%eax
  802529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80252f:	eb 0c                	jmp    80253d <strsplit+0x31>
			*string++ = 0;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8d 50 01             	lea    0x1(%eax),%edx
  802537:	89 55 08             	mov    %edx,0x8(%ebp)
  80253a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8a 00                	mov    (%eax),%al
  802542:	84 c0                	test   %al,%al
  802544:	74 18                	je     80255e <strsplit+0x52>
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8a 00                	mov    (%eax),%al
  80254b:	0f be c0             	movsbl %al,%eax
  80254e:	50                   	push   %eax
  80254f:	ff 75 0c             	pushl  0xc(%ebp)
  802552:	e8 13 fb ff ff       	call   80206a <strchr>
  802557:	83 c4 08             	add    $0x8,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	75 d3                	jne    802531 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8a 00                	mov    (%eax),%al
  802563:	84 c0                	test   %al,%al
  802565:	74 5a                	je     8025c1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802567:	8b 45 14             	mov    0x14(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	83 f8 0f             	cmp    $0xf,%eax
  80256f:	75 07                	jne    802578 <strsplit+0x6c>
		{
			return 0;
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
  802576:	eb 66                	jmp    8025de <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802578:	8b 45 14             	mov    0x14(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	8d 48 01             	lea    0x1(%eax),%ecx
  802580:	8b 55 14             	mov    0x14(%ebp),%edx
  802583:	89 0a                	mov    %ecx,(%edx)
  802585:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80258c:	8b 45 10             	mov    0x10(%ebp),%eax
  80258f:	01 c2                	add    %eax,%edx
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802596:	eb 03                	jmp    80259b <strsplit+0x8f>
			string++;
  802598:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	84 c0                	test   %al,%al
  8025a2:	74 8b                	je     80252f <strsplit+0x23>
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	8a 00                	mov    (%eax),%al
  8025a9:	0f be c0             	movsbl %al,%eax
  8025ac:	50                   	push   %eax
  8025ad:	ff 75 0c             	pushl  0xc(%ebp)
  8025b0:	e8 b5 fa ff ff       	call   80206a <strchr>
  8025b5:	83 c4 08             	add    $0x8,%esp
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 dc                	je     802598 <strsplit+0x8c>
			string++;
	}
  8025bc:	e9 6e ff ff ff       	jmp    80252f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025c1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d1:	01 d0                	add    %edx,%eax
  8025d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 f0 37 80 00       	push   $0x8037f0
  8025ee:	6a 0e                	push   $0xe
  8025f0:	68 2a 38 80 00       	push   $0x80382a
  8025f5:	e8 a8 ef ff ff       	call   8015a2 <_panic>

008025fa <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  802600:	a1 04 40 80 00       	mov    0x804004,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	74 0f                	je     802618 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  802609:	e8 d2 ff ff ff       	call   8025e0 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80260e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802615:	00 00 00 
	}
	if (size == 0) return NULL ;
  802618:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261c:	75 07                	jne    802625 <malloc+0x2b>
  80261e:	b8 00 00 00 00       	mov    $0x0,%eax
  802623:	eb 14                	jmp    802639 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802625:	83 ec 04             	sub    $0x4,%esp
  802628:	68 38 38 80 00       	push   $0x803838
  80262d:	6a 2e                	push   $0x2e
  80262f:	68 2a 38 80 00       	push   $0x80382a
  802634:	e8 69 ef ff ff       	call   8015a2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 60 38 80 00       	push   $0x803860
  802649:	6a 49                	push   $0x49
  80264b:	68 2a 38 80 00       	push   $0x80382a
  802650:	e8 4d ef ff ff       	call   8015a2 <_panic>

00802655 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 18             	sub    $0x18,%esp
  80265b:	8b 45 10             	mov    0x10(%ebp),%eax
  80265e:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802661:	83 ec 04             	sub    $0x4,%esp
  802664:	68 84 38 80 00       	push   $0x803884
  802669:	6a 57                	push   $0x57
  80266b:	68 2a 38 80 00       	push   $0x80382a
  802670:	e8 2d ef ff ff       	call   8015a2 <_panic>

00802675 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	68 ac 38 80 00       	push   $0x8038ac
  802683:	6a 60                	push   $0x60
  802685:	68 2a 38 80 00       	push   $0x80382a
  80268a:	e8 13 ef ff ff       	call   8015a2 <_panic>

0080268f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 d0 38 80 00       	push   $0x8038d0
  80269d:	6a 7c                	push   $0x7c
  80269f:	68 2a 38 80 00       	push   $0x80382a
  8026a4:	e8 f9 ee ff ff       	call   8015a2 <_panic>

008026a9 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8026af:	83 ec 04             	sub    $0x4,%esp
  8026b2:	68 f8 38 80 00       	push   $0x8038f8
  8026b7:	68 86 00 00 00       	push   $0x86
  8026bc:	68 2a 38 80 00       	push   $0x80382a
  8026c1:	e8 dc ee ff ff       	call   8015a2 <_panic>

008026c6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 1c 39 80 00       	push   $0x80391c
  8026d4:	68 91 00 00 00       	push   $0x91
  8026d9:	68 2a 38 80 00       	push   $0x80382a
  8026de:	e8 bf ee ff ff       	call   8015a2 <_panic>

008026e3 <shrink>:

}
void shrink(uint32 newSize)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 1c 39 80 00       	push   $0x80391c
  8026f1:	68 96 00 00 00       	push   $0x96
  8026f6:	68 2a 38 80 00       	push   $0x80382a
  8026fb:	e8 a2 ee ff ff       	call   8015a2 <_panic>

00802700 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	68 1c 39 80 00       	push   $0x80391c
  80270e:	68 9b 00 00 00       	push   $0x9b
  802713:	68 2a 38 80 00       	push   $0x80382a
  802718:	e8 85 ee ff ff       	call   8015a2 <_panic>

0080271d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	57                   	push   %edi
  802721:	56                   	push   %esi
  802722:	53                   	push   %ebx
  802723:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80272f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802732:	8b 7d 18             	mov    0x18(%ebp),%edi
  802735:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802738:	cd 30                	int    $0x30
  80273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802740:	83 c4 10             	add    $0x10,%esp
  802743:	5b                   	pop    %ebx
  802744:	5e                   	pop    %esi
  802745:	5f                   	pop    %edi
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	8b 45 10             	mov    0x10(%ebp),%eax
  802751:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802754:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	52                   	push   %edx
  802760:	ff 75 0c             	pushl  0xc(%ebp)
  802763:	50                   	push   %eax
  802764:	6a 00                	push   $0x0
  802766:	e8 b2 ff ff ff       	call   80271d <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	90                   	nop
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_cgetc>:

int
sys_cgetc(void)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 01                	push   $0x1
  802780:	e8 98 ff ff ff       	call   80271d <syscall>
  802785:	83 c4 18             	add    $0x18,%esp
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80278d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	52                   	push   %edx
  80279a:	50                   	push   %eax
  80279b:	6a 05                	push   $0x5
  80279d:	e8 7b ff ff ff       	call   80271d <syscall>
  8027a2:	83 c4 18             	add    $0x18,%esp
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	56                   	push   %esi
  8027ab:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027ac:	8b 75 18             	mov    0x18(%ebp),%esi
  8027af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	56                   	push   %esi
  8027bc:	53                   	push   %ebx
  8027bd:	51                   	push   %ecx
  8027be:	52                   	push   %edx
  8027bf:	50                   	push   %eax
  8027c0:	6a 06                	push   $0x6
  8027c2:	e8 56 ff ff ff       	call   80271d <syscall>
  8027c7:	83 c4 18             	add    $0x18,%esp
}
  8027ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    

008027d1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8027d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	52                   	push   %edx
  8027e1:	50                   	push   %eax
  8027e2:	6a 07                	push   $0x7
  8027e4:	e8 34 ff ff ff       	call   80271d <syscall>
  8027e9:	83 c4 18             	add    $0x18,%esp
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	ff 75 0c             	pushl  0xc(%ebp)
  8027fa:	ff 75 08             	pushl  0x8(%ebp)
  8027fd:	6a 08                	push   $0x8
  8027ff:	e8 19 ff ff ff       	call   80271d <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 09                	push   $0x9
  802818:	e8 00 ff ff ff       	call   80271d <syscall>
  80281d:	83 c4 18             	add    $0x18,%esp
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 0a                	push   $0xa
  802831:	e8 e7 fe ff ff       	call   80271d <syscall>
  802836:	83 c4 18             	add    $0x18,%esp
}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 0b                	push   $0xb
  80284a:	e8 ce fe ff ff       	call   80271d <syscall>
  80284f:	83 c4 18             	add    $0x18,%esp
}
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	ff 75 0c             	pushl  0xc(%ebp)
  802860:	ff 75 08             	pushl  0x8(%ebp)
  802863:	6a 0f                	push   $0xf
  802865:	e8 b3 fe ff ff       	call   80271d <syscall>
  80286a:	83 c4 18             	add    $0x18,%esp
	return;
  80286d:	90                   	nop
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	ff 75 0c             	pushl  0xc(%ebp)
  80287c:	ff 75 08             	pushl  0x8(%ebp)
  80287f:	6a 10                	push   $0x10
  802881:	e8 97 fe ff ff       	call   80271d <syscall>
  802886:	83 c4 18             	add    $0x18,%esp
	return ;
  802889:	90                   	nop
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	ff 75 10             	pushl  0x10(%ebp)
  802896:	ff 75 0c             	pushl  0xc(%ebp)
  802899:	ff 75 08             	pushl  0x8(%ebp)
  80289c:	6a 11                	push   $0x11
  80289e:	e8 7a fe ff ff       	call   80271d <syscall>
  8028a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a6:	90                   	nop
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 0c                	push   $0xc
  8028b8:	e8 60 fe ff ff       	call   80271d <syscall>
  8028bd:	83 c4 18             	add    $0x18,%esp
}
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	ff 75 08             	pushl  0x8(%ebp)
  8028d0:	6a 0d                	push   $0xd
  8028d2:	e8 46 fe ff ff       	call   80271d <syscall>
  8028d7:	83 c4 18             	add    $0x18,%esp
}
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 0e                	push   $0xe
  8028eb:	e8 2d fe ff ff       	call   80271d <syscall>
  8028f0:	83 c4 18             	add    $0x18,%esp
}
  8028f3:	90                   	nop
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	6a 13                	push   $0x13
  802905:	e8 13 fe ff ff       	call   80271d <syscall>
  80290a:	83 c4 18             	add    $0x18,%esp
}
  80290d:	90                   	nop
  80290e:	c9                   	leave  
  80290f:	c3                   	ret    

00802910 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 14                	push   $0x14
  80291f:	e8 f9 fd ff ff       	call   80271d <syscall>
  802924:	83 c4 18             	add    $0x18,%esp
}
  802927:	90                   	nop
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <sys_cputc>:


void
sys_cputc(const char c)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802936:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	50                   	push   %eax
  802943:	6a 15                	push   $0x15
  802945:	e8 d3 fd ff ff       	call   80271d <syscall>
  80294a:	83 c4 18             	add    $0x18,%esp
}
  80294d:	90                   	nop
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 16                	push   $0x16
  80295f:	e8 b9 fd ff ff       	call   80271d <syscall>
  802964:	83 c4 18             	add    $0x18,%esp
}
  802967:	90                   	nop
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	ff 75 0c             	pushl  0xc(%ebp)
  802979:	50                   	push   %eax
  80297a:	6a 17                	push   $0x17
  80297c:	e8 9c fd ff ff       	call   80271d <syscall>
  802981:	83 c4 18             	add    $0x18,%esp
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	6a 00                	push   $0x0
  802991:	6a 00                	push   $0x0
  802993:	6a 00                	push   $0x0
  802995:	52                   	push   %edx
  802996:	50                   	push   %eax
  802997:	6a 1a                	push   $0x1a
  802999:	e8 7f fd ff ff       	call   80271d <syscall>
  80299e:	83 c4 18             	add    $0x18,%esp
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	52                   	push   %edx
  8029b3:	50                   	push   %eax
  8029b4:	6a 18                	push   $0x18
  8029b6:	e8 62 fd ff ff       	call   80271d <syscall>
  8029bb:	83 c4 18             	add    $0x18,%esp
}
  8029be:	90                   	nop
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	52                   	push   %edx
  8029d1:	50                   	push   %eax
  8029d2:	6a 19                	push   $0x19
  8029d4:	e8 44 fd ff ff       	call   80271d <syscall>
  8029d9:	83 c4 18             	add    $0x18,%esp
}
  8029dc:	90                   	nop
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8029e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8029eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	6a 00                	push   $0x0
  8029f7:	51                   	push   %ecx
  8029f8:	52                   	push   %edx
  8029f9:	ff 75 0c             	pushl  0xc(%ebp)
  8029fc:	50                   	push   %eax
  8029fd:	6a 1b                	push   $0x1b
  8029ff:	e8 19 fd ff ff       	call   80271d <syscall>
  802a04:	83 c4 18             	add    $0x18,%esp
}
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    

00802a09 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	52                   	push   %edx
  802a19:	50                   	push   %eax
  802a1a:	6a 1c                	push   $0x1c
  802a1c:	e8 fc fc ff ff       	call   80271d <syscall>
  802a21:	83 c4 18             	add    $0x18,%esp
}
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	51                   	push   %ecx
  802a37:	52                   	push   %edx
  802a38:	50                   	push   %eax
  802a39:	6a 1d                	push   $0x1d
  802a3b:	e8 dd fc ff ff       	call   80271d <syscall>
  802a40:	83 c4 18             	add    $0x18,%esp
}
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	52                   	push   %edx
  802a55:	50                   	push   %eax
  802a56:	6a 1e                	push   $0x1e
  802a58:	e8 c0 fc ff ff       	call   80271d <syscall>
  802a5d:	83 c4 18             	add    $0x18,%esp
}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 1f                	push   $0x1f
  802a71:	e8 a7 fc ff ff       	call   80271d <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	6a 00                	push   $0x0
  802a83:	ff 75 14             	pushl  0x14(%ebp)
  802a86:	ff 75 10             	pushl  0x10(%ebp)
  802a89:	ff 75 0c             	pushl  0xc(%ebp)
  802a8c:	50                   	push   %eax
  802a8d:	6a 20                	push   $0x20
  802a8f:	e8 89 fc ff ff       	call   80271d <syscall>
  802a94:	83 c4 18             	add    $0x18,%esp
}
  802a97:	c9                   	leave  
  802a98:	c3                   	ret    

00802a99 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	50                   	push   %eax
  802aa8:	6a 21                	push   $0x21
  802aaa:	e8 6e fc ff ff       	call   80271d <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
}
  802ab2:	90                   	nop
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	50                   	push   %eax
  802ac4:	6a 22                	push   $0x22
  802ac6:	e8 52 fc ff ff       	call   80271d <syscall>
  802acb:	83 c4 18             	add    $0x18,%esp
}
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 02                	push   $0x2
  802adf:	e8 39 fc ff ff       	call   80271d <syscall>
  802ae4:	83 c4 18             	add    $0x18,%esp
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 03                	push   $0x3
  802af8:	e8 20 fc ff ff       	call   80271d <syscall>
  802afd:	83 c4 18             	add    $0x18,%esp
}
  802b00:	c9                   	leave  
  802b01:	c3                   	ret    

00802b02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 04                	push   $0x4
  802b11:	e8 07 fc ff ff       	call   80271d <syscall>
  802b16:	83 c4 18             	add    $0x18,%esp
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <sys_exit_env>:


void sys_exit_env(void)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 23                	push   $0x23
  802b2a:	e8 ee fb ff ff       	call   80271d <syscall>
  802b2f:	83 c4 18             	add    $0x18,%esp
}
  802b32:	90                   	nop
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
  802b38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b3e:	8d 50 04             	lea    0x4(%eax),%edx
  802b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	6a 00                	push   $0x0
  802b4a:	52                   	push   %edx
  802b4b:	50                   	push   %eax
  802b4c:	6a 24                	push   $0x24
  802b4e:	e8 ca fb ff ff       	call   80271d <syscall>
  802b53:	83 c4 18             	add    $0x18,%esp
	return result;
  802b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b5f:	89 01                	mov    %eax,(%ecx)
  802b61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	c9                   	leave  
  802b68:	c2 04 00             	ret    $0x4

00802b6b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	ff 75 10             	pushl  0x10(%ebp)
  802b75:	ff 75 0c             	pushl  0xc(%ebp)
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	6a 12                	push   $0x12
  802b7d:	e8 9b fb ff ff       	call   80271d <syscall>
  802b82:	83 c4 18             	add    $0x18,%esp
	return ;
  802b85:	90                   	nop
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 25                	push   $0x25
  802b97:	e8 81 fb ff ff       	call   80271d <syscall>
  802b9c:	83 c4 18             	add    $0x18,%esp
}
  802b9f:	c9                   	leave  
  802ba0:	c3                   	ret    

00802ba1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802ba1:	55                   	push   %ebp
  802ba2:	89 e5                	mov    %esp,%ebp
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 00                	push   $0x0
  802bb9:	50                   	push   %eax
  802bba:	6a 26                	push   $0x26
  802bbc:	e8 5c fb ff ff       	call   80271d <syscall>
  802bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  802bc4:	90                   	nop
}
  802bc5:	c9                   	leave  
  802bc6:	c3                   	ret    

00802bc7 <rsttst>:
void rsttst()
{
  802bc7:	55                   	push   %ebp
  802bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 28                	push   $0x28
  802bd6:	e8 42 fb ff ff       	call   80271d <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  802bde:	90                   	nop
}
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	8b 45 14             	mov    0x14(%ebp),%eax
  802bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bed:	8b 55 18             	mov    0x18(%ebp),%edx
  802bf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bf4:	52                   	push   %edx
  802bf5:	50                   	push   %eax
  802bf6:	ff 75 10             	pushl  0x10(%ebp)
  802bf9:	ff 75 0c             	pushl  0xc(%ebp)
  802bfc:	ff 75 08             	pushl  0x8(%ebp)
  802bff:	6a 27                	push   $0x27
  802c01:	e8 17 fb ff ff       	call   80271d <syscall>
  802c06:	83 c4 18             	add    $0x18,%esp
	return ;
  802c09:	90                   	nop
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <chktst>:
void chktst(uint32 n)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	6a 29                	push   $0x29
  802c1c:	e8 fc fa ff ff       	call   80271d <syscall>
  802c21:	83 c4 18             	add    $0x18,%esp
	return ;
  802c24:	90                   	nop
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <inctst>:

void inctst()
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 2a                	push   $0x2a
  802c36:	e8 e2 fa ff ff       	call   80271d <syscall>
  802c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c3e:	90                   	nop
}
  802c3f:	c9                   	leave  
  802c40:	c3                   	ret    

00802c41 <gettst>:
uint32 gettst()
{
  802c41:	55                   	push   %ebp
  802c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c44:	6a 00                	push   $0x0
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	6a 00                	push   $0x0
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 2b                	push   $0x2b
  802c50:	e8 c8 fa ff ff       	call   80271d <syscall>
  802c55:	83 c4 18             	add    $0x18,%esp
}
  802c58:	c9                   	leave  
  802c59:	c3                   	ret    

00802c5a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 2c                	push   $0x2c
  802c6c:	e8 ac fa ff ff       	call   80271d <syscall>
  802c71:	83 c4 18             	add    $0x18,%esp
  802c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c77:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c7b:	75 07                	jne    802c84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c82:	eb 05                	jmp    802c89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c89:	c9                   	leave  
  802c8a:	c3                   	ret    

00802c8b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c8b:	55                   	push   %ebp
  802c8c:	89 e5                	mov    %esp,%ebp
  802c8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 00                	push   $0x0
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 2c                	push   $0x2c
  802c9d:	e8 7b fa ff ff       	call   80271d <syscall>
  802ca2:	83 c4 18             	add    $0x18,%esp
  802ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ca8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802cac:	75 07                	jne    802cb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802cae:	b8 01 00 00 00       	mov    $0x1,%eax
  802cb3:	eb 05                	jmp    802cba <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cba:	c9                   	leave  
  802cbb:	c3                   	ret    

00802cbc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 2c                	push   $0x2c
  802cce:	e8 4a fa ff ff       	call   80271d <syscall>
  802cd3:	83 c4 18             	add    $0x18,%esp
  802cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802cd9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802cdd:	75 07                	jne    802ce6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802cdf:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce4:	eb 05                	jmp    802ceb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
  802cf0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 2c                	push   $0x2c
  802cff:	e8 19 fa ff ff       	call   80271d <syscall>
  802d04:	83 c4 18             	add    $0x18,%esp
  802d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802d0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802d0e:	75 07                	jne    802d17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802d10:	b8 01 00 00 00       	mov    $0x1,%eax
  802d15:	eb 05                	jmp    802d1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1c:	c9                   	leave  
  802d1d:	c3                   	ret    

00802d1e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d1e:	55                   	push   %ebp
  802d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	ff 75 08             	pushl  0x8(%ebp)
  802d2c:	6a 2d                	push   $0x2d
  802d2e:	e8 ea f9 ff ff       	call   80271d <syscall>
  802d33:	83 c4 18             	add    $0x18,%esp
	return ;
  802d36:	90                   	nop
}
  802d37:	c9                   	leave  
  802d38:	c3                   	ret    

00802d39 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d39:	55                   	push   %ebp
  802d3a:	89 e5                	mov    %esp,%ebp
  802d3c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	6a 00                	push   $0x0
  802d4b:	53                   	push   %ebx
  802d4c:	51                   	push   %ecx
  802d4d:	52                   	push   %edx
  802d4e:	50                   	push   %eax
  802d4f:	6a 2e                	push   $0x2e
  802d51:	e8 c7 f9 ff ff       	call   80271d <syscall>
  802d56:	83 c4 18             	add    $0x18,%esp
}
  802d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d5c:	c9                   	leave  
  802d5d:	c3                   	ret    

00802d5e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d5e:	55                   	push   %ebp
  802d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	52                   	push   %edx
  802d6e:	50                   	push   %eax
  802d6f:	6a 2f                	push   $0x2f
  802d71:	e8 a7 f9 ff ff       	call   80271d <syscall>
  802d76:	83 c4 18             	add    $0x18,%esp
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    
  802d7b:	90                   	nop

00802d7c <__udivdi3>:
  802d7c:	55                   	push   %ebp
  802d7d:	57                   	push   %edi
  802d7e:	56                   	push   %esi
  802d7f:	53                   	push   %ebx
  802d80:	83 ec 1c             	sub    $0x1c,%esp
  802d83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d93:	89 ca                	mov    %ecx,%edx
  802d95:	89 f8                	mov    %edi,%eax
  802d97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d9b:	85 f6                	test   %esi,%esi
  802d9d:	75 2d                	jne    802dcc <__udivdi3+0x50>
  802d9f:	39 cf                	cmp    %ecx,%edi
  802da1:	77 65                	ja     802e08 <__udivdi3+0x8c>
  802da3:	89 fd                	mov    %edi,%ebp
  802da5:	85 ff                	test   %edi,%edi
  802da7:	75 0b                	jne    802db4 <__udivdi3+0x38>
  802da9:	b8 01 00 00 00       	mov    $0x1,%eax
  802dae:	31 d2                	xor    %edx,%edx
  802db0:	f7 f7                	div    %edi
  802db2:	89 c5                	mov    %eax,%ebp
  802db4:	31 d2                	xor    %edx,%edx
  802db6:	89 c8                	mov    %ecx,%eax
  802db8:	f7 f5                	div    %ebp
  802dba:	89 c1                	mov    %eax,%ecx
  802dbc:	89 d8                	mov    %ebx,%eax
  802dbe:	f7 f5                	div    %ebp
  802dc0:	89 cf                	mov    %ecx,%edi
  802dc2:	89 fa                	mov    %edi,%edx
  802dc4:	83 c4 1c             	add    $0x1c,%esp
  802dc7:	5b                   	pop    %ebx
  802dc8:	5e                   	pop    %esi
  802dc9:	5f                   	pop    %edi
  802dca:	5d                   	pop    %ebp
  802dcb:	c3                   	ret    
  802dcc:	39 ce                	cmp    %ecx,%esi
  802dce:	77 28                	ja     802df8 <__udivdi3+0x7c>
  802dd0:	0f bd fe             	bsr    %esi,%edi
  802dd3:	83 f7 1f             	xor    $0x1f,%edi
  802dd6:	75 40                	jne    802e18 <__udivdi3+0x9c>
  802dd8:	39 ce                	cmp    %ecx,%esi
  802dda:	72 0a                	jb     802de6 <__udivdi3+0x6a>
  802ddc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802de0:	0f 87 9e 00 00 00    	ja     802e84 <__udivdi3+0x108>
  802de6:	b8 01 00 00 00       	mov    $0x1,%eax
  802deb:	89 fa                	mov    %edi,%edx
  802ded:	83 c4 1c             	add    $0x1c,%esp
  802df0:	5b                   	pop    %ebx
  802df1:	5e                   	pop    %esi
  802df2:	5f                   	pop    %edi
  802df3:	5d                   	pop    %ebp
  802df4:	c3                   	ret    
  802df5:	8d 76 00             	lea    0x0(%esi),%esi
  802df8:	31 ff                	xor    %edi,%edi
  802dfa:	31 c0                	xor    %eax,%eax
  802dfc:	89 fa                	mov    %edi,%edx
  802dfe:	83 c4 1c             	add    $0x1c,%esp
  802e01:	5b                   	pop    %ebx
  802e02:	5e                   	pop    %esi
  802e03:	5f                   	pop    %edi
  802e04:	5d                   	pop    %ebp
  802e05:	c3                   	ret    
  802e06:	66 90                	xchg   %ax,%ax
  802e08:	89 d8                	mov    %ebx,%eax
  802e0a:	f7 f7                	div    %edi
  802e0c:	31 ff                	xor    %edi,%edi
  802e0e:	89 fa                	mov    %edi,%edx
  802e10:	83 c4 1c             	add    $0x1c,%esp
  802e13:	5b                   	pop    %ebx
  802e14:	5e                   	pop    %esi
  802e15:	5f                   	pop    %edi
  802e16:	5d                   	pop    %ebp
  802e17:	c3                   	ret    
  802e18:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e1d:	89 eb                	mov    %ebp,%ebx
  802e1f:	29 fb                	sub    %edi,%ebx
  802e21:	89 f9                	mov    %edi,%ecx
  802e23:	d3 e6                	shl    %cl,%esi
  802e25:	89 c5                	mov    %eax,%ebp
  802e27:	88 d9                	mov    %bl,%cl
  802e29:	d3 ed                	shr    %cl,%ebp
  802e2b:	89 e9                	mov    %ebp,%ecx
  802e2d:	09 f1                	or     %esi,%ecx
  802e2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e33:	89 f9                	mov    %edi,%ecx
  802e35:	d3 e0                	shl    %cl,%eax
  802e37:	89 c5                	mov    %eax,%ebp
  802e39:	89 d6                	mov    %edx,%esi
  802e3b:	88 d9                	mov    %bl,%cl
  802e3d:	d3 ee                	shr    %cl,%esi
  802e3f:	89 f9                	mov    %edi,%ecx
  802e41:	d3 e2                	shl    %cl,%edx
  802e43:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e47:	88 d9                	mov    %bl,%cl
  802e49:	d3 e8                	shr    %cl,%eax
  802e4b:	09 c2                	or     %eax,%edx
  802e4d:	89 d0                	mov    %edx,%eax
  802e4f:	89 f2                	mov    %esi,%edx
  802e51:	f7 74 24 0c          	divl   0xc(%esp)
  802e55:	89 d6                	mov    %edx,%esi
  802e57:	89 c3                	mov    %eax,%ebx
  802e59:	f7 e5                	mul    %ebp
  802e5b:	39 d6                	cmp    %edx,%esi
  802e5d:	72 19                	jb     802e78 <__udivdi3+0xfc>
  802e5f:	74 0b                	je     802e6c <__udivdi3+0xf0>
  802e61:	89 d8                	mov    %ebx,%eax
  802e63:	31 ff                	xor    %edi,%edi
  802e65:	e9 58 ff ff ff       	jmp    802dc2 <__udivdi3+0x46>
  802e6a:	66 90                	xchg   %ax,%ax
  802e6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e70:	89 f9                	mov    %edi,%ecx
  802e72:	d3 e2                	shl    %cl,%edx
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	73 e9                	jae    802e61 <__udivdi3+0xe5>
  802e78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e7b:	31 ff                	xor    %edi,%edi
  802e7d:	e9 40 ff ff ff       	jmp    802dc2 <__udivdi3+0x46>
  802e82:	66 90                	xchg   %ax,%ax
  802e84:	31 c0                	xor    %eax,%eax
  802e86:	e9 37 ff ff ff       	jmp    802dc2 <__udivdi3+0x46>
  802e8b:	90                   	nop

00802e8c <__umoddi3>:
  802e8c:	55                   	push   %ebp
  802e8d:	57                   	push   %edi
  802e8e:	56                   	push   %esi
  802e8f:	53                   	push   %ebx
  802e90:	83 ec 1c             	sub    $0x1c,%esp
  802e93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e97:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ea7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802eab:	89 f3                	mov    %esi,%ebx
  802ead:	89 fa                	mov    %edi,%edx
  802eaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802eb3:	89 34 24             	mov    %esi,(%esp)
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	75 1a                	jne    802ed4 <__umoddi3+0x48>
  802eba:	39 f7                	cmp    %esi,%edi
  802ebc:	0f 86 a2 00 00 00    	jbe    802f64 <__umoddi3+0xd8>
  802ec2:	89 c8                	mov    %ecx,%eax
  802ec4:	89 f2                	mov    %esi,%edx
  802ec6:	f7 f7                	div    %edi
  802ec8:	89 d0                	mov    %edx,%eax
  802eca:	31 d2                	xor    %edx,%edx
  802ecc:	83 c4 1c             	add    $0x1c,%esp
  802ecf:	5b                   	pop    %ebx
  802ed0:	5e                   	pop    %esi
  802ed1:	5f                   	pop    %edi
  802ed2:	5d                   	pop    %ebp
  802ed3:	c3                   	ret    
  802ed4:	39 f0                	cmp    %esi,%eax
  802ed6:	0f 87 ac 00 00 00    	ja     802f88 <__umoddi3+0xfc>
  802edc:	0f bd e8             	bsr    %eax,%ebp
  802edf:	83 f5 1f             	xor    $0x1f,%ebp
  802ee2:	0f 84 ac 00 00 00    	je     802f94 <__umoddi3+0x108>
  802ee8:	bf 20 00 00 00       	mov    $0x20,%edi
  802eed:	29 ef                	sub    %ebp,%edi
  802eef:	89 fe                	mov    %edi,%esi
  802ef1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ef5:	89 e9                	mov    %ebp,%ecx
  802ef7:	d3 e0                	shl    %cl,%eax
  802ef9:	89 d7                	mov    %edx,%edi
  802efb:	89 f1                	mov    %esi,%ecx
  802efd:	d3 ef                	shr    %cl,%edi
  802eff:	09 c7                	or     %eax,%edi
  802f01:	89 e9                	mov    %ebp,%ecx
  802f03:	d3 e2                	shl    %cl,%edx
  802f05:	89 14 24             	mov    %edx,(%esp)
  802f08:	89 d8                	mov    %ebx,%eax
  802f0a:	d3 e0                	shl    %cl,%eax
  802f0c:	89 c2                	mov    %eax,%edx
  802f0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f12:	d3 e0                	shl    %cl,%eax
  802f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f18:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f1c:	89 f1                	mov    %esi,%ecx
  802f1e:	d3 e8                	shr    %cl,%eax
  802f20:	09 d0                	or     %edx,%eax
  802f22:	d3 eb                	shr    %cl,%ebx
  802f24:	89 da                	mov    %ebx,%edx
  802f26:	f7 f7                	div    %edi
  802f28:	89 d3                	mov    %edx,%ebx
  802f2a:	f7 24 24             	mull   (%esp)
  802f2d:	89 c6                	mov    %eax,%esi
  802f2f:	89 d1                	mov    %edx,%ecx
  802f31:	39 d3                	cmp    %edx,%ebx
  802f33:	0f 82 87 00 00 00    	jb     802fc0 <__umoddi3+0x134>
  802f39:	0f 84 91 00 00 00    	je     802fd0 <__umoddi3+0x144>
  802f3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f43:	29 f2                	sub    %esi,%edx
  802f45:	19 cb                	sbb    %ecx,%ebx
  802f47:	89 d8                	mov    %ebx,%eax
  802f49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f4d:	d3 e0                	shl    %cl,%eax
  802f4f:	89 e9                	mov    %ebp,%ecx
  802f51:	d3 ea                	shr    %cl,%edx
  802f53:	09 d0                	or     %edx,%eax
  802f55:	89 e9                	mov    %ebp,%ecx
  802f57:	d3 eb                	shr    %cl,%ebx
  802f59:	89 da                	mov    %ebx,%edx
  802f5b:	83 c4 1c             	add    $0x1c,%esp
  802f5e:	5b                   	pop    %ebx
  802f5f:	5e                   	pop    %esi
  802f60:	5f                   	pop    %edi
  802f61:	5d                   	pop    %ebp
  802f62:	c3                   	ret    
  802f63:	90                   	nop
  802f64:	89 fd                	mov    %edi,%ebp
  802f66:	85 ff                	test   %edi,%edi
  802f68:	75 0b                	jne    802f75 <__umoddi3+0xe9>
  802f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f6f:	31 d2                	xor    %edx,%edx
  802f71:	f7 f7                	div    %edi
  802f73:	89 c5                	mov    %eax,%ebp
  802f75:	89 f0                	mov    %esi,%eax
  802f77:	31 d2                	xor    %edx,%edx
  802f79:	f7 f5                	div    %ebp
  802f7b:	89 c8                	mov    %ecx,%eax
  802f7d:	f7 f5                	div    %ebp
  802f7f:	89 d0                	mov    %edx,%eax
  802f81:	e9 44 ff ff ff       	jmp    802eca <__umoddi3+0x3e>
  802f86:	66 90                	xchg   %ax,%ax
  802f88:	89 c8                	mov    %ecx,%eax
  802f8a:	89 f2                	mov    %esi,%edx
  802f8c:	83 c4 1c             	add    $0x1c,%esp
  802f8f:	5b                   	pop    %ebx
  802f90:	5e                   	pop    %esi
  802f91:	5f                   	pop    %edi
  802f92:	5d                   	pop    %ebp
  802f93:	c3                   	ret    
  802f94:	3b 04 24             	cmp    (%esp),%eax
  802f97:	72 06                	jb     802f9f <__umoddi3+0x113>
  802f99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f9d:	77 0f                	ja     802fae <__umoddi3+0x122>
  802f9f:	89 f2                	mov    %esi,%edx
  802fa1:	29 f9                	sub    %edi,%ecx
  802fa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802fa7:	89 14 24             	mov    %edx,(%esp)
  802faa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fae:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fb2:	8b 14 24             	mov    (%esp),%edx
  802fb5:	83 c4 1c             	add    $0x1c,%esp
  802fb8:	5b                   	pop    %ebx
  802fb9:	5e                   	pop    %esi
  802fba:	5f                   	pop    %edi
  802fbb:	5d                   	pop    %ebp
  802fbc:	c3                   	ret    
  802fbd:	8d 76 00             	lea    0x0(%esi),%esi
  802fc0:	2b 04 24             	sub    (%esp),%eax
  802fc3:	19 fa                	sbb    %edi,%edx
  802fc5:	89 d1                	mov    %edx,%ecx
  802fc7:	89 c6                	mov    %eax,%esi
  802fc9:	e9 71 ff ff ff       	jmp    802f3f <__umoddi3+0xb3>
  802fce:	66 90                	xchg   %ax,%ax
  802fd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fd4:	72 ea                	jb     802fc0 <__umoddi3+0x134>
  802fd6:	89 d9                	mov    %ebx,%ecx
  802fd8:	e9 62 ff ff ff       	jmp    802f3f <__umoddi3+0xb3>
