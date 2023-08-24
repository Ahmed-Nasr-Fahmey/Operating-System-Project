
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 69 18 00 00       	call   80189f <libmain>
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
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
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
  800091:	68 40 34 80 00       	push   $0x803440
  800096:	6a 1a                	push   $0x1a
  800098:	68 5c 34 80 00       	push   $0x80345c
  80009d:	e8 4c 19 00 00       	call   8019ee <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 6a 29 00 00       	call   802a46 <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 71 2b 00 00       	call   802c55 <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 f5 2b 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 32 29 00 00       	call   802a46 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 70 34 80 00       	push   $0x803470
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 5c 34 80 00       	push   $0x80345c
  800143:	e8 a6 18 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 a8 2b 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  80014d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800150:	3d 00 02 00 00       	cmp    $0x200,%eax
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 d8 34 80 00       	push   $0x8034d8
  80015f:	6a 3b                	push   $0x3b
  800161:	68 5c 34 80 00       	push   $0x80345c
  800166:	e8 83 18 00 00       	call   8019ee <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  80016b:	e8 e5 2a 00 00       	call   802c55 <sys_calculate_free_frames>
  800170:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800176:	01 c0                	add    %eax,%eax
  800178:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017b:	48                   	dec    %eax
  80017c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017f:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800185:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800188:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80018b:	8a 55 db             	mov    -0x25(%ebp),%dl
  80018e:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800190:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800193:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800196:	01 c2                	add    %eax,%edx
  800198:	8a 45 da             	mov    -0x26(%ebp),%al
  80019b:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8001a0:	e8 b0 2a 00 00       	call   802c55 <sys_calculate_free_frames>
  8001a5:	29 c3                	sub    %eax,%ebx
  8001a7:	89 d8                	mov    %ebx,%eax
  8001a9:	83 f8 03             	cmp    $0x3,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 08 35 80 00       	push   $0x803508
  8001b6:	6a 42                	push   $0x42
  8001b8:	68 5c 34 80 00       	push   $0x80345c
  8001bd:	e8 2c 18 00 00       	call   8019ee <_panic>
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
  8001f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800200:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800203:	8b 45 b0             	mov    -0x50(%ebp),%eax
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
  80022d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800230:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800238:	89 c1                	mov    %eax,%ecx
  80023a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80023d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800240:	01 d0                	add    %edx,%eax
  800242:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800245:	8b 45 a8             	mov    -0x58(%ebp),%eax
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
  800273:	68 4c 35 80 00       	push   $0x80354c
  800278:	6a 4c                	push   $0x4c
  80027a:	68 5c 34 80 00       	push   $0x80345c
  80027f:	e8 6a 17 00 00       	call   8019ee <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800284:	e8 6c 2a 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800289:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 a9 27 00 00       	call   802a46 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a6:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002ac:	89 c2                	mov    %eax,%edx
  8002ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b8:	39 c2                	cmp    %eax,%edx
  8002ba:	72 16                	jb     8002d2 <_main+0x29a>
  8002bc:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002c2:	89 c2                	mov    %eax,%edx
  8002c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	76 14                	jbe    8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 70 34 80 00       	push   $0x803470
  8002da:	6a 51                	push   $0x51
  8002dc:	68 5c 34 80 00       	push   $0x80345c
  8002e1:	e8 08 17 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002e6:	e8 0a 2a 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8002eb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 d8 34 80 00       	push   $0x8034d8
  8002fd:	6a 52                	push   $0x52
  8002ff:	68 5c 34 80 00       	push   $0x80345c
  800304:	e8 e5 16 00 00       	call   8019ee <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800309:	e8 47 29 00 00       	call   802c55 <sys_calculate_free_frames>
  80030e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800311:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800317:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	01 c0                	add    %eax,%eax
  80031f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800322:	d1 e8                	shr    %eax
  800324:	48                   	dec    %eax
  800325:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  800328:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80032b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032e:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800331:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800334:	01 c0                	add    %eax,%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80033b:	01 c2                	add    %eax,%edx
  80033d:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800341:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800344:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800347:	e8 09 29 00 00       	call   802c55 <sys_calculate_free_frames>
  80034c:	29 c3                	sub    %eax,%ebx
  80034e:	89 d8                	mov    %ebx,%eax
  800350:	83 f8 02             	cmp    $0x2,%eax
  800353:	74 14                	je     800369 <_main+0x331>
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 08 35 80 00       	push   $0x803508
  80035d:	6a 59                	push   $0x59
  80035f:	68 5c 34 80 00       	push   $0x80345c
  800364:	e8 85 16 00 00       	call   8019ee <_panic>
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
  800397:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80039a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80039d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003a7:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003aa:	8b 45 98             	mov    -0x68(%ebp),%eax
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
  8003d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003f0:	8b 45 90             	mov    -0x70(%ebp),%eax
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
  80041e:	68 4c 35 80 00       	push   $0x80354c
  800423:	6a 62                	push   $0x62
  800425:	68 5c 34 80 00       	push   $0x80345c
  80042a:	e8 bf 15 00 00       	call   8019ee <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042f:	e8 c1 28 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800434:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043a:	01 c0                	add    %eax,%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 01 26 00 00       	call   802a46 <malloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80044e:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800454:	89 c2                	mov    %eax,%edx
  800456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800459:	c1 e0 02             	shl    $0x2,%eax
  80045c:	05 00 00 00 80       	add    $0x80000000,%eax
  800461:	39 c2                	cmp    %eax,%edx
  800463:	72 17                	jb     80047c <_main+0x444>
  800465:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80046b:	89 c2                	mov    %eax,%edx
  80046d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800470:	c1 e0 02             	shl    $0x2,%eax
  800473:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	76 14                	jbe    800490 <_main+0x458>
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 70 34 80 00       	push   $0x803470
  800484:	6a 67                	push   $0x67
  800486:	68 5c 34 80 00       	push   $0x80345c
  80048b:	e8 5e 15 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800490:	e8 60 28 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800495:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800498:	83 f8 01             	cmp    $0x1,%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 d8 34 80 00       	push   $0x8034d8
  8004a5:	6a 68                	push   $0x68
  8004a7:	68 5c 34 80 00       	push   $0x80345c
  8004ac:	e8 3d 15 00 00       	call   8019ee <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 9f 27 00 00       	call   802c55 <sys_calculate_free_frames>
  8004b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b9:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004bf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	c1 e8 02             	shr    $0x2,%eax
  8004ca:	48                   	dec    %eax
  8004cb:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004ce:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004d4:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004d6:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004e3:	01 c2                	add    %eax,%edx
  8004e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e8:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ea:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004ed:	e8 63 27 00 00       	call   802c55 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 08 35 80 00       	push   $0x803508
  800503:	6a 6f                	push   $0x6f
  800505:	68 5c 34 80 00       	push   $0x80345c
  80050a:	e8 df 14 00 00       	call   8019ee <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 95 00 00 00       	jmp    8005b7 <_main+0x57f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 20 40 80 00       	mov    0x804020,%eax
  800527:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80052d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800540:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80054d:	89 45 80             	mov    %eax,-0x80(%ebp)
  800550:	8b 45 80             	mov    -0x80(%ebp),%eax
  800553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800558:	39 c2                	cmp    %eax,%edx
  80055a:	75 03                	jne    80055f <_main+0x527>
				found++;
  80055c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80056a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	01 c0                	add    %eax,%eax
  800571:	01 d0                	add    %edx,%eax
  800573:	c1 e0 03             	shl    $0x3,%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800580:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058b:	89 c2                	mov    %eax,%edx
  80058d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  8005a2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8005a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ad:	39 c2                	cmp    %eax,%edx
  8005af:	75 03                	jne    8005b4 <_main+0x57c>
				found++;
  8005b1:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005b4:	ff 45 ec             	incl   -0x14(%ebp)
  8005b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bc:	8b 50 74             	mov    0x74(%eax),%edx
  8005bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c2:	39 c2                	cmp    %eax,%edx
  8005c4:	0f 87 58 ff ff ff    	ja     800522 <_main+0x4ea>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005ca:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 4c 35 80 00       	push   $0x80354c
  8005d8:	6a 78                	push   $0x78
  8005da:	68 5c 34 80 00       	push   $0x80345c
  8005df:	e8 0a 14 00 00       	call   8019ee <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e4:	e8 6c 26 00 00       	call   802c55 <sys_calculate_free_frames>
  8005e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005ec:	e8 04 27 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8005f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f7:	01 c0                	add    %eax,%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 44 24 00 00       	call   802a46 <malloc>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060b:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800611:	89 c2                	mov    %eax,%edx
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	c1 e0 02             	shl    $0x2,%eax
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061e:	c1 e0 02             	shl    $0x2,%eax
  800621:	01 c8                	add    %ecx,%eax
  800623:	05 00 00 00 80       	add    $0x80000000,%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	72 21                	jb     80064d <_main+0x615>
  80062c:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800632:	89 c2                	mov    %eax,%edx
  800634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800637:	c1 e0 02             	shl    $0x2,%eax
  80063a:	89 c1                	mov    %eax,%ecx
  80063c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063f:	c1 e0 02             	shl    $0x2,%eax
  800642:	01 c8                	add    %ecx,%eax
  800644:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800649:	39 c2                	cmp    %eax,%edx
  80064b:	76 14                	jbe    800661 <_main+0x629>
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 70 34 80 00       	push   $0x803470
  800655:	6a 7e                	push   $0x7e
  800657:	68 5c 34 80 00       	push   $0x80345c
  80065c:	e8 8d 13 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800661:	e8 8f 26 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800666:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800669:	83 f8 01             	cmp    $0x1,%eax
  80066c:	74 14                	je     800682 <_main+0x64a>
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 d8 34 80 00       	push   $0x8034d8
  800676:	6a 7f                	push   $0x7f
  800678:	68 5c 34 80 00       	push   $0x80345c
  80067d:	e8 6c 13 00 00       	call   8019ee <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800682:	e8 6e 26 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800687:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80068a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068d:	89 d0                	mov    %edx,%eax
  80068f:	01 c0                	add    %eax,%eax
  800691:	01 d0                	add    %edx,%eax
  800693:	01 c0                	add    %eax,%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	83 ec 0c             	sub    $0xc,%esp
  80069a:	50                   	push   %eax
  80069b:	e8 a6 23 00 00       	call   802a46 <malloc>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006a9:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006af:	89 c2                	mov    %eax,%edx
  8006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b4:	c1 e0 02             	shl    $0x2,%eax
  8006b7:	89 c1                	mov    %eax,%ecx
  8006b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006bc:	c1 e0 03             	shl    $0x3,%eax
  8006bf:	01 c8                	add    %ecx,%eax
  8006c1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c6:	39 c2                	cmp    %eax,%edx
  8006c8:	72 21                	jb     8006eb <_main+0x6b3>
  8006ca:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006d0:	89 c2                	mov    %eax,%edx
  8006d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d5:	c1 e0 02             	shl    $0x2,%eax
  8006d8:	89 c1                	mov    %eax,%ecx
  8006da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dd:	c1 e0 03             	shl    $0x3,%eax
  8006e0:	01 c8                	add    %ecx,%eax
  8006e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e7:	39 c2                	cmp    %eax,%edx
  8006e9:	76 17                	jbe    800702 <_main+0x6ca>
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	68 70 34 80 00       	push   $0x803470
  8006f3:	68 85 00 00 00       	push   $0x85
  8006f8:	68 5c 34 80 00       	push   $0x80345c
  8006fd:	e8 ec 12 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800702:	e8 ee 25 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800707:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80070a:	83 f8 02             	cmp    $0x2,%eax
  80070d:	74 17                	je     800726 <_main+0x6ee>
  80070f:	83 ec 04             	sub    $0x4,%esp
  800712:	68 d8 34 80 00       	push   $0x8034d8
  800717:	68 86 00 00 00       	push   $0x86
  80071c:	68 5c 34 80 00       	push   $0x80345c
  800721:	e8 c8 12 00 00       	call   8019ee <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800726:	e8 2a 25 00 00       	call   802c55 <sys_calculate_free_frames>
  80072b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80072e:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800734:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80073a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80073d:	89 d0                	mov    %edx,%eax
  80073f:	01 c0                	add    %eax,%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	01 c0                	add    %eax,%eax
  800745:	01 d0                	add    %edx,%eax
  800747:	c1 e8 03             	shr    $0x3,%eax
  80074a:	48                   	dec    %eax
  80074b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800751:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800757:	8a 55 db             	mov    -0x25(%ebp),%dl
  80075a:	88 10                	mov    %dl,(%eax)
  80075c:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  800762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800765:	66 89 42 02          	mov    %ax,0x2(%edx)
  800769:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800772:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800775:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80077b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800782:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800788:	01 c2                	add    %eax,%edx
  80078a:	8a 45 da             	mov    -0x26(%ebp),%al
  80078d:	88 02                	mov    %al,(%edx)
  80078f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800795:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80079c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a2:	01 c2                	add    %eax,%edx
  8007a4:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  8007a8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007ac:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8007b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007c4:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c7:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007ca:	e8 86 24 00 00       	call   802c55 <sys_calculate_free_frames>
  8007cf:	29 c3                	sub    %eax,%ebx
  8007d1:	89 d8                	mov    %ebx,%eax
  8007d3:	83 f8 02             	cmp    $0x2,%eax
  8007d6:	74 17                	je     8007ef <_main+0x7b7>
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	68 08 35 80 00       	push   $0x803508
  8007e0:	68 8d 00 00 00       	push   $0x8d
  8007e5:	68 5c 34 80 00       	push   $0x80345c
  8007ea:	e8 ff 11 00 00       	call   8019ee <_panic>
		found = 0;
  8007ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007fd:	e9 aa 00 00 00       	jmp    8008ac <_main+0x874>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  800802:	a1 20 40 80 00       	mov    0x804020,%eax
  800807:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80080d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800810:	89 d0                	mov    %edx,%eax
  800812:	01 c0                	add    %eax,%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	c1 e0 03             	shl    $0x3,%eax
  800819:	01 c8                	add    %ecx,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800823:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800829:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80082e:	89 c2                	mov    %eax,%edx
  800830:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800836:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80083c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	39 c2                	cmp    %eax,%edx
  800849:	75 03                	jne    80084e <_main+0x816>
				found++;
  80084b:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80084e:	a1 20 40 80 00       	mov    0x804020,%eax
  800853:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800859:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80085c:	89 d0                	mov    %edx,%eax
  80085e:	01 c0                	add    %eax,%eax
  800860:	01 d0                	add    %edx,%eax
  800862:	c1 e0 03             	shl    $0x3,%eax
  800865:	01 c8                	add    %ecx,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80086f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800882:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800889:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80088f:	01 c8                	add    %ecx,%eax
  800891:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800897:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80089d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a2:	39 c2                	cmp    %eax,%edx
  8008a4:	75 03                	jne    8008a9 <_main+0x871>
				found++;
  8008a6:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008a9:	ff 45 ec             	incl   -0x14(%ebp)
  8008ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b1:	8b 50 74             	mov    0x74(%eax),%edx
  8008b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b7:	39 c2                	cmp    %eax,%edx
  8008b9:	0f 87 43 ff ff ff    	ja     800802 <_main+0x7ca>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008bf:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c3:	74 17                	je     8008dc <_main+0x8a4>
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 4c 35 80 00       	push   $0x80354c
  8008cd:	68 96 00 00 00       	push   $0x96
  8008d2:	68 5c 34 80 00       	push   $0x80345c
  8008d7:	e8 12 11 00 00       	call   8019ee <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008dc:	e8 74 23 00 00       	call   802c55 <sys_calculate_free_frames>
  8008e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e4:	e8 0c 24 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8008e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 c2                	mov    %eax,%edx
  8008f1:	01 d2                	add    %edx,%edx
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	50                   	push   %eax
  8008fc:	e8 45 21 00 00       	call   802a46 <malloc>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80090a:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800910:	89 c2                	mov    %eax,%edx
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	c1 e0 02             	shl    $0x2,%eax
  800918:	89 c1                	mov    %eax,%ecx
  80091a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80091d:	c1 e0 04             	shl    $0x4,%eax
  800920:	01 c8                	add    %ecx,%eax
  800922:	05 00 00 00 80       	add    $0x80000000,%eax
  800927:	39 c2                	cmp    %eax,%edx
  800929:	72 21                	jb     80094c <_main+0x914>
  80092b:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800931:	89 c2                	mov    %eax,%edx
  800933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800936:	c1 e0 02             	shl    $0x2,%eax
  800939:	89 c1                	mov    %eax,%ecx
  80093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80093e:	c1 e0 04             	shl    $0x4,%eax
  800941:	01 c8                	add    %ecx,%eax
  800943:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	76 17                	jbe    800963 <_main+0x92b>
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 70 34 80 00       	push   $0x803470
  800954:	68 9c 00 00 00       	push   $0x9c
  800959:	68 5c 34 80 00       	push   $0x80345c
  80095e:	e8 8b 10 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800963:	e8 8d 23 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800968:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80096b:	89 c2                	mov    %eax,%edx
  80096d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800970:	89 c1                	mov    %eax,%ecx
  800972:	01 c9                	add    %ecx,%ecx
  800974:	01 c8                	add    %ecx,%eax
  800976:	85 c0                	test   %eax,%eax
  800978:	79 05                	jns    80097f <_main+0x947>
  80097a:	05 ff 0f 00 00       	add    $0xfff,%eax
  80097f:	c1 f8 0c             	sar    $0xc,%eax
  800982:	39 c2                	cmp    %eax,%edx
  800984:	74 17                	je     80099d <_main+0x965>
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 d8 34 80 00       	push   $0x8034d8
  80098e:	68 9d 00 00 00       	push   $0x9d
  800993:	68 5c 34 80 00       	push   $0x80345c
  800998:	e8 51 10 00 00       	call   8019ee <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80099d:	e8 53 23 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8009a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  8009a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a8:	89 d0                	mov    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	50                   	push   %eax
  8009b7:	e8 8a 20 00 00       	call   802a46 <malloc>
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009c5:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009cb:	89 c1                	mov    %eax,%ecx
  8009cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d0:	89 d0                	mov    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	01 c0                	add    %eax,%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	89 c2                	mov    %eax,%edx
  8009dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009df:	c1 e0 04             	shl    $0x4,%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	05 00 00 00 80       	add    $0x80000000,%eax
  8009e9:	39 c1                	cmp    %eax,%ecx
  8009eb:	72 28                	jb     800a15 <_main+0x9dd>
  8009ed:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009f3:	89 c1                	mov    %eax,%ecx
  8009f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a07:	c1 e0 04             	shl    $0x4,%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a11:	39 c1                	cmp    %eax,%ecx
  800a13:	76 17                	jbe    800a2c <_main+0x9f4>
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 70 34 80 00       	push   $0x803470
  800a1d:	68 a3 00 00 00       	push   $0xa3
  800a22:	68 5c 34 80 00       	push   $0x80345c
  800a27:	e8 c2 0f 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800a2c:	e8 c4 22 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800a31:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800a34:	89 c1                	mov    %eax,%ecx
  800a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a39:	89 d0                	mov    %edx,%eax
  800a3b:	01 c0                	add    %eax,%eax
  800a3d:	01 d0                	add    %edx,%eax
  800a3f:	01 c0                	add    %eax,%eax
  800a41:	85 c0                	test   %eax,%eax
  800a43:	79 05                	jns    800a4a <_main+0xa12>
  800a45:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a4a:	c1 f8 0c             	sar    $0xc,%eax
  800a4d:	39 c1                	cmp    %eax,%ecx
  800a4f:	74 17                	je     800a68 <_main+0xa30>
  800a51:	83 ec 04             	sub    $0x4,%esp
  800a54:	68 d8 34 80 00       	push   $0x8034d8
  800a59:	68 a4 00 00 00       	push   $0xa4
  800a5e:	68 5c 34 80 00       	push   $0x80345c
  800a63:	e8 86 0f 00 00       	call   8019ee <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a68:	e8 e8 21 00 00       	call   802c55 <sys_calculate_free_frames>
  800a6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	01 c0                	add    %eax,%eax
  800a77:	01 d0                	add    %edx,%eax
  800a79:	01 c0                	add    %eax,%eax
  800a7b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a7e:	48                   	dec    %eax
  800a7f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a85:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a8b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a91:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a97:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a9a:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a9c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	c1 ea 1f             	shr    $0x1f,%edx
  800aa7:	01 d0                	add    %edx,%eax
  800aa9:	d1 f8                	sar    %eax
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800ab3:	01 c2                	add    %eax,%edx
  800ab5:	8a 45 da             	mov    -0x26(%ebp),%al
  800ab8:	88 c1                	mov    %al,%cl
  800aba:	c0 e9 07             	shr    $0x7,%cl
  800abd:	01 c8                	add    %ecx,%eax
  800abf:	d0 f8                	sar    %al
  800ac1:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800ac3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ac9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800acf:	01 c2                	add    %eax,%edx
  800ad1:	8a 45 da             	mov    -0x26(%ebp),%al
  800ad4:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800ad6:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800ad9:	e8 77 21 00 00       	call   802c55 <sys_calculate_free_frames>
  800ade:	29 c3                	sub    %eax,%ebx
  800ae0:	89 d8                	mov    %ebx,%eax
  800ae2:	83 f8 05             	cmp    $0x5,%eax
  800ae5:	74 17                	je     800afe <_main+0xac6>
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	68 08 35 80 00       	push   $0x803508
  800aef:	68 ac 00 00 00       	push   $0xac
  800af4:	68 5c 34 80 00       	push   $0x80345c
  800af9:	e8 f0 0e 00 00       	call   8019ee <_panic>
		found = 0;
  800afe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800b0c:	e9 02 01 00 00       	jmp    800c13 <_main+0xbdb>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800b11:	a1 20 40 80 00       	mov    0x804020,%eax
  800b16:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 03             	shl    $0x3,%eax
  800b28:	01 c8                	add    %ecx,%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b32:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b45:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b4b:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b56:	39 c2                	cmp    %eax,%edx
  800b58:	75 03                	jne    800b5d <_main+0xb25>
				found++;
  800b5a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b5d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b62:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b6b:	89 d0                	mov    %edx,%eax
  800b6d:	01 c0                	add    %eax,%eax
  800b6f:	01 d0                	add    %edx,%eax
  800b71:	c1 e0 03             	shl    $0x3,%eax
  800b74:	01 c8                	add    %ecx,%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b7e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b91:	89 c1                	mov    %eax,%ecx
  800b93:	c1 e9 1f             	shr    $0x1f,%ecx
  800b96:	01 c8                	add    %ecx,%eax
  800b98:	d1 f8                	sar    %eax
  800b9a:	89 c1                	mov    %eax,%ecx
  800b9c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800ba2:	01 c8                	add    %ecx,%eax
  800ba4:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800baa:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800bb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	75 03                	jne    800bbc <_main+0xb84>
				found++;
  800bb9:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800bbc:	a1 20 40 80 00       	mov    0x804020,%eax
  800bc1:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	01 c0                	add    %eax,%eax
  800bce:	01 d0                	add    %edx,%eax
  800bd0:	c1 e0 03             	shl    $0x3,%eax
  800bd3:	01 c8                	add    %ecx,%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bdd:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800be8:	89 c1                	mov    %eax,%ecx
  800bea:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800bf0:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800bf6:	01 d0                	add    %edx,%eax
  800bf8:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bfe:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800c04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c09:	39 c1                	cmp    %eax,%ecx
  800c0b:	75 03                	jne    800c10 <_main+0xbd8>
				found++;
  800c0d:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c10:	ff 45 ec             	incl   -0x14(%ebp)
  800c13:	a1 20 40 80 00       	mov    0x804020,%eax
  800c18:	8b 50 74             	mov    0x74(%eax),%edx
  800c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	0f 87 eb fe ff ff    	ja     800b11 <_main+0xad9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800c26:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 4c 35 80 00       	push   $0x80354c
  800c34:	68 b7 00 00 00       	push   $0xb7
  800c39:	68 5c 34 80 00       	push   $0x80345c
  800c3e:	e8 ab 0d 00 00       	call   8019ee <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 ad 20 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	01 d0                	add    %edx,%eax
  800c58:	01 c0                	add    %eax,%eax
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	50                   	push   %eax
  800c5e:	e8 e3 1d 00 00       	call   802a46 <malloc>
  800c63:	83 c4 10             	add    $0x10,%esp
  800c66:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c6c:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c72:	89 c1                	mov    %eax,%ecx
  800c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c77:	89 d0                	mov    %edx,%eax
  800c79:	01 c0                	add    %eax,%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	c1 e0 02             	shl    $0x2,%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	89 c2                	mov    %eax,%edx
  800c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c87:	c1 e0 04             	shl    $0x4,%eax
  800c8a:	01 d0                	add    %edx,%eax
  800c8c:	05 00 00 00 80       	add    $0x80000000,%eax
  800c91:	39 c1                	cmp    %eax,%ecx
  800c93:	72 29                	jb     800cbe <_main+0xc86>
  800c95:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c9b:	89 c1                	mov    %eax,%ecx
  800c9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ca0:	89 d0                	mov    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	c1 e0 02             	shl    $0x2,%eax
  800ca9:	01 d0                	add    %edx,%eax
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cb0:	c1 e0 04             	shl    $0x4,%eax
  800cb3:	01 d0                	add    %edx,%eax
  800cb5:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800cba:	39 c1                	cmp    %eax,%ecx
  800cbc:	76 17                	jbe    800cd5 <_main+0xc9d>
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	68 70 34 80 00       	push   $0x803470
  800cc6:	68 bc 00 00 00       	push   $0xbc
  800ccb:	68 5c 34 80 00       	push   $0x80345c
  800cd0:	e8 19 0d 00 00       	call   8019ee <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800cd5:	e8 1b 20 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800cda:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800cdd:	83 f8 04             	cmp    $0x4,%eax
  800ce0:	74 17                	je     800cf9 <_main+0xcc1>
  800ce2:	83 ec 04             	sub    $0x4,%esp
  800ce5:	68 d8 34 80 00       	push   $0x8034d8
  800cea:	68 bd 00 00 00       	push   $0xbd
  800cef:	68 5c 34 80 00       	push   $0x80345c
  800cf4:	e8 f5 0c 00 00       	call   8019ee <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cf9:	e8 57 1f 00 00       	call   802c55 <sys_calculate_free_frames>
  800cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800d01:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800d07:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	01 c0                	add    %eax,%eax
  800d14:	01 d0                	add    %edx,%eax
  800d16:	01 c0                	add    %eax,%eax
  800d18:	01 d0                	add    %edx,%eax
  800d1a:	01 c0                	add    %eax,%eax
  800d1c:	d1 e8                	shr    %eax
  800d1e:	48                   	dec    %eax
  800d1f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800d2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d2e:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800d31:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d37:	01 c0                	add    %eax,%eax
  800d39:	89 c2                	mov    %eax,%edx
  800d3b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d41:	01 c2                	add    %eax,%edx
  800d43:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800d47:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d4a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d4d:	e8 03 1f 00 00       	call   802c55 <sys_calculate_free_frames>
  800d52:	29 c3                	sub    %eax,%ebx
  800d54:	89 d8                	mov    %ebx,%eax
  800d56:	83 f8 02             	cmp    $0x2,%eax
  800d59:	74 17                	je     800d72 <_main+0xd3a>
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	68 08 35 80 00       	push   $0x803508
  800d63:	68 c4 00 00 00       	push   $0xc4
  800d68:	68 5c 34 80 00       	push   $0x80345c
  800d6d:	e8 7c 0c 00 00       	call   8019ee <_panic>
		found = 0;
  800d72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d80:	e9 a7 00 00 00       	jmp    800e2c <_main+0xdf4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d85:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800d90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800da6:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800dac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800db9:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800dbf:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dca:	39 c2                	cmp    %eax,%edx
  800dcc:	75 03                	jne    800dd1 <_main+0xd99>
				found++;
  800dce:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800dd1:	a1 20 40 80 00       	mov    0x804020,%eax
  800dd6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ddf:	89 d0                	mov    %edx,%eax
  800de1:	01 c0                	add    %eax,%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	c1 e0 03             	shl    $0x3,%eax
  800de8:	01 c8                	add    %ecx,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800df2:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800df8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800e05:	01 c0                	add    %eax,%eax
  800e07:	89 c1                	mov    %eax,%ecx
  800e09:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e0f:	01 c8                	add    %ecx,%eax
  800e11:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800e17:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e22:	39 c2                	cmp    %eax,%edx
  800e24:	75 03                	jne    800e29 <_main+0xdf1>
				found++;
  800e26:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e29:	ff 45 ec             	incl   -0x14(%ebp)
  800e2c:	a1 20 40 80 00       	mov    0x804020,%eax
  800e31:	8b 50 74             	mov    0x74(%eax),%edx
  800e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e37:	39 c2                	cmp    %eax,%edx
  800e39:	0f 87 46 ff ff ff    	ja     800d85 <_main+0xd4d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e3f:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e43:	74 17                	je     800e5c <_main+0xe24>
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	68 4c 35 80 00       	push   $0x80354c
  800e4d:	68 cd 00 00 00       	push   $0xcd
  800e52:	68 5c 34 80 00       	push   $0x80345c
  800e57:	e8 92 0b 00 00       	call   8019ee <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e5c:	e8 f4 1d 00 00       	call   802c55 <sys_calculate_free_frames>
  800e61:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e67:	e8 89 1e 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800e6c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e72:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	e8 06 1c 00 00       	call   802a87 <free>
  800e81:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e84:	e8 6c 1e 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800e89:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800e8f:	29 c2                	sub    %eax,%edx
  800e91:	89 d0                	mov    %edx,%eax
  800e93:	3d 00 02 00 00       	cmp    $0x200,%eax
  800e98:	74 17                	je     800eb1 <_main+0xe79>
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	68 6c 35 80 00       	push   $0x80356c
  800ea2:	68 d5 00 00 00       	push   $0xd5
  800ea7:	68 5c 34 80 00       	push   $0x80345c
  800eac:	e8 3d 0b 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800eb1:	e8 9f 1d 00 00       	call   802c55 <sys_calculate_free_frames>
  800eb6:	89 c2                	mov    %eax,%edx
  800eb8:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
  800ec2:	83 f8 02             	cmp    $0x2,%eax
  800ec5:	74 17                	je     800ede <_main+0xea6>
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	68 a8 35 80 00       	push   $0x8035a8
  800ecf:	68 d6 00 00 00       	push   $0xd6
  800ed4:	68 5c 34 80 00       	push   $0x80345c
  800ed9:	e8 10 0b 00 00       	call   8019ee <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ede:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ee5:	e9 c2 00 00 00       	jmp    800fac <_main+0xf74>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800eea:	a1 20 40 80 00       	mov    0x804020,%eax
  800eef:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ef5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ef8:	89 d0                	mov    %edx,%eax
  800efa:	01 c0                	add    %eax,%eax
  800efc:	01 d0                	add    %edx,%eax
  800efe:	c1 e0 03             	shl    $0x3,%eax
  800f01:	01 c8                	add    %ecx,%eax
  800f03:	8b 00                	mov    (%eax),%eax
  800f05:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800f0b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f16:	89 c2                	mov    %eax,%edx
  800f18:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f1b:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800f21:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800f27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2c:	39 c2                	cmp    %eax,%edx
  800f2e:	75 17                	jne    800f47 <_main+0xf0f>
				panic("free: page is not removed from WS");
  800f30:	83 ec 04             	sub    $0x4,%esp
  800f33:	68 f4 35 80 00       	push   $0x8035f4
  800f38:	68 db 00 00 00       	push   $0xdb
  800f3d:	68 5c 34 80 00       	push   $0x80345c
  800f42:	e8 a7 0a 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800f47:	a1 20 40 80 00       	mov    0x804020,%eax
  800f4c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800f52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	01 c0                	add    %eax,%eax
  800f59:	01 d0                	add    %edx,%eax
  800f5b:	c1 e0 03             	shl    $0x3,%eax
  800f5e:	01 c8                	add    %ecx,%eax
  800f60:	8b 00                	mov    (%eax),%eax
  800f62:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f68:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f73:	89 c1                	mov    %eax,%ecx
  800f75:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f7b:	01 d0                	add    %edx,%eax
  800f7d:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f83:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f8e:	39 c1                	cmp    %eax,%ecx
  800f90:	75 17                	jne    800fa9 <_main+0xf71>
				panic("free: page is not removed from WS");
  800f92:	83 ec 04             	sub    $0x4,%esp
  800f95:	68 f4 35 80 00       	push   $0x8035f4
  800f9a:	68 dd 00 00 00       	push   $0xdd
  800f9f:	68 5c 34 80 00       	push   $0x80345c
  800fa4:	e8 45 0a 00 00       	call   8019ee <_panic>
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[0]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fa9:	ff 45 e4             	incl   -0x1c(%ebp)
  800fac:	a1 20 40 80 00       	mov    0x804020,%eax
  800fb1:	8b 50 74             	mov    0x74(%eax),%edx
  800fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fb7:	39 c2                	cmp    %eax,%edx
  800fb9:	0f 87 2b ff ff ff    	ja     800eea <_main+0xeb2>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800fbf:	e8 91 1c 00 00       	call   802c55 <sys_calculate_free_frames>
  800fc4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fca:	e8 26 1d 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800fcf:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800fd5:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	50                   	push   %eax
  800fdf:	e8 a3 1a 00 00       	call   802a87 <free>
  800fe4:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fe7:	e8 09 1d 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  800fec:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800ff2:	29 c2                	sub    %eax,%edx
  800ff4:	89 d0                	mov    %edx,%eax
  800ff6:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ffb:	74 17                	je     801014 <_main+0xfdc>
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	68 6c 35 80 00       	push   $0x80356c
  801005:	68 e5 00 00 00       	push   $0xe5
  80100a:	68 5c 34 80 00       	push   $0x80345c
  80100f:	e8 da 09 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801014:	e8 3c 1c 00 00       	call   802c55 <sys_calculate_free_frames>
  801019:	89 c2                	mov    %eax,%edx
  80101b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801021:	29 c2                	sub    %eax,%edx
  801023:	89 d0                	mov    %edx,%eax
  801025:	83 f8 03             	cmp    $0x3,%eax
  801028:	74 17                	je     801041 <_main+0x1009>
  80102a:	83 ec 04             	sub    $0x4,%esp
  80102d:	68 a8 35 80 00       	push   $0x8035a8
  801032:	68 e6 00 00 00       	push   $0xe6
  801037:	68 5c 34 80 00       	push   $0x80345c
  80103c:	e8 ad 09 00 00       	call   8019ee <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801041:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801048:	e9 c6 00 00 00       	jmp    801113 <_main+0x10db>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  80104d:	a1 20 40 80 00       	mov    0x804020,%eax
  801052:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801058:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105b:	89 d0                	mov    %edx,%eax
  80105d:	01 c0                	add    %eax,%eax
  80105f:	01 d0                	add    %edx,%eax
  801061:	c1 e0 03             	shl    $0x3,%eax
  801064:	01 c8                	add    %ecx,%eax
  801066:	8b 00                	mov    (%eax),%eax
  801068:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  80106e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801079:	89 c2                	mov    %eax,%edx
  80107b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80107e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801084:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80108a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108f:	39 c2                	cmp    %eax,%edx
  801091:	75 17                	jne    8010aa <_main+0x1072>
				panic("free: page is not removed from WS");
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 f4 35 80 00       	push   $0x8035f4
  80109b:	68 ea 00 00 00       	push   $0xea
  8010a0:	68 5c 34 80 00       	push   $0x80345c
  8010a5:	e8 44 09 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8010aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8010af:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8010b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010b8:	89 d0                	mov    %edx,%eax
  8010ba:	01 c0                	add    %eax,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	c1 e0 03             	shl    $0x3,%eax
  8010c1:	01 c8                	add    %ecx,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
  8010c5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8010cb:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8010d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8010db:	01 c0                	add    %eax,%eax
  8010dd:	89 c1                	mov    %eax,%ecx
  8010df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8010e2:	01 c8                	add    %ecx,%eax
  8010e4:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8010ea:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8010f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f5:	39 c2                	cmp    %eax,%edx
  8010f7:	75 17                	jne    801110 <_main+0x10d8>
				panic("free: page is not removed from WS");
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	68 f4 35 80 00       	push   $0x8035f4
  801101:	68 ec 00 00 00       	push   $0xec
  801106:	68 5c 34 80 00       	push   $0x80345c
  80110b:	e8 de 08 00 00       	call   8019ee <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801110:	ff 45 e4             	incl   -0x1c(%ebp)
  801113:	a1 20 40 80 00       	mov    0x804020,%eax
  801118:	8b 50 74             	mov    0x74(%eax),%edx
  80111b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	0f 87 27 ff ff ff    	ja     80104d <_main+0x1015>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  801126:	e8 2a 1b 00 00       	call   802c55 <sys_calculate_free_frames>
  80112b:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801131:	e8 bf 1b 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801136:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  80113c:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	50                   	push   %eax
  801146:	e8 3c 19 00 00       	call   802a87 <free>
  80114b:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  80114e:	e8 a2 1b 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801153:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  801159:	89 d1                	mov    %edx,%ecx
  80115b:	29 c1                	sub    %eax,%ecx
  80115d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801160:	89 d0                	mov    %edx,%eax
  801162:	01 c0                	add    %eax,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	85 c0                	test   %eax,%eax
  80116a:	79 05                	jns    801171 <_main+0x1139>
  80116c:	05 ff 0f 00 00       	add    $0xfff,%eax
  801171:	c1 f8 0c             	sar    $0xc,%eax
  801174:	39 c1                	cmp    %eax,%ecx
  801176:	74 17                	je     80118f <_main+0x1157>
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	68 6c 35 80 00       	push   $0x80356c
  801180:	68 f3 00 00 00       	push   $0xf3
  801185:	68 5c 34 80 00       	push   $0x80345c
  80118a:	e8 5f 08 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80118f:	e8 c1 1a 00 00       	call   802c55 <sys_calculate_free_frames>
  801194:	89 c2                	mov    %eax,%edx
  801196:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	83 f8 04             	cmp    $0x4,%eax
  8011a3:	74 17                	je     8011bc <_main+0x1184>
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	68 a8 35 80 00       	push   $0x8035a8
  8011ad:	68 f4 00 00 00       	push   $0xf4
  8011b2:	68 5c 34 80 00       	push   $0x80345c
  8011b7:	e8 32 08 00 00       	call   8019ee <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011c3:	e9 3e 01 00 00       	jmp    801306 <_main+0x12ce>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8011c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8011cd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8011d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d6:	89 d0                	mov    %edx,%eax
  8011d8:	01 c0                	add    %eax,%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	c1 e0 03             	shl    $0x3,%eax
  8011df:	01 c8                	add    %ecx,%eax
  8011e1:	8b 00                	mov    (%eax),%eax
  8011e3:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  8011e9:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  8011ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011fc:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801202:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  801208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120d:	39 c2                	cmp    %eax,%edx
  80120f:	75 17                	jne    801228 <_main+0x11f0>
				panic("free: page is not removed from WS");
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	68 f4 35 80 00       	push   $0x8035f4
  801219:	68 f8 00 00 00       	push   $0xf8
  80121e:	68 5c 34 80 00       	push   $0x80345c
  801223:	e8 c6 07 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  801228:	a1 20 40 80 00       	mov    0x804020,%eax
  80122d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801233:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801236:	89 d0                	mov    %edx,%eax
  801238:	01 c0                	add    %eax,%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c1 e0 03             	shl    $0x3,%eax
  80123f:	01 c8                	add    %ecx,%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  801249:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80124f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801254:	89 c2                	mov    %eax,%edx
  801256:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80125c:	89 c1                	mov    %eax,%ecx
  80125e:	c1 e9 1f             	shr    $0x1f,%ecx
  801261:	01 c8                	add    %ecx,%eax
  801263:	d1 f8                	sar    %eax
  801265:	89 c1                	mov    %eax,%ecx
  801267:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80126d:	01 c8                	add    %ecx,%eax
  80126f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  801275:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80127b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801280:	39 c2                	cmp    %eax,%edx
  801282:	75 17                	jne    80129b <_main+0x1263>
				panic("free: page is not removed from WS");
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	68 f4 35 80 00       	push   $0x8035f4
  80128c:	68 fa 00 00 00       	push   $0xfa
  801291:	68 5c 34 80 00       	push   $0x80345c
  801296:	e8 53 07 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  80129b:	a1 20 40 80 00       	mov    0x804020,%eax
  8012a0:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8012a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	01 c0                	add    %eax,%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c1 e0 03             	shl    $0x3,%eax
  8012b2:	01 c8                	add    %ecx,%eax
  8012b4:	8b 00                	mov    (%eax),%eax
  8012b6:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8012bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8012c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c7:	89 c1                	mov    %eax,%ecx
  8012c9:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  8012cf:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  8012dd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8012e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e8:	39 c1                	cmp    %eax,%ecx
  8012ea:	75 17                	jne    801303 <_main+0x12cb>
				panic("free: page is not removed from WS");
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 f4 35 80 00       	push   $0x8035f4
  8012f4:	68 fc 00 00 00       	push   $0xfc
  8012f9:	68 5c 34 80 00       	push   $0x80345c
  8012fe:	e8 eb 06 00 00       	call   8019ee <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801303:	ff 45 e4             	incl   -0x1c(%ebp)
  801306:	a1 20 40 80 00       	mov    0x804020,%eax
  80130b:	8b 50 74             	mov    0x74(%eax),%edx
  80130e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801311:	39 c2                	cmp    %eax,%edx
  801313:	0f 87 af fe ff ff    	ja     8011c8 <_main+0x1190>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  801319:	e8 37 19 00 00       	call   802c55 <sys_calculate_free_frames>
  80131e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801324:	e8 cc 19 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801329:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  80132f:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	50                   	push   %eax
  801339:	e8 49 17 00 00       	call   802a87 <free>
  80133e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  801341:	e8 af 19 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801346:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	83 f8 02             	cmp    $0x2,%eax
  801353:	74 17                	je     80136c <_main+0x1334>
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	68 6c 35 80 00       	push   $0x80356c
  80135d:	68 03 01 00 00       	push   $0x103
  801362:	68 5c 34 80 00       	push   $0x80345c
  801367:	e8 82 06 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80136c:	e8 e4 18 00 00       	call   802c55 <sys_calculate_free_frames>
  801371:	89 c2                	mov    %eax,%edx
  801373:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801379:	29 c2                	sub    %eax,%edx
  80137b:	89 d0                	mov    %edx,%eax
  80137d:	83 f8 02             	cmp    $0x2,%eax
  801380:	74 17                	je     801399 <_main+0x1361>
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	68 a8 35 80 00       	push   $0x8035a8
  80138a:	68 04 01 00 00       	push   $0x104
  80138f:	68 5c 34 80 00       	push   $0x80345c
  801394:	e8 55 06 00 00       	call   8019ee <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801399:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8013a0:	e9 d2 00 00 00       	jmp    801477 <_main+0x143f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8013a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8013aa:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8013b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  8013c6:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8013cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d1:	89 c2                	mov    %eax,%edx
  8013d3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013d9:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  8013df:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8013e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ea:	39 c2                	cmp    %eax,%edx
  8013ec:	75 17                	jne    801405 <_main+0x13cd>
				panic("free: page is not removed from WS");
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	68 f4 35 80 00       	push   $0x8035f4
  8013f6:	68 08 01 00 00       	push   $0x108
  8013fb:	68 5c 34 80 00       	push   $0x80345c
  801400:	e8 e9 05 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801405:	a1 20 40 80 00       	mov    0x804020,%eax
  80140a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801410:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801413:	89 d0                	mov    %edx,%eax
  801415:	01 c0                	add    %eax,%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c1 e0 03             	shl    $0x3,%eax
  80141c:	01 c8                	add    %ecx,%eax
  80141e:	8b 00                	mov    (%eax),%eax
  801420:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  801426:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80142c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801439:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801440:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801446:	01 c8                	add    %ecx,%eax
  801448:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  80144e:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801459:	39 c2                	cmp    %eax,%edx
  80145b:	75 17                	jne    801474 <_main+0x143c>
				panic("free: page is not removed from WS");
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	68 f4 35 80 00       	push   $0x8035f4
  801465:	68 0a 01 00 00       	push   $0x10a
  80146a:	68 5c 34 80 00       	push   $0x80345c
  80146f:	e8 7a 05 00 00       	call   8019ee <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801474:	ff 45 e4             	incl   -0x1c(%ebp)
  801477:	a1 20 40 80 00       	mov    0x804020,%eax
  80147c:	8b 50 74             	mov    0x74(%eax),%edx
  80147f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801482:	39 c2                	cmp    %eax,%edx
  801484:	0f 87 1b ff ff ff    	ja     8013a5 <_main+0x136d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80148a:	e8 c6 17 00 00       	call   802c55 <sys_calculate_free_frames>
  80148f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801495:	e8 5b 18 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  80149a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  8014a0:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	50                   	push   %eax
  8014aa:	e8 d8 15 00 00       	call   802a87 <free>
  8014af:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014b2:	e8 3e 18 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8014b7:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8014bd:	89 d1                	mov    %edx,%ecx
  8014bf:	29 c1                	sub    %eax,%ecx
  8014c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c4:	89 c2                	mov    %eax,%edx
  8014c6:	01 d2                	add    %edx,%edx
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	79 05                	jns    8014d3 <_main+0x149b>
  8014ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8014d3:	c1 f8 0c             	sar    $0xc,%eax
  8014d6:	39 c1                	cmp    %eax,%ecx
  8014d8:	74 17                	je     8014f1 <_main+0x14b9>
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	68 6c 35 80 00       	push   $0x80356c
  8014e2:	68 11 01 00 00       	push   $0x111
  8014e7:	68 5c 34 80 00       	push   $0x80345c
  8014ec:	e8 fd 04 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014f1:	e8 5f 17 00 00       	call   802c55 <sys_calculate_free_frames>
  8014f6:	89 c2                	mov    %eax,%edx
  8014f8:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014fe:	39 c2                	cmp    %eax,%edx
  801500:	74 17                	je     801519 <_main+0x14e1>
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 a8 35 80 00       	push   $0x8035a8
  80150a:	68 12 01 00 00       	push   $0x112
  80150f:	68 5c 34 80 00       	push   $0x80345c
  801514:	e8 d5 04 00 00       	call   8019ee <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  801519:	e8 37 17 00 00       	call   802c55 <sys_calculate_free_frames>
  80151e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801524:	e8 cc 17 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801529:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  80152f:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	50                   	push   %eax
  801539:	e8 49 15 00 00       	call   802a87 <free>
  80153e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  801541:	e8 af 17 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801546:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80154c:	29 c2                	sub    %eax,%edx
  80154e:	89 d0                	mov    %edx,%eax
  801550:	83 f8 01             	cmp    $0x1,%eax
  801553:	74 17                	je     80156c <_main+0x1534>
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	68 6c 35 80 00       	push   $0x80356c
  80155d:	68 18 01 00 00       	push   $0x118
  801562:	68 5c 34 80 00       	push   $0x80345c
  801567:	e8 82 04 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80156c:	e8 e4 16 00 00       	call   802c55 <sys_calculate_free_frames>
  801571:	89 c2                	mov    %eax,%edx
  801573:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801579:	29 c2                	sub    %eax,%edx
  80157b:	89 d0                	mov    %edx,%eax
  80157d:	83 f8 02             	cmp    $0x2,%eax
  801580:	74 17                	je     801599 <_main+0x1561>
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 a8 35 80 00       	push   $0x8035a8
  80158a:	68 19 01 00 00       	push   $0x119
  80158f:	68 5c 34 80 00       	push   $0x80345c
  801594:	e8 55 04 00 00       	call   8019ee <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801599:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8015a0:	e9 c9 00 00 00       	jmp    80166e <_main+0x1636>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  8015a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8015aa:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8015b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015b3:	89 d0                	mov    %edx,%eax
  8015b5:	01 c0                	add    %eax,%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c1 e0 03             	shl    $0x3,%eax
  8015bc:	01 c8                	add    %ecx,%eax
  8015be:	8b 00                	mov    (%eax),%eax
  8015c0:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  8015c6:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8015cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8015d6:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  8015dc:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8015e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e7:	39 c2                	cmp    %eax,%edx
  8015e9:	75 17                	jne    801602 <_main+0x15ca>
				panic("free: page is not removed from WS");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 f4 35 80 00       	push   $0x8035f4
  8015f3:	68 1d 01 00 00       	push   $0x11d
  8015f8:	68 5c 34 80 00       	push   $0x80345c
  8015fd:	e8 ec 03 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801602:	a1 20 40 80 00       	mov    0x804020,%eax
  801607:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80160d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801610:	89 d0                	mov    %edx,%eax
  801612:	01 c0                	add    %eax,%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	c1 e0 03             	shl    $0x3,%eax
  801619:	01 c8                	add    %ecx,%eax
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801623:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801629:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80162e:	89 c2                	mov    %eax,%edx
  801630:	8b 45 88             	mov    -0x78(%ebp),%eax
  801633:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80163a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80163d:	01 c8                	add    %ecx,%eax
  80163f:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  801645:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  80164b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801650:	39 c2                	cmp    %eax,%edx
  801652:	75 17                	jne    80166b <_main+0x1633>
				panic("free: page is not removed from WS");
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	68 f4 35 80 00       	push   $0x8035f4
  80165c:	68 1f 01 00 00       	push   $0x11f
  801661:	68 5c 34 80 00       	push   $0x80345c
  801666:	e8 83 03 00 00       	call   8019ee <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80166b:	ff 45 e4             	incl   -0x1c(%ebp)
  80166e:	a1 20 40 80 00       	mov    0x804020,%eax
  801673:	8b 50 74             	mov    0x74(%eax),%edx
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	39 c2                	cmp    %eax,%edx
  80167b:	0f 87 24 ff ff ff    	ja     8015a5 <_main+0x156d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  801681:	e8 cf 15 00 00       	call   802c55 <sys_calculate_free_frames>
  801686:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80168c:	e8 64 16 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801691:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  801697:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  80169d:	83 ec 0c             	sub    $0xc,%esp
  8016a0:	50                   	push   %eax
  8016a1:	e8 e1 13 00 00       	call   802a87 <free>
  8016a6:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8016a9:	e8 47 16 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  8016ae:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	83 f8 01             	cmp    $0x1,%eax
  8016bb:	74 17                	je     8016d4 <_main+0x169c>
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 6c 35 80 00       	push   $0x80356c
  8016c5:	68 26 01 00 00       	push   $0x126
  8016ca:	68 5c 34 80 00       	push   $0x80345c
  8016cf:	e8 1a 03 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8016d4:	e8 7c 15 00 00       	call   802c55 <sys_calculate_free_frames>
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016e1:	39 c2                	cmp    %eax,%edx
  8016e3:	74 17                	je     8016fc <_main+0x16c4>
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 a8 35 80 00       	push   $0x8035a8
  8016ed:	68 27 01 00 00       	push   $0x127
  8016f2:	68 5c 34 80 00       	push   $0x80345c
  8016f7:	e8 f2 02 00 00       	call   8019ee <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  8016fc:	e8 54 15 00 00       	call   802c55 <sys_calculate_free_frames>
  801701:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801707:	e8 e9 15 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  80170c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801712:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	50                   	push   %eax
  80171c:	e8 66 13 00 00       	call   802a87 <free>
  801721:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
  801724:	e8 cc 15 00 00       	call   802cf5 <sys_pf_calculate_allocated_pages>
  801729:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80172f:	29 c2                	sub    %eax,%edx
  801731:	89 d0                	mov    %edx,%eax
  801733:	83 f8 04             	cmp    $0x4,%eax
  801736:	74 17                	je     80174f <_main+0x1717>
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 6c 35 80 00       	push   $0x80356c
  801740:	68 2e 01 00 00       	push   $0x12e
  801745:	68 5c 34 80 00       	push   $0x80345c
  80174a:	e8 9f 02 00 00       	call   8019ee <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80174f:	e8 01 15 00 00       	call   802c55 <sys_calculate_free_frames>
  801754:	89 c2                	mov    %eax,%edx
  801756:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80175c:	29 c2                	sub    %eax,%edx
  80175e:	89 d0                	mov    %edx,%eax
  801760:	83 f8 03             	cmp    $0x3,%eax
  801763:	74 17                	je     80177c <_main+0x1744>
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 a8 35 80 00       	push   $0x8035a8
  80176d:	68 2f 01 00 00       	push   $0x12f
  801772:	68 5c 34 80 00       	push   $0x80345c
  801777:	e8 72 02 00 00       	call   8019ee <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80177c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801783:	e9 c6 00 00 00       	jmp    80184e <_main+0x1816>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  801788:	a1 20 40 80 00       	mov    0x804020,%eax
  80178d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801796:	89 d0                	mov    %edx,%eax
  801798:	01 c0                	add    %eax,%eax
  80179a:	01 d0                	add    %edx,%eax
  80179c:	c1 e0 03             	shl    $0x3,%eax
  80179f:	01 c8                	add    %ecx,%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8017a9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8017af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8017b9:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  8017bf:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8017c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ca:	39 c2                	cmp    %eax,%edx
  8017cc:	75 17                	jne    8017e5 <_main+0x17ad>
				panic("free: page is not removed from WS");
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 f4 35 80 00       	push   $0x8035f4
  8017d6:	68 33 01 00 00       	push   $0x133
  8017db:	68 5c 34 80 00       	push   $0x80345c
  8017e0:	e8 09 02 00 00       	call   8019ee <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8017e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8017ea:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8017f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	01 c0                	add    %eax,%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	c1 e0 03             	shl    $0x3,%eax
  8017fc:	01 c8                	add    %ecx,%eax
  8017fe:	8b 00                	mov    (%eax),%eax
  801800:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801806:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80180c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801811:	89 c2                	mov    %eax,%edx
  801813:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801816:	01 c0                	add    %eax,%eax
  801818:	89 c1                	mov    %eax,%ecx
  80181a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80181d:	01 c8                	add    %ecx,%eax
  80181f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801825:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80182b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801830:	39 c2                	cmp    %eax,%edx
  801832:	75 17                	jne    80184b <_main+0x1813>
				panic("free: page is not removed from WS");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 f4 35 80 00       	push   $0x8035f4
  80183c:	68 35 01 00 00       	push   $0x135
  801841:	68 5c 34 80 00       	push   $0x80345c
  801846:	e8 a3 01 00 00       	call   8019ee <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80184b:	ff 45 e4             	incl   -0x1c(%ebp)
  80184e:	a1 20 40 80 00       	mov    0x804020,%eax
  801853:	8b 50 74             	mov    0x74(%eax),%edx
  801856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801859:	39 c2                	cmp    %eax,%edx
  80185b:	0f 87 27 ff ff ff    	ja     801788 <_main+0x1750>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
  801861:	e8 ef 13 00 00       	call   802c55 <sys_calculate_free_frames>
  801866:	8d 50 04             	lea    0x4(%eax),%edx
  801869:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80186c:	39 c2                	cmp    %eax,%edx
  80186e:	74 17                	je     801887 <_main+0x184f>
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 18 36 80 00       	push   $0x803618
  801878:	68 38 01 00 00       	push   $0x138
  80187d:	68 5c 34 80 00       	push   $0x80345c
  801882:	e8 67 01 00 00       	call   8019ee <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	68 4c 36 80 00       	push   $0x80364c
  80188f:	e8 0e 04 00 00       	call   801ca2 <cprintf>
  801894:	83 c4 10             	add    $0x10,%esp

	return;
  801897:	90                   	nop
}
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    

