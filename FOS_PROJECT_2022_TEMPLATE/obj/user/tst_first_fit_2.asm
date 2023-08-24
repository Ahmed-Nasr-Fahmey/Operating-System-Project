
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 d0 06 00 00       	call   800706 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 87 1f 00 00       	call   801fd1 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 a0 22 80 00       	push   $0x8022a0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 bc 22 80 00       	push   $0x8022bc
  8000a7:	e8 a9 07 00 00       	call   800855 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 f7 17 00 00       	call   8018ad <malloc>
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
  8000e0:	e8 c8 17 00 00       	call   8018ad <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 d4 22 80 00       	push   $0x8022d4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 bc 22 80 00       	push   $0x8022bc
  800101:	e8 4f 07 00 00       	call   800855 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 b1 19 00 00       	call   801abc <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 49 1a 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 86 17 00 00       	call   8018ad <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 18 23 80 00       	push   $0x802318
  80013f:	6a 31                	push   $0x31
  800141:	68 bc 22 80 00       	push   $0x8022bc
  800146:	e8 0a 07 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 0c 1a 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 48 23 80 00       	push   $0x802348
  800162:	6a 33                	push   $0x33
  800164:	68 bc 22 80 00       	push   $0x8022bc
  800169:	e8 e7 06 00 00       	call   800855 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 49 19 00 00       	call   801abc <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 e1 19 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 1e 17 00 00       	call   8018ad <malloc>
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
  8001ab:	68 18 23 80 00       	push   $0x802318
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 bc 22 80 00       	push   $0x8022bc
  8001b7:	e8 99 06 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 9b 19 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 48 23 80 00       	push   $0x802348
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 bc 22 80 00       	push   $0x8022bc
  8001da:	e8 76 06 00 00       	call   800855 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 d8 18 00 00       	call   801abc <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 70 19 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	89 c2                	mov    %eax,%edx
  8001f4:	01 d2                	add    %edx,%edx
  8001f6:	01 d0                	add    %edx,%eax
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	50                   	push   %eax
  8001fc:	e8 ac 16 00 00       	call   8018ad <malloc>
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800207:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	05 00 00 00 80       	add    $0x80000000,%eax
  800217:	39 c2                	cmp    %eax,%edx
  800219:	74 14                	je     80022f <_main+0x1f7>
  80021b:	83 ec 04             	sub    $0x4,%esp
  80021e:	68 18 23 80 00       	push   $0x802318
  800223:	6a 41                	push   $0x41
  800225:	68 bc 22 80 00       	push   $0x8022bc
  80022a:	e8 26 06 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022f:	e8 28 19 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800234:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800237:	83 f8 01             	cmp    $0x1,%eax
  80023a:	74 14                	je     800250 <_main+0x218>
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	68 48 23 80 00       	push   $0x802348
  800244:	6a 43                	push   $0x43
  800246:	68 bc 22 80 00       	push   $0x8022bc
  80024b:	e8 05 06 00 00       	call   800855 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800250:	e8 67 18 00 00       	call   801abc <sys_calculate_free_frames>
  800255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800258:	e8 ff 18 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80025d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800263:	89 c2                	mov    %eax,%edx
  800265:	01 d2                	add    %edx,%edx
  800267:	01 d0                	add    %edx,%eax
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	50                   	push   %eax
  80026d:	e8 3b 16 00 00       	call   8018ad <malloc>
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800278:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80027b:	89 c2                	mov    %eax,%edx
  80027d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	89 c1                	mov    %eax,%ecx
  800285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800288:	c1 e0 02             	shl    $0x2,%eax
  80028b:	01 c8                	add    %ecx,%eax
  80028d:	05 00 00 00 80       	add    $0x80000000,%eax
  800292:	39 c2                	cmp    %eax,%edx
  800294:	74 14                	je     8002aa <_main+0x272>
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	68 18 23 80 00       	push   $0x802318
  80029e:	6a 49                	push   $0x49
  8002a0:	68 bc 22 80 00       	push   $0x8022bc
  8002a5:	e8 ab 05 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002aa:	e8 ad 18 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8002af:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b2:	83 f8 01             	cmp    $0x1,%eax
  8002b5:	74 14                	je     8002cb <_main+0x293>
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	68 48 23 80 00       	push   $0x802348
  8002bf:	6a 4b                	push   $0x4b
  8002c1:	68 bc 22 80 00       	push   $0x8022bc
  8002c6:	e8 8a 05 00 00       	call   800855 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 ec 17 00 00       	call   801abc <sys_calculate_free_frames>
  8002d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002d3:	e8 84 18 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8002d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002db:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	e8 07 16 00 00       	call   8018ee <free>
  8002e7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002ea:	e8 6d 18 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8002ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f2:	29 c2                	sub    %eax,%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	83 f8 01             	cmp    $0x1,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 65 23 80 00       	push   $0x802365
  800303:	6a 52                	push   $0x52
  800305:	68 bc 22 80 00       	push   $0x8022bc
  80030a:	e8 46 05 00 00       	call   800855 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  80030f:	e8 a8 17 00 00       	call   801abc <sys_calculate_free_frames>
  800314:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800317:	e8 40 18 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80031c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80031f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800322:	89 d0                	mov    %edx,%eax
  800324:	01 c0                	add    %eax,%eax
  800326:	01 d0                	add    %edx,%eax
  800328:	01 c0                	add    %eax,%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	e8 78 15 00 00       	call   8018ad <malloc>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  80033b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80033e:	89 c2                	mov    %eax,%edx
  800340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800343:	c1 e0 02             	shl    $0x2,%eax
  800346:	89 c1                	mov    %eax,%ecx
  800348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80034b:	c1 e0 03             	shl    $0x3,%eax
  80034e:	01 c8                	add    %ecx,%eax
  800350:	05 00 00 00 80       	add    $0x80000000,%eax
  800355:	39 c2                	cmp    %eax,%edx
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 18 23 80 00       	push   $0x802318
  800361:	6a 58                	push   $0x58
  800363:	68 bc 22 80 00       	push   $0x8022bc
  800368:	e8 e8 04 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80036d:	e8 ea 17 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800372:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800375:	83 f8 02             	cmp    $0x2,%eax
  800378:	74 14                	je     80038e <_main+0x356>
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	68 48 23 80 00       	push   $0x802348
  800382:	6a 5a                	push   $0x5a
  800384:	68 bc 22 80 00       	push   $0x8022bc
  800389:	e8 c7 04 00 00       	call   800855 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80038e:	e8 29 17 00 00       	call   801abc <sys_calculate_free_frames>
  800393:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800396:	e8 c1 17 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  80039e:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	50                   	push   %eax
  8003a5:	e8 44 15 00 00       	call   8018ee <free>
  8003aa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003ad:	e8 aa 17 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8003b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b5:	29 c2                	sub    %eax,%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003be:	74 14                	je     8003d4 <_main+0x39c>
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 65 23 80 00       	push   $0x802365
  8003c8:	6a 61                	push   $0x61
  8003ca:	68 bc 22 80 00       	push   $0x8022bc
  8003cf:	e8 81 04 00 00       	call   800855 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003d4:	e8 e3 16 00 00       	call   801abc <sys_calculate_free_frames>
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003dc:	e8 7b 17 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	01 d2                	add    %edx,%edx
  8003eb:	01 d0                	add    %edx,%eax
  8003ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	50                   	push   %eax
  8003f4:	e8 b4 14 00 00       	call   8018ad <malloc>
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800402:	89 c2                	mov    %eax,%edx
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	c1 e0 02             	shl    $0x2,%eax
  80040a:	89 c1                	mov    %eax,%ecx
  80040c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040f:	c1 e0 04             	shl    $0x4,%eax
  800412:	01 c8                	add    %ecx,%eax
  800414:	05 00 00 00 80       	add    $0x80000000,%eax
  800419:	39 c2                	cmp    %eax,%edx
  80041b:	74 14                	je     800431 <_main+0x3f9>
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	68 18 23 80 00       	push   $0x802318
  800425:	6a 67                	push   $0x67
  800427:	68 bc 22 80 00       	push   $0x8022bc
  80042c:	e8 24 04 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800431:	e8 26 17 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800436:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80043e:	89 c1                	mov    %eax,%ecx
  800440:	01 c9                	add    %ecx,%ecx
  800442:	01 c8                	add    %ecx,%eax
  800444:	85 c0                	test   %eax,%eax
  800446:	79 05                	jns    80044d <_main+0x415>
  800448:	05 ff 0f 00 00       	add    $0xfff,%eax
  80044d:	c1 f8 0c             	sar    $0xc,%eax
  800450:	39 c2                	cmp    %eax,%edx
  800452:	74 14                	je     800468 <_main+0x430>
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 48 23 80 00       	push   $0x802348
  80045c:	6a 69                	push   $0x69
  80045e:	68 bc 22 80 00       	push   $0x8022bc
  800463:	e8 ed 03 00 00       	call   800855 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800468:	e8 4f 16 00 00       	call   801abc <sys_calculate_free_frames>
  80046d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800470:	e8 e7 16 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	01 d2                	add    %edx,%edx
  80047f:	01 c2                	add    %eax,%edx
  800481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800484:	01 d0                	add    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	50                   	push   %eax
  80048c:	e8 1c 14 00 00       	call   8018ad <malloc>
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800497:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80049a:	89 c1                	mov    %eax,%ecx
  80049c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80049f:	89 d0                	mov    %edx,%eax
  8004a1:	01 c0                	add    %eax,%eax
  8004a3:	01 d0                	add    %edx,%eax
  8004a5:	01 c0                	add    %eax,%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	89 c2                	mov    %eax,%edx
  8004ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ae:	c1 e0 04             	shl    $0x4,%eax
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b8:	39 c1                	cmp    %eax,%ecx
  8004ba:	74 14                	je     8004d0 <_main+0x498>
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 18 23 80 00       	push   $0x802318
  8004c4:	6a 6f                	push   $0x6f
  8004c6:	68 bc 22 80 00       	push   $0x8022bc
  8004cb:	e8 85 03 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004d0:	e8 87 16 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8004d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d8:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004dd:	74 14                	je     8004f3 <_main+0x4bb>
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 48 23 80 00       	push   $0x802348
  8004e7:	6a 71                	push   $0x71
  8004e9:	68 bc 22 80 00       	push   $0x8022bc
  8004ee:	e8 62 03 00 00       	call   800855 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004f3:	e8 c4 15 00 00       	call   801abc <sys_calculate_free_frames>
  8004f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004fb:	e8 5c 16 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800503:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	50                   	push   %eax
  80050a:	e8 df 13 00 00       	call   8018ee <free>
  80050f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800512:	e8 45 16 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800517:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051a:	29 c2                	sub    %eax,%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800523:	74 14                	je     800539 <_main+0x501>
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	68 65 23 80 00       	push   $0x802365
  80052d:	6a 78                	push   $0x78
  80052f:	68 bc 22 80 00       	push   $0x8022bc
  800534:	e8 1c 03 00 00       	call   800855 <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  800539:	e8 7e 15 00 00       	call   801abc <sys_calculate_free_frames>
  80053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800541:	e8 16 16 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800546:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800549:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 99 13 00 00       	call   8018ee <free>
  800555:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800558:	e8 ff 15 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80055d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800560:	29 c2                	sub    %eax,%edx
  800562:	89 d0                	mov    %edx,%eax
  800564:	3d 00 02 00 00       	cmp    $0x200,%eax
  800569:	74 14                	je     80057f <_main+0x547>
  80056b:	83 ec 04             	sub    $0x4,%esp
  80056e:	68 65 23 80 00       	push   $0x802365
  800573:	6a 7f                	push   $0x7f
  800575:	68 bc 22 80 00       	push   $0x8022bc
  80057a:	e8 d6 02 00 00       	call   800855 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80057f:	e8 38 15 00 00       	call   801abc <sys_calculate_free_frames>
  800584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800587:	e8 d0 15 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  80058c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80058f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800592:	89 d0                	mov    %edx,%eax
  800594:	c1 e0 02             	shl    $0x2,%eax
  800597:	01 d0                	add    %edx,%eax
  800599:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80059c:	83 ec 0c             	sub    $0xc,%esp
  80059f:	50                   	push   %eax
  8005a0:	e8 08 13 00 00       	call   8018ad <malloc>
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  8005ab:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005ae:	89 c1                	mov    %eax,%ecx
  8005b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005b3:	89 d0                	mov    %edx,%eax
  8005b5:	c1 e0 03             	shl    $0x3,%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	89 c3                	mov    %eax,%ebx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 d8                	add    %ebx,%eax
  8005ca:	05 00 00 00 80       	add    $0x80000000,%eax
  8005cf:	39 c1                	cmp    %eax,%ecx
  8005d1:	74 17                	je     8005ea <_main+0x5b2>
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 18 23 80 00       	push   $0x802318
  8005db:	68 85 00 00 00       	push   $0x85
  8005e0:	68 bc 22 80 00       	push   $0x8022bc
  8005e5:	e8 6b 02 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005ea:	e8 6d 15 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  8005ef:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	c1 e0 02             	shl    $0x2,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	85 c0                	test   %eax,%eax
  800600:	79 05                	jns    800607 <_main+0x5cf>
  800602:	05 ff 0f 00 00       	add    $0xfff,%eax
  800607:	c1 f8 0c             	sar    $0xc,%eax
  80060a:	39 c1                	cmp    %eax,%ecx
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 48 23 80 00       	push   $0x802348
  800616:	68 87 00 00 00       	push   $0x87
  80061b:	68 bc 22 80 00       	push   $0x8022bc
  800620:	e8 30 02 00 00       	call   800855 <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800625:	e8 92 14 00 00       	call   801abc <sys_calculate_free_frames>
  80062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80062d:	e8 2a 15 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800632:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  800635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800638:	89 c2                	mov    %eax,%edx
  80063a:	01 d2                	add    %edx,%edx
  80063c:	01 d0                	add    %edx,%eax
  80063e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	50                   	push   %eax
  800645:	e8 63 12 00 00       	call   8018ad <malloc>
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800650:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800653:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800658:	74 17                	je     800671 <_main+0x639>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 18 23 80 00       	push   $0x802318
  800662:	68 95 00 00 00       	push   $0x95
  800667:	68 bc 22 80 00       	push   $0x8022bc
  80066c:	e8 e4 01 00 00       	call   800855 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800671:	e8 e6 14 00 00       	call   801b5c <sys_pf_calculate_allocated_pages>
  800676:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	01 c9                	add    %ecx,%ecx
  800682:	01 c8                	add    %ecx,%eax
  800684:	85 c0                	test   %eax,%eax
  800686:	79 05                	jns    80068d <_main+0x655>
  800688:	05 ff 0f 00 00       	add    $0xfff,%eax
  80068d:	c1 f8 0c             	sar    $0xc,%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 17                	je     8006ab <_main+0x673>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 48 23 80 00       	push   $0x802348
  80069c:	68 97 00 00 00       	push   $0x97
  8006a1:	68 bc 22 80 00       	push   $0x8022bc
  8006a6:	e8 aa 01 00 00       	call   800855 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  8006ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006ae:	89 d0                	mov    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	01 c0                	add    %eax,%eax
  8006b6:	01 d0                	add    %edx,%eax
  8006b8:	01 c0                	add    %eax,%eax
  8006ba:	f7 d8                	neg    %eax
  8006bc:	05 00 00 00 20       	add    $0x20000000,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 e3 11 00 00       	call   8018ad <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	74 17                	je     8006ee <_main+0x6b6>
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	68 7c 23 80 00       	push   $0x80237c
  8006df:	68 a0 00 00 00       	push   $0xa0
  8006e4:	68 bc 22 80 00       	push   $0x8022bc
  8006e9:	e8 67 01 00 00       	call   800855 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 e0 23 80 00       	push   $0x8023e0
  8006f6:	e8 0e 04 00 00       	call   800b09 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp

		return;
  8006fe:	90                   	nop
	}
}
  8006ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800702:	5b                   	pop    %ebx
  800703:	5f                   	pop    %edi
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80070c:	e8 8b 16 00 00       	call   801d9c <sys_getenvindex>
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	01 c0                	add    %eax,%eax
  80071b:	01 d0                	add    %edx,%eax
  80071d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800724:	01 c8                	add    %ecx,%eax
  800726:	c1 e0 02             	shl    $0x2,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800732:	01 c8                	add    %ecx,%eax
  800734:	c1 e0 02             	shl    $0x2,%eax
  800737:	01 d0                	add    %edx,%eax
  800739:	c1 e0 02             	shl    $0x2,%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	c1 e0 03             	shl    $0x3,%eax
  800741:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800746:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80074b:	a1 20 30 80 00       	mov    0x803020,%eax
  800750:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800756:	84 c0                	test   %al,%al
  800758:	74 0f                	je     800769 <libmain+0x63>
		binaryname = myEnv->prog_name;
  80075a:	a1 20 30 80 00       	mov    0x803020,%eax
  80075f:	05 18 da 01 00       	add    $0x1da18,%eax
  800764:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800769:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80076d:	7e 0a                	jle    800779 <libmain+0x73>
		binaryname = argv[0];
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	ff 75 0c             	pushl  0xc(%ebp)
  80077f:	ff 75 08             	pushl  0x8(%ebp)
  800782:	e8 b1 f8 ff ff       	call   800038 <_main>
  800787:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80078a:	e8 1a 14 00 00       	call   801ba9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 44 24 80 00       	push   $0x802444
  800797:	e8 6d 03 00 00       	call   800b09 <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80079f:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a4:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8007aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8007af:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8007b5:	83 ec 04             	sub    $0x4,%esp
  8007b8:	52                   	push   %edx
  8007b9:	50                   	push   %eax
  8007ba:	68 6c 24 80 00       	push   $0x80246c
  8007bf:	e8 45 03 00 00       	call   800b09 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8007cc:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8007d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d7:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8007dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e2:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8007e8:	51                   	push   %ecx
  8007e9:	52                   	push   %edx
  8007ea:	50                   	push   %eax
  8007eb:	68 94 24 80 00       	push   $0x802494
  8007f0:	e8 14 03 00 00       	call   800b09 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8007fd:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	50                   	push   %eax
  800807:	68 ec 24 80 00       	push   $0x8024ec
  80080c:	e8 f8 02 00 00       	call   800b09 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800814:	83 ec 0c             	sub    $0xc,%esp
  800817:	68 44 24 80 00       	push   $0x802444
  80081c:	e8 e8 02 00 00       	call   800b09 <cprintf>
  800821:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800824:	e8 9a 13 00 00       	call   801bc3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800829:	e8 19 00 00 00       	call   800847 <exit>
}
  80082e:	90                   	nop
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800837:	83 ec 0c             	sub    $0xc,%esp
  80083a:	6a 00                	push   $0x0
  80083c:	e8 27 15 00 00       	call   801d68 <sys_destroy_env>
  800841:	83 c4 10             	add    $0x10,%esp
}
  800844:	90                   	nop
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <exit>:

void
exit(void)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80084d:	e8 7c 15 00 00       	call   801dce <sys_exit_env>
}
  800852:	90                   	nop
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80085b:	8d 45 10             	lea    0x10(%ebp),%eax
  80085e:	83 c0 04             	add    $0x4,%eax
  800861:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800864:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	74 16                	je     800883 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80086d:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 00 25 80 00       	push   $0x802500
  80087b:	e8 89 02 00 00       	call   800b09 <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800883:	a1 00 30 80 00       	mov    0x803000,%eax
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	50                   	push   %eax
  80088f:	68 05 25 80 00       	push   $0x802505
  800894:	e8 70 02 00 00       	call   800b09 <cprintf>
  800899:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80089c:	8b 45 10             	mov    0x10(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	e8 f3 01 00 00       	call   800a9e <vcprintf>
  8008ab:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	6a 00                	push   $0x0
  8008b3:	68 21 25 80 00       	push   $0x802521
  8008b8:	e8 e1 01 00 00       	call   800a9e <vcprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008c0:	e8 82 ff ff ff       	call   800847 <exit>

	// should not return here
	while (1) ;
  8008c5:	eb fe                	jmp    8008c5 <_panic+0x70>

008008c7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8008d2:	8b 50 74             	mov    0x74(%eax),%edx
  8008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d8:	39 c2                	cmp    %eax,%edx
  8008da:	74 14                	je     8008f0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 24 25 80 00       	push   $0x802524
  8008e4:	6a 26                	push   $0x26
  8008e6:	68 70 25 80 00       	push   $0x802570
  8008eb:	e8 65 ff ff ff       	call   800855 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008fe:	e9 c2 00 00 00       	jmp    8009c5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	01 d0                	add    %edx,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	85 c0                	test   %eax,%eax
  800916:	75 08                	jne    800920 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800918:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80091b:	e9 a2 00 00 00       	jmp    8009c2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800920:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800927:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80092e:	eb 69                	jmp    800999 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800930:	a1 20 30 80 00       	mov    0x803020,%eax
  800935:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80093b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	01 c0                	add    %eax,%eax
  800942:	01 d0                	add    %edx,%eax
  800944:	c1 e0 03             	shl    $0x3,%eax
  800947:	01 c8                	add    %ecx,%eax
  800949:	8a 40 04             	mov    0x4(%eax),%al
  80094c:	84 c0                	test   %al,%al
  80094e:	75 46                	jne    800996 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800950:	a1 20 30 80 00       	mov    0x803020,%eax
  800955:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80095b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80095e:	89 d0                	mov    %edx,%eax
  800960:	01 c0                	add    %eax,%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	c1 e0 03             	shl    $0x3,%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80096e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800971:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800976:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	01 c8                	add    %ecx,%eax
  800987:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	75 09                	jne    800996 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80098d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800994:	eb 12                	jmp    8009a8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800996:	ff 45 e8             	incl   -0x18(%ebp)
  800999:	a1 20 30 80 00       	mov    0x803020,%eax
  80099e:	8b 50 74             	mov    0x74(%eax),%edx
  8009a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	77 88                	ja     800930 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009ac:	75 14                	jne    8009c2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009ae:	83 ec 04             	sub    $0x4,%esp
  8009b1:	68 7c 25 80 00       	push   $0x80257c
  8009b6:	6a 3a                	push   $0x3a
  8009b8:	68 70 25 80 00       	push   $0x802570
  8009bd:	e8 93 fe ff ff       	call   800855 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009c2:	ff 45 f0             	incl   -0x10(%ebp)
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cb:	0f 8c 32 ff ff ff    	jl     800903 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009df:	eb 26                	jmp    800a07 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	01 c0                	add    %eax,%eax
  8009f3:	01 d0                	add    %edx,%eax
  8009f5:	c1 e0 03             	shl    $0x3,%eax
  8009f8:	01 c8                	add    %ecx,%eax
  8009fa:	8a 40 04             	mov    0x4(%eax),%al
  8009fd:	3c 01                	cmp    $0x1,%al
  8009ff:	75 03                	jne    800a04 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a01:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a04:	ff 45 e0             	incl   -0x20(%ebp)
  800a07:	a1 20 30 80 00       	mov    0x803020,%eax
  800a0c:	8b 50 74             	mov    0x74(%eax),%edx
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	39 c2                	cmp    %eax,%edx
  800a14:	77 cb                	ja     8009e1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a19:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a1c:	74 14                	je     800a32 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a1e:	83 ec 04             	sub    $0x4,%esp
  800a21:	68 d0 25 80 00       	push   $0x8025d0
  800a26:	6a 44                	push   $0x44
  800a28:	68 70 25 80 00       	push   $0x802570
  800a2d:	e8 23 fe ff ff       	call   800855 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a32:	90                   	nop
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 00                	mov    (%eax),%eax
  800a40:	8d 48 01             	lea    0x1(%eax),%ecx
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a46:	89 0a                	mov    %ecx,(%edx)
  800a48:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4b:	88 d1                	mov    %dl,%cl
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a5e:	75 2c                	jne    800a8c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a60:	a0 24 30 80 00       	mov    0x803024,%al
  800a65:	0f b6 c0             	movzbl %al,%eax
  800a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6b:	8b 12                	mov    (%edx),%edx
  800a6d:	89 d1                	mov    %edx,%ecx
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a72:	83 c2 08             	add    $0x8,%edx
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	50                   	push   %eax
  800a79:	51                   	push   %ecx
  800a7a:	52                   	push   %edx
  800a7b:	e8 7b 0f 00 00       	call   8019fb <sys_cputs>
  800a80:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8b 40 04             	mov    0x4(%eax),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a9b:	90                   	nop
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aa7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aae:	00 00 00 
	b.cnt = 0;
  800ab1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ab8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ac7:	50                   	push   %eax
  800ac8:	68 35 0a 80 00       	push   $0x800a35
  800acd:	e8 11 02 00 00       	call   800ce3 <vprintfmt>
  800ad2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ad5:	a0 24 30 80 00       	mov    0x803024,%al
  800ada:	0f b6 c0             	movzbl %al,%eax
  800add:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ae3:	83 ec 04             	sub    $0x4,%esp
  800ae6:	50                   	push   %eax
  800ae7:	52                   	push   %edx
  800ae8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aee:	83 c0 08             	add    $0x8,%eax
  800af1:	50                   	push   %eax
  800af2:	e8 04 0f 00 00       	call   8019fb <sys_cputs>
  800af7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800afa:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800b01:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b0f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b16:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 f4             	pushl  -0xc(%ebp)
  800b25:	50                   	push   %eax
  800b26:	e8 73 ff ff ff       	call   800a9e <vcprintf>
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b3c:	e8 68 10 00 00       	call   801ba9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	e8 48 ff ff ff       	call   800a9e <vcprintf>
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b5c:	e8 62 10 00 00       	call   801bc3 <sys_enable_interrupt>
	return cnt;
  800b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	53                   	push   %ebx
  800b6a:	83 ec 14             	sub    $0x14,%esp
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b73:	8b 45 14             	mov    0x14(%ebp),%eax
  800b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b79:	8b 45 18             	mov    0x18(%ebp),%eax
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b81:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b84:	77 55                	ja     800bdb <printnum+0x75>
  800b86:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b89:	72 05                	jb     800b90 <printnum+0x2a>
  800b8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b8e:	77 4b                	ja     800bdb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b90:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b93:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b96:	8b 45 18             	mov    0x18(%ebp),%eax
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9e:	52                   	push   %edx
  800b9f:	50                   	push   %eax
  800ba0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba6:	e8 85 14 00 00       	call   802030 <__udivdi3>
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	ff 75 20             	pushl  0x20(%ebp)
  800bb4:	53                   	push   %ebx
  800bb5:	ff 75 18             	pushl  0x18(%ebp)
  800bb8:	52                   	push   %edx
  800bb9:	50                   	push   %eax
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	ff 75 08             	pushl  0x8(%ebp)
  800bc0:	e8 a1 ff ff ff       	call   800b66 <printnum>
  800bc5:	83 c4 20             	add    $0x20,%esp
  800bc8:	eb 1a                	jmp    800be4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	ff 75 20             	pushl  0x20(%ebp)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bdb:	ff 4d 1c             	decl   0x1c(%ebp)
  800bde:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800be2:	7f e6                	jg     800bca <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800be7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	53                   	push   %ebx
  800bf3:	51                   	push   %ecx
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	e8 45 15 00 00       	call   802140 <__umoddi3>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	05 34 28 80 00       	add    $0x802834,%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	0f be c0             	movsbl %al,%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
}
  800c17:	90                   	nop
  800c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c20:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c24:	7e 1c                	jle    800c42 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	8d 50 08             	lea    0x8(%eax),%edx
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 10                	mov    %edx,(%eax)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	83 e8 08             	sub    $0x8,%eax
  800c3b:	8b 50 04             	mov    0x4(%eax),%edx
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	eb 40                	jmp    800c82 <getuint+0x65>
	else if (lflag)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 1e                	je     800c66 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	8d 50 04             	lea    0x4(%eax),%edx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 10                	mov    %edx,(%eax)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	83 e8 04             	sub    $0x4,%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c64:	eb 1c                	jmp    800c82 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	8d 50 04             	lea    0x4(%eax),%edx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	89 10                	mov    %edx,(%eax)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	83 e8 04             	sub    $0x4,%eax
  800c7b:	8b 00                	mov    (%eax),%eax
  800c7d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c8b:	7e 1c                	jle    800ca9 <getint+0x25>
		return va_arg(*ap, long long);
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	8d 50 08             	lea    0x8(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 10                	mov    %edx,(%eax)
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	83 e8 08             	sub    $0x8,%eax
  800ca2:	8b 50 04             	mov    0x4(%eax),%edx
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	eb 38                	jmp    800ce1 <getint+0x5d>
	else if (lflag)
  800ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cad:	74 1a                	je     800cc9 <getint+0x45>
		return va_arg(*ap, long);
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8b 00                	mov    (%eax),%eax
  800cb4:	8d 50 04             	lea    0x4(%eax),%edx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 10                	mov    %edx,(%eax)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	83 e8 04             	sub    $0x4,%eax
  800cc4:	8b 00                	mov    (%eax),%eax
  800cc6:	99                   	cltd   
  800cc7:	eb 18                	jmp    800ce1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8b 00                	mov    (%eax),%eax
  800cce:	8d 50 04             	lea    0x4(%eax),%edx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 10                	mov    %edx,(%eax)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	83 e8 04             	sub    $0x4,%eax
  800cde:	8b 00                	mov    (%eax),%eax
  800ce0:	99                   	cltd   
}
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ceb:	eb 17                	jmp    800d04 <vprintfmt+0x21>
			if (ch == '\0')
  800ced:	85 db                	test   %ebx,%ebx
  800cef:	0f 84 af 03 00 00    	je     8010a4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	53                   	push   %ebx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f b6 d8             	movzbl %al,%ebx
  800d12:	83 fb 25             	cmp    $0x25,%ebx
  800d15:	75 d6                	jne    800ced <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d17:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d1b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d30:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	8d 50 01             	lea    0x1(%eax),%edx
  800d3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 d8             	movzbl %al,%ebx
  800d45:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d48:	83 f8 55             	cmp    $0x55,%eax
  800d4b:	0f 87 2b 03 00 00    	ja     80107c <vprintfmt+0x399>
  800d51:	8b 04 85 58 28 80 00 	mov    0x802858(,%eax,4),%eax
  800d58:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d5a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d5e:	eb d7                	jmp    800d37 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d60:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d64:	eb d1                	jmp    800d37 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	c1 e0 02             	shl    $0x2,%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	01 c0                	add    %eax,%eax
  800d79:	01 d8                	add    %ebx,%eax
  800d7b:	83 e8 30             	sub    $0x30,%eax
  800d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d89:	83 fb 2f             	cmp    $0x2f,%ebx
  800d8c:	7e 3e                	jle    800dcc <vprintfmt+0xe9>
  800d8e:	83 fb 39             	cmp    $0x39,%ebx
  800d91:	7f 39                	jg     800dcc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d93:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d96:	eb d5                	jmp    800d6d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d98:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9b:	83 c0 04             	add    $0x4,%eax
  800d9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800da1:	8b 45 14             	mov    0x14(%ebp),%eax
  800da4:	83 e8 04             	sub    $0x4,%eax
  800da7:	8b 00                	mov    (%eax),%eax
  800da9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dac:	eb 1f                	jmp    800dcd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db2:	79 83                	jns    800d37 <vprintfmt+0x54>
				width = 0;
  800db4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dbb:	e9 77 ff ff ff       	jmp    800d37 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dc0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dc7:	e9 6b ff ff ff       	jmp    800d37 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dcc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dcd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd1:	0f 89 60 ff ff ff    	jns    800d37 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ddd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800de4:	e9 4e ff ff ff       	jmp    800d37 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800de9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dec:	e9 46 ff ff ff       	jmp    800d37 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	83 c0 04             	add    $0x4,%eax
  800df7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfd:	83 e8 04             	sub    $0x4,%eax
  800e00:	8b 00                	mov    (%eax),%eax
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	50                   	push   %eax
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	ff d0                	call   *%eax
  800e0e:	83 c4 10             	add    $0x10,%esp
			break;
  800e11:	e9 89 02 00 00       	jmp    80109f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e16:	8b 45 14             	mov    0x14(%ebp),%eax
  800e19:	83 c0 04             	add    $0x4,%eax
  800e1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e22:	83 e8 04             	sub    $0x4,%eax
  800e25:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e27:	85 db                	test   %ebx,%ebx
  800e29:	79 02                	jns    800e2d <vprintfmt+0x14a>
				err = -err;
  800e2b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e2d:	83 fb 64             	cmp    $0x64,%ebx
  800e30:	7f 0b                	jg     800e3d <vprintfmt+0x15a>
  800e32:	8b 34 9d a0 26 80 00 	mov    0x8026a0(,%ebx,4),%esi
  800e39:	85 f6                	test   %esi,%esi
  800e3b:	75 19                	jne    800e56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e3d:	53                   	push   %ebx
  800e3e:	68 45 28 80 00       	push   $0x802845
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	ff 75 08             	pushl  0x8(%ebp)
  800e49:	e8 5e 02 00 00       	call   8010ac <printfmt>
  800e4e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e51:	e9 49 02 00 00       	jmp    80109f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e56:	56                   	push   %esi
  800e57:	68 4e 28 80 00       	push   $0x80284e
  800e5c:	ff 75 0c             	pushl  0xc(%ebp)
  800e5f:	ff 75 08             	pushl  0x8(%ebp)
  800e62:	e8 45 02 00 00       	call   8010ac <printfmt>
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 30 02 00 00       	jmp    80109f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e72:	83 c0 04             	add    $0x4,%eax
  800e75:	89 45 14             	mov    %eax,0x14(%ebp)
  800e78:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7b:	83 e8 04             	sub    $0x4,%eax
  800e7e:	8b 30                	mov    (%eax),%esi
  800e80:	85 f6                	test   %esi,%esi
  800e82:	75 05                	jne    800e89 <vprintfmt+0x1a6>
				p = "(null)";
  800e84:	be 51 28 80 00       	mov    $0x802851,%esi
			if (width > 0 && padc != '-')
  800e89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8d:	7e 6d                	jle    800efc <vprintfmt+0x219>
  800e8f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e93:	74 67                	je     800efc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e98:	83 ec 08             	sub    $0x8,%esp
  800e9b:	50                   	push   %eax
  800e9c:	56                   	push   %esi
  800e9d:	e8 0c 03 00 00       	call   8011ae <strnlen>
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ea8:	eb 16                	jmp    800ec0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eaa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ebd:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec4:	7f e4                	jg     800eaa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec6:	eb 34                	jmp    800efc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ec8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ecc:	74 1c                	je     800eea <vprintfmt+0x207>
  800ece:	83 fb 1f             	cmp    $0x1f,%ebx
  800ed1:	7e 05                	jle    800ed8 <vprintfmt+0x1f5>
  800ed3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ed6:	7e 12                	jle    800eea <vprintfmt+0x207>
					putch('?', putdat);
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	6a 3f                	push   $0x3f
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
  800ee8:	eb 0f                	jmp    800ef9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	53                   	push   %ebx
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef9:	ff 4d e4             	decl   -0x1c(%ebp)
  800efc:	89 f0                	mov    %esi,%eax
  800efe:	8d 70 01             	lea    0x1(%eax),%esi
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f be d8             	movsbl %al,%ebx
  800f06:	85 db                	test   %ebx,%ebx
  800f08:	74 24                	je     800f2e <vprintfmt+0x24b>
  800f0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f0e:	78 b8                	js     800ec8 <vprintfmt+0x1e5>
  800f10:	ff 4d e0             	decl   -0x20(%ebp)
  800f13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f17:	79 af                	jns    800ec8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f19:	eb 13                	jmp    800f2e <vprintfmt+0x24b>
				putch(' ', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 20                	push   $0x20
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f2b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f32:	7f e7                	jg     800f1b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f34:	e9 66 01 00 00       	jmp    80109f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f42:	50                   	push   %eax
  800f43:	e8 3c fd ff ff       	call   800c84 <getint>
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f57:	85 d2                	test   %edx,%edx
  800f59:	79 23                	jns    800f7e <vprintfmt+0x29b>
				putch('-', putdat);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 0c             	pushl  0xc(%ebp)
  800f61:	6a 2d                	push   $0x2d
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	ff d0                	call   *%eax
  800f68:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f71:	f7 d8                	neg    %eax
  800f73:	83 d2 00             	adc    $0x0,%edx
  800f76:	f7 da                	neg    %edx
  800f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f85:	e9 bc 00 00 00       	jmp    801046 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f8a:	83 ec 08             	sub    $0x8,%esp
  800f8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f90:	8d 45 14             	lea    0x14(%ebp),%eax
  800f93:	50                   	push   %eax
  800f94:	e8 84 fc ff ff       	call   800c1d <getuint>
  800f99:	83 c4 10             	add    $0x10,%esp
  800f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fa2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fa9:	e9 98 00 00 00       	jmp    801046 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	ff 75 0c             	pushl  0xc(%ebp)
  800fb4:	6a 58                	push   $0x58
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	ff d0                	call   *%eax
  800fbb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 58                	push   $0x58
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fce:	83 ec 08             	sub    $0x8,%esp
  800fd1:	ff 75 0c             	pushl  0xc(%ebp)
  800fd4:	6a 58                	push   $0x58
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	ff d0                	call   *%eax
  800fdb:	83 c4 10             	add    $0x10,%esp
			break;
  800fde:	e9 bc 00 00 00       	jmp    80109f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 30                	push   $0x30
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	6a 78                	push   $0x78
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	ff d0                	call   *%eax
  801000:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801003:	8b 45 14             	mov    0x14(%ebp),%eax
  801006:	83 c0 04             	add    $0x4,%eax
  801009:	89 45 14             	mov    %eax,0x14(%ebp)
  80100c:	8b 45 14             	mov    0x14(%ebp),%eax
  80100f:	83 e8 04             	sub    $0x4,%eax
  801012:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801014:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80101e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801025:	eb 1f                	jmp    801046 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	ff 75 e8             	pushl  -0x18(%ebp)
  80102d:	8d 45 14             	lea    0x14(%ebp),%eax
  801030:	50                   	push   %eax
  801031:	e8 e7 fb ff ff       	call   800c1d <getuint>
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80103f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801046:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80104a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104d:	83 ec 04             	sub    $0x4,%esp
  801050:	52                   	push   %edx
  801051:	ff 75 e4             	pushl  -0x1c(%ebp)
  801054:	50                   	push   %eax
  801055:	ff 75 f4             	pushl  -0xc(%ebp)
  801058:	ff 75 f0             	pushl  -0x10(%ebp)
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	ff 75 08             	pushl  0x8(%ebp)
  801061:	e8 00 fb ff ff       	call   800b66 <printnum>
  801066:	83 c4 20             	add    $0x20,%esp
			break;
  801069:	eb 34                	jmp    80109f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	53                   	push   %ebx
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			break;
  80107a:	eb 23                	jmp    80109f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80107c:	83 ec 08             	sub    $0x8,%esp
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	6a 25                	push   $0x25
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	ff d0                	call   *%eax
  801089:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80108c:	ff 4d 10             	decl   0x10(%ebp)
  80108f:	eb 03                	jmp    801094 <vprintfmt+0x3b1>
  801091:	ff 4d 10             	decl   0x10(%ebp)
  801094:	8b 45 10             	mov    0x10(%ebp),%eax
  801097:	48                   	dec    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 25                	cmp    $0x25,%al
  80109c:	75 f3                	jne    801091 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80109e:	90                   	nop
		}
	}
  80109f:	e9 47 fc ff ff       	jmp    800ceb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010a4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8010b5:	83 c0 04             	add    $0x4,%eax
  8010b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c1:	50                   	push   %eax
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	e8 16 fc ff ff       	call   800ce3 <vprintfmt>
  8010cd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010d0:	90                   	nop
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	8b 40 08             	mov    0x8(%eax),%eax
  8010dc:	8d 50 01             	lea    0x1(%eax),%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	8b 10                	mov    (%eax),%edx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	8b 40 04             	mov    0x4(%eax),%eax
  8010f0:	39 c2                	cmp    %eax,%edx
  8010f2:	73 12                	jae    801106 <sprintputch+0x33>
		*b->buf++ = ch;
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	8b 00                	mov    (%eax),%eax
  8010f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8010fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ff:	89 0a                	mov    %ecx,(%edx)
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	88 10                	mov    %dl,(%eax)
}
  801106:	90                   	nop
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80112a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80112e:	74 06                	je     801136 <vsnprintf+0x2d>
  801130:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801134:	7f 07                	jg     80113d <vsnprintf+0x34>
		return -E_INVAL;
  801136:	b8 03 00 00 00       	mov    $0x3,%eax
  80113b:	eb 20                	jmp    80115d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80113d:	ff 75 14             	pushl  0x14(%ebp)
  801140:	ff 75 10             	pushl  0x10(%ebp)
  801143:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	68 d3 10 80 00       	push   $0x8010d3
  80114c:	e8 92 fb ff ff       	call   800ce3 <vprintfmt>
  801151:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801157:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801165:	8d 45 10             	lea    0x10(%ebp),%eax
  801168:	83 c0 04             	add    $0x4,%eax
  80116b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	ff 75 f4             	pushl  -0xc(%ebp)
  801174:	50                   	push   %eax
  801175:	ff 75 0c             	pushl  0xc(%ebp)
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 89 ff ff ff       	call   801109 <vsnprintf>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801186:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801198:	eb 06                	jmp    8011a0 <strlen+0x15>
		n++;
  80119a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80119d:	ff 45 08             	incl   0x8(%ebp)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 f1                	jne    80119a <strlen+0xf>
		n++;
	return n;
  8011a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011bb:	eb 09                	jmp    8011c6 <strnlen+0x18>
		n++;
  8011bd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011c0:	ff 45 08             	incl   0x8(%ebp)
  8011c3:	ff 4d 0c             	decl   0xc(%ebp)
  8011c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ca:	74 09                	je     8011d5 <strnlen+0x27>
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	75 e8                	jne    8011bd <strnlen+0xf>
		n++;
	return n;
  8011d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011e6:	90                   	nop
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011f9:	8a 12                	mov    (%edx),%dl
  8011fb:	88 10                	mov    %dl,(%eax)
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	75 e4                	jne    8011e7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121b:	eb 1f                	jmp    80123c <strncpy+0x34>
		*dst++ = *src;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8d 50 01             	lea    0x1(%eax),%edx
  801223:	89 55 08             	mov    %edx,0x8(%ebp)
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	8a 12                	mov    (%edx),%dl
  80122b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 03                	je     801239 <strncpy+0x31>
			src++;
  801236:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801239:	ff 45 fc             	incl   -0x4(%ebp)
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801242:	72 d9                	jb     80121d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801244:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801259:	74 30                	je     80128b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80125b:	eb 16                	jmp    801273 <strlcpy+0x2a>
			*dst++ = *src++;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	8b 55 0c             	mov    0xc(%ebp),%edx
  801269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80126f:	8a 12                	mov    (%edx),%dl
  801271:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801273:	ff 4d 10             	decl   0x10(%ebp)
  801276:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127a:	74 09                	je     801285 <strlcpy+0x3c>
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	84 c0                	test   %al,%al
  801283:	75 d8                	jne    80125d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801291:	29 c2                	sub    %eax,%edx
  801293:	89 d0                	mov    %edx,%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80129a:	eb 06                	jmp    8012a2 <strcmp+0xb>
		p++, q++;
  80129c:	ff 45 08             	incl   0x8(%ebp)
  80129f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	84 c0                	test   %al,%al
  8012a9:	74 0e                	je     8012b9 <strcmp+0x22>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 10                	mov    (%eax),%dl
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	38 c2                	cmp    %al,%dl
  8012b7:	74 e3                	je     80129c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f b6 d0             	movzbl %al,%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f b6 c0             	movzbl %al,%eax
  8012c9:	29 c2                	sub    %eax,%edx
  8012cb:	89 d0                	mov    %edx,%eax
}
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012d2:	eb 09                	jmp    8012dd <strncmp+0xe>
		n--, p++, q++;
  8012d4:	ff 4d 10             	decl   0x10(%ebp)
  8012d7:	ff 45 08             	incl   0x8(%ebp)
  8012da:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e1:	74 17                	je     8012fa <strncmp+0x2b>
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	84 c0                	test   %al,%al
  8012ea:	74 0e                	je     8012fa <strncmp+0x2b>
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 10                	mov    (%eax),%dl
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	38 c2                	cmp    %al,%dl
  8012f8:	74 da                	je     8012d4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fe:	75 07                	jne    801307 <strncmp+0x38>
		return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb 14                	jmp    80131b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	0f b6 d0             	movzbl %al,%edx
  80130f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 c0             	movzbl %al,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
}
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801329:	eb 12                	jmp    80133d <strchr+0x20>
		if (*s == c)
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801333:	75 05                	jne    80133a <strchr+0x1d>
			return (char *) s;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	eb 11                	jmp    80134b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	84 c0                	test   %al,%al
  801344:	75 e5                	jne    80132b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 04             	sub    $0x4,%esp
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801359:	eb 0d                	jmp    801368 <strfind+0x1b>
		if (*s == c)
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801363:	74 0e                	je     801373 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801365:	ff 45 08             	incl   0x8(%ebp)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	84 c0                	test   %al,%al
  80136f:	75 ea                	jne    80135b <strfind+0xe>
  801371:	eb 01                	jmp    801374 <strfind+0x27>
		if (*s == c)
			break;
  801373:	90                   	nop
	return (char *) s;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80138b:	eb 0e                	jmp    80139b <memset+0x22>
		*p++ = c;
  80138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801390:	8d 50 01             	lea    0x1(%eax),%edx
  801393:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801396:	8b 55 0c             	mov    0xc(%ebp),%edx
  801399:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80139b:	ff 4d f8             	decl   -0x8(%ebp)
  80139e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8013a2:	79 e9                	jns    80138d <memset+0x14>
		*p++ = c;

	return v;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013bb:	eb 16                	jmp    8013d3 <memcpy+0x2a>
		*d++ = *s++;
  8013bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c0:	8d 50 01             	lea    0x1(%eax),%edx
  8013c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013cc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013cf:	8a 12                	mov    (%edx),%dl
  8013d1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	75 dd                	jne    8013bd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013fd:	73 50                	jae    80144f <memmove+0x6a>
  8013ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80140a:	76 43                	jbe    80144f <memmove+0x6a>
		s += n;
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801418:	eb 10                	jmp    80142a <memmove+0x45>
			*--d = *--s;
  80141a:	ff 4d f8             	decl   -0x8(%ebp)
  80141d:	ff 4d fc             	decl   -0x4(%ebp)
  801420:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801423:	8a 10                	mov    (%eax),%dl
  801425:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801428:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801430:	89 55 10             	mov    %edx,0x10(%ebp)
  801433:	85 c0                	test   %eax,%eax
  801435:	75 e3                	jne    80141a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801437:	eb 23                	jmp    80145c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801442:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801445:	8d 4a 01             	lea    0x1(%edx),%ecx
  801448:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80144b:	8a 12                	mov    (%edx),%dl
  80144d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80144f:	8b 45 10             	mov    0x10(%ebp),%eax
  801452:	8d 50 ff             	lea    -0x1(%eax),%edx
  801455:	89 55 10             	mov    %edx,0x10(%ebp)
  801458:	85 c0                	test   %eax,%eax
  80145a:	75 dd                	jne    801439 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801473:	eb 2a                	jmp    80149f <memcmp+0x3e>
		if (*s1 != *s2)
  801475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801478:	8a 10                	mov    (%eax),%dl
  80147a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	38 c2                	cmp    %al,%dl
  801481:	74 16                	je     801499 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	0f b6 d0             	movzbl %al,%edx
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 c0             	movzbl %al,%eax
  801493:	29 c2                	sub    %eax,%edx
  801495:	89 d0                	mov    %edx,%eax
  801497:	eb 18                	jmp    8014b1 <memcmp+0x50>
		s1++, s2++;
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	75 c9                	jne    801475 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bf:	01 d0                	add    %edx,%eax
  8014c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014c4:	eb 15                	jmp    8014db <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	0f b6 d0             	movzbl %al,%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	0f b6 c0             	movzbl %al,%eax
  8014d4:	39 c2                	cmp    %eax,%edx
  8014d6:	74 0d                	je     8014e5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014d8:	ff 45 08             	incl   0x8(%ebp)
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014e1:	72 e3                	jb     8014c6 <memfind+0x13>
  8014e3:	eb 01                	jmp    8014e6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014e5:	90                   	nop
	return (void *) s;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ff:	eb 03                	jmp    801504 <strtol+0x19>
		s++;
  801501:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	3c 20                	cmp    $0x20,%al
  80150b:	74 f4                	je     801501 <strtol+0x16>
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	3c 09                	cmp    $0x9,%al
  801514:	74 eb                	je     801501 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	3c 2b                	cmp    $0x2b,%al
  80151d:	75 05                	jne    801524 <strtol+0x39>
		s++;
  80151f:	ff 45 08             	incl   0x8(%ebp)
  801522:	eb 13                	jmp    801537 <strtol+0x4c>
	else if (*s == '-')
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 2d                	cmp    $0x2d,%al
  80152b:	75 0a                	jne    801537 <strtol+0x4c>
		s++, neg = 1;
  80152d:	ff 45 08             	incl   0x8(%ebp)
  801530:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153b:	74 06                	je     801543 <strtol+0x58>
  80153d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801541:	75 20                	jne    801563 <strtol+0x78>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	3c 30                	cmp    $0x30,%al
  80154a:	75 17                	jne    801563 <strtol+0x78>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	40                   	inc    %eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	3c 78                	cmp    $0x78,%al
  801554:	75 0d                	jne    801563 <strtol+0x78>
		s += 2, base = 16;
  801556:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80155a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801561:	eb 28                	jmp    80158b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801563:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801567:	75 15                	jne    80157e <strtol+0x93>
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	3c 30                	cmp    $0x30,%al
  801570:	75 0c                	jne    80157e <strtol+0x93>
		s++, base = 8;
  801572:	ff 45 08             	incl   0x8(%ebp)
  801575:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80157c:	eb 0d                	jmp    80158b <strtol+0xa0>
	else if (base == 0)
  80157e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801582:	75 07                	jne    80158b <strtol+0xa0>
		base = 10;
  801584:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3c 2f                	cmp    $0x2f,%al
  801592:	7e 19                	jle    8015ad <strtol+0xc2>
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	3c 39                	cmp    $0x39,%al
  80159b:	7f 10                	jg     8015ad <strtol+0xc2>
			dig = *s - '0';
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f be c0             	movsbl %al,%eax
  8015a5:	83 e8 30             	sub    $0x30,%eax
  8015a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015ab:	eb 42                	jmp    8015ef <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	3c 60                	cmp    $0x60,%al
  8015b4:	7e 19                	jle    8015cf <strtol+0xe4>
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	3c 7a                	cmp    $0x7a,%al
  8015bd:	7f 10                	jg     8015cf <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8a 00                	mov    (%eax),%al
  8015c4:	0f be c0             	movsbl %al,%eax
  8015c7:	83 e8 57             	sub    $0x57,%eax
  8015ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015cd:	eb 20                	jmp    8015ef <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	3c 40                	cmp    $0x40,%al
  8015d6:	7e 39                	jle    801611 <strtol+0x126>
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8a 00                	mov    (%eax),%al
  8015dd:	3c 5a                	cmp    $0x5a,%al
  8015df:	7f 30                	jg     801611 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	0f be c0             	movsbl %al,%eax
  8015e9:	83 e8 37             	sub    $0x37,%eax
  8015ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015f5:	7d 19                	jge    801610 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015f7:	ff 45 08             	incl   0x8(%ebp)
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fd:	0f af 45 10          	imul   0x10(%ebp),%eax
  801601:	89 c2                	mov    %eax,%edx
  801603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801606:	01 d0                	add    %edx,%eax
  801608:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80160b:	e9 7b ff ff ff       	jmp    80158b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801610:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801611:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801615:	74 08                	je     80161f <strtol+0x134>
		*endptr = (char *) s;
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	8b 55 08             	mov    0x8(%ebp),%edx
  80161d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80161f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801623:	74 07                	je     80162c <strtol+0x141>
  801625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801628:	f7 d8                	neg    %eax
  80162a:	eb 03                	jmp    80162f <strtol+0x144>
  80162c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <ltostr>:

void
ltostr(long value, char *str)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801637:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80163e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801649:	79 13                	jns    80165e <ltostr+0x2d>
	{
		neg = 1;
  80164b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801658:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80165b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801666:	99                   	cltd   
  801667:	f7 f9                	idiv   %ecx
  801669:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80166c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166f:	8d 50 01             	lea    0x1(%eax),%edx
  801672:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801675:	89 c2                	mov    %eax,%edx
  801677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167a:	01 d0                	add    %edx,%eax
  80167c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80167f:	83 c2 30             	add    $0x30,%edx
  801682:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801684:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801687:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80168c:	f7 e9                	imul   %ecx
  80168e:	c1 fa 02             	sar    $0x2,%edx
  801691:	89 c8                	mov    %ecx,%eax
  801693:	c1 f8 1f             	sar    $0x1f,%eax
  801696:	29 c2                	sub    %eax,%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80169d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016a5:	f7 e9                	imul   %ecx
  8016a7:	c1 fa 02             	sar    $0x2,%edx
  8016aa:	89 c8                	mov    %ecx,%eax
  8016ac:	c1 f8 1f             	sar    $0x1f,%eax
  8016af:	29 c2                	sub    %eax,%edx
  8016b1:	89 d0                	mov    %edx,%eax
  8016b3:	c1 e0 02             	shl    $0x2,%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	01 c0                	add    %eax,%eax
  8016ba:	29 c1                	sub    %eax,%ecx
  8016bc:	89 ca                	mov    %ecx,%edx
  8016be:	85 d2                	test   %edx,%edx
  8016c0:	75 9c                	jne    80165e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cc:	48                   	dec    %eax
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016d4:	74 3d                	je     801713 <ltostr+0xe2>
		start = 1 ;
  8016d6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016dd:	eb 34                	jmp    801713 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	01 d0                	add    %edx,%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	01 c2                	add    %eax,%edx
  8016f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fa:	01 c8                	add    %ecx,%eax
  8016fc:	8a 00                	mov    (%eax),%al
  8016fe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801700:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	01 c2                	add    %eax,%edx
  801708:	8a 45 eb             	mov    -0x15(%ebp),%al
  80170b:	88 02                	mov    %al,(%edx)
		start++ ;
  80170d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801710:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801716:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801719:	7c c4                	jl     8016df <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80171b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80171e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801721:	01 d0                	add    %edx,%eax
  801723:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801726:	90                   	nop
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 54 fa ff ff       	call   80118b <strlen>
  801737:	83 c4 04             	add    $0x4,%esp
  80173a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	e8 46 fa ff ff       	call   80118b <strlen>
  801745:	83 c4 04             	add    $0x4,%esp
  801748:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80174b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 17                	jmp    801772 <strcconcat+0x49>
		final[s] = str1[s] ;
  80175b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175e:	8b 45 10             	mov    0x10(%ebp),%eax
  801761:	01 c2                	add    %eax,%edx
  801763:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	01 c8                	add    %ecx,%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80176f:	ff 45 fc             	incl   -0x4(%ebp)
  801772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801775:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801778:	7c e1                	jl     80175b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80177a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801781:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801788:	eb 1f                	jmp    8017a9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80178a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178d:	8d 50 01             	lea    0x1(%eax),%edx
  801790:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801793:	89 c2                	mov    %eax,%edx
  801795:	8b 45 10             	mov    0x10(%ebp),%eax
  801798:	01 c2                	add    %eax,%edx
  80179a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	01 c8                	add    %ecx,%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8017a6:	ff 45 f8             	incl   -0x8(%ebp)
  8017a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017af:	7c d9                	jl     80178a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	c6 00 00             	movb   $0x0,(%eax)
}
  8017bc:	90                   	nop
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ce:	8b 00                	mov    (%eax),%eax
  8017d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017da:	01 d0                	add    %edx,%eax
  8017dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017e2:	eb 0c                	jmp    8017f0 <strsplit+0x31>
			*string++ = 0;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8d 50 01             	lea    0x1(%eax),%edx
  8017ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8017ed:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	84 c0                	test   %al,%al
  8017f7:	74 18                	je     801811 <strsplit+0x52>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	0f be c0             	movsbl %al,%eax
  801801:	50                   	push   %eax
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	e8 13 fb ff ff       	call   80131d <strchr>
  80180a:	83 c4 08             	add    $0x8,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 d3                	jne    8017e4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	8a 00                	mov    (%eax),%al
  801816:	84 c0                	test   %al,%al
  801818:	74 5a                	je     801874 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80181a:	8b 45 14             	mov    0x14(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	83 f8 0f             	cmp    $0xf,%eax
  801822:	75 07                	jne    80182b <strsplit+0x6c>
		{
			return 0;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	eb 66                	jmp    801891 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80182b:	8b 45 14             	mov    0x14(%ebp),%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	8d 48 01             	lea    0x1(%eax),%ecx
  801833:	8b 55 14             	mov    0x14(%ebp),%edx
  801836:	89 0a                	mov    %ecx,(%edx)
  801838:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183f:	8b 45 10             	mov    0x10(%ebp),%eax
  801842:	01 c2                	add    %eax,%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801849:	eb 03                	jmp    80184e <strsplit+0x8f>
			string++;
  80184b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	84 c0                	test   %al,%al
  801855:	74 8b                	je     8017e2 <strsplit+0x23>
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f be c0             	movsbl %al,%eax
  80185f:	50                   	push   %eax
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	e8 b5 fa ff ff       	call   80131d <strchr>
  801868:	83 c4 08             	add    $0x8,%esp
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 dc                	je     80184b <strsplit+0x8c>
			string++;
	}
  80186f:	e9 6e ff ff ff       	jmp    8017e2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801874:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801875:	8b 45 14             	mov    0x14(%ebp),%eax
  801878:	8b 00                	mov    (%eax),%eax
  80187a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	01 d0                	add    %edx,%eax
  801886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80188c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	68 b0 29 80 00       	push   $0x8029b0
  8018a1:	6a 0e                	push   $0xe
  8018a3:	68 ea 29 80 00       	push   $0x8029ea
  8018a8:	e8 a8 ef ff ff       	call   800855 <_panic>

008018ad <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8018b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	74 0f                	je     8018cb <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8018bc:	e8 d2 ff ff ff       	call   801893 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8018c1:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8018c8:	00 00 00 
	}
	if (size == 0) return NULL ;
  8018cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018cf:	75 07                	jne    8018d8 <malloc+0x2b>
  8018d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d6:	eb 14                	jmp    8018ec <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 f8 29 80 00       	push   $0x8029f8
  8018e0:	6a 2e                	push   $0x2e
  8018e2:	68 ea 29 80 00       	push   $0x8029ea
  8018e7:	e8 69 ef ff ff       	call   800855 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	68 20 2a 80 00       	push   $0x802a20
  8018fc:	6a 49                	push   $0x49
  8018fe:	68 ea 29 80 00       	push   $0x8029ea
  801903:	e8 4d ef ff ff       	call   800855 <_panic>

