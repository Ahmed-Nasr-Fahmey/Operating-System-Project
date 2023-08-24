
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
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
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 5c 24 00 00       	call   8024b7 <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 40 80 00       	mov    0x804020,%eax
  800070:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 40 80 00       	mov    0x804020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 80 27 80 00       	push   $0x802780
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 9c 27 80 00       	push   $0x80279c
  8000b8:	e8 7e 0c 00 00       	call   800d3b <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 cc 1c 00 00       	call   801d93 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 af 27 80 00       	push   $0x8027af
  8000ee:	68 c6 27 80 00       	push   $0x8027c6
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 9c 27 80 00       	push   $0x80279c
  8000fa:	e8 3c 0c 00 00       	call   800d3b <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 ae 23 00 00       	call   8024b7 <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 40 80 00       	mov    0x804020,%eax
  80011e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 80 27 80 00       	push   $0x802780
  80015f:	6a 32                	push   $0x32
  800161:	68 9c 27 80 00       	push   $0x80279c
  800166:	e8 d0 0b 00 00       	call   800d3b <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 40 80 00       	mov    0x804020,%eax
  80018e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 dc 27 80 00       	push   $0x8027dc
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 9c 27 80 00       	push   $0x80279c
  8001d5:	e8 61 0b 00 00       	call   800d3b <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 2c 28 80 00       	push   $0x80282c
  8001f6:	e8 f4 0d 00 00       	call   800fef <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 9f 1d 00 00       	call   801fa2 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 37 1e 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 6e 1b 00 00       	call   801d93 <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 7c 28 80 00       	push   $0x80287c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 9c 27 80 00       	push   $0x80279c
  8002b7:	e8 7f 0a 00 00       	call   800d3b <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 81 1d 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 ba 28 80 00       	push   $0x8028ba
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 9c 27 80 00       	push   $0x80279c
  8002eb:	e8 4b 0a 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 aa 1c 00 00       	call   801fa2 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 d7 28 80 00       	push   $0x8028d7
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 9c 27 80 00       	push   $0x80279c
  800321:	e8 15 0a 00 00       	call   800d3b <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 77 1c 00 00       	call   801fa2 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 0f 1d 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 8f 1a 00 00       	call   801dd4 <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 7d 1a 00 00       	call   801dd4 <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 6b 1a 00 00       	call   801dd4 <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 59 1a 00 00       	call   801dd4 <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 47 1a 00 00       	call   801dd4 <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 35 1a 00 00       	call   801dd4 <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 23 1a 00 00       	call   801dd4 <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 11 1a 00 00       	call   801dd4 <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 ff 19 00 00       	call   801dd4 <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 ed 19 00 00       	call   801dd4 <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 53 1c 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 e8 28 80 00       	push   $0x8028e8
  80041b:	6a 70                	push   $0x70
  80041d:	68 9c 27 80 00       	push   $0x80279c
  800422:	e8 14 09 00 00       	call   800d3b <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 76 1b 00 00       	call   801fa2 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 24 29 80 00       	push   $0x802924
  80043d:	6a 71                	push   $0x71
  80043f:	68 9c 27 80 00       	push   $0x80279c
  800444:	e8 f2 08 00 00       	call   800d3b <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 54 1b 00 00       	call   801fa2 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 ec 1b 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 2b 19 00 00       	call   801d93 <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 64 29 80 00       	push   $0x802964
  800480:	6a 79                	push   $0x79
  800482:	68 9c 27 80 00       	push   $0x80279c
  800487:	e8 af 08 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 b1 1b 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 ba 28 80 00       	push   $0x8028ba
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 9c 27 80 00       	push   $0x80279c
  8004b8:	e8 7e 08 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 e0 1a 00 00       	call   801fa2 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 d7 28 80 00       	push   $0x8028d7
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 9c 27 80 00       	push   $0x80279c
  8004da:	e8 5c 08 00 00       	call   800d3b <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 be 1a 00 00       	call   801fa2 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 56 1b 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 98 18 00 00       	call   801d93 <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 64 29 80 00       	push   $0x802964
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 9c 27 80 00       	push   $0x80279c
  80051d:	e8 19 08 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 1b 1b 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 ba 28 80 00       	push   $0x8028ba
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 9c 27 80 00       	push   $0x80279c
  800554:	e8 e2 07 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 44 1a 00 00       	call   801fa2 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 d7 28 80 00       	push   $0x8028d7
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 9c 27 80 00       	push   $0x80279c
  800579:	e8 bd 07 00 00       	call   800d3b <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 1f 1a 00 00       	call   801fa2 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 b7 1a 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 f2 17 00 00       	call   801d93 <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 64 29 80 00       	push   $0x802964
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 9c 27 80 00       	push   $0x80279c
  8005c3:	e8 73 07 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 75 1a 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 ba 28 80 00       	push   $0x8028ba
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 9c 27 80 00       	push   $0x80279c
  8005fe:	e8 38 07 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 9a 19 00 00       	call   801fa2 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 d7 28 80 00       	push   $0x8028d7
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 9c 27 80 00       	push   $0x80279c
  800623:	e8 13 07 00 00       	call   800d3b <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 75 19 00 00       	call   801fa2 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 0d 1a 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 4f 17 00 00       	call   801d93 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 64 29 80 00       	push   $0x802964
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 9c 27 80 00       	push   $0x80279c
  800666:	e8 d0 06 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 d2 19 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 ba 28 80 00       	push   $0x8028ba
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 9c 27 80 00       	push   $0x80279c
  80069a:	e8 9c 06 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 fe 18 00 00       	call   801fa2 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 d7 28 80 00       	push   $0x8028d7
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 9c 27 80 00       	push   $0x80279c
  8006bf:	e8 77 06 00 00       	call   800d3b <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 d9 18 00 00       	call   801fa2 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 71 19 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 f1 16 00 00       	call   801dd4 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 57 19 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 e8 28 80 00       	push   $0x8028e8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 9c 27 80 00       	push   $0x80279c
  800717:	e8 1f 06 00 00       	call   800d3b <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 81 18 00 00       	call   801fa2 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 24 29 80 00       	push   $0x802924
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 9c 27 80 00       	push   $0x80279c
  80073c:	e8 fa 05 00 00       	call   800d3b <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 5c 18 00 00       	call   801fa2 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 f4 18 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 36 16 00 00       	call   801d93 <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 64 29 80 00       	push   $0x802964
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 9c 27 80 00       	push   $0x80279c
  80077f:	e8 b7 05 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 b9 18 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 ba 28 80 00       	push   $0x8028ba
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 9c 27 80 00       	push   $0x80279c
  8007b6:	e8 80 05 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 e2 17 00 00       	call   801fa2 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 d7 28 80 00       	push   $0x8028d7
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 9c 27 80 00       	push   $0x80279c
  8007db:	e8 5b 05 00 00       	call   800d3b <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 bd 17 00 00       	call   801fa2 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 55 18 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 88 15 00 00       	call   801d93 <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 64 29 80 00       	push   $0x802964
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 9c 27 80 00       	push   $0x80279c
  80082d:	e8 09 05 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 0b 18 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 ba 28 80 00       	push   $0x8028ba
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 9c 27 80 00       	push   $0x80279c
  800870:	e8 c6 04 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 28 17 00 00       	call   801fa2 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 d7 28 80 00       	push   $0x8028d7
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 9c 27 80 00       	push   $0x80279c
  800895:	e8 a1 04 00 00       	call   800d3b <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 03 17 00 00       	call   801fa2 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 9b 17 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 da 14 00 00       	call   801d93 <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 64 29 80 00       	push   $0x802964
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 9c 27 80 00       	push   $0x80279c
  8008db:	e8 5b 04 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 5d 17 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 ba 28 80 00       	push   $0x8028ba
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 9c 27 80 00       	push   $0x80279c
  800912:	e8 24 04 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 86 16 00 00       	call   801fa2 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 d7 28 80 00       	push   $0x8028d7
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 9c 27 80 00       	push   $0x80279c
  800937:	e8 ff 03 00 00       	call   800d3b <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 84 29 80 00       	push   $0x802984
  800944:	e8 a6 06 00 00       	call   800fef <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 51 16 00 00       	call   801fa2 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 e9 16 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 1d 14 00 00       	call   801d93 <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 64 29 80 00       	push   $0x802964
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 9c 27 80 00       	push   $0x80279c
  800998:	e8 9e 03 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 a0 16 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 ba 28 80 00       	push   $0x8028ba
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 9c 27 80 00       	push   $0x80279c
  8009da:	e8 5c 03 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 be 15 00 00       	call   801fa2 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 d7 28 80 00       	push   $0x8028d7
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 9c 27 80 00       	push   $0x80279c
  8009ff:	e8 37 03 00 00       	call   800d3b <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 99 15 00 00       	call   801fa2 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 31 16 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 b1 13 00 00       	call   801dd4 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 17 16 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 e8 28 80 00       	push   $0x8028e8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 9c 27 80 00       	push   $0x80279c
  800a57:	e8 df 02 00 00       	call   800d3b <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 41 15 00 00       	call   801fa2 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 24 29 80 00       	push   $0x802924
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 9c 27 80 00       	push   $0x80279c
  800a7c:	e8 ba 02 00 00       	call   800d3b <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 1c 15 00 00       	call   801fa2 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 b4 15 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 f0 12 00 00       	call   801d93 <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 64 29 80 00       	push   $0x802964
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 9c 27 80 00       	push   $0x80279c
  800ac5:	e8 71 02 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 73 15 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 ba 28 80 00       	push   $0x8028ba
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 9c 27 80 00       	push   $0x80279c
  800afc:	e8 3a 02 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 9c 14 00 00       	call   801fa2 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 d7 28 80 00       	push   $0x8028d7
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 9c 27 80 00       	push   $0x80279c
  800b21:	e8 15 02 00 00       	call   800d3b <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 c0 29 80 00       	push   $0x8029c0
  800b2e:	e8 bc 04 00 00       	call   800fef <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 67 14 00 00       	call   801fa2 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 ff 14 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 39 12 00 00       	call   801d93 <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 64 29 80 00       	push   $0x802964
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 9c 27 80 00       	push   $0x80279c
  800b79:	e8 bd 01 00 00       	call   800d3b <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 bf 14 00 00       	call   802042 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 ba 28 80 00       	push   $0x8028ba
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 9c 27 80 00       	push   $0x80279c
  800b9a:	e8 9c 01 00 00       	call   800d3b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 fe 13 00 00       	call   801fa2 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 d7 28 80 00       	push   $0x8028d7
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 9c 27 80 00       	push   $0x80279c
  800bbf:	e8 77 01 00 00       	call   800d3b <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 f8 29 80 00       	push   $0x8029f8
  800bcc:	e8 1e 04 00 00       	call   800fef <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 34 2a 80 00       	push   $0x802a34
  800bdc:	e8 0e 04 00 00       	call   800fef <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 8b 16 00 00       	call   802282 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	01 c0                	add    %eax,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c0a:	01 c8                	add    %ecx,%eax
  800c0c:	c1 e0 02             	shl    $0x2,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c18:	01 c8                	add    %ecx,%eax
  800c1a:	c1 e0 02             	shl    $0x2,%eax
  800c1d:	01 d0                	add    %edx,%eax
  800c1f:	c1 e0 02             	shl    $0x2,%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	c1 e0 03             	shl    $0x3,%eax
  800c27:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c2c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c31:	a1 20 40 80 00       	mov    0x804020,%eax
  800c36:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800c3c:	84 c0                	test   %al,%al
  800c3e:	74 0f                	je     800c4f <libmain+0x63>
		binaryname = myEnv->prog_name;
  800c40:	a1 20 40 80 00       	mov    0x804020,%eax
  800c45:	05 18 da 01 00       	add    $0x1da18,%eax
  800c4a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c53:	7e 0a                	jle    800c5f <libmain+0x73>
		binaryname = argv[0];
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	ff 75 08             	pushl  0x8(%ebp)
  800c68:	e8 cb f3 ff ff       	call   800038 <_main>
  800c6d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c70:	e8 1a 14 00 00       	call   80208f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c75:	83 ec 0c             	sub    $0xc,%esp
  800c78:	68 88 2a 80 00       	push   $0x802a88
  800c7d:	e8 6d 03 00 00       	call   800fef <cprintf>
  800c82:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c85:	a1 20 40 80 00       	mov    0x804020,%eax
  800c8a:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800c90:	a1 20 40 80 00       	mov    0x804020,%eax
  800c95:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	52                   	push   %edx
  800c9f:	50                   	push   %eax
  800ca0:	68 b0 2a 80 00       	push   $0x802ab0
  800ca5:	e8 45 03 00 00       	call   800fef <cprintf>
  800caa:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800cad:	a1 20 40 80 00       	mov    0x804020,%eax
  800cb2:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800cb8:	a1 20 40 80 00       	mov    0x804020,%eax
  800cbd:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800cc3:	a1 20 40 80 00       	mov    0x804020,%eax
  800cc8:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800cce:	51                   	push   %ecx
  800ccf:	52                   	push   %edx
  800cd0:	50                   	push   %eax
  800cd1:	68 d8 2a 80 00       	push   $0x802ad8
  800cd6:	e8 14 03 00 00       	call   800fef <cprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800cde:	a1 20 40 80 00       	mov    0x804020,%eax
  800ce3:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	50                   	push   %eax
  800ced:	68 30 2b 80 00       	push   $0x802b30
  800cf2:	e8 f8 02 00 00       	call   800fef <cprintf>
  800cf7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800cfa:	83 ec 0c             	sub    $0xc,%esp
  800cfd:	68 88 2a 80 00       	push   $0x802a88
  800d02:	e8 e8 02 00 00       	call   800fef <cprintf>
  800d07:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800d0a:	e8 9a 13 00 00       	call   8020a9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800d0f:	e8 19 00 00 00       	call   800d2d <exit>
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	6a 00                	push   $0x0
  800d22:	e8 27 15 00 00       	call   80224e <sys_destroy_env>
  800d27:	83 c4 10             	add    $0x10,%esp
}
  800d2a:	90                   	nop
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <exit>:

