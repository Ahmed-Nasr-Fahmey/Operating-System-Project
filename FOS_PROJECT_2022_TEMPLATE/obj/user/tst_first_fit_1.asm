
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 c4 0b 00 00       	call   800bfa <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

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
  800045:	e8 7b 24 00 00       	call   8024c5 <sys_set_uheap_strategy>
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
  80009b:	68 a0 27 80 00       	push   $0x8027a0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 bc 27 80 00       	push   $0x8027bc
  8000a7:	e8 9d 0c 00 00       	call   800d49 <_panic>
	}

	int Mega = 1024*1024;
  8000ac:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b3:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	6a 00                	push   $0x0
  8000bf:	e8 dd 1c 00 00       	call   801da1 <malloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 d3 1e 00 00       	call   801fb0 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 6b 1f 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	50                   	push   %eax
  8000f2:	e8 aa 1c 00 00       	call   801da1 <malloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fd:	8b 45 90             	mov    -0x70(%ebp),%eax
  800100:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 d4 27 80 00       	push   $0x8027d4
  80010f:	6a 26                	push   $0x26
  800111:	68 bc 27 80 00       	push   $0x8027bc
  800116:	e8 2e 0c 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80011b:	e8 30 1f 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800120:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800123:	3d 00 01 00 00       	cmp    $0x100,%eax
  800128:	74 14                	je     80013e <_main+0x106>
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	68 04 28 80 00       	push   $0x802804
  800132:	6a 28                	push   $0x28
  800134:	68 bc 27 80 00       	push   $0x8027bc
  800139:	e8 0b 0c 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80013e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800141:	e8 6a 1e 00 00       	call   801fb0 <sys_calculate_free_frames>
  800146:	29 c3                	sub    %eax,%ebx
  800148:	89 d8                	mov    %ebx,%eax
  80014a:	83 f8 01             	cmp    $0x1,%eax
  80014d:	74 14                	je     800163 <_main+0x12b>
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	68 21 28 80 00       	push   $0x802821
  800157:	6a 29                	push   $0x29
  800159:	68 bc 27 80 00       	push   $0x8027bc
  80015e:	e8 e6 0b 00 00       	call   800d49 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800163:	e8 48 1e 00 00       	call   801fb0 <sys_calculate_free_frames>
  800168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80016b:	e8 e0 1e 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800170:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800176:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	e8 1f 1c 00 00       	call   801da1 <malloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800188:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80018b:	89 c2                	mov    %eax,%edx
  80018d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800190:	05 00 00 00 80       	add    $0x80000000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 d4 27 80 00       	push   $0x8027d4
  8001a1:	6a 2f                	push   $0x2f
  8001a3:	68 bc 27 80 00       	push   $0x8027bc
  8001a8:	e8 9c 0b 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8001ad:	e8 9e 1e 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8001b2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001ba:	74 14                	je     8001d0 <_main+0x198>
  8001bc:	83 ec 04             	sub    $0x4,%esp
  8001bf:	68 04 28 80 00       	push   $0x802804
  8001c4:	6a 31                	push   $0x31
  8001c6:	68 bc 27 80 00       	push   $0x8027bc
  8001cb:	e8 79 0b 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d0:	e8 db 1d 00 00       	call   801fb0 <sys_calculate_free_frames>
  8001d5:	89 c2                	mov    %eax,%edx
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	39 c2                	cmp    %eax,%edx
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 21 28 80 00       	push   $0x802821
  8001e6:	6a 32                	push   $0x32
  8001e8:	68 bc 27 80 00       	push   $0x8027bc
  8001ed:	e8 57 0b 00 00       	call   800d49 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f2:	e8 b9 1d 00 00       	call   801fb0 <sys_calculate_free_frames>
  8001f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fa:	e8 51 1e 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	50                   	push   %eax
  80020c:	e8 90 1b 00 00       	call   801da1 <malloc>
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800217:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021a:	89 c2                	mov    %eax,%edx
  80021c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021f:	01 c0                	add    %eax,%eax
  800221:	05 00 00 00 80       	add    $0x80000000,%eax
  800226:	39 c2                	cmp    %eax,%edx
  800228:	74 14                	je     80023e <_main+0x206>
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	68 d4 27 80 00       	push   $0x8027d4
  800232:	6a 38                	push   $0x38
  800234:	68 bc 27 80 00       	push   $0x8027bc
  800239:	e8 0b 0b 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80023e:	e8 0d 1e 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800243:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800246:	3d 00 01 00 00       	cmp    $0x100,%eax
  80024b:	74 14                	je     800261 <_main+0x229>
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 04 28 80 00       	push   $0x802804
  800255:	6a 3a                	push   $0x3a
  800257:	68 bc 27 80 00       	push   $0x8027bc
  80025c:	e8 e8 0a 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800261:	e8 4a 1d 00 00       	call   801fb0 <sys_calculate_free_frames>
  800266:	89 c2                	mov    %eax,%edx
  800268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026b:	39 c2                	cmp    %eax,%edx
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 21 28 80 00       	push   $0x802821
  800277:	6a 3b                	push   $0x3b
  800279:	68 bc 27 80 00       	push   $0x8027bc
  80027e:	e8 c6 0a 00 00       	call   800d49 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800283:	e8 28 1d 00 00       	call   801fb0 <sys_calculate_free_frames>
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028b:	e8 c0 1d 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800290:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800296:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	50                   	push   %eax
  80029d:	e8 ff 1a 00 00       	call   801da1 <malloc>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ab:	89 c1                	mov    %eax,%ecx
  8002ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b0:	89 c2                	mov    %eax,%edx
  8002b2:	01 d2                	add    %edx,%edx
  8002b4:	01 d0                	add    %edx,%eax
  8002b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8002bb:	39 c1                	cmp    %eax,%ecx
  8002bd:	74 14                	je     8002d3 <_main+0x29b>
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 d4 27 80 00       	push   $0x8027d4
  8002c7:	6a 41                	push   $0x41
  8002c9:	68 bc 27 80 00       	push   $0x8027bc
  8002ce:	e8 76 0a 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8002d3:	e8 78 1d 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8002d8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002db:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002e0:	74 14                	je     8002f6 <_main+0x2be>
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 04 28 80 00       	push   $0x802804
  8002ea:	6a 43                	push   $0x43
  8002ec:	68 bc 27 80 00       	push   $0x8027bc
  8002f1:	e8 53 0a 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f6:	e8 b5 1c 00 00       	call   801fb0 <sys_calculate_free_frames>
  8002fb:	89 c2                	mov    %eax,%edx
  8002fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	74 14                	je     800318 <_main+0x2e0>
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	68 21 28 80 00       	push   $0x802821
  80030c:	6a 44                	push   $0x44
  80030e:	68 bc 27 80 00       	push   $0x8027bc
  800313:	e8 31 0a 00 00       	call   800d49 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800318:	e8 93 1c 00 00       	call   801fb0 <sys_calculate_free_frames>
  80031d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800320:	e8 2b 1d 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800325:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032b:	01 c0                	add    %eax,%eax
  80032d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	e8 68 1a 00 00       	call   801da1 <malloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80033f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800342:	89 c2                	mov    %eax,%edx
  800344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800347:	c1 e0 02             	shl    $0x2,%eax
  80034a:	05 00 00 00 80       	add    $0x80000000,%eax
  80034f:	39 c2                	cmp    %eax,%edx
  800351:	74 14                	je     800367 <_main+0x32f>
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	68 d4 27 80 00       	push   $0x8027d4
  80035b:	6a 4a                	push   $0x4a
  80035d:	68 bc 27 80 00       	push   $0x8027bc
  800362:	e8 e2 09 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800367:	e8 e4 1c 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80036c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036f:	3d 00 02 00 00       	cmp    $0x200,%eax
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 04 28 80 00       	push   $0x802804
  80037e:	6a 4c                	push   $0x4c
  800380:	68 bc 27 80 00       	push   $0x8027bc
  800385:	e8 bf 09 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80038a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80038d:	e8 1e 1c 00 00       	call   801fb0 <sys_calculate_free_frames>
  800392:	29 c3                	sub    %eax,%ebx
  800394:	89 d8                	mov    %ebx,%eax
  800396:	83 f8 01             	cmp    $0x1,%eax
  800399:	74 14                	je     8003af <_main+0x377>
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 21 28 80 00       	push   $0x802821
  8003a3:	6a 4d                	push   $0x4d
  8003a5:	68 bc 27 80 00       	push   $0x8027bc
  8003aa:	e8 9a 09 00 00       	call   800d49 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003af:	e8 fc 1b 00 00       	call   801fb0 <sys_calculate_free_frames>
  8003b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b7:	e8 94 1c 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8003bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c2:	01 c0                	add    %eax,%eax
  8003c4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003c7:	83 ec 0c             	sub    $0xc,%esp
  8003ca:	50                   	push   %eax
  8003cb:	e8 d1 19 00 00       	call   801da1 <malloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003d6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d9:	89 c1                	mov    %eax,%ecx
  8003db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003de:	89 d0                	mov    %edx,%eax
  8003e0:	01 c0                	add    %eax,%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003eb:	39 c1                	cmp    %eax,%ecx
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 d4 27 80 00       	push   $0x8027d4
  8003f7:	6a 53                	push   $0x53
  8003f9:	68 bc 27 80 00       	push   $0x8027bc
  8003fe:	e8 46 09 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800403:	e8 48 1c 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800408:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80040b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800410:	74 14                	je     800426 <_main+0x3ee>
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	68 04 28 80 00       	push   $0x802804
  80041a:	6a 55                	push   $0x55
  80041c:	68 bc 27 80 00       	push   $0x8027bc
  800421:	e8 23 09 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800426:	e8 85 1b 00 00       	call   801fb0 <sys_calculate_free_frames>
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800430:	39 c2                	cmp    %eax,%edx
  800432:	74 14                	je     800448 <_main+0x410>
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	68 21 28 80 00       	push   $0x802821
  80043c:	6a 56                	push   $0x56
  80043e:	68 bc 27 80 00       	push   $0x8027bc
  800443:	e8 01 09 00 00       	call   800d49 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800448:	e8 63 1b 00 00       	call   801fb0 <sys_calculate_free_frames>
  80044d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800450:	e8 fb 1b 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800455:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	01 d2                	add    %edx,%edx
  80045f:	01 d0                	add    %edx,%eax
  800461:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	50                   	push   %eax
  800468:	e8 34 19 00 00       	call   801da1 <malloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800473:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800476:	89 c2                	mov    %eax,%edx
  800478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047b:	c1 e0 03             	shl    $0x3,%eax
  80047e:	05 00 00 00 80       	add    $0x80000000,%eax
  800483:	39 c2                	cmp    %eax,%edx
  800485:	74 14                	je     80049b <_main+0x463>
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 d4 27 80 00       	push   $0x8027d4
  80048f:	6a 5c                	push   $0x5c
  800491:	68 bc 27 80 00       	push   $0x8027bc
  800496:	e8 ae 08 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80049b:	e8 b0 1b 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8004a0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004a3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 04 28 80 00       	push   $0x802804
  8004b2:	6a 5e                	push   $0x5e
  8004b4:	68 bc 27 80 00       	push   $0x8027bc
  8004b9:	e8 8b 08 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004c1:	e8 ea 1a 00 00       	call   801fb0 <sys_calculate_free_frames>
  8004c6:	29 c3                	sub    %eax,%ebx
  8004c8:	89 d8                	mov    %ebx,%eax
  8004ca:	83 f8 01             	cmp    $0x1,%eax
  8004cd:	74 14                	je     8004e3 <_main+0x4ab>
  8004cf:	83 ec 04             	sub    $0x4,%esp
  8004d2:	68 21 28 80 00       	push   $0x802821
  8004d7:	6a 5f                	push   $0x5f
  8004d9:	68 bc 27 80 00       	push   $0x8027bc
  8004de:	e8 66 08 00 00       	call   800d49 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004e3:	e8 c8 1a 00 00       	call   801fb0 <sys_calculate_free_frames>
  8004e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004eb:	e8 60 1b 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	01 d2                	add    %edx,%edx
  8004fa:	01 d0                	add    %edx,%eax
  8004fc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	50                   	push   %eax
  800503:	e8 99 18 00 00       	call   801da1 <malloc>
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  80050e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800511:	89 c1                	mov    %eax,%ecx
  800513:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800516:	89 d0                	mov    %edx,%eax
  800518:	c1 e0 02             	shl    $0x2,%eax
  80051b:	01 d0                	add    %edx,%eax
  80051d:	01 c0                	add    %eax,%eax
  80051f:	01 d0                	add    %edx,%eax
  800521:	05 00 00 00 80       	add    $0x80000000,%eax
  800526:	39 c1                	cmp    %eax,%ecx
  800528:	74 14                	je     80053e <_main+0x506>
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	68 d4 27 80 00       	push   $0x8027d4
  800532:	6a 65                	push   $0x65
  800534:	68 bc 27 80 00       	push   $0x8027bc
  800539:	e8 0b 08 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80053e:	e8 0d 1b 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800543:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800546:	3d 00 03 00 00       	cmp    $0x300,%eax
  80054b:	74 14                	je     800561 <_main+0x529>
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 04 28 80 00       	push   $0x802804
  800555:	6a 67                	push   $0x67
  800557:	68 bc 27 80 00       	push   $0x8027bc
  80055c:	e8 e8 07 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800561:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800564:	e8 47 1a 00 00       	call   801fb0 <sys_calculate_free_frames>
  800569:	29 c3                	sub    %eax,%ebx
  80056b:	89 d8                	mov    %ebx,%eax
  80056d:	83 f8 01             	cmp    $0x1,%eax
  800570:	74 14                	je     800586 <_main+0x54e>
  800572:	83 ec 04             	sub    $0x4,%esp
  800575:	68 21 28 80 00       	push   $0x802821
  80057a:	6a 68                	push   $0x68
  80057c:	68 bc 27 80 00       	push   $0x8027bc
  800581:	e8 c3 07 00 00       	call   800d49 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800586:	e8 25 1a 00 00       	call   801fb0 <sys_calculate_free_frames>
  80058b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80058e:	e8 bd 1a 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800596:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 40 18 00 00       	call   801de2 <free>
  8005a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8005a5:	e8 a6 1a 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8005aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ad:	29 c2                	sub    %eax,%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005b6:	74 14                	je     8005cc <_main+0x594>
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 34 28 80 00       	push   $0x802834
  8005c0:	6a 72                	push   $0x72
  8005c2:	68 bc 27 80 00       	push   $0x8027bc
  8005c7:	e8 7d 07 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005cc:	e8 df 19 00 00       	call   801fb0 <sys_calculate_free_frames>
  8005d1:	89 c2                	mov    %eax,%edx
  8005d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d6:	39 c2                	cmp    %eax,%edx
  8005d8:	74 14                	je     8005ee <_main+0x5b6>
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	68 4b 28 80 00       	push   $0x80284b
  8005e2:	6a 73                	push   $0x73
  8005e4:	68 bc 27 80 00       	push   $0x8027bc
  8005e9:	e8 5b 07 00 00       	call   800d49 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005ee:	e8 bd 19 00 00       	call   801fb0 <sys_calculate_free_frames>
  8005f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005f6:	e8 55 1a 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8005fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800601:	83 ec 0c             	sub    $0xc,%esp
  800604:	50                   	push   %eax
  800605:	e8 d8 17 00 00       	call   801de2 <free>
  80060a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  80060d:	e8 3e 1a 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800612:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800615:	29 c2                	sub    %eax,%edx
  800617:	89 d0                	mov    %edx,%eax
  800619:	3d 00 02 00 00       	cmp    $0x200,%eax
  80061e:	74 14                	je     800634 <_main+0x5fc>
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 34 28 80 00       	push   $0x802834
  800628:	6a 7a                	push   $0x7a
  80062a:	68 bc 27 80 00       	push   $0x8027bc
  80062f:	e8 15 07 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800634:	e8 77 19 00 00       	call   801fb0 <sys_calculate_free_frames>
  800639:	89 c2                	mov    %eax,%edx
  80063b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	74 14                	je     800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 4b 28 80 00       	push   $0x80284b
  80064a:	6a 7b                	push   $0x7b
  80064c:	68 bc 27 80 00       	push   $0x8027bc
  800651:	e8 f3 06 00 00       	call   800d49 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800656:	e8 55 19 00 00       	call   801fb0 <sys_calculate_free_frames>
  80065b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80065e:	e8 ed 19 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800663:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800666:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800669:	83 ec 0c             	sub    $0xc,%esp
  80066c:	50                   	push   %eax
  80066d:	e8 70 17 00 00       	call   801de2 <free>
  800672:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800675:	e8 d6 19 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80067a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067d:	29 c2                	sub    %eax,%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	3d 00 03 00 00       	cmp    $0x300,%eax
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 34 28 80 00       	push   $0x802834
  800690:	68 82 00 00 00       	push   $0x82
  800695:	68 bc 27 80 00       	push   $0x8027bc
  80069a:	e8 aa 06 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80069f:	e8 0c 19 00 00       	call   801fb0 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 4b 28 80 00       	push   $0x80284b
  8006b5:	68 83 00 00 00       	push   $0x83
  8006ba:	68 bc 27 80 00       	push   $0x8027bc
  8006bf:	e8 85 06 00 00       	call   800d49 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 e7 18 00 00       	call   801fb0 <sys_calculate_free_frames>
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 7f 19 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006d7:	89 d0                	mov    %edx,%eax
  8006d9:	c1 e0 09             	shl    $0x9,%eax
  8006dc:	29 d0                	sub    %edx,%eax
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	50                   	push   %eax
  8006e2:	e8 ba 16 00 00       	call   801da1 <malloc>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006fa:	39 c2                	cmp    %eax,%edx
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 d4 27 80 00       	push   $0x8027d4
  800706:	68 8c 00 00 00       	push   $0x8c
  80070b:	68 bc 27 80 00       	push   $0x8027bc
  800710:	e8 34 06 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800715:	e8 36 19 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80071a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80071d:	3d 80 00 00 00       	cmp    $0x80,%eax
  800722:	74 17                	je     80073b <_main+0x703>
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 04 28 80 00       	push   $0x802804
  80072c:	68 8e 00 00 00       	push   $0x8e
  800731:	68 bc 27 80 00       	push   $0x8027bc
  800736:	e8 0e 06 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80073b:	e8 70 18 00 00       	call   801fb0 <sys_calculate_free_frames>
  800740:	89 c2                	mov    %eax,%edx
  800742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800745:	39 c2                	cmp    %eax,%edx
  800747:	74 17                	je     800760 <_main+0x728>
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	68 21 28 80 00       	push   $0x802821
  800751:	68 8f 00 00 00       	push   $0x8f
  800756:	68 bc 27 80 00       	push   $0x8027bc
  80075b:	e8 e9 05 00 00       	call   800d49 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800760:	e8 4b 18 00 00       	call   801fb0 <sys_calculate_free_frames>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800768:	e8 e3 18 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800773:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	50                   	push   %eax
  80077a:	e8 22 16 00 00       	call   801da1 <malloc>
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800785:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800788:	89 c2                	mov    %eax,%edx
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c1 e0 02             	shl    $0x2,%eax
  800790:	05 00 00 00 80       	add    $0x80000000,%eax
  800795:	39 c2                	cmp    %eax,%edx
  800797:	74 17                	je     8007b0 <_main+0x778>
  800799:	83 ec 04             	sub    $0x4,%esp
  80079c:	68 d4 27 80 00       	push   $0x8027d4
  8007a1:	68 95 00 00 00       	push   $0x95
  8007a6:	68 bc 27 80 00       	push   $0x8027bc
  8007ab:	e8 99 05 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007b0:	e8 9b 18 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8007b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007b8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 04 28 80 00       	push   $0x802804
  8007c7:	68 97 00 00 00       	push   $0x97
  8007cc:	68 bc 27 80 00       	push   $0x8027bc
  8007d1:	e8 73 05 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007d6:	e8 d5 17 00 00       	call   801fb0 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 21 28 80 00       	push   $0x802821
  8007ec:	68 98 00 00 00       	push   $0x98
  8007f1:	68 bc 27 80 00       	push   $0x8027bc
  8007f6:	e8 4e 05 00 00       	call   800d49 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007fb:	e8 b0 17 00 00       	call   801fb0 <sys_calculate_free_frames>
  800800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800803:	e8 48 18 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80080b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080e:	89 d0                	mov    %edx,%eax
  800810:	c1 e0 08             	shl    $0x8,%eax
  800813:	29 d0                	sub    %edx,%eax
  800815:	83 ec 0c             	sub    $0xc,%esp
  800818:	50                   	push   %eax
  800819:	e8 83 15 00 00       	call   801da1 <malloc>
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800824:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800827:	89 c2                	mov    %eax,%edx
  800829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80082c:	c1 e0 09             	shl    $0x9,%eax
  80082f:	89 c1                	mov    %eax,%ecx
  800831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800834:	01 c8                	add    %ecx,%eax
  800836:	05 00 00 00 80       	add    $0x80000000,%eax
  80083b:	39 c2                	cmp    %eax,%edx
  80083d:	74 17                	je     800856 <_main+0x81e>
  80083f:	83 ec 04             	sub    $0x4,%esp
  800842:	68 d4 27 80 00       	push   $0x8027d4
  800847:	68 9e 00 00 00       	push   $0x9e
  80084c:	68 bc 27 80 00       	push   $0x8027bc
  800851:	e8 f3 04 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800856:	e8 f5 17 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80085b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80085e:	83 f8 40             	cmp    $0x40,%eax
  800861:	74 17                	je     80087a <_main+0x842>
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	68 04 28 80 00       	push   $0x802804
  80086b:	68 a0 00 00 00       	push   $0xa0
  800870:	68 bc 27 80 00       	push   $0x8027bc
  800875:	e8 cf 04 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80087a:	e8 31 17 00 00       	call   801fb0 <sys_calculate_free_frames>
  80087f:	89 c2                	mov    %eax,%edx
  800881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800884:	39 c2                	cmp    %eax,%edx
  800886:	74 17                	je     80089f <_main+0x867>
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	68 21 28 80 00       	push   $0x802821
  800890:	68 a1 00 00 00       	push   $0xa1
  800895:	68 bc 27 80 00       	push   $0x8027bc
  80089a:	e8 aa 04 00 00       	call   800d49 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80089f:	e8 0c 17 00 00       	call   801fb0 <sys_calculate_free_frames>
  8008a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a7:	e8 a4 17 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8008ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	50                   	push   %eax
  8008b8:	e8 e4 14 00 00       	call   801da1 <malloc>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8008c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008c6:	89 c2                	mov    %eax,%edx
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8008d3:	39 c2                	cmp    %eax,%edx
  8008d5:	74 17                	je     8008ee <_main+0x8b6>
  8008d7:	83 ec 04             	sub    $0x4,%esp
  8008da:	68 d4 27 80 00       	push   $0x8027d4
  8008df:	68 a7 00 00 00       	push   $0xa7
  8008e4:	68 bc 27 80 00       	push   $0x8027bc
  8008e9:	e8 5b 04 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8008ee:	e8 5d 17 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8008fb:	74 17                	je     800914 <_main+0x8dc>
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	68 04 28 80 00       	push   $0x802804
  800905:	68 a9 00 00 00       	push   $0xa9
  80090a:	68 bc 27 80 00       	push   $0x8027bc
  80090f:	e8 35 04 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800914:	e8 97 16 00 00       	call   801fb0 <sys_calculate_free_frames>
  800919:	89 c2                	mov    %eax,%edx
  80091b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	74 17                	je     800939 <_main+0x901>
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 21 28 80 00       	push   $0x802821
  80092a:	68 aa 00 00 00       	push   $0xaa
  80092f:	68 bc 27 80 00       	push   $0x8027bc
  800934:	e8 10 04 00 00       	call   800d49 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800939:	e8 72 16 00 00       	call   801fb0 <sys_calculate_free_frames>
  80093e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800941:	e8 0a 17 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094c:	c1 e0 02             	shl    $0x2,%eax
  80094f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800952:	83 ec 0c             	sub    $0xc,%esp
  800955:	50                   	push   %eax
  800956:	e8 46 14 00 00       	call   801da1 <malloc>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  800961:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800964:	89 c1                	mov    %eax,%ecx
  800966:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800969:	89 d0                	mov    %edx,%eax
  80096b:	01 c0                	add    %eax,%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	01 c0                	add    %eax,%eax
  800971:	01 d0                	add    %edx,%eax
  800973:	01 c0                	add    %eax,%eax
  800975:	05 00 00 00 80       	add    $0x80000000,%eax
  80097a:	39 c1                	cmp    %eax,%ecx
  80097c:	74 17                	je     800995 <_main+0x95d>
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	68 d4 27 80 00       	push   $0x8027d4
  800986:	68 b0 00 00 00       	push   $0xb0
  80098b:	68 bc 27 80 00       	push   $0x8027bc
  800990:	e8 b4 03 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800995:	e8 b6 16 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  80099a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80099d:	3d 00 04 00 00       	cmp    $0x400,%eax
  8009a2:	74 17                	je     8009bb <_main+0x983>
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	68 04 28 80 00       	push   $0x802804
  8009ac:	68 b2 00 00 00       	push   $0xb2
  8009b1:	68 bc 27 80 00       	push   $0x8027bc
  8009b6:	e8 8e 03 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8009bb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009be:	e8 ed 15 00 00       	call   801fb0 <sys_calculate_free_frames>
  8009c3:	29 c3                	sub    %eax,%ebx
  8009c5:	89 d8                	mov    %ebx,%eax
  8009c7:	83 f8 01             	cmp    $0x1,%eax
  8009ca:	74 17                	je     8009e3 <_main+0x9ab>
  8009cc:	83 ec 04             	sub    $0x4,%esp
  8009cf:	68 21 28 80 00       	push   $0x802821
  8009d4:	68 b3 00 00 00       	push   $0xb3
  8009d9:	68 bc 27 80 00       	push   $0x8027bc
  8009de:	e8 66 03 00 00       	call   800d49 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009e3:	e8 c8 15 00 00       	call   801fb0 <sys_calculate_free_frames>
  8009e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009eb:	e8 60 16 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  8009f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8009f3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8009f6:	83 ec 0c             	sub    $0xc,%esp
  8009f9:	50                   	push   %eax
  8009fa:	e8 e3 13 00 00       	call   801de2 <free>
  8009ff:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a02:	e8 49 16 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0a:	29 c2                	sub    %eax,%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a13:	74 17                	je     800a2c <_main+0x9f4>
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 34 28 80 00       	push   $0x802834
  800a1d:	68 bd 00 00 00       	push   $0xbd
  800a22:	68 bc 27 80 00       	push   $0x8027bc
  800a27:	e8 1d 03 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2c:	e8 7f 15 00 00       	call   801fb0 <sys_calculate_free_frames>
  800a31:	89 c2                	mov    %eax,%edx
  800a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a36:	39 c2                	cmp    %eax,%edx
  800a38:	74 17                	je     800a51 <_main+0xa19>
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	68 4b 28 80 00       	push   $0x80284b
  800a42:	68 be 00 00 00       	push   $0xbe
  800a47:	68 bc 27 80 00       	push   $0x8027bc
  800a4c:	e8 f8 02 00 00       	call   800d49 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a51:	e8 5a 15 00 00       	call   801fb0 <sys_calculate_free_frames>
  800a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a59:	e8 f2 15 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800a5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  800a61:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	50                   	push   %eax
  800a68:	e8 75 13 00 00       	call   801de2 <free>
  800a6d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a70:	e8 db 15 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 d0                	mov    %edx,%eax
  800a7c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a81:	74 17                	je     800a9a <_main+0xa62>
  800a83:	83 ec 04             	sub    $0x4,%esp
  800a86:	68 34 28 80 00       	push   $0x802834
  800a8b:	68 c5 00 00 00       	push   $0xc5
  800a90:	68 bc 27 80 00       	push   $0x8027bc
  800a95:	e8 af 02 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a9a:	e8 11 15 00 00       	call   801fb0 <sys_calculate_free_frames>
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aa4:	39 c2                	cmp    %eax,%edx
  800aa6:	74 17                	je     800abf <_main+0xa87>
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	68 4b 28 80 00       	push   $0x80284b
  800ab0:	68 c6 00 00 00       	push   $0xc6
  800ab5:	68 bc 27 80 00       	push   $0x8027bc
  800aba:	e8 8a 02 00 00       	call   800d49 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800abf:	e8 ec 14 00 00       	call   801fb0 <sys_calculate_free_frames>
  800ac4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac7:	e8 84 15 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800acc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800acf:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800ad2:	83 ec 0c             	sub    $0xc,%esp
  800ad5:	50                   	push   %eax
  800ad6:	e8 07 13 00 00       	call   801de2 <free>
  800adb:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800ade:	e8 6d 15 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae6:	29 c2                	sub    %eax,%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	3d 00 01 00 00       	cmp    $0x100,%eax
  800aef:	74 17                	je     800b08 <_main+0xad0>
  800af1:	83 ec 04             	sub    $0x4,%esp
  800af4:	68 34 28 80 00       	push   $0x802834
  800af9:	68 cd 00 00 00       	push   $0xcd
  800afe:	68 bc 27 80 00       	push   $0x8027bc
  800b03:	e8 41 02 00 00       	call   800d49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b08:	e8 a3 14 00 00       	call   801fb0 <sys_calculate_free_frames>
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	74 17                	je     800b2d <_main+0xaf5>
  800b16:	83 ec 04             	sub    $0x4,%esp
  800b19:	68 4b 28 80 00       	push   $0x80284b
  800b1e:	68 ce 00 00 00       	push   $0xce
  800b23:	68 bc 27 80 00       	push   $0x8027bc
  800b28:	e8 1c 02 00 00       	call   800d49 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800b2d:	e8 7e 14 00 00       	call   801fb0 <sys_calculate_free_frames>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b35:	e8 16 15 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800b3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b40:	c1 e0 06             	shl    $0x6,%eax
  800b43:	89 c2                	mov    %eax,%edx
  800b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	c1 e0 02             	shl    $0x2,%eax
  800b4d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	50                   	push   %eax
  800b54:	e8 48 12 00 00       	call   801da1 <malloc>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b62:	89 c1                	mov    %eax,%ecx
  800b64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b67:	89 d0                	mov    %edx,%eax
  800b69:	01 c0                	add    %eax,%eax
  800b6b:	01 d0                	add    %edx,%eax
  800b6d:	c1 e0 08             	shl    $0x8,%eax
  800b70:	89 c2                	mov    %eax,%edx
  800b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	05 00 00 00 80       	add    $0x80000000,%eax
  800b7c:	39 c1                	cmp    %eax,%ecx
  800b7e:	74 17                	je     800b97 <_main+0xb5f>
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 d4 27 80 00       	push   $0x8027d4
  800b88:	68 d8 00 00 00       	push   $0xd8
  800b8d:	68 bc 27 80 00       	push   $0x8027bc
  800b92:	e8 b2 01 00 00       	call   800d49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024+64) panic("Wrong page file allocation: ");
  800b97:	e8 b4 14 00 00       	call   802050 <sys_pf_calculate_allocated_pages>
  800b9c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800b9f:	3d 40 04 00 00       	cmp    $0x440,%eax
  800ba4:	74 17                	je     800bbd <_main+0xb85>
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	68 04 28 80 00       	push   $0x802804
  800bae:	68 da 00 00 00       	push   $0xda
  800bb3:	68 bc 27 80 00       	push   $0x8027bc
  800bb8:	e8 8c 01 00 00       	call   800d49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800bbd:	e8 ee 13 00 00       	call   801fb0 <sys_calculate_free_frames>
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc7:	39 c2                	cmp    %eax,%edx
  800bc9:	74 17                	je     800be2 <_main+0xbaa>
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	68 21 28 80 00       	push   $0x802821
  800bd3:	68 db 00 00 00       	push   $0xdb
  800bd8:	68 bc 27 80 00       	push   $0x8027bc
  800bdd:	e8 67 01 00 00       	call   800d49 <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	68 58 28 80 00       	push   $0x802858
  800bea:	e8 0e 04 00 00       	call   800ffd <cprintf>
  800bef:	83 c4 10             	add    $0x10,%esp

	return;
  800bf2:	90                   	nop
}
  800bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800c00:	e8 8b 16 00 00       	call   802290 <sys_getenvindex>
  800c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0b:	89 d0                	mov    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c18:	01 c8                	add    %ecx,%eax
  800c1a:	c1 e0 02             	shl    $0x2,%eax
  800c1d:	01 d0                	add    %edx,%eax
  800c1f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c26:	01 c8                	add    %ecx,%eax
  800c28:	c1 e0 02             	shl    $0x2,%eax
  800c2b:	01 d0                	add    %edx,%eax
  800c2d:	c1 e0 02             	shl    $0x2,%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	c1 e0 03             	shl    $0x3,%eax
  800c35:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c3a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c3f:	a1 20 30 80 00       	mov    0x803020,%eax
  800c44:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 0f                	je     800c5d <libmain+0x63>
		binaryname = myEnv->prog_name;
  800c4e:	a1 20 30 80 00       	mov    0x803020,%eax
  800c53:	05 18 da 01 00       	add    $0x1da18,%eax
  800c58:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c61:	7e 0a                	jle    800c6d <libmain+0x73>
		binaryname = argv[0];
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8b 00                	mov    (%eax),%eax
  800c68:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	ff 75 08             	pushl  0x8(%ebp)
  800c76:	e8 bd f3 ff ff       	call   800038 <_main>
  800c7b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c7e:	e8 1a 14 00 00       	call   80209d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	68 bc 28 80 00       	push   $0x8028bc
  800c8b:	e8 6d 03 00 00       	call   800ffd <cprintf>
  800c90:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c93:	a1 20 30 80 00       	mov    0x803020,%eax
  800c98:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800c9e:	a1 20 30 80 00       	mov    0x803020,%eax
  800ca3:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800ca9:	83 ec 04             	sub    $0x4,%esp
  800cac:	52                   	push   %edx
  800cad:	50                   	push   %eax
  800cae:	68 e4 28 80 00       	push   $0x8028e4
  800cb3:	e8 45 03 00 00       	call   800ffd <cprintf>
  800cb8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800cbb:	a1 20 30 80 00       	mov    0x803020,%eax
  800cc0:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800cc6:	a1 20 30 80 00       	mov    0x803020,%eax
  800ccb:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800cd1:	a1 20 30 80 00       	mov    0x803020,%eax
  800cd6:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800cdc:	51                   	push   %ecx
  800cdd:	52                   	push   %edx
  800cde:	50                   	push   %eax
  800cdf:	68 0c 29 80 00       	push   $0x80290c
  800ce4:	e8 14 03 00 00       	call   800ffd <cprintf>
  800ce9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800cec:	a1 20 30 80 00       	mov    0x803020,%eax
  800cf1:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	50                   	push   %eax
  800cfb:	68 64 29 80 00       	push   $0x802964
  800d00:	e8 f8 02 00 00       	call   800ffd <cprintf>
  800d05:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	68 bc 28 80 00       	push   $0x8028bc
  800d10:	e8 e8 02 00 00       	call   800ffd <cprintf>
  800d15:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800d18:	e8 9a 13 00 00       	call   8020b7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800d1d:	e8 19 00 00 00       	call   800d3b <exit>
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d2b:	83 ec 0c             	sub    $0xc,%esp
  800d2e:	6a 00                	push   $0x0
  800d30:	e8 27 15 00 00       	call   80225c <sys_destroy_env>
  800d35:	83 c4 10             	add    $0x10,%esp
}
  800d38:	90                   	nop
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <exit>:

