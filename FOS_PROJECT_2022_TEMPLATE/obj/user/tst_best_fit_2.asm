
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 6c 21 00 00       	call   8021b6 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
  80005f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 30 80 00       	mov    0x803020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 80 24 80 00       	push   $0x802480
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 9c 24 80 00       	push   $0x80249c
  8000a7:	e8 8e 09 00 00       	call   800a3a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 dc 19 00 00       	call   801a92 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 ad 19 00 00       	call   801a92 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 b4 24 80 00       	push   $0x8024b4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 9c 24 80 00       	push   $0x80249c
  800101:	e8 34 09 00 00       	call   800a3a <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 96 1b 00 00       	call   801ca1 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 2e 1c 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 6b 19 00 00       	call   801a92 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 f8 24 80 00       	push   $0x8024f8
  80013f:	6a 31                	push   $0x31
  800141:	68 9c 24 80 00       	push   $0x80249c
  800146:	e8 ef 08 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 f1 1b 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 28 25 80 00       	push   $0x802528
  800162:	6a 33                	push   $0x33
  800164:	68 9c 24 80 00       	push   $0x80249c
  800169:	e8 cc 08 00 00       	call   800a3a <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 2e 1b 00 00       	call   801ca1 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 c6 1b 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 03 19 00 00       	call   801a92 <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 f8 24 80 00       	push   $0x8024f8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 9c 24 80 00       	push   $0x80249c
  8001b7:	e8 7e 08 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 80 1b 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 28 25 80 00       	push   $0x802528
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 9c 24 80 00       	push   $0x80249c
  8001da:	e8 5b 08 00 00       	call   800a3a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 bd 1a 00 00       	call   801ca1 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 55 1b 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 95 18 00 00       	call   801a92 <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 f8 24 80 00       	push   $0x8024f8
  80021f:	6a 41                	push   $0x41
  800221:	68 9c 24 80 00       	push   $0x80249c
  800226:	e8 0f 08 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 11 1b 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 28 25 80 00       	push   $0x802528
  800240:	6a 43                	push   $0x43
  800242:	68 9c 24 80 00       	push   $0x80249c
  800247:	e8 ee 07 00 00       	call   800a3a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 50 1a 00 00       	call   801ca1 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 e8 1a 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 28 18 00 00       	call   801a92 <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 f8 24 80 00       	push   $0x8024f8
  800296:	6a 49                	push   $0x49
  800298:	68 9c 24 80 00       	push   $0x80249c
  80029d:	e8 98 07 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 9a 1a 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 28 25 80 00       	push   $0x802528
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 9c 24 80 00       	push   $0x80249c
  8002be:	e8 77 07 00 00       	call   800a3a <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 d9 19 00 00       	call   801ca1 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 71 1a 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 f4 17 00 00       	call   801ad3 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 5a 1a 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 45 25 80 00       	push   $0x802545
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 9c 24 80 00       	push   $0x80249c
  800302:	e8 33 07 00 00       	call   800a3a <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 95 19 00 00       	call   801ca1 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 2d 1a 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 65 17 00 00       	call   801a92 <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 f8 24 80 00       	push   $0x8024f8
  800359:	6a 58                	push   $0x58
  80035b:	68 9c 24 80 00       	push   $0x80249c
  800360:	e8 d5 06 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 d7 19 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 28 25 80 00       	push   $0x802528
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 9c 24 80 00       	push   $0x80249c
  800381:	e8 b4 06 00 00       	call   800a3a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 16 19 00 00       	call   801ca1 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 ae 19 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 31 17 00 00       	call   801ad3 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 97 19 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 45 25 80 00       	push   $0x802545
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 9c 24 80 00       	push   $0x80249c
  8003c7:	e8 6e 06 00 00       	call   800a3a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 d0 18 00 00       	call   801ca1 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 68 19 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 a1 16 00 00       	call   801a92 <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 f8 24 80 00       	push   $0x8024f8
  80041d:	6a 67                	push   $0x67
  80041f:	68 9c 24 80 00       	push   $0x80249c
  800424:	e8 11 06 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 13 19 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 28 25 80 00       	push   $0x802528
  800454:	6a 69                	push   $0x69
  800456:	68 9c 24 80 00       	push   $0x80249c
  80045b:	e8 da 05 00 00       	call   800a3a <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 3c 18 00 00       	call   801ca1 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 d4 18 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 09 16 00 00       	call   801a92 <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 f8 24 80 00       	push   $0x8024f8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 9c 24 80 00       	push   $0x80249c
  8004c3:	e8 72 05 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 74 18 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 28 25 80 00       	push   $0x802528
  8004df:	6a 71                	push   $0x71
  8004e1:	68 9c 24 80 00       	push   $0x80249c
  8004e6:	e8 4f 05 00 00       	call   800a3a <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 b1 17 00 00       	call   801ca1 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 49 18 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 81 15 00 00       	call   801a92 <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 f8 24 80 00       	push   $0x8024f8
  800547:	6a 77                	push   $0x77
  800549:	68 9c 24 80 00       	push   $0x80249c
  80054e:	e8 e7 04 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 e9 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 28 25 80 00       	push   $0x802528
  80057f:	6a 79                	push   $0x79
  800581:	68 9c 24 80 00       	push   $0x80249c
  800586:	e8 af 04 00 00       	call   800a3a <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 11 17 00 00       	call   801ca1 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 a9 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 2c 15 00 00       	call   801ad3 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 92 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 45 25 80 00       	push   $0x802545
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 9c 24 80 00       	push   $0x80249c
  8005cf:	e8 66 04 00 00       	call   800a3a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 c8 16 00 00       	call   801ca1 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 60 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 e3 14 00 00       	call   801ad3 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 49 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 45 25 80 00       	push   $0x802545
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 9c 24 80 00       	push   $0x80249c
  800618:	e8 1d 04 00 00       	call   800a3a <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 7f 16 00 00       	call   801ca1 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 17 17 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 54 14 00 00       	call   801a92 <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 f8 24 80 00       	push   $0x8024f8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 9c 24 80 00       	push   $0x80249c
  80067b:	e8 ba 03 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 bc 16 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 28 25 80 00       	push   $0x802528
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 9c 24 80 00       	push   $0x80249c
  8006a1:	e8 94 03 00 00       	call   800a3a <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 f6 15 00 00       	call   801ca1 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 8e 16 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 c8 13 00 00       	call   801a92 <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 f8 24 80 00       	push   $0x8024f8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 9c 24 80 00       	push   $0x80249c
  800704:	e8 31 03 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 33 16 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 28 25 80 00       	push   $0x802528
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 9c 24 80 00       	push   $0x80249c
  800728:	e8 0d 03 00 00       	call   800a3a <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 6f 15 00 00       	call   801ca1 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 07 16 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 8a 13 00 00       	call   801ad3 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 f0 15 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 45 25 80 00       	push   $0x802545
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 9c 24 80 00       	push   $0x80249c
  800771:	e8 c4 02 00 00       	call   800a3a <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 26 15 00 00       	call   801ca1 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 be 15 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 f7 12 00 00       	call   801a92 <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 f8 24 80 00       	push   $0x8024f8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 9c 24 80 00       	push   $0x80249c
  8007d1:	e8 64 02 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 66 15 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 28 25 80 00       	push   $0x802528
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 9c 24 80 00       	push   $0x80249c
  80080b:	e8 2a 02 00 00       	call   800a3a <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 8c 14 00 00       	call   801ca1 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 24 15 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 60 12 00 00       	call   801a92 <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 f8 24 80 00       	push   $0x8024f8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 9c 24 80 00       	push   $0x80249c
  800854:	e8 e1 01 00 00       	call   800a3a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 e3 14 00 00       	call   801d41 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 28 25 80 00       	push   $0x802528
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 9c 24 80 00       	push   $0x80249c
  80088b:	e8 aa 01 00 00       	call   800a3a <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 e3 11 00 00       	call   801a92 <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 5c 25 80 00       	push   $0x80255c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 9c 24 80 00       	push   $0x80249c
  8008ce:	e8 67 01 00 00       	call   800a3a <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 c0 25 80 00       	push   $0x8025c0
  8008db:	e8 0e 04 00 00       	call   800cee <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 8b 16 00 00       	call   801f81 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	01 c0                	add    %eax,%eax
  800900:	01 d0                	add    %edx,%eax
  800902:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800909:	01 c8                	add    %ecx,%eax
  80090b:	c1 e0 02             	shl    $0x2,%eax
  80090e:	01 d0                	add    %edx,%eax
  800910:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800917:	01 c8                	add    %ecx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	01 d0                	add    %edx,%eax
  800923:	c1 e0 03             	shl    $0x3,%eax
  800926:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80092b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800930:	a1 20 30 80 00       	mov    0x803020,%eax
  800935:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80093b:	84 c0                	test   %al,%al
  80093d:	74 0f                	je     80094e <libmain+0x63>
		binaryname = myEnv->prog_name;
  80093f:	a1 20 30 80 00       	mov    0x803020,%eax
  800944:	05 18 da 01 00       	add    $0x1da18,%eax
  800949:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80094e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800952:	7e 0a                	jle    80095e <libmain+0x73>
		binaryname = argv[0];
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	ff 75 08             	pushl  0x8(%ebp)
  800967:	e8 cc f6 ff ff       	call   800038 <_main>
  80096c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80096f:	e8 1a 14 00 00       	call   801d8e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	68 20 26 80 00       	push   $0x802620
  80097c:	e8 6d 03 00 00       	call   800cee <cprintf>
  800981:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800984:	a1 20 30 80 00       	mov    0x803020,%eax
  800989:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80098f:	a1 20 30 80 00       	mov    0x803020,%eax
  800994:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80099a:	83 ec 04             	sub    $0x4,%esp
  80099d:	52                   	push   %edx
  80099e:	50                   	push   %eax
  80099f:	68 48 26 80 00       	push   $0x802648
  8009a4:	e8 45 03 00 00       	call   800cee <cprintf>
  8009a9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8009ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8009b1:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8009b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8009bc:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8009c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8009c7:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8009cd:	51                   	push   %ecx
  8009ce:	52                   	push   %edx
  8009cf:	50                   	push   %eax
  8009d0:	68 70 26 80 00       	push   $0x802670
  8009d5:	e8 14 03 00 00       	call   800cee <cprintf>
  8009da:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e2:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	50                   	push   %eax
  8009ec:	68 c8 26 80 00       	push   $0x8026c8
  8009f1:	e8 f8 02 00 00       	call   800cee <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009f9:	83 ec 0c             	sub    $0xc,%esp
  8009fc:	68 20 26 80 00       	push   $0x802620
  800a01:	e8 e8 02 00 00       	call   800cee <cprintf>
  800a06:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a09:	e8 9a 13 00 00       	call   801da8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a0e:	e8 19 00 00 00       	call   800a2c <exit>
}
  800a13:	90                   	nop
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a1c:	83 ec 0c             	sub    $0xc,%esp
  800a1f:	6a 00                	push   $0x0
  800a21:	e8 27 15 00 00       	call   801f4d <sys_destroy_env>
  800a26:	83 c4 10             	add    $0x10,%esp
}
  800a29:	90                   	nop
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <exit>:

void
exit(void)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a32:	e8 7c 15 00 00       	call   801fb3 <sys_exit_env>
}
  800a37:	90                   	nop
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a40:	8d 45 10             	lea    0x10(%ebp),%eax
  800a43:	83 c0 04             	add    $0x4,%eax
  800a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a49:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800a4e:	85 c0                	test   %eax,%eax
  800a50:	74 16                	je     800a68 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a52:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	50                   	push   %eax
  800a5b:	68 dc 26 80 00       	push   $0x8026dc
  800a60:	e8 89 02 00 00       	call   800cee <cprintf>
  800a65:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a68:	a1 00 30 80 00       	mov    0x803000,%eax
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	50                   	push   %eax
  800a74:	68 e1 26 80 00       	push   $0x8026e1
  800a79:	e8 70 02 00 00       	call   800cee <cprintf>
  800a7e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a81:	8b 45 10             	mov    0x10(%ebp),%eax
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	e8 f3 01 00 00       	call   800c83 <vcprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	6a 00                	push   $0x0
  800a98:	68 fd 26 80 00       	push   $0x8026fd
  800a9d:	e8 e1 01 00 00       	call   800c83 <vcprintf>
  800aa2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800aa5:	e8 82 ff ff ff       	call   800a2c <exit>

	// should not return here
	while (1) ;
  800aaa:	eb fe                	jmp    800aaa <_panic+0x70>

00800aac <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ab2:	a1 20 30 80 00       	mov    0x803020,%eax
  800ab7:	8b 50 74             	mov    0x74(%eax),%edx
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	39 c2                	cmp    %eax,%edx
  800abf:	74 14                	je     800ad5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ac1:	83 ec 04             	sub    $0x4,%esp
  800ac4:	68 00 27 80 00       	push   $0x802700
  800ac9:	6a 26                	push   $0x26
  800acb:	68 4c 27 80 00       	push   $0x80274c
  800ad0:	e8 65 ff ff ff       	call   800a3a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800adc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ae3:	e9 c2 00 00 00       	jmp    800baa <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	01 d0                	add    %edx,%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	85 c0                	test   %eax,%eax
  800afb:	75 08                	jne    800b05 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800afd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b00:	e9 a2 00 00 00       	jmp    800ba7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b0c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b13:	eb 69                	jmp    800b7e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b15:	a1 20 30 80 00       	mov    0x803020,%eax
  800b1a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b23:	89 d0                	mov    %edx,%eax
  800b25:	01 c0                	add    %eax,%eax
  800b27:	01 d0                	add    %edx,%eax
  800b29:	c1 e0 03             	shl    $0x3,%eax
  800b2c:	01 c8                	add    %ecx,%eax
  800b2e:	8a 40 04             	mov    0x4(%eax),%al
  800b31:	84 c0                	test   %al,%al
  800b33:	75 46                	jne    800b7b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b35:	a1 20 30 80 00       	mov    0x803020,%eax
  800b3a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b43:	89 d0                	mov    %edx,%eax
  800b45:	01 c0                	add    %eax,%eax
  800b47:	01 d0                	add    %edx,%eax
  800b49:	c1 e0 03             	shl    $0x3,%eax
  800b4c:	01 c8                	add    %ecx,%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b5b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b60:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 c8                	add    %ecx,%eax
  800b6c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 09                	jne    800b7b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b72:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b79:	eb 12                	jmp    800b8d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b7b:	ff 45 e8             	incl   -0x18(%ebp)
  800b7e:	a1 20 30 80 00       	mov    0x803020,%eax
  800b83:	8b 50 74             	mov    0x74(%eax),%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	77 88                	ja     800b15 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b91:	75 14                	jne    800ba7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	68 58 27 80 00       	push   $0x802758
  800b9b:	6a 3a                	push   $0x3a
  800b9d:	68 4c 27 80 00       	push   $0x80274c
  800ba2:	e8 93 fe ff ff       	call   800a3a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ba7:	ff 45 f0             	incl   -0x10(%ebp)
  800baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bb0:	0f 8c 32 ff ff ff    	jl     800ae8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800bb6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bbd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bc4:	eb 26                	jmp    800bec <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bc6:	a1 20 30 80 00       	mov    0x803020,%eax
  800bcb:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800bd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	01 c0                	add    %eax,%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	c1 e0 03             	shl    $0x3,%eax
  800bdd:	01 c8                	add    %ecx,%eax
  800bdf:	8a 40 04             	mov    0x4(%eax),%al
  800be2:	3c 01                	cmp    $0x1,%al
  800be4:	75 03                	jne    800be9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800be6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800be9:	ff 45 e0             	incl   -0x20(%ebp)
  800bec:	a1 20 30 80 00       	mov    0x803020,%eax
  800bf1:	8b 50 74             	mov    0x74(%eax),%edx
  800bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf7:	39 c2                	cmp    %eax,%edx
  800bf9:	77 cb                	ja     800bc6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bfe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c01:	74 14                	je     800c17 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 ac 27 80 00       	push   $0x8027ac
  800c0b:	6a 44                	push   $0x44
  800c0d:	68 4c 27 80 00       	push   $0x80274c
  800c12:	e8 23 fe ff ff       	call   800a3a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c17:	90                   	nop
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 48 01             	lea    0x1(%eax),%ecx
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	89 0a                	mov    %ecx,(%edx)
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	88 d1                	mov    %dl,%cl
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c35:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c43:	75 2c                	jne    800c71 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c45:	a0 24 30 80 00       	mov    0x803024,%al
  800c4a:	0f b6 c0             	movzbl %al,%eax
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8b 12                	mov    (%edx),%edx
  800c52:	89 d1                	mov    %edx,%ecx
  800c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c57:	83 c2 08             	add    $0x8,%edx
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	50                   	push   %eax
  800c5e:	51                   	push   %ecx
  800c5f:	52                   	push   %edx
  800c60:	e8 7b 0f 00 00       	call   801be0 <sys_cputs>
  800c65:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8b 40 04             	mov    0x4(%eax),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c80:	90                   	nop
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c8c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c93:	00 00 00 
	b.cnt = 0;
  800c96:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c9d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cac:	50                   	push   %eax
  800cad:	68 1a 0c 80 00       	push   $0x800c1a
  800cb2:	e8 11 02 00 00       	call   800ec8 <vprintfmt>
  800cb7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cba:	a0 24 30 80 00       	mov    0x803024,%al
  800cbf:	0f b6 c0             	movzbl %al,%eax
  800cc2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cc8:	83 ec 04             	sub    $0x4,%esp
  800ccb:	50                   	push   %eax
  800ccc:	52                   	push   %edx
  800ccd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cd3:	83 c0 08             	add    $0x8,%eax
  800cd6:	50                   	push   %eax
  800cd7:	e8 04 0f 00 00       	call   801be0 <sys_cputs>
  800cdc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800cdf:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800ce6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <cprintf>:

int cprintf(const char *fmt, ...) {
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cf4:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800cfb:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0a:	50                   	push   %eax
  800d0b:	e8 73 ff ff ff       	call   800c83 <vcprintf>
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d21:	e8 68 10 00 00       	call   801d8e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 f4             	pushl  -0xc(%ebp)
  800d35:	50                   	push   %eax
  800d36:	e8 48 ff ff ff       	call   800c83 <vcprintf>
  800d3b:	83 c4 10             	add    $0x10,%esp
  800d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d41:	e8 62 10 00 00       	call   801da8 <sys_enable_interrupt>
	return cnt;
  800d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 14             	sub    $0x14,%esp
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d5e:	8b 45 18             	mov    0x18(%ebp),%eax
  800d61:	ba 00 00 00 00       	mov    $0x0,%edx
  800d66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d69:	77 55                	ja     800dc0 <printnum+0x75>
  800d6b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d6e:	72 05                	jb     800d75 <printnum+0x2a>
  800d70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d73:	77 4b                	ja     800dc0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d78:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d7b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d83:	52                   	push   %edx
  800d84:	50                   	push   %eax
  800d85:	ff 75 f4             	pushl  -0xc(%ebp)
  800d88:	ff 75 f0             	pushl  -0x10(%ebp)
  800d8b:	e8 84 14 00 00       	call   802214 <__udivdi3>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	ff 75 20             	pushl  0x20(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	ff 75 18             	pushl  0x18(%ebp)
  800d9d:	52                   	push   %edx
  800d9e:	50                   	push   %eax
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 a1 ff ff ff       	call   800d4b <printnum>
  800daa:	83 c4 20             	add    $0x20,%esp
  800dad:	eb 1a                	jmp    800dc9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800daf:	83 ec 08             	sub    $0x8,%esp
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 20             	pushl  0x20(%ebp)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	ff d0                	call   *%eax
  800dbd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dc0:	ff 4d 1c             	decl   0x1c(%ebp)
  800dc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dc7:	7f e6                	jg     800daf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dc9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd7:	53                   	push   %ebx
  800dd8:	51                   	push   %ecx
  800dd9:	52                   	push   %edx
  800dda:	50                   	push   %eax
  800ddb:	e8 44 15 00 00       	call   802324 <__umoddi3>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	05 14 2a 80 00       	add    $0x802a14,%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	50                   	push   %eax
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
}
  800dfc:	90                   	nop
  800dfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e05:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e09:	7e 1c                	jle    800e27 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8b 00                	mov    (%eax),%eax
  800e10:	8d 50 08             	lea    0x8(%eax),%edx
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 10                	mov    %edx,(%eax)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8b 00                	mov    (%eax),%eax
  800e1d:	83 e8 08             	sub    $0x8,%eax
  800e20:	8b 50 04             	mov    0x4(%eax),%edx
  800e23:	8b 00                	mov    (%eax),%eax
  800e25:	eb 40                	jmp    800e67 <getuint+0x65>
	else if (lflag)
  800e27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e2b:	74 1e                	je     800e4b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	8d 50 04             	lea    0x4(%eax),%edx
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 10                	mov    %edx,(%eax)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	83 e8 04             	sub    $0x4,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	ba 00 00 00 00       	mov    $0x0,%edx
  800e49:	eb 1c                	jmp    800e67 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	8d 50 04             	lea    0x4(%eax),%edx
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	89 10                	mov    %edx,(%eax)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	83 e8 04             	sub    $0x4,%eax
  800e60:	8b 00                	mov    (%eax),%eax
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e70:	7e 1c                	jle    800e8e <getint+0x25>
		return va_arg(*ap, long long);
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8b 00                	mov    (%eax),%eax
  800e77:	8d 50 08             	lea    0x8(%eax),%edx
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 10                	mov    %edx,(%eax)
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 e8 08             	sub    $0x8,%eax
  800e87:	8b 50 04             	mov    0x4(%eax),%edx
  800e8a:	8b 00                	mov    (%eax),%eax
  800e8c:	eb 38                	jmp    800ec6 <getint+0x5d>
	else if (lflag)
  800e8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e92:	74 1a                	je     800eae <getint+0x45>
		return va_arg(*ap, long);
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8b 00                	mov    (%eax),%eax
  800e99:	8d 50 04             	lea    0x4(%eax),%edx
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 10                	mov    %edx,(%eax)
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	83 e8 04             	sub    $0x4,%eax
  800ea9:	8b 00                	mov    (%eax),%eax
  800eab:	99                   	cltd   
  800eac:	eb 18                	jmp    800ec6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	8d 50 04             	lea    0x4(%eax),%edx
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	89 10                	mov    %edx,(%eax)
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	99                   	cltd   
}
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed0:	eb 17                	jmp    800ee9 <vprintfmt+0x21>
			if (ch == '\0')
  800ed2:	85 db                	test   %ebx,%ebx
  800ed4:	0f 84 af 03 00 00    	je     801289 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	53                   	push   %ebx
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d8             	movzbl %al,%ebx
  800ef7:	83 fb 25             	cmp    $0x25,%ebx
  800efa:	75 d6                	jne    800ed2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800efc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f00:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	8d 50 01             	lea    0x1(%eax),%edx
  800f22:	89 55 10             	mov    %edx,0x10(%ebp)
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	0f b6 d8             	movzbl %al,%ebx
  800f2a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f2d:	83 f8 55             	cmp    $0x55,%eax
  800f30:	0f 87 2b 03 00 00    	ja     801261 <vprintfmt+0x399>
  800f36:	8b 04 85 38 2a 80 00 	mov    0x802a38(,%eax,4),%eax
  800f3d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f3f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f43:	eb d7                	jmp    800f1c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f45:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f49:	eb d1                	jmp    800f1c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	c1 e0 02             	shl    $0x2,%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	01 c0                	add    %eax,%eax
  800f5e:	01 d8                	add    %ebx,%eax
  800f60:	83 e8 30             	sub    $0x30,%eax
  800f63:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f66:	8b 45 10             	mov    0x10(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f6e:	83 fb 2f             	cmp    $0x2f,%ebx
  800f71:	7e 3e                	jle    800fb1 <vprintfmt+0xe9>
  800f73:	83 fb 39             	cmp    $0x39,%ebx
  800f76:	7f 39                	jg     800fb1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f78:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f7b:	eb d5                	jmp    800f52 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	83 c0 04             	add    $0x4,%eax
  800f83:	89 45 14             	mov    %eax,0x14(%ebp)
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	83 e8 04             	sub    $0x4,%eax
  800f8c:	8b 00                	mov    (%eax),%eax
  800f8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f91:	eb 1f                	jmp    800fb2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f97:	79 83                	jns    800f1c <vprintfmt+0x54>
				width = 0;
  800f99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fa0:	e9 77 ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fa5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fac:	e9 6b ff ff ff       	jmp    800f1c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fb1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb6:	0f 89 60 ff ff ff    	jns    800f1c <vprintfmt+0x54>
				width = precision, precision = -1;
  800fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fc2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fc9:	e9 4e ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fd1:	e9 46 ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd9:	83 c0 04             	add    $0x4,%eax
  800fdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe2:	83 e8 04             	sub    $0x4,%eax
  800fe5:	8b 00                	mov    (%eax),%eax
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	50                   	push   %eax
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	ff d0                	call   *%eax
  800ff3:	83 c4 10             	add    $0x10,%esp
			break;
  800ff6:	e9 89 02 00 00       	jmp    801284 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 c0 04             	add    $0x4,%eax
  801001:	89 45 14             	mov    %eax,0x14(%ebp)
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	83 e8 04             	sub    $0x4,%eax
  80100a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80100c:	85 db                	test   %ebx,%ebx
  80100e:	79 02                	jns    801012 <vprintfmt+0x14a>
				err = -err;
  801010:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801012:	83 fb 64             	cmp    $0x64,%ebx
  801015:	7f 0b                	jg     801022 <vprintfmt+0x15a>
  801017:	8b 34 9d 80 28 80 00 	mov    0x802880(,%ebx,4),%esi
  80101e:	85 f6                	test   %esi,%esi
  801020:	75 19                	jne    80103b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801022:	53                   	push   %ebx
  801023:	68 25 2a 80 00       	push   $0x802a25
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	ff 75 08             	pushl  0x8(%ebp)
  80102e:	e8 5e 02 00 00       	call   801291 <printfmt>
  801033:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801036:	e9 49 02 00 00       	jmp    801284 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80103b:	56                   	push   %esi
  80103c:	68 2e 2a 80 00       	push   $0x802a2e
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 45 02 00 00       	call   801291 <printfmt>
  80104c:	83 c4 10             	add    $0x10,%esp
			break;
  80104f:	e9 30 02 00 00       	jmp    801284 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 c0 04             	add    $0x4,%eax
  80105a:	89 45 14             	mov    %eax,0x14(%ebp)
  80105d:	8b 45 14             	mov    0x14(%ebp),%eax
  801060:	83 e8 04             	sub    $0x4,%eax
  801063:	8b 30                	mov    (%eax),%esi
  801065:	85 f6                	test   %esi,%esi
  801067:	75 05                	jne    80106e <vprintfmt+0x1a6>
				p = "(null)";
  801069:	be 31 2a 80 00       	mov    $0x802a31,%esi
			if (width > 0 && padc != '-')
  80106e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801072:	7e 6d                	jle    8010e1 <vprintfmt+0x219>
  801074:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801078:	74 67                	je     8010e1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80107a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	50                   	push   %eax
  801081:	56                   	push   %esi
  801082:	e8 0c 03 00 00       	call   801393 <strnlen>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80108d:	eb 16                	jmp    8010a5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80108f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	50                   	push   %eax
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	ff d0                	call   *%eax
  80109f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8010a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a9:	7f e4                	jg     80108f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ab:	eb 34                	jmp    8010e1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010b1:	74 1c                	je     8010cf <vprintfmt+0x207>
  8010b3:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b6:	7e 05                	jle    8010bd <vprintfmt+0x1f5>
  8010b8:	83 fb 7e             	cmp    $0x7e,%ebx
  8010bb:	7e 12                	jle    8010cf <vprintfmt+0x207>
					putch('?', putdat);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	6a 3f                	push   $0x3f
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	eb 0f                	jmp    8010de <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	53                   	push   %ebx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010de:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e1:	89 f0                	mov    %esi,%eax
  8010e3:	8d 70 01             	lea    0x1(%eax),%esi
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	0f be d8             	movsbl %al,%ebx
  8010eb:	85 db                	test   %ebx,%ebx
  8010ed:	74 24                	je     801113 <vprintfmt+0x24b>
  8010ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010f3:	78 b8                	js     8010ad <vprintfmt+0x1e5>
  8010f5:	ff 4d e0             	decl   -0x20(%ebp)
  8010f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010fc:	79 af                	jns    8010ad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fe:	eb 13                	jmp    801113 <vprintfmt+0x24b>
				putch(' ', putdat);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	6a 20                	push   $0x20
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	ff d0                	call   *%eax
  80110d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801110:	ff 4d e4             	decl   -0x1c(%ebp)
  801113:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801117:	7f e7                	jg     801100 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801119:	e9 66 01 00 00       	jmp    801284 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 e8             	pushl  -0x18(%ebp)
  801124:	8d 45 14             	lea    0x14(%ebp),%eax
  801127:	50                   	push   %eax
  801128:	e8 3c fd ff ff       	call   800e69 <getint>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801133:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113c:	85 d2                	test   %edx,%edx
  80113e:	79 23                	jns    801163 <vprintfmt+0x29b>
				putch('-', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 2d                	push   $0x2d
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801156:	f7 d8                	neg    %eax
  801158:	83 d2 00             	adc    $0x0,%edx
  80115b:	f7 da                	neg    %edx
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801160:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801163:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80116a:	e9 bc 00 00 00       	jmp    80122b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	ff 75 e8             	pushl  -0x18(%ebp)
  801175:	8d 45 14             	lea    0x14(%ebp),%eax
  801178:	50                   	push   %eax
  801179:	e8 84 fc ff ff       	call   800e02 <getuint>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801184:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801187:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80118e:	e9 98 00 00 00       	jmp    80122b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	6a 58                	push   $0x58
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	ff d0                	call   *%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	6a 58                	push   $0x58
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	ff d0                	call   *%eax
  8011b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	6a 58                	push   $0x58
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	ff d0                	call   *%eax
  8011c0:	83 c4 10             	add    $0x10,%esp
			break;
  8011c3:	e9 bc 00 00 00       	jmp    801284 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	6a 30                	push   $0x30
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	ff d0                	call   *%eax
  8011d5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	ff 75 0c             	pushl  0xc(%ebp)
  8011de:	6a 78                	push   $0x78
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	ff d0                	call   *%eax
  8011e5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011eb:	83 c0 04             	add    $0x4,%eax
  8011ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f4:	83 e8 04             	sub    $0x4,%eax
  8011f7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801203:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80120a:	eb 1f                	jmp    80122b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	ff 75 e8             	pushl  -0x18(%ebp)
  801212:	8d 45 14             	lea    0x14(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	e8 e7 fb ff ff       	call   800e02 <getuint>
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801221:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801224:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80122b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80122f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	52                   	push   %edx
  801236:	ff 75 e4             	pushl  -0x1c(%ebp)
  801239:	50                   	push   %eax
  80123a:	ff 75 f4             	pushl  -0xc(%ebp)
  80123d:	ff 75 f0             	pushl  -0x10(%ebp)
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	ff 75 08             	pushl  0x8(%ebp)
  801246:	e8 00 fb ff ff       	call   800d4b <printnum>
  80124b:	83 c4 20             	add    $0x20,%esp
			break;
  80124e:	eb 34                	jmp    801284 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	53                   	push   %ebx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	ff d0                	call   *%eax
  80125c:	83 c4 10             	add    $0x10,%esp
			break;
  80125f:	eb 23                	jmp    801284 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 0c             	pushl  0xc(%ebp)
  801267:	6a 25                	push   $0x25
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	ff d0                	call   *%eax
  80126e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801271:	ff 4d 10             	decl   0x10(%ebp)
  801274:	eb 03                	jmp    801279 <vprintfmt+0x3b1>
  801276:	ff 4d 10             	decl   0x10(%ebp)
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	48                   	dec    %eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 25                	cmp    $0x25,%al
  801281:	75 f3                	jne    801276 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801283:	90                   	nop
		}
	}
  801284:	e9 47 fc ff ff       	jmp    800ed0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801289:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80128a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801297:	8d 45 10             	lea    0x10(%ebp),%eax
  80129a:	83 c0 04             	add    $0x4,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	ff 75 08             	pushl  0x8(%ebp)
  8012ad:	e8 16 fc ff ff       	call   800ec8 <vprintfmt>
  8012b2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012b5:	90                   	nop
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	8b 40 08             	mov    0x8(%eax),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	8b 10                	mov    (%eax),%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	8b 40 04             	mov    0x4(%eax),%eax
  8012d5:	39 c2                	cmp    %eax,%edx
  8012d7:	73 12                	jae    8012eb <sprintputch+0x33>
		*b->buf++ = ch;
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	8b 00                	mov    (%eax),%eax
  8012de:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e4:	89 0a                	mov    %ecx,(%edx)
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	88 10                	mov    %dl,(%eax)
}
  8012eb:	90                   	nop
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801308:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80130f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801313:	74 06                	je     80131b <vsnprintf+0x2d>
  801315:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801319:	7f 07                	jg     801322 <vsnprintf+0x34>
		return -E_INVAL;
  80131b:	b8 03 00 00 00       	mov    $0x3,%eax
  801320:	eb 20                	jmp    801342 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801322:	ff 75 14             	pushl  0x14(%ebp)
  801325:	ff 75 10             	pushl  0x10(%ebp)
  801328:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	68 b8 12 80 00       	push   $0x8012b8
  801331:	e8 92 fb ff ff       	call   800ec8 <vprintfmt>
  801336:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80134a:	8d 45 10             	lea    0x10(%ebp),%eax
  80134d:	83 c0 04             	add    $0x4,%eax
  801350:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	ff 75 f4             	pushl  -0xc(%ebp)
  801359:	50                   	push   %eax
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 89 ff ff ff       	call   8012ee <vsnprintf>
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137d:	eb 06                	jmp    801385 <strlen+0x15>
		n++;
  80137f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801382:	ff 45 08             	incl   0x8(%ebp)
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	75 f1                	jne    80137f <strlen+0xf>
		n++;
	return n;
  80138e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801399:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a0:	eb 09                	jmp    8013ab <strnlen+0x18>
		n++;
  8013a2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a5:	ff 45 08             	incl   0x8(%ebp)
  8013a8:	ff 4d 0c             	decl   0xc(%ebp)
  8013ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013af:	74 09                	je     8013ba <strnlen+0x27>
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 e8                	jne    8013a2 <strnlen+0xf>
		n++;
	return n;
  8013ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013cb:	90                   	nop
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8d 50 01             	lea    0x1(%eax),%edx
  8013d2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013db:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013de:	8a 12                	mov    (%edx),%dl
  8013e0:	88 10                	mov    %dl,(%eax)
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	84 c0                	test   %al,%al
  8013e6:	75 e4                	jne    8013cc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 1f                	jmp    801421 <strncpy+0x34>
		*dst++ = *src;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8d 50 01             	lea    0x1(%eax),%edx
  801408:	89 55 08             	mov    %edx,0x8(%ebp)
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	8a 12                	mov    (%edx),%dl
  801410:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801412:	8b 45 0c             	mov    0xc(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	84 c0                	test   %al,%al
  801419:	74 03                	je     80141e <strncpy+0x31>
			src++;
  80141b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80141e:	ff 45 fc             	incl   -0x4(%ebp)
  801421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801424:	3b 45 10             	cmp    0x10(%ebp),%eax
  801427:	72 d9                	jb     801402 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801429:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80143a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143e:	74 30                	je     801470 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801440:	eb 16                	jmp    801458 <strlcpy+0x2a>
			*dst++ = *src++;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8d 50 01             	lea    0x1(%eax),%edx
  801448:	89 55 08             	mov    %edx,0x8(%ebp)
  80144b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801451:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801454:	8a 12                	mov    (%edx),%dl
  801456:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801458:	ff 4d 10             	decl   0x10(%ebp)
  80145b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145f:	74 09                	je     80146a <strlcpy+0x3c>
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	84 c0                	test   %al,%al
  801468:	75 d8                	jne    801442 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801470:	8b 55 08             	mov    0x8(%ebp),%edx
  801473:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801476:	29 c2                	sub    %eax,%edx
  801478:	89 d0                	mov    %edx,%eax
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80147f:	eb 06                	jmp    801487 <strcmp+0xb>
		p++, q++;
  801481:	ff 45 08             	incl   0x8(%ebp)
  801484:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	74 0e                	je     80149e <strcmp+0x22>
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 10                	mov    (%eax),%dl
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	38 c2                	cmp    %al,%dl
  80149c:	74 e3                	je     801481 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	0f b6 d0             	movzbl %al,%edx
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	0f b6 c0             	movzbl %al,%eax
  8014ae:	29 c2                	sub    %eax,%edx
  8014b0:	89 d0                	mov    %edx,%eax
}
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014b7:	eb 09                	jmp    8014c2 <strncmp+0xe>
		n--, p++, q++;
  8014b9:	ff 4d 10             	decl   0x10(%ebp)
  8014bc:	ff 45 08             	incl   0x8(%ebp)
  8014bf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c6:	74 17                	je     8014df <strncmp+0x2b>
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	84 c0                	test   %al,%al
  8014cf:	74 0e                	je     8014df <strncmp+0x2b>
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 10                	mov    (%eax),%dl
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	38 c2                	cmp    %al,%dl
  8014dd:	74 da                	je     8014b9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e3:	75 07                	jne    8014ec <strncmp+0x38>
		return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	eb 14                	jmp    801500 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	0f b6 d0             	movzbl %al,%edx
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f b6 c0             	movzbl %al,%eax
  8014fc:	29 c2                	sub    %eax,%edx
  8014fe:	89 d0                	mov    %edx,%eax
}
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    