void
exit(void)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d33:	e8 7c 15 00 00       	call   8022b4 <sys_exit_env>
}
  800d38:	90                   	nop
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d41:	8d 45 10             	lea    0x10(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d4a:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	74 16                	je     800d69 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d53:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	50                   	push   %eax
  800d5c:	68 44 2b 80 00       	push   $0x802b44
  800d61:	e8 89 02 00 00       	call   800fef <cprintf>
  800d66:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d69:	a1 00 40 80 00       	mov    0x804000,%eax
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	50                   	push   %eax
  800d75:	68 49 2b 80 00       	push   $0x802b49
  800d7a:	e8 70 02 00 00       	call   800fef <cprintf>
  800d7f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8b:	50                   	push   %eax
  800d8c:	e8 f3 01 00 00       	call   800f84 <vcprintf>
  800d91:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	6a 00                	push   $0x0
  800d99:	68 65 2b 80 00       	push   $0x802b65
  800d9e:	e8 e1 01 00 00       	call   800f84 <vcprintf>
  800da3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800da6:	e8 82 ff ff ff       	call   800d2d <exit>

	// should not return here
	while (1) ;
  800dab:	eb fe                	jmp    800dab <_panic+0x70>

00800dad <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800db3:	a1 20 40 80 00       	mov    0x804020,%eax
  800db8:	8b 50 74             	mov    0x74(%eax),%edx
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	39 c2                	cmp    %eax,%edx
  800dc0:	74 14                	je     800dd6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	68 68 2b 80 00       	push   $0x802b68
  800dca:	6a 26                	push   $0x26
  800dcc:	68 b4 2b 80 00       	push   $0x802bb4
  800dd1:	e8 65 ff ff ff       	call   800d3b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800de4:	e9 c2 00 00 00       	jmp    800eab <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	01 d0                	add    %edx,%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	75 08                	jne    800e06 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800dfe:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800e01:	e9 a2 00 00 00       	jmp    800ea8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800e06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e14:	eb 69                	jmp    800e7f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e16:	a1 20 40 80 00       	mov    0x804020,%eax
  800e1b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800e21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e24:	89 d0                	mov    %edx,%eax
  800e26:	01 c0                	add    %eax,%eax
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	c1 e0 03             	shl    $0x3,%eax
  800e2d:	01 c8                	add    %ecx,%eax
  800e2f:	8a 40 04             	mov    0x4(%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 46                	jne    800e7c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e36:	a1 20 40 80 00       	mov    0x804020,%eax
  800e3b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800e41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	01 c8                	add    %ecx,%eax
  800e6d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e6f:	39 c2                	cmp    %eax,%edx
  800e71:	75 09                	jne    800e7c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e73:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e7a:	eb 12                	jmp    800e8e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e7c:	ff 45 e8             	incl   -0x18(%ebp)
  800e7f:	a1 20 40 80 00       	mov    0x804020,%eax
  800e84:	8b 50 74             	mov    0x74(%eax),%edx
  800e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e8a:	39 c2                	cmp    %eax,%edx
  800e8c:	77 88                	ja     800e16 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e92:	75 14                	jne    800ea8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e94:	83 ec 04             	sub    $0x4,%esp
  800e97:	68 c0 2b 80 00       	push   $0x802bc0
  800e9c:	6a 3a                	push   $0x3a
  800e9e:	68 b4 2b 80 00       	push   $0x802bb4
  800ea3:	e8 93 fe ff ff       	call   800d3b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ea8:	ff 45 f0             	incl   -0x10(%ebp)
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800eb1:	0f 8c 32 ff ff ff    	jl     800de9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800eb7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ebe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ec5:	eb 26                	jmp    800eed <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ec7:	a1 20 40 80 00       	mov    0x804020,%eax
  800ecc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ed2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ed5:	89 d0                	mov    %edx,%eax
  800ed7:	01 c0                	add    %eax,%eax
  800ed9:	01 d0                	add    %edx,%eax
  800edb:	c1 e0 03             	shl    $0x3,%eax
  800ede:	01 c8                	add    %ecx,%eax
  800ee0:	8a 40 04             	mov    0x4(%eax),%al
  800ee3:	3c 01                	cmp    $0x1,%al
  800ee5:	75 03                	jne    800eea <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ee7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eea:	ff 45 e0             	incl   -0x20(%ebp)
  800eed:	a1 20 40 80 00       	mov    0x804020,%eax
  800ef2:	8b 50 74             	mov    0x74(%eax),%edx
  800ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef8:	39 c2                	cmp    %eax,%edx
  800efa:	77 cb                	ja     800ec7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f02:	74 14                	je     800f18 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800f04:	83 ec 04             	sub    $0x4,%esp
  800f07:	68 14 2c 80 00       	push   $0x802c14
  800f0c:	6a 44                	push   $0x44
  800f0e:	68 b4 2b 80 00       	push   $0x802bb4
  800f13:	e8 23 fe ff ff       	call   800d3b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f18:	90                   	nop
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	8d 48 01             	lea    0x1(%eax),%ecx
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	89 0a                	mov    %ecx,(%edx)
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	88 d1                	mov    %dl,%cl
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f36:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f44:	75 2c                	jne    800f72 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f46:	a0 24 40 80 00       	mov    0x804024,%al
  800f4b:	0f b6 c0             	movzbl %al,%eax
  800f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f51:	8b 12                	mov    (%edx),%edx
  800f53:	89 d1                	mov    %edx,%ecx
  800f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f58:	83 c2 08             	add    $0x8,%edx
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	50                   	push   %eax
  800f5f:	51                   	push   %ecx
  800f60:	52                   	push   %edx
  800f61:	e8 7b 0f 00 00       	call   801ee1 <sys_cputs>
  800f66:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8b 40 04             	mov    0x4(%eax),%eax
  800f78:	8d 50 01             	lea    0x1(%eax),%edx
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f81:	90                   	nop
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f8d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f94:	00 00 00 
	b.cnt = 0;
  800f97:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f9e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fad:	50                   	push   %eax
  800fae:	68 1b 0f 80 00       	push   $0x800f1b
  800fb3:	e8 11 02 00 00       	call   8011c9 <vprintfmt>
  800fb8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fbb:	a0 24 40 80 00       	mov    0x804024,%al
  800fc0:	0f b6 c0             	movzbl %al,%eax
  800fc3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	50                   	push   %eax
  800fcd:	52                   	push   %edx
  800fce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fd4:	83 c0 08             	add    $0x8,%eax
  800fd7:	50                   	push   %eax
  800fd8:	e8 04 0f 00 00       	call   801ee1 <sys_cputs>
  800fdd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fe0:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800fe7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <cprintf>:

int cprintf(const char *fmt, ...) {
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ff5:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800ffc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	83 ec 08             	sub    $0x8,%esp
  801008:	ff 75 f4             	pushl  -0xc(%ebp)
  80100b:	50                   	push   %eax
  80100c:	e8 73 ff ff ff       	call   800f84 <vcprintf>
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801022:	e8 68 10 00 00       	call   80208f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801027:	8d 45 0c             	lea    0xc(%ebp),%eax
  80102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 f4             	pushl  -0xc(%ebp)
  801036:	50                   	push   %eax
  801037:	e8 48 ff ff ff       	call   800f84 <vcprintf>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801042:	e8 62 10 00 00       	call   8020a9 <sys_enable_interrupt>
	return cnt;
  801047:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	53                   	push   %ebx
  801050:	83 ec 14             	sub    $0x14,%esp
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80105f:	8b 45 18             	mov    0x18(%ebp),%eax
  801062:	ba 00 00 00 00       	mov    $0x0,%edx
  801067:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80106a:	77 55                	ja     8010c1 <printnum+0x75>
  80106c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80106f:	72 05                	jb     801076 <printnum+0x2a>
  801071:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801074:	77 4b                	ja     8010c1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801076:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801079:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80107c:	8b 45 18             	mov    0x18(%ebp),%eax
  80107f:	ba 00 00 00 00       	mov    $0x0,%edx
  801084:	52                   	push   %edx
  801085:	50                   	push   %eax
  801086:	ff 75 f4             	pushl  -0xc(%ebp)
  801089:	ff 75 f0             	pushl  -0x10(%ebp)
  80108c:	e8 83 14 00 00       	call   802514 <__udivdi3>
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	ff 75 20             	pushl  0x20(%ebp)
  80109a:	53                   	push   %ebx
  80109b:	ff 75 18             	pushl  0x18(%ebp)
  80109e:	52                   	push   %edx
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 a1 ff ff ff       	call   80104c <printnum>
  8010ab:	83 c4 20             	add    $0x20,%esp
  8010ae:	eb 1a                	jmp    8010ca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	ff 75 20             	pushl  0x20(%ebp)
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	ff d0                	call   *%eax
  8010be:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010c1:	ff 4d 1c             	decl   0x1c(%ebp)
  8010c4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010c8:	7f e6                	jg     8010b0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010ca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d8:	53                   	push   %ebx
  8010d9:	51                   	push   %ecx
  8010da:	52                   	push   %edx
  8010db:	50                   	push   %eax
  8010dc:	e8 43 15 00 00       	call   802624 <__umoddi3>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	05 74 2e 80 00       	add    $0x802e74,%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f be c0             	movsbl %al,%eax
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	ff 75 0c             	pushl  0xc(%ebp)
  8010f4:	50                   	push   %eax
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
}
  8010fd:	90                   	nop
  8010fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801106:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80110a:	7e 1c                	jle    801128 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8b 00                	mov    (%eax),%eax
  801111:	8d 50 08             	lea    0x8(%eax),%edx
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	89 10                	mov    %edx,(%eax)
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	83 e8 08             	sub    $0x8,%eax
  801121:	8b 50 04             	mov    0x4(%eax),%edx
  801124:	8b 00                	mov    (%eax),%eax
  801126:	eb 40                	jmp    801168 <getuint+0x65>
	else if (lflag)
  801128:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112c:	74 1e                	je     80114c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8b 00                	mov    (%eax),%eax
  801133:	8d 50 04             	lea    0x4(%eax),%edx
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	89 10                	mov    %edx,(%eax)
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8b 00                	mov    (%eax),%eax
  801140:	83 e8 04             	sub    $0x4,%eax
  801143:	8b 00                	mov    (%eax),%eax
  801145:	ba 00 00 00 00       	mov    $0x0,%edx
  80114a:	eb 1c                	jmp    801168 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8b 00                	mov    (%eax),%eax
  801151:	8d 50 04             	lea    0x4(%eax),%edx
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 10                	mov    %edx,(%eax)
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8b 00                	mov    (%eax),%eax
  80115e:	83 e8 04             	sub    $0x4,%eax
  801161:	8b 00                	mov    (%eax),%eax
  801163:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80116d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801171:	7e 1c                	jle    80118f <getint+0x25>
		return va_arg(*ap, long long);
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8b 00                	mov    (%eax),%eax
  801178:	8d 50 08             	lea    0x8(%eax),%edx
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	89 10                	mov    %edx,(%eax)
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8b 00                	mov    (%eax),%eax
  801185:	83 e8 08             	sub    $0x8,%eax
  801188:	8b 50 04             	mov    0x4(%eax),%edx
  80118b:	8b 00                	mov    (%eax),%eax
  80118d:	eb 38                	jmp    8011c7 <getint+0x5d>
	else if (lflag)
  80118f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801193:	74 1a                	je     8011af <getint+0x45>
		return va_arg(*ap, long);
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8b 00                	mov    (%eax),%eax
  80119a:	8d 50 04             	lea    0x4(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	89 10                	mov    %edx,(%eax)
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8b 00                	mov    (%eax),%eax
  8011a7:	83 e8 04             	sub    $0x4,%eax
  8011aa:	8b 00                	mov    (%eax),%eax
  8011ac:	99                   	cltd   
  8011ad:	eb 18                	jmp    8011c7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8b 00                	mov    (%eax),%eax
  8011b4:	8d 50 04             	lea    0x4(%eax),%edx
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	89 10                	mov    %edx,(%eax)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	83 e8 04             	sub    $0x4,%eax
  8011c4:	8b 00                	mov    (%eax),%eax
  8011c6:	99                   	cltd   
}
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d1:	eb 17                	jmp    8011ea <vprintfmt+0x21>
			if (ch == '\0')
  8011d3:	85 db                	test   %ebx,%ebx
  8011d5:	0f 84 af 03 00 00    	je     80158a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	53                   	push   %ebx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	ff d0                	call   *%eax
  8011e7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f b6 d8             	movzbl %al,%ebx
  8011f8:	83 fb 25             	cmp    $0x25,%ebx
  8011fb:	75 d6                	jne    8011d3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011fd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801201:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801208:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80120f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801216:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80121d:	8b 45 10             	mov    0x10(%ebp),%eax
  801220:	8d 50 01             	lea    0x1(%eax),%edx
  801223:	89 55 10             	mov    %edx,0x10(%ebp)
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f b6 d8             	movzbl %al,%ebx
  80122b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80122e:	83 f8 55             	cmp    $0x55,%eax
  801231:	0f 87 2b 03 00 00    	ja     801562 <vprintfmt+0x399>
  801237:	8b 04 85 98 2e 80 00 	mov    0x802e98(,%eax,4),%eax
  80123e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801240:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801244:	eb d7                	jmp    80121d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801246:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80124a:	eb d1                	jmp    80121d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80124c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801253:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801256:	89 d0                	mov    %edx,%eax
  801258:	c1 e0 02             	shl    $0x2,%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	01 c0                	add    %eax,%eax
  80125f:	01 d8                	add    %ebx,%eax
  801261:	83 e8 30             	sub    $0x30,%eax
  801264:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801267:	8b 45 10             	mov    0x10(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80126f:	83 fb 2f             	cmp    $0x2f,%ebx
  801272:	7e 3e                	jle    8012b2 <vprintfmt+0xe9>
  801274:	83 fb 39             	cmp    $0x39,%ebx
  801277:	7f 39                	jg     8012b2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801279:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80127c:	eb d5                	jmp    801253 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	83 c0 04             	add    $0x4,%eax
  801284:	89 45 14             	mov    %eax,0x14(%ebp)
  801287:	8b 45 14             	mov    0x14(%ebp),%eax
  80128a:	83 e8 04             	sub    $0x4,%eax
  80128d:	8b 00                	mov    (%eax),%eax
  80128f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801292:	eb 1f                	jmp    8012b3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801294:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801298:	79 83                	jns    80121d <vprintfmt+0x54>
				width = 0;
  80129a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8012a1:	e9 77 ff ff ff       	jmp    80121d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012a6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012ad:	e9 6b ff ff ff       	jmp    80121d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012b2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b7:	0f 89 60 ff ff ff    	jns    80121d <vprintfmt+0x54>
				width = precision, precision = -1;
  8012bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012ca:	e9 4e ff ff ff       	jmp    80121d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012cf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012d2:	e9 46 ff ff ff       	jmp    80121d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	83 c0 04             	add    $0x4,%eax
  8012dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	83 e8 04             	sub    $0x4,%eax
  8012e6:	8b 00                	mov    (%eax),%eax
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	50                   	push   %eax
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	ff d0                	call   *%eax
  8012f4:	83 c4 10             	add    $0x10,%esp
			break;
  8012f7:	e9 89 02 00 00       	jmp    801585 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	83 c0 04             	add    $0x4,%eax
  801302:	89 45 14             	mov    %eax,0x14(%ebp)
  801305:	8b 45 14             	mov    0x14(%ebp),%eax
  801308:	83 e8 04             	sub    $0x4,%eax
  80130b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80130d:	85 db                	test   %ebx,%ebx
  80130f:	79 02                	jns    801313 <vprintfmt+0x14a>
				err = -err;
  801311:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801313:	83 fb 64             	cmp    $0x64,%ebx
  801316:	7f 0b                	jg     801323 <vprintfmt+0x15a>
  801318:	8b 34 9d e0 2c 80 00 	mov    0x802ce0(,%ebx,4),%esi
  80131f:	85 f6                	test   %esi,%esi
  801321:	75 19                	jne    80133c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801323:	53                   	push   %ebx
  801324:	68 85 2e 80 00       	push   $0x802e85
  801329:	ff 75 0c             	pushl  0xc(%ebp)
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 5e 02 00 00       	call   801592 <printfmt>
  801334:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801337:	e9 49 02 00 00       	jmp    801585 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80133c:	56                   	push   %esi
  80133d:	68 8e 2e 80 00       	push   $0x802e8e
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	ff 75 08             	pushl  0x8(%ebp)
  801348:	e8 45 02 00 00       	call   801592 <printfmt>
  80134d:	83 c4 10             	add    $0x10,%esp
			break;
  801350:	e9 30 02 00 00       	jmp    801585 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	83 c0 04             	add    $0x4,%eax
  80135b:	89 45 14             	mov    %eax,0x14(%ebp)
  80135e:	8b 45 14             	mov    0x14(%ebp),%eax
  801361:	83 e8 04             	sub    $0x4,%eax
  801364:	8b 30                	mov    (%eax),%esi
  801366:	85 f6                	test   %esi,%esi
  801368:	75 05                	jne    80136f <vprintfmt+0x1a6>
				p = "(null)";
  80136a:	be 91 2e 80 00       	mov    $0x802e91,%esi
			if (width > 0 && padc != '-')
  80136f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801373:	7e 6d                	jle    8013e2 <vprintfmt+0x219>
  801375:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801379:	74 67                	je     8013e2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80137b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	50                   	push   %eax
  801382:	56                   	push   %esi
  801383:	e8 0c 03 00 00       	call   801694 <strnlen>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80138e:	eb 16                	jmp    8013a6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801390:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	50                   	push   %eax
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	ff d0                	call   *%eax
  8013a0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a3:	ff 4d e4             	decl   -0x1c(%ebp)
  8013a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013aa:	7f e4                	jg     801390 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013ac:	eb 34                	jmp    8013e2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013b2:	74 1c                	je     8013d0 <vprintfmt+0x207>
  8013b4:	83 fb 1f             	cmp    $0x1f,%ebx
  8013b7:	7e 05                	jle    8013be <vprintfmt+0x1f5>
  8013b9:	83 fb 7e             	cmp    $0x7e,%ebx
  8013bc:	7e 12                	jle    8013d0 <vprintfmt+0x207>
					putch('?', putdat);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	6a 3f                	push   $0x3f
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	ff d0                	call   *%eax
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	eb 0f                	jmp    8013df <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	53                   	push   %ebx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	ff d0                	call   *%eax
  8013dc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013df:	ff 4d e4             	decl   -0x1c(%ebp)
  8013e2:	89 f0                	mov    %esi,%eax
  8013e4:	8d 70 01             	lea    0x1(%eax),%esi
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	0f be d8             	movsbl %al,%ebx
  8013ec:	85 db                	test   %ebx,%ebx
  8013ee:	74 24                	je     801414 <vprintfmt+0x24b>
  8013f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f4:	78 b8                	js     8013ae <vprintfmt+0x1e5>
  8013f6:	ff 4d e0             	decl   -0x20(%ebp)
  8013f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013fd:	79 af                	jns    8013ae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ff:	eb 13                	jmp    801414 <vprintfmt+0x24b>
				putch(' ', putdat);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	6a 20                	push   $0x20
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	ff d0                	call   *%eax
  80140e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801411:	ff 4d e4             	decl   -0x1c(%ebp)
  801414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801418:	7f e7                	jg     801401 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80141a:	e9 66 01 00 00       	jmp    801585 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	ff 75 e8             	pushl  -0x18(%ebp)
  801425:	8d 45 14             	lea    0x14(%ebp),%eax
  801428:	50                   	push   %eax
  801429:	e8 3c fd ff ff       	call   80116a <getint>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801434:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	85 d2                	test   %edx,%edx
  80143f:	79 23                	jns    801464 <vprintfmt+0x29b>
				putch('-', putdat);
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	ff 75 0c             	pushl  0xc(%ebp)
  801447:	6a 2d                	push   $0x2d
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	ff d0                	call   *%eax
  80144e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801457:	f7 d8                	neg    %eax
  801459:	83 d2 00             	adc    $0x0,%edx
  80145c:	f7 da                	neg    %edx
  80145e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801461:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801464:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80146b:	e9 bc 00 00 00       	jmp    80152c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	ff 75 e8             	pushl  -0x18(%ebp)
  801476:	8d 45 14             	lea    0x14(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	e8 84 fc ff ff       	call   801103 <getuint>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801485:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801488:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80148f:	e9 98 00 00 00       	jmp    80152c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	6a 58                	push   $0x58
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	ff d0                	call   *%eax
  8014a1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	6a 58                	push   $0x58
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	ff d0                	call   *%eax
  8014b1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	6a 58                	push   $0x58
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	ff d0                	call   *%eax
  8014c1:	83 c4 10             	add    $0x10,%esp
			break;
  8014c4:	e9 bc 00 00 00       	jmp    801585 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	6a 30                	push   $0x30
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	ff d0                	call   *%eax
  8014d6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	6a 78                	push   $0x78
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	ff d0                	call   *%eax
  8014e6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ec:	83 c0 04             	add    $0x4,%eax
  8014ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	83 e8 04             	sub    $0x4,%eax
  8014f8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801504:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80150b:	eb 1f                	jmp    80152c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	ff 75 e8             	pushl  -0x18(%ebp)
  801513:	8d 45 14             	lea    0x14(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	e8 e7 fb ff ff       	call   801103 <getuint>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801522:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801525:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80152c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	52                   	push   %edx
  801537:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153a:	50                   	push   %eax
  80153b:	ff 75 f4             	pushl  -0xc(%ebp)
  80153e:	ff 75 f0             	pushl  -0x10(%ebp)
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	e8 00 fb ff ff       	call   80104c <printnum>
  80154c:	83 c4 20             	add    $0x20,%esp
			break;
  80154f:	eb 34                	jmp    801585 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801551:	83 ec 08             	sub    $0x8,%esp
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	53                   	push   %ebx
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	ff d0                	call   *%eax
  80155d:	83 c4 10             	add    $0x10,%esp
			break;
  801560:	eb 23                	jmp    801585 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	6a 25                	push   $0x25
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	ff d0                	call   *%eax
  80156f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801572:	ff 4d 10             	decl   0x10(%ebp)
  801575:	eb 03                	jmp    80157a <vprintfmt+0x3b1>
  801577:	ff 4d 10             	decl   0x10(%ebp)
  80157a:	8b 45 10             	mov    0x10(%ebp),%eax
  80157d:	48                   	dec    %eax
  80157e:	8a 00                	mov    (%eax),%al
  801580:	3c 25                	cmp    $0x25,%al
  801582:	75 f3                	jne    801577 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801584:	90                   	nop
		}
	}
  801585:	e9 47 fc ff ff       	jmp    8011d1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80158a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801598:	8d 45 10             	lea    0x10(%ebp),%eax
  80159b:	83 c0 04             	add    $0x4,%eax
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8015a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 16 fc ff ff       	call   8011c9 <vprintfmt>
  8015b3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	8b 40 08             	mov    0x8(%eax),%eax
  8015c2:	8d 50 01             	lea    0x1(%eax),%edx
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	8b 10                	mov    (%eax),%edx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	8b 40 04             	mov    0x4(%eax),%eax
  8015d6:	39 c2                	cmp    %eax,%edx
  8015d8:	73 12                	jae    8015ec <sprintputch+0x33>
		*b->buf++ = ch;
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	8b 00                	mov    (%eax),%eax
  8015df:	8d 48 01             	lea    0x1(%eax),%ecx
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	89 0a                	mov    %ecx,(%edx)
  8015e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ea:	88 10                	mov    %dl,(%eax)
}
  8015ec:	90                   	nop
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	01 d0                	add    %edx,%eax
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801614:	74 06                	je     80161c <vsnprintf+0x2d>
  801616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161a:	7f 07                	jg     801623 <vsnprintf+0x34>
		return -E_INVAL;
  80161c:	b8 03 00 00 00       	mov    $0x3,%eax
  801621:	eb 20                	jmp    801643 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801623:	ff 75 14             	pushl  0x14(%ebp)
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80162c:	50                   	push   %eax
  80162d:	68 b9 15 80 00       	push   $0x8015b9
  801632:	e8 92 fb ff ff       	call   8011c9 <vprintfmt>
  801637:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80163a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80164b:	8d 45 10             	lea    0x10(%ebp),%eax
  80164e:	83 c0 04             	add    $0x4,%eax
  801651:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	ff 75 f4             	pushl  -0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	e8 89 ff ff ff       	call   8015ef <vsnprintf>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801677:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80167e:	eb 06                	jmp    801686 <strlen+0x15>
		n++;
  801680:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801683:	ff 45 08             	incl   0x8(%ebp)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	84 c0                	test   %al,%al
  80168d:	75 f1                	jne    801680 <strlen+0xf>
		n++;
	return n;
  80168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80169a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016a1:	eb 09                	jmp    8016ac <strnlen+0x18>
		n++;
  8016a3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a6:	ff 45 08             	incl   0x8(%ebp)
  8016a9:	ff 4d 0c             	decl   0xc(%ebp)
  8016ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b0:	74 09                	je     8016bb <strnlen+0x27>
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	84 c0                	test   %al,%al
  8016b9:	75 e8                	jne    8016a3 <strnlen+0xf>
		n++;
	return n;
  8016bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016cc:	90                   	nop
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8d 50 01             	lea    0x1(%eax),%edx
  8016d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016dc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016df:	8a 12                	mov    (%edx),%dl
  8016e1:	88 10                	mov    %dl,(%eax)
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	84 c0                	test   %al,%al
  8016e7:	75 e4                	jne    8016cd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801701:	eb 1f                	jmp    801722 <strncpy+0x34>
		*dst++ = *src;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	8d 50 01             	lea    0x1(%eax),%edx
  801709:	89 55 08             	mov    %edx,0x8(%ebp)
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8a 12                	mov    (%edx),%dl
  801711:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801713:	8b 45 0c             	mov    0xc(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	84 c0                	test   %al,%al
  80171a:	74 03                	je     80171f <strncpy+0x31>
			src++;
  80171c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80171f:	ff 45 fc             	incl   -0x4(%ebp)
  801722:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801725:	3b 45 10             	cmp    0x10(%ebp),%eax
  801728:	72 d9                	jb     801703 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80172a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80173b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173f:	74 30                	je     801771 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801741:	eb 16                	jmp    801759 <strlcpy+0x2a>
			*dst++ = *src++;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 08             	mov    %edx,0x8(%ebp)
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801752:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801755:	8a 12                	mov    (%edx),%dl
  801757:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801759:	ff 4d 10             	decl   0x10(%ebp)
  80175c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801760:	74 09                	je     80176b <strlcpy+0x3c>
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	75 d8                	jne    801743 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801771:	8b 55 08             	mov    0x8(%ebp),%edx
  801774:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801777:	29 c2                	sub    %eax,%edx
  801779:	89 d0                	mov    %edx,%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801780:	eb 06                	jmp    801788 <strcmp+0xb>
		p++, q++;
  801782:	ff 45 08             	incl   0x8(%ebp)
  801785:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	84 c0                	test   %al,%al
  80178f:	74 0e                	je     80179f <strcmp+0x22>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 10                	mov    (%eax),%dl
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	38 c2                	cmp    %al,%dl
  80179d:	74 e3                	je     801782 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f b6 d0             	movzbl %al,%edx
  8017a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	0f b6 c0             	movzbl %al,%eax
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d0                	mov    %edx,%eax
}
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017b8:	eb 09                	jmp    8017c3 <strncmp+0xe>
		n--, p++, q++;
  8017ba:	ff 4d 10             	decl   0x10(%ebp)
  8017bd:	ff 45 08             	incl   0x8(%ebp)
  8017c0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	74 17                	je     8017e0 <strncmp+0x2b>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	84 c0                	test   %al,%al
  8017d0:	74 0e                	je     8017e0 <strncmp+0x2b>
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 10                	mov    (%eax),%dl
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	38 c2                	cmp    %al,%dl
  8017de:	74 da                	je     8017ba <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e4:	75 07                	jne    8017ed <strncmp+0x38>
		return 0;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	eb 14                	jmp    801801 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	0f b6 d0             	movzbl %al,%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	0f b6 c0             	movzbl %al,%eax
  8017fd:	29 c2                	sub    %eax,%edx
  8017ff:	89 d0                	mov    %edx,%eax
}
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80180f:	eb 12                	jmp    801823 <strchr+0x20>
		if (*s == c)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	8a 00                	mov    (%eax),%al
  801816:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801819:	75 05                	jne    801820 <strchr+0x1d>
			return (char *) s;
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	eb 11                	jmp    801831 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801820:	ff 45 08             	incl   0x8(%ebp)
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	84 c0                	test   %al,%al
  80182a:	75 e5                	jne    801811 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80183f:	eb 0d                	jmp    80184e <strfind+0x1b>
		if (*s == c)
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801849:	74 0e                	je     801859 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80184b:	ff 45 08             	incl   0x8(%ebp)
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	84 c0                	test   %al,%al
  801855:	75 ea                	jne    801841 <strfind+0xe>
  801857:	eb 01                	jmp    80185a <strfind+0x27>
		if (*s == c)
			break;
  801859:	90                   	nop
	return (char *) s;
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801871:	eb 0e                	jmp    801881 <memset+0x22>
		*p++ = c;
  801873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801876:	8d 50 01             	lea    0x1(%eax),%edx
  801879:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801881:	ff 4d f8             	decl   -0x8(%ebp)
  801884:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801888:	79 e9                	jns    801873 <memset+0x14>
		*p++ = c;

	return v;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801895:	8b 45 0c             	mov    0xc(%ebp),%eax
  801898:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8018a1:	eb 16                	jmp    8018b9 <memcpy+0x2a>
		*d++ = *s++;
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	8d 50 01             	lea    0x1(%eax),%edx
  8018a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018b5:	8a 12                	mov    (%edx),%dl
  8018b7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	75 dd                	jne    8018a3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018e3:	73 50                	jae    801935 <memmove+0x6a>
  8018e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018f0:	76 43                	jbe    801935 <memmove+0x6a>
		s += n;
  8018f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018fe:	eb 10                	jmp    801910 <memmove+0x45>
			*--d = *--s;
  801900:	ff 4d f8             	decl   -0x8(%ebp)
  801903:	ff 4d fc             	decl   -0x4(%ebp)
  801906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801909:	8a 10                	mov    (%eax),%dl
  80190b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	8d 50 ff             	lea    -0x1(%eax),%edx
  801916:	89 55 10             	mov    %edx,0x10(%ebp)
  801919:	85 c0                	test   %eax,%eax
  80191b:	75 e3                	jne    801900 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80191d:	eb 23                	jmp    801942 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80191f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801922:	8d 50 01             	lea    0x1(%eax),%edx
  801925:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801928:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80192e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801931:	8a 12                	mov    (%edx),%dl
  801933:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801935:	8b 45 10             	mov    0x10(%ebp),%eax
  801938:	8d 50 ff             	lea    -0x1(%eax),%edx
  80193b:	89 55 10             	mov    %edx,0x10(%ebp)
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 dd                	jne    80191f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801953:	8b 45 0c             	mov    0xc(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801959:	eb 2a                	jmp    801985 <memcmp+0x3e>
		if (*s1 != *s2)
  80195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195e:	8a 10                	mov    (%eax),%dl
  801960:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	38 c2                	cmp    %al,%dl
  801967:	74 16                	je     80197f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	0f b6 d0             	movzbl %al,%edx
  801971:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	0f b6 c0             	movzbl %al,%eax
  801979:	29 c2                	sub    %eax,%edx
  80197b:	89 d0                	mov    %edx,%eax
  80197d:	eb 18                	jmp    801997 <memcmp+0x50>
		s1++, s2++;
  80197f:	ff 45 fc             	incl   -0x4(%ebp)
  801982:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801985:	8b 45 10             	mov    0x10(%ebp),%eax
  801988:	8d 50 ff             	lea    -0x1(%eax),%edx
  80198b:	89 55 10             	mov    %edx,0x10(%ebp)
  80198e:	85 c0                	test   %eax,%eax
  801990:	75 c9                	jne    80195b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80199f:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8019aa:	eb 15                	jmp    8019c1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	0f b6 d0             	movzbl %al,%edx
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	0f b6 c0             	movzbl %al,%eax
  8019ba:	39 c2                	cmp    %eax,%edx
  8019bc:	74 0d                	je     8019cb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019be:	ff 45 08             	incl   0x8(%ebp)
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019c7:	72 e3                	jb     8019ac <memfind+0x13>
  8019c9:	eb 01                	jmp    8019cc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019cb:	90                   	nop
	return (void *) s;
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019e5:	eb 03                	jmp    8019ea <strtol+0x19>
		s++;
  8019e7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	3c 20                	cmp    $0x20,%al
  8019f1:	74 f4                	je     8019e7 <strtol+0x16>
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	3c 09                	cmp    $0x9,%al
  8019fa:	74 eb                	je     8019e7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	3c 2b                	cmp    $0x2b,%al
  801a03:	75 05                	jne    801a0a <strtol+0x39>
		s++;
  801a05:	ff 45 08             	incl   0x8(%ebp)
  801a08:	eb 13                	jmp    801a1d <strtol+0x4c>
	else if (*s == '-')
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 2d                	cmp    $0x2d,%al
  801a11:	75 0a                	jne    801a1d <strtol+0x4c>
		s++, neg = 1;
  801a13:	ff 45 08             	incl   0x8(%ebp)
  801a16:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a21:	74 06                	je     801a29 <strtol+0x58>
  801a23:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a27:	75 20                	jne    801a49 <strtol+0x78>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	3c 30                	cmp    $0x30,%al
  801a30:	75 17                	jne    801a49 <strtol+0x78>
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	40                   	inc    %eax
  801a36:	8a 00                	mov    (%eax),%al
  801a38:	3c 78                	cmp    $0x78,%al
  801a3a:	75 0d                	jne    801a49 <strtol+0x78>
		s += 2, base = 16;
  801a3c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a40:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a47:	eb 28                	jmp    801a71 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a4d:	75 15                	jne    801a64 <strtol+0x93>
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8a 00                	mov    (%eax),%al
  801a54:	3c 30                	cmp    $0x30,%al
  801a56:	75 0c                	jne    801a64 <strtol+0x93>
		s++, base = 8;
  801a58:	ff 45 08             	incl   0x8(%ebp)
  801a5b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a62:	eb 0d                	jmp    801a71 <strtol+0xa0>
	else if (base == 0)
  801a64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a68:	75 07                	jne    801a71 <strtol+0xa0>
		base = 10;
  801a6a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	3c 2f                	cmp    $0x2f,%al
  801a78:	7e 19                	jle    801a93 <strtol+0xc2>
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8a 00                	mov    (%eax),%al
  801a7f:	3c 39                	cmp    $0x39,%al
  801a81:	7f 10                	jg     801a93 <strtol+0xc2>
			dig = *s - '0';
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8a 00                	mov    (%eax),%al
  801a88:	0f be c0             	movsbl %al,%eax
  801a8b:	83 e8 30             	sub    $0x30,%eax
  801a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a91:	eb 42                	jmp    801ad5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8a 00                	mov    (%eax),%al
  801a98:	3c 60                	cmp    $0x60,%al
  801a9a:	7e 19                	jle    801ab5 <strtol+0xe4>
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	3c 7a                	cmp    $0x7a,%al
  801aa3:	7f 10                	jg     801ab5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	83 e8 57             	sub    $0x57,%eax
  801ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab3:	eb 20                	jmp    801ad5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8a 00                	mov    (%eax),%al
  801aba:	3c 40                	cmp    $0x40,%al
  801abc:	7e 39                	jle    801af7 <strtol+0x126>
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	3c 5a                	cmp    $0x5a,%al
  801ac5:	7f 30                	jg     801af7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8a 00                	mov    (%eax),%al
  801acc:	0f be c0             	movsbl %al,%eax
  801acf:	83 e8 37             	sub    $0x37,%eax
  801ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad8:	3b 45 10             	cmp    0x10(%ebp),%eax
  801adb:	7d 19                	jge    801af6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801add:	ff 45 08             	incl   0x8(%ebp)
  801ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae7:	89 c2                	mov    %eax,%edx
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	01 d0                	add    %edx,%eax
  801aee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801af1:	e9 7b ff ff ff       	jmp    801a71 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801af6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801af7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801afb:	74 08                	je     801b05 <strtol+0x134>
		*endptr = (char *) s;
  801afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b00:	8b 55 08             	mov    0x8(%ebp),%edx
  801b03:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b09:	74 07                	je     801b12 <strtol+0x141>
  801b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0e:	f7 d8                	neg    %eax
  801b10:	eb 03                	jmp    801b15 <strtol+0x144>
  801b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <ltostr>:

void
ltostr(long value, char *str)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b2f:	79 13                	jns    801b44 <ltostr+0x2d>
	{
		neg = 1;
  801b31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b3e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b41:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b4c:	99                   	cltd   
  801b4d:	f7 f9                	idiv   %ecx
  801b4f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b55:	8d 50 01             	lea    0x1(%eax),%edx
  801b58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b5b:	89 c2                	mov    %eax,%edx
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	01 d0                	add    %edx,%eax
  801b62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b65:	83 c2 30             	add    $0x30,%edx
  801b68:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b72:	f7 e9                	imul   %ecx
  801b74:	c1 fa 02             	sar    $0x2,%edx
  801b77:	89 c8                	mov    %ecx,%eax
  801b79:	c1 f8 1f             	sar    $0x1f,%eax
  801b7c:	29 c2                	sub    %eax,%edx
  801b7e:	89 d0                	mov    %edx,%eax
  801b80:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b86:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b8b:	f7 e9                	imul   %ecx
  801b8d:	c1 fa 02             	sar    $0x2,%edx
  801b90:	89 c8                	mov    %ecx,%eax
  801b92:	c1 f8 1f             	sar    $0x1f,%eax
  801b95:	29 c2                	sub    %eax,%edx
  801b97:	89 d0                	mov    %edx,%eax
  801b99:	c1 e0 02             	shl    $0x2,%eax
  801b9c:	01 d0                	add    %edx,%eax
  801b9e:	01 c0                	add    %eax,%eax
  801ba0:	29 c1                	sub    %eax,%ecx
  801ba2:	89 ca                	mov    %ecx,%edx
  801ba4:	85 d2                	test   %edx,%edx
  801ba6:	75 9c                	jne    801b44 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb2:	48                   	dec    %eax
  801bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bba:	74 3d                	je     801bf9 <ltostr+0xe2>
		start = 1 ;
  801bbc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bc3:	eb 34                	jmp    801bf9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	8a 00                	mov    (%eax),%al
  801bcf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	01 c2                	add    %eax,%edx
  801bda:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	01 c8                	add    %ecx,%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bec:	01 c2                	add    %eax,%edx
  801bee:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bf1:	88 02                	mov    %al,(%edx)
		start++ ;
  801bf3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801bf6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bff:	7c c4                	jl     801bc5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c01:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c07:	01 d0                	add    %edx,%eax
  801c09:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c0c:	90                   	nop
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	e8 54 fa ff ff       	call   801671 <strlen>
  801c1d:	83 c4 04             	add    $0x4,%esp
  801c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	e8 46 fa ff ff       	call   801671 <strlen>
  801c2b:	83 c4 04             	add    $0x4,%esp
  801c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c3f:	eb 17                	jmp    801c58 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c44:	8b 45 10             	mov    0x10(%ebp),%eax
  801c47:	01 c2                	add    %eax,%edx
  801c49:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	01 c8                	add    %ecx,%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c55:	ff 45 fc             	incl   -0x4(%ebp)
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c5b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c5e:	7c e1                	jl     801c41 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c6e:	eb 1f                	jmp    801c8f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c73:	8d 50 01             	lea    0x1(%eax),%edx
  801c76:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c79:	89 c2                	mov    %eax,%edx
  801c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7e:	01 c2                	add    %eax,%edx
  801c80:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c86:	01 c8                	add    %ecx,%eax
  801c88:	8a 00                	mov    (%eax),%al
  801c8a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c8c:	ff 45 f8             	incl   -0x8(%ebp)
  801c8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c95:	7c d9                	jl     801c70 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	c6 00 00             	movb   $0x0,(%eax)
}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb4:	8b 00                	mov    (%eax),%eax
  801cb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc8:	eb 0c                	jmp    801cd6 <strsplit+0x31>
			*string++ = 0;
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	8d 50 01             	lea    0x1(%eax),%edx
  801cd0:	89 55 08             	mov    %edx,0x8(%ebp)
  801cd3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	8a 00                	mov    (%eax),%al
  801cdb:	84 c0                	test   %al,%al
  801cdd:	74 18                	je     801cf7 <strsplit+0x52>
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8a 00                	mov    (%eax),%al
  801ce4:	0f be c0             	movsbl %al,%eax
  801ce7:	50                   	push   %eax
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	e8 13 fb ff ff       	call   801803 <strchr>
  801cf0:	83 c4 08             	add    $0x8,%esp
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	75 d3                	jne    801cca <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 5a                	je     801d5a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	8b 00                	mov    (%eax),%eax
  801d05:	83 f8 0f             	cmp    $0xf,%eax
  801d08:	75 07                	jne    801d11 <strsplit+0x6c>
		{
			return 0;
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0f:	eb 66                	jmp    801d77 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d11:	8b 45 14             	mov    0x14(%ebp),%eax
  801d14:	8b 00                	mov    (%eax),%eax
  801d16:	8d 48 01             	lea    0x1(%eax),%ecx
  801d19:	8b 55 14             	mov    0x14(%ebp),%edx
  801d1c:	89 0a                	mov    %ecx,(%edx)
  801d1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d25:	8b 45 10             	mov    0x10(%ebp),%eax
  801d28:	01 c2                	add    %eax,%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d2f:	eb 03                	jmp    801d34 <strsplit+0x8f>
			string++;
  801d31:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	8a 00                	mov    (%eax),%al
  801d39:	84 c0                	test   %al,%al
  801d3b:	74 8b                	je     801cc8 <strsplit+0x23>
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	0f be c0             	movsbl %al,%eax
  801d45:	50                   	push   %eax
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	e8 b5 fa ff ff       	call   801803 <strchr>
  801d4e:	83 c4 08             	add    $0x8,%esp
  801d51:	85 c0                	test   %eax,%eax
  801d53:	74 dc                	je     801d31 <strsplit+0x8c>
			string++;
	}
  801d55:	e9 6e ff ff ff       	jmp    801cc8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d5a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5e:	8b 00                	mov    (%eax),%eax
  801d60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d67:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6a:	01 d0                	add    %edx,%eax
  801d6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d72:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 f0 2f 80 00       	push   $0x802ff0
  801d87:	6a 0e                	push   $0xe
  801d89:	68 2a 30 80 00       	push   $0x80302a
  801d8e:	e8 a8 ef ff ff       	call   800d3b <_panic>

00801d93 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801d99:	a1 04 40 80 00       	mov    0x804004,%eax
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	74 0f                	je     801db1 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801da2:	e8 d2 ff ff ff       	call   801d79 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801da7:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801dae:	00 00 00 
	}
	if (size == 0) return NULL ;
  801db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801db5:	75 07                	jne    801dbe <malloc+0x2b>
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	eb 14                	jmp    801dd2 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 38 30 80 00       	push   $0x803038
  801dc6:	6a 2e                	push   $0x2e
  801dc8:	68 2a 30 80 00       	push   $0x80302a
  801dcd:	e8 69 ef ff ff       	call   800d3b <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	68 60 30 80 00       	push   $0x803060
  801de2:	6a 49                	push   $0x49
  801de4:	68 2a 30 80 00       	push   $0x80302a
  801de9:	e8 4d ef ff ff       	call   800d3b <_panic>

00801dee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 18             	sub    $0x18,%esp
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 84 30 80 00       	push   $0x803084
  801e02:	6a 57                	push   $0x57
  801e04:	68 2a 30 80 00       	push   $0x80302a
  801e09:	e8 2d ef ff ff       	call   800d3b <_panic>

00801e0e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	68 ac 30 80 00       	push   $0x8030ac
  801e1c:	6a 60                	push   $0x60
  801e1e:	68 2a 30 80 00       	push   $0x80302a
  801e23:	e8 13 ef ff ff       	call   800d3b <_panic>

00801e28 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 d0 30 80 00       	push   $0x8030d0
  801e36:	6a 7c                	push   $0x7c
  801e38:	68 2a 30 80 00       	push   $0x80302a
  801e3d:	e8 f9 ee ff ff       	call   800d3b <_panic>

00801e42 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 f8 30 80 00       	push   $0x8030f8
  801e50:	68 86 00 00 00       	push   $0x86
  801e55:	68 2a 30 80 00       	push   $0x80302a
  801e5a:	e8 dc ee ff ff       	call   800d3b <_panic>

00801e5f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 1c 31 80 00       	push   $0x80311c
  801e6d:	68 91 00 00 00       	push   $0x91
  801e72:	68 2a 30 80 00       	push   $0x80302a
  801e77:	e8 bf ee ff ff       	call   800d3b <_panic>

00801e7c <shrink>:

}
void shrink(uint32 newSize)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 1c 31 80 00       	push   $0x80311c
  801e8a:	68 96 00 00 00       	push   $0x96
  801e8f:	68 2a 30 80 00       	push   $0x80302a
  801e94:	e8 a2 ee ff ff       	call   800d3b <_panic>