00801908 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 18             	sub    $0x18,%esp
  80190e:	8b 45 10             	mov    0x10(%ebp),%eax
  801911:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 44 2a 80 00       	push   $0x802a44
  80191c:	6a 57                	push   $0x57
  80191e:	68 ea 29 80 00       	push   $0x8029ea
  801923:	e8 2d ef ff ff       	call   800855 <_panic>

00801928 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 6c 2a 80 00       	push   $0x802a6c
  801936:	6a 60                	push   $0x60
  801938:	68 ea 29 80 00       	push   $0x8029ea
  80193d:	e8 13 ef ff ff       	call   800855 <_panic>

00801942 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 90 2a 80 00       	push   $0x802a90
  801950:	6a 7c                	push   $0x7c
  801952:	68 ea 29 80 00       	push   $0x8029ea
  801957:	e8 f9 ee ff ff       	call   800855 <_panic>

0080195c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 b8 2a 80 00       	push   $0x802ab8
  80196a:	68 86 00 00 00       	push   $0x86
  80196f:	68 ea 29 80 00       	push   $0x8029ea
  801974:	e8 dc ee ff ff       	call   800855 <_panic>

00801979 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	68 dc 2a 80 00       	push   $0x802adc
  801987:	68 91 00 00 00       	push   $0x91
  80198c:	68 ea 29 80 00       	push   $0x8029ea
  801991:	e8 bf ee ff ff       	call   800855 <_panic>