0080189f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8018a5:	e8 8b 16 00 00       	call   802f35 <sys_getenvindex>
  8018aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	01 c0                	add    %eax,%eax
  8018b4:	01 d0                	add    %edx,%eax
  8018b6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8018bd:	01 c8                	add    %ecx,%eax
  8018bf:	c1 e0 02             	shl    $0x2,%eax
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8018cb:	01 c8                	add    %ecx,%eax
  8018cd:	c1 e0 02             	shl    $0x2,%eax
  8018d0:	01 d0                	add    %edx,%eax
  8018d2:	c1 e0 02             	shl    $0x2,%eax
  8018d5:	01 d0                	add    %edx,%eax
  8018d7:	c1 e0 03             	shl    $0x3,%eax
  8018da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018df:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8018e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8018e9:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8018ef:	84 c0                	test   %al,%al
  8018f1:	74 0f                	je     801902 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8018f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8018f8:	05 18 da 01 00       	add    $0x1da18,%eax
  8018fd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801902:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801906:	7e 0a                	jle    801912 <libmain+0x73>
		binaryname = argv[0];
  801908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190b:	8b 00                	mov    (%eax),%eax
  80190d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	e8 18 e7 ff ff       	call   800038 <_main>
  801920:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  801923:	e8 1a 14 00 00       	call   802d42 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	68 a0 36 80 00       	push   $0x8036a0
  801930:	e8 6d 03 00 00       	call   801ca2 <cprintf>
  801935:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801938:	a1 20 40 80 00       	mov    0x804020,%eax
  80193d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  801943:	a1 20 40 80 00       	mov    0x804020,%eax
  801948:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	52                   	push   %edx
  801952:	50                   	push   %eax
  801953:	68 c8 36 80 00       	push   $0x8036c8
  801958:	e8 45 03 00 00       	call   801ca2 <cprintf>
  80195d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801960:	a1 20 40 80 00       	mov    0x804020,%eax
  801965:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80196b:	a1 20 40 80 00       	mov    0x804020,%eax
  801970:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  801976:	a1 20 40 80 00       	mov    0x804020,%eax
  80197b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  801981:	51                   	push   %ecx
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	68 f0 36 80 00       	push   $0x8036f0
  801989:	e8 14 03 00 00       	call   801ca2 <cprintf>
  80198e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801991:	a1 20 40 80 00       	mov    0x804020,%eax
  801996:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	50                   	push   %eax
  8019a0:	68 48 37 80 00       	push   $0x803748
  8019a5:	e8 f8 02 00 00       	call   801ca2 <cprintf>
  8019aa:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8019ad:	83 ec 0c             	sub    $0xc,%esp
  8019b0:	68 a0 36 80 00       	push   $0x8036a0
  8019b5:	e8 e8 02 00 00       	call   801ca2 <cprintf>
  8019ba:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019bd:	e8 9a 13 00 00       	call   802d5c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8019c2:	e8 19 00 00 00       	call   8019e0 <exit>
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	6a 00                	push   $0x0
  8019d5:	e8 27 15 00 00       	call   802f01 <sys_destroy_env>
  8019da:	83 c4 10             	add    $0x10,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <exit>:

void
exit(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8019e6:	e8 7c 15 00 00       	call   802f67 <sys_exit_env>
}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8019f7:	83 c0 04             	add    $0x4,%eax
  8019fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019fd:	a1 58 b2 82 00       	mov    0x82b258,%eax
  801a02:	85 c0                	test   %eax,%eax
  801a04:	74 16                	je     801a1c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a06:	a1 58 b2 82 00       	mov    0x82b258,%eax
  801a0b:	83 ec 08             	sub    $0x8,%esp
  801a0e:	50                   	push   %eax
  801a0f:	68 5c 37 80 00       	push   $0x80375c
  801a14:	e8 89 02 00 00       	call   801ca2 <cprintf>
  801a19:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a1c:	a1 00 40 80 00       	mov    0x804000,%eax
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	50                   	push   %eax
  801a28:	68 61 37 80 00       	push   $0x803761
  801a2d:	e8 70 02 00 00       	call   801ca2 <cprintf>
  801a32:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	50                   	push   %eax
  801a3f:	e8 f3 01 00 00       	call   801c37 <vcprintf>
  801a44:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a47:	83 ec 08             	sub    $0x8,%esp
  801a4a:	6a 00                	push   $0x0
  801a4c:	68 7d 37 80 00       	push   $0x80377d
  801a51:	e8 e1 01 00 00       	call   801c37 <vcprintf>
  801a56:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a59:	e8 82 ff ff ff       	call   8019e0 <exit>

	// should not return here
	while (1) ;
  801a5e:	eb fe                	jmp    801a5e <_panic+0x70>