00801e99 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9f:	83 ec 04             	sub    $0x4,%esp
  801ea2:	68 1c 31 80 00       	push   $0x80311c
  801ea7:	68 9b 00 00 00       	push   $0x9b
  801eac:	68 2a 30 80 00       	push   $0x80302a
  801eb1:	e8 85 ee ff ff       	call   800d3b <_panic>

00801eb6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	57                   	push   %edi
  801eba:	56                   	push   %esi
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ecb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ece:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ed1:	cd 30                	int    $0x30
  801ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	52                   	push   %edx
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	50                   	push   %eax
  801efd:	6a 00                	push   $0x0
  801eff:	e8 b2 ff ff ff       	call   801eb6 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_cgetc>:

int
sys_cgetc(void)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 01                	push   $0x1
  801f19:	e8 98 ff ff ff       	call   801eb6 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 05                	push   $0x5
  801f36:	e8 7b ff ff ff       	call   801eb6 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f45:	8b 75 18             	mov    0x18(%ebp),%esi
  801f48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	51                   	push   %ecx
  801f57:	52                   	push   %edx
  801f58:	50                   	push   %eax
  801f59:	6a 06                	push   $0x6
  801f5b:	e8 56 ff ff ff       	call   801eb6 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 07                	push   $0x7
  801f7d:	e8 34 ff ff ff       	call   801eb6 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	6a 08                	push   $0x8
  801f98:	e8 19 ff ff ff       	call   801eb6 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 09                	push   $0x9
  801fb1:	e8 00 ff ff ff       	call   801eb6 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 0a                	push   $0xa
  801fca:	e8 e7 fe ff ff       	call   801eb6 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 0b                	push   $0xb
  801fe3:	e8 ce fe ff ff       	call   801eb6 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	ff 75 0c             	pushl  0xc(%ebp)
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	6a 0f                	push   $0xf
  801ffe:	e8 b3 fe ff ff       	call   801eb6 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 10                	push   $0x10
  80201a:	e8 97 fe ff ff       	call   801eb6 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return ;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	ff 75 10             	pushl  0x10(%ebp)
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	6a 11                	push   $0x11
  802037:	e8 7a fe ff ff       	call   801eb6 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
	return ;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 0c                	push   $0xc
  802051:	e8 60 fe ff ff       	call   801eb6 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	ff 75 08             	pushl  0x8(%ebp)
  802069:	6a 0d                	push   $0xd
  80206b:	e8 46 fe ff ff       	call   801eb6 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 0e                	push   $0xe
  802084:	e8 2d fe ff ff       	call   801eb6 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	90                   	nop
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 13                	push   $0x13
  80209e:	e8 13 fe ff ff       	call   801eb6 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	90                   	nop
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 14                	push   $0x14
  8020b8:	e8 f9 fd ff ff       	call   801eb6 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	50                   	push   %eax
  8020dc:	6a 15                	push   $0x15
  8020de:	e8 d3 fd ff ff       	call   801eb6 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	90                   	nop
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 16                	push   $0x16
  8020f8:	e8 b9 fd ff ff       	call   801eb6 <syscall>
  8020fd:	83 c4 18             	add    $0x18,%esp
}
  802100:	90                   	nop
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	ff 75 0c             	pushl  0xc(%ebp)
  802112:	50                   	push   %eax
  802113:	6a 17                	push   $0x17
  802115:	e8 9c fd ff ff       	call   801eb6 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 1a                	push   $0x1a
  802132:	e8 7f fd ff ff       	call   801eb6 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 18                	push   $0x18
  80214f:	e8 62 fd ff ff       	call   801eb6 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	90                   	nop
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 19                	push   $0x19
  80216d:	e8 44 fd ff ff       	call   801eb6 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	90                   	nop
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	8b 45 10             	mov    0x10(%ebp),%eax
  802181:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802184:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802187:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	6a 00                	push   $0x0
  802190:	51                   	push   %ecx
  802191:	52                   	push   %edx
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	50                   	push   %eax
  802196:	6a 1b                	push   $0x1b
  802198:	e8 19 fd ff ff       	call   801eb6 <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	52                   	push   %edx
  8021b2:	50                   	push   %eax
  8021b3:	6a 1c                	push   $0x1c
  8021b5:	e8 fc fc ff ff       	call   801eb6 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	51                   	push   %ecx
  8021d0:	52                   	push   %edx
  8021d1:	50                   	push   %eax
  8021d2:	6a 1d                	push   $0x1d
  8021d4:	e8 dd fc ff ff       	call   801eb6 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	6a 1e                	push   $0x1e
  8021f1:	e8 c0 fc ff ff       	call   801eb6 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 1f                	push   $0x1f
  80220a:	e8 a7 fc ff ff       	call   801eb6 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	6a 00                	push   $0x0
  80221c:	ff 75 14             	pushl  0x14(%ebp)
  80221f:	ff 75 10             	pushl  0x10(%ebp)
  802222:	ff 75 0c             	pushl  0xc(%ebp)
  802225:	50                   	push   %eax
  802226:	6a 20                	push   $0x20
  802228:	e8 89 fc ff ff       	call   801eb6 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	50                   	push   %eax
  802241:	6a 21                	push   $0x21
  802243:	e8 6e fc ff ff       	call   801eb6 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	50                   	push   %eax
  80225d:	6a 22                	push   $0x22
  80225f:	e8 52 fc ff ff       	call   801eb6 <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 02                	push   $0x2
  802278:	e8 39 fc ff ff       	call   801eb6 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 03                	push   $0x3
  802291:	e8 20 fc ff ff       	call   801eb6 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 04                	push   $0x4
  8022aa:	e8 07 fc ff ff       	call   801eb6 <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 23                	push   $0x23
  8022c3:	e8 ee fb ff ff       	call   801eb6 <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
}
  8022cb:	90                   	nop
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d7:	8d 50 04             	lea    0x4(%eax),%edx
  8022da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	52                   	push   %edx
  8022e4:	50                   	push   %eax
  8022e5:	6a 24                	push   $0x24
  8022e7:	e8 ca fb ff ff       	call   801eb6 <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f8:	89 01                	mov    %eax,(%ecx)
  8022fa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	c9                   	leave  
  802301:	c2 04 00             	ret    $0x4

