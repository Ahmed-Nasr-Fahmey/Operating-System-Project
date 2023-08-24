
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 40 0e 00 00       	call   800e76 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 40 80 00       	mov    0x804020,%eax
  800055:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 40 80 00       	mov    0x804020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 20 2a 80 00       	push   $0x802a20
  800096:	6a 1a                	push   $0x1a
  800098:	68 3c 2a 80 00       	push   $0x802a3c
  80009d:	e8 23 0f 00 00       	call   800fc5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 71 1f 00 00       	call   80201d <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 48 21 00 00       	call   80222c <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 cc 21 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 09 1f 00 00       	call   80201d <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 50 2a 80 00       	push   $0x802a50
  80013c:	6a 39                	push   $0x39
  80013e:	68 3c 2a 80 00       	push   $0x802a3c
  800143:	e8 7d 0e 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 7f 21 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  80014d:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800150:	3d 00 02 00 00       	cmp    $0x200,%eax
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 b8 2a 80 00       	push   $0x802ab8
  80015f:	6a 3a                	push   $0x3a
  800161:	68 3c 2a 80 00       	push   $0x802a3c
  800166:	e8 5a 0e 00 00       	call   800fc5 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  80016b:	e8 bc 20 00 00       	call   80222c <sys_calculate_free_frames>
  800170:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	01 c0                	add    %eax,%eax
  800178:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80017b:	48                   	dec    %eax
  80017c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017f:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800185:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800188:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80018b:	8a 55 df             	mov    -0x21(%ebp),%dl
  80018e:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800190:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800193:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800196:	01 c2                	add    %eax,%edx
  800198:	8a 45 de             	mov    -0x22(%ebp),%al
  80019b:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8001a0:	e8 87 20 00 00       	call   80222c <sys_calculate_free_frames>
  8001a5:	29 c3                	sub    %eax,%ebx
  8001a7:	89 d8                	mov    %ebx,%eax
  8001a9:	83 f8 03             	cmp    $0x3,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e8 2a 80 00       	push   $0x802ae8
  8001b6:	6a 41                	push   $0x41
  8001b8:	68 3c 2a 80 00       	push   $0x802a3c
  8001bd:	e8 03 0e 00 00       	call   800fc5 <_panic>
		int var;
		int found = 0;
  8001c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001d0:	e9 82 00 00 00       	jmp    800257 <_main+0x21f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001da:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	c1 e0 03             	shl    $0x3,%eax
  8001ec:	01 c8                	add    %ecx,%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800200:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800203:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800206:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020b:	39 c2                	cmp    %eax,%edx
  80020d:	75 03                	jne    800212 <_main+0x1da>
				found++;
  80020f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80021d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800220:	89 d0                	mov    %edx,%eax
  800222:	01 c0                	add    %eax,%eax
  800224:	01 d0                	add    %edx,%eax
  800226:	c1 e0 03             	shl    $0x3,%eax
  800229:	01 c8                	add    %ecx,%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800230:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800238:	89 c1                	mov    %eax,%ecx
  80023a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80023d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800240:	01 d0                	add    %edx,%eax
  800242:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800245:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800248:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024d:	39 c1                	cmp    %eax,%ecx
  80024f:	75 03                	jne    800254 <_main+0x21c>
				found++;
  800251:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800254:	ff 45 ec             	incl   -0x14(%ebp)
  800257:	a1 20 40 80 00       	mov    0x804020,%eax
  80025c:	8b 50 74             	mov    0x74(%eax),%edx
  80025f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800262:	39 c2                	cmp    %eax,%edx
  800264:	0f 87 6b ff ff ff    	ja     8001d5 <_main+0x19d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80026a:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80026e:	74 14                	je     800284 <_main+0x24c>
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	68 2c 2b 80 00       	push   $0x802b2c
  800278:	6a 4b                	push   $0x4b
  80027a:	68 3c 2a 80 00       	push   $0x802a3c
  80027f:	e8 41 0d 00 00       	call   800fc5 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800284:	e8 43 20 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800289:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 80 1d 00 00       	call   80201d <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a6:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002ac:	89 c2                	mov    %eax,%edx
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b8:	39 c2                	cmp    %eax,%edx
  8002ba:	72 16                	jb     8002d2 <_main+0x29a>
  8002bc:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002c2:	89 c2                	mov    %eax,%edx
  8002c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	76 14                	jbe    8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 50 2a 80 00       	push   $0x802a50
  8002da:	6a 50                	push   $0x50
  8002dc:	68 3c 2a 80 00       	push   $0x802a3c
  8002e1:	e8 df 0c 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002e6:	e8 e1 1f 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  8002eb:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8002ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 b8 2a 80 00       	push   $0x802ab8
  8002fd:	6a 51                	push   $0x51
  8002ff:	68 3c 2a 80 00       	push   $0x802a3c
  800304:	e8 bc 0c 00 00       	call   800fc5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800309:	e8 1e 1f 00 00       	call   80222c <sys_calculate_free_frames>
  80030e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800311:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800317:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	01 c0                	add    %eax,%eax
  80031f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800322:	d1 e8                	shr    %eax
  800324:	48                   	dec    %eax
  800325:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  800328:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80032b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032e:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800331:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800334:	01 c0                	add    %eax,%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80033b:	01 c2                	add    %eax,%edx
  80033d:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800341:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800344:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800347:	e8 e0 1e 00 00       	call   80222c <sys_calculate_free_frames>
  80034c:	29 c3                	sub    %eax,%ebx
  80034e:	89 d8                	mov    %ebx,%eax
  800350:	83 f8 02             	cmp    $0x2,%eax
  800353:	74 14                	je     800369 <_main+0x331>
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 e8 2a 80 00       	push   $0x802ae8
  80035d:	6a 58                	push   $0x58
  80035f:	68 3c 2a 80 00       	push   $0x802a3c
  800364:	e8 5c 0c 00 00       	call   800fc5 <_panic>
		found = 0;
  800369:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800370:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800377:	e9 86 00 00 00       	jmp    800402 <_main+0x3ca>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800387:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80038a:	89 d0                	mov    %edx,%eax
  80038c:	01 c0                	add    %eax,%eax
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 03             	shl    $0x3,%eax
  800393:	01 c8                	add    %ecx,%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80039a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80039d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a7:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003aa:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	75 03                	jne    8003b9 <_main+0x381>
				found++;
  8003b6:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003be:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8003c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	01 c0                	add    %eax,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	c1 e0 03             	shl    $0x3,%eax
  8003d0:	01 c8                	add    %ecx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003d7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f8:	39 c2                	cmp    %eax,%edx
  8003fa:	75 03                	jne    8003ff <_main+0x3c7>
				found++;
  8003fc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003ff:	ff 45 ec             	incl   -0x14(%ebp)
  800402:	a1 20 40 80 00       	mov    0x804020,%eax
  800407:	8b 50 74             	mov    0x74(%eax),%edx
  80040a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040d:	39 c2                	cmp    %eax,%edx
  80040f:	0f 87 67 ff ff ff    	ja     80037c <_main+0x344>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800415:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800419:	74 14                	je     80042f <_main+0x3f7>
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	68 2c 2b 80 00       	push   $0x802b2c
  800423:	6a 61                	push   $0x61
  800425:	68 3c 2a 80 00       	push   $0x802a3c
  80042a:	e8 96 0b 00 00       	call   800fc5 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042f:	e8 98 1e 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800434:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043a:	89 c2                	mov    %eax,%edx
  80043c:	01 d2                	add    %edx,%edx
  80043e:	01 d0                	add    %edx,%eax
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	50                   	push   %eax
  800444:	e8 d4 1b 00 00       	call   80201d <malloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800452:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800458:	89 c2                	mov    %eax,%edx
  80045a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045d:	c1 e0 02             	shl    $0x2,%eax
  800460:	05 00 00 00 80       	add    $0x80000000,%eax
  800465:	39 c2                	cmp    %eax,%edx
  800467:	72 17                	jb     800480 <_main+0x448>
  800469:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80046f:	89 c2                	mov    %eax,%edx
  800471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800474:	c1 e0 02             	shl    $0x2,%eax
  800477:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80047c:	39 c2                	cmp    %eax,%edx
  80047e:	76 14                	jbe    800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 50 2a 80 00       	push   $0x802a50
  800488:	6a 66                	push   $0x66
  80048a:	68 3c 2a 80 00       	push   $0x802a3c
  80048f:	e8 31 0b 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800494:	e8 33 1e 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800499:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80049c:	83 f8 01             	cmp    $0x1,%eax
  80049f:	74 14                	je     8004b5 <_main+0x47d>
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 b8 2a 80 00       	push   $0x802ab8
  8004a9:	6a 67                	push   $0x67
  8004ab:	68 3c 2a 80 00       	push   $0x802a3c
  8004b0:	e8 10 0b 00 00       	call   800fc5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b5:	e8 72 1d 00 00       	call   80222c <sys_calculate_free_frames>
  8004ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004bd:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004c3:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c9:	01 c0                	add    %eax,%eax
  8004cb:	c1 e8 02             	shr    $0x2,%eax
  8004ce:	48                   	dec    %eax
  8004cf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004d2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d8:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004da:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004e7:	01 c2                	add    %eax,%edx
  8004e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ec:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ee:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004f1:	e8 36 1d 00 00       	call   80222c <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 f8 02             	cmp    $0x2,%eax
  8004fd:	74 14                	je     800513 <_main+0x4db>
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	68 e8 2a 80 00       	push   $0x802ae8
  800507:	6a 6e                	push   $0x6e
  800509:	68 3c 2a 80 00       	push   $0x802a3c
  80050e:	e8 b2 0a 00 00       	call   800fc5 <_panic>
		found = 0;
  800513:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80051a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800521:	e9 8f 00 00 00       	jmp    8005b5 <_main+0x57d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800526:	a1 20 40 80 00       	mov    0x804020,%eax
  80052b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800531:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800534:	89 d0                	mov    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	c1 e0 03             	shl    $0x3,%eax
  80053d:	01 c8                	add    %ecx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 88             	mov    %eax,-0x78(%ebp)
  800544:	8b 45 88             	mov    -0x78(%ebp),%eax
  800547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054c:	89 c2                	mov    %eax,%edx
  80054e:	8b 45 90             	mov    -0x70(%ebp),%eax
  800551:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800554:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800557:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80055c:	39 c2                	cmp    %eax,%edx
  80055e:	75 03                	jne    800563 <_main+0x52b>
				found++;
  800560:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800563:	a1 20 40 80 00       	mov    0x804020,%eax
  800568:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80056e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800571:	89 d0                	mov    %edx,%eax
  800573:	01 c0                	add    %eax,%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	c1 e0 03             	shl    $0x3,%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	89 45 80             	mov    %eax,-0x80(%ebp)
  800581:	8b 45 80             	mov    -0x80(%ebp),%eax
  800584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800589:	89 c2                	mov    %eax,%edx
  80058b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800595:	8b 45 90             	mov    -0x70(%ebp),%eax
  800598:	01 c8                	add    %ecx,%eax
  80059a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8005a0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ab:	39 c2                	cmp    %eax,%edx
  8005ad:	75 03                	jne    8005b2 <_main+0x57a>
				found++;
  8005af:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005b2:	ff 45 ec             	incl   -0x14(%ebp)
  8005b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ba:	8b 50 74             	mov    0x74(%eax),%edx
  8005bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c0:	39 c2                	cmp    %eax,%edx
  8005c2:	0f 87 5e ff ff ff    	ja     800526 <_main+0x4ee>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005c8:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005cc:	74 14                	je     8005e2 <_main+0x5aa>
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 2c 2b 80 00       	push   $0x802b2c
  8005d6:	6a 77                	push   $0x77
  8005d8:	68 3c 2a 80 00       	push   $0x802a3c
  8005dd:	e8 e3 09 00 00       	call   800fc5 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e2:	e8 45 1c 00 00       	call   80222c <sys_calculate_free_frames>
  8005e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005ea:	e8 dd 1c 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  8005ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f5:	89 c2                	mov    %eax,%edx
  8005f7:	01 d2                	add    %edx,%edx
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	83 ec 0c             	sub    $0xc,%esp
  8005fe:	50                   	push   %eax
  8005ff:	e8 19 1a 00 00       	call   80201d <malloc>
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060d:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800613:	89 c2                	mov    %eax,%edx
  800615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800618:	c1 e0 02             	shl    $0x2,%eax
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800620:	c1 e0 02             	shl    $0x2,%eax
  800623:	01 c8                	add    %ecx,%eax
  800625:	05 00 00 00 80       	add    $0x80000000,%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	72 21                	jb     80064f <_main+0x617>
  80062e:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800634:	89 c2                	mov    %eax,%edx
  800636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800639:	c1 e0 02             	shl    $0x2,%eax
  80063c:	89 c1                	mov    %eax,%ecx
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	c1 e0 02             	shl    $0x2,%eax
  800644:	01 c8                	add    %ecx,%eax
  800646:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	76 14                	jbe    800663 <_main+0x62b>
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	68 50 2a 80 00       	push   $0x802a50
  800657:	6a 7d                	push   $0x7d
  800659:	68 3c 2a 80 00       	push   $0x802a3c
  80065e:	e8 62 09 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800663:	e8 64 1c 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800668:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80066b:	83 f8 01             	cmp    $0x1,%eax
  80066e:	74 14                	je     800684 <_main+0x64c>
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 b8 2a 80 00       	push   $0x802ab8
  800678:	6a 7e                	push   $0x7e
  80067a:	68 3c 2a 80 00       	push   $0x802a3c
  80067f:	e8 41 09 00 00       	call   800fc5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800684:	e8 43 1c 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800689:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80068c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068f:	89 d0                	mov    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	01 c0                	add    %eax,%eax
  800697:	01 d0                	add    %edx,%eax
  800699:	83 ec 0c             	sub    $0xc,%esp
  80069c:	50                   	push   %eax
  80069d:	e8 7b 19 00 00       	call   80201d <malloc>
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006ab:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006b1:	89 c2                	mov    %eax,%edx
  8006b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b6:	c1 e0 02             	shl    $0x2,%eax
  8006b9:	89 c1                	mov    %eax,%ecx
  8006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c8:	39 c2                	cmp    %eax,%edx
  8006ca:	72 21                	jb     8006ed <_main+0x6b5>
  8006cc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006d2:	89 c2                	mov    %eax,%edx
  8006d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d7:	c1 e0 02             	shl    $0x2,%eax
  8006da:	89 c1                	mov    %eax,%ecx
  8006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006df:	c1 e0 03             	shl    $0x3,%eax
  8006e2:	01 c8                	add    %ecx,%eax
  8006e4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e9:	39 c2                	cmp    %eax,%edx
  8006eb:	76 17                	jbe    800704 <_main+0x6cc>
  8006ed:	83 ec 04             	sub    $0x4,%esp
  8006f0:	68 50 2a 80 00       	push   $0x802a50
  8006f5:	68 84 00 00 00       	push   $0x84
  8006fa:	68 3c 2a 80 00       	push   $0x802a3c
  8006ff:	e8 c1 08 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800704:	e8 c3 1b 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800709:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80070c:	83 f8 02             	cmp    $0x2,%eax
  80070f:	74 17                	je     800728 <_main+0x6f0>
  800711:	83 ec 04             	sub    $0x4,%esp
  800714:	68 b8 2a 80 00       	push   $0x802ab8
  800719:	68 85 00 00 00       	push   $0x85
  80071e:	68 3c 2a 80 00       	push   $0x802a3c
  800723:	e8 9d 08 00 00       	call   800fc5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800728:	e8 ff 1a 00 00       	call   80222c <sys_calculate_free_frames>
  80072d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  800730:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800736:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80073c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80073f:	89 d0                	mov    %edx,%eax
  800741:	01 c0                	add    %eax,%eax
  800743:	01 d0                	add    %edx,%eax
  800745:	01 c0                	add    %eax,%eax
  800747:	01 d0                	add    %edx,%eax
  800749:	c1 e8 03             	shr    $0x3,%eax
  80074c:	48                   	dec    %eax
  80074d:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800753:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800759:	8a 55 df             	mov    -0x21(%ebp),%dl
  80075c:	88 10                	mov    %dl,(%eax)
  80075e:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800767:	66 89 42 02          	mov    %ax,0x2(%edx)
  80076b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800774:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800777:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80077d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800784:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80078a:	01 c2                	add    %eax,%edx
  80078c:	8a 45 de             	mov    -0x22(%ebp),%al
  80078f:	88 02                	mov    %al,(%edx)
  800791:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800797:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80079e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007a4:	01 c2                	add    %eax,%edx
  8007a6:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  8007aa:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007ae:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bb:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007c1:	01 c2                	add    %eax,%edx
  8007c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c6:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c9:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007cc:	e8 5b 1a 00 00       	call   80222c <sys_calculate_free_frames>
  8007d1:	29 c3                	sub    %eax,%ebx
  8007d3:	89 d8                	mov    %ebx,%eax
  8007d5:	83 f8 02             	cmp    $0x2,%eax
  8007d8:	74 17                	je     8007f1 <_main+0x7b9>
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	68 e8 2a 80 00       	push   $0x802ae8
  8007e2:	68 8c 00 00 00       	push   $0x8c
  8007e7:	68 3c 2a 80 00       	push   $0x802a3c
  8007ec:	e8 d4 07 00 00       	call   800fc5 <_panic>
		found = 0;
  8007f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ff:	e9 aa 00 00 00       	jmp    8008ae <_main+0x876>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  800804:	a1 20 40 80 00       	mov    0x804020,%eax
  800809:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80080f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800812:	89 d0                	mov    %edx,%eax
  800814:	01 c0                	add    %eax,%eax
  800816:	01 d0                	add    %edx,%eax
  800818:	c1 e0 03             	shl    $0x3,%eax
  80081b:	01 c8                	add    %ecx,%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800825:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80082b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800830:	89 c2                	mov    %eax,%edx
  800832:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800838:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80083e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800844:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800849:	39 c2                	cmp    %eax,%edx
  80084b:	75 03                	jne    800850 <_main+0x818>
				found++;
  80084d:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  800850:	a1 20 40 80 00       	mov    0x804020,%eax
  800855:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80085b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80085e:	89 d0                	mov    %edx,%eax
  800860:	01 c0                	add    %eax,%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	c1 e0 03             	shl    $0x3,%eax
  800867:	01 c8                	add    %ecx,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800871:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800877:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087c:	89 c2                	mov    %eax,%edx
  80087e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800884:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80088b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800891:	01 c8                	add    %ecx,%eax
  800893:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800899:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80089f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	75 03                	jne    8008ab <_main+0x873>
				found++;
  8008a8:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008ab:	ff 45 ec             	incl   -0x14(%ebp)
  8008ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b3:	8b 50 74             	mov    0x74(%eax),%edx
  8008b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b9:	39 c2                	cmp    %eax,%edx
  8008bb:	0f 87 43 ff ff ff    	ja     800804 <_main+0x7cc>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008c1:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c5:	74 17                	je     8008de <_main+0x8a6>
  8008c7:	83 ec 04             	sub    $0x4,%esp
  8008ca:	68 2c 2b 80 00       	push   $0x802b2c
  8008cf:	68 95 00 00 00       	push   $0x95
  8008d4:	68 3c 2a 80 00       	push   $0x802a3c
  8008d9:	e8 e7 06 00 00       	call   800fc5 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008de:	e8 49 19 00 00       	call   80222c <sys_calculate_free_frames>
  8008e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e6:	e8 e1 19 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  8008eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	01 d2                	add    %edx,%edx
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	50                   	push   %eax
  8008fe:	e8 1a 17 00 00       	call   80201d <malloc>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80090c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800912:	89 c2                	mov    %eax,%edx
  800914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800917:	c1 e0 02             	shl    $0x2,%eax
  80091a:	89 c1                	mov    %eax,%ecx
  80091c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091f:	c1 e0 04             	shl    $0x4,%eax
  800922:	01 c8                	add    %ecx,%eax
  800924:	05 00 00 00 80       	add    $0x80000000,%eax
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	72 21                	jb     80094e <_main+0x916>
  80092d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800933:	89 c2                	mov    %eax,%edx
  800935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800938:	c1 e0 02             	shl    $0x2,%eax
  80093b:	89 c1                	mov    %eax,%ecx
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	c1 e0 04             	shl    $0x4,%eax
  800943:	01 c8                	add    %ecx,%eax
  800945:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	76 17                	jbe    800965 <_main+0x92d>
  80094e:	83 ec 04             	sub    $0x4,%esp
  800951:	68 50 2a 80 00       	push   $0x802a50
  800956:	68 9b 00 00 00       	push   $0x9b
  80095b:	68 3c 2a 80 00       	push   $0x802a3c
  800960:	e8 60 06 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800965:	e8 62 19 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  80096a:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800972:	89 c1                	mov    %eax,%ecx
  800974:	01 c9                	add    %ecx,%ecx
  800976:	01 c8                	add    %ecx,%eax
  800978:	85 c0                	test   %eax,%eax
  80097a:	79 05                	jns    800981 <_main+0x949>
  80097c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800981:	c1 f8 0c             	sar    $0xc,%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 b8 2a 80 00       	push   $0x802ab8
  800990:	68 9c 00 00 00       	push   $0x9c
  800995:	68 3c 2a 80 00       	push   $0x802a3c
  80099a:	e8 26 06 00 00       	call   800fc5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80099f:	e8 28 19 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  8009a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  8009a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009aa:	89 d0                	mov    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	01 c0                	add    %eax,%eax
  8009b2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8009b5:	83 ec 0c             	sub    $0xc,%esp
  8009b8:	50                   	push   %eax
  8009b9:	e8 5f 16 00 00       	call   80201d <malloc>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009cd:	89 c1                	mov    %eax,%ecx
  8009cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009d2:	89 d0                	mov    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	01 c0                	add    %eax,%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	89 c2                	mov    %eax,%edx
  8009de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e1:	c1 e0 04             	shl    $0x4,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8009eb:	39 c1                	cmp    %eax,%ecx
  8009ed:	72 28                	jb     800a17 <_main+0x9df>
  8009ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009f5:	89 c1                	mov    %eax,%ecx
  8009f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009fa:	89 d0                	mov    %edx,%eax
  8009fc:	01 c0                	add    %eax,%eax
  8009fe:	01 d0                	add    %edx,%eax
  800a00:	01 c0                	add    %eax,%eax
  800a02:	01 d0                	add    %edx,%eax
  800a04:	89 c2                	mov    %eax,%edx
  800a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a09:	c1 e0 04             	shl    $0x4,%eax
  800a0c:	01 d0                	add    %edx,%eax
  800a0e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a13:	39 c1                	cmp    %eax,%ecx
  800a15:	76 17                	jbe    800a2e <_main+0x9f6>
  800a17:	83 ec 04             	sub    $0x4,%esp
  800a1a:	68 50 2a 80 00       	push   $0x802a50
  800a1f:	68 a2 00 00 00       	push   $0xa2
  800a24:	68 3c 2a 80 00       	push   $0x802a3c
  800a29:	e8 97 05 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800a2e:	e8 99 18 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800a33:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800a36:	89 c1                	mov    %eax,%ecx
  800a38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	01 d0                	add    %edx,%eax
  800a41:	01 c0                	add    %eax,%eax
  800a43:	85 c0                	test   %eax,%eax
  800a45:	79 05                	jns    800a4c <_main+0xa14>
  800a47:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a4c:	c1 f8 0c             	sar    $0xc,%eax
  800a4f:	39 c1                	cmp    %eax,%ecx
  800a51:	74 17                	je     800a6a <_main+0xa32>
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	68 b8 2a 80 00       	push   $0x802ab8
  800a5b:	68 a3 00 00 00       	push   $0xa3
  800a60:	68 3c 2a 80 00       	push   $0x802a3c
  800a65:	e8 5b 05 00 00       	call   800fc5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a6a:	e8 bd 17 00 00       	call   80222c <sys_calculate_free_frames>
  800a6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d0                	add    %edx,%eax
  800a7b:	01 c0                	add    %eax,%eax
  800a7d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a80:	48                   	dec    %eax
  800a81:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a8d:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a93:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a99:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a9c:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a9e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	c1 ea 1f             	shr    $0x1f,%edx
  800aa9:	01 d0                	add    %edx,%eax
  800aab:	d1 f8                	sar    %eax
  800aad:	89 c2                	mov    %eax,%edx
  800aaf:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ab5:	01 c2                	add    %eax,%edx
  800ab7:	8a 45 de             	mov    -0x22(%ebp),%al
  800aba:	88 c1                	mov    %al,%cl
  800abc:	c0 e9 07             	shr    $0x7,%cl
  800abf:	01 c8                	add    %ecx,%eax
  800ac1:	d0 f8                	sar    %al
  800ac3:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800ac5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800acb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ad1:	01 c2                	add    %eax,%edx
  800ad3:	8a 45 de             	mov    -0x22(%ebp),%al
  800ad6:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800ad8:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800adb:	e8 4c 17 00 00       	call   80222c <sys_calculate_free_frames>
  800ae0:	29 c3                	sub    %eax,%ebx
  800ae2:	89 d8                	mov    %ebx,%eax
  800ae4:	83 f8 05             	cmp    $0x5,%eax
  800ae7:	74 17                	je     800b00 <_main+0xac8>
  800ae9:	83 ec 04             	sub    $0x4,%esp
  800aec:	68 e8 2a 80 00       	push   $0x802ae8
  800af1:	68 ab 00 00 00       	push   $0xab
  800af6:	68 3c 2a 80 00       	push   $0x802a3c
  800afb:	e8 c5 04 00 00       	call   800fc5 <_panic>
		found = 0;
  800b00:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800b0e:	e9 02 01 00 00       	jmp    800c15 <_main+0xbdd>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800b13:	a1 20 40 80 00       	mov    0x804020,%eax
  800b18:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	01 c0                	add    %eax,%eax
  800b25:	01 d0                	add    %edx,%eax
  800b27:	c1 e0 03             	shl    $0x3,%eax
  800b2a:	01 c8                	add    %ecx,%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800b34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b47:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b4d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	75 03                	jne    800b5f <_main+0xb27>
				found++;
  800b5c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b5f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b64:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b6d:	89 d0                	mov    %edx,%eax
  800b6f:	01 c0                	add    %eax,%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	c1 e0 03             	shl    $0x3,%eax
  800b76:	01 c8                	add    %ecx,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b80:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b8b:	89 c2                	mov    %eax,%edx
  800b8d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b93:	89 c1                	mov    %eax,%ecx
  800b95:	c1 e9 1f             	shr    $0x1f,%ecx
  800b98:	01 c8                	add    %ecx,%eax
  800b9a:	d1 f8                	sar    %eax
  800b9c:	89 c1                	mov    %eax,%ecx
  800b9e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ba4:	01 c8                	add    %ecx,%eax
  800ba6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800bac:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	75 03                	jne    800bbe <_main+0xb86>
				found++;
  800bbb:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800bbe:	a1 20 40 80 00       	mov    0x804020,%eax
  800bc3:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800bc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bcc:	89 d0                	mov    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	01 d0                	add    %edx,%eax
  800bd2:	c1 e0 03             	shl    $0x3,%eax
  800bd5:	01 c8                	add    %ecx,%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800bdf:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800be5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bea:	89 c1                	mov    %eax,%ecx
  800bec:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bf2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
  800bfa:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800c00:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c0b:	39 c1                	cmp    %eax,%ecx
  800c0d:	75 03                	jne    800c12 <_main+0xbda>
				found++;
  800c0f:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c12:	ff 45 ec             	incl   -0x14(%ebp)
  800c15:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1a:	8b 50 74             	mov    0x74(%eax),%edx
  800c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c20:	39 c2                	cmp    %eax,%edx
  800c22:	0f 87 eb fe ff ff    	ja     800b13 <_main+0xadb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800c28:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800c2c:	74 17                	je     800c45 <_main+0xc0d>
  800c2e:	83 ec 04             	sub    $0x4,%esp
  800c31:	68 2c 2b 80 00       	push   $0x802b2c
  800c36:	68 b6 00 00 00       	push   $0xb6
  800c3b:	68 3c 2a 80 00       	push   $0x802a3c
  800c40:	e8 80 03 00 00       	call   800fc5 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c45:	e8 82 16 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800c4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c50:	89 d0                	mov    %edx,%eax
  800c52:	01 c0                	add    %eax,%eax
  800c54:	01 d0                	add    %edx,%eax
  800c56:	01 c0                	add    %eax,%eax
  800c58:	01 d0                	add    %edx,%eax
  800c5a:	01 c0                	add    %eax,%eax
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	e8 b8 13 00 00       	call   80201d <malloc>
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c6e:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c74:	89 c1                	mov    %eax,%ecx
  800c76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c79:	89 d0                	mov    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d0                	add    %edx,%eax
  800c7f:	c1 e0 02             	shl    $0x2,%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	89 c2                	mov    %eax,%edx
  800c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c89:	c1 e0 04             	shl    $0x4,%eax
  800c8c:	01 d0                	add    %edx,%eax
  800c8e:	05 00 00 00 80       	add    $0x80000000,%eax
  800c93:	39 c1                	cmp    %eax,%ecx
  800c95:	72 29                	jb     800cc0 <_main+0xc88>
  800c97:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c9d:	89 c1                	mov    %eax,%ecx
  800c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ca2:	89 d0                	mov    %edx,%eax
  800ca4:	01 c0                	add    %eax,%eax
  800ca6:	01 d0                	add    %edx,%eax
  800ca8:	c1 e0 02             	shl    $0x2,%eax
  800cab:	01 d0                	add    %edx,%eax
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb2:	c1 e0 04             	shl    $0x4,%eax
  800cb5:	01 d0                	add    %edx,%eax
  800cb7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800cbc:	39 c1                	cmp    %eax,%ecx
  800cbe:	76 17                	jbe    800cd7 <_main+0xc9f>
  800cc0:	83 ec 04             	sub    $0x4,%esp
  800cc3:	68 50 2a 80 00       	push   $0x802a50
  800cc8:	68 bb 00 00 00       	push   $0xbb
  800ccd:	68 3c 2a 80 00       	push   $0x802a3c
  800cd2:	e8 ee 02 00 00       	call   800fc5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800cd7:	e8 f0 15 00 00       	call   8022cc <sys_pf_calculate_allocated_pages>
  800cdc:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800cdf:	83 f8 04             	cmp    $0x4,%eax
  800ce2:	74 17                	je     800cfb <_main+0xcc3>
  800ce4:	83 ec 04             	sub    $0x4,%esp
  800ce7:	68 b8 2a 80 00       	push   $0x802ab8
  800cec:	68 bc 00 00 00       	push   $0xbc
  800cf1:	68 3c 2a 80 00       	push   $0x802a3c
  800cf6:	e8 ca 02 00 00       	call   800fc5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cfb:	e8 2c 15 00 00       	call   80222c <sys_calculate_free_frames>
  800d00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800d03:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800d09:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d12:	89 d0                	mov    %edx,%eax
  800d14:	01 c0                	add    %eax,%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	01 c0                	add    %eax,%eax
  800d1a:	01 d0                	add    %edx,%eax
  800d1c:	01 c0                	add    %eax,%eax
  800d1e:	d1 e8                	shr    %eax
  800d20:	48                   	dec    %eax
  800d21:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800d27:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800d2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d30:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800d33:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	89 c2                	mov    %eax,%edx
  800d3d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d43:	01 c2                	add    %eax,%edx
  800d45:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800d49:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d4c:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d4f:	e8 d8 14 00 00       	call   80222c <sys_calculate_free_frames>
  800d54:	29 c3                	sub    %eax,%ebx
  800d56:	89 d8                	mov    %ebx,%eax
  800d58:	83 f8 02             	cmp    $0x2,%eax
  800d5b:	74 17                	je     800d74 <_main+0xd3c>
  800d5d:	83 ec 04             	sub    $0x4,%esp
  800d60:	68 e8 2a 80 00       	push   $0x802ae8
  800d65:	68 c3 00 00 00       	push   $0xc3
  800d6a:	68 3c 2a 80 00       	push   $0x802a3c
  800d6f:	e8 51 02 00 00       	call   800fc5 <_panic>
		found = 0;
  800d74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d82:	e9 a7 00 00 00       	jmp    800e2e <_main+0xdf6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d87:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800da8:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dbb:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800dc1:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcc:	39 c2                	cmp    %eax,%edx
  800dce:	75 03                	jne    800dd3 <_main+0xd9b>
				found++;
  800dd0:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800dd3:	a1 20 40 80 00       	mov    0x804020,%eax
  800dd8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800dde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800de1:	89 d0                	mov    %edx,%eax
  800de3:	01 c0                	add    %eax,%eax
  800de5:	01 d0                	add    %edx,%eax
  800de7:	c1 e0 03             	shl    $0x3,%eax
  800dea:	01 c8                	add    %ecx,%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800df4:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e07:	01 c0                	add    %eax,%eax
  800e09:	89 c1                	mov    %eax,%ecx
  800e0b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800e11:	01 c8                	add    %ecx,%eax
  800e13:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800e19:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e24:	39 c2                	cmp    %eax,%edx
  800e26:	75 03                	jne    800e2b <_main+0xdf3>
				found++;
  800e28:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e2b:	ff 45 ec             	incl   -0x14(%ebp)
  800e2e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e33:	8b 50 74             	mov    0x74(%eax),%edx
  800e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e39:	39 c2                	cmp    %eax,%edx
  800e3b:	0f 87 46 ff ff ff    	ja     800d87 <_main+0xd4f>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e41:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 2c 2b 80 00       	push   $0x802b2c
  800e4f:	68 cc 00 00 00       	push   $0xcc
  800e54:	68 3c 2a 80 00       	push   $0x802a3c
  800e59:	e8 67 01 00 00       	call   800fc5 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	68 4c 2b 80 00       	push   $0x802b4c
  800e66:	e8 0e 04 00 00       	call   801279 <cprintf>
  800e6b:	83 c4 10             	add    $0x10,%esp

	return;
  800e6e:	90                   	nop
}
  800e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e7c:	e8 8b 16 00 00       	call   80250c <sys_getenvindex>
  800e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e87:	89 d0                	mov    %edx,%eax
  800e89:	01 c0                	add    %eax,%eax
  800e8b:	01 d0                	add    %edx,%eax
  800e8d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800e94:	01 c8                	add    %ecx,%eax
  800e96:	c1 e0 02             	shl    $0x2,%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800ea2:	01 c8                	add    %ecx,%eax
  800ea4:	c1 e0 02             	shl    $0x2,%eax
  800ea7:	01 d0                	add    %edx,%eax
  800ea9:	c1 e0 02             	shl    $0x2,%eax
  800eac:	01 d0                	add    %edx,%eax
  800eae:	c1 e0 03             	shl    $0x3,%eax
  800eb1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800eb6:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ebb:	a1 20 40 80 00       	mov    0x804020,%eax
  800ec0:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	74 0f                	je     800ed9 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800eca:	a1 20 40 80 00       	mov    0x804020,%eax
  800ecf:	05 18 da 01 00       	add    $0x1da18,%eax
  800ed4:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ed9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800edd:	7e 0a                	jle    800ee9 <libmain+0x73>
		binaryname = argv[0];
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	8b 00                	mov    (%eax),%eax
  800ee4:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	ff 75 08             	pushl  0x8(%ebp)
  800ef2:	e8 41 f1 ff ff       	call   800038 <_main>
  800ef7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800efa:	e8 1a 14 00 00       	call   802319 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	68 a0 2b 80 00       	push   $0x802ba0
  800f07:	e8 6d 03 00 00       	call   801279 <cprintf>
  800f0c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800f0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800f14:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800f1a:	a1 20 40 80 00       	mov    0x804020,%eax
  800f1f:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800f25:	83 ec 04             	sub    $0x4,%esp
  800f28:	52                   	push   %edx
  800f29:	50                   	push   %eax
  800f2a:	68 c8 2b 80 00       	push   $0x802bc8
  800f2f:	e8 45 03 00 00       	call   801279 <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800f37:	a1 20 40 80 00       	mov    0x804020,%eax
  800f3c:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800f42:	a1 20 40 80 00       	mov    0x804020,%eax
  800f47:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800f4d:	a1 20 40 80 00       	mov    0x804020,%eax
  800f52:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800f58:	51                   	push   %ecx
  800f59:	52                   	push   %edx
  800f5a:	50                   	push   %eax
  800f5b:	68 f0 2b 80 00       	push   $0x802bf0
  800f60:	e8 14 03 00 00       	call   801279 <cprintf>
  800f65:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f68:	a1 20 40 80 00       	mov    0x804020,%eax
  800f6d:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	50                   	push   %eax
  800f77:	68 48 2c 80 00       	push   $0x802c48
  800f7c:	e8 f8 02 00 00       	call   801279 <cprintf>
  800f81:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	68 a0 2b 80 00       	push   $0x802ba0
  800f8c:	e8 e8 02 00 00       	call   801279 <cprintf>
  800f91:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f94:	e8 9a 13 00 00       	call   802333 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f99:	e8 19 00 00 00       	call   800fb7 <exit>
}
  800f9e:	90                   	nop
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	6a 00                	push   $0x0
  800fac:	e8 27 15 00 00       	call   8024d8 <sys_destroy_env>
  800fb1:	83 c4 10             	add    $0x10,%esp
}
  800fb4:	90                   	nop
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <exit>:

void
exit(void)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800fbd:	e8 7c 15 00 00       	call   80253e <sys_exit_env>
}
  800fc2:	90                   	nop
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800fcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800fce:	83 c0 04             	add    $0x4,%eax
  800fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800fd4:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	74 16                	je     800ff3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800fdd:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	50                   	push   %eax
  800fe6:	68 5c 2c 80 00       	push   $0x802c5c
  800feb:	e8 89 02 00 00       	call   801279 <cprintf>
  800ff0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ff3:	a1 00 40 80 00       	mov    0x804000,%eax
  800ff8:	ff 75 0c             	pushl  0xc(%ebp)
  800ffb:	ff 75 08             	pushl  0x8(%ebp)
  800ffe:	50                   	push   %eax
  800fff:	68 61 2c 80 00       	push   $0x802c61
  801004:	e8 70 02 00 00       	call   801279 <cprintf>
  801009:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	ff 75 f4             	pushl  -0xc(%ebp)
  801015:	50                   	push   %eax
  801016:	e8 f3 01 00 00       	call   80120e <vcprintf>
  80101b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	6a 00                	push   $0x0
  801023:	68 7d 2c 80 00       	push   $0x802c7d
  801028:	e8 e1 01 00 00       	call   80120e <vcprintf>
  80102d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801030:	e8 82 ff ff ff       	call   800fb7 <exit>

	// should not return here
	while (1) ;
  801035:	eb fe                	jmp    801035 <_panic+0x70>