00801a60 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a66:	a1 20 40 80 00       	mov    0x804020,%eax
  801a6b:	8b 50 74             	mov    0x74(%eax),%edx
  801a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a71:	39 c2                	cmp    %eax,%edx
  801a73:	74 14                	je     801a89 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	68 80 37 80 00       	push   $0x803780
  801a7d:	6a 26                	push   $0x26
  801a7f:	68 cc 37 80 00       	push   $0x8037cc
  801a84:	e8 65 ff ff ff       	call   8019ee <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a97:	e9 c2 00 00 00       	jmp    801b5e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	8b 00                	mov    (%eax),%eax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	75 08                	jne    801ab9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801ab1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ab4:	e9 a2 00 00 00       	jmp    801b5b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801ab9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ac7:	eb 69                	jmp    801b32 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ac9:	a1 20 40 80 00       	mov    0x804020,%eax
  801ace:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801ad4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ad7:	89 d0                	mov    %edx,%eax
  801ad9:	01 c0                	add    %eax,%eax
  801adb:	01 d0                	add    %edx,%eax
  801add:	c1 e0 03             	shl    $0x3,%eax
  801ae0:	01 c8                	add    %ecx,%eax
  801ae2:	8a 40 04             	mov    0x4(%eax),%al
  801ae5:	84 c0                	test   %al,%al
  801ae7:	75 46                	jne    801b2f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ae9:	a1 20 40 80 00       	mov    0x804020,%eax
  801aee:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801af4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af7:	89 d0                	mov    %edx,%eax
  801af9:	01 c0                	add    %eax,%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	c1 e0 03             	shl    $0x3,%eax
  801b00:	01 c8                	add    %ecx,%eax
  801b02:	8b 00                	mov    (%eax),%eax
  801b04:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b0f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	01 c8                	add    %ecx,%eax
  801b20:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b22:	39 c2                	cmp    %eax,%edx
  801b24:	75 09                	jne    801b2f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801b26:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b2d:	eb 12                	jmp    801b41 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b2f:	ff 45 e8             	incl   -0x18(%ebp)
  801b32:	a1 20 40 80 00       	mov    0x804020,%eax
  801b37:	8b 50 74             	mov    0x74(%eax),%edx
  801b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3d:	39 c2                	cmp    %eax,%edx
  801b3f:	77 88                	ja     801ac9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b45:	75 14                	jne    801b5b <CheckWSWithoutLastIndex+0xfb>
			panic(
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	68 d8 37 80 00       	push   $0x8037d8
  801b4f:	6a 3a                	push   $0x3a
  801b51:	68 cc 37 80 00       	push   $0x8037cc
  801b56:	e8 93 fe ff ff       	call   8019ee <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b5b:	ff 45 f0             	incl   -0x10(%ebp)
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b64:	0f 8c 32 ff ff ff    	jl     801a9c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b78:	eb 26                	jmp    801ba0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b7a:	a1 20 40 80 00       	mov    0x804020,%eax
  801b7f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801b85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b88:	89 d0                	mov    %edx,%eax
  801b8a:	01 c0                	add    %eax,%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	c1 e0 03             	shl    $0x3,%eax
  801b91:	01 c8                	add    %ecx,%eax
  801b93:	8a 40 04             	mov    0x4(%eax),%al
  801b96:	3c 01                	cmp    $0x1,%al
  801b98:	75 03                	jne    801b9d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801b9a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b9d:	ff 45 e0             	incl   -0x20(%ebp)
  801ba0:	a1 20 40 80 00       	mov    0x804020,%eax
  801ba5:	8b 50 74             	mov    0x74(%eax),%edx
  801ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bab:	39 c2                	cmp    %eax,%edx
  801bad:	77 cb                	ja     801b7a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bb5:	74 14                	je     801bcb <CheckWSWithoutLastIndex+0x16b>
		panic(
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	68 2c 38 80 00       	push   $0x80382c
  801bbf:	6a 44                	push   $0x44
  801bc1:	68 cc 37 80 00       	push   $0x8037cc
  801bc6:	e8 23 fe ff ff       	call   8019ee <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801bcb:	90                   	nop
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd7:	8b 00                	mov    (%eax),%eax
  801bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	89 0a                	mov    %ecx,(%edx)
  801be1:	8b 55 08             	mov    0x8(%ebp),%edx
  801be4:	88 d1                	mov    %dl,%cl
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf0:	8b 00                	mov    (%eax),%eax
  801bf2:	3d ff 00 00 00       	cmp    $0xff,%eax
  801bf7:	75 2c                	jne    801c25 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801bf9:	a0 24 40 80 00       	mov    0x804024,%al
  801bfe:	0f b6 c0             	movzbl %al,%eax
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 12                	mov    (%edx),%edx
  801c06:	89 d1                	mov    %edx,%ecx
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	83 c2 08             	add    $0x8,%edx
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	50                   	push   %eax
  801c12:	51                   	push   %ecx
  801c13:	52                   	push   %edx
  801c14:	e8 7b 0f 00 00       	call   802b94 <sys_cputs>
  801c19:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c28:	8b 40 04             	mov    0x4(%eax),%eax
  801c2b:	8d 50 01             	lea    0x1(%eax),%edx
  801c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c31:	89 50 04             	mov    %edx,0x4(%eax)
}
  801c34:	90                   	nop
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c40:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c47:	00 00 00 
	b.cnt = 0;
  801c4a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c51:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c60:	50                   	push   %eax
  801c61:	68 ce 1b 80 00       	push   $0x801bce
  801c66:	e8 11 02 00 00       	call   801e7c <vprintfmt>
  801c6b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801c6e:	a0 24 40 80 00       	mov    0x804024,%al
  801c73:	0f b6 c0             	movzbl %al,%eax
  801c76:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	50                   	push   %eax
  801c80:	52                   	push   %edx
  801c81:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c87:	83 c0 08             	add    $0x8,%eax
  801c8a:	50                   	push   %eax
  801c8b:	e8 04 0f 00 00       	call   802b94 <sys_cputs>
  801c90:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801c93:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  801c9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <cprintf>:

int cprintf(const char *fmt, ...) {
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801ca8:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801caf:	8d 45 0c             	lea    0xc(%ebp),%eax
  801cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbe:	50                   	push   %eax
  801cbf:	e8 73 ff ff ff       	call   801c37 <vcprintf>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801cd5:	e8 68 10 00 00       	call   802d42 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cda:	8d 45 0c             	lea    0xc(%ebp),%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	83 ec 08             	sub    $0x8,%esp
  801ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce9:	50                   	push   %eax
  801cea:	e8 48 ff ff ff       	call   801c37 <vcprintf>
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801cf5:	e8 62 10 00 00       	call   802d5c <sys_enable_interrupt>
	return cnt;
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	53                   	push   %ebx
  801d03:	83 ec 14             	sub    $0x14,%esp
  801d06:	8b 45 10             	mov    0x10(%ebp),%eax
  801d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d12:	8b 45 18             	mov    0x18(%ebp),%eax
  801d15:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801d1d:	77 55                	ja     801d74 <printnum+0x75>
  801d1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801d22:	72 05                	jb     801d29 <printnum+0x2a>
  801d24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d27:	77 4b                	ja     801d74 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d29:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801d2c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801d2f:	8b 45 18             	mov    0x18(%ebp),%eax
  801d32:	ba 00 00 00 00       	mov    $0x0,%edx
  801d37:	52                   	push   %edx
  801d38:	50                   	push   %eax
  801d39:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d3f:	e8 84 14 00 00       	call   8031c8 <__udivdi3>
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	ff 75 20             	pushl  0x20(%ebp)
  801d4d:	53                   	push   %ebx
  801d4e:	ff 75 18             	pushl  0x18(%ebp)
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	ff 75 08             	pushl  0x8(%ebp)
  801d59:	e8 a1 ff ff ff       	call   801cff <printnum>
  801d5e:	83 c4 20             	add    $0x20,%esp
  801d61:	eb 1a                	jmp    801d7d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 20             	pushl  0x20(%ebp)
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	ff d0                	call   *%eax
  801d71:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801d74:	ff 4d 1c             	decl   0x1c(%ebp)
  801d77:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801d7b:	7f e6                	jg     801d63 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d7d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801d80:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8b:	53                   	push   %ebx
  801d8c:	51                   	push   %ecx
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	e8 44 15 00 00       	call   8032d8 <__umoddi3>
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	05 94 3a 80 00       	add    $0x803a94,%eax
  801d9c:	8a 00                	mov    (%eax),%al
  801d9e:	0f be c0             	movsbl %al,%eax
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	50                   	push   %eax
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	ff d0                	call   *%eax
  801dad:	83 c4 10             	add    $0x10,%esp
}
  801db0:	90                   	nop
  801db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801db9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801dbd:	7e 1c                	jle    801ddb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8b 00                	mov    (%eax),%eax
  801dc4:	8d 50 08             	lea    0x8(%eax),%edx
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	89 10                	mov    %edx,(%eax)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 00                	mov    (%eax),%eax
  801dd1:	83 e8 08             	sub    $0x8,%eax
  801dd4:	8b 50 04             	mov    0x4(%eax),%edx
  801dd7:	8b 00                	mov    (%eax),%eax
  801dd9:	eb 40                	jmp    801e1b <getuint+0x65>
	else if (lflag)
  801ddb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ddf:	74 1e                	je     801dff <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	8b 00                	mov    (%eax),%eax
  801de6:	8d 50 04             	lea    0x4(%eax),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	89 10                	mov    %edx,(%eax)
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	8b 00                	mov    (%eax),%eax
  801df3:	83 e8 04             	sub    $0x4,%eax
  801df6:	8b 00                	mov    (%eax),%eax
  801df8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfd:	eb 1c                	jmp    801e1b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	8b 00                	mov    (%eax),%eax
  801e04:	8d 50 04             	lea    0x4(%eax),%edx
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	89 10                	mov    %edx,(%eax)
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	8b 00                	mov    (%eax),%eax
  801e11:	83 e8 04             	sub    $0x4,%eax
  801e14:	8b 00                	mov    (%eax),%eax
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801e20:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801e24:	7e 1c                	jle    801e42 <getint+0x25>
		return va_arg(*ap, long long);
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	8b 00                	mov    (%eax),%eax
  801e2b:	8d 50 08             	lea    0x8(%eax),%edx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	89 10                	mov    %edx,(%eax)
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	8b 00                	mov    (%eax),%eax
  801e38:	83 e8 08             	sub    $0x8,%eax
  801e3b:	8b 50 04             	mov    0x4(%eax),%edx
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	eb 38                	jmp    801e7a <getint+0x5d>
	else if (lflag)
  801e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e46:	74 1a                	je     801e62 <getint+0x45>
		return va_arg(*ap, long);
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	8b 00                	mov    (%eax),%eax
  801e4d:	8d 50 04             	lea    0x4(%eax),%edx
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	89 10                	mov    %edx,(%eax)
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	83 e8 04             	sub    $0x4,%eax
  801e5d:	8b 00                	mov    (%eax),%eax
  801e5f:	99                   	cltd   
  801e60:	eb 18                	jmp    801e7a <getint+0x5d>
	else
		return va_arg(*ap, int);
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8b 00                	mov    (%eax),%eax
  801e67:	8d 50 04             	lea    0x4(%eax),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	89 10                	mov    %edx,(%eax)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	8b 00                	mov    (%eax),%eax
  801e74:	83 e8 04             	sub    $0x4,%eax
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	99                   	cltd   
}
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    