void
exit(void)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d41:	e8 7c 15 00 00       	call   8022c2 <sys_exit_env>
}
  800d46:	90                   	nop
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d58:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	74 16                	je     800d77 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d61:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	50                   	push   %eax
  800d6a:	68 78 29 80 00       	push   $0x802978
  800d6f:	e8 89 02 00 00       	call   800ffd <cprintf>
  800d74:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d77:	a1 00 30 80 00       	mov    0x803000,%eax
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	ff 75 08             	pushl  0x8(%ebp)
  800d82:	50                   	push   %eax
  800d83:	68 7d 29 80 00       	push   $0x80297d
  800d88:	e8 70 02 00 00       	call   800ffd <cprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d90:	8b 45 10             	mov    0x10(%ebp),%eax
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	50                   	push   %eax
  800d9a:	e8 f3 01 00 00       	call   800f92 <vcprintf>
  800d9f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800da2:	83 ec 08             	sub    $0x8,%esp
  800da5:	6a 00                	push   $0x0
  800da7:	68 99 29 80 00       	push   $0x802999
  800dac:	e8 e1 01 00 00       	call   800f92 <vcprintf>
  800db1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800db4:	e8 82 ff ff ff       	call   800d3b <exit>

	// should not return here
	while (1) ;
  800db9:	eb fe                	jmp    800db9 <_panic+0x70>