00802304 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	ff 75 10             	pushl  0x10(%ebp)
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	6a 12                	push   $0x12
  802316:	e8 9b fb ff ff       	call   801eb6 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
	return ;
  80231e:	90                   	nop
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_rcr2>:
uint32 sys_rcr2()
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 25                	push   $0x25
  802330:	e8 81 fb ff ff       	call   801eb6 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 04             	sub    $0x4,%esp
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802346:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	50                   	push   %eax
  802353:	6a 26                	push   $0x26
  802355:	e8 5c fb ff ff       	call   801eb6 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
	return ;
  80235d:	90                   	nop
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <rsttst>:
void rsttst()
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 28                	push   $0x28
  80236f:	e8 42 fb ff ff       	call   801eb6 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
	return ;
  802377:	90                   	nop
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	8b 45 14             	mov    0x14(%ebp),%eax
  802383:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802386:	8b 55 18             	mov    0x18(%ebp),%edx
  802389:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80238d:	52                   	push   %edx
  80238e:	50                   	push   %eax
  80238f:	ff 75 10             	pushl  0x10(%ebp)
  802392:	ff 75 0c             	pushl  0xc(%ebp)
  802395:	ff 75 08             	pushl  0x8(%ebp)
  802398:	6a 27                	push   $0x27
  80239a:	e8 17 fb ff ff       	call   801eb6 <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a2:	90                   	nop
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <chktst>:
void chktst(uint32 n)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	6a 29                	push   $0x29
  8023b5:	e8 fc fa ff ff       	call   801eb6 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bd:	90                   	nop
}
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <inctst>:

void inctst()
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 2a                	push   $0x2a
  8023cf:	e8 e2 fa ff ff       	call   801eb6 <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d7:	90                   	nop
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <gettst>:
uint32 gettst()
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 2b                	push   $0x2b
  8023e9:	e8 c8 fa ff ff       	call   801eb6 <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 2c                	push   $0x2c
  802405:	e8 ac fa ff ff       	call   801eb6 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
  80240d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802410:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802414:	75 07                	jne    80241d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802416:	b8 01 00 00 00       	mov    $0x1,%eax
  80241b:	eb 05                	jmp    802422 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 2c                	push   $0x2c
  802436:	e8 7b fa ff ff       	call   801eb6 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
  80243e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802441:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802445:	75 07                	jne    80244e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802447:	b8 01 00 00 00       	mov    $0x1,%eax
  80244c:	eb 05                	jmp    802453 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 2c                	push   $0x2c
  802467:	e8 4a fa ff ff       	call   801eb6 <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
  80246f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802472:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802476:	75 07                	jne    80247f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802478:	b8 01 00 00 00       	mov    $0x1,%eax
  80247d:	eb 05                	jmp    802484 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 2c                	push   $0x2c
  802498:	e8 19 fa ff ff       	call   801eb6 <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
  8024a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024a3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024a7:	75 07                	jne    8024b0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ae:	eb 05                	jmp    8024b5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	ff 75 08             	pushl  0x8(%ebp)
  8024c5:	6a 2d                	push   $0x2d
  8024c7:	e8 ea f9 ff ff       	call   801eb6 <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cf:	90                   	nop
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	6a 00                	push   $0x0
  8024e4:	53                   	push   %ebx
  8024e5:	51                   	push   %ecx
  8024e6:	52                   	push   %edx
  8024e7:	50                   	push   %eax
  8024e8:	6a 2e                	push   $0x2e
  8024ea:	e8 c7 f9 ff ff       	call   801eb6 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	52                   	push   %edx
  802507:	50                   	push   %eax
  802508:	6a 2f                	push   $0x2f
  80250a:	e8 a7 f9 ff ff       	call   801eb6 <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <__udivdi3>:
  802514:	55                   	push   %ebp
  802515:	57                   	push   %edi
  802516:	56                   	push   %esi
  802517:	53                   	push   %ebx
  802518:	83 ec 1c             	sub    $0x1c,%esp
  80251b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80251f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80252b:	89 ca                	mov    %ecx,%edx
  80252d:	89 f8                	mov    %edi,%eax
  80252f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802533:	85 f6                	test   %esi,%esi
  802535:	75 2d                	jne    802564 <__udivdi3+0x50>
  802537:	39 cf                	cmp    %ecx,%edi
  802539:	77 65                	ja     8025a0 <__udivdi3+0x8c>
  80253b:	89 fd                	mov    %edi,%ebp
  80253d:	85 ff                	test   %edi,%edi
  80253f:	75 0b                	jne    80254c <__udivdi3+0x38>
  802541:	b8 01 00 00 00       	mov    $0x1,%eax
  802546:	31 d2                	xor    %edx,%edx
  802548:	f7 f7                	div    %edi
  80254a:	89 c5                	mov    %eax,%ebp
  80254c:	31 d2                	xor    %edx,%edx
  80254e:	89 c8                	mov    %ecx,%eax
  802550:	f7 f5                	div    %ebp
  802552:	89 c1                	mov    %eax,%ecx
  802554:	89 d8                	mov    %ebx,%eax
  802556:	f7 f5                	div    %ebp
  802558:	89 cf                	mov    %ecx,%edi
  80255a:	89 fa                	mov    %edi,%edx
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	39 ce                	cmp    %ecx,%esi
  802566:	77 28                	ja     802590 <__udivdi3+0x7c>
  802568:	0f bd fe             	bsr    %esi,%edi
  80256b:	83 f7 1f             	xor    $0x1f,%edi
  80256e:	75 40                	jne    8025b0 <__udivdi3+0x9c>
  802570:	39 ce                	cmp    %ecx,%esi
  802572:	72 0a                	jb     80257e <__udivdi3+0x6a>
  802574:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802578:	0f 87 9e 00 00 00    	ja     80261c <__udivdi3+0x108>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	89 fa                	mov    %edi,%edx
  802585:	83 c4 1c             	add    $0x1c,%esp
  802588:	5b                   	pop    %ebx
  802589:	5e                   	pop    %esi
  80258a:	5f                   	pop    %edi
  80258b:	5d                   	pop    %ebp
  80258c:	c3                   	ret    
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	31 ff                	xor    %edi,%edi
  802592:	31 c0                	xor    %eax,%eax
  802594:	89 fa                	mov    %edi,%edx
  802596:	83 c4 1c             	add    $0x1c,%esp
  802599:	5b                   	pop    %ebx
  80259a:	5e                   	pop    %esi
  80259b:	5f                   	pop    %edi
  80259c:	5d                   	pop    %ebp
  80259d:	c3                   	ret    
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	89 d8                	mov    %ebx,%eax
  8025a2:	f7 f7                	div    %edi
  8025a4:	31 ff                	xor    %edi,%edi
  8025a6:	89 fa                	mov    %edi,%edx
  8025a8:	83 c4 1c             	add    $0x1c,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025b5:	89 eb                	mov    %ebp,%ebx
  8025b7:	29 fb                	sub    %edi,%ebx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	d3 e6                	shl    %cl,%esi
  8025bd:	89 c5                	mov    %eax,%ebp
  8025bf:	88 d9                	mov    %bl,%cl
  8025c1:	d3 ed                	shr    %cl,%ebp
  8025c3:	89 e9                	mov    %ebp,%ecx
  8025c5:	09 f1                	or     %esi,%ecx
  8025c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025cb:	89 f9                	mov    %edi,%ecx
  8025cd:	d3 e0                	shl    %cl,%eax
  8025cf:	89 c5                	mov    %eax,%ebp
  8025d1:	89 d6                	mov    %edx,%esi
  8025d3:	88 d9                	mov    %bl,%cl
  8025d5:	d3 ee                	shr    %cl,%esi
  8025d7:	89 f9                	mov    %edi,%ecx
  8025d9:	d3 e2                	shl    %cl,%edx
  8025db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025df:	88 d9                	mov    %bl,%cl
  8025e1:	d3 e8                	shr    %cl,%eax
  8025e3:	09 c2                	or     %eax,%edx
  8025e5:	89 d0                	mov    %edx,%eax
  8025e7:	89 f2                	mov    %esi,%edx
  8025e9:	f7 74 24 0c          	divl   0xc(%esp)
  8025ed:	89 d6                	mov    %edx,%esi
  8025ef:	89 c3                	mov    %eax,%ebx
  8025f1:	f7 e5                	mul    %ebp
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	72 19                	jb     802610 <__udivdi3+0xfc>
  8025f7:	74 0b                	je     802604 <__udivdi3+0xf0>
  8025f9:	89 d8                	mov    %ebx,%eax
  8025fb:	31 ff                	xor    %edi,%edi
  8025fd:	e9 58 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  802602:	66 90                	xchg   %ax,%ax
  802604:	8b 54 24 08          	mov    0x8(%esp),%edx
  802608:	89 f9                	mov    %edi,%ecx
  80260a:	d3 e2                	shl    %cl,%edx
  80260c:	39 c2                	cmp    %eax,%edx
  80260e:	73 e9                	jae    8025f9 <__udivdi3+0xe5>
  802610:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802613:	31 ff                	xor    %edi,%edi
  802615:	e9 40 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	31 c0                	xor    %eax,%eax
  80261e:	e9 37 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  802623:	90                   	nop