00801037 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80103d:	a1 20 40 80 00       	mov    0x804020,%eax
  801042:	8b 50 74             	mov    0x74(%eax),%edx
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	39 c2                	cmp    %eax,%edx
  80104a:	74 14                	je     801060 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80104c:	83 ec 04             	sub    $0x4,%esp
  80104f:	68 80 2c 80 00       	push   $0x802c80
  801054:	6a 26                	push   $0x26
  801056:	68 cc 2c 80 00       	push   $0x802ccc
  80105b:	e8 65 ff ff ff       	call   800fc5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801067:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80106e:	e9 c2 00 00 00       	jmp    801135 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801076:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 00                	mov    (%eax),%eax
  801084:	85 c0                	test   %eax,%eax
  801086:	75 08                	jne    801090 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801088:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80108b:	e9 a2 00 00 00       	jmp    801132 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801090:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801097:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80109e:	eb 69                	jmp    801109 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8010a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8010a5:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8010ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	01 c0                	add    %eax,%eax
  8010b2:	01 d0                	add    %edx,%eax
  8010b4:	c1 e0 03             	shl    $0x3,%eax
  8010b7:	01 c8                	add    %ecx,%eax
  8010b9:	8a 40 04             	mov    0x4(%eax),%al
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 46                	jne    801106 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8010c5:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8010cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8010ce:	89 d0                	mov    %edx,%eax
  8010d0:	01 c0                	add    %eax,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	c1 e0 03             	shl    $0x3,%eax
  8010d7:	01 c8                	add    %ecx,%eax
  8010d9:	8b 00                	mov    (%eax),%eax
  8010db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	01 c8                	add    %ecx,%eax
  8010f7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010f9:	39 c2                	cmp    %eax,%edx
  8010fb:	75 09                	jne    801106 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801104:	eb 12                	jmp    801118 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801106:	ff 45 e8             	incl   -0x18(%ebp)
  801109:	a1 20 40 80 00       	mov    0x804020,%eax
  80110e:	8b 50 74             	mov    0x74(%eax),%edx
  801111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801114:	39 c2                	cmp    %eax,%edx
  801116:	77 88                	ja     8010a0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801118:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80111c:	75 14                	jne    801132 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	68 d8 2c 80 00       	push   $0x802cd8
  801126:	6a 3a                	push   $0x3a
  801128:	68 cc 2c 80 00       	push   $0x802ccc
  80112d:	e8 93 fe ff ff       	call   800fc5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801132:	ff 45 f0             	incl   -0x10(%ebp)
  801135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801138:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80113b:	0f 8c 32 ff ff ff    	jl     801073 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801141:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801148:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80114f:	eb 26                	jmp    801177 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801151:	a1 20 40 80 00       	mov    0x804020,%eax
  801156:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	01 c0                	add    %eax,%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	c1 e0 03             	shl    $0x3,%eax
  801168:	01 c8                	add    %ecx,%eax
  80116a:	8a 40 04             	mov    0x4(%eax),%al
  80116d:	3c 01                	cmp    $0x1,%al
  80116f:	75 03                	jne    801174 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801171:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801174:	ff 45 e0             	incl   -0x20(%ebp)
  801177:	a1 20 40 80 00       	mov    0x804020,%eax
  80117c:	8b 50 74             	mov    0x74(%eax),%edx
  80117f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801182:	39 c2                	cmp    %eax,%edx
  801184:	77 cb                	ja     801151 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80118c:	74 14                	je     8011a2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	68 2c 2d 80 00       	push   $0x802d2c
  801196:	6a 44                	push   $0x44
  801198:	68 cc 2c 80 00       	push   $0x802ccc
  80119d:	e8 23 fe ff ff       	call   800fc5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 d1                	mov    %dl,%cl
  8011bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011ce:	75 2c                	jne    8011fc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8011d0:	a0 24 40 80 00       	mov    0x804024,%al
  8011d5:	0f b6 c0             	movzbl %al,%eax
  8011d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011db:	8b 12                	mov    (%edx),%edx
  8011dd:	89 d1                	mov    %edx,%ecx
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	83 c2 08             	add    $0x8,%edx
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	50                   	push   %eax
  8011e9:	51                   	push   %ecx
  8011ea:	52                   	push   %edx
  8011eb:	e8 7b 0f 00 00       	call   80216b <sys_cputs>
  8011f0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	8b 40 04             	mov    0x4(%eax),%eax
  801202:	8d 50 01             	lea    0x1(%eax),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	89 50 04             	mov    %edx,0x4(%eax)
}
  80120b:	90                   	nop
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801217:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80121e:	00 00 00 
	b.cnt = 0;
  801221:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801228:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80122b:	ff 75 0c             	pushl  0xc(%ebp)
  80122e:	ff 75 08             	pushl  0x8(%ebp)
  801231:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	68 a5 11 80 00       	push   $0x8011a5
  80123d:	e8 11 02 00 00       	call   801453 <vprintfmt>
  801242:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801245:	a0 24 40 80 00       	mov    0x804024,%al
  80124a:	0f b6 c0             	movzbl %al,%eax
  80124d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	50                   	push   %eax
  801257:	52                   	push   %edx
  801258:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80125e:	83 c0 08             	add    $0x8,%eax
  801261:	50                   	push   %eax
  801262:	e8 04 0f 00 00       	call   80216b <sys_cputs>
  801267:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80126a:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  801271:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <cprintf>:

int cprintf(const char *fmt, ...) {
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80127f:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801286:	8d 45 0c             	lea    0xc(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 f4             	pushl  -0xc(%ebp)
  801295:	50                   	push   %eax
  801296:	e8 73 ff ff ff       	call   80120e <vcprintf>
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8012a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012ac:	e8 68 10 00 00       	call   802319 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c0:	50                   	push   %eax
  8012c1:	e8 48 ff ff ff       	call   80120e <vcprintf>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8012cc:	e8 62 10 00 00       	call   802333 <sys_enable_interrupt>
	return cnt;
  8012d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 14             	sub    $0x14,%esp
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012f4:	77 55                	ja     80134b <printnum+0x75>
  8012f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012f9:	72 05                	jb     801300 <printnum+0x2a>
  8012fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012fe:	77 4b                	ja     80134b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801300:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801303:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801306:	8b 45 18             	mov    0x18(%ebp),%eax
  801309:	ba 00 00 00 00       	mov    $0x0,%edx
  80130e:	52                   	push   %edx
  80130f:	50                   	push   %eax
  801310:	ff 75 f4             	pushl  -0xc(%ebp)
  801313:	ff 75 f0             	pushl  -0x10(%ebp)
  801316:	e8 85 14 00 00       	call   8027a0 <__udivdi3>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	83 ec 04             	sub    $0x4,%esp
  801321:	ff 75 20             	pushl  0x20(%ebp)
  801324:	53                   	push   %ebx
  801325:	ff 75 18             	pushl  0x18(%ebp)
  801328:	52                   	push   %edx
  801329:	50                   	push   %eax
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	ff 75 08             	pushl  0x8(%ebp)
  801330:	e8 a1 ff ff ff       	call   8012d6 <printnum>
  801335:	83 c4 20             	add    $0x20,%esp
  801338:	eb 1a                	jmp    801354 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	ff 75 20             	pushl  0x20(%ebp)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	ff d0                	call   *%eax
  801348:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80134b:	ff 4d 1c             	decl   0x1c(%ebp)
  80134e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801352:	7f e6                	jg     80133a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801354:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801357:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801362:	53                   	push   %ebx
  801363:	51                   	push   %ecx
  801364:	52                   	push   %edx
  801365:	50                   	push   %eax
  801366:	e8 45 15 00 00       	call   8028b0 <__umoddi3>
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	05 94 2f 80 00       	add    $0x802f94,%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	50                   	push   %eax
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	ff d0                	call   *%eax
  801384:	83 c4 10             	add    $0x10,%esp
}
  801387:	90                   	nop
  801388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801390:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801394:	7e 1c                	jle    8013b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8b 00                	mov    (%eax),%eax
  80139b:	8d 50 08             	lea    0x8(%eax),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	89 10                	mov    %edx,(%eax)
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	83 e8 08             	sub    $0x8,%eax
  8013ab:	8b 50 04             	mov    0x4(%eax),%edx
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	eb 40                	jmp    8013f2 <getuint+0x65>
	else if (lflag)
  8013b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b6:	74 1e                	je     8013d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	8d 50 04             	lea    0x4(%eax),%edx
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	89 10                	mov    %edx,(%eax)
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8b 00                	mov    (%eax),%eax
  8013ca:	83 e8 04             	sub    $0x4,%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d4:	eb 1c                	jmp    8013f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	8d 50 04             	lea    0x4(%eax),%edx
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	89 10                	mov    %edx,(%eax)
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	83 e8 04             	sub    $0x4,%eax
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013fb:	7e 1c                	jle    801419 <getint+0x25>
		return va_arg(*ap, long long);
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8b 00                	mov    (%eax),%eax
  801402:	8d 50 08             	lea    0x8(%eax),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	89 10                	mov    %edx,(%eax)
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	83 e8 08             	sub    $0x8,%eax
  801412:	8b 50 04             	mov    0x4(%eax),%edx
  801415:	8b 00                	mov    (%eax),%eax
  801417:	eb 38                	jmp    801451 <getint+0x5d>
	else if (lflag)
  801419:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80141d:	74 1a                	je     801439 <getint+0x45>
		return va_arg(*ap, long);
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8b 00                	mov    (%eax),%eax
  801424:	8d 50 04             	lea    0x4(%eax),%edx
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	89 10                	mov    %edx,(%eax)
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8b 00                	mov    (%eax),%eax
  801431:	83 e8 04             	sub    $0x4,%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	99                   	cltd   
  801437:	eb 18                	jmp    801451 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8b 00                	mov    (%eax),%eax
  80143e:	8d 50 04             	lea    0x4(%eax),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	89 10                	mov    %edx,(%eax)
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8b 00                	mov    (%eax),%eax
  80144b:	83 e8 04             	sub    $0x4,%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	99                   	cltd   
}
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80145b:	eb 17                	jmp    801474 <vprintfmt+0x21>
			if (ch == '\0')
  80145d:	85 db                	test   %ebx,%ebx
  80145f:	0f 84 af 03 00 00    	je     801814 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801465:	83 ec 08             	sub    $0x8,%esp
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	53                   	push   %ebx
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	ff d0                	call   *%eax
  801471:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 10             	mov    %edx,0x10(%ebp)
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f b6 d8             	movzbl %al,%ebx
  801482:	83 fb 25             	cmp    $0x25,%ebx
  801485:	75 d6                	jne    80145d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801487:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80148b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801492:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801499:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8014a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	0f b6 d8             	movzbl %al,%ebx
  8014b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8014b8:	83 f8 55             	cmp    $0x55,%eax
  8014bb:	0f 87 2b 03 00 00    	ja     8017ec <vprintfmt+0x399>
  8014c1:	8b 04 85 b8 2f 80 00 	mov    0x802fb8(,%eax,4),%eax
  8014c8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8014ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8014ce:	eb d7                	jmp    8014a7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8014d4:	eb d1                	jmp    8014a7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e0:	89 d0                	mov    %edx,%eax
  8014e2:	c1 e0 02             	shl    $0x2,%eax
  8014e5:	01 d0                	add    %edx,%eax
  8014e7:	01 c0                	add    %eax,%eax
  8014e9:	01 d8                	add    %ebx,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8014fc:	7e 3e                	jle    80153c <vprintfmt+0xe9>
  8014fe:	83 fb 39             	cmp    $0x39,%ebx
  801501:	7f 39                	jg     80153c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801503:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801506:	eb d5                	jmp    8014dd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	83 c0 04             	add    $0x4,%eax
  80150e:	89 45 14             	mov    %eax,0x14(%ebp)
  801511:	8b 45 14             	mov    0x14(%ebp),%eax
  801514:	83 e8 04             	sub    $0x4,%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80151c:	eb 1f                	jmp    80153d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80151e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801522:	79 83                	jns    8014a7 <vprintfmt+0x54>
				width = 0;
  801524:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80152b:	e9 77 ff ff ff       	jmp    8014a7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801530:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801537:	e9 6b ff ff ff       	jmp    8014a7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80153c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80153d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801541:	0f 89 60 ff ff ff    	jns    8014a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  801547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80154d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801554:	e9 4e ff ff ff       	jmp    8014a7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801559:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80155c:	e9 46 ff ff ff       	jmp    8014a7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	83 c0 04             	add    $0x4,%eax
  801567:	89 45 14             	mov    %eax,0x14(%ebp)
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	83 e8 04             	sub    $0x4,%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	ff 75 0c             	pushl  0xc(%ebp)
  801578:	50                   	push   %eax
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	ff d0                	call   *%eax
  80157e:	83 c4 10             	add    $0x10,%esp
			break;
  801581:	e9 89 02 00 00       	jmp    80180f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801586:	8b 45 14             	mov    0x14(%ebp),%eax
  801589:	83 c0 04             	add    $0x4,%eax
  80158c:	89 45 14             	mov    %eax,0x14(%ebp)
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	83 e8 04             	sub    $0x4,%eax
  801595:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801597:	85 db                	test   %ebx,%ebx
  801599:	79 02                	jns    80159d <vprintfmt+0x14a>
				err = -err;
  80159b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80159d:	83 fb 64             	cmp    $0x64,%ebx
  8015a0:	7f 0b                	jg     8015ad <vprintfmt+0x15a>
  8015a2:	8b 34 9d 00 2e 80 00 	mov    0x802e00(,%ebx,4),%esi
  8015a9:	85 f6                	test   %esi,%esi
  8015ab:	75 19                	jne    8015c6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8015ad:	53                   	push   %ebx
  8015ae:	68 a5 2f 80 00       	push   $0x802fa5
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	e8 5e 02 00 00       	call   80181c <printfmt>
  8015be:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8015c1:	e9 49 02 00 00       	jmp    80180f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8015c6:	56                   	push   %esi
  8015c7:	68 ae 2f 80 00       	push   $0x802fae
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 45 02 00 00       	call   80181c <printfmt>
  8015d7:	83 c4 10             	add    $0x10,%esp
			break;
  8015da:	e9 30 02 00 00       	jmp    80180f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015df:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e2:	83 c0 04             	add    $0x4,%eax
  8015e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8015e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015eb:	83 e8 04             	sub    $0x4,%eax
  8015ee:	8b 30                	mov    (%eax),%esi
  8015f0:	85 f6                	test   %esi,%esi
  8015f2:	75 05                	jne    8015f9 <vprintfmt+0x1a6>
				p = "(null)";
  8015f4:	be b1 2f 80 00       	mov    $0x802fb1,%esi
			if (width > 0 && padc != '-')
  8015f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015fd:	7e 6d                	jle    80166c <vprintfmt+0x219>
  8015ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801603:	74 67                	je     80166c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	50                   	push   %eax
  80160c:	56                   	push   %esi
  80160d:	e8 0c 03 00 00       	call   80191e <strnlen>
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801618:	eb 16                	jmp    801630 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80161a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	50                   	push   %eax
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	ff d0                	call   *%eax
  80162a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80162d:	ff 4d e4             	decl   -0x1c(%ebp)
  801630:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801634:	7f e4                	jg     80161a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801636:	eb 34                	jmp    80166c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801638:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80163c:	74 1c                	je     80165a <vprintfmt+0x207>
  80163e:	83 fb 1f             	cmp    $0x1f,%ebx
  801641:	7e 05                	jle    801648 <vprintfmt+0x1f5>
  801643:	83 fb 7e             	cmp    $0x7e,%ebx
  801646:	7e 12                	jle    80165a <vprintfmt+0x207>
					putch('?', putdat);
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	6a 3f                	push   $0x3f
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	ff d0                	call   *%eax
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	eb 0f                	jmp    801669 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	53                   	push   %ebx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	ff d0                	call   *%eax
  801666:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801669:	ff 4d e4             	decl   -0x1c(%ebp)
  80166c:	89 f0                	mov    %esi,%eax
  80166e:	8d 70 01             	lea    0x1(%eax),%esi
  801671:	8a 00                	mov    (%eax),%al
  801673:	0f be d8             	movsbl %al,%ebx
  801676:	85 db                	test   %ebx,%ebx
  801678:	74 24                	je     80169e <vprintfmt+0x24b>
  80167a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80167e:	78 b8                	js     801638 <vprintfmt+0x1e5>
  801680:	ff 4d e0             	decl   -0x20(%ebp)
  801683:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801687:	79 af                	jns    801638 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801689:	eb 13                	jmp    80169e <vprintfmt+0x24b>
				putch(' ', putdat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	6a 20                	push   $0x20
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	ff d0                	call   *%eax
  801698:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80169b:	ff 4d e4             	decl   -0x1c(%ebp)
  80169e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016a2:	7f e7                	jg     80168b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8016a4:	e9 66 01 00 00       	jmp    80180f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8016af:	8d 45 14             	lea    0x14(%ebp),%eax
  8016b2:	50                   	push   %eax
  8016b3:	e8 3c fd ff ff       	call   8013f4 <getint>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c7:	85 d2                	test   %edx,%edx
  8016c9:	79 23                	jns    8016ee <vprintfmt+0x29b>
				putch('-', putdat);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	6a 2d                	push   $0x2d
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	ff d0                	call   *%eax
  8016d8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	f7 d8                	neg    %eax
  8016e3:	83 d2 00             	adc    $0x0,%edx
  8016e6:	f7 da                	neg    %edx
  8016e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016f5:	e9 bc 00 00 00       	jmp    8017b6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801700:	8d 45 14             	lea    0x14(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	e8 84 fc ff ff       	call   80138d <getuint>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80170f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801712:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801719:	e9 98 00 00 00       	jmp    8017b6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	6a 58                	push   $0x58
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	ff d0                	call   *%eax
  80172b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80172e:	83 ec 08             	sub    $0x8,%esp
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	6a 58                	push   $0x58
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	ff d0                	call   *%eax
  80173b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	6a 58                	push   $0x58
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	ff d0                	call   *%eax
  80174b:	83 c4 10             	add    $0x10,%esp
			break;
  80174e:	e9 bc 00 00 00       	jmp    80180f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	6a 30                	push   $0x30
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	ff d0                	call   *%eax
  801760:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	6a 78                	push   $0x78
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	ff d0                	call   *%eax
  801770:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801773:	8b 45 14             	mov    0x14(%ebp),%eax
  801776:	83 c0 04             	add    $0x4,%eax
  801779:	89 45 14             	mov    %eax,0x14(%ebp)
  80177c:	8b 45 14             	mov    0x14(%ebp),%eax
  80177f:	83 e8 04             	sub    $0x4,%eax
  801782:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801787:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80178e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801795:	eb 1f                	jmp    8017b6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801797:	83 ec 08             	sub    $0x8,%esp
  80179a:	ff 75 e8             	pushl  -0x18(%ebp)
  80179d:	8d 45 14             	lea    0x14(%ebp),%eax
  8017a0:	50                   	push   %eax
  8017a1:	e8 e7 fb ff ff       	call   80138d <getuint>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8017af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	52                   	push   %edx
  8017c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c4:	50                   	push   %eax
  8017c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	ff 75 08             	pushl  0x8(%ebp)
  8017d1:	e8 00 fb ff ff       	call   8012d6 <printnum>
  8017d6:	83 c4 20             	add    $0x20,%esp
			break;
  8017d9:	eb 34                	jmp    80180f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	53                   	push   %ebx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	ff d0                	call   *%eax
  8017e7:	83 c4 10             	add    $0x10,%esp
			break;
  8017ea:	eb 23                	jmp    80180f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	6a 25                	push   $0x25
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	ff d0                	call   *%eax
  8017f9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017fc:	ff 4d 10             	decl   0x10(%ebp)
  8017ff:	eb 03                	jmp    801804 <vprintfmt+0x3b1>
  801801:	ff 4d 10             	decl   0x10(%ebp)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	48                   	dec    %eax
  801808:	8a 00                	mov    (%eax),%al
  80180a:	3c 25                	cmp    $0x25,%al
  80180c:	75 f3                	jne    801801 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80180e:	90                   	nop
		}
	}
  80180f:	e9 47 fc ff ff       	jmp    80145b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801814:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801815:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801822:	8d 45 10             	lea    0x10(%ebp),%eax
  801825:	83 c0 04             	add    $0x4,%eax
  801828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80182b:	8b 45 10             	mov    0x10(%ebp),%eax
  80182e:	ff 75 f4             	pushl  -0xc(%ebp)
  801831:	50                   	push   %eax
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	ff 75 08             	pushl  0x8(%ebp)
  801838:	e8 16 fc ff ff       	call   801453 <vprintfmt>
  80183d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	8b 40 08             	mov    0x8(%eax),%eax
  80184c:	8d 50 01             	lea    0x1(%eax),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801855:	8b 45 0c             	mov    0xc(%ebp),%eax
  801858:	8b 10                	mov    (%eax),%edx
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	8b 40 04             	mov    0x4(%eax),%eax
  801860:	39 c2                	cmp    %eax,%edx
  801862:	73 12                	jae    801876 <sprintputch+0x33>
		*b->buf++ = ch;
  801864:	8b 45 0c             	mov    0xc(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8d 48 01             	lea    0x1(%eax),%ecx
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	89 0a                	mov    %ecx,(%edx)
  801871:	8b 55 08             	mov    0x8(%ebp),%edx
  801874:	88 10                	mov    %dl,(%eax)
}
  801876:	90                   	nop
  801877:	5d                   	pop    %ebp
  801878:	c3                   	ret    