00800dbb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800dc1:	a1 20 30 80 00       	mov    0x803020,%eax
  800dc6:	8b 50 74             	mov    0x74(%eax),%edx
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	39 c2                	cmp    %eax,%edx
  800dce:	74 14                	je     800de4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	68 9c 29 80 00       	push   $0x80299c
  800dd8:	6a 26                	push   $0x26
  800dda:	68 e8 29 80 00       	push   $0x8029e8
  800ddf:	e8 65 ff ff ff       	call   800d49 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800deb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800df2:	e9 c2 00 00 00       	jmp    800eb9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	01 d0                	add    %edx,%eax
  800e06:	8b 00                	mov    (%eax),%eax
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	75 08                	jne    800e14 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800e0c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800e0f:	e9 a2 00 00 00       	jmp    800eb6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800e14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e22:	eb 69                	jmp    800e8d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e24:	a1 20 30 80 00       	mov    0x803020,%eax
  800e29:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800e2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e32:	89 d0                	mov    %edx,%eax
  800e34:	01 c0                	add    %eax,%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	c1 e0 03             	shl    $0x3,%eax
  800e3b:	01 c8                	add    %ecx,%eax
  800e3d:	8a 40 04             	mov    0x4(%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 46                	jne    800e8a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e44:	a1 20 30 80 00       	mov    0x803020,%eax
  800e49:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800e4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	01 c0                	add    %eax,%eax
  800e56:	01 d0                	add    %edx,%eax
  800e58:	c1 e0 03             	shl    $0x3,%eax
  800e5b:	01 c8                	add    %ecx,%eax
  800e5d:	8b 00                	mov    (%eax),%eax
  800e5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e6a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	01 c8                	add    %ecx,%eax
  800e7b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e7d:	39 c2                	cmp    %eax,%edx
  800e7f:	75 09                	jne    800e8a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e81:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e88:	eb 12                	jmp    800e9c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e8a:	ff 45 e8             	incl   -0x18(%ebp)
  800e8d:	a1 20 30 80 00       	mov    0x803020,%eax
  800e92:	8b 50 74             	mov    0x74(%eax),%edx
  800e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e98:	39 c2                	cmp    %eax,%edx
  800e9a:	77 88                	ja     800e24 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ea0:	75 14                	jne    800eb6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800ea2:	83 ec 04             	sub    $0x4,%esp
  800ea5:	68 f4 29 80 00       	push   $0x8029f4
  800eaa:	6a 3a                	push   $0x3a
  800eac:	68 e8 29 80 00       	push   $0x8029e8
  800eb1:	e8 93 fe ff ff       	call   800d49 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800eb6:	ff 45 f0             	incl   -0x10(%ebp)
  800eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ebf:	0f 8c 32 ff ff ff    	jl     800df7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ecc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ed3:	eb 26                	jmp    800efb <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ed5:	a1 20 30 80 00       	mov    0x803020,%eax
  800eda:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ee3:	89 d0                	mov    %edx,%eax
  800ee5:	01 c0                	add    %eax,%eax
  800ee7:	01 d0                	add    %edx,%eax
  800ee9:	c1 e0 03             	shl    $0x3,%eax
  800eec:	01 c8                	add    %ecx,%eax
  800eee:	8a 40 04             	mov    0x4(%eax),%al
  800ef1:	3c 01                	cmp    $0x1,%al
  800ef3:	75 03                	jne    800ef8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ef5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ef8:	ff 45 e0             	incl   -0x20(%ebp)
  800efb:	a1 20 30 80 00       	mov    0x803020,%eax
  800f00:	8b 50 74             	mov    0x74(%eax),%edx
  800f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f06:	39 c2                	cmp    %eax,%edx
  800f08:	77 cb                	ja     800ed5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f10:	74 14                	je     800f26 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	68 48 2a 80 00       	push   $0x802a48
  800f1a:	6a 44                	push   $0x44
  800f1c:	68 e8 29 80 00       	push   $0x8029e8
  800f21:	e8 23 fe ff ff       	call   800d49 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f26:	90                   	nop
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8b 00                	mov    (%eax),%eax
  800f34:	8d 48 01             	lea    0x1(%eax),%ecx
  800f37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3a:	89 0a                	mov    %ecx,(%edx)
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	88 d1                	mov    %dl,%cl
  800f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f44:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f52:	75 2c                	jne    800f80 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f54:	a0 24 30 80 00       	mov    0x803024,%al
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5f:	8b 12                	mov    (%edx),%edx
  800f61:	89 d1                	mov    %edx,%ecx
  800f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f66:	83 c2 08             	add    $0x8,%edx
  800f69:	83 ec 04             	sub    $0x4,%esp
  800f6c:	50                   	push   %eax
  800f6d:	51                   	push   %ecx
  800f6e:	52                   	push   %edx
  800f6f:	e8 7b 0f 00 00       	call   801eef <sys_cputs>
  800f74:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 40 04             	mov    0x4(%eax),%eax
  800f86:	8d 50 01             	lea    0x1(%eax),%edx
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f8f:	90                   	nop
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f9b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800fa2:	00 00 00 
	b.cnt = 0;
  800fa5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fac:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	ff 75 08             	pushl  0x8(%ebp)
  800fb5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fbb:	50                   	push   %eax
  800fbc:	68 29 0f 80 00       	push   $0x800f29
  800fc1:	e8 11 02 00 00       	call   8011d7 <vprintfmt>
  800fc6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fc9:	a0 24 30 80 00       	mov    0x803024,%al
  800fce:	0f b6 c0             	movzbl %al,%eax
  800fd1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	50                   	push   %eax
  800fdb:	52                   	push   %edx
  800fdc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fe2:	83 c0 08             	add    $0x8,%eax
  800fe5:	50                   	push   %eax
  800fe6:	e8 04 0f 00 00       	call   801eef <sys_cputs>
  800feb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fee:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800ff5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <cprintf>:

int cprintf(const char *fmt, ...) {
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801003:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80100a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80100d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	83 ec 08             	sub    $0x8,%esp
  801016:	ff 75 f4             	pushl  -0xc(%ebp)
  801019:	50                   	push   %eax
  80101a:	e8 73 ff ff ff       	call   800f92 <vcprintf>
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801025:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801030:	e8 68 10 00 00       	call   80209d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801035:	8d 45 0c             	lea    0xc(%ebp),%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	83 ec 08             	sub    $0x8,%esp
  801041:	ff 75 f4             	pushl  -0xc(%ebp)
  801044:	50                   	push   %eax
  801045:	e8 48 ff ff ff       	call   800f92 <vcprintf>
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801050:	e8 62 10 00 00       	call   8020b7 <sys_enable_interrupt>
	return cnt;
  801055:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	53                   	push   %ebx
  80105e:	83 ec 14             	sub    $0x14,%esp
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801067:	8b 45 14             	mov    0x14(%ebp),%eax
  80106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80106d:	8b 45 18             	mov    0x18(%ebp),%eax
  801070:	ba 00 00 00 00       	mov    $0x0,%edx
  801075:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801078:	77 55                	ja     8010cf <printnum+0x75>
  80107a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80107d:	72 05                	jb     801084 <printnum+0x2a>
  80107f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801082:	77 4b                	ja     8010cf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801084:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801087:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80108a:	8b 45 18             	mov    0x18(%ebp),%eax
  80108d:	ba 00 00 00 00       	mov    $0x0,%edx
  801092:	52                   	push   %edx
  801093:	50                   	push   %eax
  801094:	ff 75 f4             	pushl  -0xc(%ebp)
  801097:	ff 75 f0             	pushl  -0x10(%ebp)
  80109a:	e8 85 14 00 00       	call   802524 <__udivdi3>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	83 ec 04             	sub    $0x4,%esp
  8010a5:	ff 75 20             	pushl  0x20(%ebp)
  8010a8:	53                   	push   %ebx
  8010a9:	ff 75 18             	pushl  0x18(%ebp)
  8010ac:	52                   	push   %edx
  8010ad:	50                   	push   %eax
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	ff 75 08             	pushl  0x8(%ebp)
  8010b4:	e8 a1 ff ff ff       	call   80105a <printnum>
  8010b9:	83 c4 20             	add    $0x20,%esp
  8010bc:	eb 1a                	jmp    8010d8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	ff 75 20             	pushl  0x20(%ebp)
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010cf:	ff 4d 1c             	decl   0x1c(%ebp)
  8010d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010d6:	7f e6                	jg     8010be <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010d8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	53                   	push   %ebx
  8010e7:	51                   	push   %ecx
  8010e8:	52                   	push   %edx
  8010e9:	50                   	push   %eax
  8010ea:	e8 45 15 00 00       	call   802634 <__umoddi3>
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	05 b4 2c 80 00       	add    $0x802cb4,%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be c0             	movsbl %al,%eax
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	ff 75 0c             	pushl  0xc(%ebp)
  801102:	50                   	push   %eax
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
}
  80110b:	90                   	nop
  80110c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801114:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801118:	7e 1c                	jle    801136 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8b 00                	mov    (%eax),%eax
  80111f:	8d 50 08             	lea    0x8(%eax),%edx
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 10                	mov    %edx,(%eax)
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8b 00                	mov    (%eax),%eax
  80112c:	83 e8 08             	sub    $0x8,%eax
  80112f:	8b 50 04             	mov    0x4(%eax),%edx
  801132:	8b 00                	mov    (%eax),%eax
  801134:	eb 40                	jmp    801176 <getuint+0x65>
	else if (lflag)
  801136:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113a:	74 1e                	je     80115a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 50 04             	lea    0x4(%eax),%edx
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	89 10                	mov    %edx,(%eax)
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	83 e8 04             	sub    $0x4,%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	ba 00 00 00 00       	mov    $0x0,%edx
  801158:	eb 1c                	jmp    801176 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8b 00                	mov    (%eax),%eax
  80115f:	8d 50 04             	lea    0x4(%eax),%edx
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	89 10                	mov    %edx,(%eax)
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	83 e8 04             	sub    $0x4,%eax
  80116f:	8b 00                	mov    (%eax),%eax
  801171:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80117b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80117f:	7e 1c                	jle    80119d <getint+0x25>
		return va_arg(*ap, long long);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8b 00                	mov    (%eax),%eax
  801186:	8d 50 08             	lea    0x8(%eax),%edx
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	89 10                	mov    %edx,(%eax)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8b 00                	mov    (%eax),%eax
  801193:	83 e8 08             	sub    $0x8,%eax
  801196:	8b 50 04             	mov    0x4(%eax),%edx
  801199:	8b 00                	mov    (%eax),%eax
  80119b:	eb 38                	jmp    8011d5 <getint+0x5d>
	else if (lflag)
  80119d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a1:	74 1a                	je     8011bd <getint+0x45>
		return va_arg(*ap, long);
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8b 00                	mov    (%eax),%eax
  8011a8:	8d 50 04             	lea    0x4(%eax),%edx
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	89 10                	mov    %edx,(%eax)
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b3:	8b 00                	mov    (%eax),%eax
  8011b5:	83 e8 04             	sub    $0x4,%eax
  8011b8:	8b 00                	mov    (%eax),%eax
  8011ba:	99                   	cltd   
  8011bb:	eb 18                	jmp    8011d5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8b 00                	mov    (%eax),%eax
  8011c2:	8d 50 04             	lea    0x4(%eax),%edx
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	89 10                	mov    %edx,(%eax)
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8b 00                	mov    (%eax),%eax
  8011cf:	83 e8 04             	sub    $0x4,%eax
  8011d2:	8b 00                	mov    (%eax),%eax
  8011d4:	99                   	cltd   
}
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	56                   	push   %esi
  8011db:	53                   	push   %ebx
  8011dc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011df:	eb 17                	jmp    8011f8 <vprintfmt+0x21>
			if (ch == '\0')
  8011e1:	85 db                	test   %ebx,%ebx
  8011e3:	0f 84 af 03 00 00    	je     801598 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	53                   	push   %ebx
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	ff d0                	call   *%eax
  8011f5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801201:	8a 00                	mov    (%eax),%al
  801203:	0f b6 d8             	movzbl %al,%ebx
  801206:	83 fb 25             	cmp    $0x25,%ebx
  801209:	75 d6                	jne    8011e1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80120b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80120f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801216:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80121d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801224:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 10             	mov    %edx,0x10(%ebp)
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f b6 d8             	movzbl %al,%ebx
  801239:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80123c:	83 f8 55             	cmp    $0x55,%eax
  80123f:	0f 87 2b 03 00 00    	ja     801570 <vprintfmt+0x399>
  801245:	8b 04 85 d8 2c 80 00 	mov    0x802cd8(,%eax,4),%eax
  80124c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80124e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801252:	eb d7                	jmp    80122b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801254:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801258:	eb d1                	jmp    80122b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80125a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801261:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801264:	89 d0                	mov    %edx,%eax
  801266:	c1 e0 02             	shl    $0x2,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	01 c0                	add    %eax,%eax
  80126d:	01 d8                	add    %ebx,%eax
  80126f:	83 e8 30             	sub    $0x30,%eax
  801272:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80127d:	83 fb 2f             	cmp    $0x2f,%ebx
  801280:	7e 3e                	jle    8012c0 <vprintfmt+0xe9>
  801282:	83 fb 39             	cmp    $0x39,%ebx
  801285:	7f 39                	jg     8012c0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801287:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80128a:	eb d5                	jmp    801261 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	83 c0 04             	add    $0x4,%eax
  801292:	89 45 14             	mov    %eax,0x14(%ebp)
  801295:	8b 45 14             	mov    0x14(%ebp),%eax
  801298:	83 e8 04             	sub    $0x4,%eax
  80129b:	8b 00                	mov    (%eax),%eax
  80129d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8012a0:	eb 1f                	jmp    8012c1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8012a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a6:	79 83                	jns    80122b <vprintfmt+0x54>
				width = 0;
  8012a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8012af:	e9 77 ff ff ff       	jmp    80122b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012b4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012bb:	e9 6b ff ff ff       	jmp    80122b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012c0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012c5:	0f 89 60 ff ff ff    	jns    80122b <vprintfmt+0x54>
				width = precision, precision = -1;
  8012cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012d8:	e9 4e ff ff ff       	jmp    80122b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012dd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012e0:	e9 46 ff ff ff       	jmp    80122b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e8:	83 c0 04             	add    $0x4,%eax
  8012eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	83 e8 04             	sub    $0x4,%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	50                   	push   %eax
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	ff d0                	call   *%eax
  801302:	83 c4 10             	add    $0x10,%esp
			break;
  801305:	e9 89 02 00 00       	jmp    801593 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	83 c0 04             	add    $0x4,%eax
  801310:	89 45 14             	mov    %eax,0x14(%ebp)
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	83 e8 04             	sub    $0x4,%eax
  801319:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80131b:	85 db                	test   %ebx,%ebx
  80131d:	79 02                	jns    801321 <vprintfmt+0x14a>
				err = -err;
  80131f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801321:	83 fb 64             	cmp    $0x64,%ebx
  801324:	7f 0b                	jg     801331 <vprintfmt+0x15a>
  801326:	8b 34 9d 20 2b 80 00 	mov    0x802b20(,%ebx,4),%esi
  80132d:	85 f6                	test   %esi,%esi
  80132f:	75 19                	jne    80134a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801331:	53                   	push   %ebx
  801332:	68 c5 2c 80 00       	push   $0x802cc5
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 5e 02 00 00       	call   8015a0 <printfmt>
  801342:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801345:	e9 49 02 00 00       	jmp    801593 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80134a:	56                   	push   %esi
  80134b:	68 ce 2c 80 00       	push   $0x802cce
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 45 02 00 00       	call   8015a0 <printfmt>
  80135b:	83 c4 10             	add    $0x10,%esp
			break;
  80135e:	e9 30 02 00 00       	jmp    801593 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801363:	8b 45 14             	mov    0x14(%ebp),%eax
  801366:	83 c0 04             	add    $0x4,%eax
  801369:	89 45 14             	mov    %eax,0x14(%ebp)
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	83 e8 04             	sub    $0x4,%eax
  801372:	8b 30                	mov    (%eax),%esi
  801374:	85 f6                	test   %esi,%esi
  801376:	75 05                	jne    80137d <vprintfmt+0x1a6>
				p = "(null)";
  801378:	be d1 2c 80 00       	mov    $0x802cd1,%esi
			if (width > 0 && padc != '-')
  80137d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801381:	7e 6d                	jle    8013f0 <vprintfmt+0x219>
  801383:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801387:	74 67                	je     8013f0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801389:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	50                   	push   %eax
  801390:	56                   	push   %esi
  801391:	e8 0c 03 00 00       	call   8016a2 <strnlen>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80139c:	eb 16                	jmp    8013b4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80139e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	50                   	push   %eax
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	ff d0                	call   *%eax
  8013ae:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013b1:	ff 4d e4             	decl   -0x1c(%ebp)
  8013b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013b8:	7f e4                	jg     80139e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013ba:	eb 34                	jmp    8013f0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013c0:	74 1c                	je     8013de <vprintfmt+0x207>
  8013c2:	83 fb 1f             	cmp    $0x1f,%ebx
  8013c5:	7e 05                	jle    8013cc <vprintfmt+0x1f5>
  8013c7:	83 fb 7e             	cmp    $0x7e,%ebx
  8013ca:	7e 12                	jle    8013de <vprintfmt+0x207>
					putch('?', putdat);
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	ff 75 0c             	pushl  0xc(%ebp)
  8013d2:	6a 3f                	push   $0x3f
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	ff d0                	call   *%eax
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	eb 0f                	jmp    8013ed <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	53                   	push   %ebx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	ff d0                	call   *%eax
  8013ea:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013ed:	ff 4d e4             	decl   -0x1c(%ebp)
  8013f0:	89 f0                	mov    %esi,%eax
  8013f2:	8d 70 01             	lea    0x1(%eax),%esi
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f be d8             	movsbl %al,%ebx
  8013fa:	85 db                	test   %ebx,%ebx
  8013fc:	74 24                	je     801422 <vprintfmt+0x24b>
  8013fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801402:	78 b8                	js     8013bc <vprintfmt+0x1e5>
  801404:	ff 4d e0             	decl   -0x20(%ebp)
  801407:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80140b:	79 af                	jns    8013bc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80140d:	eb 13                	jmp    801422 <vprintfmt+0x24b>
				putch(' ', putdat);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	6a 20                	push   $0x20
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	ff d0                	call   *%eax
  80141c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80141f:	ff 4d e4             	decl   -0x1c(%ebp)
  801422:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801426:	7f e7                	jg     80140f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801428:	e9 66 01 00 00       	jmp    801593 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	ff 75 e8             	pushl  -0x18(%ebp)
  801433:	8d 45 14             	lea    0x14(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	e8 3c fd ff ff       	call   801178 <getint>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801442:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144b:	85 d2                	test   %edx,%edx
  80144d:	79 23                	jns    801472 <vprintfmt+0x29b>
				putch('-', putdat);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	6a 2d                	push   $0x2d
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	ff d0                	call   *%eax
  80145c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80145f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801465:	f7 d8                	neg    %eax
  801467:	83 d2 00             	adc    $0x0,%edx
  80146a:	f7 da                	neg    %edx
  80146c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801472:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801479:	e9 bc 00 00 00       	jmp    80153a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	ff 75 e8             	pushl  -0x18(%ebp)
  801484:	8d 45 14             	lea    0x14(%ebp),%eax
  801487:	50                   	push   %eax
  801488:	e8 84 fc ff ff       	call   801111 <getuint>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801493:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801496:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80149d:	e9 98 00 00 00       	jmp    80153a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	6a 58                	push   $0x58
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	ff d0                	call   *%eax
  8014af:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	6a 58                	push   $0x58
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	ff d0                	call   *%eax
  8014bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014c2:	83 ec 08             	sub    $0x8,%esp
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	6a 58                	push   $0x58
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	ff d0                	call   *%eax
  8014cf:	83 c4 10             	add    $0x10,%esp
			break;
  8014d2:	e9 bc 00 00 00       	jmp    801593 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	6a 30                	push   $0x30
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	ff d0                	call   *%eax
  8014e4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	6a 78                	push   $0x78
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	ff d0                	call   *%eax
  8014f4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	83 c0 04             	add    $0x4,%eax
  8014fd:	89 45 14             	mov    %eax,0x14(%ebp)
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	83 e8 04             	sub    $0x4,%eax
  801506:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801508:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801519:	eb 1f                	jmp    80153a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 e8             	pushl  -0x18(%ebp)
  801521:	8d 45 14             	lea    0x14(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	e8 e7 fb ff ff       	call   801111 <getuint>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801530:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801533:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80153a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80153e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	52                   	push   %edx
  801545:	ff 75 e4             	pushl  -0x1c(%ebp)
  801548:	50                   	push   %eax
  801549:	ff 75 f4             	pushl  -0xc(%ebp)
  80154c:	ff 75 f0             	pushl  -0x10(%ebp)
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 00 fb ff ff       	call   80105a <printnum>
  80155a:	83 c4 20             	add    $0x20,%esp
			break;
  80155d:	eb 34                	jmp    801593 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	53                   	push   %ebx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	ff d0                	call   *%eax
  80156b:	83 c4 10             	add    $0x10,%esp
			break;
  80156e:	eb 23                	jmp    801593 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	6a 25                	push   $0x25
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	ff d0                	call   *%eax
  80157d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801580:	ff 4d 10             	decl   0x10(%ebp)
  801583:	eb 03                	jmp    801588 <vprintfmt+0x3b1>
  801585:	ff 4d 10             	decl   0x10(%ebp)
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	48                   	dec    %eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	3c 25                	cmp    $0x25,%al
  801590:	75 f3                	jne    801585 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801592:	90                   	nop
		}
	}
  801593:	e9 47 fc ff ff       	jmp    8011df <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801598:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801599:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8015a6:	8d 45 10             	lea    0x10(%ebp),%eax
  8015a9:	83 c0 04             	add    $0x4,%eax
  8015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b5:	50                   	push   %eax
  8015b6:	ff 75 0c             	pushl  0xc(%ebp)
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	e8 16 fc ff ff       	call   8011d7 <vprintfmt>
  8015c1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cd:	8b 40 08             	mov    0x8(%eax),%eax
  8015d0:	8d 50 01             	lea    0x1(%eax),%edx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	8b 10                	mov    (%eax),%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	8b 40 04             	mov    0x4(%eax),%eax
  8015e4:	39 c2                	cmp    %eax,%edx
  8015e6:	73 12                	jae    8015fa <sprintputch+0x33>
		*b->buf++ = ch;
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8015f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f3:	89 0a                	mov    %ecx,(%edx)
  8015f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f8:	88 10                	mov    %dl,(%eax)
}
  8015fa:	90                   	nop
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80161e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801622:	74 06                	je     80162a <vsnprintf+0x2d>
  801624:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801628:	7f 07                	jg     801631 <vsnprintf+0x34>
		return -E_INVAL;
  80162a:	b8 03 00 00 00       	mov    $0x3,%eax
  80162f:	eb 20                	jmp    801651 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801631:	ff 75 14             	pushl  0x14(%ebp)
  801634:	ff 75 10             	pushl  0x10(%ebp)
  801637:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80163a:	50                   	push   %eax
  80163b:	68 c7 15 80 00       	push   $0x8015c7
  801640:	e8 92 fb ff ff       	call   8011d7 <vprintfmt>
  801645:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801659:	8d 45 10             	lea    0x10(%ebp),%eax
  80165c:	83 c0 04             	add    $0x4,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	ff 75 f4             	pushl  -0xc(%ebp)
  801668:	50                   	push   %eax
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 89 ff ff ff       	call   8015fd <vsnprintf>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801685:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168c:	eb 06                	jmp    801694 <strlen+0x15>
		n++;
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801691:	ff 45 08             	incl   0x8(%ebp)
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8a 00                	mov    (%eax),%al
  801699:	84 c0                	test   %al,%al
  80169b:	75 f1                	jne    80168e <strlen+0xf>
		n++;
	return n;
  80169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016af:	eb 09                	jmp    8016ba <strnlen+0x18>
		n++;
  8016b1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	ff 4d 0c             	decl   0xc(%ebp)
  8016ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016be:	74 09                	je     8016c9 <strnlen+0x27>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	84 c0                	test   %al,%al
  8016c7:	75 e8                	jne    8016b1 <strnlen+0xf>
		n++;
	return n;
  8016c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016da:	90                   	nop
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8d 50 01             	lea    0x1(%eax),%edx
  8016e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016ed:	8a 12                	mov    (%edx),%dl
  8016ef:	88 10                	mov    %dl,(%eax)
  8016f1:	8a 00                	mov    (%eax),%al
  8016f3:	84 c0                	test   %al,%al
  8016f5:	75 e4                	jne    8016db <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801708:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80170f:	eb 1f                	jmp    801730 <strncpy+0x34>
		*dst++ = *src;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8d 50 01             	lea    0x1(%eax),%edx
  801717:	89 55 08             	mov    %edx,0x8(%ebp)
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8a 12                	mov    (%edx),%dl
  80171f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801721:	8b 45 0c             	mov    0xc(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	84 c0                	test   %al,%al
  801728:	74 03                	je     80172d <strncpy+0x31>
			src++;
  80172a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80172d:	ff 45 fc             	incl   -0x4(%ebp)
  801730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801733:	3b 45 10             	cmp    0x10(%ebp),%eax
  801736:	72 d9                	jb     801711 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801738:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 30                	je     80177f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80174f:	eb 16                	jmp    801767 <strlcpy+0x2a>
			*dst++ = *src++;
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8d 50 01             	lea    0x1(%eax),%edx
  801757:	89 55 08             	mov    %edx,0x8(%ebp)
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801760:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801763:	8a 12                	mov    (%edx),%dl
  801765:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801767:	ff 4d 10             	decl   0x10(%ebp)
  80176a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80176e:	74 09                	je     801779 <strlcpy+0x3c>
  801770:	8b 45 0c             	mov    0xc(%ebp),%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	84 c0                	test   %al,%al
  801777:	75 d8                	jne    801751 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80177f:	8b 55 08             	mov    0x8(%ebp),%edx
  801782:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801785:	29 c2                	sub    %eax,%edx
  801787:	89 d0                	mov    %edx,%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80178e:	eb 06                	jmp    801796 <strcmp+0xb>
		p++, q++;
  801790:	ff 45 08             	incl   0x8(%ebp)
  801793:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	84 c0                	test   %al,%al
  80179d:	74 0e                	je     8017ad <strcmp+0x22>
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 10                	mov    (%eax),%dl
  8017a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 e3                	je     801790 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	0f b6 d0             	movzbl %al,%edx
  8017b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	0f b6 c0             	movzbl %al,%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
}
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017c6:	eb 09                	jmp    8017d1 <strncmp+0xe>
		n--, p++, q++;
  8017c8:	ff 4d 10             	decl   0x10(%ebp)
  8017cb:	ff 45 08             	incl   0x8(%ebp)
  8017ce:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d5:	74 17                	je     8017ee <strncmp+0x2b>
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	84 c0                	test   %al,%al
  8017de:	74 0e                	je     8017ee <strncmp+0x2b>
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8a 10                	mov    (%eax),%dl
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	38 c2                	cmp    %al,%dl
  8017ec:	74 da                	je     8017c8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f2:	75 07                	jne    8017fb <strncmp+0x38>
		return 0;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb 14                	jmp    80180f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	0f b6 d0             	movzbl %al,%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	0f b6 c0             	movzbl %al,%eax
  80180b:	29 c2                	sub    %eax,%edx
  80180d:	89 d0                	mov    %edx,%eax
}
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80181d:	eb 12                	jmp    801831 <strchr+0x20>
		if (*s == c)
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801827:	75 05                	jne    80182e <strchr+0x1d>
			return (char *) s;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	eb 11                	jmp    80183f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80182e:	ff 45 08             	incl   0x8(%ebp)
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8a 00                	mov    (%eax),%al
  801836:	84 c0                	test   %al,%al
  801838:	75 e5                	jne    80181f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80184d:	eb 0d                	jmp    80185c <strfind+0x1b>
		if (*s == c)
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801857:	74 0e                	je     801867 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801859:	ff 45 08             	incl   0x8(%ebp)
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8a 00                	mov    (%eax),%al
  801861:	84 c0                	test   %al,%al
  801863:	75 ea                	jne    80184f <strfind+0xe>
  801865:	eb 01                	jmp    801868 <strfind+0x27>
		if (*s == c)
			break;
  801867:	90                   	nop
	return (char *) s;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80187f:	eb 0e                	jmp    80188f <memset+0x22>
		*p++ = c;
  801881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801884:	8d 50 01             	lea    0x1(%eax),%edx
  801887:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80188f:	ff 4d f8             	decl   -0x8(%ebp)
  801892:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801896:	79 e9                	jns    801881 <memset+0x14>
		*p++ = c;

	return v;
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8018af:	eb 16                	jmp    8018c7 <memcpy+0x2a>
		*d++ = *s++;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b4:	8d 50 01             	lea    0x1(%eax),%edx
  8018b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018c0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018c3:	8a 12                	mov    (%edx),%dl
  8018c5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	75 dd                	jne    8018b1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018f1:	73 50                	jae    801943 <memmove+0x6a>
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018fe:	76 43                	jbe    801943 <memmove+0x6a>
		s += n;
  801900:	8b 45 10             	mov    0x10(%ebp),%eax
  801903:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801906:	8b 45 10             	mov    0x10(%ebp),%eax
  801909:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80190c:	eb 10                	jmp    80191e <memmove+0x45>
			*--d = *--s;
  80190e:	ff 4d f8             	decl   -0x8(%ebp)
  801911:	ff 4d fc             	decl   -0x4(%ebp)
  801914:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801917:	8a 10                	mov    (%eax),%dl
  801919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80191e:	8b 45 10             	mov    0x10(%ebp),%eax
  801921:	8d 50 ff             	lea    -0x1(%eax),%edx
  801924:	89 55 10             	mov    %edx,0x10(%ebp)
  801927:	85 c0                	test   %eax,%eax
  801929:	75 e3                	jne    80190e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80192b:	eb 23                	jmp    801950 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80192d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801930:	8d 50 01             	lea    0x1(%eax),%edx
  801933:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801936:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801939:	8d 4a 01             	lea    0x1(%edx),%ecx
  80193c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80193f:	8a 12                	mov    (%edx),%dl
  801941:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	8d 50 ff             	lea    -0x1(%eax),%edx
  801949:	89 55 10             	mov    %edx,0x10(%ebp)
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 dd                	jne    80192d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801967:	eb 2a                	jmp    801993 <memcmp+0x3e>
		if (*s1 != *s2)
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196c:	8a 10                	mov    (%eax),%dl
  80196e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801971:	8a 00                	mov    (%eax),%al
  801973:	38 c2                	cmp    %al,%dl
  801975:	74 16                	je     80198d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197a:	8a 00                	mov    (%eax),%al
  80197c:	0f b6 d0             	movzbl %al,%edx
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	0f b6 c0             	movzbl %al,%eax
  801987:	29 c2                	sub    %eax,%edx
  801989:	89 d0                	mov    %edx,%eax
  80198b:	eb 18                	jmp    8019a5 <memcmp+0x50>
		s1++, s2++;
  80198d:	ff 45 fc             	incl   -0x4(%ebp)
  801990:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	8d 50 ff             	lea    -0x1(%eax),%edx
  801999:	89 55 10             	mov    %edx,0x10(%ebp)
  80199c:	85 c0                	test   %eax,%eax
  80199e:	75 c9                	jne    801969 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8019a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8019ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 d0                	add    %edx,%eax
  8019b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8019b8:	eb 15                	jmp    8019cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	0f b6 d0             	movzbl %al,%edx
  8019c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c5:	0f b6 c0             	movzbl %al,%eax
  8019c8:	39 c2                	cmp    %eax,%edx
  8019ca:	74 0d                	je     8019d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019cc:	ff 45 08             	incl   0x8(%ebp)
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019d5:	72 e3                	jb     8019ba <memfind+0x13>
  8019d7:	eb 01                	jmp    8019da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019d9:	90                   	nop
	return (void *) s;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019f3:	eb 03                	jmp    8019f8 <strtol+0x19>
		s++;
  8019f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8a 00                	mov    (%eax),%al
  8019fd:	3c 20                	cmp    $0x20,%al
  8019ff:	74 f4                	je     8019f5 <strtol+0x16>
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 09                	cmp    $0x9,%al
  801a08:	74 eb                	je     8019f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 2b                	cmp    $0x2b,%al
  801a11:	75 05                	jne    801a18 <strtol+0x39>
		s++;
  801a13:	ff 45 08             	incl   0x8(%ebp)
  801a16:	eb 13                	jmp    801a2b <strtol+0x4c>
	else if (*s == '-')
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	3c 2d                	cmp    $0x2d,%al
  801a1f:	75 0a                	jne    801a2b <strtol+0x4c>
		s++, neg = 1;
  801a21:	ff 45 08             	incl   0x8(%ebp)
  801a24:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2f:	74 06                	je     801a37 <strtol+0x58>
  801a31:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a35:	75 20                	jne    801a57 <strtol+0x78>
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	3c 30                	cmp    $0x30,%al
  801a3e:	75 17                	jne    801a57 <strtol+0x78>
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	40                   	inc    %eax
  801a44:	8a 00                	mov    (%eax),%al
  801a46:	3c 78                	cmp    $0x78,%al
  801a48:	75 0d                	jne    801a57 <strtol+0x78>
		s += 2, base = 16;
  801a4a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a4e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a55:	eb 28                	jmp    801a7f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5b:	75 15                	jne    801a72 <strtol+0x93>
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	8a 00                	mov    (%eax),%al
  801a62:	3c 30                	cmp    $0x30,%al
  801a64:	75 0c                	jne    801a72 <strtol+0x93>
		s++, base = 8;
  801a66:	ff 45 08             	incl   0x8(%ebp)
  801a69:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a70:	eb 0d                	jmp    801a7f <strtol+0xa0>
	else if (base == 0)
  801a72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a76:	75 07                	jne    801a7f <strtol+0xa0>
		base = 10;
  801a78:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	3c 2f                	cmp    $0x2f,%al
  801a86:	7e 19                	jle    801aa1 <strtol+0xc2>
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8a 00                	mov    (%eax),%al
  801a8d:	3c 39                	cmp    $0x39,%al
  801a8f:	7f 10                	jg     801aa1 <strtol+0xc2>
			dig = *s - '0';
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8a 00                	mov    (%eax),%al
  801a96:	0f be c0             	movsbl %al,%eax
  801a99:	83 e8 30             	sub    $0x30,%eax
  801a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a9f:	eb 42                	jmp    801ae3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	3c 60                	cmp    $0x60,%al
  801aa8:	7e 19                	jle    801ac3 <strtol+0xe4>
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	3c 7a                	cmp    $0x7a,%al
  801ab1:	7f 10                	jg     801ac3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	8a 00                	mov    (%eax),%al
  801ab8:	0f be c0             	movsbl %al,%eax
  801abb:	83 e8 57             	sub    $0x57,%eax
  801abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ac1:	eb 20                	jmp    801ae3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	3c 40                	cmp    $0x40,%al
  801aca:	7e 39                	jle    801b05 <strtol+0x126>
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	8a 00                	mov    (%eax),%al
  801ad1:	3c 5a                	cmp    $0x5a,%al
  801ad3:	7f 30                	jg     801b05 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	8a 00                	mov    (%eax),%al
  801ada:	0f be c0             	movsbl %al,%eax
  801add:	83 e8 37             	sub    $0x37,%eax
  801ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae6:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ae9:	7d 19                	jge    801b04 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aeb:	ff 45 08             	incl   0x8(%ebp)
  801aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af1:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af5:	89 c2                	mov    %eax,%edx
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801aff:	e9 7b ff ff ff       	jmp    801a7f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b04:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b09:	74 08                	je     801b13 <strtol+0x134>
		*endptr = (char *) s;
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b11:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b17:	74 07                	je     801b20 <strtol+0x141>
  801b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b1c:	f7 d8                	neg    %eax
  801b1e:	eb 03                	jmp    801b23 <strtol+0x144>
  801b20:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <ltostr>:

void
ltostr(long value, char *str)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3d:	79 13                	jns    801b52 <ltostr+0x2d>
	{
		neg = 1;
  801b3f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b49:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b4c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b4f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b5a:	99                   	cltd   
  801b5b:	f7 f9                	idiv   %ecx
  801b5d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b63:	8d 50 01             	lea    0x1(%eax),%edx
  801b66:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b69:	89 c2                	mov    %eax,%edx
  801b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6e:	01 d0                	add    %edx,%eax
  801b70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b73:	83 c2 30             	add    $0x30,%edx
  801b76:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b80:	f7 e9                	imul   %ecx
  801b82:	c1 fa 02             	sar    $0x2,%edx
  801b85:	89 c8                	mov    %ecx,%eax
  801b87:	c1 f8 1f             	sar    $0x1f,%eax
  801b8a:	29 c2                	sub    %eax,%edx
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b94:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b99:	f7 e9                	imul   %ecx
  801b9b:	c1 fa 02             	sar    $0x2,%edx
  801b9e:	89 c8                	mov    %ecx,%eax
  801ba0:	c1 f8 1f             	sar    $0x1f,%eax
  801ba3:	29 c2                	sub    %eax,%edx
  801ba5:	89 d0                	mov    %edx,%eax
  801ba7:	c1 e0 02             	shl    $0x2,%eax
  801baa:	01 d0                	add    %edx,%eax
  801bac:	01 c0                	add    %eax,%eax
  801bae:	29 c1                	sub    %eax,%ecx
  801bb0:	89 ca                	mov    %ecx,%edx
  801bb2:	85 d2                	test   %edx,%edx
  801bb4:	75 9c                	jne    801b52 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc0:	48                   	dec    %eax
  801bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc8:	74 3d                	je     801c07 <ltostr+0xe2>
		start = 1 ;
  801bca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bd1:	eb 34                	jmp    801c07 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 d0                	add    %edx,%eax
  801bdb:	8a 00                	mov    (%eax),%al
  801bdd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be6:	01 c2                	add    %eax,%edx
  801be8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bee:	01 c8                	add    %ecx,%eax
  801bf0:	8a 00                	mov    (%eax),%al
  801bf2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfa:	01 c2                	add    %eax,%edx
  801bfc:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bff:	88 02                	mov    %al,(%edx)
		start++ ;
  801c01:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c04:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c0d:	7c c4                	jl     801bd3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c0f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c15:	01 d0                	add    %edx,%eax
  801c17:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 54 fa ff ff       	call   80167f <strlen>
  801c2b:	83 c4 04             	add    $0x4,%esp
  801c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c31:	ff 75 0c             	pushl  0xc(%ebp)
  801c34:	e8 46 fa ff ff       	call   80167f <strlen>
  801c39:	83 c4 04             	add    $0x4,%esp
  801c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c4d:	eb 17                	jmp    801c66 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c52:	8b 45 10             	mov    0x10(%ebp),%eax
  801c55:	01 c2                	add    %eax,%edx
  801c57:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	01 c8                	add    %ecx,%eax
  801c5f:	8a 00                	mov    (%eax),%al
  801c61:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c63:	ff 45 fc             	incl   -0x4(%ebp)
  801c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c6c:	7c e1                	jl     801c4f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c6e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c7c:	eb 1f                	jmp    801c9d <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c81:	8d 50 01             	lea    0x1(%eax),%edx
  801c84:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8c:	01 c2                	add    %eax,%edx
  801c8e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c94:	01 c8                	add    %ecx,%eax
  801c96:	8a 00                	mov    (%eax),%al
  801c98:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c9a:	ff 45 f8             	incl   -0x8(%ebp)
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ca3:	7c d9                	jl     801c7e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ca5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	01 d0                	add    %edx,%eax
  801cad:	c6 00 00             	movb   $0x0,(%eax)
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc2:	8b 00                	mov    (%eax),%eax
  801cc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cd6:	eb 0c                	jmp    801ce4 <strsplit+0x31>
			*string++ = 0;
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8d 50 01             	lea    0x1(%eax),%edx
  801cde:	89 55 08             	mov    %edx,0x8(%ebp)
  801ce1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 18                	je     801d05 <strsplit+0x52>
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	8a 00                	mov    (%eax),%al
  801cf2:	0f be c0             	movsbl %al,%eax
  801cf5:	50                   	push   %eax
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	e8 13 fb ff ff       	call   801811 <strchr>
  801cfe:	83 c4 08             	add    $0x8,%esp
  801d01:	85 c0                	test   %eax,%eax
  801d03:	75 d3                	jne    801cd8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	84 c0                	test   %al,%al
  801d0c:	74 5a                	je     801d68 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d11:	8b 00                	mov    (%eax),%eax
  801d13:	83 f8 0f             	cmp    $0xf,%eax
  801d16:	75 07                	jne    801d1f <strsplit+0x6c>
		{
			return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	eb 66                	jmp    801d85 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d22:	8b 00                	mov    (%eax),%eax
  801d24:	8d 48 01             	lea    0x1(%eax),%ecx
  801d27:	8b 55 14             	mov    0x14(%ebp),%edx
  801d2a:	89 0a                	mov    %ecx,(%edx)
  801d2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d3d:	eb 03                	jmp    801d42 <strsplit+0x8f>
			string++;
  801d3f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	8a 00                	mov    (%eax),%al
  801d47:	84 c0                	test   %al,%al
  801d49:	74 8b                	je     801cd6 <strsplit+0x23>
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	0f be c0             	movsbl %al,%eax
  801d53:	50                   	push   %eax
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	e8 b5 fa ff ff       	call   801811 <strchr>
  801d5c:	83 c4 08             	add    $0x8,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	74 dc                	je     801d3f <strsplit+0x8c>
			string++;
	}
  801d63:	e9 6e ff ff ff       	jmp    801cd6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d68:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d80:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	68 30 2e 80 00       	push   $0x802e30
  801d95:	6a 0e                	push   $0xe
  801d97:	68 6a 2e 80 00       	push   $0x802e6a
  801d9c:	e8 a8 ef ff ff       	call   800d49 <_panic>

00801da1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801da7:	a1 04 30 80 00       	mov    0x803004,%eax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	74 0f                	je     801dbf <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801db0:	e8 d2 ff ff ff       	call   801d87 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801db5:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801dbc:	00 00 00 
	}
	if (size == 0) return NULL ;
  801dbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dc3:	75 07                	jne    801dcc <malloc+0x2b>
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	eb 14                	jmp    801de0 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	68 78 2e 80 00       	push   $0x802e78
  801dd4:	6a 2e                	push   $0x2e
  801dd6:	68 6a 2e 80 00       	push   $0x802e6a
  801ddb:	e8 69 ef ff ff       	call   800d49 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 a0 2e 80 00       	push   $0x802ea0
  801df0:	6a 49                	push   $0x49
  801df2:	68 6a 2e 80 00       	push   $0x802e6a
  801df7:	e8 4d ef ff ff       	call   800d49 <_panic>