00801502 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80150e:	eb 12                	jmp    801522 <strchr+0x20>
		if (*s == c)
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801518:	75 05                	jne    80151f <strchr+0x1d>
			return (char *) s;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	eb 11                	jmp    801530 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80151f:	ff 45 08             	incl   0x8(%ebp)
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	84 c0                	test   %al,%al
  801529:	75 e5                	jne    801510 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80153e:	eb 0d                	jmp    80154d <strfind+0x1b>
		if (*s == c)
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8a 00                	mov    (%eax),%al
  801545:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801548:	74 0e                	je     801558 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80154a:	ff 45 08             	incl   0x8(%ebp)
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 ea                	jne    801540 <strfind+0xe>
  801556:	eb 01                	jmp    801559 <strfind+0x27>
		if (*s == c)
			break;
  801558:	90                   	nop
	return (char *) s;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801570:	eb 0e                	jmp    801580 <memset+0x22>
		*p++ = c;
  801572:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801575:	8d 50 01             	lea    0x1(%eax),%edx
  801578:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801580:	ff 4d f8             	decl   -0x8(%ebp)
  801583:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801587:	79 e9                	jns    801572 <memset+0x14>
		*p++ = c;

	return v;
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015a0:	eb 16                	jmp    8015b8 <memcpy+0x2a>
		*d++ = *s++;
  8015a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a5:	8d 50 01             	lea    0x1(%eax),%edx
  8015a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015b1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015b4:	8a 12                	mov    (%edx),%dl
  8015b6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015be:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	75 dd                	jne    8015a2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015e2:	73 50                	jae    801634 <memmove+0x6a>
  8015e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ef:	76 43                	jbe    801634 <memmove+0x6a>
		s += n;
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015fd:	eb 10                	jmp    80160f <memmove+0x45>
			*--d = *--s;
  8015ff:	ff 4d f8             	decl   -0x8(%ebp)
  801602:	ff 4d fc             	decl   -0x4(%ebp)
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	8a 10                	mov    (%eax),%dl
  80160a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	8d 50 ff             	lea    -0x1(%eax),%edx
  801615:	89 55 10             	mov    %edx,0x10(%ebp)
  801618:	85 c0                	test   %eax,%eax
  80161a:	75 e3                	jne    8015ff <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80161c:	eb 23                	jmp    801641 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80161e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801621:	8d 50 01             	lea    0x1(%eax),%edx
  801624:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801627:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801630:	8a 12                	mov    (%edx),%dl
  801632:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163a:	89 55 10             	mov    %edx,0x10(%ebp)
  80163d:	85 c0                	test   %eax,%eax
  80163f:	75 dd                	jne    80161e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801658:	eb 2a                	jmp    801684 <memcmp+0x3e>
		if (*s1 != *s2)
  80165a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165d:	8a 10                	mov    (%eax),%dl
  80165f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	38 c2                	cmp    %al,%dl
  801666:	74 16                	je     80167e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	0f b6 d0             	movzbl %al,%edx
  801670:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	0f b6 c0             	movzbl %al,%eax
  801678:	29 c2                	sub    %eax,%edx
  80167a:	89 d0                	mov    %edx,%eax
  80167c:	eb 18                	jmp    801696 <memcmp+0x50>
		s1++, s2++;
  80167e:	ff 45 fc             	incl   -0x4(%ebp)
  801681:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168a:	89 55 10             	mov    %edx,0x10(%ebp)
  80168d:	85 c0                	test   %eax,%eax
  80168f:	75 c9                	jne    80165a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80169e:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016a9:	eb 15                	jmp    8016c0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	0f b6 d0             	movzbl %al,%edx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	0f b6 c0             	movzbl %al,%eax
  8016b9:	39 c2                	cmp    %eax,%edx
  8016bb:	74 0d                	je     8016ca <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016bd:	ff 45 08             	incl   0x8(%ebp)
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016c6:	72 e3                	jb     8016ab <memfind+0x13>
  8016c8:	eb 01                	jmp    8016cb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016ca:	90                   	nop
	return (void *) s;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e4:	eb 03                	jmp    8016e9 <strtol+0x19>
		s++;
  8016e6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 20                	cmp    $0x20,%al
  8016f0:	74 f4                	je     8016e6 <strtol+0x16>
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	3c 09                	cmp    $0x9,%al
  8016f9:	74 eb                	je     8016e6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	3c 2b                	cmp    $0x2b,%al
  801702:	75 05                	jne    801709 <strtol+0x39>
		s++;
  801704:	ff 45 08             	incl   0x8(%ebp)
  801707:	eb 13                	jmp    80171c <strtol+0x4c>
	else if (*s == '-')
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 2d                	cmp    $0x2d,%al
  801710:	75 0a                	jne    80171c <strtol+0x4c>
		s++, neg = 1;
  801712:	ff 45 08             	incl   0x8(%ebp)
  801715:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80171c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801720:	74 06                	je     801728 <strtol+0x58>
  801722:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801726:	75 20                	jne    801748 <strtol+0x78>
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8a 00                	mov    (%eax),%al
  80172d:	3c 30                	cmp    $0x30,%al
  80172f:	75 17                	jne    801748 <strtol+0x78>
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	40                   	inc    %eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	3c 78                	cmp    $0x78,%al
  801739:	75 0d                	jne    801748 <strtol+0x78>
		s += 2, base = 16;
  80173b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80173f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801746:	eb 28                	jmp    801770 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801748:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174c:	75 15                	jne    801763 <strtol+0x93>
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	3c 30                	cmp    $0x30,%al
  801755:	75 0c                	jne    801763 <strtol+0x93>
		s++, base = 8;
  801757:	ff 45 08             	incl   0x8(%ebp)
  80175a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801761:	eb 0d                	jmp    801770 <strtol+0xa0>
	else if (base == 0)
  801763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801767:	75 07                	jne    801770 <strtol+0xa0>
		base = 10;
  801769:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	3c 2f                	cmp    $0x2f,%al
  801777:	7e 19                	jle    801792 <strtol+0xc2>
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	3c 39                	cmp    $0x39,%al
  801780:	7f 10                	jg     801792 <strtol+0xc2>
			dig = *s - '0';
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	0f be c0             	movsbl %al,%eax
  80178a:	83 e8 30             	sub    $0x30,%eax
  80178d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801790:	eb 42                	jmp    8017d4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	3c 60                	cmp    $0x60,%al
  801799:	7e 19                	jle    8017b4 <strtol+0xe4>
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 7a                	cmp    $0x7a,%al
  8017a2:	7f 10                	jg     8017b4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	0f be c0             	movsbl %al,%eax
  8017ac:	83 e8 57             	sub    $0x57,%eax
  8017af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b2:	eb 20                	jmp    8017d4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	3c 40                	cmp    $0x40,%al
  8017bb:	7e 39                	jle    8017f6 <strtol+0x126>
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	3c 5a                	cmp    $0x5a,%al
  8017c4:	7f 30                	jg     8017f6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	0f be c0             	movsbl %al,%eax
  8017ce:	83 e8 37             	sub    $0x37,%eax
  8017d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017da:	7d 19                	jge    8017f5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017dc:	ff 45 08             	incl   0x8(%ebp)
  8017df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017e6:	89 c2                	mov    %eax,%edx
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017f0:	e9 7b ff ff ff       	jmp    801770 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017f5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017fa:	74 08                	je     801804 <strtol+0x134>
		*endptr = (char *) s;
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801802:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801804:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801808:	74 07                	je     801811 <strtol+0x141>
  80180a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180d:	f7 d8                	neg    %eax
  80180f:	eb 03                	jmp    801814 <strtol+0x144>
  801811:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <ltostr>:

void
ltostr(long value, char *str)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80181c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801823:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80182a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80182e:	79 13                	jns    801843 <ltostr+0x2d>
	{
		neg = 1;
  801830:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80183d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801840:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80184b:	99                   	cltd   
  80184c:	f7 f9                	idiv   %ecx
  80184e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801851:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801854:	8d 50 01             	lea    0x1(%eax),%edx
  801857:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80185a:	89 c2                	mov    %eax,%edx
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	01 d0                	add    %edx,%eax
  801861:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801864:	83 c2 30             	add    $0x30,%edx
  801867:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801869:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801871:	f7 e9                	imul   %ecx
  801873:	c1 fa 02             	sar    $0x2,%edx
  801876:	89 c8                	mov    %ecx,%eax
  801878:	c1 f8 1f             	sar    $0x1f,%eax
  80187b:	29 c2                	sub    %eax,%edx
  80187d:	89 d0                	mov    %edx,%eax
  80187f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801882:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801885:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80188a:	f7 e9                	imul   %ecx
  80188c:	c1 fa 02             	sar    $0x2,%edx
  80188f:	89 c8                	mov    %ecx,%eax
  801891:	c1 f8 1f             	sar    $0x1f,%eax
  801894:	29 c2                	sub    %eax,%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	c1 e0 02             	shl    $0x2,%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	01 c0                	add    %eax,%eax
  80189f:	29 c1                	sub    %eax,%ecx
  8018a1:	89 ca                	mov    %ecx,%edx
  8018a3:	85 d2                	test   %edx,%edx
  8018a5:	75 9c                	jne    801843 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b1:	48                   	dec    %eax
  8018b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b9:	74 3d                	je     8018f8 <ltostr+0xe2>
		start = 1 ;
  8018bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018c2:	eb 34                	jmp    8018f8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ca:	01 d0                	add    %edx,%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d7:	01 c2                	add    %eax,%edx
  8018d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 c8                	add    %ecx,%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	01 c2                	add    %eax,%edx
  8018ed:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018f0:	88 02                	mov    %al,(%edx)
		start++ ;
  8018f2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018f5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018fe:	7c c4                	jl     8018c4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801900:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801903:	8b 45 0c             	mov    0xc(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	e8 54 fa ff ff       	call   801370 <strlen>
  80191c:	83 c4 04             	add    $0x4,%esp
  80191f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	e8 46 fa ff ff       	call   801370 <strlen>
  80192a:	83 c4 04             	add    $0x4,%esp
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801930:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80193e:	eb 17                	jmp    801957 <strcconcat+0x49>
		final[s] = str1[s] ;
  801940:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	01 c2                	add    %eax,%edx
  801948:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	01 c8                	add    %ecx,%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801954:	ff 45 fc             	incl   -0x4(%ebp)
  801957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80195d:	7c e1                	jl     801940 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80195f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801966:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80196d:	eb 1f                	jmp    80198e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801972:	8d 50 01             	lea    0x1(%eax),%edx
  801975:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801978:	89 c2                	mov    %eax,%edx
  80197a:	8b 45 10             	mov    0x10(%ebp),%eax
  80197d:	01 c2                	add    %eax,%edx
  80197f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801982:	8b 45 0c             	mov    0xc(%ebp),%eax
  801985:	01 c8                	add    %ecx,%eax
  801987:	8a 00                	mov    (%eax),%al
  801989:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80198b:	ff 45 f8             	incl   -0x8(%ebp)
  80198e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801991:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801994:	7c d9                	jl     80196f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801996:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801999:	8b 45 10             	mov    0x10(%ebp),%eax
  80199c:	01 d0                	add    %edx,%eax
  80199e:	c6 00 00             	movb   $0x0,(%eax)
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b3:	8b 00                	mov    (%eax),%eax
  8019b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	01 d0                	add    %edx,%eax
  8019c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c7:	eb 0c                	jmp    8019d5 <strsplit+0x31>
			*string++ = 0;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	8d 50 01             	lea    0x1(%eax),%edx
  8019cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8019d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	74 18                	je     8019f6 <strsplit+0x52>
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8a 00                	mov    (%eax),%al
  8019e3:	0f be c0             	movsbl %al,%eax
  8019e6:	50                   	push   %eax
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	e8 13 fb ff ff       	call   801502 <strchr>
  8019ef:	83 c4 08             	add    $0x8,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	75 d3                	jne    8019c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 5a                	je     801a59 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801a02:	8b 00                	mov    (%eax),%eax
  801a04:	83 f8 0f             	cmp    $0xf,%eax
  801a07:	75 07                	jne    801a10 <strsplit+0x6c>
		{
			return 0;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	eb 66                	jmp    801a76 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	8d 48 01             	lea    0x1(%eax),%ecx
  801a18:	8b 55 14             	mov    0x14(%ebp),%edx
  801a1b:	89 0a                	mov    %ecx,(%edx)
  801a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a24:	8b 45 10             	mov    0x10(%ebp),%eax
  801a27:	01 c2                	add    %eax,%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a2e:	eb 03                	jmp    801a33 <strsplit+0x8f>
			string++;
  801a30:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8a 00                	mov    (%eax),%al
  801a38:	84 c0                	test   %al,%al
  801a3a:	74 8b                	je     8019c7 <strsplit+0x23>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	0f be c0             	movsbl %al,%eax
  801a44:	50                   	push   %eax
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	e8 b5 fa ff ff       	call   801502 <strchr>
  801a4d:	83 c4 08             	add    $0x8,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	74 dc                	je     801a30 <strsplit+0x8c>
			string++;
	}
  801a54:	e9 6e ff ff ff       	jmp    8019c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a59:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	68 90 2b 80 00       	push   $0x802b90
  801a86:	6a 0e                	push   $0xe
  801a88:	68 ca 2b 80 00       	push   $0x802bca
  801a8d:	e8 a8 ef ff ff       	call   800a3a <_panic>

00801a92 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801a98:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	74 0f                	je     801ab0 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801aa1:	e8 d2 ff ff ff       	call   801a78 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801aa6:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801aad:	00 00 00 
	}
	if (size == 0) return NULL ;
  801ab0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ab4:	75 07                	jne    801abd <malloc+0x2b>
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  801abb:	eb 14                	jmp    801ad1 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	68 d8 2b 80 00       	push   $0x802bd8
  801ac5:	6a 2e                	push   $0x2e
  801ac7:	68 ca 2b 80 00       	push   $0x802bca
  801acc:	e8 69 ef ff ff       	call   800a3a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 00 2c 80 00       	push   $0x802c00
  801ae1:	6a 49                	push   $0x49
  801ae3:	68 ca 2b 80 00       	push   $0x802bca
  801ae8:	e8 4d ef ff ff       	call   800a3a <_panic>

00801aed <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 18             	sub    $0x18,%esp
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	68 24 2c 80 00       	push   $0x802c24
  801b01:	6a 57                	push   $0x57
  801b03:	68 ca 2b 80 00       	push   $0x802bca
  801b08:	e8 2d ef ff ff       	call   800a3a <_panic>

00801b0d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	68 4c 2c 80 00       	push   $0x802c4c
  801b1b:	6a 60                	push   $0x60
  801b1d:	68 ca 2b 80 00       	push   $0x802bca
  801b22:	e8 13 ef ff ff       	call   800a3a <_panic>

00801b27 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	68 70 2c 80 00       	push   $0x802c70
  801b35:	6a 7c                	push   $0x7c
  801b37:	68 ca 2b 80 00       	push   $0x802bca
  801b3c:	e8 f9 ee ff ff       	call   800a3a <_panic>

00801b41 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	68 98 2c 80 00       	push   $0x802c98
  801b4f:	68 86 00 00 00       	push   $0x86
  801b54:	68 ca 2b 80 00       	push   $0x802bca
  801b59:	e8 dc ee ff ff       	call   800a3a <_panic>

00801b5e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	68 bc 2c 80 00       	push   $0x802cbc
  801b6c:	68 91 00 00 00       	push   $0x91
  801b71:	68 ca 2b 80 00       	push   $0x802bca
  801b76:	e8 bf ee ff ff       	call   800a3a <_panic>

00801b7b <shrink>:

}
void shrink(uint32 newSize)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	68 bc 2c 80 00       	push   $0x802cbc
  801b89:	68 96 00 00 00       	push   $0x96
  801b8e:	68 ca 2b 80 00       	push   $0x802bca
  801b93:	e8 a2 ee ff ff       	call   800a3a <_panic>