00801879 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	8d 50 ff             	lea    -0x1(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80189a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80189e:	74 06                	je     8018a6 <vsnprintf+0x2d>
  8018a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a4:	7f 07                	jg     8018ad <vsnprintf+0x34>
		return -E_INVAL;
  8018a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8018ab:	eb 20                	jmp    8018cd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018ad:	ff 75 14             	pushl  0x14(%ebp)
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018b6:	50                   	push   %eax
  8018b7:	68 43 18 80 00       	push   $0x801843
  8018bc:	e8 92 fb ff ff       	call   801453 <vprintfmt>
  8018c1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8018c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8018d8:	83 c0 04             	add    $0x4,%eax
  8018db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018de:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e4:	50                   	push   %eax
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 89 ff ff ff       	call   801879 <vsnprintf>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801908:	eb 06                	jmp    801910 <strlen+0x15>
		n++;
  80190a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80190d:	ff 45 08             	incl   0x8(%ebp)
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8a 00                	mov    (%eax),%al
  801915:	84 c0                	test   %al,%al
  801917:	75 f1                	jne    80190a <strlen+0xf>
		n++;
	return n;
  801919:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 09                	jmp    801936 <strnlen+0x18>
		n++;
  80192d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801930:	ff 45 08             	incl   0x8(%ebp)
  801933:	ff 4d 0c             	decl   0xc(%ebp)
  801936:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193a:	74 09                	je     801945 <strnlen+0x27>
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	84 c0                	test   %al,%al
  801943:	75 e8                	jne    80192d <strnlen+0xf>
		n++;
	return n;
  801945:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801956:	90                   	nop
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8d 50 01             	lea    0x1(%eax),%edx
  80195d:	89 55 08             	mov    %edx,0x8(%ebp)
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8d 4a 01             	lea    0x1(%edx),%ecx
  801966:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801969:	8a 12                	mov    (%edx),%dl
  80196b:	88 10                	mov    %dl,(%eax)
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	84 c0                	test   %al,%al
  801971:	75 e4                	jne    801957 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80198b:	eb 1f                	jmp    8019ac <strncpy+0x34>
		*dst++ = *src;
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8d 50 01             	lea    0x1(%eax),%edx
  801993:	89 55 08             	mov    %edx,0x8(%ebp)
  801996:	8b 55 0c             	mov    0xc(%ebp),%edx
  801999:	8a 12                	mov    (%edx),%dl
  80199b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a0:	8a 00                	mov    (%eax),%al
  8019a2:	84 c0                	test   %al,%al
  8019a4:	74 03                	je     8019a9 <strncpy+0x31>
			src++;
  8019a6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019a9:	ff 45 fc             	incl   -0x4(%ebp)
  8019ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019b2:	72 d9                	jb     80198d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c9:	74 30                	je     8019fb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019cb:	eb 16                	jmp    8019e3 <strlcpy+0x2a>
			*dst++ = *src++;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8d 50 01             	lea    0x1(%eax),%edx
  8019d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8019d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019dc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019df:	8a 12                	mov    (%edx),%dl
  8019e1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019e3:	ff 4d 10             	decl   0x10(%ebp)
  8019e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ea:	74 09                	je     8019f5 <strlcpy+0x3c>
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	84 c0                	test   %al,%al
  8019f3:	75 d8                	jne    8019cd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a01:	29 c2                	sub    %eax,%edx
  801a03:	89 d0                	mov    %edx,%eax
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801a0a:	eb 06                	jmp    801a12 <strcmp+0xb>
		p++, q++;
  801a0c:	ff 45 08             	incl   0x8(%ebp)
  801a0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	84 c0                	test   %al,%al
  801a19:	74 0e                	je     801a29 <strcmp+0x22>
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8a 10                	mov    (%eax),%dl
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	38 c2                	cmp    %al,%dl
  801a27:	74 e3                	je     801a0c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 d0             	movzbl %al,%edx
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	0f b6 c0             	movzbl %al,%eax
  801a39:	29 c2                	sub    %eax,%edx
  801a3b:	89 d0                	mov    %edx,%eax
}
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a42:	eb 09                	jmp    801a4d <strncmp+0xe>
		n--, p++, q++;
  801a44:	ff 4d 10             	decl   0x10(%ebp)
  801a47:	ff 45 08             	incl   0x8(%ebp)
  801a4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a51:	74 17                	je     801a6a <strncmp+0x2b>
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8a 00                	mov    (%eax),%al
  801a58:	84 c0                	test   %al,%al
  801a5a:	74 0e                	je     801a6a <strncmp+0x2b>
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8a 10                	mov    (%eax),%dl
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	8a 00                	mov    (%eax),%al
  801a66:	38 c2                	cmp    %al,%dl
  801a68:	74 da                	je     801a44 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a6e:	75 07                	jne    801a77 <strncmp+0x38>
		return 0;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	eb 14                	jmp    801a8b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d0             	movzbl %al,%edx
  801a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	0f b6 c0             	movzbl %al,%eax
  801a87:	29 c2                	sub    %eax,%edx
  801a89:	89 d0                	mov    %edx,%eax
}
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a99:	eb 12                	jmp    801aad <strchr+0x20>
		if (*s == c)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	8a 00                	mov    (%eax),%al
  801aa0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aa3:	75 05                	jne    801aaa <strchr+0x1d>
			return (char *) s;
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	eb 11                	jmp    801abb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801aaa:	ff 45 08             	incl   0x8(%ebp)
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	8a 00                	mov    (%eax),%al
  801ab2:	84 c0                	test   %al,%al
  801ab4:	75 e5                	jne    801a9b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ac9:	eb 0d                	jmp    801ad8 <strfind+0x1b>
		if (*s == c)
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	8a 00                	mov    (%eax),%al
  801ad0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ad3:	74 0e                	je     801ae3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ad5:	ff 45 08             	incl   0x8(%ebp)
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8a 00                	mov    (%eax),%al
  801add:	84 c0                	test   %al,%al
  801adf:	75 ea                	jne    801acb <strfind+0xe>
  801ae1:	eb 01                	jmp    801ae4 <strfind+0x27>
		if (*s == c)
			break;
  801ae3:	90                   	nop
	return (char *) s;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801af5:	8b 45 10             	mov    0x10(%ebp),%eax
  801af8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801afb:	eb 0e                	jmp    801b0b <memset+0x22>
		*p++ = c;
  801afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b00:	8d 50 01             	lea    0x1(%eax),%edx
  801b03:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801b0b:	ff 4d f8             	decl   -0x8(%ebp)
  801b0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b12:	79 e9                	jns    801afd <memset+0x14>
		*p++ = c;

	return v;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b2b:	eb 16                	jmp    801b43 <memcpy+0x2a>
		*d++ = *s++;
  801b2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b30:	8d 50 01             	lea    0x1(%eax),%edx
  801b33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b3f:	8a 12                	mov    (%edx),%dl
  801b41:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b43:	8b 45 10             	mov    0x10(%ebp),%eax
  801b46:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b49:	89 55 10             	mov    %edx,0x10(%ebp)
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	75 dd                	jne    801b2d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b6d:	73 50                	jae    801bbf <memmove+0x6a>
  801b6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b72:	8b 45 10             	mov    0x10(%ebp),%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b7a:	76 43                	jbe    801bbf <memmove+0x6a>
		s += n;
  801b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b82:	8b 45 10             	mov    0x10(%ebp),%eax
  801b85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b88:	eb 10                	jmp    801b9a <memmove+0x45>
			*--d = *--s;
  801b8a:	ff 4d f8             	decl   -0x8(%ebp)
  801b8d:	ff 4d fc             	decl   -0x4(%ebp)
  801b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b93:	8a 10                	mov    (%eax),%dl
  801b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ba0:	89 55 10             	mov    %edx,0x10(%ebp)
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	75 e3                	jne    801b8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ba7:	eb 23                	jmp    801bcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bac:	8d 50 01             	lea    0x1(%eax),%edx
  801baf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801bb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801bbb:	8a 12                	mov    (%edx),%dl
  801bbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bc5:	89 55 10             	mov    %edx,0x10(%ebp)
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	75 dd                	jne    801ba9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801be3:	eb 2a                	jmp    801c0f <memcmp+0x3e>
		if (*s1 != *s2)
  801be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be8:	8a 10                	mov    (%eax),%dl
  801bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bed:	8a 00                	mov    (%eax),%al
  801bef:	38 c2                	cmp    %al,%dl
  801bf1:	74 16                	je     801c09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf6:	8a 00                	mov    (%eax),%al
  801bf8:	0f b6 d0             	movzbl %al,%edx
  801bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bfe:	8a 00                	mov    (%eax),%al
  801c00:	0f b6 c0             	movzbl %al,%eax
  801c03:	29 c2                	sub    %eax,%edx
  801c05:	89 d0                	mov    %edx,%eax
  801c07:	eb 18                	jmp    801c21 <memcmp+0x50>
		s1++, s2++;
  801c09:	ff 45 fc             	incl   -0x4(%ebp)
  801c0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c15:	89 55 10             	mov    %edx,0x10(%ebp)
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 c9                	jne    801be5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c29:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c34:	eb 15                	jmp    801c4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	8a 00                	mov    (%eax),%al
  801c3b:	0f b6 d0             	movzbl %al,%edx
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	0f b6 c0             	movzbl %al,%eax
  801c44:	39 c2                	cmp    %eax,%edx
  801c46:	74 0d                	je     801c55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c48:	ff 45 08             	incl   0x8(%ebp)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c51:	72 e3                	jb     801c36 <memfind+0x13>
  801c53:	eb 01                	jmp    801c56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c55:	90                   	nop
	return (void *) s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c6f:	eb 03                	jmp    801c74 <strtol+0x19>
		s++;
  801c71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8a 00                	mov    (%eax),%al
  801c79:	3c 20                	cmp    $0x20,%al
  801c7b:	74 f4                	je     801c71 <strtol+0x16>
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	8a 00                	mov    (%eax),%al
  801c82:	3c 09                	cmp    $0x9,%al
  801c84:	74 eb                	je     801c71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	8a 00                	mov    (%eax),%al
  801c8b:	3c 2b                	cmp    $0x2b,%al
  801c8d:	75 05                	jne    801c94 <strtol+0x39>
		s++;
  801c8f:	ff 45 08             	incl   0x8(%ebp)
  801c92:	eb 13                	jmp    801ca7 <strtol+0x4c>
	else if (*s == '-')
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8a 00                	mov    (%eax),%al
  801c99:	3c 2d                	cmp    $0x2d,%al
  801c9b:	75 0a                	jne    801ca7 <strtol+0x4c>
		s++, neg = 1;
  801c9d:	ff 45 08             	incl   0x8(%ebp)
  801ca0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cab:	74 06                	je     801cb3 <strtol+0x58>
  801cad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801cb1:	75 20                	jne    801cd3 <strtol+0x78>
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	8a 00                	mov    (%eax),%al
  801cb8:	3c 30                	cmp    $0x30,%al
  801cba:	75 17                	jne    801cd3 <strtol+0x78>
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	40                   	inc    %eax
  801cc0:	8a 00                	mov    (%eax),%al
  801cc2:	3c 78                	cmp    $0x78,%al
  801cc4:	75 0d                	jne    801cd3 <strtol+0x78>
		s += 2, base = 16;
  801cc6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801cca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801cd1:	eb 28                	jmp    801cfb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cd7:	75 15                	jne    801cee <strtol+0x93>
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	8a 00                	mov    (%eax),%al
  801cde:	3c 30                	cmp    $0x30,%al
  801ce0:	75 0c                	jne    801cee <strtol+0x93>
		s++, base = 8;
  801ce2:	ff 45 08             	incl   0x8(%ebp)
  801ce5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cec:	eb 0d                	jmp    801cfb <strtol+0xa0>
	else if (base == 0)
  801cee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cf2:	75 07                	jne    801cfb <strtol+0xa0>
		base = 10;
  801cf4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8a 00                	mov    (%eax),%al
  801d00:	3c 2f                	cmp    $0x2f,%al
  801d02:	7e 19                	jle    801d1d <strtol+0xc2>
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	8a 00                	mov    (%eax),%al
  801d09:	3c 39                	cmp    $0x39,%al
  801d0b:	7f 10                	jg     801d1d <strtol+0xc2>
			dig = *s - '0';
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8a 00                	mov    (%eax),%al
  801d12:	0f be c0             	movsbl %al,%eax
  801d15:	83 e8 30             	sub    $0x30,%eax
  801d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1b:	eb 42                	jmp    801d5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8a 00                	mov    (%eax),%al
  801d22:	3c 60                	cmp    $0x60,%al
  801d24:	7e 19                	jle    801d3f <strtol+0xe4>
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	8a 00                	mov    (%eax),%al
  801d2b:	3c 7a                	cmp    $0x7a,%al
  801d2d:	7f 10                	jg     801d3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8a 00                	mov    (%eax),%al
  801d34:	0f be c0             	movsbl %al,%eax
  801d37:	83 e8 57             	sub    $0x57,%eax
  801d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3d:	eb 20                	jmp    801d5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	8a 00                	mov    (%eax),%al
  801d44:	3c 40                	cmp    $0x40,%al
  801d46:	7e 39                	jle    801d81 <strtol+0x126>
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	8a 00                	mov    (%eax),%al
  801d4d:	3c 5a                	cmp    $0x5a,%al
  801d4f:	7f 30                	jg     801d81 <strtol+0x126>
			dig = *s - 'A' + 10;
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	0f be c0             	movsbl %al,%eax
  801d59:	83 e8 37             	sub    $0x37,%eax
  801d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d65:	7d 19                	jge    801d80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d67:	ff 45 08             	incl   0x8(%ebp)
  801d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d7b:	e9 7b ff ff ff       	jmp    801cfb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d85:	74 08                	je     801d8f <strtol+0x134>
		*endptr = (char *) s;
  801d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d93:	74 07                	je     801d9c <strtol+0x141>
  801d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d98:	f7 d8                	neg    %eax
  801d9a:	eb 03                	jmp    801d9f <strtol+0x144>
  801d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <ltostr>:

void
ltostr(long value, char *str)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801da7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801dae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801db9:	79 13                	jns    801dce <ltostr+0x2d>
	{
		neg = 1;
  801dbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801dc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801dcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801dd6:	99                   	cltd   
  801dd7:	f7 f9                	idiv   %ecx
  801dd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	8d 50 01             	lea    0x1(%eax),%edx
  801de2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801de5:	89 c2                	mov    %eax,%edx
  801de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dea:	01 d0                	add    %edx,%eax
  801dec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801def:	83 c2 30             	add    $0x30,%edx
  801df2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801df4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dfc:	f7 e9                	imul   %ecx
  801dfe:	c1 fa 02             	sar    $0x2,%edx
  801e01:	89 c8                	mov    %ecx,%eax
  801e03:	c1 f8 1f             	sar    $0x1f,%eax
  801e06:	29 c2                	sub    %eax,%edx
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e10:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801e15:	f7 e9                	imul   %ecx
  801e17:	c1 fa 02             	sar    $0x2,%edx
  801e1a:	89 c8                	mov    %ecx,%eax
  801e1c:	c1 f8 1f             	sar    $0x1f,%eax
  801e1f:	29 c2                	sub    %eax,%edx
  801e21:	89 d0                	mov    %edx,%eax
  801e23:	c1 e0 02             	shl    $0x2,%eax
  801e26:	01 d0                	add    %edx,%eax
  801e28:	01 c0                	add    %eax,%eax
  801e2a:	29 c1                	sub    %eax,%ecx
  801e2c:	89 ca                	mov    %ecx,%edx
  801e2e:	85 d2                	test   %edx,%edx
  801e30:	75 9c                	jne    801dce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801e32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3c:	48                   	dec    %eax
  801e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e44:	74 3d                	je     801e83 <ltostr+0xe2>
		start = 1 ;
  801e46:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e4d:	eb 34                	jmp    801e83 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	01 d0                	add    %edx,%eax
  801e57:	8a 00                	mov    (%eax),%al
  801e59:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e62:	01 c2                	add    %eax,%edx
  801e64:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	01 c8                	add    %ecx,%eax
  801e6c:	8a 00                	mov    (%eax),%al
  801e6e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e76:	01 c2                	add    %eax,%edx
  801e78:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e7b:	88 02                	mov    %al,(%edx)
		start++ ;
  801e7d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e80:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e89:	7c c4                	jl     801e4f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e8b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e96:	90                   	nop
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	e8 54 fa ff ff       	call   8018fb <strlen>
  801ea7:	83 c4 04             	add    $0x4,%esp
  801eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ead:	ff 75 0c             	pushl  0xc(%ebp)
  801eb0:	e8 46 fa ff ff       	call   8018fb <strlen>
  801eb5:	83 c4 04             	add    $0x4,%esp
  801eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ec9:	eb 17                	jmp    801ee2 <strcconcat+0x49>
		final[s] = str1[s] ;
  801ecb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	01 c2                	add    %eax,%edx
  801ed3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	01 c8                	add    %ecx,%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801edf:	ff 45 fc             	incl   -0x4(%ebp)
  801ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ee8:	7c e1                	jl     801ecb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801eea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ef1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ef8:	eb 1f                	jmp    801f19 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801efd:	8d 50 01             	lea    0x1(%eax),%edx
  801f00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f03:	89 c2                	mov    %eax,%edx
  801f05:	8b 45 10             	mov    0x10(%ebp),%eax
  801f08:	01 c2                	add    %eax,%edx
  801f0a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	01 c8                	add    %ecx,%eax
  801f12:	8a 00                	mov    (%eax),%al
  801f14:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801f16:	ff 45 f8             	incl   -0x8(%ebp)
  801f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f1f:	7c d9                	jl     801efa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801f21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f24:	8b 45 10             	mov    0x10(%ebp),%eax
  801f27:	01 d0                	add    %edx,%eax
  801f29:	c6 00 00             	movb   $0x0,(%eax)
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801f32:	8b 45 14             	mov    0x14(%ebp),%eax
  801f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f47:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f52:	eb 0c                	jmp    801f60 <strsplit+0x31>
			*string++ = 0;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8d 50 01             	lea    0x1(%eax),%edx
  801f5a:	89 55 08             	mov    %edx,0x8(%ebp)
  801f5d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8a 00                	mov    (%eax),%al
  801f65:	84 c0                	test   %al,%al
  801f67:	74 18                	je     801f81 <strsplit+0x52>
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	8a 00                	mov    (%eax),%al
  801f6e:	0f be c0             	movsbl %al,%eax
  801f71:	50                   	push   %eax
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	e8 13 fb ff ff       	call   801a8d <strchr>
  801f7a:	83 c4 08             	add    $0x8,%esp
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	75 d3                	jne    801f54 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	8a 00                	mov    (%eax),%al
  801f86:	84 c0                	test   %al,%al
  801f88:	74 5a                	je     801fe4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	83 f8 0f             	cmp    $0xf,%eax
  801f92:	75 07                	jne    801f9b <strsplit+0x6c>
		{
			return 0;
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	eb 66                	jmp    802001 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	8d 48 01             	lea    0x1(%eax),%ecx
  801fa3:	8b 55 14             	mov    0x14(%ebp),%edx
  801fa6:	89 0a                	mov    %ecx,(%edx)
  801fa8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801faf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb2:	01 c2                	add    %eax,%edx
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801fb9:	eb 03                	jmp    801fbe <strsplit+0x8f>
			string++;
  801fbb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	84 c0                	test   %al,%al
  801fc5:	74 8b                	je     801f52 <strsplit+0x23>
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	8a 00                	mov    (%eax),%al
  801fcc:	0f be c0             	movsbl %al,%eax
  801fcf:	50                   	push   %eax
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	e8 b5 fa ff ff       	call   801a8d <strchr>
  801fd8:	83 c4 08             	add    $0x8,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 dc                	je     801fbb <strsplit+0x8c>
			string++;
	}
  801fdf:	e9 6e ff ff ff       	jmp    801f52 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fe4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ffc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	68 10 31 80 00       	push   $0x803110
  802011:	6a 0e                	push   $0xe
  802013:	68 4a 31 80 00       	push   $0x80314a
  802018:	e8 a8 ef ff ff       	call   800fc5 <_panic>

0080201d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  802023:	a1 04 40 80 00       	mov    0x804004,%eax
  802028:	85 c0                	test   %eax,%eax
  80202a:	74 0f                	je     80203b <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80202c:	e8 d2 ff ff ff       	call   802003 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802031:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802038:	00 00 00 
	}
	if (size == 0) return NULL ;
  80203b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203f:	75 07                	jne    802048 <malloc+0x2b>
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	eb 14                	jmp    80205c <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 58 31 80 00       	push   $0x803158
  802050:	6a 2e                	push   $0x2e
  802052:	68 4a 31 80 00       	push   $0x80314a
  802057:	e8 69 ef ff ff       	call   800fc5 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	68 80 31 80 00       	push   $0x803180
  80206c:	6a 49                	push   $0x49
  80206e:	68 4a 31 80 00       	push   $0x80314a
  802073:	e8 4d ef ff ff       	call   800fc5 <_panic>