00801dfc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	68 c4 2e 80 00       	push   $0x802ec4
  801e10:	6a 57                	push   $0x57
  801e12:	68 6a 2e 80 00       	push   $0x802e6a
  801e17:	e8 2d ef ff ff       	call   800d49 <_panic>

00801e1c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	68 ec 2e 80 00       	push   $0x802eec
  801e2a:	6a 60                	push   $0x60
  801e2c:	68 6a 2e 80 00       	push   $0x802e6a
  801e31:	e8 13 ef ff ff       	call   800d49 <_panic>

00801e36 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	68 10 2f 80 00       	push   $0x802f10
  801e44:	6a 7c                	push   $0x7c
  801e46:	68 6a 2e 80 00       	push   $0x802e6a
  801e4b:	e8 f9 ee ff ff       	call   800d49 <_panic>

00801e50 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	68 38 2f 80 00       	push   $0x802f38
  801e5e:	68 86 00 00 00       	push   $0x86
  801e63:	68 6a 2e 80 00       	push   $0x802e6a
  801e68:	e8 dc ee ff ff       	call   800d49 <_panic>

00801e6d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 5c 2f 80 00       	push   $0x802f5c
  801e7b:	68 91 00 00 00       	push   $0x91
  801e80:	68 6a 2e 80 00       	push   $0x802e6a
  801e85:	e8 bf ee ff ff       	call   800d49 <_panic>