00801996 <shrink>:

}
void shrink(uint32 newSize)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	68 dc 2a 80 00       	push   $0x802adc
  8019a4:	68 96 00 00 00       	push   $0x96
  8019a9:	68 ea 29 80 00       	push   $0x8029ea
  8019ae:	e8 a2 ee ff ff       	call   800855 <_panic>

008019b3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 dc 2a 80 00       	push   $0x802adc
  8019c1:	68 9b 00 00 00       	push   $0x9b
  8019c6:	68 ea 29 80 00       	push   $0x8029ea
  8019cb:	e8 85 ee ff ff       	call   800855 <_panic>

008019d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	57                   	push   %edi
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019eb:	cd 30                	int    $0x30
  8019ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5f                   	pop    %edi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	50                   	push   %eax
  801a17:	6a 00                	push   $0x0
  801a19:	e8 b2 ff ff ff       	call   8019d0 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 01                	push   $0x1
  801a33:	e8 98 ff ff ff       	call   8019d0 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 05                	push   $0x5
  801a50:	e8 7b ff ff ff       	call   8019d0 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a5f:	8b 75 18             	mov    0x18(%ebp),%esi
  801a62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
  801a70:	51                   	push   %ecx
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 06                	push   $0x6
  801a75:	e8 56 ff ff ff       	call   8019d0 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	6a 07                	push   $0x7
  801a97:	e8 34 ff ff ff       	call   8019d0 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	ff 75 08             	pushl  0x8(%ebp)
  801ab0:	6a 08                	push   $0x8
  801ab2:	e8 19 ff ff ff       	call   8019d0 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 09                	push   $0x9
  801acb:	e8 00 ff ff ff       	call   8019d0 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 0a                	push   $0xa
  801ae4:	e8 e7 fe ff ff       	call   8019d0 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 0b                	push   $0xb
  801afd:	e8 ce fe ff ff       	call   8019d0 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	ff 75 08             	pushl  0x8(%ebp)
  801b16:	6a 0f                	push   $0xf
  801b18:	e8 b3 fe ff ff       	call   8019d0 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	6a 10                	push   $0x10
  801b34:	e8 97 fe ff ff       	call   8019d0 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3c:	90                   	nop
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 11                	push   $0x11
  801b51:	e8 7a fe ff ff       	call   8019d0 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return ;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 0c                	push   $0xc
  801b6b:	e8 60 fe ff ff       	call   8019d0 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	6a 0d                	push   $0xd
  801b85:	e8 46 fe ff ff       	call   8019d0 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 0e                	push   $0xe
  801b9e:	e8 2d fe ff ff       	call   8019d0 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	90                   	nop
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 13                	push   $0x13
  801bb8:	e8 13 fe ff ff       	call   8019d0 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	90                   	nop
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 14                	push   $0x14
  801bd2:	e8 f9 fd ff ff       	call   8019d0 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	90                   	nop
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_cputc>:


void
sys_cputc(const char c)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801be9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	50                   	push   %eax
  801bf6:	6a 15                	push   $0x15
  801bf8:	e8 d3 fd ff ff       	call   8019d0 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	90                   	nop
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 16                	push   $0x16
  801c12:	e8 b9 fd ff ff       	call   8019d0 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	50                   	push   %eax
  801c2d:	6a 17                	push   $0x17
  801c2f:	e8 9c fd ff ff       	call   8019d0 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	52                   	push   %edx
  801c49:	50                   	push   %eax
  801c4a:	6a 1a                	push   $0x1a
  801c4c:	e8 7f fd ff ff       	call   8019d0 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	6a 18                	push   $0x18
  801c69:	e8 62 fd ff ff       	call   8019d0 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	90                   	nop
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 19                	push   $0x19
  801c87:	e8 44 fd ff ff       	call   8019d0 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	51                   	push   %ecx
  801cab:	52                   	push   %edx
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	50                   	push   %eax
  801cb0:	6a 1b                	push   $0x1b
  801cb2:	e8 19 fd ff ff       	call   8019d0 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 1c                	push   $0x1c
  801ccf:	e8 fc fc ff ff       	call   8019d0 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	51                   	push   %ecx
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 1d                	push   $0x1d
  801cee:	e8 dd fc ff ff       	call   8019d0 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 1e                	push   $0x1e
  801d0b:	e8 c0 fc ff ff       	call   8019d0 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 1f                	push   $0x1f
  801d24:	e8 a7 fc ff ff       	call   8019d0 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 14             	pushl  0x14(%ebp)
  801d39:	ff 75 10             	pushl  0x10(%ebp)
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	50                   	push   %eax
  801d40:	6a 20                	push   $0x20
  801d42:	e8 89 fc ff ff       	call   8019d0 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	50                   	push   %eax
  801d5b:	6a 21                	push   $0x21
  801d5d:	e8 6e fc ff ff       	call   8019d0 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	90                   	nop
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	50                   	push   %eax
  801d77:	6a 22                	push   $0x22
  801d79:	e8 52 fc ff ff       	call   8019d0 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 02                	push   $0x2
  801d92:	e8 39 fc ff ff       	call   8019d0 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 03                	push   $0x3
  801dab:	e8 20 fc ff ff       	call   8019d0 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 04                	push   $0x4
  801dc4:	e8 07 fc ff ff       	call   8019d0 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_exit_env>:


void sys_exit_env(void)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 23                	push   $0x23
  801ddd:	e8 ee fb ff ff       	call   8019d0 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	90                   	nop
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df1:	8d 50 04             	lea    0x4(%eax),%edx
  801df4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	6a 24                	push   $0x24
  801e01:	e8 ca fb ff ff       	call   8019d0 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
	return result;
  801e09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e12:	89 01                	mov    %eax,(%ecx)
  801e14:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	c9                   	leave  
  801e1b:	c2 04 00             	ret    $0x4

00801e1e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 10             	pushl  0x10(%ebp)
  801e28:	ff 75 0c             	pushl  0xc(%ebp)
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	6a 12                	push   $0x12
  801e30:	e8 9b fb ff ff       	call   8019d0 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return ;
  801e38:	90                   	nop
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_rcr2>:
uint32 sys_rcr2()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 25                	push   $0x25
  801e4a:	e8 81 fb ff ff       	call   8019d0 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e60:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 26                	push   $0x26
  801e6f:	e8 5c fb ff ff       	call   8019d0 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return ;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <rsttst>:
void rsttst()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 28                	push   $0x28
  801e89:	e8 42 fb ff ff       	call   8019d0 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 04             	sub    $0x4,%esp
  801e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ea0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ea3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	ff 75 10             	pushl  0x10(%ebp)
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	6a 27                	push   $0x27
  801eb4:	e8 17 fb ff ff       	call   8019d0 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebc:	90                   	nop
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <chktst>:
void chktst(uint32 n)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	ff 75 08             	pushl  0x8(%ebp)
  801ecd:	6a 29                	push   $0x29
  801ecf:	e8 fc fa ff ff       	call   8019d0 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed7:	90                   	nop
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <inctst>:

void inctst()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 2a                	push   $0x2a
  801ee9:	e8 e2 fa ff ff       	call   8019d0 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef1:	90                   	nop
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <gettst>:
uint32 gettst()
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 2b                	push   $0x2b
  801f03:	e8 c8 fa ff ff       	call   8019d0 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 2c                	push   $0x2c
  801f1f:	e8 ac fa ff ff       	call   8019d0 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
  801f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f2a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f2e:	75 07                	jne    801f37 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f30:	b8 01 00 00 00       	mov    $0x1,%eax
  801f35:	eb 05                	jmp    801f3c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2c                	push   $0x2c
  801f50:	e8 7b fa ff ff       	call   8019d0 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
  801f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f5b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f5f:	75 07                	jne    801f68 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb 05                	jmp    801f6d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 2c                	push   $0x2c
  801f81:	e8 4a fa ff ff       	call   8019d0 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
  801f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f8c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f90:	75 07                	jne    801f99 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f92:	b8 01 00 00 00       	mov    $0x1,%eax
  801f97:	eb 05                	jmp    801f9e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 2c                	push   $0x2c
  801fb2:	e8 19 fa ff ff       	call   8019d0 <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
  801fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fbd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fc1:	75 07                	jne    801fca <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc8:	eb 05                	jmp    801fcf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	6a 2d                	push   $0x2d
  801fe1:	e8 ea f9 ff ff       	call   8019d0 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe9:	90                   	nop
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ff0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	53                   	push   %ebx
  801fff:	51                   	push   %ecx
  802000:	52                   	push   %edx
  802001:	50                   	push   %eax
  802002:	6a 2e                	push   $0x2e
  802004:	e8 c7 f9 ff ff       	call   8019d0 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	52                   	push   %edx
  802021:	50                   	push   %eax
  802022:	6a 2f                	push   $0x2f
  802024:	e8 a7 f9 ff ff       	call   8019d0 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    
  80202e:	66 90                	xchg   %ax,%ax

