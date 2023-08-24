
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 35 25 00 00       	call   802582 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 40 80 00       	mov    0x804020,%eax
  800062:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 40 80 00       	mov    0x804020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 60 28 80 00       	push   $0x802860
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 7c 28 80 00       	push   $0x80287c
  8000aa:	e8 57 0d 00 00       	call   800e06 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 a5 1d 00 00       	call   801e5e <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 90 28 80 00       	push   $0x802890
  8000fc:	68 a7 28 80 00       	push   $0x8028a7
  800101:	6a 24                	push   $0x24
  800103:	68 7c 28 80 00       	push   $0x80287c
  800108:	e8 f9 0c 00 00       	call   800e06 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 6b 24 00 00       	call   802582 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 40 80 00       	mov    0x804020,%eax
  80012c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 40 80 00       	mov    0x804020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 60 28 80 00       	push   $0x802860
  80016d:	6a 36                	push   $0x36
  80016f:	68 7c 28 80 00       	push   $0x80287c
  800174:	e8 8d 0c 00 00       	call   800e06 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 bc 28 80 00       	push   $0x8028bc
  800184:	e8 31 0f 00 00       	call   8010ba <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001af:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 08 29 80 00       	push   $0x802908
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 7c 28 80 00       	push   $0x80287c
  8001f6:	e8 0b 0c 00 00       	call   800e06 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 59 1e 00 00       	call   80206d <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 f1 1e 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 28 1c 00 00       	call   801e5e <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 58 29 80 00       	push   $0x802958
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 7c 28 80 00       	push   $0x80287c
  8002bb:	e8 46 0b 00 00       	call   800e06 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 48 1e 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 96 29 80 00       	push   $0x802996
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 7c 28 80 00       	push   $0x80287c
  8002ef:	e8 12 0b 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 71 1d 00 00       	call   80206d <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 b3 29 80 00       	push   $0x8029b3
  80031e:	6a 60                	push   $0x60
  800320:	68 7c 28 80 00       	push   $0x80287c
  800325:	e8 dc 0a 00 00       	call   800e06 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 3e 1d 00 00       	call   80206d <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 d6 1d 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 56 1b 00 00       	call   801e9f <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 44 1b 00 00       	call   801e9f <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 32 1b 00 00       	call   801e9f <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 20 1b 00 00       	call   801e9f <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 0e 1b 00 00       	call   801e9f <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 fc 1a 00 00       	call   801e9f <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 ea 1a 00 00       	call   801e9f <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 d8 1a 00 00       	call   801e9f <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 c6 1a 00 00       	call   801e9f <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 b4 1a 00 00       	call   801e9f <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 a2 1a 00 00       	call   801e9f <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 90 1a 00 00       	call   801e9f <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 7e 1a 00 00       	call   801e9f <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 6c 1a 00 00       	call   801e9f <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 5a 1a 00 00       	call   801e9f <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 c0 1c 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 c4 29 80 00       	push   $0x8029c4
  800480:	6a 76                	push   $0x76
  800482:	68 7c 28 80 00       	push   $0x80287c
  800487:	e8 7a 09 00 00       	call   800e06 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 dc 1b 00 00       	call   80206d <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 00 2a 80 00       	push   $0x802a00
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 7c 28 80 00       	push   $0x80287c
  8004a9:	e8 58 09 00 00       	call   800e06 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 ba 1b 00 00       	call   80206d <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 52 1c 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 94 19 00 00       	call   801e5e <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 40 2a 80 00       	push   $0x802a40
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 7c 28 80 00       	push   $0x80287c
  8004e9:	e8 18 09 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 1a 1c 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 96 29 80 00       	push   $0x802996
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 7c 28 80 00       	push   $0x80287c
  80051d:	e8 e4 08 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 46 1b 00 00       	call   80206d <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 b3 29 80 00       	push   $0x8029b3
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 7c 28 80 00       	push   $0x80287c
  800542:	e8 bf 08 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 60 2a 80 00       	push   $0x802a60
  800555:	e8 60 0b 00 00       	call   8010ba <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 0b 1b 00 00       	call   80206d <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 a3 1b 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 e2 18 00 00       	call   801e5e <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 40 2a 80 00       	push   $0x802a40
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 7c 28 80 00       	push   $0x80287c
  80059e:	e8 63 08 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 65 1b 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 96 29 80 00       	push   $0x802996
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 7c 28 80 00       	push   $0x80287c
  8005d5:	e8 2c 08 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 8e 1a 00 00       	call   80206d <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 b3 29 80 00       	push   $0x8029b3
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 7c 28 80 00       	push   $0x80287c
  8005fa:	e8 07 08 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 60 2a 80 00       	push   $0x802a60
  80060d:	e8 a8 0a 00 00       	call   8010ba <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 53 1a 00 00       	call   80206d <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 eb 1a 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 25 18 00 00       	call   801e5e <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 40 2a 80 00       	push   $0x802a40
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 7c 28 80 00       	push   $0x80287c
  80065b:	e8 a6 07 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 a8 1a 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 96 29 80 00       	push   $0x802996
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 7c 28 80 00       	push   $0x80287c
  800697:	e8 6a 07 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 cc 19 00 00       	call   80206d <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 b3 29 80 00       	push   $0x8029b3
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 7c 28 80 00       	push   $0x80287c
  8006bc:	e8 45 07 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 60 2a 80 00       	push   $0x802a60
  8006cf:	e8 e6 09 00 00       	call   8010ba <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 91 19 00 00       	call   80206d <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 29 1a 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 64 17 00 00       	call   801e5e <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 40 2a 80 00       	push   $0x802a40
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 7c 28 80 00       	push   $0x80287c
  80071c:	e8 e5 06 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 e7 19 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 96 29 80 00       	push   $0x802996
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 7c 28 80 00       	push   $0x80287c
  800757:	e8 aa 06 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 0c 19 00 00       	call   80206d <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 b3 29 80 00       	push   $0x8029b3
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 7c 28 80 00       	push   $0x80287c
  80077c:	e8 85 06 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 60 2a 80 00       	push   $0x802a60
  80078f:	e8 26 09 00 00       	call   8010ba <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 d1 18 00 00       	call   80206d <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 69 19 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 a8 16 00 00       	call   801e5e <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 40 2a 80 00       	push   $0x802a40
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 7c 28 80 00       	push   $0x80287c
  8007d8:	e8 29 06 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 2b 19 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 96 29 80 00       	push   $0x802996
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 7c 28 80 00       	push   $0x80287c
  80080f:	e8 f2 05 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 54 18 00 00       	call   80206d <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 b3 29 80 00       	push   $0x8029b3
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 7c 28 80 00       	push   $0x80287c
  800834:	e8 cd 05 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 60 2a 80 00       	push   $0x802a60
  800847:	e8 6e 08 00 00       	call   8010ba <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 19 18 00 00       	call   80206d <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 b1 18 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 f1 15 00 00       	call   801e5e <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 40 2a 80 00       	push   $0x802a40
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 7c 28 80 00       	push   $0x80287c
  80088f:	e8 72 05 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 74 18 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 96 29 80 00       	push   $0x802996
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 7c 28 80 00       	push   $0x80287c
  8008c5:	e8 3c 05 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 9e 17 00 00       	call   80206d <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 b3 29 80 00       	push   $0x8029b3
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 7c 28 80 00       	push   $0x80287c
  8008ea:	e8 17 05 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 60 2a 80 00       	push   $0x802a60
  8008fd:	e8 b8 07 00 00       	call   8010ba <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 63 17 00 00       	call   80206d <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 fb 17 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 33 15 00 00       	call   801e5e <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 40 2a 80 00       	push   $0x802a40
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 7c 28 80 00       	push   $0x80287c
  80094d:	e8 b4 04 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 b6 17 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 96 29 80 00       	push   $0x802996
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 7c 28 80 00       	push   $0x80287c
  80098b:	e8 76 04 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 d8 16 00 00       	call   80206d <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 b3 29 80 00       	push   $0x8029b3
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 7c 28 80 00       	push   $0x80287c
  8009b0:	e8 51 04 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 60 2a 80 00       	push   $0x802a60
  8009c3:	e8 f2 06 00 00       	call   8010ba <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 9d 16 00 00       	call   80206d <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 35 17 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 74 14 00 00       	call   801e5e <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 40 2a 80 00       	push   $0x802a40
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 7c 28 80 00       	push   $0x80287c
  800a0c:	e8 f5 03 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 f7 16 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 96 29 80 00       	push   $0x802996
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 7c 28 80 00       	push   $0x80287c
  800a43:	e8 be 03 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 20 16 00 00       	call   80206d <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 b3 29 80 00       	push   $0x8029b3
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 7c 28 80 00       	push   $0x80287c
  800a68:	e8 99 03 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 60 2a 80 00       	push   $0x802a60
  800a7b:	e8 3a 06 00 00       	call   8010ba <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 e5 15 00 00       	call   80206d <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 7d 16 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 bf 13 00 00       	call   801e5e <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 40 2a 80 00       	push   $0x802a40
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 7c 28 80 00       	push   $0x80287c
  800ac1:	e8 40 03 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 42 16 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 96 29 80 00       	push   $0x802996
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 7c 28 80 00       	push   $0x80287c
  800af8:	e8 09 03 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 6b 15 00 00       	call   80206d <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 b3 29 80 00       	push   $0x8029b3
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 7c 28 80 00       	push   $0x80287c
  800b1d:	e8 e4 02 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 60 2a 80 00       	push   $0x802a60
  800b30:	e8 85 05 00 00       	call   8010ba <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 30 15 00 00       	call   80206d <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 c8 15 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 ff 12 00 00       	call   801e5e <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 40 2a 80 00       	push   $0x802a40
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 7c 28 80 00       	push   $0x80287c
  800b81:	e8 80 02 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 82 15 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 96 29 80 00       	push   $0x802996
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 7c 28 80 00       	push   $0x80287c
  800bc0:	e8 41 02 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 a3 14 00 00       	call   80206d <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 b3 29 80 00       	push   $0x8029b3
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 7c 28 80 00       	push   $0x80287c
  800be5:	e8 1c 02 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 60 2a 80 00       	push   $0x802a60
  800bf8:	e8 bd 04 00 00       	call   8010ba <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 68 14 00 00       	call   80206d <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 00 15 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 3f 12 00 00       	call   801e5e <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 40 2a 80 00       	push   $0x802a40
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 7c 28 80 00       	push   $0x80287c
  800c3e:	e8 c3 01 00 00       	call   800e06 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 c5 14 00 00       	call   80210d <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 96 29 80 00       	push   $0x802996
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 7c 28 80 00       	push   $0x80287c
  800c5f:	e8 a2 01 00 00       	call   800e06 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 04 14 00 00       	call   80206d <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 b3 29 80 00       	push   $0x8029b3
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 7c 28 80 00       	push   $0x80287c
  800c84:	e8 7d 01 00 00       	call   800e06 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 60 2a 80 00       	push   $0x802a60
  800c97:	e8 1e 04 00 00       	call   8010ba <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 74 2a 80 00       	push   $0x802a74
  800ca7:	e8 0e 04 00 00       	call   8010ba <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 8b 16 00 00       	call   80234d <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800cd5:	01 c8                	add    %ecx,%eax
  800cd7:	c1 e0 02             	shl    $0x2,%eax
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800ce3:	01 c8                	add    %ecx,%eax
  800ce5:	c1 e0 02             	shl    $0x2,%eax
  800ce8:	01 d0                	add    %edx,%eax
  800cea:	c1 e0 02             	shl    $0x2,%eax
  800ced:	01 d0                	add    %edx,%eax
  800cef:	c1 e0 03             	shl    $0x3,%eax
  800cf2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800cf7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800cfc:	a1 20 40 80 00       	mov    0x804020,%eax
  800d01:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	74 0f                	je     800d1a <libmain+0x63>
		binaryname = myEnv->prog_name;
  800d0b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d10:	05 18 da 01 00       	add    $0x1da18,%eax
  800d15:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d1e:	7e 0a                	jle    800d2a <libmain+0x73>
		binaryname = argv[0];
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 00 f3 ff ff       	call   800038 <_main>
  800d38:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d3b:	e8 1a 14 00 00       	call   80215a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d40:	83 ec 0c             	sub    $0xc,%esp
  800d43:	68 c8 2a 80 00       	push   $0x802ac8
  800d48:	e8 6d 03 00 00       	call   8010ba <cprintf>
  800d4d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d50:	a1 20 40 80 00       	mov    0x804020,%eax
  800d55:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800d5b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d60:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800d66:	83 ec 04             	sub    $0x4,%esp
  800d69:	52                   	push   %edx
  800d6a:	50                   	push   %eax
  800d6b:	68 f0 2a 80 00       	push   $0x802af0
  800d70:	e8 45 03 00 00       	call   8010ba <cprintf>
  800d75:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d78:	a1 20 40 80 00       	mov    0x804020,%eax
  800d7d:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800d83:	a1 20 40 80 00       	mov    0x804020,%eax
  800d88:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800d8e:	a1 20 40 80 00       	mov    0x804020,%eax
  800d93:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800d99:	51                   	push   %ecx
  800d9a:	52                   	push   %edx
  800d9b:	50                   	push   %eax
  800d9c:	68 18 2b 80 00       	push   $0x802b18
  800da1:	e8 14 03 00 00       	call   8010ba <cprintf>
  800da6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800da9:	a1 20 40 80 00       	mov    0x804020,%eax
  800dae:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800db4:	83 ec 08             	sub    $0x8,%esp
  800db7:	50                   	push   %eax
  800db8:	68 70 2b 80 00       	push   $0x802b70
  800dbd:	e8 f8 02 00 00       	call   8010ba <cprintf>
  800dc2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	68 c8 2a 80 00       	push   $0x802ac8
  800dcd:	e8 e8 02 00 00       	call   8010ba <cprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dd5:	e8 9a 13 00 00       	call   802174 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dda:	e8 19 00 00 00       	call   800df8 <exit>
}
  800ddf:	90                   	nop
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800de8:	83 ec 0c             	sub    $0xc,%esp
  800deb:	6a 00                	push   $0x0
  800ded:	e8 27 15 00 00       	call   802319 <sys_destroy_env>
  800df2:	83 c4 10             	add    $0x10,%esp
}
  800df5:	90                   	nop
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <exit>:

void
exit(void)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800dfe:	e8 7c 15 00 00       	call   80237f <sys_exit_env>
}
  800e03:	90                   	nop
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e15:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	74 16                	je     800e34 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e1e:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800e23:	83 ec 08             	sub    $0x8,%esp
  800e26:	50                   	push   %eax
  800e27:	68 84 2b 80 00       	push   $0x802b84
  800e2c:	e8 89 02 00 00       	call   8010ba <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e34:	a1 00 40 80 00       	mov    0x804000,%eax
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	ff 75 08             	pushl  0x8(%ebp)
  800e3f:	50                   	push   %eax
  800e40:	68 89 2b 80 00       	push   $0x802b89
  800e45:	e8 70 02 00 00       	call   8010ba <cprintf>
  800e4a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 f4             	pushl  -0xc(%ebp)
  800e56:	50                   	push   %eax
  800e57:	e8 f3 01 00 00       	call   80104f <vcprintf>
  800e5c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	6a 00                	push   $0x0
  800e64:	68 a5 2b 80 00       	push   $0x802ba5
  800e69:	e8 e1 01 00 00       	call   80104f <vcprintf>
  800e6e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e71:	e8 82 ff ff ff       	call   800df8 <exit>

	// should not return here
	while (1) ;
  800e76:	eb fe                	jmp    800e76 <_panic+0x70>

00800e78 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e7e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e83:	8b 50 74             	mov    0x74(%eax),%edx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	39 c2                	cmp    %eax,%edx
  800e8b:	74 14                	je     800ea1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e8d:	83 ec 04             	sub    $0x4,%esp
  800e90:	68 a8 2b 80 00       	push   $0x802ba8
  800e95:	6a 26                	push   $0x26
  800e97:	68 f4 2b 80 00       	push   $0x802bf4
  800e9c:	e8 65 ff ff ff       	call   800e06 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ea8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eaf:	e9 c2 00 00 00       	jmp    800f76 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	01 d0                	add    %edx,%eax
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 08                	jne    800ed1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800ec9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800ecc:	e9 a2 00 00 00       	jmp    800f73 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ed1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800edf:	eb 69                	jmp    800f4a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ee1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ee6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800eec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800eef:	89 d0                	mov    %edx,%eax
  800ef1:	01 c0                	add    %eax,%eax
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	c1 e0 03             	shl    $0x3,%eax
  800ef8:	01 c8                	add    %ecx,%eax
  800efa:	8a 40 04             	mov    0x4(%eax),%al
  800efd:	84 c0                	test   %al,%al
  800eff:	75 46                	jne    800f47 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f01:	a1 20 40 80 00       	mov    0x804020,%eax
  800f06:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800f0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f0f:	89 d0                	mov    %edx,%eax
  800f11:	01 c0                	add    %eax,%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	c1 e0 03             	shl    $0x3,%eax
  800f18:	01 c8                	add    %ecx,%eax
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f27:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	01 c8                	add    %ecx,%eax
  800f38:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f3a:	39 c2                	cmp    %eax,%edx
  800f3c:	75 09                	jne    800f47 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f3e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f45:	eb 12                	jmp    800f59 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f47:	ff 45 e8             	incl   -0x18(%ebp)
  800f4a:	a1 20 40 80 00       	mov    0x804020,%eax
  800f4f:	8b 50 74             	mov    0x74(%eax),%edx
  800f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f55:	39 c2                	cmp    %eax,%edx
  800f57:	77 88                	ja     800ee1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f5d:	75 14                	jne    800f73 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	68 00 2c 80 00       	push   $0x802c00
  800f67:	6a 3a                	push   $0x3a
  800f69:	68 f4 2b 80 00       	push   $0x802bf4
  800f6e:	e8 93 fe ff ff       	call   800e06 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f73:	ff 45 f0             	incl   -0x10(%ebp)
  800f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f79:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f7c:	0f 8c 32 ff ff ff    	jl     800eb4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f90:	eb 26                	jmp    800fb8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f92:	a1 20 40 80 00       	mov    0x804020,%eax
  800f97:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800f9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fa0:	89 d0                	mov    %edx,%eax
  800fa2:	01 c0                	add    %eax,%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	c1 e0 03             	shl    $0x3,%eax
  800fa9:	01 c8                	add    %ecx,%eax
  800fab:	8a 40 04             	mov    0x4(%eax),%al
  800fae:	3c 01                	cmp    $0x1,%al
  800fb0:	75 03                	jne    800fb5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800fb2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fb5:	ff 45 e0             	incl   -0x20(%ebp)
  800fb8:	a1 20 40 80 00       	mov    0x804020,%eax
  800fbd:	8b 50 74             	mov    0x74(%eax),%edx
  800fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc3:	39 c2                	cmp    %eax,%edx
  800fc5:	77 cb                	ja     800f92 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fcd:	74 14                	je     800fe3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	68 54 2c 80 00       	push   $0x802c54
  800fd7:	6a 44                	push   $0x44
  800fd9:	68 f4 2b 80 00       	push   $0x802bf4
  800fde:	e8 23 fe ff ff       	call   800e06 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fe3:	90                   	nop
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	8b 00                	mov    (%eax),%eax
  800ff1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff7:	89 0a                	mov    %ecx,(%edx)
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	88 d1                	mov    %dl,%cl
  800ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801001:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8b 00                	mov    (%eax),%eax
  80100a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80100f:	75 2c                	jne    80103d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801011:	a0 24 40 80 00       	mov    0x804024,%al
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101c:	8b 12                	mov    (%edx),%edx
  80101e:	89 d1                	mov    %edx,%ecx
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	83 c2 08             	add    $0x8,%edx
  801026:	83 ec 04             	sub    $0x4,%esp
  801029:	50                   	push   %eax
  80102a:	51                   	push   %ecx
  80102b:	52                   	push   %edx
  80102c:	e8 7b 0f 00 00       	call   801fac <sys_cputs>
  801031:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 04             	mov    0x4(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 04             	mov    %edx,0x4(%eax)
}
  80104c:	90                   	nop
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801058:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80105f:	00 00 00 
	b.cnt = 0;
  801062:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801069:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	ff 75 08             	pushl  0x8(%ebp)
  801072:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	68 e6 0f 80 00       	push   $0x800fe6
  80107e:	e8 11 02 00 00       	call   801294 <vprintfmt>
  801083:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801086:	a0 24 40 80 00       	mov    0x804024,%al
  80108b:	0f b6 c0             	movzbl %al,%eax
  80108e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	50                   	push   %eax
  801098:	52                   	push   %edx
  801099:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80109f:	83 c0 08             	add    $0x8,%eax
  8010a2:	50                   	push   %eax
  8010a3:	e8 04 0f 00 00       	call   801fac <sys_cputs>
  8010a8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8010ab:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8010b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <cprintf>:

int cprintf(const char *fmt, ...) {
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010c0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8010c7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	83 ec 08             	sub    $0x8,%esp
  8010d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	e8 73 ff ff ff       	call   80104f <vcprintf>
  8010dc:	83 c4 10             	add    $0x10,%esp
  8010df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010ed:	e8 68 10 00 00       	call   80215a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801101:	50                   	push   %eax
  801102:	e8 48 ff ff ff       	call   80104f <vcprintf>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80110d:	e8 62 10 00 00       	call   802174 <sys_enable_interrupt>
	return cnt;
  801112:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	53                   	push   %ebx
  80111b:	83 ec 14             	sub    $0x14,%esp
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801124:	8b 45 14             	mov    0x14(%ebp),%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80112a:	8b 45 18             	mov    0x18(%ebp),%eax
  80112d:	ba 00 00 00 00       	mov    $0x0,%edx
  801132:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801135:	77 55                	ja     80118c <printnum+0x75>
  801137:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80113a:	72 05                	jb     801141 <printnum+0x2a>
  80113c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113f:	77 4b                	ja     80118c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801141:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801144:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801147:	8b 45 18             	mov    0x18(%ebp),%eax
  80114a:	ba 00 00 00 00       	mov    $0x0,%edx
  80114f:	52                   	push   %edx
  801150:	50                   	push   %eax
  801151:	ff 75 f4             	pushl  -0xc(%ebp)
  801154:	ff 75 f0             	pushl  -0x10(%ebp)
  801157:	e8 84 14 00 00       	call   8025e0 <__udivdi3>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	83 ec 04             	sub    $0x4,%esp
  801162:	ff 75 20             	pushl  0x20(%ebp)
  801165:	53                   	push   %ebx
  801166:	ff 75 18             	pushl  0x18(%ebp)
  801169:	52                   	push   %edx
  80116a:	50                   	push   %eax
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	e8 a1 ff ff ff       	call   801117 <printnum>
  801176:	83 c4 20             	add    $0x20,%esp
  801179:	eb 1a                	jmp    801195 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	ff 75 20             	pushl  0x20(%ebp)
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	ff d0                	call   *%eax
  801189:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80118c:	ff 4d 1c             	decl   0x1c(%ebp)
  80118f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801193:	7f e6                	jg     80117b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801195:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801198:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a3:	53                   	push   %ebx
  8011a4:	51                   	push   %ecx
  8011a5:	52                   	push   %edx
  8011a6:	50                   	push   %eax
  8011a7:	e8 44 15 00 00       	call   8026f0 <__umoddi3>
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	05 b4 2e 80 00       	add    $0x802eb4,%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f be c0             	movsbl %al,%eax
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	50                   	push   %eax
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	ff d0                	call   *%eax
  8011c5:	83 c4 10             	add    $0x10,%esp
}
  8011c8:	90                   	nop
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011d5:	7e 1c                	jle    8011f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8b 00                	mov    (%eax),%eax
  8011dc:	8d 50 08             	lea    0x8(%eax),%edx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	89 10                	mov    %edx,(%eax)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8b 00                	mov    (%eax),%eax
  8011e9:	83 e8 08             	sub    $0x8,%eax
  8011ec:	8b 50 04             	mov    0x4(%eax),%edx
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	eb 40                	jmp    801233 <getuint+0x65>
	else if (lflag)
  8011f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f7:	74 1e                	je     801217 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	8d 50 04             	lea    0x4(%eax),%edx
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	89 10                	mov    %edx,(%eax)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	83 e8 04             	sub    $0x4,%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	ba 00 00 00 00       	mov    $0x0,%edx
  801215:	eb 1c                	jmp    801233 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 50 04             	lea    0x4(%eax),%edx
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	89 10                	mov    %edx,(%eax)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8b 00                	mov    (%eax),%eax
  801229:	83 e8 04             	sub    $0x4,%eax
  80122c:	8b 00                	mov    (%eax),%eax
  80122e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801238:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80123c:	7e 1c                	jle    80125a <getint+0x25>
		return va_arg(*ap, long long);
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 50 08             	lea    0x8(%eax),%edx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	89 10                	mov    %edx,(%eax)
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	83 e8 08             	sub    $0x8,%eax
  801253:	8b 50 04             	mov    0x4(%eax),%edx
  801256:	8b 00                	mov    (%eax),%eax
  801258:	eb 38                	jmp    801292 <getint+0x5d>
	else if (lflag)
  80125a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125e:	74 1a                	je     80127a <getint+0x45>
		return va_arg(*ap, long);
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8b 00                	mov    (%eax),%eax
  801265:	8d 50 04             	lea    0x4(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	89 10                	mov    %edx,(%eax)
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8b 00                	mov    (%eax),%eax
  801272:	83 e8 04             	sub    $0x4,%eax
  801275:	8b 00                	mov    (%eax),%eax
  801277:	99                   	cltd   
  801278:	eb 18                	jmp    801292 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8b 00                	mov    (%eax),%eax
  80127f:	8d 50 04             	lea    0x4(%eax),%edx
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	89 10                	mov    %edx,(%eax)
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	83 e8 04             	sub    $0x4,%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	99                   	cltd   
}
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	56                   	push   %esi
  801298:	53                   	push   %ebx
  801299:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80129c:	eb 17                	jmp    8012b5 <vprintfmt+0x21>
			if (ch == '\0')
  80129e:	85 db                	test   %ebx,%ebx
  8012a0:	0f 84 af 03 00 00    	je     801655 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ac:	53                   	push   %ebx
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	ff d0                	call   *%eax
  8012b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	0f b6 d8             	movzbl %al,%ebx
  8012c3:	83 fb 25             	cmp    $0x25,%ebx
  8012c6:	75 d6                	jne    80129e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	8d 50 01             	lea    0x1(%eax),%edx
  8012ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	0f b6 d8             	movzbl %al,%ebx
  8012f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012f9:	83 f8 55             	cmp    $0x55,%eax
  8012fc:	0f 87 2b 03 00 00    	ja     80162d <vprintfmt+0x399>
  801302:	8b 04 85 d8 2e 80 00 	mov    0x802ed8(,%eax,4),%eax
  801309:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80130b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80130f:	eb d7                	jmp    8012e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801311:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801315:	eb d1                	jmp    8012e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801317:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80131e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	c1 e0 02             	shl    $0x2,%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	01 c0                	add    %eax,%eax
  80132a:	01 d8                	add    %ebx,%eax
  80132c:	83 e8 30             	sub    $0x30,%eax
  80132f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80133a:	83 fb 2f             	cmp    $0x2f,%ebx
  80133d:	7e 3e                	jle    80137d <vprintfmt+0xe9>
  80133f:	83 fb 39             	cmp    $0x39,%ebx
  801342:	7f 39                	jg     80137d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801344:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801347:	eb d5                	jmp    80131e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801349:	8b 45 14             	mov    0x14(%ebp),%eax
  80134c:	83 c0 04             	add    $0x4,%eax
  80134f:	89 45 14             	mov    %eax,0x14(%ebp)
  801352:	8b 45 14             	mov    0x14(%ebp),%eax
  801355:	83 e8 04             	sub    $0x4,%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80135d:	eb 1f                	jmp    80137e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80135f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801363:	79 83                	jns    8012e8 <vprintfmt+0x54>
				width = 0;
  801365:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80136c:	e9 77 ff ff ff       	jmp    8012e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801371:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801378:	e9 6b ff ff ff       	jmp    8012e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80137d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80137e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801382:	0f 89 60 ff ff ff    	jns    8012e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80138b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80138e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801395:	e9 4e ff ff ff       	jmp    8012e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80139a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80139d:	e9 46 ff ff ff       	jmp    8012e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8013a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a5:	83 c0 04             	add    $0x4,%eax
  8013a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	83 e8 04             	sub    $0x4,%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	50                   	push   %eax
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	ff d0                	call   *%eax
  8013bf:	83 c4 10             	add    $0x10,%esp
			break;
  8013c2:	e9 89 02 00 00       	jmp    801650 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ca:	83 c0 04             	add    $0x4,%eax
  8013cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	83 e8 04             	sub    $0x4,%eax
  8013d6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013d8:	85 db                	test   %ebx,%ebx
  8013da:	79 02                	jns    8013de <vprintfmt+0x14a>
				err = -err;
  8013dc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013de:	83 fb 64             	cmp    $0x64,%ebx
  8013e1:	7f 0b                	jg     8013ee <vprintfmt+0x15a>
  8013e3:	8b 34 9d 20 2d 80 00 	mov    0x802d20(,%ebx,4),%esi
  8013ea:	85 f6                	test   %esi,%esi
  8013ec:	75 19                	jne    801407 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013ee:	53                   	push   %ebx
  8013ef:	68 c5 2e 80 00       	push   $0x802ec5
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	ff 75 08             	pushl  0x8(%ebp)
  8013fa:	e8 5e 02 00 00       	call   80165d <printfmt>
  8013ff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801402:	e9 49 02 00 00       	jmp    801650 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801407:	56                   	push   %esi
  801408:	68 ce 2e 80 00       	push   $0x802ece
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	ff 75 08             	pushl  0x8(%ebp)
  801413:	e8 45 02 00 00       	call   80165d <printfmt>
  801418:	83 c4 10             	add    $0x10,%esp
			break;
  80141b:	e9 30 02 00 00       	jmp    801650 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	83 c0 04             	add    $0x4,%eax
  801426:	89 45 14             	mov    %eax,0x14(%ebp)
  801429:	8b 45 14             	mov    0x14(%ebp),%eax
  80142c:	83 e8 04             	sub    $0x4,%eax
  80142f:	8b 30                	mov    (%eax),%esi
  801431:	85 f6                	test   %esi,%esi
  801433:	75 05                	jne    80143a <vprintfmt+0x1a6>
				p = "(null)";
  801435:	be d1 2e 80 00       	mov    $0x802ed1,%esi
			if (width > 0 && padc != '-')
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	7e 6d                	jle    8014ad <vprintfmt+0x219>
  801440:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801444:	74 67                	je     8014ad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	50                   	push   %eax
  80144d:	56                   	push   %esi
  80144e:	e8 0c 03 00 00       	call   80175f <strnlen>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801459:	eb 16                	jmp    801471 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80145b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	ff d0                	call   *%eax
  80146b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80146e:	ff 4d e4             	decl   -0x1c(%ebp)
  801471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801475:	7f e4                	jg     80145b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801477:	eb 34                	jmp    8014ad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801479:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80147d:	74 1c                	je     80149b <vprintfmt+0x207>
  80147f:	83 fb 1f             	cmp    $0x1f,%ebx
  801482:	7e 05                	jle    801489 <vprintfmt+0x1f5>
  801484:	83 fb 7e             	cmp    $0x7e,%ebx
  801487:	7e 12                	jle    80149b <vprintfmt+0x207>
					putch('?', putdat);
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	6a 3f                	push   $0x3f
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	ff d0                	call   *%eax
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	eb 0f                	jmp    8014aa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	53                   	push   %ebx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	ff d0                	call   *%eax
  8014a7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8014ad:	89 f0                	mov    %esi,%eax
  8014af:	8d 70 01             	lea    0x1(%eax),%esi
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be d8             	movsbl %al,%ebx
  8014b7:	85 db                	test   %ebx,%ebx
  8014b9:	74 24                	je     8014df <vprintfmt+0x24b>
  8014bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014bf:	78 b8                	js     801479 <vprintfmt+0x1e5>
  8014c1:	ff 4d e0             	decl   -0x20(%ebp)
  8014c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c8:	79 af                	jns    801479 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014ca:	eb 13                	jmp    8014df <vprintfmt+0x24b>
				putch(' ', putdat);
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	6a 20                	push   $0x20
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	ff d0                	call   *%eax
  8014d9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8014df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e3:	7f e7                	jg     8014cc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014e5:	e9 66 01 00 00       	jmp    801650 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8014f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8014f3:	50                   	push   %eax
  8014f4:	e8 3c fd ff ff       	call   801235 <getint>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801508:	85 d2                	test   %edx,%edx
  80150a:	79 23                	jns    80152f <vprintfmt+0x29b>
				putch('-', putdat);
  80150c:	83 ec 08             	sub    $0x8,%esp
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	6a 2d                	push   $0x2d
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	ff d0                	call   *%eax
  801519:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	f7 d8                	neg    %eax
  801524:	83 d2 00             	adc    $0x0,%edx
  801527:	f7 da                	neg    %edx
  801529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80152c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80152f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801536:	e9 bc 00 00 00       	jmp    8015f7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	ff 75 e8             	pushl  -0x18(%ebp)
  801541:	8d 45 14             	lea    0x14(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	e8 84 fc ff ff       	call   8011ce <getuint>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801550:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801553:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80155a:	e9 98 00 00 00       	jmp    8015f7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	6a 58                	push   $0x58
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	ff d0                	call   *%eax
  80156c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	6a 58                	push   $0x58
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	ff d0                	call   *%eax
  80157c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	6a 58                	push   $0x58
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	ff d0                	call   *%eax
  80158c:	83 c4 10             	add    $0x10,%esp
			break;
  80158f:	e9 bc 00 00 00       	jmp    801650 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	6a 30                	push   $0x30
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	ff d0                	call   *%eax
  8015a1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	6a 78                	push   $0x78
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	ff d0                	call   *%eax
  8015b1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b7:	83 c0 04             	add    $0x4,%eax
  8015ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8015bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c0:	83 e8 04             	sub    $0x4,%eax
  8015c3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015d6:	eb 1f                	jmp    8015f7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	ff 75 e8             	pushl  -0x18(%ebp)
  8015de:	8d 45 14             	lea    0x14(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	e8 e7 fb ff ff       	call   8011ce <getuint>
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015f7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	52                   	push   %edx
  801602:	ff 75 e4             	pushl  -0x1c(%ebp)
  801605:	50                   	push   %eax
  801606:	ff 75 f4             	pushl  -0xc(%ebp)
  801609:	ff 75 f0             	pushl  -0x10(%ebp)
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	e8 00 fb ff ff       	call   801117 <printnum>
  801617:	83 c4 20             	add    $0x20,%esp
			break;
  80161a:	eb 34                	jmp    801650 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	53                   	push   %ebx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			break;
  80162b:	eb 23                	jmp    801650 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	6a 25                	push   $0x25
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	ff d0                	call   *%eax
  80163a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80163d:	ff 4d 10             	decl   0x10(%ebp)
  801640:	eb 03                	jmp    801645 <vprintfmt+0x3b1>
  801642:	ff 4d 10             	decl   0x10(%ebp)
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	48                   	dec    %eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 25                	cmp    $0x25,%al
  80164d:	75 f3                	jne    801642 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80164f:	90                   	nop
		}
	}
  801650:	e9 47 fc ff ff       	jmp    80129c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801655:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801656:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801663:	8d 45 10             	lea    0x10(%ebp),%eax
  801666:	83 c0 04             	add    $0x4,%eax
  801669:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	ff 75 f4             	pushl  -0xc(%ebp)
  801672:	50                   	push   %eax
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	ff 75 08             	pushl  0x8(%ebp)
  801679:	e8 16 fc ff ff       	call   801294 <vprintfmt>
  80167e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168a:	8b 40 08             	mov    0x8(%eax),%eax
  80168d:	8d 50 01             	lea    0x1(%eax),%edx
  801690:	8b 45 0c             	mov    0xc(%ebp),%eax
  801693:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	8b 10                	mov    (%eax),%edx
  80169b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169e:	8b 40 04             	mov    0x4(%eax),%eax
  8016a1:	39 c2                	cmp    %eax,%edx
  8016a3:	73 12                	jae    8016b7 <sprintputch+0x33>
		*b->buf++ = ch;
  8016a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	88 10                	mov    %dl,(%eax)
}
  8016b7:	90                   	nop
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016df:	74 06                	je     8016e7 <vsnprintf+0x2d>
  8016e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e5:	7f 07                	jg     8016ee <vsnprintf+0x34>
		return -E_INVAL;
  8016e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ec:	eb 20                	jmp    80170e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016ee:	ff 75 14             	pushl  0x14(%ebp)
  8016f1:	ff 75 10             	pushl  0x10(%ebp)
  8016f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	68 84 16 80 00       	push   $0x801684
  8016fd:	e8 92 fb ff ff       	call   801294 <vprintfmt>
  801702:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801708:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801716:	8d 45 10             	lea    0x10(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80171f:	8b 45 10             	mov    0x10(%ebp),%eax
  801722:	ff 75 f4             	pushl  -0xc(%ebp)
  801725:	50                   	push   %eax
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 89 ff ff ff       	call   8016ba <vsnprintf>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801742:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801749:	eb 06                	jmp    801751 <strlen+0x15>
		n++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80174e:	ff 45 08             	incl   0x8(%ebp)
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	84 c0                	test   %al,%al
  801758:	75 f1                	jne    80174b <strlen+0xf>
		n++;
	return n;
  80175a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801765:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80176c:	eb 09                	jmp    801777 <strnlen+0x18>
		n++;
  80176e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801771:	ff 45 08             	incl   0x8(%ebp)
  801774:	ff 4d 0c             	decl   0xc(%ebp)
  801777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80177b:	74 09                	je     801786 <strnlen+0x27>
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	84 c0                	test   %al,%al
  801784:	75 e8                	jne    80176e <strnlen+0xf>
		n++;
	return n;
  801786:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801797:	90                   	nop
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8d 50 01             	lea    0x1(%eax),%edx
  80179e:	89 55 08             	mov    %edx,0x8(%ebp)
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8017aa:	8a 12                	mov    (%edx),%dl
  8017ac:	88 10                	mov    %dl,(%eax)
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	84 c0                	test   %al,%al
  8017b2:	75 e4                	jne    801798 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017cc:	eb 1f                	jmp    8017ed <strncpy+0x34>
		*dst++ = *src;
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8d 50 01             	lea    0x1(%eax),%edx
  8017d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8a 12                	mov    (%edx),%dl
  8017dc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	84 c0                	test   %al,%al
  8017e5:	74 03                	je     8017ea <strncpy+0x31>
			src++;
  8017e7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017ea:	ff 45 fc             	incl   -0x4(%ebp)
  8017ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017f3:	72 d9                	jb     8017ce <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	74 30                	je     80183c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80180c:	eb 16                	jmp    801824 <strlcpy+0x2a>
			*dst++ = *src++;
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	8d 50 01             	lea    0x1(%eax),%edx
  801814:	89 55 08             	mov    %edx,0x8(%ebp)
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80181d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801820:	8a 12                	mov    (%edx),%dl
  801822:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801824:	ff 4d 10             	decl   0x10(%ebp)
  801827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182b:	74 09                	je     801836 <strlcpy+0x3c>
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	8a 00                	mov    (%eax),%al
  801832:	84 c0                	test   %al,%al
  801834:	75 d8                	jne    80180e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80183c:	8b 55 08             	mov    0x8(%ebp),%edx
  80183f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801842:	29 c2                	sub    %eax,%edx
  801844:	89 d0                	mov    %edx,%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80184b:	eb 06                	jmp    801853 <strcmp+0xb>
		p++, q++;
  80184d:	ff 45 08             	incl   0x8(%ebp)
  801850:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	84 c0                	test   %al,%al
  80185a:	74 0e                	je     80186a <strcmp+0x22>
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8a 10                	mov    (%eax),%dl
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	8a 00                	mov    (%eax),%al
  801866:	38 c2                	cmp    %al,%dl
  801868:	74 e3                	je     80184d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	8a 00                	mov    (%eax),%al
  80186f:	0f b6 d0             	movzbl %al,%edx
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 c0             	movzbl %al,%eax
  80187a:	29 c2                	sub    %eax,%edx
  80187c:	89 d0                	mov    %edx,%eax
}
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801883:	eb 09                	jmp    80188e <strncmp+0xe>
		n--, p++, q++;
  801885:	ff 4d 10             	decl   0x10(%ebp)
  801888:	ff 45 08             	incl   0x8(%ebp)
  80188b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80188e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801892:	74 17                	je     8018ab <strncmp+0x2b>
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8a 00                	mov    (%eax),%al
  801899:	84 c0                	test   %al,%al
  80189b:	74 0e                	je     8018ab <strncmp+0x2b>
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8a 10                	mov    (%eax),%dl
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	8a 00                	mov    (%eax),%al
  8018a7:	38 c2                	cmp    %al,%dl
  8018a9:	74 da                	je     801885 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8018ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018af:	75 07                	jne    8018b8 <strncmp+0x38>
		return 0;
  8018b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b6:	eb 14                	jmp    8018cc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	8a 00                	mov    (%eax),%al
  8018bd:	0f b6 d0             	movzbl %al,%edx
  8018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c3:	8a 00                	mov    (%eax),%al
  8018c5:	0f b6 c0             	movzbl %al,%eax
  8018c8:	29 c2                	sub    %eax,%edx
  8018ca:	89 d0                	mov    %edx,%eax
}
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018da:	eb 12                	jmp    8018ee <strchr+0x20>
		if (*s == c)
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8a 00                	mov    (%eax),%al
  8018e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018e4:	75 05                	jne    8018eb <strchr+0x1d>
			return (char *) s;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	eb 11                	jmp    8018fc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018eb:	ff 45 08             	incl   0x8(%ebp)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8a 00                	mov    (%eax),%al
  8018f3:	84 c0                	test   %al,%al
  8018f5:	75 e5                	jne    8018dc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80190a:	eb 0d                	jmp    801919 <strfind+0x1b>
		if (*s == c)
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8a 00                	mov    (%eax),%al
  801911:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801914:	74 0e                	je     801924 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801916:	ff 45 08             	incl   0x8(%ebp)
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8a 00                	mov    (%eax),%al
  80191e:	84 c0                	test   %al,%al
  801920:	75 ea                	jne    80190c <strfind+0xe>
  801922:	eb 01                	jmp    801925 <strfind+0x27>
		if (*s == c)
			break;
  801924:	90                   	nop
	return (char *) s;
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801936:	8b 45 10             	mov    0x10(%ebp),%eax
  801939:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80193c:	eb 0e                	jmp    80194c <memset+0x22>
		*p++ = c;
  80193e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801941:	8d 50 01             	lea    0x1(%eax),%edx
  801944:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80194c:	ff 4d f8             	decl   -0x8(%ebp)
  80194f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801953:	79 e9                	jns    80193e <memset+0x14>
		*p++ = c;

	return v;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801960:	8b 45 0c             	mov    0xc(%ebp),%eax
  801963:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80196c:	eb 16                	jmp    801984 <memcpy+0x2a>
		*d++ = *s++;
  80196e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801971:	8d 50 01             	lea    0x1(%eax),%edx
  801974:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801977:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801980:	8a 12                	mov    (%edx),%dl
  801982:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801984:	8b 45 10             	mov    0x10(%ebp),%eax
  801987:	8d 50 ff             	lea    -0x1(%eax),%edx
  80198a:	89 55 10             	mov    %edx,0x10(%ebp)
  80198d:	85 c0                	test   %eax,%eax
  80198f:	75 dd                	jne    80196e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8019a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019ae:	73 50                	jae    801a00 <memmove+0x6a>
  8019b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b6:	01 d0                	add    %edx,%eax
  8019b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019bb:	76 43                	jbe    801a00 <memmove+0x6a>
		s += n;
  8019bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019c9:	eb 10                	jmp    8019db <memmove+0x45>
			*--d = *--s;
  8019cb:	ff 4d f8             	decl   -0x8(%ebp)
  8019ce:	ff 4d fc             	decl   -0x4(%ebp)
  8019d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d4:	8a 10                	mov    (%eax),%dl
  8019d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
  8019de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	75 e3                	jne    8019cb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019e8:	eb 23                	jmp    801a0d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019fc:	8a 12                	mov    (%edx),%dl
  8019fe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a06:	89 55 10             	mov    %edx,0x10(%ebp)
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	75 dd                	jne    8019ea <memmove+0x54>
			*d++ = *s++;

	return dst;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a24:	eb 2a                	jmp    801a50 <memcmp+0x3e>
		if (*s1 != *s2)
  801a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a29:	8a 10                	mov    (%eax),%dl
  801a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2e:	8a 00                	mov    (%eax),%al
  801a30:	38 c2                	cmp    %al,%dl
  801a32:	74 16                	je     801a4a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a37:	8a 00                	mov    (%eax),%al
  801a39:	0f b6 d0             	movzbl %al,%edx
  801a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	0f b6 c0             	movzbl %al,%eax
  801a44:	29 c2                	sub    %eax,%edx
  801a46:	89 d0                	mov    %edx,%eax
  801a48:	eb 18                	jmp    801a62 <memcmp+0x50>
		s1++, s2++;
  801a4a:	ff 45 fc             	incl   -0x4(%ebp)
  801a4d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
  801a53:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a56:	89 55 10             	mov    %edx,0x10(%ebp)
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	75 c9                	jne    801a26 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a70:	01 d0                	add    %edx,%eax
  801a72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a75:	eb 15                	jmp    801a8c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d0             	movzbl %al,%edx
  801a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a82:	0f b6 c0             	movzbl %al,%eax
  801a85:	39 c2                	cmp    %eax,%edx
  801a87:	74 0d                	je     801a96 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a89:	ff 45 08             	incl   0x8(%ebp)
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a92:	72 e3                	jb     801a77 <memfind+0x13>
  801a94:	eb 01                	jmp    801a97 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a96:	90                   	nop
	return (void *) s;
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801aa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801aa9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ab0:	eb 03                	jmp    801ab5 <strtol+0x19>
		s++;
  801ab2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8a 00                	mov    (%eax),%al
  801aba:	3c 20                	cmp    $0x20,%al
  801abc:	74 f4                	je     801ab2 <strtol+0x16>
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	3c 09                	cmp    $0x9,%al
  801ac5:	74 eb                	je     801ab2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8a 00                	mov    (%eax),%al
  801acc:	3c 2b                	cmp    $0x2b,%al
  801ace:	75 05                	jne    801ad5 <strtol+0x39>
		s++;
  801ad0:	ff 45 08             	incl   0x8(%ebp)
  801ad3:	eb 13                	jmp    801ae8 <strtol+0x4c>
	else if (*s == '-')
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	8a 00                	mov    (%eax),%al
  801ada:	3c 2d                	cmp    $0x2d,%al
  801adc:	75 0a                	jne    801ae8 <strtol+0x4c>
		s++, neg = 1;
  801ade:	ff 45 08             	incl   0x8(%ebp)
  801ae1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aec:	74 06                	je     801af4 <strtol+0x58>
  801aee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801af2:	75 20                	jne    801b14 <strtol+0x78>
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	8a 00                	mov    (%eax),%al
  801af9:	3c 30                	cmp    $0x30,%al
  801afb:	75 17                	jne    801b14 <strtol+0x78>
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	40                   	inc    %eax
  801b01:	8a 00                	mov    (%eax),%al
  801b03:	3c 78                	cmp    $0x78,%al
  801b05:	75 0d                	jne    801b14 <strtol+0x78>
		s += 2, base = 16;
  801b07:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801b0b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801b12:	eb 28                	jmp    801b3c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b18:	75 15                	jne    801b2f <strtol+0x93>
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	8a 00                	mov    (%eax),%al
  801b1f:	3c 30                	cmp    $0x30,%al
  801b21:	75 0c                	jne    801b2f <strtol+0x93>
		s++, base = 8;
  801b23:	ff 45 08             	incl   0x8(%ebp)
  801b26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b2d:	eb 0d                	jmp    801b3c <strtol+0xa0>
	else if (base == 0)
  801b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b33:	75 07                	jne    801b3c <strtol+0xa0>
		base = 10;
  801b35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	8a 00                	mov    (%eax),%al
  801b41:	3c 2f                	cmp    $0x2f,%al
  801b43:	7e 19                	jle    801b5e <strtol+0xc2>
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	8a 00                	mov    (%eax),%al
  801b4a:	3c 39                	cmp    $0x39,%al
  801b4c:	7f 10                	jg     801b5e <strtol+0xc2>
			dig = *s - '0';
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	0f be c0             	movsbl %al,%eax
  801b56:	83 e8 30             	sub    $0x30,%eax
  801b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5c:	eb 42                	jmp    801ba0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	8a 00                	mov    (%eax),%al
  801b63:	3c 60                	cmp    $0x60,%al
  801b65:	7e 19                	jle    801b80 <strtol+0xe4>
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	8a 00                	mov    (%eax),%al
  801b6c:	3c 7a                	cmp    $0x7a,%al
  801b6e:	7f 10                	jg     801b80 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	8a 00                	mov    (%eax),%al
  801b75:	0f be c0             	movsbl %al,%eax
  801b78:	83 e8 57             	sub    $0x57,%eax
  801b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7e:	eb 20                	jmp    801ba0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	8a 00                	mov    (%eax),%al
  801b85:	3c 40                	cmp    $0x40,%al
  801b87:	7e 39                	jle    801bc2 <strtol+0x126>
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	8a 00                	mov    (%eax),%al
  801b8e:	3c 5a                	cmp    $0x5a,%al
  801b90:	7f 30                	jg     801bc2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	8a 00                	mov    (%eax),%al
  801b97:	0f be c0             	movsbl %al,%eax
  801b9a:	83 e8 37             	sub    $0x37,%eax
  801b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba3:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ba6:	7d 19                	jge    801bc1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ba8:	ff 45 08             	incl   0x8(%ebp)
  801bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bae:	0f af 45 10          	imul   0x10(%ebp),%eax
  801bb2:	89 c2                	mov    %eax,%edx
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	01 d0                	add    %edx,%eax
  801bb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801bbc:	e9 7b ff ff ff       	jmp    801b3c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bc1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801bc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bc6:	74 08                	je     801bd0 <strtol+0x134>
		*endptr = (char *) s;
  801bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bd4:	74 07                	je     801bdd <strtol+0x141>
  801bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd9:	f7 d8                	neg    %eax
  801bdb:	eb 03                	jmp    801be0 <strtol+0x144>
  801bdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <ltostr>:

void
ltostr(long value, char *str)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801be8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801bf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bfa:	79 13                	jns    801c0f <ltostr+0x2d>
	{
		neg = 1;
  801bfc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c06:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801c09:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801c0c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c17:	99                   	cltd   
  801c18:	f7 f9                	idiv   %ecx
  801c1a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c20:	8d 50 01             	lea    0x1(%eax),%edx
  801c23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c26:	89 c2                	mov    %eax,%edx
  801c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2b:	01 d0                	add    %edx,%eax
  801c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c30:	83 c2 30             	add    $0x30,%edx
  801c33:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c38:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c3d:	f7 e9                	imul   %ecx
  801c3f:	c1 fa 02             	sar    $0x2,%edx
  801c42:	89 c8                	mov    %ecx,%eax
  801c44:	c1 f8 1f             	sar    $0x1f,%eax
  801c47:	29 c2                	sub    %eax,%edx
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c51:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c56:	f7 e9                	imul   %ecx
  801c58:	c1 fa 02             	sar    $0x2,%edx
  801c5b:	89 c8                	mov    %ecx,%eax
  801c5d:	c1 f8 1f             	sar    $0x1f,%eax
  801c60:	29 c2                	sub    %eax,%edx
  801c62:	89 d0                	mov    %edx,%eax
  801c64:	c1 e0 02             	shl    $0x2,%eax
  801c67:	01 d0                	add    %edx,%eax
  801c69:	01 c0                	add    %eax,%eax
  801c6b:	29 c1                	sub    %eax,%ecx
  801c6d:	89 ca                	mov    %ecx,%edx
  801c6f:	85 d2                	test   %edx,%edx
  801c71:	75 9c                	jne    801c0f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7d:	48                   	dec    %eax
  801c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c81:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c85:	74 3d                	je     801cc4 <ltostr+0xe2>
		start = 1 ;
  801c87:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c8e:	eb 34                	jmp    801cc4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c96:	01 d0                	add    %edx,%eax
  801c98:	8a 00                	mov    (%eax),%al
  801c9a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca3:	01 c2                	add    %eax,%edx
  801ca5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	01 c8                	add    %ecx,%eax
  801cad:	8a 00                	mov    (%eax),%al
  801caf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801cb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb7:	01 c2                	add    %eax,%edx
  801cb9:	8a 45 eb             	mov    -0x15(%ebp),%al
  801cbc:	88 02                	mov    %al,(%edx)
		start++ ;
  801cbe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cc1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cca:	7c c4                	jl     801c90 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ccc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd2:	01 d0                	add    %edx,%eax
  801cd4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 54 fa ff ff       	call   80173c <strlen>
  801ce8:	83 c4 04             	add    $0x4,%esp
  801ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	e8 46 fa ff ff       	call   80173c <strlen>
  801cf6:	83 c4 04             	add    $0x4,%esp
  801cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801d03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d0a:	eb 17                	jmp    801d23 <strcconcat+0x49>
		final[s] = str1[s] ;
  801d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d12:	01 c2                	add    %eax,%edx
  801d14:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	01 c8                	add    %ecx,%eax
  801d1c:	8a 00                	mov    (%eax),%al
  801d1e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d20:	ff 45 fc             	incl   -0x4(%ebp)
  801d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d29:	7c e1                	jl     801d0c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d39:	eb 1f                	jmp    801d5a <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3e:	8d 50 01             	lea    0x1(%eax),%edx
  801d41:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	8b 45 10             	mov    0x10(%ebp),%eax
  801d49:	01 c2                	add    %eax,%edx
  801d4b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d51:	01 c8                	add    %ecx,%eax
  801d53:	8a 00                	mov    (%eax),%al
  801d55:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d57:	ff 45 f8             	incl   -0x8(%ebp)
  801d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d60:	7c d9                	jl     801d3b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d65:	8b 45 10             	mov    0x10(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	c6 00 00             	movb   $0x0,(%eax)
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	8b 00                	mov    (%eax),%eax
  801d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d88:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8b:	01 d0                	add    %edx,%eax
  801d8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d93:	eb 0c                	jmp    801da1 <strsplit+0x31>
			*string++ = 0;
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	8d 50 01             	lea    0x1(%eax),%edx
  801d9b:	89 55 08             	mov    %edx,0x8(%ebp)
  801d9e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	8a 00                	mov    (%eax),%al
  801da6:	84 c0                	test   %al,%al
  801da8:	74 18                	je     801dc2 <strsplit+0x52>
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	8a 00                	mov    (%eax),%al
  801daf:	0f be c0             	movsbl %al,%eax
  801db2:	50                   	push   %eax
  801db3:	ff 75 0c             	pushl  0xc(%ebp)
  801db6:	e8 13 fb ff ff       	call   8018ce <strchr>
  801dbb:	83 c4 08             	add    $0x8,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 d3                	jne    801d95 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	8a 00                	mov    (%eax),%al
  801dc7:	84 c0                	test   %al,%al
  801dc9:	74 5a                	je     801e25 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	83 f8 0f             	cmp    $0xf,%eax
  801dd3:	75 07                	jne    801ddc <strsplit+0x6c>
		{
			return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb 66                	jmp    801e42 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddf:	8b 00                	mov    (%eax),%eax
  801de1:	8d 48 01             	lea    0x1(%eax),%ecx
  801de4:	8b 55 14             	mov    0x14(%ebp),%edx
  801de7:	89 0a                	mov    %ecx,(%edx)
  801de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df0:	8b 45 10             	mov    0x10(%ebp),%eax
  801df3:	01 c2                	add    %eax,%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dfa:	eb 03                	jmp    801dff <strsplit+0x8f>
			string++;
  801dfc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	8a 00                	mov    (%eax),%al
  801e04:	84 c0                	test   %al,%al
  801e06:	74 8b                	je     801d93 <strsplit+0x23>
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	8a 00                	mov    (%eax),%al
  801e0d:	0f be c0             	movsbl %al,%eax
  801e10:	50                   	push   %eax
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	e8 b5 fa ff ff       	call   8018ce <strchr>
  801e19:	83 c4 08             	add    $0x8,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	74 dc                	je     801dfc <strsplit+0x8c>
			string++;
	}
  801e20:	e9 6e ff ff ff       	jmp    801d93 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e25:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e26:	8b 45 14             	mov    0x14(%ebp),%eax
  801e29:	8b 00                	mov    (%eax),%eax
  801e2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e32:	8b 45 10             	mov    0x10(%ebp),%eax
  801e35:	01 d0                	add    %edx,%eax
  801e37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	68 30 30 80 00       	push   $0x803030
  801e52:	6a 0e                	push   $0xe
  801e54:	68 6a 30 80 00       	push   $0x80306a
  801e59:	e8 a8 ef ff ff       	call   800e06 <_panic>

00801e5e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801e64:	a1 04 40 80 00       	mov    0x804004,%eax
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	74 0f                	je     801e7c <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801e6d:	e8 d2 ff ff ff       	call   801e44 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e72:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801e79:	00 00 00 
	}
	if (size == 0) return NULL ;
  801e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e80:	75 07                	jne    801e89 <malloc+0x2b>
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
  801e87:	eb 14                	jmp    801e9d <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 78 30 80 00       	push   $0x803078
  801e91:	6a 2e                	push   $0x2e
  801e93:	68 6a 30 80 00       	push   $0x80306a
  801e98:	e8 69 ef ff ff       	call   800e06 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 a0 30 80 00       	push   $0x8030a0
  801ead:	6a 49                	push   $0x49
  801eaf:	68 6a 30 80 00       	push   $0x80306a
  801eb4:	e8 4d ef ff ff       	call   800e06 <_panic>

00801eb9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 18             	sub    $0x18,%esp
  801ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec2:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	68 c4 30 80 00       	push   $0x8030c4
  801ecd:	6a 57                	push   $0x57
  801ecf:	68 6a 30 80 00       	push   $0x80306a
  801ed4:	e8 2d ef ff ff       	call   800e06 <_panic>

00801ed9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 ec 30 80 00       	push   $0x8030ec
  801ee7:	6a 60                	push   $0x60
  801ee9:	68 6a 30 80 00       	push   $0x80306a
  801eee:	e8 13 ef ff ff       	call   800e06 <_panic>

00801ef3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ef9:	83 ec 04             	sub    $0x4,%esp
  801efc:	68 10 31 80 00       	push   $0x803110
  801f01:	6a 7c                	push   $0x7c
  801f03:	68 6a 30 80 00       	push   $0x80306a
  801f08:	e8 f9 ee ff ff       	call   800e06 <_panic>

00801f0d <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	68 38 31 80 00       	push   $0x803138
  801f1b:	68 86 00 00 00       	push   $0x86
  801f20:	68 6a 30 80 00       	push   $0x80306a
  801f25:	e8 dc ee ff ff       	call   800e06 <_panic>

00801f2a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	68 5c 31 80 00       	push   $0x80315c
  801f38:	68 91 00 00 00       	push   $0x91
  801f3d:	68 6a 30 80 00       	push   $0x80306a
  801f42:	e8 bf ee ff ff       	call   800e06 <_panic>

00801f47 <shrink>:

}
void shrink(uint32 newSize)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	68 5c 31 80 00       	push   $0x80315c
  801f55:	68 96 00 00 00       	push   $0x96
  801f5a:	68 6a 30 80 00       	push   $0x80306a
  801f5f:	e8 a2 ee ff ff       	call   800e06 <_panic>