00801e8a <shrink>:

}
void shrink(uint32 newSize)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 5c 2f 80 00       	push   $0x802f5c
  801e98:	68 96 00 00 00       	push   $0x96
  801e9d:	68 6a 2e 80 00       	push   $0x802e6a
  801ea2:	e8 a2 ee ff ff       	call   800d49 <_panic>

00801ea7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	68 5c 2f 80 00       	push   $0x802f5c
  801eb5:	68 9b 00 00 00       	push   $0x9b
  801eba:	68 6a 2e 80 00       	push   $0x802e6a
  801ebf:	e8 85 ee ff ff       	call   800d49 <_panic>

00801ec4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	57                   	push   %edi
  801ec8:	56                   	push   %esi
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801edc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801edf:	cd 30                	int    $0x30
  801ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	5b                   	pop    %ebx
  801eeb:	5e                   	pop    %esi
  801eec:	5f                   	pop    %edi
  801eed:	5d                   	pop    %ebp
  801eee:	c3                   	ret    

00801eef <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801efb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	52                   	push   %edx
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	50                   	push   %eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	e8 b2 ff ff ff       	call   801ec4 <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	90                   	nop
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 01                	push   $0x1
  801f27:	e8 98 ff ff ff       	call   801ec4 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 05                	push   $0x5
  801f44:	e8 7b ff ff ff       	call   801ec4 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f53:	8b 75 18             	mov    0x18(%ebp),%esi
  801f56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	51                   	push   %ecx
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	6a 06                	push   $0x6
  801f69:	e8 56 ff ff ff       	call   801ec4 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f74:	5b                   	pop    %ebx
  801f75:	5e                   	pop    %esi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    