00802078 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 18             	sub    $0x18,%esp
  80207e:	8b 45 10             	mov    0x10(%ebp),%eax
  802081:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	68 a4 31 80 00       	push   $0x8031a4
  80208c:	6a 57                	push   $0x57
  80208e:	68 4a 31 80 00       	push   $0x80314a
  802093:	e8 2d ef ff ff       	call   800fc5 <_panic>

00802098 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	68 cc 31 80 00       	push   $0x8031cc
  8020a6:	6a 60                	push   $0x60
  8020a8:	68 4a 31 80 00       	push   $0x80314a
  8020ad:	e8 13 ef ff ff       	call   800fc5 <_panic>

008020b2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	68 f0 31 80 00       	push   $0x8031f0
  8020c0:	6a 7c                	push   $0x7c
  8020c2:	68 4a 31 80 00       	push   $0x80314a
  8020c7:	e8 f9 ee ff ff       	call   800fc5 <_panic>

008020cc <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 18 32 80 00       	push   $0x803218
  8020da:	68 86 00 00 00       	push   $0x86
  8020df:	68 4a 31 80 00       	push   $0x80314a
  8020e4:	e8 dc ee ff ff       	call   800fc5 <_panic>

008020e9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 3c 32 80 00       	push   $0x80323c
  8020f7:	68 91 00 00 00       	push   $0x91
  8020fc:	68 4a 31 80 00       	push   $0x80314a
  802101:	e8 bf ee ff ff       	call   800fc5 <_panic>

00802106 <shrink>:

}
void shrink(uint32 newSize)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 3c 32 80 00       	push   $0x80323c
  802114:	68 96 00 00 00       	push   $0x96
  802119:	68 4a 31 80 00       	push   $0x80314a
  80211e:	e8 a2 ee ff ff       	call   800fc5 <_panic>

00802123 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802129:	83 ec 04             	sub    $0x4,%esp
  80212c:	68 3c 32 80 00       	push   $0x80323c
  802131:	68 9b 00 00 00       	push   $0x9b
  802136:	68 4a 31 80 00       	push   $0x80314a
  80213b:	e8 85 ee ff ff       	call   800fc5 <_panic>

00802140 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	57                   	push   %edi
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802152:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802155:	8b 7d 18             	mov    0x18(%ebp),%edi
  802158:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80215b:	cd 30                	int    $0x30
  80215d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802163:	83 c4 10             	add    $0x10,%esp
  802166:	5b                   	pop    %ebx
  802167:	5e                   	pop    %esi
  802168:	5f                   	pop    %edi
  802169:	5d                   	pop    %ebp
  80216a:	c3                   	ret    

0080216b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	8b 45 10             	mov    0x10(%ebp),%eax
  802174:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802177:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	52                   	push   %edx
  802183:	ff 75 0c             	pushl  0xc(%ebp)
  802186:	50                   	push   %eax
  802187:	6a 00                	push   $0x0
  802189:	e8 b2 ff ff ff       	call   802140 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	90                   	nop
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_cgetc>:

int
sys_cgetc(void)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 01                	push   $0x1
  8021a3:	e8 98 ff ff ff       	call   802140 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	52                   	push   %edx
  8021bd:	50                   	push   %eax
  8021be:	6a 05                	push   $0x5
  8021c0:	e8 7b ff ff ff       	call   802140 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	56                   	push   %esi
  8021ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8021d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	51                   	push   %ecx
  8021e1:	52                   	push   %edx
  8021e2:	50                   	push   %eax
  8021e3:	6a 06                	push   $0x6
  8021e5:	e8 56 ff ff ff       	call   802140 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5d                   	pop    %ebp
  8021f3:	c3                   	ret    

008021f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	6a 07                	push   $0x7
  802207:	e8 34 ff ff ff       	call   802140 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	ff 75 0c             	pushl  0xc(%ebp)
  80221d:	ff 75 08             	pushl  0x8(%ebp)
  802220:	6a 08                	push   $0x8
  802222:	e8 19 ff ff ff       	call   802140 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 09                	push   $0x9
  80223b:	e8 00 ff ff ff       	call   802140 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 0a                	push   $0xa
  802254:	e8 e7 fe ff ff       	call   802140 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 0b                	push   $0xb
  80226d:	e8 ce fe ff ff       	call   802140 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	6a 0f                	push   $0xf
  802288:	e8 b3 fe ff ff       	call   802140 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	ff 75 08             	pushl  0x8(%ebp)
  8022a2:	6a 10                	push   $0x10
  8022a4:	e8 97 fe ff ff       	call   802140 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ac:	90                   	nop
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 10             	pushl  0x10(%ebp)
  8022b9:	ff 75 0c             	pushl  0xc(%ebp)
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	6a 11                	push   $0x11
  8022c1:	e8 7a fe ff ff       	call   802140 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c9:	90                   	nop
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 0c                	push   $0xc
  8022db:	e8 60 fe ff ff       	call   802140 <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	ff 75 08             	pushl  0x8(%ebp)
  8022f3:	6a 0d                	push   $0xd
  8022f5:	e8 46 fe ff ff       	call   802140 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 0e                	push   $0xe
  80230e:	e8 2d fe ff ff       	call   802140 <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 13                	push   $0x13
  802328:	e8 13 fe ff ff       	call   802140 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	90                   	nop
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 14                	push   $0x14
  802342:	e8 f9 fd ff ff       	call   802140 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	90                   	nop
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_cputc>:


void
sys_cputc(const char c)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802359:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	50                   	push   %eax
  802366:	6a 15                	push   $0x15
  802368:	e8 d3 fd ff ff       	call   802140 <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	90                   	nop
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 16                	push   $0x16
  802382:	e8 b9 fd ff ff       	call   802140 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
}
  80238a:	90                   	nop
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	50                   	push   %eax
  80239d:	6a 17                	push   $0x17
  80239f:	e8 9c fd ff ff       	call   802140 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	6a 1a                	push   $0x1a
  8023bc:	e8 7f fd ff ff       	call   802140 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	52                   	push   %edx
  8023d6:	50                   	push   %eax
  8023d7:	6a 18                	push   $0x18
  8023d9:	e8 62 fd ff ff       	call   802140 <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
}
  8023e1:	90                   	nop
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	52                   	push   %edx
  8023f4:	50                   	push   %eax
  8023f5:	6a 19                	push   $0x19
  8023f7:	e8 44 fd ff ff       	call   802140 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	90                   	nop
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 04             	sub    $0x4,%esp
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80240e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802411:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	6a 00                	push   $0x0
  80241a:	51                   	push   %ecx
  80241b:	52                   	push   %edx
  80241c:	ff 75 0c             	pushl  0xc(%ebp)
  80241f:	50                   	push   %eax
  802420:	6a 1b                	push   $0x1b
  802422:	e8 19 fd ff ff       	call   802140 <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80242f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	52                   	push   %edx
  80243c:	50                   	push   %eax
  80243d:	6a 1c                	push   $0x1c
  80243f:	e8 fc fc ff ff       	call   802140 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80244c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	51                   	push   %ecx
  80245a:	52                   	push   %edx
  80245b:	50                   	push   %eax
  80245c:	6a 1d                	push   $0x1d
  80245e:	e8 dd fc ff ff       	call   802140 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	52                   	push   %edx
  802478:	50                   	push   %eax
  802479:	6a 1e                	push   $0x1e
  80247b:	e8 c0 fc ff ff       	call   802140 <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 1f                	push   $0x1f
  802494:	e8 a7 fc ff ff       	call   802140 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	6a 00                	push   $0x0
  8024a6:	ff 75 14             	pushl  0x14(%ebp)
  8024a9:	ff 75 10             	pushl  0x10(%ebp)
  8024ac:	ff 75 0c             	pushl  0xc(%ebp)
  8024af:	50                   	push   %eax
  8024b0:	6a 20                	push   $0x20
  8024b2:	e8 89 fc ff ff       	call   802140 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	50                   	push   %eax
  8024cb:	6a 21                	push   $0x21
  8024cd:	e8 6e fc ff ff       	call   802140 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	90                   	nop
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	50                   	push   %eax
  8024e7:	6a 22                	push   $0x22
  8024e9:	e8 52 fc ff ff       	call   802140 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 02                	push   $0x2
  802502:	e8 39 fc ff ff       	call   802140 <syscall>
  802507:	83 c4 18             	add    $0x18,%esp
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 03                	push   $0x3
  80251b:	e8 20 fc ff ff       	call   802140 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 04                	push   $0x4
  802534:	e8 07 fc ff ff       	call   802140 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_exit_env>:


void sys_exit_env(void)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 23                	push   $0x23
  80254d:	e8 ee fb ff ff       	call   802140 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	90                   	nop
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80255e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802561:	8d 50 04             	lea    0x4(%eax),%edx
  802564:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	52                   	push   %edx
  80256e:	50                   	push   %eax
  80256f:	6a 24                	push   $0x24
  802571:	e8 ca fb ff ff       	call   802140 <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
	return result;
  802579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80257c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80257f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802582:	89 01                	mov    %eax,(%ecx)
  802584:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	c9                   	leave  
  80258b:	c2 04 00             	ret    $0x4

0080258e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	ff 75 10             	pushl  0x10(%ebp)
  802598:	ff 75 0c             	pushl  0xc(%ebp)
  80259b:	ff 75 08             	pushl  0x8(%ebp)
  80259e:	6a 12                	push   $0x12
  8025a0:	e8 9b fb ff ff       	call   802140 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a8:	90                   	nop
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_rcr2>:
uint32 sys_rcr2()
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 25                	push   $0x25
  8025ba:	e8 81 fb ff ff       	call   802140 <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025d0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	50                   	push   %eax
  8025dd:	6a 26                	push   $0x26
  8025df:	e8 5c fb ff ff       	call   802140 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e7:	90                   	nop
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <rsttst>:
void rsttst()
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 28                	push   $0x28
  8025f9:	e8 42 fb ff ff       	call   802140 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802601:	90                   	nop
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	83 ec 04             	sub    $0x4,%esp
  80260a:	8b 45 14             	mov    0x14(%ebp),%eax
  80260d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802610:	8b 55 18             	mov    0x18(%ebp),%edx
  802613:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802617:	52                   	push   %edx
  802618:	50                   	push   %eax
  802619:	ff 75 10             	pushl  0x10(%ebp)
  80261c:	ff 75 0c             	pushl  0xc(%ebp)
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	6a 27                	push   $0x27
  802624:	e8 17 fb ff ff       	call   802140 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
	return ;
  80262c:	90                   	nop
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <chktst>:
void chktst(uint32 n)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	ff 75 08             	pushl  0x8(%ebp)
  80263d:	6a 29                	push   $0x29
  80263f:	e8 fc fa ff ff       	call   802140 <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
	return ;
  802647:	90                   	nop
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <inctst>:

void inctst()
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 2a                	push   $0x2a
  802659:	e8 e2 fa ff ff       	call   802140 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
	return ;
  802661:	90                   	nop
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <gettst>:
uint32 gettst()
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 2b                	push   $0x2b
  802673:	e8 c8 fa ff ff       	call   802140 <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 2c                	push   $0x2c
  80268f:	e8 ac fa ff ff       	call   802140 <syscall>
  802694:	83 c4 18             	add    $0x18,%esp
  802697:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80269a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80269e:	75 07                	jne    8026a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a5:	eb 05                	jmp    8026ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 2c                	push   $0x2c
  8026c0:	e8 7b fa ff ff       	call   802140 <syscall>
  8026c5:	83 c4 18             	add    $0x18,%esp
  8026c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026cb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026cf:	75 07                	jne    8026d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d6:	eb 05                	jmp    8026dd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 2c                	push   $0x2c
  8026f1:	e8 4a fa ff ff       	call   802140 <syscall>
  8026f6:	83 c4 18             	add    $0x18,%esp
  8026f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026fc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802700:	75 07                	jne    802709 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	eb 05                	jmp    80270e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 2c                	push   $0x2c
  802722:	e8 19 fa ff ff       	call   802140 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
  80272a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80272d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802731:	75 07                	jne    80273a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802733:	b8 01 00 00 00       	mov    $0x1,%eax
  802738:	eb 05                	jmp    80273f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	ff 75 08             	pushl  0x8(%ebp)
  80274f:	6a 2d                	push   $0x2d
  802751:	e8 ea f9 ff ff       	call   802140 <syscall>
  802756:	83 c4 18             	add    $0x18,%esp
	return ;
  802759:	90                   	nop
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802760:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802763:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802766:	8b 55 0c             	mov    0xc(%ebp),%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	6a 00                	push   $0x0
  80276e:	53                   	push   %ebx
  80276f:	51                   	push   %ecx
  802770:	52                   	push   %edx
  802771:	50                   	push   %eax
  802772:	6a 2e                	push   $0x2e
  802774:	e8 c7 f9 ff ff       	call   802140 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
}
  80277c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802784:	8b 55 0c             	mov    0xc(%ebp),%edx
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	52                   	push   %edx
  802791:	50                   	push   %eax
  802792:	6a 2f                	push   $0x2f
  802794:	e8 a7 f9 ff ff       	call   802140 <syscall>
  802799:	83 c4 18             	add    $0x18,%esp
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    
  80279e:	66 90                	xchg   %ax,%ax