00801b98 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	68 bc 2c 80 00       	push   $0x802cbc
  801ba6:	68 9b 00 00 00       	push   $0x9b
  801bab:	68 ca 2b 80 00       	push   $0x802bca
  801bb0:	e8 85 ee ff ff       	call   800a3a <_panic>

00801bb5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	57                   	push   %edi
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bca:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bcd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bd0:	cd 30                	int    $0x30
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	52                   	push   %edx
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	e8 b2 ff ff ff       	call   801bb5 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	90                   	nop
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 01                	push   $0x1
  801c18:	e8 98 ff ff ff       	call   801bb5 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 05                	push   $0x5
  801c35:	e8 7b ff ff ff       	call   801bb5 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c44:	8b 75 18             	mov    0x18(%ebp),%esi
  801c47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	51                   	push   %ecx
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 06                	push   $0x6
  801c5a:	e8 56 ff ff ff       	call   801bb5 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	6a 07                	push   $0x7
  801c7c:	e8 34 ff ff ff       	call   801bb5 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	6a 08                	push   $0x8
  801c97:	e8 19 ff ff ff       	call   801bb5 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 09                	push   $0x9
  801cb0:	e8 00 ff ff ff       	call   801bb5 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 0a                	push   $0xa
  801cc9:	e8 e7 fe ff ff       	call   801bb5 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 0b                	push   $0xb
  801ce2:	e8 ce fe ff ff       	call   801bb5 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	6a 0f                	push   $0xf
  801cfd:	e8 b3 fe ff ff       	call   801bb5 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 10                	push   $0x10
  801d19:	e8 97 fe ff ff       	call   801bb5 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	ff 75 10             	pushl  0x10(%ebp)
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 11                	push   $0x11
  801d36:	e8 7a fe ff ff       	call   801bb5 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3e:	90                   	nop
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 0c                	push   $0xc
  801d50:	e8 60 fe ff ff       	call   801bb5 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 08             	pushl  0x8(%ebp)
  801d68:	6a 0d                	push   $0xd
  801d6a:	e8 46 fe ff ff       	call   801bb5 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 0e                	push   $0xe
  801d83:	e8 2d fe ff ff       	call   801bb5 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	90                   	nop
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 13                	push   $0x13
  801d9d:	e8 13 fe ff ff       	call   801bb5 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	90                   	nop
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 14                	push   $0x14
  801db7:	e8 f9 fd ff ff       	call   801bb5 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	90                   	nop
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	50                   	push   %eax
  801ddb:	6a 15                	push   $0x15
  801ddd:	e8 d3 fd ff ff       	call   801bb5 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	90                   	nop
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 16                	push   $0x16
  801df7:	e8 b9 fd ff ff       	call   801bb5 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	90                   	nop
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	50                   	push   %eax
  801e12:	6a 17                	push   $0x17
  801e14:	e8 9c fd ff ff       	call   801bb5 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 1a                	push   $0x1a
  801e31:	e8 7f fd ff ff       	call   801bb5 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 18                	push   $0x18
  801e4e:	e8 62 fd ff ff       	call   801bb5 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	90                   	nop
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	52                   	push   %edx
  801e69:	50                   	push   %eax
  801e6a:	6a 19                	push   $0x19
  801e6c:	e8 44 fd ff ff       	call   801bb5 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	51                   	push   %ecx
  801e90:	52                   	push   %edx
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	6a 1b                	push   $0x1b
  801e97:	e8 19 fd ff ff       	call   801bb5 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 1c                	push   $0x1c
  801eb4:	e8 fc fc ff ff       	call   801bb5 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ec1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	51                   	push   %ecx
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 1d                	push   $0x1d
  801ed3:	e8 dd fc ff ff       	call   801bb5 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 1e                	push   $0x1e
  801ef0:	e8 c0 fc ff ff       	call   801bb5 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 1f                	push   $0x1f
  801f09:	e8 a7 fc ff ff       	call   801bb5 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 14             	pushl  0x14(%ebp)
  801f1e:	ff 75 10             	pushl  0x10(%ebp)
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	50                   	push   %eax
  801f25:	6a 20                	push   $0x20
  801f27:	e8 89 fc ff ff       	call   801bb5 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	50                   	push   %eax
  801f40:	6a 21                	push   $0x21
  801f42:	e8 6e fc ff ff       	call   801bb5 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	90                   	nop
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	50                   	push   %eax
  801f5c:	6a 22                	push   $0x22
  801f5e:	e8 52 fc ff ff       	call   801bb5 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 02                	push   $0x2
  801f77:	e8 39 fc ff ff       	call   801bb5 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 03                	push   $0x3
  801f90:	e8 20 fc ff ff       	call   801bb5 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 04                	push   $0x4
  801fa9:	e8 07 fc ff ff       	call   801bb5 <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 23                	push   $0x23
  801fc2:	e8 ee fb ff ff       	call   801bb5 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	90                   	nop
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd6:	8d 50 04             	lea    0x4(%eax),%edx
  801fd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	52                   	push   %edx
  801fe3:	50                   	push   %eax
  801fe4:	6a 24                	push   $0x24
  801fe6:	e8 ca fb ff ff       	call   801bb5 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
	return result;
  801fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff7:	89 01                	mov    %eax,(%ecx)
  801ff9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	c9                   	leave  
  802000:	c2 04 00             	ret    $0x4