00801f78 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	6a 07                	push   $0x7
  801f8b:	e8 34 ff ff ff       	call   801ec4 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 08                	push   $0x8
  801fa6:	e8 19 ff ff ff       	call   801ec4 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 09                	push   $0x9
  801fbf:	e8 00 ff ff ff       	call   801ec4 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 0a                	push   $0xa
  801fd8:	e8 e7 fe ff ff       	call   801ec4 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 0b                	push   $0xb
  801ff1:	e8 ce fe ff ff       	call   801ec4 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	6a 0f                	push   $0xf
  80200c:	e8 b3 fe ff ff       	call   801ec4 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
	return;
  802014:	90                   	nop
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 0c             	pushl  0xc(%ebp)
  802023:	ff 75 08             	pushl  0x8(%ebp)
  802026:	6a 10                	push   $0x10
  802028:	e8 97 fe ff ff       	call   801ec4 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
	return ;
  802030:	90                   	nop
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 10             	pushl  0x10(%ebp)
  80203d:	ff 75 0c             	pushl  0xc(%ebp)
  802040:	ff 75 08             	pushl  0x8(%ebp)
  802043:	6a 11                	push   $0x11
  802045:	e8 7a fe ff ff       	call   801ec4 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
	return ;
  80204d:	90                   	nop
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 0c                	push   $0xc
  80205f:	e8 60 fe ff ff       	call   801ec4 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	6a 0d                	push   $0xd
  802079:	e8 46 fe ff ff       	call   801ec4 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 0e                	push   $0xe
  802092:	e8 2d fe ff ff       	call   801ec4 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	90                   	nop
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 13                	push   $0x13
  8020ac:	e8 13 fe ff ff       	call   801ec4 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	90                   	nop
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 14                	push   $0x14
  8020c6:	e8 f9 fd ff ff       	call   801ec4 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020dd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	50                   	push   %eax
  8020ea:	6a 15                	push   $0x15
  8020ec:	e8 d3 fd ff ff       	call   801ec4 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	90                   	nop
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 16                	push   $0x16
  802106:	e8 b9 fd ff ff       	call   801ec4 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	90                   	nop
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	50                   	push   %eax
  802121:	6a 17                	push   $0x17
  802123:	e8 9c fd ff ff       	call   801ec4 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	52                   	push   %edx
  80213d:	50                   	push   %eax
  80213e:	6a 1a                	push   $0x1a
  802140:	e8 7f fd ff ff       	call   801ec4 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80214d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	52                   	push   %edx
  80215a:	50                   	push   %eax
  80215b:	6a 18                	push   $0x18
  80215d:	e8 62 fd ff ff       	call   801ec4 <syscall>
  802162:	83 c4 18             	add    $0x18,%esp
}
  802165:	90                   	nop
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	52                   	push   %edx
  802178:	50                   	push   %eax
  802179:	6a 19                	push   $0x19
  80217b:	e8 44 fd ff ff       	call   801ec4 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	90                   	nop
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	8b 45 10             	mov    0x10(%ebp),%eax
  80218f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802192:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802195:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	51                   	push   %ecx
  80219f:	52                   	push   %edx
  8021a0:	ff 75 0c             	pushl  0xc(%ebp)
  8021a3:	50                   	push   %eax
  8021a4:	6a 1b                	push   $0x1b
  8021a6:	e8 19 fd ff ff       	call   801ec4 <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	6a 1c                	push   $0x1c
  8021c3:	e8 fc fc ff ff       	call   801ec4 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	51                   	push   %ecx
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	6a 1d                	push   $0x1d
  8021e2:	e8 dd fc ff ff       	call   801ec4 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	52                   	push   %edx
  8021fc:	50                   	push   %eax
  8021fd:	6a 1e                	push   $0x1e
  8021ff:	e8 c0 fc ff ff       	call   801ec4 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 1f                	push   $0x1f
  802218:	e8 a7 fc ff ff       	call   801ec4 <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	ff 75 14             	pushl  0x14(%ebp)
  80222d:	ff 75 10             	pushl  0x10(%ebp)
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	50                   	push   %eax
  802234:	6a 20                	push   $0x20
  802236:	e8 89 fc ff ff       	call   801ec4 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	50                   	push   %eax
  80224f:	6a 21                	push   $0x21
  802251:	e8 6e fc ff ff       	call   801ec4 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	90                   	nop
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	50                   	push   %eax
  80226b:	6a 22                	push   $0x22
  80226d:	e8 52 fc ff ff       	call   801ec4 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 02                	push   $0x2
  802286:	e8 39 fc ff ff       	call   801ec4 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 03                	push   $0x3
  80229f:	e8 20 fc ff ff       	call   801ec4 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 04                	push   $0x4
  8022b8:	e8 07 fc ff ff       	call   801ec4 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_exit_env>:


void sys_exit_env(void)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 23                	push   $0x23
  8022d1:	e8 ee fb ff ff       	call   801ec4 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
}
  8022d9:	90                   	nop
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e5:	8d 50 04             	lea    0x4(%eax),%edx
  8022e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	52                   	push   %edx
  8022f2:	50                   	push   %eax
  8022f3:	6a 24                	push   $0x24
  8022f5:	e8 ca fb ff ff       	call   801ec4 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
	return result;
  8022fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802306:	89 01                	mov    %eax,(%ecx)
  802308:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	c9                   	leave  
  80230f:	c2 04 00             	ret    $0x4

00802312 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	ff 75 10             	pushl  0x10(%ebp)
  80231c:	ff 75 0c             	pushl  0xc(%ebp)
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	6a 12                	push   $0x12
  802324:	e8 9b fb ff ff       	call   801ec4 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
	return ;
  80232c:	90                   	nop
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_rcr2>:
uint32 sys_rcr2()
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 25                	push   $0x25
  80233e:	e8 81 fb ff ff       	call   801ec4 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802354:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	50                   	push   %eax
  802361:	6a 26                	push   $0x26
  802363:	e8 5c fb ff ff       	call   801ec4 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
	return ;
  80236b:	90                   	nop
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <rsttst>:
void rsttst()
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 28                	push   $0x28
  80237d:	e8 42 fb ff ff       	call   801ec4 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
	return ;
  802385:	90                   	nop
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	8b 45 14             	mov    0x14(%ebp),%eax
  802391:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802394:	8b 55 18             	mov    0x18(%ebp),%edx
  802397:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80239b:	52                   	push   %edx
  80239c:	50                   	push   %eax
  80239d:	ff 75 10             	pushl  0x10(%ebp)
  8023a0:	ff 75 0c             	pushl  0xc(%ebp)
  8023a3:	ff 75 08             	pushl  0x8(%ebp)
  8023a6:	6a 27                	push   $0x27
  8023a8:	e8 17 fb ff ff       	call   801ec4 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b0:	90                   	nop
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <chktst>:
void chktst(uint32 n)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	ff 75 08             	pushl  0x8(%ebp)
  8023c1:	6a 29                	push   $0x29
  8023c3:	e8 fc fa ff ff       	call   801ec4 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cb:	90                   	nop
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <inctst>:

void inctst()
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 2a                	push   $0x2a
  8023dd:	e8 e2 fa ff ff       	call   801ec4 <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e5:	90                   	nop
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <gettst>:
uint32 gettst()
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 2b                	push   $0x2b
  8023f7:	e8 c8 fa ff ff       	call   801ec4 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 2c                	push   $0x2c
  802413:	e8 ac fa ff ff       	call   801ec4 <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
  80241b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80241e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802422:	75 07                	jne    80242b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802424:	b8 01 00 00 00       	mov    $0x1,%eax
  802429:	eb 05                	jmp    802430 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 2c                	push   $0x2c
  802444:	e8 7b fa ff ff       	call   801ec4 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
  80244c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80244f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802453:	75 07                	jne    80245c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802455:	b8 01 00 00 00       	mov    $0x1,%eax
  80245a:	eb 05                	jmp    802461 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 2c                	push   $0x2c
  802475:	e8 4a fa ff ff       	call   801ec4 <syscall>
  80247a:	83 c4 18             	add    $0x18,%esp
  80247d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802480:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802484:	75 07                	jne    80248d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802486:	b8 01 00 00 00       	mov    $0x1,%eax
  80248b:	eb 05                	jmp    802492 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 2c                	push   $0x2c
  8024a6:	e8 19 fa ff ff       	call   801ec4 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
  8024ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024b5:	75 07                	jne    8024be <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bc:	eb 05                	jmp    8024c3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	ff 75 08             	pushl  0x8(%ebp)
  8024d3:	6a 2d                	push   $0x2d
  8024d5:	e8 ea f9 ff ff       	call   801ec4 <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dd:	90                   	nop
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	6a 00                	push   $0x0
  8024f2:	53                   	push   %ebx
  8024f3:	51                   	push   %ecx
  8024f4:	52                   	push   %edx
  8024f5:	50                   	push   %eax
  8024f6:	6a 2e                	push   $0x2e
  8024f8:	e8 c7 f9 ff ff       	call   801ec4 <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
}
  802500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	52                   	push   %edx
  802515:	50                   	push   %eax
  802516:	6a 2f                	push   $0x2f
  802518:	e8 a7 f9 ff ff       	call   801ec4 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    
  802522:	66 90                	xchg   %ax,%ax