00801e7c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e84:	eb 17                	jmp    801e9d <vprintfmt+0x21>
			if (ch == '\0')
  801e86:	85 db                	test   %ebx,%ebx
  801e88:	0f 84 af 03 00 00    	je     80223d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801e8e:	83 ec 08             	sub    $0x8,%esp
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	53                   	push   %ebx
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	ff d0                	call   *%eax
  801e9a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 10             	mov    %edx,0x10(%ebp)
  801ea6:	8a 00                	mov    (%eax),%al
  801ea8:	0f b6 d8             	movzbl %al,%ebx
  801eab:	83 fb 25             	cmp    $0x25,%ebx
  801eae:	75 d6                	jne    801e86 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801eb0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801eb4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ebb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ec2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ec9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed3:	8d 50 01             	lea    0x1(%eax),%edx
  801ed6:	89 55 10             	mov    %edx,0x10(%ebp)
  801ed9:	8a 00                	mov    (%eax),%al
  801edb:	0f b6 d8             	movzbl %al,%ebx
  801ede:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ee1:	83 f8 55             	cmp    $0x55,%eax
  801ee4:	0f 87 2b 03 00 00    	ja     802215 <vprintfmt+0x399>
  801eea:	8b 04 85 b8 3a 80 00 	mov    0x803ab8(,%eax,4),%eax
  801ef1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ef3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ef7:	eb d7                	jmp    801ed0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ef9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801efd:	eb d1                	jmp    801ed0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801eff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801f06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f09:	89 d0                	mov    %edx,%eax
  801f0b:	c1 e0 02             	shl    $0x2,%eax
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	01 c0                	add    %eax,%eax
  801f12:	01 d8                	add    %ebx,%eax
  801f14:	83 e8 30             	sub    $0x30,%eax
  801f17:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1d:	8a 00                	mov    (%eax),%al
  801f1f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801f22:	83 fb 2f             	cmp    $0x2f,%ebx
  801f25:	7e 3e                	jle    801f65 <vprintfmt+0xe9>
  801f27:	83 fb 39             	cmp    $0x39,%ebx
  801f2a:	7f 39                	jg     801f65 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801f2c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801f2f:	eb d5                	jmp    801f06 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801f31:	8b 45 14             	mov    0x14(%ebp),%eax
  801f34:	83 c0 04             	add    $0x4,%eax
  801f37:	89 45 14             	mov    %eax,0x14(%ebp)
  801f3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3d:	83 e8 04             	sub    $0x4,%eax
  801f40:	8b 00                	mov    (%eax),%eax
  801f42:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801f45:	eb 1f                	jmp    801f66 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801f47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f4b:	79 83                	jns    801ed0 <vprintfmt+0x54>
				width = 0;
  801f4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801f54:	e9 77 ff ff ff       	jmp    801ed0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801f59:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801f60:	e9 6b ff ff ff       	jmp    801ed0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801f65:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801f66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f6a:	0f 89 60 ff ff ff    	jns    801ed0 <vprintfmt+0x54>
				width = precision, precision = -1;
  801f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f76:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801f7d:	e9 4e ff ff ff       	jmp    801ed0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f82:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801f85:	e9 46 ff ff ff       	jmp    801ed0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8d:	83 c0 04             	add    $0x4,%eax
  801f90:	89 45 14             	mov    %eax,0x14(%ebp)
  801f93:	8b 45 14             	mov    0x14(%ebp),%eax
  801f96:	83 e8 04             	sub    $0x4,%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	50                   	push   %eax
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	ff d0                	call   *%eax
  801fa7:	83 c4 10             	add    $0x10,%esp
			break;
  801faa:	e9 89 02 00 00       	jmp    802238 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801faf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb2:	83 c0 04             	add    $0x4,%eax
  801fb5:	89 45 14             	mov    %eax,0x14(%ebp)
  801fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbb:	83 e8 04             	sub    $0x4,%eax
  801fbe:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801fc0:	85 db                	test   %ebx,%ebx
  801fc2:	79 02                	jns    801fc6 <vprintfmt+0x14a>
				err = -err;
  801fc4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801fc6:	83 fb 64             	cmp    $0x64,%ebx
  801fc9:	7f 0b                	jg     801fd6 <vprintfmt+0x15a>
  801fcb:	8b 34 9d 00 39 80 00 	mov    0x803900(,%ebx,4),%esi
  801fd2:	85 f6                	test   %esi,%esi
  801fd4:	75 19                	jne    801fef <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801fd6:	53                   	push   %ebx
  801fd7:	68 a5 3a 80 00       	push   $0x803aa5
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	e8 5e 02 00 00       	call   802245 <printfmt>
  801fe7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801fea:	e9 49 02 00 00       	jmp    802238 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801fef:	56                   	push   %esi
  801ff0:	68 ae 3a 80 00       	push   $0x803aae
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	e8 45 02 00 00       	call   802245 <printfmt>
  802000:	83 c4 10             	add    $0x10,%esp
			break;
  802003:	e9 30 02 00 00       	jmp    802238 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802008:	8b 45 14             	mov    0x14(%ebp),%eax
  80200b:	83 c0 04             	add    $0x4,%eax
  80200e:	89 45 14             	mov    %eax,0x14(%ebp)
  802011:	8b 45 14             	mov    0x14(%ebp),%eax
  802014:	83 e8 04             	sub    $0x4,%eax
  802017:	8b 30                	mov    (%eax),%esi
  802019:	85 f6                	test   %esi,%esi
  80201b:	75 05                	jne    802022 <vprintfmt+0x1a6>
				p = "(null)";
  80201d:	be b1 3a 80 00       	mov    $0x803ab1,%esi
			if (width > 0 && padc != '-')
  802022:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802026:	7e 6d                	jle    802095 <vprintfmt+0x219>
  802028:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80202c:	74 67                	je     802095 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80202e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802031:	83 ec 08             	sub    $0x8,%esp
  802034:	50                   	push   %eax
  802035:	56                   	push   %esi
  802036:	e8 0c 03 00 00       	call   802347 <strnlen>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  802041:	eb 16                	jmp    802059 <vprintfmt+0x1dd>
					putch(padc, putdat);
  802043:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  802047:	83 ec 08             	sub    $0x8,%esp
  80204a:	ff 75 0c             	pushl  0xc(%ebp)
  80204d:	50                   	push   %eax
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	ff d0                	call   *%eax
  802053:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802056:	ff 4d e4             	decl   -0x1c(%ebp)
  802059:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80205d:	7f e4                	jg     802043 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80205f:	eb 34                	jmp    802095 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  802061:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802065:	74 1c                	je     802083 <vprintfmt+0x207>
  802067:	83 fb 1f             	cmp    $0x1f,%ebx
  80206a:	7e 05                	jle    802071 <vprintfmt+0x1f5>
  80206c:	83 fb 7e             	cmp    $0x7e,%ebx
  80206f:	7e 12                	jle    802083 <vprintfmt+0x207>
					putch('?', putdat);
  802071:	83 ec 08             	sub    $0x8,%esp
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	6a 3f                	push   $0x3f
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	ff d0                	call   *%eax
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	eb 0f                	jmp    802092 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	53                   	push   %ebx
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	ff d0                	call   *%eax
  80208f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802092:	ff 4d e4             	decl   -0x1c(%ebp)
  802095:	89 f0                	mov    %esi,%eax
  802097:	8d 70 01             	lea    0x1(%eax),%esi
  80209a:	8a 00                	mov    (%eax),%al
  80209c:	0f be d8             	movsbl %al,%ebx
  80209f:	85 db                	test   %ebx,%ebx
  8020a1:	74 24                	je     8020c7 <vprintfmt+0x24b>
  8020a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020a7:	78 b8                	js     802061 <vprintfmt+0x1e5>
  8020a9:	ff 4d e0             	decl   -0x20(%ebp)
  8020ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020b0:	79 af                	jns    802061 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8020b2:	eb 13                	jmp    8020c7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8020b4:	83 ec 08             	sub    $0x8,%esp
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	6a 20                	push   $0x20
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	ff d0                	call   *%eax
  8020c1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8020c4:	ff 4d e4             	decl   -0x1c(%ebp)
  8020c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020cb:	7f e7                	jg     8020b4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8020cd:	e9 66 01 00 00       	jmp    802238 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8020d2:	83 ec 08             	sub    $0x8,%esp
  8020d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8020d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8020db:	50                   	push   %eax
  8020dc:	e8 3c fd ff ff       	call   801e1d <getint>
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f0:	85 d2                	test   %edx,%edx
  8020f2:	79 23                	jns    802117 <vprintfmt+0x29b>
				putch('-', putdat);
  8020f4:	83 ec 08             	sub    $0x8,%esp
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	6a 2d                	push   $0x2d
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	ff d0                	call   *%eax
  802101:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210a:	f7 d8                	neg    %eax
  80210c:	83 d2 00             	adc    $0x0,%edx
  80210f:	f7 da                	neg    %edx
  802111:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802114:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802117:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80211e:	e9 bc 00 00 00       	jmp    8021df <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802123:	83 ec 08             	sub    $0x8,%esp
  802126:	ff 75 e8             	pushl  -0x18(%ebp)
  802129:	8d 45 14             	lea    0x14(%ebp),%eax
  80212c:	50                   	push   %eax
  80212d:	e8 84 fc ff ff       	call   801db6 <getuint>
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802138:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80213b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802142:	e9 98 00 00 00       	jmp    8021df <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802147:	83 ec 08             	sub    $0x8,%esp
  80214a:	ff 75 0c             	pushl  0xc(%ebp)
  80214d:	6a 58                	push   $0x58
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	ff d0                	call   *%eax
  802154:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802157:	83 ec 08             	sub    $0x8,%esp
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	6a 58                	push   $0x58
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	ff d0                	call   *%eax
  802164:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802167:	83 ec 08             	sub    $0x8,%esp
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	6a 58                	push   $0x58
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	ff d0                	call   *%eax
  802174:	83 c4 10             	add    $0x10,%esp
			break;
  802177:	e9 bc 00 00 00       	jmp    802238 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80217c:	83 ec 08             	sub    $0x8,%esp
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	6a 30                	push   $0x30
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	ff d0                	call   *%eax
  802189:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80218c:	83 ec 08             	sub    $0x8,%esp
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	6a 78                	push   $0x78
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	ff d0                	call   *%eax
  802199:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80219c:	8b 45 14             	mov    0x14(%ebp),%eax
  80219f:	83 c0 04             	add    $0x4,%eax
  8021a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8021a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a8:	83 e8 04             	sub    $0x4,%eax
  8021ab:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8021ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8021b7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8021be:	eb 1f                	jmp    8021df <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8021c0:	83 ec 08             	sub    $0x8,%esp
  8021c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8021c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	e8 e7 fb ff ff       	call   801db6 <getuint>
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8021d8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8021df:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8021e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	52                   	push   %edx
  8021ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021ed:	50                   	push   %eax
  8021ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	e8 00 fb ff ff       	call   801cff <printnum>
  8021ff:	83 c4 20             	add    $0x20,%esp
			break;
  802202:	eb 34                	jmp    802238 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802204:	83 ec 08             	sub    $0x8,%esp
  802207:	ff 75 0c             	pushl  0xc(%ebp)
  80220a:	53                   	push   %ebx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	ff d0                	call   *%eax
  802210:	83 c4 10             	add    $0x10,%esp
			break;
  802213:	eb 23                	jmp    802238 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802215:	83 ec 08             	sub    $0x8,%esp
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	6a 25                	push   $0x25
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	ff d0                	call   *%eax
  802222:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802225:	ff 4d 10             	decl   0x10(%ebp)
  802228:	eb 03                	jmp    80222d <vprintfmt+0x3b1>
  80222a:	ff 4d 10             	decl   0x10(%ebp)
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	48                   	dec    %eax
  802231:	8a 00                	mov    (%eax),%al
  802233:	3c 25                	cmp    $0x25,%al
  802235:	75 f3                	jne    80222a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802237:	90                   	nop
		}
	}
  802238:	e9 47 fc ff ff       	jmp    801e84 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80223d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80223e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80224b:	8d 45 10             	lea    0x10(%ebp),%eax
  80224e:	83 c0 04             	add    $0x4,%eax
  802251:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802254:	8b 45 10             	mov    0x10(%ebp),%eax
  802257:	ff 75 f4             	pushl  -0xc(%ebp)
  80225a:	50                   	push   %eax
  80225b:	ff 75 0c             	pushl  0xc(%ebp)
  80225e:	ff 75 08             	pushl  0x8(%ebp)
  802261:	e8 16 fc ff ff       	call   801e7c <vprintfmt>
  802266:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80226f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	8d 50 01             	lea    0x1(%eax),%edx
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80227e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802281:	8b 10                	mov    (%eax),%edx
  802283:	8b 45 0c             	mov    0xc(%ebp),%eax
  802286:	8b 40 04             	mov    0x4(%eax),%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	73 12                	jae    80229f <sprintputch+0x33>
		*b->buf++ = ch;
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	8d 48 01             	lea    0x1(%eax),%ecx
  802295:	8b 55 0c             	mov    0xc(%ebp),%edx
  802298:	89 0a                	mov    %ecx,(%edx)
  80229a:	8b 55 08             	mov    0x8(%ebp),%edx
  80229d:	88 10                	mov    %dl,(%eax)
}
  80229f:	90                   	nop
  8022a0:	5d                   	pop    %ebp
  8022a1:	c3                   	ret    

008022a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	01 d0                	add    %edx,%eax
  8022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8022c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c7:	74 06                	je     8022cf <vsnprintf+0x2d>
  8022c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022cd:	7f 07                	jg     8022d6 <vsnprintf+0x34>
		return -E_INVAL;
  8022cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8022d4:	eb 20                	jmp    8022f6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022d6:	ff 75 14             	pushl  0x14(%ebp)
  8022d9:	ff 75 10             	pushl  0x10(%ebp)
  8022dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022df:	50                   	push   %eax
  8022e0:	68 6c 22 80 00       	push   $0x80226c
  8022e5:	e8 92 fb ff ff       	call   801e7c <vprintfmt>
  8022ea:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8022ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022fe:	8d 45 10             	lea    0x10(%ebp),%eax
  802301:	83 c0 04             	add    $0x4,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802307:	8b 45 10             	mov    0x10(%ebp),%eax
  80230a:	ff 75 f4             	pushl  -0xc(%ebp)
  80230d:	50                   	push   %eax
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	e8 89 ff ff ff       	call   8022a2 <vsnprintf>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80232a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802331:	eb 06                	jmp    802339 <strlen+0x15>
		n++;
  802333:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802336:	ff 45 08             	incl   0x8(%ebp)
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	8a 00                	mov    (%eax),%al
  80233e:	84 c0                	test   %al,%al
  802340:	75 f1                	jne    802333 <strlen+0xf>
		n++;
	return n;
  802342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80234d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802354:	eb 09                	jmp    80235f <strnlen+0x18>
		n++;
  802356:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802359:	ff 45 08             	incl   0x8(%ebp)
  80235c:	ff 4d 0c             	decl   0xc(%ebp)
  80235f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802363:	74 09                	je     80236e <strnlen+0x27>
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	8a 00                	mov    (%eax),%al
  80236a:	84 c0                	test   %al,%al
  80236c:	75 e8                	jne    802356 <strnlen+0xf>
		n++;
	return n;
  80236e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80237f:	90                   	nop
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8d 50 01             	lea    0x1(%eax),%edx
  802386:	89 55 08             	mov    %edx,0x8(%ebp)
  802389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80238f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802392:	8a 12                	mov    (%edx),%dl
  802394:	88 10                	mov    %dl,(%eax)
  802396:	8a 00                	mov    (%eax),%al
  802398:	84 c0                	test   %al,%al
  80239a:	75 e4                	jne    802380 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80239c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8023ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8023b4:	eb 1f                	jmp    8023d5 <strncpy+0x34>
		*dst++ = *src;
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8d 50 01             	lea    0x1(%eax),%edx
  8023bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8023bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c2:	8a 12                	mov    (%edx),%dl
  8023c4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8a 00                	mov    (%eax),%al
  8023cb:	84 c0                	test   %al,%al
  8023cd:	74 03                	je     8023d2 <strncpy+0x31>
			src++;
  8023cf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8023d2:	ff 45 fc             	incl   -0x4(%ebp)
  8023d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023db:	72 d9                	jb     8023b6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8023dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8023ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f2:	74 30                	je     802424 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8023f4:	eb 16                	jmp    80240c <strlcpy+0x2a>
			*dst++ = *src++;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8d 50 01             	lea    0x1(%eax),%edx
  8023fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8023ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802402:	8d 4a 01             	lea    0x1(%edx),%ecx
  802405:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802408:	8a 12                	mov    (%edx),%dl
  80240a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80240c:	ff 4d 10             	decl   0x10(%ebp)
  80240f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802413:	74 09                	je     80241e <strlcpy+0x3c>
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	8a 00                	mov    (%eax),%al
  80241a:	84 c0                	test   %al,%al
  80241c:	75 d8                	jne    8023f6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802424:	8b 55 08             	mov    0x8(%ebp),%edx
  802427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80242a:	29 c2                	sub    %eax,%edx
  80242c:	89 d0                	mov    %edx,%eax
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802433:	eb 06                	jmp    80243b <strcmp+0xb>
		p++, q++;
  802435:	ff 45 08             	incl   0x8(%ebp)
  802438:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	8a 00                	mov    (%eax),%al
  802440:	84 c0                	test   %al,%al
  802442:	74 0e                	je     802452 <strcmp+0x22>
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8a 10                	mov    (%eax),%dl
  802449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244c:	8a 00                	mov    (%eax),%al
  80244e:	38 c2                	cmp    %al,%dl
  802450:	74 e3                	je     802435 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	8a 00                	mov    (%eax),%al
  802457:	0f b6 d0             	movzbl %al,%edx
  80245a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245d:	8a 00                	mov    (%eax),%al
  80245f:	0f b6 c0             	movzbl %al,%eax
  802462:	29 c2                	sub    %eax,%edx
  802464:	89 d0                	mov    %edx,%eax
}
  802466:	5d                   	pop    %ebp
  802467:	c3                   	ret    

00802468 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80246b:	eb 09                	jmp    802476 <strncmp+0xe>
		n--, p++, q++;
  80246d:	ff 4d 10             	decl   0x10(%ebp)
  802470:	ff 45 08             	incl   0x8(%ebp)
  802473:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80247a:	74 17                	je     802493 <strncmp+0x2b>
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	8a 00                	mov    (%eax),%al
  802481:	84 c0                	test   %al,%al
  802483:	74 0e                	je     802493 <strncmp+0x2b>
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8a 10                	mov    (%eax),%dl
  80248a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248d:	8a 00                	mov    (%eax),%al
  80248f:	38 c2                	cmp    %al,%dl
  802491:	74 da                	je     80246d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802497:	75 07                	jne    8024a0 <strncmp+0x38>
		return 0;
  802499:	b8 00 00 00 00       	mov    $0x0,%eax
  80249e:	eb 14                	jmp    8024b4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8a 00                	mov    (%eax),%al
  8024a5:	0f b6 d0             	movzbl %al,%edx
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	8a 00                	mov    (%eax),%al
  8024ad:	0f b6 c0             	movzbl %al,%eax
  8024b0:	29 c2                	sub    %eax,%edx
  8024b2:	89 d0                	mov    %edx,%eax
}
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    