00802003 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	6a 12                	push   $0x12
  802015:	e8 9b fb ff ff       	call   801bb5 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
	return ;
  80201d:	90                   	nop
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_rcr2>:
uint32 sys_rcr2()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 25                	push   $0x25
  80202f:	e8 81 fb ff ff       	call   801bb5 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802045:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	50                   	push   %eax
  802052:	6a 26                	push   $0x26
  802054:	e8 5c fb ff ff       	call   801bb5 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
	return ;
  80205c:	90                   	nop
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <rsttst>:
void rsttst()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 28                	push   $0x28
  80206e:	e8 42 fb ff ff       	call   801bb5 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
	return ;
  802076:	90                   	nop
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	8b 45 14             	mov    0x14(%ebp),%eax
  802082:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802085:	8b 55 18             	mov    0x18(%ebp),%edx
  802088:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	ff 75 10             	pushl  0x10(%ebp)
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	ff 75 08             	pushl  0x8(%ebp)
  802097:	6a 27                	push   $0x27
  802099:	e8 17 fb ff ff       	call   801bb5 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a1:	90                   	nop
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <chktst>:
void chktst(uint32 n)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	6a 29                	push   $0x29
  8020b4:	e8 fc fa ff ff       	call   801bb5 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bc:	90                   	nop
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <inctst>:

void inctst()
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 2a                	push   $0x2a
  8020ce:	e8 e2 fa ff ff       	call   801bb5 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d6:	90                   	nop
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <gettst>:
uint32 gettst()
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 2b                	push   $0x2b
  8020e8:	e8 c8 fa ff ff       	call   801bb5 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 2c                	push   $0x2c
  802104:	e8 ac fa ff ff       	call   801bb5 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
  80210c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80210f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802113:	75 07                	jne    80211c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802115:	b8 01 00 00 00       	mov    $0x1,%eax
  80211a:	eb 05                	jmp    802121 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 2c                	push   $0x2c
  802135:	e8 7b fa ff ff       	call   801bb5 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
  80213d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802140:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802144:	75 07                	jne    80214d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	eb 05                	jmp    802152 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 2c                	push   $0x2c
  802166:	e8 4a fa ff ff       	call   801bb5 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
  80216e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802171:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802175:	75 07                	jne    80217e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802177:	b8 01 00 00 00       	mov    $0x1,%eax
  80217c:	eb 05                	jmp    802183 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 2c                	push   $0x2c
  802197:	e8 19 fa ff ff       	call   801bb5 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
  80219f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021a6:	75 07                	jne    8021af <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ad:	eb 05                	jmp    8021b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	6a 2d                	push   $0x2d
  8021c6:	e8 ea f9 ff ff       	call   801bb5 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ce:	90                   	nop
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	53                   	push   %ebx
  8021e4:	51                   	push   %ecx
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	6a 2e                	push   $0x2e
  8021e9:	e8 c7 f9 ff ff       	call   801bb5 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	6a 2f                	push   $0x2f
  802209:	e8 a7 f9 ff ff       	call   801bb5 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    
  802213:	90                   	nop