00801f64 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 5c 31 80 00       	push   $0x80315c
  801f72:	68 9b 00 00 00       	push   $0x9b
  801f77:	68 6a 30 80 00       	push   $0x80306a
  801f7c:	e8 85 ee ff ff       	call   800e06 <_panic>

00801f81 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	57                   	push   %edi
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
  801f87:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f96:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f99:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f9c:	cd 30                	int    $0x30
  801f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fb8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	52                   	push   %edx
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	50                   	push   %eax
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 b2 ff ff ff       	call   801f81 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	90                   	nop
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 01                	push   $0x1
  801fe4:	e8 98 ff ff ff       	call   801f81 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	6a 05                	push   $0x5
  802001:	e8 7b ff ff ff       	call   801f81 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802010:	8b 75 18             	mov    0x18(%ebp),%esi
  802013:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802016:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	51                   	push   %ecx
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	6a 06                	push   $0x6
  802026:	e8 56 ff ff ff       	call   801f81 <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    

00802035 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	6a 07                	push   $0x7
  802048:	e8 34 ff ff ff       	call   801f81 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	6a 08                	push   $0x8
  802063:	e8 19 ff ff ff       	call   801f81 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 09                	push   $0x9
  80207c:	e8 00 ff ff ff       	call   801f81 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 0a                	push   $0xa
  802095:	e8 e7 fe ff ff       	call   801f81 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 0b                	push   $0xb
  8020ae:	e8 ce fe ff ff       	call   801f81 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	ff 75 0c             	pushl  0xc(%ebp)
  8020c4:	ff 75 08             	pushl  0x8(%ebp)
  8020c7:	6a 0f                	push   $0xf
  8020c9:	e8 b3 fe ff ff       	call   801f81 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
	return;
  8020d1:	90                   	nop
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	ff 75 08             	pushl  0x8(%ebp)
  8020e3:	6a 10                	push   $0x10
  8020e5:	e8 97 fe ff ff       	call   801f81 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ed:	90                   	nop
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	ff 75 10             	pushl  0x10(%ebp)
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	ff 75 08             	pushl  0x8(%ebp)
  802100:	6a 11                	push   $0x11
  802102:	e8 7a fe ff ff       	call   801f81 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
	return ;
  80210a:	90                   	nop
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 0c                	push   $0xc
  80211c:	e8 60 fe ff ff       	call   801f81 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 0d                	push   $0xd
  802136:	e8 46 fe ff ff       	call   801f81 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 0e                	push   $0xe
  80214f:	e8 2d fe ff ff       	call   801f81 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	90                   	nop
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 13                	push   $0x13
  802169:	e8 13 fe ff ff       	call   801f81 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	90                   	nop
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 14                	push   $0x14
  802183:	e8 f9 fd ff ff       	call   801f81 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	90                   	nop
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_cputc>:


void
sys_cputc(const char c)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80219a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	50                   	push   %eax
  8021a7:	6a 15                	push   $0x15
  8021a9:	e8 d3 fd ff ff       	call   801f81 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	90                   	nop
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 16                	push   $0x16
  8021c3:	e8 b9 fd ff ff       	call   801f81 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	90                   	nop
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	ff 75 0c             	pushl  0xc(%ebp)
  8021dd:	50                   	push   %eax
  8021de:	6a 17                	push   $0x17
  8021e0:	e8 9c fd ff ff       	call   801f81 <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	52                   	push   %edx
  8021fa:	50                   	push   %eax
  8021fb:	6a 1a                	push   $0x1a
  8021fd:	e8 7f fd ff ff       	call   801f81 <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	52                   	push   %edx
  802217:	50                   	push   %eax
  802218:	6a 18                	push   $0x18
  80221a:	e8 62 fd ff ff       	call   801f81 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	52                   	push   %edx
  802235:	50                   	push   %eax
  802236:	6a 19                	push   $0x19
  802238:	e8 44 fd ff ff       	call   801f81 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	90                   	nop
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	8b 45 10             	mov    0x10(%ebp),%eax
  80224c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80224f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802252:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	6a 00                	push   $0x0
  80225b:	51                   	push   %ecx
  80225c:	52                   	push   %edx
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	50                   	push   %eax
  802261:	6a 1b                	push   $0x1b
  802263:	e8 19 fd ff ff       	call   801f81 <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802270:	8b 55 0c             	mov    0xc(%ebp),%edx
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	52                   	push   %edx
  80227d:	50                   	push   %eax
  80227e:	6a 1c                	push   $0x1c
  802280:	e8 fc fc ff ff       	call   801f81 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80228d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802290:	8b 55 0c             	mov    0xc(%ebp),%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	51                   	push   %ecx
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 1d                	push   $0x1d
  80229f:	e8 dd fc ff ff       	call   801f81 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	52                   	push   %edx
  8022b9:	50                   	push   %eax
  8022ba:	6a 1e                	push   $0x1e
  8022bc:	e8 c0 fc ff ff       	call   801f81 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 1f                	push   $0x1f
  8022d5:	e8 a7 fc ff ff       	call   801f81 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	6a 00                	push   $0x0
  8022e7:	ff 75 14             	pushl  0x14(%ebp)
  8022ea:	ff 75 10             	pushl  0x10(%ebp)
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	50                   	push   %eax
  8022f1:	6a 20                	push   $0x20
  8022f3:	e8 89 fc ff ff       	call   801f81 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	50                   	push   %eax
  80230c:	6a 21                	push   $0x21
  80230e:	e8 6e fc ff ff       	call   801f81 <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	50                   	push   %eax
  802328:	6a 22                	push   $0x22
  80232a:	e8 52 fc ff ff       	call   801f81 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 02                	push   $0x2
  802343:	e8 39 fc ff ff       	call   801f81 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 03                	push   $0x3
  80235c:	e8 20 fc ff ff       	call   801f81 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 04                	push   $0x4
  802375:	e8 07 fc ff ff       	call   801f81 <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_exit_env>:


void sys_exit_env(void)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 23                	push   $0x23
  80238e:	e8 ee fb ff ff       	call   801f81 <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	90                   	nop
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80239f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023a2:	8d 50 04             	lea    0x4(%eax),%edx
  8023a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	52                   	push   %edx
  8023af:	50                   	push   %eax
  8023b0:	6a 24                	push   $0x24
  8023b2:	e8 ca fb ff ff       	call   801f81 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
	return result;
  8023ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023c3:	89 01                	mov    %eax,(%ecx)
  8023c5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	c9                   	leave  
  8023cc:	c2 04 00             	ret    $0x4

008023cf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	ff 75 10             	pushl  0x10(%ebp)
  8023d9:	ff 75 0c             	pushl  0xc(%ebp)
  8023dc:	ff 75 08             	pushl  0x8(%ebp)
  8023df:	6a 12                	push   $0x12
  8023e1:	e8 9b fb ff ff       	call   801f81 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e9:	90                   	nop
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_rcr2>:
uint32 sys_rcr2()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 25                	push   $0x25
  8023fb:	e8 81 fb ff ff       	call   801f81 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802411:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	50                   	push   %eax
  80241e:	6a 26                	push   $0x26
  802420:	e8 5c fb ff ff       	call   801f81 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
	return ;
  802428:	90                   	nop
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <rsttst>:
void rsttst()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 28                	push   $0x28
  80243a:	e8 42 fb ff ff       	call   801f81 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
	return ;
  802442:	90                   	nop
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	8b 45 14             	mov    0x14(%ebp),%eax
  80244e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802451:	8b 55 18             	mov    0x18(%ebp),%edx
  802454:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802458:	52                   	push   %edx
  802459:	50                   	push   %eax
  80245a:	ff 75 10             	pushl  0x10(%ebp)
  80245d:	ff 75 0c             	pushl  0xc(%ebp)
  802460:	ff 75 08             	pushl  0x8(%ebp)
  802463:	6a 27                	push   $0x27
  802465:	e8 17 fb ff ff       	call   801f81 <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
	return ;
  80246d:	90                   	nop
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <chktst>:
void chktst(uint32 n)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	ff 75 08             	pushl  0x8(%ebp)
  80247e:	6a 29                	push   $0x29
  802480:	e8 fc fa ff ff       	call   801f81 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return ;
  802488:	90                   	nop
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <inctst>:

void inctst()
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 2a                	push   $0x2a
  80249a:	e8 e2 fa ff ff       	call   801f81 <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a2:	90                   	nop
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <gettst>:
uint32 gettst()
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 2b                	push   $0x2b
  8024b4:	e8 c8 fa ff ff       	call   801f81 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 2c                	push   $0x2c
  8024d0:	e8 ac fa ff ff       	call   801f81 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
  8024d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024db:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024df:	75 07                	jne    8024e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e6:	eb 05                	jmp    8024ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 2c                	push   $0x2c
  802501:	e8 7b fa ff ff       	call   801f81 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
  802509:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80250c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802510:	75 07                	jne    802519 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802512:	b8 01 00 00 00       	mov    $0x1,%eax
  802517:	eb 05                	jmp    80251e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 2c                	push   $0x2c
  802532:	e8 4a fa ff ff       	call   801f81 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
  80253a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80253d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802541:	75 07                	jne    80254a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802543:	b8 01 00 00 00       	mov    $0x1,%eax
  802548:	eb 05                	jmp    80254f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 2c                	push   $0x2c
  802563:	e8 19 fa ff ff       	call   801f81 <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
  80256b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80256e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802572:	75 07                	jne    80257b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802574:	b8 01 00 00 00       	mov    $0x1,%eax
  802579:	eb 05                	jmp    802580 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	ff 75 08             	pushl  0x8(%ebp)
  802590:	6a 2d                	push   $0x2d
  802592:	e8 ea f9 ff ff       	call   801f81 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
	return ;
  80259a:	90                   	nop
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	6a 00                	push   $0x0
  8025af:	53                   	push   %ebx
  8025b0:	51                   	push   %ecx
  8025b1:	52                   	push   %edx
  8025b2:	50                   	push   %eax
  8025b3:	6a 2e                	push   $0x2e
  8025b5:	e8 c7 f9 ff ff       	call   801f81 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
}
  8025bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	52                   	push   %edx
  8025d2:	50                   	push   %eax
  8025d3:	6a 2f                	push   $0x2f
  8025d5:	e8 a7 f9 ff ff       	call   801f81 <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    
  8025df:	90                   	nop