008024b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8024c2:	eb 12                	jmp    8024d6 <strchr+0x20>
		if (*s == c)
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	8a 00                	mov    (%eax),%al
  8024c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8024cc:	75 05                	jne    8024d3 <strchr+0x1d>
			return (char *) s;
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	eb 11                	jmp    8024e4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8024d3:	ff 45 08             	incl   0x8(%ebp)
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	8a 00                	mov    (%eax),%al
  8024db:	84 c0                	test   %al,%al
  8024dd:	75 e5                	jne    8024c4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8024f2:	eb 0d                	jmp    802501 <strfind+0x1b>
		if (*s == c)
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8a 00                	mov    (%eax),%al
  8024f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8024fc:	74 0e                	je     80250c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024fe:	ff 45 08             	incl   0x8(%ebp)
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	8a 00                	mov    (%eax),%al
  802506:	84 c0                	test   %al,%al
  802508:	75 ea                	jne    8024f4 <strfind+0xe>
  80250a:	eb 01                	jmp    80250d <strfind+0x27>
		if (*s == c)
			break;
  80250c:	90                   	nop
	return (char *) s;
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80251e:	8b 45 10             	mov    0x10(%ebp),%eax
  802521:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802524:	eb 0e                	jmp    802534 <memset+0x22>
		*p++ = c;
  802526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802529:	8d 50 01             	lea    0x1(%eax),%edx
  80252c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80252f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802532:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802534:	ff 4d f8             	decl   -0x8(%ebp)
  802537:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80253b:	79 e9                	jns    802526 <memset+0x14>
		*p++ = c;

	return v;
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802554:	eb 16                	jmp    80256c <memcpy+0x2a>
		*d++ = *s++;
  802556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802559:	8d 50 01             	lea    0x1(%eax),%edx
  80255c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80255f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802562:	8d 4a 01             	lea    0x1(%edx),%ecx
  802565:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802568:	8a 12                	mov    (%edx),%dl
  80256a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80256c:	8b 45 10             	mov    0x10(%ebp),%eax
  80256f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802572:	89 55 10             	mov    %edx,0x10(%ebp)
  802575:	85 c0                	test   %eax,%eax
  802577:	75 dd                	jne    802556 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802584:	8b 45 0c             	mov    0xc(%ebp),%eax
  802587:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802593:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802596:	73 50                	jae    8025e8 <memmove+0x6a>
  802598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80259b:	8b 45 10             	mov    0x10(%ebp),%eax
  80259e:	01 d0                	add    %edx,%eax
  8025a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8025a3:	76 43                	jbe    8025e8 <memmove+0x6a>
		s += n;
  8025a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8025ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ae:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8025b1:	eb 10                	jmp    8025c3 <memmove+0x45>
			*--d = *--s;
  8025b3:	ff 4d f8             	decl   -0x8(%ebp)
  8025b6:	ff 4d fc             	decl   -0x4(%ebp)
  8025b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bc:	8a 10                	mov    (%eax),%dl
  8025be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025c1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8025c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	75 e3                	jne    8025b3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8025d0:	eb 23                	jmp    8025f5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8025d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025d5:	8d 50 01             	lea    0x1(%eax),%edx
  8025d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8025db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8025e1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8025e4:	8a 12                	mov    (%edx),%dl
  8025e6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8025e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8025eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	75 dd                	jne    8025d2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802606:	8b 45 0c             	mov    0xc(%ebp),%eax
  802609:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80260c:	eb 2a                	jmp    802638 <memcmp+0x3e>
		if (*s1 != *s2)
  80260e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802611:	8a 10                	mov    (%eax),%dl
  802613:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802616:	8a 00                	mov    (%eax),%al
  802618:	38 c2                	cmp    %al,%dl
  80261a:	74 16                	je     802632 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80261c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261f:	8a 00                	mov    (%eax),%al
  802621:	0f b6 d0             	movzbl %al,%edx
  802624:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802627:	8a 00                	mov    (%eax),%al
  802629:	0f b6 c0             	movzbl %al,%eax
  80262c:	29 c2                	sub    %eax,%edx
  80262e:	89 d0                	mov    %edx,%eax
  802630:	eb 18                	jmp    80264a <memcmp+0x50>
		s1++, s2++;
  802632:	ff 45 fc             	incl   -0x4(%ebp)
  802635:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802638:	8b 45 10             	mov    0x10(%ebp),%eax
  80263b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80263e:	89 55 10             	mov    %edx,0x10(%ebp)
  802641:	85 c0                	test   %eax,%eax
  802643:	75 c9                	jne    80260e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802652:	8b 55 08             	mov    0x8(%ebp),%edx
  802655:	8b 45 10             	mov    0x10(%ebp),%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80265d:	eb 15                	jmp    802674 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	8a 00                	mov    (%eax),%al
  802664:	0f b6 d0             	movzbl %al,%edx
  802667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266a:	0f b6 c0             	movzbl %al,%eax
  80266d:	39 c2                	cmp    %eax,%edx
  80266f:	74 0d                	je     80267e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802671:	ff 45 08             	incl   0x8(%ebp)
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80267a:	72 e3                	jb     80265f <memfind+0x13>
  80267c:	eb 01                	jmp    80267f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80267e:	90                   	nop
	return (void *) s;
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80268a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802691:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802698:	eb 03                	jmp    80269d <strtol+0x19>
		s++;
  80269a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8a 00                	mov    (%eax),%al
  8026a2:	3c 20                	cmp    $0x20,%al
  8026a4:	74 f4                	je     80269a <strtol+0x16>
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	8a 00                	mov    (%eax),%al
  8026ab:	3c 09                	cmp    $0x9,%al
  8026ad:	74 eb                	je     80269a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	8a 00                	mov    (%eax),%al
  8026b4:	3c 2b                	cmp    $0x2b,%al
  8026b6:	75 05                	jne    8026bd <strtol+0x39>
		s++;
  8026b8:	ff 45 08             	incl   0x8(%ebp)
  8026bb:	eb 13                	jmp    8026d0 <strtol+0x4c>
	else if (*s == '-')
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	8a 00                	mov    (%eax),%al
  8026c2:	3c 2d                	cmp    $0x2d,%al
  8026c4:	75 0a                	jne    8026d0 <strtol+0x4c>
		s++, neg = 1;
  8026c6:	ff 45 08             	incl   0x8(%ebp)
  8026c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8026d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026d4:	74 06                	je     8026dc <strtol+0x58>
  8026d6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8026da:	75 20                	jne    8026fc <strtol+0x78>
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	8a 00                	mov    (%eax),%al
  8026e1:	3c 30                	cmp    $0x30,%al
  8026e3:	75 17                	jne    8026fc <strtol+0x78>
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	40                   	inc    %eax
  8026e9:	8a 00                	mov    (%eax),%al
  8026eb:	3c 78                	cmp    $0x78,%al
  8026ed:	75 0d                	jne    8026fc <strtol+0x78>
		s += 2, base = 16;
  8026ef:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8026f3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8026fa:	eb 28                	jmp    802724 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8026fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802700:	75 15                	jne    802717 <strtol+0x93>
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	8a 00                	mov    (%eax),%al
  802707:	3c 30                	cmp    $0x30,%al
  802709:	75 0c                	jne    802717 <strtol+0x93>
		s++, base = 8;
  80270b:	ff 45 08             	incl   0x8(%ebp)
  80270e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802715:	eb 0d                	jmp    802724 <strtol+0xa0>
	else if (base == 0)
  802717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80271b:	75 07                	jne    802724 <strtol+0xa0>
		base = 10;
  80271d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	8a 00                	mov    (%eax),%al
  802729:	3c 2f                	cmp    $0x2f,%al
  80272b:	7e 19                	jle    802746 <strtol+0xc2>
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	8a 00                	mov    (%eax),%al
  802732:	3c 39                	cmp    $0x39,%al
  802734:	7f 10                	jg     802746 <strtol+0xc2>
			dig = *s - '0';
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	8a 00                	mov    (%eax),%al
  80273b:	0f be c0             	movsbl %al,%eax
  80273e:	83 e8 30             	sub    $0x30,%eax
  802741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802744:	eb 42                	jmp    802788 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8a 00                	mov    (%eax),%al
  80274b:	3c 60                	cmp    $0x60,%al
  80274d:	7e 19                	jle    802768 <strtol+0xe4>
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	8a 00                	mov    (%eax),%al
  802754:	3c 7a                	cmp    $0x7a,%al
  802756:	7f 10                	jg     802768 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	8a 00                	mov    (%eax),%al
  80275d:	0f be c0             	movsbl %al,%eax
  802760:	83 e8 57             	sub    $0x57,%eax
  802763:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802766:	eb 20                	jmp    802788 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	8a 00                	mov    (%eax),%al
  80276d:	3c 40                	cmp    $0x40,%al
  80276f:	7e 39                	jle    8027aa <strtol+0x126>
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	8a 00                	mov    (%eax),%al
  802776:	3c 5a                	cmp    $0x5a,%al
  802778:	7f 30                	jg     8027aa <strtol+0x126>
			dig = *s - 'A' + 10;
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	8a 00                	mov    (%eax),%al
  80277f:	0f be c0             	movsbl %al,%eax
  802782:	83 e8 37             	sub    $0x37,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80278e:	7d 19                	jge    8027a9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802790:	ff 45 08             	incl   0x8(%ebp)
  802793:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802796:	0f af 45 10          	imul   0x10(%ebp),%eax
  80279a:	89 c2                	mov    %eax,%edx
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	01 d0                	add    %edx,%eax
  8027a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8027a4:	e9 7b ff ff ff       	jmp    802724 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8027a9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8027aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027ae:	74 08                	je     8027b8 <strtol+0x134>
		*endptr = (char *) s;
  8027b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8027b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027bc:	74 07                	je     8027c5 <strtol+0x141>
  8027be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027c1:	f7 d8                	neg    %eax
  8027c3:	eb 03                	jmp    8027c8 <strtol+0x144>
  8027c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <ltostr>:

void
ltostr(long value, char *str)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8027d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8027d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8027de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e2:	79 13                	jns    8027f7 <ltostr+0x2d>
	{
		neg = 1;
  8027e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8027eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ee:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8027f1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8027f4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8027ff:	99                   	cltd   
  802800:	f7 f9                	idiv   %ecx
  802802:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802805:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802808:	8d 50 01             	lea    0x1(%eax),%edx
  80280b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80280e:	89 c2                	mov    %eax,%edx
  802810:	8b 45 0c             	mov    0xc(%ebp),%eax
  802813:	01 d0                	add    %edx,%eax
  802815:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802818:	83 c2 30             	add    $0x30,%edx
  80281b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80281d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802820:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802825:	f7 e9                	imul   %ecx
  802827:	c1 fa 02             	sar    $0x2,%edx
  80282a:	89 c8                	mov    %ecx,%eax
  80282c:	c1 f8 1f             	sar    $0x1f,%eax
  80282f:	29 c2                	sub    %eax,%edx
  802831:	89 d0                	mov    %edx,%eax
  802833:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802836:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802839:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80283e:	f7 e9                	imul   %ecx
  802840:	c1 fa 02             	sar    $0x2,%edx
  802843:	89 c8                	mov    %ecx,%eax
  802845:	c1 f8 1f             	sar    $0x1f,%eax
  802848:	29 c2                	sub    %eax,%edx
  80284a:	89 d0                	mov    %edx,%eax
  80284c:	c1 e0 02             	shl    $0x2,%eax
  80284f:	01 d0                	add    %edx,%eax
  802851:	01 c0                	add    %eax,%eax
  802853:	29 c1                	sub    %eax,%ecx
  802855:	89 ca                	mov    %ecx,%edx
  802857:	85 d2                	test   %edx,%edx
  802859:	75 9c                	jne    8027f7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80285b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802865:	48                   	dec    %eax
  802866:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80286d:	74 3d                	je     8028ac <ltostr+0xe2>
		start = 1 ;
  80286f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802876:	eb 34                	jmp    8028ac <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	8a 00                	mov    (%eax),%al
  802882:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288b:	01 c2                	add    %eax,%edx
  80288d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802890:	8b 45 0c             	mov    0xc(%ebp),%eax
  802893:	01 c8                	add    %ecx,%eax
  802895:	8a 00                	mov    (%eax),%al
  802897:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802899:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289f:	01 c2                	add    %eax,%edx
  8028a1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8028a4:	88 02                	mov    %al,(%edx)
		start++ ;
  8028a6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8028a9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028b2:	7c c4                	jl     802878 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8028b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8028b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ba:	01 d0                	add    %edx,%eax
  8028bc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8028bf:	90                   	nop
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8028c8:	ff 75 08             	pushl  0x8(%ebp)
  8028cb:	e8 54 fa ff ff       	call   802324 <strlen>
  8028d0:	83 c4 04             	add    $0x4,%esp
  8028d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8028d6:	ff 75 0c             	pushl  0xc(%ebp)
  8028d9:	e8 46 fa ff ff       	call   802324 <strlen>
  8028de:	83 c4 04             	add    $0x4,%esp
  8028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8028e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8028eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028f2:	eb 17                	jmp    80290b <strcconcat+0x49>
		final[s] = str1[s] ;
  8028f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8028fa:	01 c2                	add    %eax,%edx
  8028fc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	01 c8                	add    %ecx,%eax
  802904:	8a 00                	mov    (%eax),%al
  802906:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802908:	ff 45 fc             	incl   -0x4(%ebp)
  80290b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802911:	7c e1                	jl     8028f4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802913:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80291a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802921:	eb 1f                	jmp    802942 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802926:	8d 50 01             	lea    0x1(%eax),%edx
  802929:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80292c:	89 c2                	mov    %eax,%edx
  80292e:	8b 45 10             	mov    0x10(%ebp),%eax
  802931:	01 c2                	add    %eax,%edx
  802933:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802936:	8b 45 0c             	mov    0xc(%ebp),%eax
  802939:	01 c8                	add    %ecx,%eax
  80293b:	8a 00                	mov    (%eax),%al
  80293d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80293f:	ff 45 f8             	incl   -0x8(%ebp)
  802942:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802945:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802948:	7c d9                	jl     802923 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80294a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80294d:	8b 45 10             	mov    0x10(%ebp),%eax
  802950:	01 d0                	add    %edx,%eax
  802952:	c6 00 00             	movb   $0x0,(%eax)
}
  802955:	90                   	nop
  802956:	c9                   	leave  
  802957:	c3                   	ret    

00802958 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80295b:	8b 45 14             	mov    0x14(%ebp),%eax
  80295e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802964:	8b 45 14             	mov    0x14(%ebp),%eax
  802967:	8b 00                	mov    (%eax),%eax
  802969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802970:	8b 45 10             	mov    0x10(%ebp),%eax
  802973:	01 d0                	add    %edx,%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80297b:	eb 0c                	jmp    802989 <strsplit+0x31>
			*string++ = 0;
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8d 50 01             	lea    0x1(%eax),%edx
  802983:	89 55 08             	mov    %edx,0x8(%ebp)
  802986:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	8a 00                	mov    (%eax),%al
  80298e:	84 c0                	test   %al,%al
  802990:	74 18                	je     8029aa <strsplit+0x52>
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8a 00                	mov    (%eax),%al
  802997:	0f be c0             	movsbl %al,%eax
  80299a:	50                   	push   %eax
  80299b:	ff 75 0c             	pushl  0xc(%ebp)
  80299e:	e8 13 fb ff ff       	call   8024b6 <strchr>
  8029a3:	83 c4 08             	add    $0x8,%esp
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	75 d3                	jne    80297d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8a 00                	mov    (%eax),%al
  8029af:	84 c0                	test   %al,%al
  8029b1:	74 5a                	je     802a0d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8029b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	83 f8 0f             	cmp    $0xf,%eax
  8029bb:	75 07                	jne    8029c4 <strsplit+0x6c>
		{
			return 0;
  8029bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c2:	eb 66                	jmp    802a2a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8029c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	8d 48 01             	lea    0x1(%eax),%ecx
  8029cc:	8b 55 14             	mov    0x14(%ebp),%edx
  8029cf:	89 0a                	mov    %ecx,(%edx)
  8029d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8029db:	01 c2                	add    %eax,%edx
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8029e2:	eb 03                	jmp    8029e7 <strsplit+0x8f>
			string++;
  8029e4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	8a 00                	mov    (%eax),%al
  8029ec:	84 c0                	test   %al,%al
  8029ee:	74 8b                	je     80297b <strsplit+0x23>
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8a 00                	mov    (%eax),%al
  8029f5:	0f be c0             	movsbl %al,%eax
  8029f8:	50                   	push   %eax
  8029f9:	ff 75 0c             	pushl  0xc(%ebp)
  8029fc:	e8 b5 fa ff ff       	call   8024b6 <strchr>
  802a01:	83 c4 08             	add    $0x8,%esp
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 dc                	je     8029e4 <strsplit+0x8c>
			string++;
	}
  802a08:	e9 6e ff ff ff       	jmp    80297b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802a0d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a1d:	01 d0                	add    %edx,%eax
  802a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802a25:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 10 3c 80 00       	push   $0x803c10
  802a3a:	6a 0e                	push   $0xe
  802a3c:	68 4a 3c 80 00       	push   $0x803c4a
  802a41:	e8 a8 ef ff ff       	call   8019ee <_panic>