00802624 <__umoddi3>:
  802624:	55                   	push   %ebp
  802625:	57                   	push   %edi
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	83 ec 1c             	sub    $0x1c,%esp
  80262b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80262f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802637:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80263b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80263f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802643:	89 f3                	mov    %esi,%ebx
  802645:	89 fa                	mov    %edi,%edx
  802647:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80264b:	89 34 24             	mov    %esi,(%esp)
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 1a                	jne    80266c <__umoddi3+0x48>
  802652:	39 f7                	cmp    %esi,%edi
  802654:	0f 86 a2 00 00 00    	jbe    8026fc <__umoddi3+0xd8>
  80265a:	89 c8                	mov    %ecx,%eax
  80265c:	89 f2                	mov    %esi,%edx
  80265e:	f7 f7                	div    %edi
  802660:	89 d0                	mov    %edx,%eax
  802662:	31 d2                	xor    %edx,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	39 f0                	cmp    %esi,%eax
  80266e:	0f 87 ac 00 00 00    	ja     802720 <__umoddi3+0xfc>
  802674:	0f bd e8             	bsr    %eax,%ebp
  802677:	83 f5 1f             	xor    $0x1f,%ebp
  80267a:	0f 84 ac 00 00 00    	je     80272c <__umoddi3+0x108>
  802680:	bf 20 00 00 00       	mov    $0x20,%edi
  802685:	29 ef                	sub    %ebp,%edi
  802687:	89 fe                	mov    %edi,%esi
  802689:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268d:	89 e9                	mov    %ebp,%ecx
  80268f:	d3 e0                	shl    %cl,%eax
  802691:	89 d7                	mov    %edx,%edi
  802693:	89 f1                	mov    %esi,%ecx
  802695:	d3 ef                	shr    %cl,%edi
  802697:	09 c7                	or     %eax,%edi
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	d3 e2                	shl    %cl,%edx
  80269d:	89 14 24             	mov    %edx,(%esp)
  8026a0:	89 d8                	mov    %ebx,%eax
  8026a2:	d3 e0                	shl    %cl,%eax
  8026a4:	89 c2                	mov    %eax,%edx
  8026a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026aa:	d3 e0                	shl    %cl,%eax
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b4:	89 f1                	mov    %esi,%ecx
  8026b6:	d3 e8                	shr    %cl,%eax
  8026b8:	09 d0                	or     %edx,%eax
  8026ba:	d3 eb                	shr    %cl,%ebx
  8026bc:	89 da                	mov    %ebx,%edx
  8026be:	f7 f7                	div    %edi
  8026c0:	89 d3                	mov    %edx,%ebx
  8026c2:	f7 24 24             	mull   (%esp)
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	89 d1                	mov    %edx,%ecx
  8026c9:	39 d3                	cmp    %edx,%ebx
  8026cb:	0f 82 87 00 00 00    	jb     802758 <__umoddi3+0x134>
  8026d1:	0f 84 91 00 00 00    	je     802768 <__umoddi3+0x144>
  8026d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026db:	29 f2                	sub    %esi,%edx
  8026dd:	19 cb                	sbb    %ecx,%ebx
  8026df:	89 d8                	mov    %ebx,%eax
  8026e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026e5:	d3 e0                	shl    %cl,%eax
  8026e7:	89 e9                	mov    %ebp,%ecx
  8026e9:	d3 ea                	shr    %cl,%edx
  8026eb:	09 d0                	or     %edx,%eax
  8026ed:	89 e9                	mov    %ebp,%ecx
  8026ef:	d3 eb                	shr    %cl,%ebx
  8026f1:	89 da                	mov    %ebx,%edx
  8026f3:	83 c4 1c             	add    $0x1c,%esp
  8026f6:	5b                   	pop    %ebx
  8026f7:	5e                   	pop    %esi
  8026f8:	5f                   	pop    %edi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    
  8026fb:	90                   	nop
  8026fc:	89 fd                	mov    %edi,%ebp
  8026fe:	85 ff                	test   %edi,%edi
  802700:	75 0b                	jne    80270d <__umoddi3+0xe9>
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	31 d2                	xor    %edx,%edx
  802709:	f7 f7                	div    %edi
  80270b:	89 c5                	mov    %eax,%ebp
  80270d:	89 f0                	mov    %esi,%eax
  80270f:	31 d2                	xor    %edx,%edx
  802711:	f7 f5                	div    %ebp
  802713:	89 c8                	mov    %ecx,%eax
  802715:	f7 f5                	div    %ebp
  802717:	89 d0                	mov    %edx,%eax
  802719:	e9 44 ff ff ff       	jmp    802662 <__umoddi3+0x3e>
  80271e:	66 90                	xchg   %ax,%ax
  802720:	89 c8                	mov    %ecx,%eax
  802722:	89 f2                	mov    %esi,%edx
  802724:	83 c4 1c             	add    $0x1c,%esp
  802727:	5b                   	pop    %ebx
  802728:	5e                   	pop    %esi
  802729:	5f                   	pop    %edi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    
  80272c:	3b 04 24             	cmp    (%esp),%eax
  80272f:	72 06                	jb     802737 <__umoddi3+0x113>
  802731:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802735:	77 0f                	ja     802746 <__umoddi3+0x122>
  802737:	89 f2                	mov    %esi,%edx
  802739:	29 f9                	sub    %edi,%ecx
  80273b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80273f:	89 14 24             	mov    %edx,(%esp)
  802742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802746:	8b 44 24 04          	mov    0x4(%esp),%eax
  80274a:	8b 14 24             	mov    (%esp),%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	2b 04 24             	sub    (%esp),%eax
  80275b:	19 fa                	sbb    %edi,%edx
  80275d:	89 d1                	mov    %edx,%ecx
  80275f:	89 c6                	mov    %eax,%esi
  802761:	e9 71 ff ff ff       	jmp    8026d7 <__umoddi3+0xb3>
  802766:	66 90                	xchg   %ax,%ax
  802768:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80276c:	72 ea                	jb     802758 <__umoddi3+0x134>
  80276e:	89 d9                	mov    %ebx,%ecx
  802770:	e9 62 ff ff ff       	jmp    8026d7 <__umoddi3+0xb3>