00802524 <__udivdi3>:
  802524:	55                   	push   %ebp
  802525:	57                   	push   %edi
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
  80252b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80252f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802537:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80253b:	89 ca                	mov    %ecx,%edx
  80253d:	89 f8                	mov    %edi,%eax
  80253f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802543:	85 f6                	test   %esi,%esi
  802545:	75 2d                	jne    802574 <__udivdi3+0x50>
  802547:	39 cf                	cmp    %ecx,%edi
  802549:	77 65                	ja     8025b0 <__udivdi3+0x8c>
  80254b:	89 fd                	mov    %edi,%ebp
  80254d:	85 ff                	test   %edi,%edi
  80254f:	75 0b                	jne    80255c <__udivdi3+0x38>
  802551:	b8 01 00 00 00       	mov    $0x1,%eax
  802556:	31 d2                	xor    %edx,%edx
  802558:	f7 f7                	div    %edi
  80255a:	89 c5                	mov    %eax,%ebp
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	89 c8                	mov    %ecx,%eax
  802560:	f7 f5                	div    %ebp
  802562:	89 c1                	mov    %eax,%ecx
  802564:	89 d8                	mov    %ebx,%eax
  802566:	f7 f5                	div    %ebp
  802568:	89 cf                	mov    %ecx,%edi
  80256a:	89 fa                	mov    %edi,%edx
  80256c:	83 c4 1c             	add    $0x1c,%esp
  80256f:	5b                   	pop    %ebx
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	39 ce                	cmp    %ecx,%esi
  802576:	77 28                	ja     8025a0 <__udivdi3+0x7c>
  802578:	0f bd fe             	bsr    %esi,%edi
  80257b:	83 f7 1f             	xor    $0x1f,%edi
  80257e:	75 40                	jne    8025c0 <__udivdi3+0x9c>
  802580:	39 ce                	cmp    %ecx,%esi
  802582:	72 0a                	jb     80258e <__udivdi3+0x6a>
  802584:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802588:	0f 87 9e 00 00 00    	ja     80262c <__udivdi3+0x108>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	89 fa                	mov    %edi,%edx
  802595:	83 c4 1c             	add    $0x1c,%esp
  802598:	5b                   	pop    %ebx
  802599:	5e                   	pop    %esi
  80259a:	5f                   	pop    %edi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	31 ff                	xor    %edi,%edi
  8025a2:	31 c0                	xor    %eax,%eax
  8025a4:	89 fa                	mov    %edi,%edx
  8025a6:	83 c4 1c             	add    $0x1c,%esp
  8025a9:	5b                   	pop    %ebx
  8025aa:	5e                   	pop    %esi
  8025ab:	5f                   	pop    %edi
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	89 d8                	mov    %ebx,%eax
  8025b2:	f7 f7                	div    %edi
  8025b4:	31 ff                	xor    %edi,%edi
  8025b6:	89 fa                	mov    %edi,%edx
  8025b8:	83 c4 1c             	add    $0x1c,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025c5:	89 eb                	mov    %ebp,%ebx
  8025c7:	29 fb                	sub    %edi,%ebx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	d3 e6                	shl    %cl,%esi
  8025cd:	89 c5                	mov    %eax,%ebp
  8025cf:	88 d9                	mov    %bl,%cl
  8025d1:	d3 ed                	shr    %cl,%ebp
  8025d3:	89 e9                	mov    %ebp,%ecx
  8025d5:	09 f1                	or     %esi,%ecx
  8025d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025db:	89 f9                	mov    %edi,%ecx
  8025dd:	d3 e0                	shl    %cl,%eax
  8025df:	89 c5                	mov    %eax,%ebp
  8025e1:	89 d6                	mov    %edx,%esi
  8025e3:	88 d9                	mov    %bl,%cl
  8025e5:	d3 ee                	shr    %cl,%esi
  8025e7:	89 f9                	mov    %edi,%ecx
  8025e9:	d3 e2                	shl    %cl,%edx
  8025eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025ef:	88 d9                	mov    %bl,%cl
  8025f1:	d3 e8                	shr    %cl,%eax
  8025f3:	09 c2                	or     %eax,%edx
  8025f5:	89 d0                	mov    %edx,%eax
  8025f7:	89 f2                	mov    %esi,%edx
  8025f9:	f7 74 24 0c          	divl   0xc(%esp)
  8025fd:	89 d6                	mov    %edx,%esi
  8025ff:	89 c3                	mov    %eax,%ebx
  802601:	f7 e5                	mul    %ebp
  802603:	39 d6                	cmp    %edx,%esi
  802605:	72 19                	jb     802620 <__udivdi3+0xfc>
  802607:	74 0b                	je     802614 <__udivdi3+0xf0>
  802609:	89 d8                	mov    %ebx,%eax
  80260b:	31 ff                	xor    %edi,%edi
  80260d:	e9 58 ff ff ff       	jmp    80256a <__udivdi3+0x46>
  802612:	66 90                	xchg   %ax,%ax
  802614:	8b 54 24 08          	mov    0x8(%esp),%edx
  802618:	89 f9                	mov    %edi,%ecx
  80261a:	d3 e2                	shl    %cl,%edx
  80261c:	39 c2                	cmp    %eax,%edx
  80261e:	73 e9                	jae    802609 <__udivdi3+0xe5>
  802620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802623:	31 ff                	xor    %edi,%edi
  802625:	e9 40 ff ff ff       	jmp    80256a <__udivdi3+0x46>
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	31 c0                	xor    %eax,%eax
  80262e:	e9 37 ff ff ff       	jmp    80256a <__udivdi3+0x46>
  802633:	90                   	nop

00802634 <__umoddi3>:
  802634:	55                   	push   %ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	83 ec 1c             	sub    $0x1c,%esp
  80263b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80263f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80264b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80264f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802653:	89 f3                	mov    %esi,%ebx
  802655:	89 fa                	mov    %edi,%edx
  802657:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80265b:	89 34 24             	mov    %esi,(%esp)
  80265e:	85 c0                	test   %eax,%eax
  802660:	75 1a                	jne    80267c <__umoddi3+0x48>
  802662:	39 f7                	cmp    %esi,%edi
  802664:	0f 86 a2 00 00 00    	jbe    80270c <__umoddi3+0xd8>
  80266a:	89 c8                	mov    %ecx,%eax
  80266c:	89 f2                	mov    %esi,%edx
  80266e:	f7 f7                	div    %edi
  802670:	89 d0                	mov    %edx,%eax
  802672:	31 d2                	xor    %edx,%edx
  802674:	83 c4 1c             	add    $0x1c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    
  80267c:	39 f0                	cmp    %esi,%eax
  80267e:	0f 87 ac 00 00 00    	ja     802730 <__umoddi3+0xfc>
  802684:	0f bd e8             	bsr    %eax,%ebp
  802687:	83 f5 1f             	xor    $0x1f,%ebp
  80268a:	0f 84 ac 00 00 00    	je     80273c <__umoddi3+0x108>
  802690:	bf 20 00 00 00       	mov    $0x20,%edi
  802695:	29 ef                	sub    %ebp,%edi
  802697:	89 fe                	mov    %edi,%esi
  802699:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80269d:	89 e9                	mov    %ebp,%ecx
  80269f:	d3 e0                	shl    %cl,%eax
  8026a1:	89 d7                	mov    %edx,%edi
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	d3 ef                	shr    %cl,%edi
  8026a7:	09 c7                	or     %eax,%edi
  8026a9:	89 e9                	mov    %ebp,%ecx
  8026ab:	d3 e2                	shl    %cl,%edx
  8026ad:	89 14 24             	mov    %edx,(%esp)
  8026b0:	89 d8                	mov    %ebx,%eax
  8026b2:	d3 e0                	shl    %cl,%eax
  8026b4:	89 c2                	mov    %eax,%edx
  8026b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026ba:	d3 e0                	shl    %cl,%eax
  8026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026c4:	89 f1                	mov    %esi,%ecx
  8026c6:	d3 e8                	shr    %cl,%eax
  8026c8:	09 d0                	or     %edx,%eax
  8026ca:	d3 eb                	shr    %cl,%ebx
  8026cc:	89 da                	mov    %ebx,%edx
  8026ce:	f7 f7                	div    %edi
  8026d0:	89 d3                	mov    %edx,%ebx
  8026d2:	f7 24 24             	mull   (%esp)
  8026d5:	89 c6                	mov    %eax,%esi
  8026d7:	89 d1                	mov    %edx,%ecx
  8026d9:	39 d3                	cmp    %edx,%ebx
  8026db:	0f 82 87 00 00 00    	jb     802768 <__umoddi3+0x134>
  8026e1:	0f 84 91 00 00 00    	je     802778 <__umoddi3+0x144>
  8026e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026eb:	29 f2                	sub    %esi,%edx
  8026ed:	19 cb                	sbb    %ecx,%ebx
  8026ef:	89 d8                	mov    %ebx,%eax
  8026f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026f5:	d3 e0                	shl    %cl,%eax
  8026f7:	89 e9                	mov    %ebp,%ecx
  8026f9:	d3 ea                	shr    %cl,%edx
  8026fb:	09 d0                	or     %edx,%eax
  8026fd:	89 e9                	mov    %ebp,%ecx
  8026ff:	d3 eb                	shr    %cl,%ebx
  802701:	89 da                	mov    %ebx,%edx
  802703:	83 c4 1c             	add    $0x1c,%esp
  802706:	5b                   	pop    %ebx
  802707:	5e                   	pop    %esi
  802708:	5f                   	pop    %edi
  802709:	5d                   	pop    %ebp
  80270a:	c3                   	ret    
  80270b:	90                   	nop
  80270c:	89 fd                	mov    %edi,%ebp
  80270e:	85 ff                	test   %edi,%edi
  802710:	75 0b                	jne    80271d <__umoddi3+0xe9>
  802712:	b8 01 00 00 00       	mov    $0x1,%eax
  802717:	31 d2                	xor    %edx,%edx
  802719:	f7 f7                	div    %edi
  80271b:	89 c5                	mov    %eax,%ebp
  80271d:	89 f0                	mov    %esi,%eax
  80271f:	31 d2                	xor    %edx,%edx
  802721:	f7 f5                	div    %ebp
  802723:	89 c8                	mov    %ecx,%eax
  802725:	f7 f5                	div    %ebp
  802727:	89 d0                	mov    %edx,%eax
  802729:	e9 44 ff ff ff       	jmp    802672 <__umoddi3+0x3e>
  80272e:	66 90                	xchg   %ax,%ax
  802730:	89 c8                	mov    %ecx,%eax
  802732:	89 f2                	mov    %esi,%edx
  802734:	83 c4 1c             	add    $0x1c,%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    
  80273c:	3b 04 24             	cmp    (%esp),%eax
  80273f:	72 06                	jb     802747 <__umoddi3+0x113>
  802741:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802745:	77 0f                	ja     802756 <__umoddi3+0x122>
  802747:	89 f2                	mov    %esi,%edx
  802749:	29 f9                	sub    %edi,%ecx
  80274b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80274f:	89 14 24             	mov    %edx,(%esp)
  802752:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802756:	8b 44 24 04          	mov    0x4(%esp),%eax
  80275a:	8b 14 24             	mov    (%esp),%edx
  80275d:	83 c4 1c             	add    $0x1c,%esp
  802760:	5b                   	pop    %ebx
  802761:	5e                   	pop    %esi
  802762:	5f                   	pop    %edi
  802763:	5d                   	pop    %ebp
  802764:	c3                   	ret    
  802765:	8d 76 00             	lea    0x0(%esi),%esi
  802768:	2b 04 24             	sub    (%esp),%eax
  80276b:	19 fa                	sbb    %edi,%edx
  80276d:	89 d1                	mov    %edx,%ecx
  80276f:	89 c6                	mov    %eax,%esi
  802771:	e9 71 ff ff ff       	jmp    8026e7 <__umoddi3+0xb3>
  802776:	66 90                	xchg   %ax,%ax
  802778:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80277c:	72 ea                	jb     802768 <__umoddi3+0x134>
  80277e:	89 d9                	mov    %ebx,%ecx
  802780:	e9 62 ff ff ff       	jmp    8026e7 <__umoddi3+0xb3>