00802a46 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  802a4c:	a1 04 40 80 00       	mov    0x804004,%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 0f                	je     802a64 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  802a55:	e8 d2 ff ff ff       	call   802a2c <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802a5a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802a61:	00 00 00 
	}
	if (size == 0) return NULL ;
  802a64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a68:	75 07                	jne    802a71 <malloc+0x2b>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	eb 14                	jmp    802a85 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	68 58 3c 80 00       	push   $0x803c58
  802a79:	6a 2e                	push   $0x2e
  802a7b:	68 4a 3c 80 00       	push   $0x803c4a
  802a80:	e8 69 ef ff ff       	call   8019ee <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 80 3c 80 00       	push   $0x803c80
  802a95:	6a 49                	push   $0x49
  802a97:	68 4a 3c 80 00       	push   $0x803c4a
  802a9c:	e8 4d ef ff ff       	call   8019ee <_panic>

00802aa1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
  802aa4:	83 ec 18             	sub    $0x18,%esp
  802aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  802aaa:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802aad:	83 ec 04             	sub    $0x4,%esp
  802ab0:	68 a4 3c 80 00       	push   $0x803ca4
  802ab5:	6a 57                	push   $0x57
  802ab7:	68 4a 3c 80 00       	push   $0x803c4a
  802abc:	e8 2d ef ff ff       	call   8019ee <_panic>

00802ac1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	68 cc 3c 80 00       	push   $0x803ccc
  802acf:	6a 60                	push   $0x60
  802ad1:	68 4a 3c 80 00       	push   $0x803c4a
  802ad6:	e8 13 ef ff ff       	call   8019ee <_panic>

00802adb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 f0 3c 80 00       	push   $0x803cf0
  802ae9:	6a 7c                	push   $0x7c
  802aeb:	68 4a 3c 80 00       	push   $0x803c4a
  802af0:	e8 f9 ee ff ff       	call   8019ee <_panic>

00802af5 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
  802af8:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	68 18 3d 80 00       	push   $0x803d18
  802b03:	68 86 00 00 00       	push   $0x86
  802b08:	68 4a 3c 80 00       	push   $0x803c4a
  802b0d:	e8 dc ee ff ff       	call   8019ee <_panic>

00802b12 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
  802b15:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b18:	83 ec 04             	sub    $0x4,%esp
  802b1b:	68 3c 3d 80 00       	push   $0x803d3c
  802b20:	68 91 00 00 00       	push   $0x91
  802b25:	68 4a 3c 80 00       	push   $0x803c4a
  802b2a:	e8 bf ee ff ff       	call   8019ee <_panic>

00802b2f <shrink>:

}
void shrink(uint32 newSize)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	68 3c 3d 80 00       	push   $0x803d3c
  802b3d:	68 96 00 00 00       	push   $0x96
  802b42:	68 4a 3c 80 00       	push   $0x803c4a
  802b47:	e8 a2 ee ff ff       	call   8019ee <_panic>

00802b4c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 3c 3d 80 00       	push   $0x803d3c
  802b5a:	68 9b 00 00 00       	push   $0x9b
  802b5f:	68 4a 3c 80 00       	push   $0x803c4a
  802b64:	e8 85 ee ff ff       	call   8019ee <_panic>

00802b69 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
  802b6c:	57                   	push   %edi
  802b6d:	56                   	push   %esi
  802b6e:	53                   	push   %ebx
  802b6f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b7b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b7e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b81:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b84:	cd 30                	int    $0x30
  802b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	5b                   	pop    %ebx
  802b90:	5e                   	pop    %esi
  802b91:	5f                   	pop    %edi
  802b92:	5d                   	pop    %ebp
  802b93:	c3                   	ret    

00802b94 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b94:	55                   	push   %ebp
  802b95:	89 e5                	mov    %esp,%ebp
  802b97:	83 ec 04             	sub    $0x4,%esp
  802b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ba0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	52                   	push   %edx
  802bac:	ff 75 0c             	pushl  0xc(%ebp)
  802baf:	50                   	push   %eax
  802bb0:	6a 00                	push   $0x0
  802bb2:	e8 b2 ff ff ff       	call   802b69 <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
}
  802bba:	90                   	nop
  802bbb:	c9                   	leave  
  802bbc:	c3                   	ret    

00802bbd <sys_cgetc>:

int
sys_cgetc(void)
{
  802bbd:	55                   	push   %ebp
  802bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 01                	push   $0x1
  802bcc:	e8 98 ff ff ff       	call   802b69 <syscall>
  802bd1:	83 c4 18             	add    $0x18,%esp
}
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	52                   	push   %edx
  802be6:	50                   	push   %eax
  802be7:	6a 05                	push   $0x5
  802be9:	e8 7b ff ff ff       	call   802b69 <syscall>
  802bee:	83 c4 18             	add    $0x18,%esp
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
  802bf6:	56                   	push   %esi
  802bf7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802bf8:	8b 75 18             	mov    0x18(%ebp),%esi
  802bfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	56                   	push   %esi
  802c08:	53                   	push   %ebx
  802c09:	51                   	push   %ecx
  802c0a:	52                   	push   %edx
  802c0b:	50                   	push   %eax
  802c0c:	6a 06                	push   $0x6
  802c0e:	e8 56 ff ff ff       	call   802b69 <syscall>
  802c13:	83 c4 18             	add    $0x18,%esp
}
  802c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c19:	5b                   	pop    %ebx
  802c1a:	5e                   	pop    %esi
  802c1b:	5d                   	pop    %ebp
  802c1c:	c3                   	ret    

00802c1d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	52                   	push   %edx
  802c2d:	50                   	push   %eax
  802c2e:	6a 07                	push   $0x7
  802c30:	e8 34 ff ff ff       	call   802b69 <syscall>
  802c35:	83 c4 18             	add    $0x18,%esp
}
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	ff 75 0c             	pushl  0xc(%ebp)
  802c46:	ff 75 08             	pushl  0x8(%ebp)
  802c49:	6a 08                	push   $0x8
  802c4b:	e8 19 ff ff ff       	call   802b69 <syscall>
  802c50:	83 c4 18             	add    $0x18,%esp
}
  802c53:	c9                   	leave  
  802c54:	c3                   	ret    

00802c55 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c55:	55                   	push   %ebp
  802c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 09                	push   $0x9
  802c64:	e8 00 ff ff ff       	call   802b69 <syscall>
  802c69:	83 c4 18             	add    $0x18,%esp
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 0a                	push   $0xa
  802c7d:	e8 e7 fe ff ff       	call   802b69 <syscall>
  802c82:	83 c4 18             	add    $0x18,%esp
}
  802c85:	c9                   	leave  
  802c86:	c3                   	ret    

00802c87 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	6a 00                	push   $0x0
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 0b                	push   $0xb
  802c96:	e8 ce fe ff ff       	call   802b69 <syscall>
  802c9b:	83 c4 18             	add    $0x18,%esp
}
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 00                	push   $0x0
  802ca7:	6a 00                	push   $0x0
  802ca9:	ff 75 0c             	pushl  0xc(%ebp)
  802cac:	ff 75 08             	pushl  0x8(%ebp)
  802caf:	6a 0f                	push   $0xf
  802cb1:	e8 b3 fe ff ff       	call   802b69 <syscall>
  802cb6:	83 c4 18             	add    $0x18,%esp
	return;
  802cb9:	90                   	nop
}
  802cba:	c9                   	leave  
  802cbb:	c3                   	ret    

00802cbc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	6a 00                	push   $0x0
  802cc5:	ff 75 0c             	pushl  0xc(%ebp)
  802cc8:	ff 75 08             	pushl  0x8(%ebp)
  802ccb:	6a 10                	push   $0x10
  802ccd:	e8 97 fe ff ff       	call   802b69 <syscall>
  802cd2:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd5:	90                   	nop
}
  802cd6:	c9                   	leave  
  802cd7:	c3                   	ret    

00802cd8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cd8:	55                   	push   %ebp
  802cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	ff 75 10             	pushl  0x10(%ebp)
  802ce2:	ff 75 0c             	pushl  0xc(%ebp)
  802ce5:	ff 75 08             	pushl  0x8(%ebp)
  802ce8:	6a 11                	push   $0x11
  802cea:	e8 7a fe ff ff       	call   802b69 <syscall>
  802cef:	83 c4 18             	add    $0x18,%esp
	return ;
  802cf2:	90                   	nop
}
  802cf3:	c9                   	leave  
  802cf4:	c3                   	ret    

00802cf5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 00                	push   $0x0
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	6a 0c                	push   $0xc
  802d04:	e8 60 fe ff ff       	call   802b69 <syscall>
  802d09:	83 c4 18             	add    $0x18,%esp
}
  802d0c:	c9                   	leave  
  802d0d:	c3                   	ret    

00802d0e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802d0e:	55                   	push   %ebp
  802d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	ff 75 08             	pushl  0x8(%ebp)
  802d1c:	6a 0d                	push   $0xd
  802d1e:	e8 46 fe ff ff       	call   802b69 <syscall>
  802d23:	83 c4 18             	add    $0x18,%esp
}
  802d26:	c9                   	leave  
  802d27:	c3                   	ret    

00802d28 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802d28:	55                   	push   %ebp
  802d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	6a 0e                	push   $0xe
  802d37:	e8 2d fe ff ff       	call   802b69 <syscall>
  802d3c:	83 c4 18             	add    $0x18,%esp
}
  802d3f:	90                   	nop
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 13                	push   $0x13
  802d51:	e8 13 fe ff ff       	call   802b69 <syscall>
  802d56:	83 c4 18             	add    $0x18,%esp
}
  802d59:	90                   	nop
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 14                	push   $0x14
  802d6b:	e8 f9 fd ff ff       	call   802b69 <syscall>
  802d70:	83 c4 18             	add    $0x18,%esp
}
  802d73:	90                   	nop
  802d74:	c9                   	leave  
  802d75:	c3                   	ret    

00802d76 <sys_cputc>:


void
sys_cputc(const char c)
{
  802d76:	55                   	push   %ebp
  802d77:	89 e5                	mov    %esp,%ebp
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	50                   	push   %eax
  802d8f:	6a 15                	push   $0x15
  802d91:	e8 d3 fd ff ff       	call   802b69 <syscall>
  802d96:	83 c4 18             	add    $0x18,%esp
}
  802d99:	90                   	nop
  802d9a:	c9                   	leave  
  802d9b:	c3                   	ret    

00802d9c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802d9c:	55                   	push   %ebp
  802d9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 00                	push   $0x0
  802da9:	6a 16                	push   $0x16
  802dab:	e8 b9 fd ff ff       	call   802b69 <syscall>
  802db0:	83 c4 18             	add    $0x18,%esp
}
  802db3:	90                   	nop
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	ff 75 0c             	pushl  0xc(%ebp)
  802dc5:	50                   	push   %eax
  802dc6:	6a 17                	push   $0x17
  802dc8:	e8 9c fd ff ff       	call   802b69 <syscall>
  802dcd:	83 c4 18             	add    $0x18,%esp
}
  802dd0:	c9                   	leave  
  802dd1:	c3                   	ret    

00802dd2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802dd2:	55                   	push   %ebp
  802dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	6a 00                	push   $0x0
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 00                	push   $0x0
  802de1:	52                   	push   %edx
  802de2:	50                   	push   %eax
  802de3:	6a 1a                	push   $0x1a
  802de5:	e8 7f fd ff ff       	call   802b69 <syscall>
  802dea:	83 c4 18             	add    $0x18,%esp
}
  802ded:	c9                   	leave  
  802dee:	c3                   	ret    

00802def <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802def:	55                   	push   %ebp
  802df0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	52                   	push   %edx
  802dff:	50                   	push   %eax
  802e00:	6a 18                	push   $0x18
  802e02:	e8 62 fd ff ff       	call   802b69 <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	90                   	nop
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	52                   	push   %edx
  802e1d:	50                   	push   %eax
  802e1e:	6a 19                	push   $0x19
  802e20:	e8 44 fd ff ff       	call   802b69 <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
}
  802e28:	90                   	nop
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	8b 45 10             	mov    0x10(%ebp),%eax
  802e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	6a 00                	push   $0x0
  802e43:	51                   	push   %ecx
  802e44:	52                   	push   %edx
  802e45:	ff 75 0c             	pushl  0xc(%ebp)
  802e48:	50                   	push   %eax
  802e49:	6a 1b                	push   $0x1b
  802e4b:	e8 19 fd ff ff       	call   802b69 <syscall>
  802e50:	83 c4 18             	add    $0x18,%esp
}
  802e53:	c9                   	leave  
  802e54:	c3                   	ret    

00802e55 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802e55:	55                   	push   %ebp
  802e56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 00                	push   $0x0
  802e64:	52                   	push   %edx
  802e65:	50                   	push   %eax
  802e66:	6a 1c                	push   $0x1c
  802e68:	e8 fc fc ff ff       	call   802b69 <syscall>
  802e6d:	83 c4 18             	add    $0x18,%esp
}
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    

00802e72 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802e72:	55                   	push   %ebp
  802e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	51                   	push   %ecx
  802e83:	52                   	push   %edx
  802e84:	50                   	push   %eax
  802e85:	6a 1d                	push   $0x1d
  802e87:	e8 dd fc ff ff       	call   802b69 <syscall>
  802e8c:	83 c4 18             	add    $0x18,%esp
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	52                   	push   %edx
  802ea1:	50                   	push   %eax
  802ea2:	6a 1e                	push   $0x1e
  802ea4:	e8 c0 fc ff ff       	call   802b69 <syscall>
  802ea9:	83 c4 18             	add    $0x18,%esp
}
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 1f                	push   $0x1f
  802ebd:	e8 a7 fc ff ff       	call   802b69 <syscall>
  802ec2:	83 c4 18             	add    $0x18,%esp
}
  802ec5:	c9                   	leave  
  802ec6:	c3                   	ret    

00802ec7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ec7:	55                   	push   %ebp
  802ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	6a 00                	push   $0x0
  802ecf:	ff 75 14             	pushl  0x14(%ebp)
  802ed2:	ff 75 10             	pushl  0x10(%ebp)
  802ed5:	ff 75 0c             	pushl  0xc(%ebp)
  802ed8:	50                   	push   %eax
  802ed9:	6a 20                	push   $0x20
  802edb:	e8 89 fc ff ff       	call   802b69 <syscall>
  802ee0:	83 c4 18             	add    $0x18,%esp
}
  802ee3:	c9                   	leave  
  802ee4:	c3                   	ret    

00802ee5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	50                   	push   %eax
  802ef4:	6a 21                	push   $0x21
  802ef6:	e8 6e fc ff ff       	call   802b69 <syscall>
  802efb:	83 c4 18             	add    $0x18,%esp
}
  802efe:	90                   	nop
  802eff:	c9                   	leave  
  802f00:	c3                   	ret    

00802f01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f01:	55                   	push   %ebp
  802f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	50                   	push   %eax
  802f10:	6a 22                	push   $0x22
  802f12:	e8 52 fc ff ff       	call   802b69 <syscall>
  802f17:	83 c4 18             	add    $0x18,%esp
}
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f1c:	55                   	push   %ebp
  802f1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 02                	push   $0x2
  802f2b:	e8 39 fc ff ff       	call   802b69 <syscall>
  802f30:	83 c4 18             	add    $0x18,%esp
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 03                	push   $0x3
  802f44:	e8 20 fc ff ff       	call   802b69 <syscall>
  802f49:	83 c4 18             	add    $0x18,%esp
}
  802f4c:	c9                   	leave  
  802f4d:	c3                   	ret    

00802f4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f4e:	55                   	push   %ebp
  802f4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f51:	6a 00                	push   $0x0
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 04                	push   $0x4
  802f5d:	e8 07 fc ff ff       	call   802b69 <syscall>
  802f62:	83 c4 18             	add    $0x18,%esp
}
  802f65:	c9                   	leave  
  802f66:	c3                   	ret    

00802f67 <sys_exit_env>:


void sys_exit_env(void)
{
  802f67:	55                   	push   %ebp
  802f68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 00                	push   $0x0
  802f72:	6a 00                	push   $0x0
  802f74:	6a 23                	push   $0x23
  802f76:	e8 ee fb ff ff       	call   802b69 <syscall>
  802f7b:	83 c4 18             	add    $0x18,%esp
}
  802f7e:	90                   	nop
  802f7f:	c9                   	leave  
  802f80:	c3                   	ret    

00802f81 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802f81:	55                   	push   %ebp
  802f82:	89 e5                	mov    %esp,%ebp
  802f84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f8a:	8d 50 04             	lea    0x4(%eax),%edx
  802f8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f90:	6a 00                	push   $0x0
  802f92:	6a 00                	push   $0x0
  802f94:	6a 00                	push   $0x0
  802f96:	52                   	push   %edx
  802f97:	50                   	push   %eax
  802f98:	6a 24                	push   $0x24
  802f9a:	e8 ca fb ff ff       	call   802b69 <syscall>
  802f9f:	83 c4 18             	add    $0x18,%esp
	return result;
  802fa2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802fa8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fab:	89 01                	mov    %eax,(%ecx)
  802fad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	c9                   	leave  
  802fb4:	c2 04 00             	ret    $0x4

00802fb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 00                	push   $0x0
  802fbe:	ff 75 10             	pushl  0x10(%ebp)
  802fc1:	ff 75 0c             	pushl  0xc(%ebp)
  802fc4:	ff 75 08             	pushl  0x8(%ebp)
  802fc7:	6a 12                	push   $0x12
  802fc9:	e8 9b fb ff ff       	call   802b69 <syscall>
  802fce:	83 c4 18             	add    $0x18,%esp
	return ;
  802fd1:	90                   	nop
}
  802fd2:	c9                   	leave  
  802fd3:	c3                   	ret    

00802fd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  802fd4:	55                   	push   %ebp
  802fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 25                	push   $0x25
  802fe3:	e8 81 fb ff ff       	call   802b69 <syscall>
  802fe8:	83 c4 18             	add    $0x18,%esp
}
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ff9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	50                   	push   %eax
  803006:	6a 26                	push   $0x26
  803008:	e8 5c fb ff ff       	call   802b69 <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
	return ;
  803010:	90                   	nop
}
  803011:	c9                   	leave  
  803012:	c3                   	ret    