008027a0 <__udivdi3>:
  8027a0:	55                   	push   %ebp
  8027a1:	57                   	push   %edi
  8027a2:	56                   	push   %esi
  8027a3:	53                   	push   %ebx
  8027a4:	83 ec 1c             	sub    $0x1c,%esp
  8027a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8027ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8027af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027b7:	89 ca                	mov    %ecx,%edx
  8027b9:	89 f8                	mov    %edi,%eax
  8027bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8027bf:	85 f6                	test   %esi,%esi
  8027c1:	75 2d                	jne    8027f0 <__udivdi3+0x50>
  8027c3:	39 cf                	cmp    %ecx,%edi
  8027c5:	77 65                	ja     80282c <__udivdi3+0x8c>
  8027c7:	89 fd                	mov    %edi,%ebp
  8027c9:	85 ff                	test   %edi,%edi
  8027cb:	75 0b                	jne    8027d8 <__udivdi3+0x38>
  8027cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d2:	31 d2                	xor    %edx,%edx
  8027d4:	f7 f7                	div    %edi
  8027d6:	89 c5                	mov    %eax,%ebp
  8027d8:	31 d2                	xor    %edx,%edx
  8027da:	89 c8                	mov    %ecx,%eax
  8027dc:	f7 f5                	div    %ebp
  8027de:	89 c1                	mov    %eax,%ecx
  8027e0:	89 d8                	mov    %ebx,%eax
  8027e2:	f7 f5                	div    %ebp
  8027e4:	89 cf                	mov    %ecx,%edi
  8027e6:	89 fa                	mov    %edi,%edx
  8027e8:	83 c4 1c             	add    $0x1c,%esp
  8027eb:	5b                   	pop    %ebx
  8027ec:	5e                   	pop    %esi
  8027ed:	5f                   	pop    %edi
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    
  8027f0:	39 ce                	cmp    %ecx,%esi
  8027f2:	77 28                	ja     80281c <__udivdi3+0x7c>
  8027f4:	0f bd fe             	bsr    %esi,%edi
  8027f7:	83 f7 1f             	xor    $0x1f,%edi
  8027fa:	75 40                	jne    80283c <__udivdi3+0x9c>
  8027fc:	39 ce                	cmp    %ecx,%esi
  8027fe:	72 0a                	jb     80280a <__udivdi3+0x6a>
  802800:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802804:	0f 87 9e 00 00 00    	ja     8028a8 <__udivdi3+0x108>
  80280a:	b8 01 00 00 00       	mov    $0x1,%eax
  80280f:	89 fa                	mov    %edi,%edx
  802811:	83 c4 1c             	add    $0x1c,%esp
  802814:	5b                   	pop    %ebx
  802815:	5e                   	pop    %esi
  802816:	5f                   	pop    %edi
  802817:	5d                   	pop    %ebp
  802818:	c3                   	ret    
  802819:	8d 76 00             	lea    0x0(%esi),%esi
  80281c:	31 ff                	xor    %edi,%edi
  80281e:	31 c0                	xor    %eax,%eax
  802820:	89 fa                	mov    %edi,%edx
  802822:	83 c4 1c             	add    $0x1c,%esp
  802825:	5b                   	pop    %ebx
  802826:	5e                   	pop    %esi
  802827:	5f                   	pop    %edi
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	89 d8                	mov    %ebx,%eax
  80282e:	f7 f7                	div    %edi
  802830:	31 ff                	xor    %edi,%edi
  802832:	89 fa                	mov    %edi,%edx
  802834:	83 c4 1c             	add    $0x1c,%esp
  802837:	5b                   	pop    %ebx
  802838:	5e                   	pop    %esi
  802839:	5f                   	pop    %edi
  80283a:	5d                   	pop    %ebp
  80283b:	c3                   	ret    
  80283c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802841:	89 eb                	mov    %ebp,%ebx
  802843:	29 fb                	sub    %edi,%ebx
  802845:	89 f9                	mov    %edi,%ecx
  802847:	d3 e6                	shl    %cl,%esi
  802849:	89 c5                	mov    %eax,%ebp
  80284b:	88 d9                	mov    %bl,%cl
  80284d:	d3 ed                	shr    %cl,%ebp
  80284f:	89 e9                	mov    %ebp,%ecx
  802851:	09 f1                	or     %esi,%ecx
  802853:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802857:	89 f9                	mov    %edi,%ecx
  802859:	d3 e0                	shl    %cl,%eax
  80285b:	89 c5                	mov    %eax,%ebp
  80285d:	89 d6                	mov    %edx,%esi
  80285f:	88 d9                	mov    %bl,%cl
  802861:	d3 ee                	shr    %cl,%esi
  802863:	89 f9                	mov    %edi,%ecx
  802865:	d3 e2                	shl    %cl,%edx
  802867:	8b 44 24 08          	mov    0x8(%esp),%eax
  80286b:	88 d9                	mov    %bl,%cl
  80286d:	d3 e8                	shr    %cl,%eax
  80286f:	09 c2                	or     %eax,%edx
  802871:	89 d0                	mov    %edx,%eax
  802873:	89 f2                	mov    %esi,%edx
  802875:	f7 74 24 0c          	divl   0xc(%esp)
  802879:	89 d6                	mov    %edx,%esi
  80287b:	89 c3                	mov    %eax,%ebx
  80287d:	f7 e5                	mul    %ebp
  80287f:	39 d6                	cmp    %edx,%esi
  802881:	72 19                	jb     80289c <__udivdi3+0xfc>
  802883:	74 0b                	je     802890 <__udivdi3+0xf0>
  802885:	89 d8                	mov    %ebx,%eax
  802887:	31 ff                	xor    %edi,%edi
  802889:	e9 58 ff ff ff       	jmp    8027e6 <__udivdi3+0x46>
  80288e:	66 90                	xchg   %ax,%ax
  802890:	8b 54 24 08          	mov    0x8(%esp),%edx
  802894:	89 f9                	mov    %edi,%ecx
  802896:	d3 e2                	shl    %cl,%edx
  802898:	39 c2                	cmp    %eax,%edx
  80289a:	73 e9                	jae    802885 <__udivdi3+0xe5>
  80289c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80289f:	31 ff                	xor    %edi,%edi
  8028a1:	e9 40 ff ff ff       	jmp    8027e6 <__udivdi3+0x46>
  8028a6:	66 90                	xchg   %ax,%ax
  8028a8:	31 c0                	xor    %eax,%eax
  8028aa:	e9 37 ff ff ff       	jmp    8027e6 <__udivdi3+0x46>
  8028af:	90                   	nop

008028b0 <__umoddi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 1c             	sub    $0x1c,%esp
  8028b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8028bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028cf:	89 f3                	mov    %esi,%ebx
  8028d1:	89 fa                	mov    %edi,%edx
  8028d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028d7:	89 34 24             	mov    %esi,(%esp)
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	75 1a                	jne    8028f8 <__umoddi3+0x48>
  8028de:	39 f7                	cmp    %esi,%edi
  8028e0:	0f 86 a2 00 00 00    	jbe    802988 <__umoddi3+0xd8>
  8028e6:	89 c8                	mov    %ecx,%eax
  8028e8:	89 f2                	mov    %esi,%edx
  8028ea:	f7 f7                	div    %edi
  8028ec:	89 d0                	mov    %edx,%eax
  8028ee:	31 d2                	xor    %edx,%edx
  8028f0:	83 c4 1c             	add    $0x1c,%esp
  8028f3:	5b                   	pop    %ebx
  8028f4:	5e                   	pop    %esi
  8028f5:	5f                   	pop    %edi
  8028f6:	5d                   	pop    %ebp
  8028f7:	c3                   	ret    
  8028f8:	39 f0                	cmp    %esi,%eax
  8028fa:	0f 87 ac 00 00 00    	ja     8029ac <__umoddi3+0xfc>
  802900:	0f bd e8             	bsr    %eax,%ebp
  802903:	83 f5 1f             	xor    $0x1f,%ebp
  802906:	0f 84 ac 00 00 00    	je     8029b8 <__umoddi3+0x108>
  80290c:	bf 20 00 00 00       	mov    $0x20,%edi
  802911:	29 ef                	sub    %ebp,%edi
  802913:	89 fe                	mov    %edi,%esi
  802915:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	d3 e0                	shl    %cl,%eax
  80291d:	89 d7                	mov    %edx,%edi
  80291f:	89 f1                	mov    %esi,%ecx
  802921:	d3 ef                	shr    %cl,%edi
  802923:	09 c7                	or     %eax,%edi
  802925:	89 e9                	mov    %ebp,%ecx
  802927:	d3 e2                	shl    %cl,%edx
  802929:	89 14 24             	mov    %edx,(%esp)
  80292c:	89 d8                	mov    %ebx,%eax
  80292e:	d3 e0                	shl    %cl,%eax
  802930:	89 c2                	mov    %eax,%edx
  802932:	8b 44 24 08          	mov    0x8(%esp),%eax
  802936:	d3 e0                	shl    %cl,%eax
  802938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80293c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802940:	89 f1                	mov    %esi,%ecx
  802942:	d3 e8                	shr    %cl,%eax
  802944:	09 d0                	or     %edx,%eax
  802946:	d3 eb                	shr    %cl,%ebx
  802948:	89 da                	mov    %ebx,%edx
  80294a:	f7 f7                	div    %edi
  80294c:	89 d3                	mov    %edx,%ebx
  80294e:	f7 24 24             	mull   (%esp)
  802951:	89 c6                	mov    %eax,%esi
  802953:	89 d1                	mov    %edx,%ecx
  802955:	39 d3                	cmp    %edx,%ebx
  802957:	0f 82 87 00 00 00    	jb     8029e4 <__umoddi3+0x134>
  80295d:	0f 84 91 00 00 00    	je     8029f4 <__umoddi3+0x144>
  802963:	8b 54 24 04          	mov    0x4(%esp),%edx
  802967:	29 f2                	sub    %esi,%edx
  802969:	19 cb                	sbb    %ecx,%ebx
  80296b:	89 d8                	mov    %ebx,%eax
  80296d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802971:	d3 e0                	shl    %cl,%eax
  802973:	89 e9                	mov    %ebp,%ecx
  802975:	d3 ea                	shr    %cl,%edx
  802977:	09 d0                	or     %edx,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	d3 eb                	shr    %cl,%ebx
  80297d:	89 da                	mov    %ebx,%edx
  80297f:	83 c4 1c             	add    $0x1c,%esp
  802982:	5b                   	pop    %ebx
  802983:	5e                   	pop    %esi
  802984:	5f                   	pop    %edi
  802985:	5d                   	pop    %ebp
  802986:	c3                   	ret    
  802987:	90                   	nop
  802988:	89 fd                	mov    %edi,%ebp
  80298a:	85 ff                	test   %edi,%edi
  80298c:	75 0b                	jne    802999 <__umoddi3+0xe9>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	31 d2                	xor    %edx,%edx
  802995:	f7 f7                	div    %edi
  802997:	89 c5                	mov    %eax,%ebp
  802999:	89 f0                	mov    %esi,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	f7 f5                	div    %ebp
  80299f:	89 c8                	mov    %ecx,%eax
  8029a1:	f7 f5                	div    %ebp
  8029a3:	89 d0                	mov    %edx,%eax
  8029a5:	e9 44 ff ff ff       	jmp    8028ee <__umoddi3+0x3e>
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	89 c8                	mov    %ecx,%eax
  8029ae:	89 f2                	mov    %esi,%edx
  8029b0:	83 c4 1c             	add    $0x1c,%esp
  8029b3:	5b                   	pop    %ebx
  8029b4:	5e                   	pop    %esi
  8029b5:	5f                   	pop    %edi
  8029b6:	5d                   	pop    %ebp
  8029b7:	c3                   	ret    
  8029b8:	3b 04 24             	cmp    (%esp),%eax
  8029bb:	72 06                	jb     8029c3 <__umoddi3+0x113>
  8029bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8029c1:	77 0f                	ja     8029d2 <__umoddi3+0x122>
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	29 f9                	sub    %edi,%ecx
  8029c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029cb:	89 14 24             	mov    %edx,(%esp)
  8029ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029d6:	8b 14 24             	mov    (%esp),%edx
  8029d9:	83 c4 1c             	add    $0x1c,%esp
  8029dc:	5b                   	pop    %ebx
  8029dd:	5e                   	pop    %esi
  8029de:	5f                   	pop    %edi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
  8029e1:	8d 76 00             	lea    0x0(%esi),%esi
  8029e4:	2b 04 24             	sub    (%esp),%eax
  8029e7:	19 fa                	sbb    %edi,%edx
  8029e9:	89 d1                	mov    %edx,%ecx
  8029eb:	89 c6                	mov    %eax,%esi
  8029ed:	e9 71 ff ff ff       	jmp    802963 <__umoddi3+0xb3>
  8029f2:	66 90                	xchg   %ax,%ax
  8029f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029f8:	72 ea                	jb     8029e4 <__umoddi3+0x134>
  8029fa:	89 d9                	mov    %ebx,%ecx
  8029fc:	e9 62 ff ff ff       	jmp    802963 <__umoddi3+0xb3>