008025e0 <__udivdi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 1c             	sub    $0x1c,%esp
  8025e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8025eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8025ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025f7:	89 ca                	mov    %ecx,%edx
  8025f9:	89 f8                	mov    %edi,%eax
  8025fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8025ff:	85 f6                	test   %esi,%esi
  802601:	75 2d                	jne    802630 <__udivdi3+0x50>
  802603:	39 cf                	cmp    %ecx,%edi
  802605:	77 65                	ja     80266c <__udivdi3+0x8c>
  802607:	89 fd                	mov    %edi,%ebp
  802609:	85 ff                	test   %edi,%edi
  80260b:	75 0b                	jne    802618 <__udivdi3+0x38>
  80260d:	b8 01 00 00 00       	mov    $0x1,%eax
  802612:	31 d2                	xor    %edx,%edx
  802614:	f7 f7                	div    %edi
  802616:	89 c5                	mov    %eax,%ebp
  802618:	31 d2                	xor    %edx,%edx
  80261a:	89 c8                	mov    %ecx,%eax
  80261c:	f7 f5                	div    %ebp
  80261e:	89 c1                	mov    %eax,%ecx
  802620:	89 d8                	mov    %ebx,%eax
  802622:	f7 f5                	div    %ebp
  802624:	89 cf                	mov    %ecx,%edi
  802626:	89 fa                	mov    %edi,%edx
  802628:	83 c4 1c             	add    $0x1c,%esp
  80262b:	5b                   	pop    %ebx
  80262c:	5e                   	pop    %esi
  80262d:	5f                   	pop    %edi
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    
  802630:	39 ce                	cmp    %ecx,%esi
  802632:	77 28                	ja     80265c <__udivdi3+0x7c>
  802634:	0f bd fe             	bsr    %esi,%edi
  802637:	83 f7 1f             	xor    $0x1f,%edi
  80263a:	75 40                	jne    80267c <__udivdi3+0x9c>
  80263c:	39 ce                	cmp    %ecx,%esi
  80263e:	72 0a                	jb     80264a <__udivdi3+0x6a>
  802640:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802644:	0f 87 9e 00 00 00    	ja     8026e8 <__udivdi3+0x108>
  80264a:	b8 01 00 00 00       	mov    $0x1,%eax
  80264f:	89 fa                	mov    %edi,%edx
  802651:	83 c4 1c             	add    $0x1c,%esp
  802654:	5b                   	pop    %ebx
  802655:	5e                   	pop    %esi
  802656:	5f                   	pop    %edi
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    
  802659:	8d 76 00             	lea    0x0(%esi),%esi
  80265c:	31 ff                	xor    %edi,%edi
  80265e:	31 c0                	xor    %eax,%eax
  802660:	89 fa                	mov    %edi,%edx
  802662:	83 c4 1c             	add    $0x1c,%esp
  802665:	5b                   	pop    %ebx
  802666:	5e                   	pop    %esi
  802667:	5f                   	pop    %edi
  802668:	5d                   	pop    %ebp
  802669:	c3                   	ret    
  80266a:	66 90                	xchg   %ax,%ax
  80266c:	89 d8                	mov    %ebx,%eax
  80266e:	f7 f7                	div    %edi
  802670:	31 ff                	xor    %edi,%edi
  802672:	89 fa                	mov    %edi,%edx
  802674:	83 c4 1c             	add    $0x1c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    
  80267c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802681:	89 eb                	mov    %ebp,%ebx
  802683:	29 fb                	sub    %edi,%ebx
  802685:	89 f9                	mov    %edi,%ecx
  802687:	d3 e6                	shl    %cl,%esi
  802689:	89 c5                	mov    %eax,%ebp
  80268b:	88 d9                	mov    %bl,%cl
  80268d:	d3 ed                	shr    %cl,%ebp
  80268f:	89 e9                	mov    %ebp,%ecx
  802691:	09 f1                	or     %esi,%ecx
  802693:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802697:	89 f9                	mov    %edi,%ecx
  802699:	d3 e0                	shl    %cl,%eax
  80269b:	89 c5                	mov    %eax,%ebp
  80269d:	89 d6                	mov    %edx,%esi
  80269f:	88 d9                	mov    %bl,%cl
  8026a1:	d3 ee                	shr    %cl,%esi
  8026a3:	89 f9                	mov    %edi,%ecx
  8026a5:	d3 e2                	shl    %cl,%edx
  8026a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026ab:	88 d9                	mov    %bl,%cl
  8026ad:	d3 e8                	shr    %cl,%eax
  8026af:	09 c2                	or     %eax,%edx
  8026b1:	89 d0                	mov    %edx,%eax
  8026b3:	89 f2                	mov    %esi,%edx
  8026b5:	f7 74 24 0c          	divl   0xc(%esp)
  8026b9:	89 d6                	mov    %edx,%esi
  8026bb:	89 c3                	mov    %eax,%ebx
  8026bd:	f7 e5                	mul    %ebp
  8026bf:	39 d6                	cmp    %edx,%esi
  8026c1:	72 19                	jb     8026dc <__udivdi3+0xfc>
  8026c3:	74 0b                	je     8026d0 <__udivdi3+0xf0>
  8026c5:	89 d8                	mov    %ebx,%eax
  8026c7:	31 ff                	xor    %edi,%edi
  8026c9:	e9 58 ff ff ff       	jmp    802626 <__udivdi3+0x46>
  8026ce:	66 90                	xchg   %ax,%ax
  8026d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8026d4:	89 f9                	mov    %edi,%ecx
  8026d6:	d3 e2                	shl    %cl,%edx
  8026d8:	39 c2                	cmp    %eax,%edx
  8026da:	73 e9                	jae    8026c5 <__udivdi3+0xe5>
  8026dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026df:	31 ff                	xor    %edi,%edi
  8026e1:	e9 40 ff ff ff       	jmp    802626 <__udivdi3+0x46>
  8026e6:	66 90                	xchg   %ax,%ax
  8026e8:	31 c0                	xor    %eax,%eax
  8026ea:	e9 37 ff ff ff       	jmp    802626 <__udivdi3+0x46>
  8026ef:	90                   	nop

008026f0 <__umoddi3>:
  8026f0:	55                   	push   %ebp
  8026f1:	57                   	push   %edi
  8026f2:	56                   	push   %esi
  8026f3:	53                   	push   %ebx
  8026f4:	83 ec 1c             	sub    $0x1c,%esp
  8026f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8026fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802703:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802707:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80270b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80270f:	89 f3                	mov    %esi,%ebx
  802711:	89 fa                	mov    %edi,%edx
  802713:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802717:	89 34 24             	mov    %esi,(%esp)
  80271a:	85 c0                	test   %eax,%eax
  80271c:	75 1a                	jne    802738 <__umoddi3+0x48>
  80271e:	39 f7                	cmp    %esi,%edi
  802720:	0f 86 a2 00 00 00    	jbe    8027c8 <__umoddi3+0xd8>
  802726:	89 c8                	mov    %ecx,%eax
  802728:	89 f2                	mov    %esi,%edx
  80272a:	f7 f7                	div    %edi
  80272c:	89 d0                	mov    %edx,%eax
  80272e:	31 d2                	xor    %edx,%edx
  802730:	83 c4 1c             	add    $0x1c,%esp
  802733:	5b                   	pop    %ebx
  802734:	5e                   	pop    %esi
  802735:	5f                   	pop    %edi
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    
  802738:	39 f0                	cmp    %esi,%eax
  80273a:	0f 87 ac 00 00 00    	ja     8027ec <__umoddi3+0xfc>
  802740:	0f bd e8             	bsr    %eax,%ebp
  802743:	83 f5 1f             	xor    $0x1f,%ebp
  802746:	0f 84 ac 00 00 00    	je     8027f8 <__umoddi3+0x108>
  80274c:	bf 20 00 00 00       	mov    $0x20,%edi
  802751:	29 ef                	sub    %ebp,%edi
  802753:	89 fe                	mov    %edi,%esi
  802755:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802759:	89 e9                	mov    %ebp,%ecx
  80275b:	d3 e0                	shl    %cl,%eax
  80275d:	89 d7                	mov    %edx,%edi
  80275f:	89 f1                	mov    %esi,%ecx
  802761:	d3 ef                	shr    %cl,%edi
  802763:	09 c7                	or     %eax,%edi
  802765:	89 e9                	mov    %ebp,%ecx
  802767:	d3 e2                	shl    %cl,%edx
  802769:	89 14 24             	mov    %edx,(%esp)
  80276c:	89 d8                	mov    %ebx,%eax
  80276e:	d3 e0                	shl    %cl,%eax
  802770:	89 c2                	mov    %eax,%edx
  802772:	8b 44 24 08          	mov    0x8(%esp),%eax
  802776:	d3 e0                	shl    %cl,%eax
  802778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802780:	89 f1                	mov    %esi,%ecx
  802782:	d3 e8                	shr    %cl,%eax
  802784:	09 d0                	or     %edx,%eax
  802786:	d3 eb                	shr    %cl,%ebx
  802788:	89 da                	mov    %ebx,%edx
  80278a:	f7 f7                	div    %edi
  80278c:	89 d3                	mov    %edx,%ebx
  80278e:	f7 24 24             	mull   (%esp)
  802791:	89 c6                	mov    %eax,%esi
  802793:	89 d1                	mov    %edx,%ecx
  802795:	39 d3                	cmp    %edx,%ebx
  802797:	0f 82 87 00 00 00    	jb     802824 <__umoddi3+0x134>
  80279d:	0f 84 91 00 00 00    	je     802834 <__umoddi3+0x144>
  8027a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027a7:	29 f2                	sub    %esi,%edx
  8027a9:	19 cb                	sbb    %ecx,%ebx
  8027ab:	89 d8                	mov    %ebx,%eax
  8027ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8027b1:	d3 e0                	shl    %cl,%eax
  8027b3:	89 e9                	mov    %ebp,%ecx
  8027b5:	d3 ea                	shr    %cl,%edx
  8027b7:	09 d0                	or     %edx,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	d3 eb                	shr    %cl,%ebx
  8027bd:	89 da                	mov    %ebx,%edx
  8027bf:	83 c4 1c             	add    $0x1c,%esp
  8027c2:	5b                   	pop    %ebx
  8027c3:	5e                   	pop    %esi
  8027c4:	5f                   	pop    %edi
  8027c5:	5d                   	pop    %ebp
  8027c6:	c3                   	ret    
  8027c7:	90                   	nop
  8027c8:	89 fd                	mov    %edi,%ebp
  8027ca:	85 ff                	test   %edi,%edi
  8027cc:	75 0b                	jne    8027d9 <__umoddi3+0xe9>
  8027ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d3:	31 d2                	xor    %edx,%edx
  8027d5:	f7 f7                	div    %edi
  8027d7:	89 c5                	mov    %eax,%ebp
  8027d9:	89 f0                	mov    %esi,%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	f7 f5                	div    %ebp
  8027df:	89 c8                	mov    %ecx,%eax
  8027e1:	f7 f5                	div    %ebp
  8027e3:	89 d0                	mov    %edx,%eax
  8027e5:	e9 44 ff ff ff       	jmp    80272e <__umoddi3+0x3e>
  8027ea:	66 90                	xchg   %ax,%ax
  8027ec:	89 c8                	mov    %ecx,%eax
  8027ee:	89 f2                	mov    %esi,%edx
  8027f0:	83 c4 1c             	add    $0x1c,%esp
  8027f3:	5b                   	pop    %ebx
  8027f4:	5e                   	pop    %esi
  8027f5:	5f                   	pop    %edi
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    
  8027f8:	3b 04 24             	cmp    (%esp),%eax
  8027fb:	72 06                	jb     802803 <__umoddi3+0x113>
  8027fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802801:	77 0f                	ja     802812 <__umoddi3+0x122>
  802803:	89 f2                	mov    %esi,%edx
  802805:	29 f9                	sub    %edi,%ecx
  802807:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80280b:	89 14 24             	mov    %edx,(%esp)
  80280e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802812:	8b 44 24 04          	mov    0x4(%esp),%eax
  802816:	8b 14 24             	mov    (%esp),%edx
  802819:	83 c4 1c             	add    $0x1c,%esp
  80281c:	5b                   	pop    %ebx
  80281d:	5e                   	pop    %esi
  80281e:	5f                   	pop    %edi
  80281f:	5d                   	pop    %ebp
  802820:	c3                   	ret    
  802821:	8d 76 00             	lea    0x0(%esi),%esi
  802824:	2b 04 24             	sub    (%esp),%eax
  802827:	19 fa                	sbb    %edi,%edx
  802829:	89 d1                	mov    %edx,%ecx
  80282b:	89 c6                	mov    %eax,%esi
  80282d:	e9 71 ff ff ff       	jmp    8027a3 <__umoddi3+0xb3>
  802832:	66 90                	xchg   %ax,%ax
  802834:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802838:	72 ea                	jb     802824 <__umoddi3+0x134>
  80283a:	89 d9                	mov    %ebx,%ecx
  80283c:	e9 62 ff ff ff       	jmp    8027a3 <__umoddi3+0xb3>