00802030 <__udivdi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80203b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80203f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802047:	89 ca                	mov    %ecx,%edx
  802049:	89 f8                	mov    %edi,%eax
  80204b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80204f:	85 f6                	test   %esi,%esi
  802051:	75 2d                	jne    802080 <__udivdi3+0x50>
  802053:	39 cf                	cmp    %ecx,%edi
  802055:	77 65                	ja     8020bc <__udivdi3+0x8c>
  802057:	89 fd                	mov    %edi,%ebp
  802059:	85 ff                	test   %edi,%edi
  80205b:	75 0b                	jne    802068 <__udivdi3+0x38>
  80205d:	b8 01 00 00 00       	mov    $0x1,%eax
  802062:	31 d2                	xor    %edx,%edx
  802064:	f7 f7                	div    %edi
  802066:	89 c5                	mov    %eax,%ebp
  802068:	31 d2                	xor    %edx,%edx
  80206a:	89 c8                	mov    %ecx,%eax
  80206c:	f7 f5                	div    %ebp
  80206e:	89 c1                	mov    %eax,%ecx
  802070:	89 d8                	mov    %ebx,%eax
  802072:	f7 f5                	div    %ebp
  802074:	89 cf                	mov    %ecx,%edi
  802076:	89 fa                	mov    %edi,%edx
  802078:	83 c4 1c             	add    $0x1c,%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    
  802080:	39 ce                	cmp    %ecx,%esi
  802082:	77 28                	ja     8020ac <__udivdi3+0x7c>
  802084:	0f bd fe             	bsr    %esi,%edi
  802087:	83 f7 1f             	xor    $0x1f,%edi
  80208a:	75 40                	jne    8020cc <__udivdi3+0x9c>
  80208c:	39 ce                	cmp    %ecx,%esi
  80208e:	72 0a                	jb     80209a <__udivdi3+0x6a>
  802090:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802094:	0f 87 9e 00 00 00    	ja     802138 <__udivdi3+0x108>
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	89 fa                	mov    %edi,%edx
  8020a1:	83 c4 1c             	add    $0x1c,%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5f                   	pop    %edi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
  8020a9:	8d 76 00             	lea    0x0(%esi),%esi
  8020ac:	31 ff                	xor    %edi,%edi
  8020ae:	31 c0                	xor    %eax,%eax
  8020b0:	89 fa                	mov    %edi,%edx
  8020b2:	83 c4 1c             	add    $0x1c,%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5e                   	pop    %esi
  8020b7:	5f                   	pop    %edi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	89 d8                	mov    %ebx,%eax
  8020be:	f7 f7                	div    %edi
  8020c0:	31 ff                	xor    %edi,%edi
  8020c2:	89 fa                	mov    %edi,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020d1:	89 eb                	mov    %ebp,%ebx
  8020d3:	29 fb                	sub    %edi,%ebx
  8020d5:	89 f9                	mov    %edi,%ecx
  8020d7:	d3 e6                	shl    %cl,%esi
  8020d9:	89 c5                	mov    %eax,%ebp
  8020db:	88 d9                	mov    %bl,%cl
  8020dd:	d3 ed                	shr    %cl,%ebp
  8020df:	89 e9                	mov    %ebp,%ecx
  8020e1:	09 f1                	or     %esi,%ecx
  8020e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020e7:	89 f9                	mov    %edi,%ecx
  8020e9:	d3 e0                	shl    %cl,%eax
  8020eb:	89 c5                	mov    %eax,%ebp
  8020ed:	89 d6                	mov    %edx,%esi
  8020ef:	88 d9                	mov    %bl,%cl
  8020f1:	d3 ee                	shr    %cl,%esi
  8020f3:	89 f9                	mov    %edi,%ecx
  8020f5:	d3 e2                	shl    %cl,%edx
  8020f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020fb:	88 d9                	mov    %bl,%cl
  8020fd:	d3 e8                	shr    %cl,%eax
  8020ff:	09 c2                	or     %eax,%edx
  802101:	89 d0                	mov    %edx,%eax
  802103:	89 f2                	mov    %esi,%edx
  802105:	f7 74 24 0c          	divl   0xc(%esp)
  802109:	89 d6                	mov    %edx,%esi
  80210b:	89 c3                	mov    %eax,%ebx
  80210d:	f7 e5                	mul    %ebp
  80210f:	39 d6                	cmp    %edx,%esi
  802111:	72 19                	jb     80212c <__udivdi3+0xfc>
  802113:	74 0b                	je     802120 <__udivdi3+0xf0>
  802115:	89 d8                	mov    %ebx,%eax
  802117:	31 ff                	xor    %edi,%edi
  802119:	e9 58 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  80211e:	66 90                	xchg   %ax,%ax
  802120:	8b 54 24 08          	mov    0x8(%esp),%edx
  802124:	89 f9                	mov    %edi,%ecx
  802126:	d3 e2                	shl    %cl,%edx
  802128:	39 c2                	cmp    %eax,%edx
  80212a:	73 e9                	jae    802115 <__udivdi3+0xe5>
  80212c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80212f:	31 ff                	xor    %edi,%edi
  802131:	e9 40 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  802136:	66 90                	xchg   %ax,%ax
  802138:	31 c0                	xor    %eax,%eax
  80213a:	e9 37 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  80213f:	90                   	nop

00802140 <__umoddi3>:
  802140:	55                   	push   %ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 1c             	sub    $0x1c,%esp
  802147:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80214b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80214f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802153:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80215f:	89 f3                	mov    %esi,%ebx
  802161:	89 fa                	mov    %edi,%edx
  802163:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802167:	89 34 24             	mov    %esi,(%esp)
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 1a                	jne    802188 <__umoddi3+0x48>
  80216e:	39 f7                	cmp    %esi,%edi
  802170:	0f 86 a2 00 00 00    	jbe    802218 <__umoddi3+0xd8>
  802176:	89 c8                	mov    %ecx,%eax
  802178:	89 f2                	mov    %esi,%edx
  80217a:	f7 f7                	div    %edi
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	31 d2                	xor    %edx,%edx
  802180:	83 c4 1c             	add    $0x1c,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
  802188:	39 f0                	cmp    %esi,%eax
  80218a:	0f 87 ac 00 00 00    	ja     80223c <__umoddi3+0xfc>
  802190:	0f bd e8             	bsr    %eax,%ebp
  802193:	83 f5 1f             	xor    $0x1f,%ebp
  802196:	0f 84 ac 00 00 00    	je     802248 <__umoddi3+0x108>
  80219c:	bf 20 00 00 00       	mov    $0x20,%edi
  8021a1:	29 ef                	sub    %ebp,%edi
  8021a3:	89 fe                	mov    %edi,%esi
  8021a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021a9:	89 e9                	mov    %ebp,%ecx
  8021ab:	d3 e0                	shl    %cl,%eax
  8021ad:	89 d7                	mov    %edx,%edi
  8021af:	89 f1                	mov    %esi,%ecx
  8021b1:	d3 ef                	shr    %cl,%edi
  8021b3:	09 c7                	or     %eax,%edi
  8021b5:	89 e9                	mov    %ebp,%ecx
  8021b7:	d3 e2                	shl    %cl,%edx
  8021b9:	89 14 24             	mov    %edx,(%esp)
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	d3 e0                	shl    %cl,%eax
  8021c0:	89 c2                	mov    %eax,%edx
  8021c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021c6:	d3 e0                	shl    %cl,%eax
  8021c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021d0:	89 f1                	mov    %esi,%ecx
  8021d2:	d3 e8                	shr    %cl,%eax
  8021d4:	09 d0                	or     %edx,%eax
  8021d6:	d3 eb                	shr    %cl,%ebx
  8021d8:	89 da                	mov    %ebx,%edx
  8021da:	f7 f7                	div    %edi
  8021dc:	89 d3                	mov    %edx,%ebx
  8021de:	f7 24 24             	mull   (%esp)
  8021e1:	89 c6                	mov    %eax,%esi
  8021e3:	89 d1                	mov    %edx,%ecx
  8021e5:	39 d3                	cmp    %edx,%ebx
  8021e7:	0f 82 87 00 00 00    	jb     802274 <__umoddi3+0x134>
  8021ed:	0f 84 91 00 00 00    	je     802284 <__umoddi3+0x144>
  8021f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021f7:	29 f2                	sub    %esi,%edx
  8021f9:	19 cb                	sbb    %ecx,%ebx
  8021fb:	89 d8                	mov    %ebx,%eax
  8021fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 e9                	mov    %ebp,%ecx
  802205:	d3 ea                	shr    %cl,%edx
  802207:	09 d0                	or     %edx,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	d3 eb                	shr    %cl,%ebx
  80220d:	89 da                	mov    %ebx,%edx
  80220f:	83 c4 1c             	add    $0x1c,%esp
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5f                   	pop    %edi
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    
  802217:	90                   	nop
  802218:	89 fd                	mov    %edi,%ebp
  80221a:	85 ff                	test   %edi,%edi
  80221c:	75 0b                	jne    802229 <__umoddi3+0xe9>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c5                	mov    %eax,%ebp
  802229:	89 f0                	mov    %esi,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f5                	div    %ebp
  80222f:	89 c8                	mov    %ecx,%eax
  802231:	f7 f5                	div    %ebp
  802233:	89 d0                	mov    %edx,%eax
  802235:	e9 44 ff ff ff       	jmp    80217e <__umoddi3+0x3e>
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	89 c8                	mov    %ecx,%eax
  80223e:	89 f2                	mov    %esi,%edx
  802240:	83 c4 1c             	add    $0x1c,%esp
  802243:	5b                   	pop    %ebx
  802244:	5e                   	pop    %esi
  802245:	5f                   	pop    %edi
  802246:	5d                   	pop    %ebp
  802247:	c3                   	ret    
  802248:	3b 04 24             	cmp    (%esp),%eax
  80224b:	72 06                	jb     802253 <__umoddi3+0x113>
  80224d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802251:	77 0f                	ja     802262 <__umoddi3+0x122>
  802253:	89 f2                	mov    %esi,%edx
  802255:	29 f9                	sub    %edi,%ecx
  802257:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80225b:	89 14 24             	mov    %edx,(%esp)
  80225e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802262:	8b 44 24 04          	mov    0x4(%esp),%eax
  802266:	8b 14 24             	mov    (%esp),%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d 76 00             	lea    0x0(%esi),%esi
  802274:	2b 04 24             	sub    (%esp),%eax
  802277:	19 fa                	sbb    %edi,%edx
  802279:	89 d1                	mov    %edx,%ecx
  80227b:	89 c6                	mov    %eax,%esi
  80227d:	e9 71 ff ff ff       	jmp    8021f3 <__umoddi3+0xb3>
  802282:	66 90                	xchg   %ax,%ax
  802284:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802288:	72 ea                	jb     802274 <__umoddi3+0x134>
  80228a:	89 d9                	mov    %ebx,%ecx
  80228c:	e9 62 ff ff ff       	jmp    8021f3 <__umoddi3+0xb3>