00802214 <__udivdi3>:
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80221f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802223:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802227:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80222b:	89 ca                	mov    %ecx,%edx
  80222d:	89 f8                	mov    %edi,%eax
  80222f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802233:	85 f6                	test   %esi,%esi
  802235:	75 2d                	jne    802264 <__udivdi3+0x50>
  802237:	39 cf                	cmp    %ecx,%edi
  802239:	77 65                	ja     8022a0 <__udivdi3+0x8c>
  80223b:	89 fd                	mov    %edi,%ebp
  80223d:	85 ff                	test   %edi,%edi
  80223f:	75 0b                	jne    80224c <__udivdi3+0x38>
  802241:	b8 01 00 00 00       	mov    $0x1,%eax
  802246:	31 d2                	xor    %edx,%edx
  802248:	f7 f7                	div    %edi
  80224a:	89 c5                	mov    %eax,%ebp
  80224c:	31 d2                	xor    %edx,%edx
  80224e:	89 c8                	mov    %ecx,%eax
  802250:	f7 f5                	div    %ebp
  802252:	89 c1                	mov    %eax,%ecx
  802254:	89 d8                	mov    %ebx,%eax
  802256:	f7 f5                	div    %ebp
  802258:	89 cf                	mov    %ecx,%edi
  80225a:	89 fa                	mov    %edi,%edx
  80225c:	83 c4 1c             	add    $0x1c,%esp
  80225f:	5b                   	pop    %ebx
  802260:	5e                   	pop    %esi
  802261:	5f                   	pop    %edi
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    
  802264:	39 ce                	cmp    %ecx,%esi
  802266:	77 28                	ja     802290 <__udivdi3+0x7c>
  802268:	0f bd fe             	bsr    %esi,%edi
  80226b:	83 f7 1f             	xor    $0x1f,%edi
  80226e:	75 40                	jne    8022b0 <__udivdi3+0x9c>
  802270:	39 ce                	cmp    %ecx,%esi
  802272:	72 0a                	jb     80227e <__udivdi3+0x6a>
  802274:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802278:	0f 87 9e 00 00 00    	ja     80231c <__udivdi3+0x108>
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	89 fa                	mov    %edi,%edx
  802285:	83 c4 1c             	add    $0x1c,%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5f                   	pop    %edi
  80228b:	5d                   	pop    %ebp
  80228c:	c3                   	ret    
  80228d:	8d 76 00             	lea    0x0(%esi),%esi
  802290:	31 ff                	xor    %edi,%edi
  802292:	31 c0                	xor    %eax,%eax
  802294:	89 fa                	mov    %edi,%edx
  802296:	83 c4 1c             	add    $0x1c,%esp
  802299:	5b                   	pop    %ebx
  80229a:	5e                   	pop    %esi
  80229b:	5f                   	pop    %edi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	89 d8                	mov    %ebx,%eax
  8022a2:	f7 f7                	div    %edi
  8022a4:	31 ff                	xor    %edi,%edi
  8022a6:	89 fa                	mov    %edi,%edx
  8022a8:	83 c4 1c             	add    $0x1c,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5f                   	pop    %edi
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    
  8022b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022b5:	89 eb                	mov    %ebp,%ebx
  8022b7:	29 fb                	sub    %edi,%ebx
  8022b9:	89 f9                	mov    %edi,%ecx
  8022bb:	d3 e6                	shl    %cl,%esi
  8022bd:	89 c5                	mov    %eax,%ebp
  8022bf:	88 d9                	mov    %bl,%cl
  8022c1:	d3 ed                	shr    %cl,%ebp
  8022c3:	89 e9                	mov    %ebp,%ecx
  8022c5:	09 f1                	or     %esi,%ecx
  8022c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022cb:	89 f9                	mov    %edi,%ecx
  8022cd:	d3 e0                	shl    %cl,%eax
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	89 d6                	mov    %edx,%esi
  8022d3:	88 d9                	mov    %bl,%cl
  8022d5:	d3 ee                	shr    %cl,%esi
  8022d7:	89 f9                	mov    %edi,%ecx
  8022d9:	d3 e2                	shl    %cl,%edx
  8022db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022df:	88 d9                	mov    %bl,%cl
  8022e1:	d3 e8                	shr    %cl,%eax
  8022e3:	09 c2                	or     %eax,%edx
  8022e5:	89 d0                	mov    %edx,%eax
  8022e7:	89 f2                	mov    %esi,%edx
  8022e9:	f7 74 24 0c          	divl   0xc(%esp)
  8022ed:	89 d6                	mov    %edx,%esi
  8022ef:	89 c3                	mov    %eax,%ebx
  8022f1:	f7 e5                	mul    %ebp
  8022f3:	39 d6                	cmp    %edx,%esi
  8022f5:	72 19                	jb     802310 <__udivdi3+0xfc>
  8022f7:	74 0b                	je     802304 <__udivdi3+0xf0>
  8022f9:	89 d8                	mov    %ebx,%eax
  8022fb:	31 ff                	xor    %edi,%edi
  8022fd:	e9 58 ff ff ff       	jmp    80225a <__udivdi3+0x46>
  802302:	66 90                	xchg   %ax,%ax
  802304:	8b 54 24 08          	mov    0x8(%esp),%edx
  802308:	89 f9                	mov    %edi,%ecx
  80230a:	d3 e2                	shl    %cl,%edx
  80230c:	39 c2                	cmp    %eax,%edx
  80230e:	73 e9                	jae    8022f9 <__udivdi3+0xe5>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 40 ff ff ff       	jmp    80225a <__udivdi3+0x46>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	31 c0                	xor    %eax,%eax
  80231e:	e9 37 ff ff ff       	jmp    80225a <__udivdi3+0x46>
  802323:	90                   	nop

00802324 <__umoddi3>:
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80232f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802337:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80233f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802343:	89 f3                	mov    %esi,%ebx
  802345:	89 fa                	mov    %edi,%edx
  802347:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80234b:	89 34 24             	mov    %esi,(%esp)
  80234e:	85 c0                	test   %eax,%eax
  802350:	75 1a                	jne    80236c <__umoddi3+0x48>
  802352:	39 f7                	cmp    %esi,%edi
  802354:	0f 86 a2 00 00 00    	jbe    8023fc <__umoddi3+0xd8>
  80235a:	89 c8                	mov    %ecx,%eax
  80235c:	89 f2                	mov    %esi,%edx
  80235e:	f7 f7                	div    %edi
  802360:	89 d0                	mov    %edx,%eax
  802362:	31 d2                	xor    %edx,%edx
  802364:	83 c4 1c             	add    $0x1c,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5f                   	pop    %edi
  80236a:	5d                   	pop    %ebp
  80236b:	c3                   	ret    
  80236c:	39 f0                	cmp    %esi,%eax
  80236e:	0f 87 ac 00 00 00    	ja     802420 <__umoddi3+0xfc>
  802374:	0f bd e8             	bsr    %eax,%ebp
  802377:	83 f5 1f             	xor    $0x1f,%ebp
  80237a:	0f 84 ac 00 00 00    	je     80242c <__umoddi3+0x108>
  802380:	bf 20 00 00 00       	mov    $0x20,%edi
  802385:	29 ef                	sub    %ebp,%edi
  802387:	89 fe                	mov    %edi,%esi
  802389:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80238d:	89 e9                	mov    %ebp,%ecx
  80238f:	d3 e0                	shl    %cl,%eax
  802391:	89 d7                	mov    %edx,%edi
  802393:	89 f1                	mov    %esi,%ecx
  802395:	d3 ef                	shr    %cl,%edi
  802397:	09 c7                	or     %eax,%edi
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	d3 e2                	shl    %cl,%edx
  80239d:	89 14 24             	mov    %edx,(%esp)
  8023a0:	89 d8                	mov    %ebx,%eax
  8023a2:	d3 e0                	shl    %cl,%eax
  8023a4:	89 c2                	mov    %eax,%edx
  8023a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023aa:	d3 e0                	shl    %cl,%eax
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023b4:	89 f1                	mov    %esi,%ecx
  8023b6:	d3 e8                	shr    %cl,%eax
  8023b8:	09 d0                	or     %edx,%eax
  8023ba:	d3 eb                	shr    %cl,%ebx
  8023bc:	89 da                	mov    %ebx,%edx
  8023be:	f7 f7                	div    %edi
  8023c0:	89 d3                	mov    %edx,%ebx
  8023c2:	f7 24 24             	mull   (%esp)
  8023c5:	89 c6                	mov    %eax,%esi
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	39 d3                	cmp    %edx,%ebx
  8023cb:	0f 82 87 00 00 00    	jb     802458 <__umoddi3+0x134>
  8023d1:	0f 84 91 00 00 00    	je     802468 <__umoddi3+0x144>
  8023d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023db:	29 f2                	sub    %esi,%edx
  8023dd:	19 cb                	sbb    %ecx,%ebx
  8023df:	89 d8                	mov    %ebx,%eax
  8023e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023e5:	d3 e0                	shl    %cl,%eax
  8023e7:	89 e9                	mov    %ebp,%ecx
  8023e9:	d3 ea                	shr    %cl,%edx
  8023eb:	09 d0                	or     %edx,%eax
  8023ed:	89 e9                	mov    %ebp,%ecx
  8023ef:	d3 eb                	shr    %cl,%ebx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	83 c4 1c             	add    $0x1c,%esp
  8023f6:	5b                   	pop    %ebx
  8023f7:	5e                   	pop    %esi
  8023f8:	5f                   	pop    %edi
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    
  8023fb:	90                   	nop
  8023fc:	89 fd                	mov    %edi,%ebp
  8023fe:	85 ff                	test   %edi,%edi
  802400:	75 0b                	jne    80240d <__umoddi3+0xe9>
  802402:	b8 01 00 00 00       	mov    $0x1,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	f7 f7                	div    %edi
  80240b:	89 c5                	mov    %eax,%ebp
  80240d:	89 f0                	mov    %esi,%eax
  80240f:	31 d2                	xor    %edx,%edx
  802411:	f7 f5                	div    %ebp
  802413:	89 c8                	mov    %ecx,%eax
  802415:	f7 f5                	div    %ebp
  802417:	89 d0                	mov    %edx,%eax
  802419:	e9 44 ff ff ff       	jmp    802362 <__umoddi3+0x3e>
  80241e:	66 90                	xchg   %ax,%ax
  802420:	89 c8                	mov    %ecx,%eax
  802422:	89 f2                	mov    %esi,%edx
  802424:	83 c4 1c             	add    $0x1c,%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    
  80242c:	3b 04 24             	cmp    (%esp),%eax
  80242f:	72 06                	jb     802437 <__umoddi3+0x113>
  802431:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802435:	77 0f                	ja     802446 <__umoddi3+0x122>
  802437:	89 f2                	mov    %esi,%edx
  802439:	29 f9                	sub    %edi,%ecx
  80243b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80243f:	89 14 24             	mov    %edx,(%esp)
  802442:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802446:	8b 44 24 04          	mov    0x4(%esp),%eax
  80244a:	8b 14 24             	mov    (%esp),%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	2b 04 24             	sub    (%esp),%eax
  80245b:	19 fa                	sbb    %edi,%edx
  80245d:	89 d1                	mov    %edx,%ecx
  80245f:	89 c6                	mov    %eax,%esi
  802461:	e9 71 ff ff ff       	jmp    8023d7 <__umoddi3+0xb3>
  802466:	66 90                	xchg   %ax,%ax
  802468:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80246c:	72 ea                	jb     802458 <__umoddi3+0x134>
  80246e:	89 d9                	mov    %ebx,%ecx
  802470:	e9 62 ff ff ff       	jmp    8023d7 <__umoddi3+0xb3>