00803013 <rsttst>:
void rsttst()
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803016:	6a 00                	push   $0x0
  803018:	6a 00                	push   $0x0
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 28                	push   $0x28
  803022:	e8 42 fb ff ff       	call   802b69 <syscall>
  803027:	83 c4 18             	add    $0x18,%esp
	return ;
  80302a:	90                   	nop
}
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	8b 45 14             	mov    0x14(%ebp),%eax
  803036:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803039:	8b 55 18             	mov    0x18(%ebp),%edx
  80303c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803040:	52                   	push   %edx
  803041:	50                   	push   %eax
  803042:	ff 75 10             	pushl  0x10(%ebp)
  803045:	ff 75 0c             	pushl  0xc(%ebp)
  803048:	ff 75 08             	pushl  0x8(%ebp)
  80304b:	6a 27                	push   $0x27
  80304d:	e8 17 fb ff ff       	call   802b69 <syscall>
  803052:	83 c4 18             	add    $0x18,%esp
	return ;
  803055:	90                   	nop
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <chktst>:
void chktst(uint32 n)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	ff 75 08             	pushl  0x8(%ebp)
  803066:	6a 29                	push   $0x29
  803068:	e8 fc fa ff ff       	call   802b69 <syscall>
  80306d:	83 c4 18             	add    $0x18,%esp
	return ;
  803070:	90                   	nop
}
  803071:	c9                   	leave  
  803072:	c3                   	ret    

00803073 <inctst>:

void inctst()
{
  803073:	55                   	push   %ebp
  803074:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803076:	6a 00                	push   $0x0
  803078:	6a 00                	push   $0x0
  80307a:	6a 00                	push   $0x0
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 2a                	push   $0x2a
  803082:	e8 e2 fa ff ff       	call   802b69 <syscall>
  803087:	83 c4 18             	add    $0x18,%esp
	return ;
  80308a:	90                   	nop
}
  80308b:	c9                   	leave  
  80308c:	c3                   	ret    

0080308d <gettst>:
uint32 gettst()
{
  80308d:	55                   	push   %ebp
  80308e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	6a 2b                	push   $0x2b
  80309c:	e8 c8 fa ff ff       	call   802b69 <syscall>
  8030a1:	83 c4 18             	add    $0x18,%esp
}
  8030a4:	c9                   	leave  
  8030a5:	c3                   	ret    

008030a6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8030a6:	55                   	push   %ebp
  8030a7:	89 e5                	mov    %esp,%ebp
  8030a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 00                	push   $0x0
  8030b2:	6a 00                	push   $0x0
  8030b4:	6a 00                	push   $0x0
  8030b6:	6a 2c                	push   $0x2c
  8030b8:	e8 ac fa ff ff       	call   802b69 <syscall>
  8030bd:	83 c4 18             	add    $0x18,%esp
  8030c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8030c3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8030c7:	75 07                	jne    8030d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8030c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ce:	eb 05                	jmp    8030d5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8030d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d5:	c9                   	leave  
  8030d6:	c3                   	ret    

008030d7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
  8030da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 2c                	push   $0x2c
  8030e9:	e8 7b fa ff ff       	call   802b69 <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
  8030f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8030f4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8030f8:	75 07                	jne    803101 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	eb 05                	jmp    803106 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803106:	c9                   	leave  
  803107:	c3                   	ret    

00803108 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803108:	55                   	push   %ebp
  803109:	89 e5                	mov    %esp,%ebp
  80310b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	6a 00                	push   $0x0
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 2c                	push   $0x2c
  80311a:	e8 4a fa ff ff       	call   802b69 <syscall>
  80311f:	83 c4 18             	add    $0x18,%esp
  803122:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803125:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803129:	75 07                	jne    803132 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80312b:	b8 01 00 00 00       	mov    $0x1,%eax
  803130:	eb 05                	jmp    803137 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803132:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803137:	c9                   	leave  
  803138:	c3                   	ret    

00803139 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803139:	55                   	push   %ebp
  80313a:	89 e5                	mov    %esp,%ebp
  80313c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 2c                	push   $0x2c
  80314b:	e8 19 fa ff ff       	call   802b69 <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
  803153:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803156:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80315a:	75 07                	jne    803163 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80315c:	b8 01 00 00 00       	mov    $0x1,%eax
  803161:	eb 05                	jmp    803168 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	6a 2d                	push   $0x2d
  80317a:	e8 ea f9 ff ff       	call   802b69 <syscall>
  80317f:	83 c4 18             	add    $0x18,%esp
	return ;
  803182:	90                   	nop
}
  803183:	c9                   	leave  
  803184:	c3                   	ret    

00803185 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803185:	55                   	push   %ebp
  803186:	89 e5                	mov    %esp,%ebp
  803188:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803189:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80318c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80318f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	6a 00                	push   $0x0
  803197:	53                   	push   %ebx
  803198:	51                   	push   %ecx
  803199:	52                   	push   %edx
  80319a:	50                   	push   %eax
  80319b:	6a 2e                	push   $0x2e
  80319d:	e8 c7 f9 ff ff       	call   802b69 <syscall>
  8031a2:	83 c4 18             	add    $0x18,%esp
}
  8031a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	52                   	push   %edx
  8031ba:	50                   	push   %eax
  8031bb:	6a 2f                	push   $0x2f
  8031bd:	e8 a7 f9 ff ff       	call   802b69 <syscall>
  8031c2:	83 c4 18             	add    $0x18,%esp
}
  8031c5:	c9                   	leave  
  8031c6:	c3                   	ret    
  8031c7:	90                   	nop

008031c8 <__udivdi3>:
  8031c8:	55                   	push   %ebp
  8031c9:	57                   	push   %edi
  8031ca:	56                   	push   %esi
  8031cb:	53                   	push   %ebx
  8031cc:	83 ec 1c             	sub    $0x1c,%esp
  8031cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031df:	89 ca                	mov    %ecx,%edx
  8031e1:	89 f8                	mov    %edi,%eax
  8031e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031e7:	85 f6                	test   %esi,%esi
  8031e9:	75 2d                	jne    803218 <__udivdi3+0x50>
  8031eb:	39 cf                	cmp    %ecx,%edi
  8031ed:	77 65                	ja     803254 <__udivdi3+0x8c>
  8031ef:	89 fd                	mov    %edi,%ebp
  8031f1:	85 ff                	test   %edi,%edi
  8031f3:	75 0b                	jne    803200 <__udivdi3+0x38>
  8031f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8031fa:	31 d2                	xor    %edx,%edx
  8031fc:	f7 f7                	div    %edi
  8031fe:	89 c5                	mov    %eax,%ebp
  803200:	31 d2                	xor    %edx,%edx
  803202:	89 c8                	mov    %ecx,%eax
  803204:	f7 f5                	div    %ebp
  803206:	89 c1                	mov    %eax,%ecx
  803208:	89 d8                	mov    %ebx,%eax
  80320a:	f7 f5                	div    %ebp
  80320c:	89 cf                	mov    %ecx,%edi
  80320e:	89 fa                	mov    %edi,%edx
  803210:	83 c4 1c             	add    $0x1c,%esp
  803213:	5b                   	pop    %ebx
  803214:	5e                   	pop    %esi
  803215:	5f                   	pop    %edi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    
  803218:	39 ce                	cmp    %ecx,%esi
  80321a:	77 28                	ja     803244 <__udivdi3+0x7c>
  80321c:	0f bd fe             	bsr    %esi,%edi
  80321f:	83 f7 1f             	xor    $0x1f,%edi
  803222:	75 40                	jne    803264 <__udivdi3+0x9c>
  803224:	39 ce                	cmp    %ecx,%esi
  803226:	72 0a                	jb     803232 <__udivdi3+0x6a>
  803228:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80322c:	0f 87 9e 00 00 00    	ja     8032d0 <__udivdi3+0x108>
  803232:	b8 01 00 00 00       	mov    $0x1,%eax
  803237:	89 fa                	mov    %edi,%edx
  803239:	83 c4 1c             	add    $0x1c,%esp
  80323c:	5b                   	pop    %ebx
  80323d:	5e                   	pop    %esi
  80323e:	5f                   	pop    %edi
  80323f:	5d                   	pop    %ebp
  803240:	c3                   	ret    
  803241:	8d 76 00             	lea    0x0(%esi),%esi
  803244:	31 ff                	xor    %edi,%edi
  803246:	31 c0                	xor    %eax,%eax
  803248:	89 fa                	mov    %edi,%edx
  80324a:	83 c4 1c             	add    $0x1c,%esp
  80324d:	5b                   	pop    %ebx
  80324e:	5e                   	pop    %esi
  80324f:	5f                   	pop    %edi
  803250:	5d                   	pop    %ebp
  803251:	c3                   	ret    
  803252:	66 90                	xchg   %ax,%ax
  803254:	89 d8                	mov    %ebx,%eax
  803256:	f7 f7                	div    %edi
  803258:	31 ff                	xor    %edi,%edi
  80325a:	89 fa                	mov    %edi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	bd 20 00 00 00       	mov    $0x20,%ebp
  803269:	89 eb                	mov    %ebp,%ebx
  80326b:	29 fb                	sub    %edi,%ebx
  80326d:	89 f9                	mov    %edi,%ecx
  80326f:	d3 e6                	shl    %cl,%esi
  803271:	89 c5                	mov    %eax,%ebp
  803273:	88 d9                	mov    %bl,%cl
  803275:	d3 ed                	shr    %cl,%ebp
  803277:	89 e9                	mov    %ebp,%ecx
  803279:	09 f1                	or     %esi,%ecx
  80327b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80327f:	89 f9                	mov    %edi,%ecx
  803281:	d3 e0                	shl    %cl,%eax
  803283:	89 c5                	mov    %eax,%ebp
  803285:	89 d6                	mov    %edx,%esi
  803287:	88 d9                	mov    %bl,%cl
  803289:	d3 ee                	shr    %cl,%esi
  80328b:	89 f9                	mov    %edi,%ecx
  80328d:	d3 e2                	shl    %cl,%edx
  80328f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803293:	88 d9                	mov    %bl,%cl
  803295:	d3 e8                	shr    %cl,%eax
  803297:	09 c2                	or     %eax,%edx
  803299:	89 d0                	mov    %edx,%eax
  80329b:	89 f2                	mov    %esi,%edx
  80329d:	f7 74 24 0c          	divl   0xc(%esp)
  8032a1:	89 d6                	mov    %edx,%esi
  8032a3:	89 c3                	mov    %eax,%ebx
  8032a5:	f7 e5                	mul    %ebp
  8032a7:	39 d6                	cmp    %edx,%esi
  8032a9:	72 19                	jb     8032c4 <__udivdi3+0xfc>
  8032ab:	74 0b                	je     8032b8 <__udivdi3+0xf0>
  8032ad:	89 d8                	mov    %ebx,%eax
  8032af:	31 ff                	xor    %edi,%edi
  8032b1:	e9 58 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032b6:	66 90                	xchg   %ax,%ax
  8032b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032bc:	89 f9                	mov    %edi,%ecx
  8032be:	d3 e2                	shl    %cl,%edx
  8032c0:	39 c2                	cmp    %eax,%edx
  8032c2:	73 e9                	jae    8032ad <__udivdi3+0xe5>
  8032c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032c7:	31 ff                	xor    %edi,%edi
  8032c9:	e9 40 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	31 c0                	xor    %eax,%eax
  8032d2:	e9 37 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032d7:	90                   	nop

008032d8 <__umoddi3>:
  8032d8:	55                   	push   %ebp
  8032d9:	57                   	push   %edi
  8032da:	56                   	push   %esi
  8032db:	53                   	push   %ebx
  8032dc:	83 ec 1c             	sub    $0x1c,%esp
  8032df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032f7:	89 f3                	mov    %esi,%ebx
  8032f9:	89 fa                	mov    %edi,%edx
  8032fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ff:	89 34 24             	mov    %esi,(%esp)
  803302:	85 c0                	test   %eax,%eax
  803304:	75 1a                	jne    803320 <__umoddi3+0x48>
  803306:	39 f7                	cmp    %esi,%edi
  803308:	0f 86 a2 00 00 00    	jbe    8033b0 <__umoddi3+0xd8>
  80330e:	89 c8                	mov    %ecx,%eax
  803310:	89 f2                	mov    %esi,%edx
  803312:	f7 f7                	div    %edi
  803314:	89 d0                	mov    %edx,%eax
  803316:	31 d2                	xor    %edx,%edx
  803318:	83 c4 1c             	add    $0x1c,%esp
  80331b:	5b                   	pop    %ebx
  80331c:	5e                   	pop    %esi
  80331d:	5f                   	pop    %edi
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    
  803320:	39 f0                	cmp    %esi,%eax
  803322:	0f 87 ac 00 00 00    	ja     8033d4 <__umoddi3+0xfc>
  803328:	0f bd e8             	bsr    %eax,%ebp
  80332b:	83 f5 1f             	xor    $0x1f,%ebp
  80332e:	0f 84 ac 00 00 00    	je     8033e0 <__umoddi3+0x108>
  803334:	bf 20 00 00 00       	mov    $0x20,%edi
  803339:	29 ef                	sub    %ebp,%edi
  80333b:	89 fe                	mov    %edi,%esi
  80333d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803341:	89 e9                	mov    %ebp,%ecx
  803343:	d3 e0                	shl    %cl,%eax
  803345:	89 d7                	mov    %edx,%edi
  803347:	89 f1                	mov    %esi,%ecx
  803349:	d3 ef                	shr    %cl,%edi
  80334b:	09 c7                	or     %eax,%edi
  80334d:	89 e9                	mov    %ebp,%ecx
  80334f:	d3 e2                	shl    %cl,%edx
  803351:	89 14 24             	mov    %edx,(%esp)
  803354:	89 d8                	mov    %ebx,%eax
  803356:	d3 e0                	shl    %cl,%eax
  803358:	89 c2                	mov    %eax,%edx
  80335a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335e:	d3 e0                	shl    %cl,%eax
  803360:	89 44 24 04          	mov    %eax,0x4(%esp)
  803364:	8b 44 24 08          	mov    0x8(%esp),%eax
  803368:	89 f1                	mov    %esi,%ecx
  80336a:	d3 e8                	shr    %cl,%eax
  80336c:	09 d0                	or     %edx,%eax
  80336e:	d3 eb                	shr    %cl,%ebx
  803370:	89 da                	mov    %ebx,%edx
  803372:	f7 f7                	div    %edi
  803374:	89 d3                	mov    %edx,%ebx
  803376:	f7 24 24             	mull   (%esp)
  803379:	89 c6                	mov    %eax,%esi
  80337b:	89 d1                	mov    %edx,%ecx
  80337d:	39 d3                	cmp    %edx,%ebx
  80337f:	0f 82 87 00 00 00    	jb     80340c <__umoddi3+0x134>
  803385:	0f 84 91 00 00 00    	je     80341c <__umoddi3+0x144>
  80338b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80338f:	29 f2                	sub    %esi,%edx
  803391:	19 cb                	sbb    %ecx,%ebx
  803393:	89 d8                	mov    %ebx,%eax
  803395:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803399:	d3 e0                	shl    %cl,%eax
  80339b:	89 e9                	mov    %ebp,%ecx
  80339d:	d3 ea                	shr    %cl,%edx
  80339f:	09 d0                	or     %edx,%eax
  8033a1:	89 e9                	mov    %ebp,%ecx
  8033a3:	d3 eb                	shr    %cl,%ebx
  8033a5:	89 da                	mov    %ebx,%edx
  8033a7:	83 c4 1c             	add    $0x1c,%esp
  8033aa:	5b                   	pop    %ebx
  8033ab:	5e                   	pop    %esi
  8033ac:	5f                   	pop    %edi
  8033ad:	5d                   	pop    %ebp
  8033ae:	c3                   	ret    
  8033af:	90                   	nop
  8033b0:	89 fd                	mov    %edi,%ebp
  8033b2:	85 ff                	test   %edi,%edi
  8033b4:	75 0b                	jne    8033c1 <__umoddi3+0xe9>
  8033b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bb:	31 d2                	xor    %edx,%edx
  8033bd:	f7 f7                	div    %edi
  8033bf:	89 c5                	mov    %eax,%ebp
  8033c1:	89 f0                	mov    %esi,%eax
  8033c3:	31 d2                	xor    %edx,%edx
  8033c5:	f7 f5                	div    %ebp
  8033c7:	89 c8                	mov    %ecx,%eax
  8033c9:	f7 f5                	div    %ebp
  8033cb:	89 d0                	mov    %edx,%eax
  8033cd:	e9 44 ff ff ff       	jmp    803316 <__umoddi3+0x3e>
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	89 c8                	mov    %ecx,%eax
  8033d6:	89 f2                	mov    %esi,%edx
  8033d8:	83 c4 1c             	add    $0x1c,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5e                   	pop    %esi
  8033dd:	5f                   	pop    %edi
  8033de:	5d                   	pop    %ebp
  8033df:	c3                   	ret    
  8033e0:	3b 04 24             	cmp    (%esp),%eax
  8033e3:	72 06                	jb     8033eb <__umoddi3+0x113>
  8033e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033e9:	77 0f                	ja     8033fa <__umoddi3+0x122>
  8033eb:	89 f2                	mov    %esi,%edx
  8033ed:	29 f9                	sub    %edi,%ecx
  8033ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033f3:	89 14 24             	mov    %edx,(%esp)
  8033f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033fe:	8b 14 24             	mov    (%esp),%edx
  803401:	83 c4 1c             	add    $0x1c,%esp
  803404:	5b                   	pop    %ebx
  803405:	5e                   	pop    %esi
  803406:	5f                   	pop    %edi
  803407:	5d                   	pop    %ebp
  803408:	c3                   	ret    
  803409:	8d 76 00             	lea    0x0(%esi),%esi
  80340c:	2b 04 24             	sub    (%esp),%eax
  80340f:	19 fa                	sbb    %edi,%edx
  803411:	89 d1                	mov    %edx,%ecx
  803413:	89 c6                	mov    %eax,%esi
  803415:	e9 71 ff ff ff       	jmp    80338b <__umoddi3+0xb3>
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803420:	72 ea                	jb     80340c <__umoddi3+0x134>
  803422:	89 d9                	mov    %ebx,%ecx
  803424:	e9 62 ff ff ff       	jmp    80338b <__umoddi3+0xb3>
