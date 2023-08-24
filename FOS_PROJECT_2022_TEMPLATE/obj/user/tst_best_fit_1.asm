
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 89 23 00 00       	call   8023d3 <sys_set_uheap_strategy>
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
  80009b:	68 a0 26 80 00       	push   $0x8026a0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 bc 26 80 00       	push   $0x8026bc
  8000a7:	e8 ab 0b 00 00       	call   800c57 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 f9 1b 00 00       	call   801caf <malloc>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 e1 1d 00 00       	call   801ebe <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 79 1e 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 b2 1b 00 00       	call   801caf <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 d4 26 80 00       	push   $0x8026d4
  800115:	6a 26                	push   $0x26
  800117:	68 bc 26 80 00       	push   $0x8026bc
  80011c:	e8 36 0b 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 38 1e 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 04 27 80 00       	push   $0x802704
  800138:	6a 28                	push   $0x28
  80013a:	68 bc 26 80 00       	push   $0x8026bc
  80013f:	e8 13 0b 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 72 1d 00 00       	call   801ebe <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 21 27 80 00       	push   $0x802721
  80015d:	6a 29                	push   $0x29
  80015f:	68 bc 26 80 00       	push   $0x8026bc
  800164:	e8 ee 0a 00 00       	call   800c57 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 50 1d 00 00       	call   801ebe <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 e8 1d 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 21 1b 00 00       	call   801caf <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 d4 26 80 00       	push   $0x8026d4
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 bc 26 80 00       	push   $0x8026bc
  8001ba:	e8 98 0a 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 9a 1d 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 04 27 80 00       	push   $0x802704
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 bc 26 80 00       	push   $0x8026bc
  8001dd:	e8 75 0a 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 d4 1c 00 00       	call   801ebe <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 21 27 80 00       	push   $0x802721
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 bc 26 80 00       	push   $0x8026bc
  800202:	e8 50 0a 00 00       	call   800c57 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 b2 1c 00 00       	call   801ebe <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 4a 1d 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 87 1a 00 00       	call   801caf <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 d4 26 80 00       	push   $0x8026d4
  80024f:	6a 38                	push   $0x38
  800251:	68 bc 26 80 00       	push   $0x8026bc
  800256:	e8 fc 09 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 fe 1c 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 04 27 80 00       	push   $0x802704
  800272:	6a 3a                	push   $0x3a
  800274:	68 bc 26 80 00       	push   $0x8026bc
  800279:	e8 d9 09 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 3b 1c 00 00       	call   801ebe <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 21 27 80 00       	push   $0x802721
  800294:	6a 3b                	push   $0x3b
  800296:	68 bc 26 80 00       	push   $0x8026bc
  80029b:	e8 b7 09 00 00       	call   800c57 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 19 1c 00 00       	call   801ebe <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 b1 1c 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 ee 19 00 00       	call   801caf <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 d4 26 80 00       	push   $0x8026d4
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 bc 26 80 00       	push   $0x8026bc
  8002ea:	e8 68 09 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 6a 1c 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 04 27 80 00       	push   $0x802704
  800306:	6a 43                	push   $0x43
  800308:	68 bc 26 80 00       	push   $0x8026bc
  80030d:	e8 45 09 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 a4 1b 00 00       	call   801ebe <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 21 27 80 00       	push   $0x802721
  80032b:	6a 44                	push   $0x44
  80032d:	68 bc 26 80 00       	push   $0x8026bc
  800332:	e8 20 09 00 00       	call   800c57 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 82 1b 00 00       	call   801ebe <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 1a 1c 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 59 19 00 00       	call   801caf <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 d4 26 80 00       	push   $0x8026d4
  80037e:	6a 4a                	push   $0x4a
  800380:	68 bc 26 80 00       	push   $0x8026bc
  800385:	e8 cd 08 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 cf 1b 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 04 27 80 00       	push   $0x802704
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 bc 26 80 00       	push   $0x8026bc
  8003a8:	e8 aa 08 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 0c 1b 00 00       	call   801ebe <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 21 27 80 00       	push   $0x802721
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 bc 26 80 00       	push   $0x8026bc
  8003ca:	e8 88 08 00 00       	call   800c57 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 ea 1a 00 00       	call   801ebe <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 82 1b 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 c1 18 00 00       	call   801caf <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 d4 26 80 00       	push   $0x8026d4
  800418:	6a 53                	push   $0x53
  80041a:	68 bc 26 80 00       	push   $0x8026bc
  80041f:	e8 33 08 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 35 1b 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 04 27 80 00       	push   $0x802704
  80043b:	6a 55                	push   $0x55
  80043d:	68 bc 26 80 00       	push   $0x8026bc
  800442:	e8 10 08 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 72 1a 00 00       	call   801ebe <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 21 27 80 00       	push   $0x802721
  80045d:	6a 56                	push   $0x56
  80045f:	68 bc 26 80 00       	push   $0x8026bc
  800464:	e8 ee 07 00 00       	call   800c57 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 50 1a 00 00       	call   801ebe <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 e8 1a 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 27 18 00 00       	call   801caf <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 d4 26 80 00       	push   $0x8026d4
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 bc 26 80 00       	push   $0x8026bc
  8004b7:	e8 9b 07 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 9d 1a 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 04 27 80 00       	push   $0x802704
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 bc 26 80 00       	push   $0x8026bc
  8004da:	e8 78 07 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 d7 19 00 00       	call   801ebe <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 21 27 80 00       	push   $0x802721
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 bc 26 80 00       	push   $0x8026bc
  8004ff:	e8 53 07 00 00       	call   800c57 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 b5 19 00 00       	call   801ebe <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 4d 1a 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 8c 17 00 00       	call   801caf <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 d4 26 80 00       	push   $0x8026d4
  80054d:	6a 65                	push   $0x65
  80054f:	68 bc 26 80 00       	push   $0x8026bc
  800554:	e8 fe 06 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 00 1a 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 04 27 80 00       	push   $0x802704
  800570:	6a 67                	push   $0x67
  800572:	68 bc 26 80 00       	push   $0x8026bc
  800577:	e8 db 06 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 3d 19 00 00       	call   801ebe <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 21 27 80 00       	push   $0x802721
  800592:	6a 68                	push   $0x68
  800594:	68 bc 26 80 00       	push   $0x8026bc
  800599:	e8 b9 06 00 00       	call   800c57 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 1b 19 00 00       	call   801ebe <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 b3 19 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 36 17 00 00       	call   801cf0 <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 9c 19 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 34 27 80 00       	push   $0x802734
  8005d8:	6a 72                	push   $0x72
  8005da:	68 bc 26 80 00       	push   $0x8026bc
  8005df:	e8 73 06 00 00       	call   800c57 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 d5 18 00 00       	call   801ebe <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 4b 27 80 00       	push   $0x80274b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 bc 26 80 00       	push   $0x8026bc
  800601:	e8 51 06 00 00       	call   800c57 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 b3 18 00 00       	call   801ebe <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 4b 19 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 ce 16 00 00       	call   801cf0 <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 34 19 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 34 27 80 00       	push   $0x802734
  800640:	6a 7a                	push   $0x7a
  800642:	68 bc 26 80 00       	push   $0x8026bc
  800647:	e8 0b 06 00 00       	call   800c57 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 6d 18 00 00       	call   801ebe <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 4b 27 80 00       	push   $0x80274b
  800662:	6a 7b                	push   $0x7b
  800664:	68 bc 26 80 00       	push   $0x8026bc
  800669:	e8 e9 05 00 00       	call   800c57 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 4b 18 00 00       	call   801ebe <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 e3 18 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 66 16 00 00       	call   801cf0 <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 cc 18 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 34 27 80 00       	push   $0x802734
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 bc 26 80 00       	push   $0x8026bc
  8006b2:	e8 a0 05 00 00       	call   800c57 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 02 18 00 00       	call   801ebe <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 4b 27 80 00       	push   $0x80274b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 bc 26 80 00       	push   $0x8026bc
  8006d7:	e8 7b 05 00 00       	call   800c57 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 dd 17 00 00       	call   801ebe <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 75 18 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 b4 15 00 00       	call   801caf <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 d4 26 80 00       	push   $0x8026d4
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 bc 26 80 00       	push   $0x8026bc
  80072f:	e8 23 05 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 25 18 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 04 27 80 00       	push   $0x802704
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 bc 26 80 00       	push   $0x8026bc
  800755:	e8 fd 04 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 5f 17 00 00       	call   801ebe <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 21 27 80 00       	push   $0x802721
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 bc 26 80 00       	push   $0x8026bc
  80077a:	e8 d8 04 00 00       	call   800c57 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 3a 17 00 00       	call   801ebe <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 d2 17 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 11 15 00 00       	call   801caf <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 d4 26 80 00       	push   $0x8026d4
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 bc 26 80 00       	push   $0x8026bc
  8007ca:	e8 88 04 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 8a 17 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 04 27 80 00       	push   $0x802704
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 bc 26 80 00       	push   $0x8026bc
  8007f0:	e8 62 04 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 c4 16 00 00       	call   801ebe <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 21 27 80 00       	push   $0x802721
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 bc 26 80 00       	push   $0x8026bc
  800815:	e8 3d 04 00 00       	call   800c57 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 9f 16 00 00       	call   801ebe <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 37 17 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 72 14 00 00       	call   801caf <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 d4 26 80 00       	push   $0x8026d4
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 bc 26 80 00       	push   $0x8026bc
  80087b:	e8 d7 03 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 d9 16 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 04 27 80 00       	push   $0x802704
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 bc 26 80 00       	push   $0x8026bc
  80089f:	e8 b3 03 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 15 16 00 00       	call   801ebe <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 21 27 80 00       	push   $0x802721
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 bc 26 80 00       	push   $0x8026bc
  8008c4:	e8 8e 03 00 00       	call   800c57 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 f0 15 00 00       	call   801ebe <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 88 16 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 c4 13 00 00       	call   801caf <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 d4 26 80 00       	push   $0x8026d4
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 bc 26 80 00       	push   $0x8026bc
  800920:	e8 32 03 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 34 16 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 04 27 80 00       	push   $0x802704
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 bc 26 80 00       	push   $0x8026bc
  800946:	e8 0c 03 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 6b 15 00 00       	call   801ebe <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 21 27 80 00       	push   $0x802721
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 bc 26 80 00       	push   $0x8026bc
  80096e:	e8 e4 02 00 00       	call   800c57 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 46 15 00 00       	call   801ebe <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 de 15 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 61 13 00 00       	call   801cf0 <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 c7 15 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 34 27 80 00       	push   $0x802734
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 bc 26 80 00       	push   $0x8026bc
  8009b7:	e8 9b 02 00 00       	call   800c57 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 fd 14 00 00       	call   801ebe <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 4b 27 80 00       	push   $0x80274b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 bc 26 80 00       	push   $0x8026bc
  8009dc:	e8 76 02 00 00       	call   800c57 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 d8 14 00 00       	call   801ebe <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 70 15 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 f3 12 00 00       	call   801cf0 <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 59 15 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 34 27 80 00       	push   $0x802734
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 bc 26 80 00       	push   $0x8026bc
  800a25:	e8 2d 02 00 00       	call   800c57 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 8f 14 00 00       	call   801ebe <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 4b 27 80 00       	push   $0x80274b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 bc 26 80 00       	push   $0x8026bc
  800a4a:	e8 08 02 00 00       	call   800c57 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 6a 14 00 00       	call   801ebe <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 02 15 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 3f 12 00 00       	call   801caf <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 d4 26 80 00       	push   $0x8026d4
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 bc 26 80 00       	push   $0x8026bc
  800aa0:	e8 b2 01 00 00       	call   800c57 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 b4 14 00 00       	call   801f5e <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 04 27 80 00       	push   $0x802704
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 bc 26 80 00       	push   $0x8026bc
  800ac6:	e8 8c 01 00 00       	call   800c57 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 ee 13 00 00       	call   801ebe <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 21 27 80 00       	push   $0x802721
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 bc 26 80 00       	push   $0x8026bc
  800aeb:	e8 67 01 00 00       	call   800c57 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 58 27 80 00       	push   $0x802758
  800af8:	e8 0e 04 00 00       	call   800f0b <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 8b 16 00 00       	call   80219e <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	01 c0                	add    %eax,%eax
  800b1d:	01 d0                	add    %edx,%eax
  800b1f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b26:	01 c8                	add    %ecx,%eax
  800b28:	c1 e0 02             	shl    $0x2,%eax
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b34:	01 c8                	add    %ecx,%eax
  800b36:	c1 e0 02             	shl    $0x2,%eax
  800b39:	01 d0                	add    %edx,%eax
  800b3b:	c1 e0 02             	shl    $0x2,%eax
  800b3e:	01 d0                	add    %edx,%eax
  800b40:	c1 e0 03             	shl    $0x3,%eax
  800b43:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b48:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b4d:	a1 20 30 80 00       	mov    0x803020,%eax
  800b52:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800b58:	84 c0                	test   %al,%al
  800b5a:	74 0f                	je     800b6b <libmain+0x63>
		binaryname = myEnv->prog_name;
  800b5c:	a1 20 30 80 00       	mov    0x803020,%eax
  800b61:	05 18 da 01 00       	add    $0x1da18,%eax
  800b66:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6f:	7e 0a                	jle    800b7b <libmain+0x73>
		binaryname = argv[0];
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	ff 75 08             	pushl  0x8(%ebp)
  800b84:	e8 af f4 ff ff       	call   800038 <_main>
  800b89:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b8c:	e8 1a 14 00 00       	call   801fab <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b91:	83 ec 0c             	sub    $0xc,%esp
  800b94:	68 b8 27 80 00       	push   $0x8027b8
  800b99:	e8 6d 03 00 00       	call   800f0b <cprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ba1:	a1 20 30 80 00       	mov    0x803020,%eax
  800ba6:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800bac:	a1 20 30 80 00       	mov    0x803020,%eax
  800bb1:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800bb7:	83 ec 04             	sub    $0x4,%esp
  800bba:	52                   	push   %edx
  800bbb:	50                   	push   %eax
  800bbc:	68 e0 27 80 00       	push   $0x8027e0
  800bc1:	e8 45 03 00 00       	call   800f0b <cprintf>
  800bc6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bc9:	a1 20 30 80 00       	mov    0x803020,%eax
  800bce:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800bd4:	a1 20 30 80 00       	mov    0x803020,%eax
  800bd9:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800bdf:	a1 20 30 80 00       	mov    0x803020,%eax
  800be4:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800bea:	51                   	push   %ecx
  800beb:	52                   	push   %edx
  800bec:	50                   	push   %eax
  800bed:	68 08 28 80 00       	push   $0x802808
  800bf2:	e8 14 03 00 00       	call   800f0b <cprintf>
  800bf7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bfa:	a1 20 30 80 00       	mov    0x803020,%eax
  800bff:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	50                   	push   %eax
  800c09:	68 60 28 80 00       	push   $0x802860
  800c0e:	e8 f8 02 00 00       	call   800f0b <cprintf>
  800c13:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 b8 27 80 00       	push   $0x8027b8
  800c1e:	e8 e8 02 00 00       	call   800f0b <cprintf>
  800c23:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c26:	e8 9a 13 00 00       	call   801fc5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c2b:	e8 19 00 00 00       	call   800c49 <exit>
}
  800c30:	90                   	nop
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	6a 00                	push   $0x0
  800c3e:	e8 27 15 00 00       	call   80216a <sys_destroy_env>
  800c43:	83 c4 10             	add    $0x10,%esp
}
  800c46:	90                   	nop
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <exit>:

void
exit(void)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c4f:	e8 7c 15 00 00       	call   8021d0 <sys_exit_env>
}
  800c54:	90                   	nop
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c5d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c60:	83 c0 04             	add    $0x4,%eax
  800c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c66:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	74 16                	je     800c85 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c6f:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	50                   	push   %eax
  800c78:	68 74 28 80 00       	push   $0x802874
  800c7d:	e8 89 02 00 00       	call   800f0b <cprintf>
  800c82:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c85:	a1 00 30 80 00       	mov    0x803000,%eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	50                   	push   %eax
  800c91:	68 79 28 80 00       	push   $0x802879
  800c96:	e8 70 02 00 00       	call   800f0b <cprintf>
  800c9b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca7:	50                   	push   %eax
  800ca8:	e8 f3 01 00 00       	call   800ea0 <vcprintf>
  800cad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	6a 00                	push   $0x0
  800cb5:	68 95 28 80 00       	push   $0x802895
  800cba:	e8 e1 01 00 00       	call   800ea0 <vcprintf>
  800cbf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cc2:	e8 82 ff ff ff       	call   800c49 <exit>

	// should not return here
	while (1) ;
  800cc7:	eb fe                	jmp    800cc7 <_panic+0x70>

00800cc9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ccf:	a1 20 30 80 00       	mov    0x803020,%eax
  800cd4:	8b 50 74             	mov    0x74(%eax),%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	39 c2                	cmp    %eax,%edx
  800cdc:	74 14                	je     800cf2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cde:	83 ec 04             	sub    $0x4,%esp
  800ce1:	68 98 28 80 00       	push   $0x802898
  800ce6:	6a 26                	push   $0x26
  800ce8:	68 e4 28 80 00       	push   $0x8028e4
  800ced:	e8 65 ff ff ff       	call   800c57 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800cf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d00:	e9 c2 00 00 00       	jmp    800dc7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	01 d0                	add    %edx,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	85 c0                	test   %eax,%eax
  800d18:	75 08                	jne    800d22 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d1a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d1d:	e9 a2 00 00 00       	jmp    800dc4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d30:	eb 69                	jmp    800d9b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d32:	a1 20 30 80 00       	mov    0x803020,%eax
  800d37:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800d3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d40:	89 d0                	mov    %edx,%eax
  800d42:	01 c0                	add    %eax,%eax
  800d44:	01 d0                	add    %edx,%eax
  800d46:	c1 e0 03             	shl    $0x3,%eax
  800d49:	01 c8                	add    %ecx,%eax
  800d4b:	8a 40 04             	mov    0x4(%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	75 46                	jne    800d98 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d52:	a1 20 30 80 00       	mov    0x803020,%eax
  800d57:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800d5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d60:	89 d0                	mov    %edx,%eax
  800d62:	01 c0                	add    %eax,%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	c1 e0 03             	shl    $0x3,%eax
  800d69:	01 c8                	add    %ecx,%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d78:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	01 c8                	add    %ecx,%eax
  800d89:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d8b:	39 c2                	cmp    %eax,%edx
  800d8d:	75 09                	jne    800d98 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d8f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d96:	eb 12                	jmp    800daa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d98:	ff 45 e8             	incl   -0x18(%ebp)
  800d9b:	a1 20 30 80 00       	mov    0x803020,%eax
  800da0:	8b 50 74             	mov    0x74(%eax),%edx
  800da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800da6:	39 c2                	cmp    %eax,%edx
  800da8:	77 88                	ja     800d32 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800daa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dae:	75 14                	jne    800dc4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	68 f0 28 80 00       	push   $0x8028f0
  800db8:	6a 3a                	push   $0x3a
  800dba:	68 e4 28 80 00       	push   $0x8028e4
  800dbf:	e8 93 fe ff ff       	call   800c57 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800dc4:	ff 45 f0             	incl   -0x10(%ebp)
  800dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dcd:	0f 8c 32 ff ff ff    	jl     800d05 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dd3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dda:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800de1:	eb 26                	jmp    800e09 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800de3:	a1 20 30 80 00       	mov    0x803020,%eax
  800de8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800dee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df1:	89 d0                	mov    %edx,%eax
  800df3:	01 c0                	add    %eax,%eax
  800df5:	01 d0                	add    %edx,%eax
  800df7:	c1 e0 03             	shl    $0x3,%eax
  800dfa:	01 c8                	add    %ecx,%eax
  800dfc:	8a 40 04             	mov    0x4(%eax),%al
  800dff:	3c 01                	cmp    $0x1,%al
  800e01:	75 03                	jne    800e06 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e03:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e06:	ff 45 e0             	incl   -0x20(%ebp)
  800e09:	a1 20 30 80 00       	mov    0x803020,%eax
  800e0e:	8b 50 74             	mov    0x74(%eax),%edx
  800e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e14:	39 c2                	cmp    %eax,%edx
  800e16:	77 cb                	ja     800de3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e1b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e1e:	74 14                	je     800e34 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e20:	83 ec 04             	sub    $0x4,%esp
  800e23:	68 44 29 80 00       	push   $0x802944
  800e28:	6a 44                	push   $0x44
  800e2a:	68 e4 28 80 00       	push   $0x8028e4
  800e2f:	e8 23 fe ff ff       	call   800c57 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e34:	90                   	nop
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	8b 00                	mov    (%eax),%eax
  800e42:	8d 48 01             	lea    0x1(%eax),%ecx
  800e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e48:	89 0a                	mov    %ecx,(%edx)
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	88 d1                	mov    %dl,%cl
  800e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e52:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 00                	mov    (%eax),%eax
  800e5b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e60:	75 2c                	jne    800e8e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e62:	a0 24 30 80 00       	mov    0x803024,%al
  800e67:	0f b6 c0             	movzbl %al,%eax
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8b 12                	mov    (%edx),%edx
  800e6f:	89 d1                	mov    %edx,%ecx
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	83 c2 08             	add    $0x8,%edx
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	50                   	push   %eax
  800e7b:	51                   	push   %ecx
  800e7c:	52                   	push   %edx
  800e7d:	e8 7b 0f 00 00       	call   801dfd <sys_cputs>
  800e82:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	8b 40 04             	mov    0x4(%eax),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e9d:	90                   	nop
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ea9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800eb0:	00 00 00 
	b.cnt = 0;
  800eb3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ebd:	ff 75 0c             	pushl  0xc(%ebp)
  800ec0:	ff 75 08             	pushl  0x8(%ebp)
  800ec3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ec9:	50                   	push   %eax
  800eca:	68 37 0e 80 00       	push   $0x800e37
  800ecf:	e8 11 02 00 00       	call   8010e5 <vprintfmt>
  800ed4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ed7:	a0 24 30 80 00       	mov    0x803024,%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	50                   	push   %eax
  800ee9:	52                   	push   %edx
  800eea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef0:	83 c0 08             	add    $0x8,%eax
  800ef3:	50                   	push   %eax
  800ef4:	e8 04 0f 00 00       	call   801dfd <sys_cputs>
  800ef9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800efc:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800f03:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f11:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800f18:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 f4             	pushl  -0xc(%ebp)
  800f27:	50                   	push   %eax
  800f28:	e8 73 ff ff ff       	call   800ea0 <vcprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f3e:	e8 68 10 00 00       	call   801fab <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f43:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	e8 48 ff ff ff       	call   800ea0 <vcprintf>
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f5e:	e8 62 10 00 00       	call   801fc5 <sys_enable_interrupt>
	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 14             	sub    $0x14,%esp
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f7b:	8b 45 18             	mov    0x18(%ebp),%eax
  800f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f83:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f86:	77 55                	ja     800fdd <printnum+0x75>
  800f88:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f8b:	72 05                	jb     800f92 <printnum+0x2a>
  800f8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f90:	77 4b                	ja     800fdd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f92:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f95:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f98:	8b 45 18             	mov    0x18(%ebp),%eax
  800f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa0:	52                   	push   %edx
  800fa1:	50                   	push   %eax
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa8:	e8 83 14 00 00       	call   802430 <__udivdi3>
  800fad:	83 c4 10             	add    $0x10,%esp
  800fb0:	83 ec 04             	sub    $0x4,%esp
  800fb3:	ff 75 20             	pushl  0x20(%ebp)
  800fb6:	53                   	push   %ebx
  800fb7:	ff 75 18             	pushl  0x18(%ebp)
  800fba:	52                   	push   %edx
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 a1 ff ff ff       	call   800f68 <printnum>
  800fc7:	83 c4 20             	add    $0x20,%esp
  800fca:	eb 1a                	jmp    800fe6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	ff 75 20             	pushl  0x20(%ebp)
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	ff d0                	call   *%eax
  800fda:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fdd:	ff 4d 1c             	decl   0x1c(%ebp)
  800fe0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fe4:	7f e6                	jg     800fcc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fe6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fe9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff4:	53                   	push   %ebx
  800ff5:	51                   	push   %ecx
  800ff6:	52                   	push   %edx
  800ff7:	50                   	push   %eax
  800ff8:	e8 43 15 00 00       	call   802540 <__umoddi3>
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	05 b4 2b 80 00       	add    $0x802bb4,%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f be c0             	movsbl %al,%eax
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	ff 75 0c             	pushl  0xc(%ebp)
  801010:	50                   	push   %eax
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	ff d0                	call   *%eax
  801016:	83 c4 10             	add    $0x10,%esp
}
  801019:	90                   	nop
  80101a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801022:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801026:	7e 1c                	jle    801044 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8b 00                	mov    (%eax),%eax
  80102d:	8d 50 08             	lea    0x8(%eax),%edx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	89 10                	mov    %edx,(%eax)
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8b 00                	mov    (%eax),%eax
  80103a:	83 e8 08             	sub    $0x8,%eax
  80103d:	8b 50 04             	mov    0x4(%eax),%edx
  801040:	8b 00                	mov    (%eax),%eax
  801042:	eb 40                	jmp    801084 <getuint+0x65>
	else if (lflag)
  801044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801048:	74 1e                	je     801068 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8b 00                	mov    (%eax),%eax
  80104f:	8d 50 04             	lea    0x4(%eax),%edx
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 10                	mov    %edx,(%eax)
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8b 00                	mov    (%eax),%eax
  80105c:	83 e8 04             	sub    $0x4,%eax
  80105f:	8b 00                	mov    (%eax),%eax
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	eb 1c                	jmp    801084 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8b 00                	mov    (%eax),%eax
  80106d:	8d 50 04             	lea    0x4(%eax),%edx
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	89 10                	mov    %edx,(%eax)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8b 00                	mov    (%eax),%eax
  80107a:	83 e8 04             	sub    $0x4,%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801089:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80108d:	7e 1c                	jle    8010ab <getint+0x25>
		return va_arg(*ap, long long);
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8b 00                	mov    (%eax),%eax
  801094:	8d 50 08             	lea    0x8(%eax),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 10                	mov    %edx,(%eax)
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8b 00                	mov    (%eax),%eax
  8010a1:	83 e8 08             	sub    $0x8,%eax
  8010a4:	8b 50 04             	mov    0x4(%eax),%edx
  8010a7:	8b 00                	mov    (%eax),%eax
  8010a9:	eb 38                	jmp    8010e3 <getint+0x5d>
	else if (lflag)
  8010ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010af:	74 1a                	je     8010cb <getint+0x45>
		return va_arg(*ap, long);
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8b 00                	mov    (%eax),%eax
  8010b6:	8d 50 04             	lea    0x4(%eax),%edx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 10                	mov    %edx,(%eax)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	83 e8 04             	sub    $0x4,%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	99                   	cltd   
  8010c9:	eb 18                	jmp    8010e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	8d 50 04             	lea    0x4(%eax),%edx
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 10                	mov    %edx,(%eax)
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 00                	mov    (%eax),%eax
  8010dd:	83 e8 04             	sub    $0x4,%eax
  8010e0:	8b 00                	mov    (%eax),%eax
  8010e2:	99                   	cltd   
}
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010ed:	eb 17                	jmp    801106 <vprintfmt+0x21>
			if (ch == '\0')
  8010ef:	85 db                	test   %ebx,%ebx
  8010f1:	0f 84 af 03 00 00    	je     8014a6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010f7:	83 ec 08             	sub    $0x8,%esp
  8010fa:	ff 75 0c             	pushl  0xc(%ebp)
  8010fd:	53                   	push   %ebx
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	ff d0                	call   *%eax
  801103:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	8d 50 01             	lea    0x1(%eax),%edx
  80110c:	89 55 10             	mov    %edx,0x10(%ebp)
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 d8             	movzbl %al,%ebx
  801114:	83 fb 25             	cmp    $0x25,%ebx
  801117:	75 d6                	jne    8010ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801119:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80111d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801124:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80112b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801132:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 10             	mov    %edx,0x10(%ebp)
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 d8             	movzbl %al,%ebx
  801147:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80114a:	83 f8 55             	cmp    $0x55,%eax
  80114d:	0f 87 2b 03 00 00    	ja     80147e <vprintfmt+0x399>
  801153:	8b 04 85 d8 2b 80 00 	mov    0x802bd8(,%eax,4),%eax
  80115a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80115c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801160:	eb d7                	jmp    801139 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801162:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801166:	eb d1                	jmp    801139 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80116f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801172:	89 d0                	mov    %edx,%eax
  801174:	c1 e0 02             	shl    $0x2,%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	01 c0                	add    %eax,%eax
  80117b:	01 d8                	add    %ebx,%eax
  80117d:	83 e8 30             	sub    $0x30,%eax
  801180:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80118b:	83 fb 2f             	cmp    $0x2f,%ebx
  80118e:	7e 3e                	jle    8011ce <vprintfmt+0xe9>
  801190:	83 fb 39             	cmp    $0x39,%ebx
  801193:	7f 39                	jg     8011ce <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801195:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801198:	eb d5                	jmp    80116f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80119a:	8b 45 14             	mov    0x14(%ebp),%eax
  80119d:	83 c0 04             	add    $0x4,%eax
  8011a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a6:	83 e8 04             	sub    $0x4,%eax
  8011a9:	8b 00                	mov    (%eax),%eax
  8011ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011ae:	eb 1f                	jmp    8011cf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011b4:	79 83                	jns    801139 <vprintfmt+0x54>
				width = 0;
  8011b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011bd:	e9 77 ff ff ff       	jmp    801139 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011c9:	e9 6b ff ff ff       	jmp    801139 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011d3:	0f 89 60 ff ff ff    	jns    801139 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011e6:	e9 4e ff ff ff       	jmp    801139 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011eb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011ee:	e9 46 ff ff ff       	jmp    801139 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f6:	83 c0 04             	add    $0x4,%eax
  8011f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ff:	83 e8 04             	sub    $0x4,%eax
  801202:	8b 00                	mov    (%eax),%eax
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	ff 75 0c             	pushl  0xc(%ebp)
  80120a:	50                   	push   %eax
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	ff d0                	call   *%eax
  801210:	83 c4 10             	add    $0x10,%esp
			break;
  801213:	e9 89 02 00 00       	jmp    8014a1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801218:	8b 45 14             	mov    0x14(%ebp),%eax
  80121b:	83 c0 04             	add    $0x4,%eax
  80121e:	89 45 14             	mov    %eax,0x14(%ebp)
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	83 e8 04             	sub    $0x4,%eax
  801227:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801229:	85 db                	test   %ebx,%ebx
  80122b:	79 02                	jns    80122f <vprintfmt+0x14a>
				err = -err;
  80122d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80122f:	83 fb 64             	cmp    $0x64,%ebx
  801232:	7f 0b                	jg     80123f <vprintfmt+0x15a>
  801234:	8b 34 9d 20 2a 80 00 	mov    0x802a20(,%ebx,4),%esi
  80123b:	85 f6                	test   %esi,%esi
  80123d:	75 19                	jne    801258 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80123f:	53                   	push   %ebx
  801240:	68 c5 2b 80 00       	push   $0x802bc5
  801245:	ff 75 0c             	pushl  0xc(%ebp)
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 5e 02 00 00       	call   8014ae <printfmt>
  801250:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801253:	e9 49 02 00 00       	jmp    8014a1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801258:	56                   	push   %esi
  801259:	68 ce 2b 80 00       	push   $0x802bce
  80125e:	ff 75 0c             	pushl  0xc(%ebp)
  801261:	ff 75 08             	pushl  0x8(%ebp)
  801264:	e8 45 02 00 00       	call   8014ae <printfmt>
  801269:	83 c4 10             	add    $0x10,%esp
			break;
  80126c:	e9 30 02 00 00       	jmp    8014a1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	83 c0 04             	add    $0x4,%eax
  801277:	89 45 14             	mov    %eax,0x14(%ebp)
  80127a:	8b 45 14             	mov    0x14(%ebp),%eax
  80127d:	83 e8 04             	sub    $0x4,%eax
  801280:	8b 30                	mov    (%eax),%esi
  801282:	85 f6                	test   %esi,%esi
  801284:	75 05                	jne    80128b <vprintfmt+0x1a6>
				p = "(null)";
  801286:	be d1 2b 80 00       	mov    $0x802bd1,%esi
			if (width > 0 && padc != '-')
  80128b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80128f:	7e 6d                	jle    8012fe <vprintfmt+0x219>
  801291:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801295:	74 67                	je     8012fe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801297:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	50                   	push   %eax
  80129e:	56                   	push   %esi
  80129f:	e8 0c 03 00 00       	call   8015b0 <strnlen>
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012aa:	eb 16                	jmp    8012c2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	ff d0                	call   *%eax
  8012bc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8012c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012c6:	7f e4                	jg     8012ac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012c8:	eb 34                	jmp    8012fe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012ce:	74 1c                	je     8012ec <vprintfmt+0x207>
  8012d0:	83 fb 1f             	cmp    $0x1f,%ebx
  8012d3:	7e 05                	jle    8012da <vprintfmt+0x1f5>
  8012d5:	83 fb 7e             	cmp    $0x7e,%ebx
  8012d8:	7e 12                	jle    8012ec <vprintfmt+0x207>
					putch('?', putdat);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	6a 3f                	push   $0x3f
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	ff d0                	call   *%eax
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	eb 0f                	jmp    8012fb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	53                   	push   %ebx
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012fb:	ff 4d e4             	decl   -0x1c(%ebp)
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	8d 70 01             	lea    0x1(%eax),%esi
  801303:	8a 00                	mov    (%eax),%al
  801305:	0f be d8             	movsbl %al,%ebx
  801308:	85 db                	test   %ebx,%ebx
  80130a:	74 24                	je     801330 <vprintfmt+0x24b>
  80130c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801310:	78 b8                	js     8012ca <vprintfmt+0x1e5>
  801312:	ff 4d e0             	decl   -0x20(%ebp)
  801315:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801319:	79 af                	jns    8012ca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131b:	eb 13                	jmp    801330 <vprintfmt+0x24b>
				putch(' ', putdat);
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	6a 20                	push   $0x20
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	ff d0                	call   *%eax
  80132a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80132d:	ff 4d e4             	decl   -0x1c(%ebp)
  801330:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801334:	7f e7                	jg     80131d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801336:	e9 66 01 00 00       	jmp    8014a1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	ff 75 e8             	pushl  -0x18(%ebp)
  801341:	8d 45 14             	lea    0x14(%ebp),%eax
  801344:	50                   	push   %eax
  801345:	e8 3c fd ff ff       	call   801086 <getint>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801350:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801359:	85 d2                	test   %edx,%edx
  80135b:	79 23                	jns    801380 <vprintfmt+0x29b>
				putch('-', putdat);
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	ff 75 0c             	pushl  0xc(%ebp)
  801363:	6a 2d                	push   $0x2d
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	ff d0                	call   *%eax
  80136a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801373:	f7 d8                	neg    %eax
  801375:	83 d2 00             	adc    $0x0,%edx
  801378:	f7 da                	neg    %edx
  80137a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80137d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801380:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801387:	e9 bc 00 00 00       	jmp    801448 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	ff 75 e8             	pushl  -0x18(%ebp)
  801392:	8d 45 14             	lea    0x14(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	e8 84 fc ff ff       	call   80101f <getuint>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ab:	e9 98 00 00 00       	jmp    801448 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 58                	push   $0x58
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	6a 58                	push   $0x58
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	ff d0                	call   *%eax
  8013cd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	6a 58                	push   $0x58
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	ff d0                	call   *%eax
  8013dd:	83 c4 10             	add    $0x10,%esp
			break;
  8013e0:	e9 bc 00 00 00       	jmp    8014a1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	ff 75 0c             	pushl  0xc(%ebp)
  8013eb:	6a 30                	push   $0x30
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	ff d0                	call   *%eax
  8013f2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	6a 78                	push   $0x78
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	ff d0                	call   *%eax
  801402:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801416:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801420:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801427:	eb 1f                	jmp    801448 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	ff 75 e8             	pushl  -0x18(%ebp)
  80142f:	8d 45 14             	lea    0x14(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	e8 e7 fb ff ff       	call   80101f <getuint>
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80143e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801441:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801448:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80144c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	52                   	push   %edx
  801453:	ff 75 e4             	pushl  -0x1c(%ebp)
  801456:	50                   	push   %eax
  801457:	ff 75 f4             	pushl  -0xc(%ebp)
  80145a:	ff 75 f0             	pushl  -0x10(%ebp)
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	ff 75 08             	pushl  0x8(%ebp)
  801463:	e8 00 fb ff ff       	call   800f68 <printnum>
  801468:	83 c4 20             	add    $0x20,%esp
			break;
  80146b:	eb 34                	jmp    8014a1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	ff 75 0c             	pushl  0xc(%ebp)
  801473:	53                   	push   %ebx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	ff d0                	call   *%eax
  801479:	83 c4 10             	add    $0x10,%esp
			break;
  80147c:	eb 23                	jmp    8014a1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	6a 25                	push   $0x25
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	ff d0                	call   *%eax
  80148b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80148e:	ff 4d 10             	decl   0x10(%ebp)
  801491:	eb 03                	jmp    801496 <vprintfmt+0x3b1>
  801493:	ff 4d 10             	decl   0x10(%ebp)
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	48                   	dec    %eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	3c 25                	cmp    $0x25,%al
  80149e:	75 f3                	jne    801493 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014a0:	90                   	nop
		}
	}
  8014a1:	e9 47 fc ff ff       	jmp    8010ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014a6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5e                   	pop    %esi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    

008014ae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014b7:	83 c0 04             	add    $0x4,%eax
  8014ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c3:	50                   	push   %eax
  8014c4:	ff 75 0c             	pushl  0xc(%ebp)
  8014c7:	ff 75 08             	pushl  0x8(%ebp)
  8014ca:	e8 16 fc ff ff       	call   8010e5 <vprintfmt>
  8014cf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	8b 40 08             	mov    0x8(%eax),%eax
  8014de:	8d 50 01             	lea    0x1(%eax),%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ea:	8b 10                	mov    (%eax),%edx
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	8b 40 04             	mov    0x4(%eax),%eax
  8014f2:	39 c2                	cmp    %eax,%edx
  8014f4:	73 12                	jae    801508 <sprintputch+0x33>
		*b->buf++ = ch;
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8014fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801501:	89 0a                	mov    %ecx,(%edx)
  801503:	8b 55 08             	mov    0x8(%ebp),%edx
  801506:	88 10                	mov    %dl,(%eax)
}
  801508:	90                   	nop
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    

0080150b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80152c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801530:	74 06                	je     801538 <vsnprintf+0x2d>
  801532:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801536:	7f 07                	jg     80153f <vsnprintf+0x34>
		return -E_INVAL;
  801538:	b8 03 00 00 00       	mov    $0x3,%eax
  80153d:	eb 20                	jmp    80155f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80153f:	ff 75 14             	pushl  0x14(%ebp)
  801542:	ff 75 10             	pushl  0x10(%ebp)
  801545:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801548:	50                   	push   %eax
  801549:	68 d5 14 80 00       	push   $0x8014d5
  80154e:	e8 92 fb ff ff       	call   8010e5 <vprintfmt>
  801553:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801556:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801559:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801567:	8d 45 10             	lea    0x10(%ebp),%eax
  80156a:	83 c0 04             	add    $0x4,%eax
  80156d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	ff 75 f4             	pushl  -0xc(%ebp)
  801576:	50                   	push   %eax
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 89 ff ff ff       	call   80150b <vsnprintf>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801593:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80159a:	eb 06                	jmp    8015a2 <strlen+0x15>
		n++;
  80159c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80159f:	ff 45 08             	incl   0x8(%ebp)
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	84 c0                	test   %al,%al
  8015a9:	75 f1                	jne    80159c <strlen+0xf>
		n++;
	return n;
  8015ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015bd:	eb 09                	jmp    8015c8 <strnlen+0x18>
		n++;
  8015bf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	ff 4d 0c             	decl   0xc(%ebp)
  8015c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015cc:	74 09                	je     8015d7 <strnlen+0x27>
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	84 c0                	test   %al,%al
  8015d5:	75 e8                	jne    8015bf <strnlen+0xf>
		n++;
	return n;
  8015d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015e8:	90                   	nop
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8d 50 01             	lea    0x1(%eax),%edx
  8015ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015fb:	8a 12                	mov    (%edx),%dl
  8015fd:	88 10                	mov    %dl,(%eax)
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	84 c0                	test   %al,%al
  801603:	75 e4                	jne    8015e9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801616:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80161d:	eb 1f                	jmp    80163e <strncpy+0x34>
		*dst++ = *src;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8d 50 01             	lea    0x1(%eax),%edx
  801625:	89 55 08             	mov    %edx,0x8(%ebp)
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	84 c0                	test   %al,%al
  801636:	74 03                	je     80163b <strncpy+0x31>
			src++;
  801638:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80163b:	ff 45 fc             	incl   -0x4(%ebp)
  80163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801641:	3b 45 10             	cmp    0x10(%ebp),%eax
  801644:	72 d9                	jb     80161f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801657:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80165b:	74 30                	je     80168d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80165d:	eb 16                	jmp    801675 <strlcpy+0x2a>
			*dst++ = *src++;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8d 50 01             	lea    0x1(%eax),%edx
  801665:	89 55 08             	mov    %edx,0x8(%ebp)
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80166e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801671:	8a 12                	mov    (%edx),%dl
  801673:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801675:	ff 4d 10             	decl   0x10(%ebp)
  801678:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167c:	74 09                	je     801687 <strlcpy+0x3c>
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	84 c0                	test   %al,%al
  801685:	75 d8                	jne    80165f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80168d:	8b 55 08             	mov    0x8(%ebp),%edx
  801690:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801693:	29 c2                	sub    %eax,%edx
  801695:	89 d0                	mov    %edx,%eax
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80169c:	eb 06                	jmp    8016a4 <strcmp+0xb>
		p++, q++;
  80169e:	ff 45 08             	incl   0x8(%ebp)
  8016a1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	84 c0                	test   %al,%al
  8016ab:	74 0e                	je     8016bb <strcmp+0x22>
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 10                	mov    (%eax),%dl
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	38 c2                	cmp    %al,%dl
  8016b9:	74 e3                	je     80169e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f b6 d0             	movzbl %al,%edx
  8016c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	0f b6 c0             	movzbl %al,%eax
  8016cb:	29 c2                	sub    %eax,%edx
  8016cd:	89 d0                	mov    %edx,%eax
}
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016d4:	eb 09                	jmp    8016df <strncmp+0xe>
		n--, p++, q++;
  8016d6:	ff 4d 10             	decl   0x10(%ebp)
  8016d9:	ff 45 08             	incl   0x8(%ebp)
  8016dc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e3:	74 17                	je     8016fc <strncmp+0x2b>
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	84 c0                	test   %al,%al
  8016ec:	74 0e                	je     8016fc <strncmp+0x2b>
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	8a 10                	mov    (%eax),%dl
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	38 c2                	cmp    %al,%dl
  8016fa:	74 da                	je     8016d6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801700:	75 07                	jne    801709 <strncmp+0x38>
		return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	eb 14                	jmp    80171d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f b6 d0             	movzbl %al,%edx
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	0f b6 c0             	movzbl %al,%eax
  801719:	29 c2                	sub    %eax,%edx
  80171b:	89 d0                	mov    %edx,%eax
}
  80171d:	5d                   	pop    %ebp
  80171e:	c3                   	ret    

0080171f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
  801728:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80172b:	eb 12                	jmp    80173f <strchr+0x20>
		if (*s == c)
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801735:	75 05                	jne    80173c <strchr+0x1d>
			return (char *) s;
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	eb 11                	jmp    80174d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80173c:	ff 45 08             	incl   0x8(%ebp)
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	84 c0                	test   %al,%al
  801746:	75 e5                	jne    80172d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 0d                	jmp    80176a <strfind+0x1b>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	74 0e                	je     801775 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 ea                	jne    80175d <strfind+0xe>
  801773:	eb 01                	jmp    801776 <strfind+0x27>
		if (*s == c)
			break;
  801775:	90                   	nop
	return (char *) s;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80178d:	eb 0e                	jmp    80179d <memset+0x22>
		*p++ = c;
  80178f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801792:	8d 50 01             	lea    0x1(%eax),%edx
  801795:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80179d:	ff 4d f8             	decl   -0x8(%ebp)
  8017a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017a4:	79 e9                	jns    80178f <memset+0x14>
		*p++ = c;

	return v;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017bd:	eb 16                	jmp    8017d5 <memcpy+0x2a>
		*d++ = *s++;
  8017bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017d1:	8a 12                	mov    (%edx),%dl
  8017d3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017db:	89 55 10             	mov    %edx,0x10(%ebp)
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	75 dd                	jne    8017bf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ff:	73 50                	jae    801851 <memmove+0x6a>
  801801:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	01 d0                	add    %edx,%eax
  801809:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80180c:	76 43                	jbe    801851 <memmove+0x6a>
		s += n;
  80180e:	8b 45 10             	mov    0x10(%ebp),%eax
  801811:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80181a:	eb 10                	jmp    80182c <memmove+0x45>
			*--d = *--s;
  80181c:	ff 4d f8             	decl   -0x8(%ebp)
  80181f:	ff 4d fc             	decl   -0x4(%ebp)
  801822:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801825:	8a 10                	mov    (%eax),%dl
  801827:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801832:	89 55 10             	mov    %edx,0x10(%ebp)
  801835:	85 c0                	test   %eax,%eax
  801837:	75 e3                	jne    80181c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801839:	eb 23                	jmp    80185e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80183b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183e:	8d 50 01             	lea    0x1(%eax),%edx
  801841:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801844:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801847:	8d 4a 01             	lea    0x1(%edx),%ecx
  80184a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80184d:	8a 12                	mov    (%edx),%dl
  80184f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801851:	8b 45 10             	mov    0x10(%ebp),%eax
  801854:	8d 50 ff             	lea    -0x1(%eax),%edx
  801857:	89 55 10             	mov    %edx,0x10(%ebp)
  80185a:	85 c0                	test   %eax,%eax
  80185c:	75 dd                	jne    80183b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80186f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801872:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801875:	eb 2a                	jmp    8018a1 <memcmp+0x3e>
		if (*s1 != *s2)
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	8a 10                	mov    (%eax),%dl
  80187c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187f:	8a 00                	mov    (%eax),%al
  801881:	38 c2                	cmp    %al,%dl
  801883:	74 16                	je     80189b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	0f b6 d0             	movzbl %al,%edx
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801890:	8a 00                	mov    (%eax),%al
  801892:	0f b6 c0             	movzbl %al,%eax
  801895:	29 c2                	sub    %eax,%edx
  801897:	89 d0                	mov    %edx,%eax
  801899:	eb 18                	jmp    8018b3 <memcmp+0x50>
		s1++, s2++;
  80189b:	ff 45 fc             	incl   -0x4(%ebp)
  80189e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	75 c9                	jne    801877 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018be:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c1:	01 d0                	add    %edx,%eax
  8018c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018c6:	eb 15                	jmp    8018dd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	0f b6 d0             	movzbl %al,%edx
  8018d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d3:	0f b6 c0             	movzbl %al,%eax
  8018d6:	39 c2                	cmp    %eax,%edx
  8018d8:	74 0d                	je     8018e7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018da:	ff 45 08             	incl   0x8(%ebp)
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018e3:	72 e3                	jb     8018c8 <memfind+0x13>
  8018e5:	eb 01                	jmp    8018e8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018e7:	90                   	nop
	return (void *) s;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801901:	eb 03                	jmp    801906 <strtol+0x19>
		s++;
  801903:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	3c 20                	cmp    $0x20,%al
  80190d:	74 f4                	je     801903 <strtol+0x16>
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	3c 09                	cmp    $0x9,%al
  801916:	74 eb                	je     801903 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	3c 2b                	cmp    $0x2b,%al
  80191f:	75 05                	jne    801926 <strtol+0x39>
		s++;
  801921:	ff 45 08             	incl   0x8(%ebp)
  801924:	eb 13                	jmp    801939 <strtol+0x4c>
	else if (*s == '-')
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	3c 2d                	cmp    $0x2d,%al
  80192d:	75 0a                	jne    801939 <strtol+0x4c>
		s++, neg = 1;
  80192f:	ff 45 08             	incl   0x8(%ebp)
  801932:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801939:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193d:	74 06                	je     801945 <strtol+0x58>
  80193f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801943:	75 20                	jne    801965 <strtol+0x78>
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	3c 30                	cmp    $0x30,%al
  80194c:	75 17                	jne    801965 <strtol+0x78>
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	40                   	inc    %eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	3c 78                	cmp    $0x78,%al
  801956:	75 0d                	jne    801965 <strtol+0x78>
		s += 2, base = 16;
  801958:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80195c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801963:	eb 28                	jmp    80198d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801965:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801969:	75 15                	jne    801980 <strtol+0x93>
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 30                	cmp    $0x30,%al
  801972:	75 0c                	jne    801980 <strtol+0x93>
		s++, base = 8;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80197e:	eb 0d                	jmp    80198d <strtol+0xa0>
	else if (base == 0)
  801980:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801984:	75 07                	jne    80198d <strtol+0xa0>
		base = 10;
  801986:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	3c 2f                	cmp    $0x2f,%al
  801994:	7e 19                	jle    8019af <strtol+0xc2>
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	3c 39                	cmp    $0x39,%al
  80199d:	7f 10                	jg     8019af <strtol+0xc2>
			dig = *s - '0';
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8a 00                	mov    (%eax),%al
  8019a4:	0f be c0             	movsbl %al,%eax
  8019a7:	83 e8 30             	sub    $0x30,%eax
  8019aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ad:	eb 42                	jmp    8019f1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8a 00                	mov    (%eax),%al
  8019b4:	3c 60                	cmp    $0x60,%al
  8019b6:	7e 19                	jle    8019d1 <strtol+0xe4>
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8a 00                	mov    (%eax),%al
  8019bd:	3c 7a                	cmp    $0x7a,%al
  8019bf:	7f 10                	jg     8019d1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8a 00                	mov    (%eax),%al
  8019c6:	0f be c0             	movsbl %al,%eax
  8019c9:	83 e8 57             	sub    $0x57,%eax
  8019cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019cf:	eb 20                	jmp    8019f1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8a 00                	mov    (%eax),%al
  8019d6:	3c 40                	cmp    $0x40,%al
  8019d8:	7e 39                	jle    801a13 <strtol+0x126>
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	3c 5a                	cmp    $0x5a,%al
  8019e1:	7f 30                	jg     801a13 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	0f be c0             	movsbl %al,%eax
  8019eb:	83 e8 37             	sub    $0x37,%eax
  8019ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019f7:	7d 19                	jge    801a12 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019f9:	ff 45 08             	incl   0x8(%ebp)
  8019fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a08:	01 d0                	add    %edx,%eax
  801a0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a0d:	e9 7b ff ff ff       	jmp    80198d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a12:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a17:	74 08                	je     801a21 <strtol+0x134>
		*endptr = (char *) s;
  801a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a25:	74 07                	je     801a2e <strtol+0x141>
  801a27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2a:	f7 d8                	neg    %eax
  801a2c:	eb 03                	jmp    801a31 <strtol+0x144>
  801a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <ltostr>:

void
ltostr(long value, char *str)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a4b:	79 13                	jns    801a60 <ltostr+0x2d>
	{
		neg = 1;
  801a4d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a5a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a5d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a68:	99                   	cltd   
  801a69:	f7 f9                	idiv   %ecx
  801a6b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a71:	8d 50 01             	lea    0x1(%eax),%edx
  801a74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a77:	89 c2                	mov    %eax,%edx
  801a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a81:	83 c2 30             	add    $0x30,%edx
  801a84:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a89:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a8e:	f7 e9                	imul   %ecx
  801a90:	c1 fa 02             	sar    $0x2,%edx
  801a93:	89 c8                	mov    %ecx,%eax
  801a95:	c1 f8 1f             	sar    $0x1f,%eax
  801a98:	29 c2                	sub    %eax,%edx
  801a9a:	89 d0                	mov    %edx,%eax
  801a9c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801aa7:	f7 e9                	imul   %ecx
  801aa9:	c1 fa 02             	sar    $0x2,%edx
  801aac:	89 c8                	mov    %ecx,%eax
  801aae:	c1 f8 1f             	sar    $0x1f,%eax
  801ab1:	29 c2                	sub    %eax,%edx
  801ab3:	89 d0                	mov    %edx,%eax
  801ab5:	c1 e0 02             	shl    $0x2,%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	01 c0                	add    %eax,%eax
  801abc:	29 c1                	sub    %eax,%ecx
  801abe:	89 ca                	mov    %ecx,%edx
  801ac0:	85 d2                	test   %edx,%edx
  801ac2:	75 9c                	jne    801a60 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ace:	48                   	dec    %eax
  801acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ad6:	74 3d                	je     801b15 <ltostr+0xe2>
		start = 1 ;
  801ad8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801adf:	eb 34                	jmp    801b15 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae7:	01 d0                	add    %edx,%eax
  801ae9:	8a 00                	mov    (%eax),%al
  801aeb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afc:	01 c8                	add    %ecx,%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b08:	01 c2                	add    %eax,%edx
  801b0a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b0d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b0f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b12:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b1b:	7c c4                	jl     801ae1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b1d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b31:	ff 75 08             	pushl  0x8(%ebp)
  801b34:	e8 54 fa ff ff       	call   80158d <strlen>
  801b39:	83 c4 04             	add    $0x4,%esp
  801b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	e8 46 fa ff ff       	call   80158d <strlen>
  801b47:	83 c4 04             	add    $0x4,%esp
  801b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b5b:	eb 17                	jmp    801b74 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	01 c2                	add    %eax,%edx
  801b65:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	01 c8                	add    %ecx,%eax
  801b6d:	8a 00                	mov    (%eax),%al
  801b6f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b71:	ff 45 fc             	incl   -0x4(%ebp)
  801b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b7a:	7c e1                	jl     801b5d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b83:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b8a:	eb 1f                	jmp    801bab <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8f:	8d 50 01             	lea    0x1(%eax),%edx
  801b92:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b95:	89 c2                	mov    %eax,%edx
  801b97:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9a:	01 c2                	add    %eax,%edx
  801b9c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba2:	01 c8                	add    %ecx,%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ba8:	ff 45 f8             	incl   -0x8(%ebp)
  801bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bb1:	7c d9                	jl     801b8c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb9:	01 d0                	add    %edx,%eax
  801bbb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bbe:	90                   	nop
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd0:	8b 00                	mov    (%eax),%eax
  801bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdc:	01 d0                	add    %edx,%eax
  801bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801be4:	eb 0c                	jmp    801bf2 <strsplit+0x31>
			*string++ = 0;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	8d 50 01             	lea    0x1(%eax),%edx
  801bec:	89 55 08             	mov    %edx,0x8(%ebp)
  801bef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	84 c0                	test   %al,%al
  801bf9:	74 18                	je     801c13 <strsplit+0x52>
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	8a 00                	mov    (%eax),%al
  801c00:	0f be c0             	movsbl %al,%eax
  801c03:	50                   	push   %eax
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	e8 13 fb ff ff       	call   80171f <strchr>
  801c0c:	83 c4 08             	add    $0x8,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	75 d3                	jne    801be6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	8a 00                	mov    (%eax),%al
  801c18:	84 c0                	test   %al,%al
  801c1a:	74 5a                	je     801c76 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1f:	8b 00                	mov    (%eax),%eax
  801c21:	83 f8 0f             	cmp    $0xf,%eax
  801c24:	75 07                	jne    801c2d <strsplit+0x6c>
		{
			return 0;
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2b:	eb 66                	jmp    801c93 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c30:	8b 00                	mov    (%eax),%eax
  801c32:	8d 48 01             	lea    0x1(%eax),%ecx
  801c35:	8b 55 14             	mov    0x14(%ebp),%edx
  801c38:	89 0a                	mov    %ecx,(%edx)
  801c3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	01 c2                	add    %eax,%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c4b:	eb 03                	jmp    801c50 <strsplit+0x8f>
			string++;
  801c4d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8a 00                	mov    (%eax),%al
  801c55:	84 c0                	test   %al,%al
  801c57:	74 8b                	je     801be4 <strsplit+0x23>
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	0f be c0             	movsbl %al,%eax
  801c61:	50                   	push   %eax
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	e8 b5 fa ff ff       	call   80171f <strchr>
  801c6a:	83 c4 08             	add    $0x8,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	74 dc                	je     801c4d <strsplit+0x8c>
			string++;
	}
  801c71:	e9 6e ff ff ff       	jmp    801be4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c76:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c77:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c83:	8b 45 10             	mov    0x10(%ebp),%eax
  801c86:	01 d0                	add    %edx,%eax
  801c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	68 30 2d 80 00       	push   $0x802d30
  801ca3:	6a 0e                	push   $0xe
  801ca5:	68 6a 2d 80 00       	push   $0x802d6a
  801caa:	e8 a8 ef ff ff       	call   800c57 <_panic>

00801caf <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801cb5:	a1 04 30 80 00       	mov    0x803004,%eax
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	74 0f                	je     801ccd <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801cbe:	e8 d2 ff ff ff       	call   801c95 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801cc3:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801cca:	00 00 00 
	}
	if (size == 0) return NULL ;
  801ccd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cd1:	75 07                	jne    801cda <malloc+0x2b>
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd8:	eb 14                	jmp    801cee <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801cda:	83 ec 04             	sub    $0x4,%esp
  801cdd:	68 78 2d 80 00       	push   $0x802d78
  801ce2:	6a 2e                	push   $0x2e
  801ce4:	68 6a 2d 80 00       	push   $0x802d6a
  801ce9:	e8 69 ef ff ff       	call   800c57 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	68 a0 2d 80 00       	push   $0x802da0
  801cfe:	6a 49                	push   $0x49
  801d00:	68 6a 2d 80 00       	push   $0x802d6a
  801d05:	e8 4d ef ff ff       	call   800c57 <_panic>

00801d0a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 18             	sub    $0x18,%esp
  801d10:	8b 45 10             	mov    0x10(%ebp),%eax
  801d13:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	68 c4 2d 80 00       	push   $0x802dc4
  801d1e:	6a 57                	push   $0x57
  801d20:	68 6a 2d 80 00       	push   $0x802d6a
  801d25:	e8 2d ef ff ff       	call   800c57 <_panic>

00801d2a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	68 ec 2d 80 00       	push   $0x802dec
  801d38:	6a 60                	push   $0x60
  801d3a:	68 6a 2d 80 00       	push   $0x802d6a
  801d3f:	e8 13 ef ff ff       	call   800c57 <_panic>

00801d44 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	68 10 2e 80 00       	push   $0x802e10
  801d52:	6a 7c                	push   $0x7c
  801d54:	68 6a 2d 80 00       	push   $0x802d6a
  801d59:	e8 f9 ee ff ff       	call   800c57 <_panic>

00801d5e <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	68 38 2e 80 00       	push   $0x802e38
  801d6c:	68 86 00 00 00       	push   $0x86
  801d71:	68 6a 2d 80 00       	push   $0x802d6a
  801d76:	e8 dc ee ff ff       	call   800c57 <_panic>

00801d7b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	68 5c 2e 80 00       	push   $0x802e5c
  801d89:	68 91 00 00 00       	push   $0x91
  801d8e:	68 6a 2d 80 00       	push   $0x802d6a
  801d93:	e8 bf ee ff ff       	call   800c57 <_panic>

00801d98 <shrink>:

}
void shrink(uint32 newSize)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 5c 2e 80 00       	push   $0x802e5c
  801da6:	68 96 00 00 00       	push   $0x96
  801dab:	68 6a 2d 80 00       	push   $0x802d6a
  801db0:	e8 a2 ee ff ff       	call   800c57 <_panic>

00801db5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	68 5c 2e 80 00       	push   $0x802e5c
  801dc3:	68 9b 00 00 00       	push   $0x9b
  801dc8:	68 6a 2d 80 00       	push   $0x802d6a
  801dcd:	e8 85 ee ff ff       	call   800c57 <_panic>

00801dd2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dea:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ded:	cd 30                	int    $0x30
  801def:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    

00801dfd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	8b 45 10             	mov    0x10(%ebp),%eax
  801e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e09:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	52                   	push   %edx
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	50                   	push   %eax
  801e19:	6a 00                	push   $0x0
  801e1b:	e8 b2 ff ff ff       	call   801dd2 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 01                	push   $0x1
  801e35:	e8 98 ff ff ff       	call   801dd2 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	52                   	push   %edx
  801e4f:	50                   	push   %eax
  801e50:	6a 05                	push   $0x5
  801e52:	e8 7b ff ff ff       	call   801dd2 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	56                   	push   %esi
  801e60:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e61:	8b 75 18             	mov    0x18(%ebp),%esi
  801e64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	51                   	push   %ecx
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	6a 06                	push   $0x6
  801e77:	e8 56 ff ff ff       	call   801dd2 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5e                   	pop    %esi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	52                   	push   %edx
  801e96:	50                   	push   %eax
  801e97:	6a 07                	push   $0x7
  801e99:	e8 34 ff ff ff       	call   801dd2 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	6a 08                	push   $0x8
  801eb4:	e8 19 ff ff ff       	call   801dd2 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 09                	push   $0x9
  801ecd:	e8 00 ff ff ff       	call   801dd2 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 0a                	push   $0xa
  801ee6:	e8 e7 fe ff ff       	call   801dd2 <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 0b                	push   $0xb
  801eff:	e8 ce fe ff ff       	call   801dd2 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	6a 0f                	push   $0xf
  801f1a:	e8 b3 fe ff ff       	call   801dd2 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 10                	push   $0x10
  801f36:	e8 97 fe ff ff       	call   801dd2 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	ff 75 10             	pushl  0x10(%ebp)
  801f4b:	ff 75 0c             	pushl  0xc(%ebp)
  801f4e:	ff 75 08             	pushl  0x8(%ebp)
  801f51:	6a 11                	push   $0x11
  801f53:	e8 7a fe ff ff       	call   801dd2 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5b:	90                   	nop
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 0c                	push   $0xc
  801f6d:	e8 60 fe ff ff       	call   801dd2 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	6a 0d                	push   $0xd
  801f87:	e8 46 fe ff ff       	call   801dd2 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 0e                	push   $0xe
  801fa0:	e8 2d fe ff ff       	call   801dd2 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	90                   	nop
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 13                	push   $0x13
  801fba:	e8 13 fe ff ff       	call   801dd2 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	90                   	nop
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 14                	push   $0x14
  801fd4:	e8 f9 fd ff ff       	call   801dd2 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_cputc>:


void
sys_cputc(const char c)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801feb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	50                   	push   %eax
  801ff8:	6a 15                	push   $0x15
  801ffa:	e8 d3 fd ff ff       	call   801dd2 <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
}
  802002:	90                   	nop
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 16                	push   $0x16
  802014:	e8 b9 fd ff ff       	call   801dd2 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	90                   	nop
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	50                   	push   %eax
  80202f:	6a 17                	push   $0x17
  802031:	e8 9c fd ff ff       	call   801dd2 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80203e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	52                   	push   %edx
  80204b:	50                   	push   %eax
  80204c:	6a 1a                	push   $0x1a
  80204e:	e8 7f fd ff ff       	call   801dd2 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 18                	push   $0x18
  80206b:	e8 62 fd ff ff       	call   801dd2 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	90                   	nop
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	52                   	push   %edx
  802086:	50                   	push   %eax
  802087:	6a 19                	push   $0x19
  802089:	e8 44 fd ff ff       	call   801dd2 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	90                   	nop
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	8b 45 10             	mov    0x10(%ebp),%eax
  80209d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	6a 00                	push   $0x0
  8020ac:	51                   	push   %ecx
  8020ad:	52                   	push   %edx
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	50                   	push   %eax
  8020b2:	6a 1b                	push   $0x1b
  8020b4:	e8 19 fd ff ff       	call   801dd2 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	52                   	push   %edx
  8020ce:	50                   	push   %eax
  8020cf:	6a 1c                	push   $0x1c
  8020d1:	e8 fc fc ff ff       	call   801dd2 <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	51                   	push   %ecx
  8020ec:	52                   	push   %edx
  8020ed:	50                   	push   %eax
  8020ee:	6a 1d                	push   $0x1d
  8020f0:	e8 dd fc ff ff       	call   801dd2 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	52                   	push   %edx
  80210a:	50                   	push   %eax
  80210b:	6a 1e                	push   $0x1e
  80210d:	e8 c0 fc ff ff       	call   801dd2 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 1f                	push   $0x1f
  802126:	e8 a7 fc ff ff       	call   801dd2 <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	6a 00                	push   $0x0
  802138:	ff 75 14             	pushl  0x14(%ebp)
  80213b:	ff 75 10             	pushl  0x10(%ebp)
  80213e:	ff 75 0c             	pushl  0xc(%ebp)
  802141:	50                   	push   %eax
  802142:	6a 20                	push   $0x20
  802144:	e8 89 fc ff ff       	call   801dd2 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	50                   	push   %eax
  80215d:	6a 21                	push   $0x21
  80215f:	e8 6e fc ff ff       	call   801dd2 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	90                   	nop
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	50                   	push   %eax
  802179:	6a 22                	push   $0x22
  80217b:	e8 52 fc ff ff       	call   801dd2 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 02                	push   $0x2
  802194:	e8 39 fc ff ff       	call   801dd2 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 03                	push   $0x3
  8021ad:	e8 20 fc ff ff       	call   801dd2 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 04                	push   $0x4
  8021c6:	e8 07 fc ff ff       	call   801dd2 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_exit_env>:


void sys_exit_env(void)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 23                	push   $0x23
  8021df:	e8 ee fb ff ff       	call   801dd2 <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
}
  8021e7:	90                   	nop
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021f3:	8d 50 04             	lea    0x4(%eax),%edx
  8021f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	52                   	push   %edx
  802200:	50                   	push   %eax
  802201:	6a 24                	push   $0x24
  802203:	e8 ca fb ff ff       	call   801dd2 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
	return result;
  80220b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80220e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802211:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802214:	89 01                	mov    %eax,(%ecx)
  802216:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	c9                   	leave  
  80221d:	c2 04 00             	ret    $0x4

00802220 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	ff 75 10             	pushl  0x10(%ebp)
  80222a:	ff 75 0c             	pushl  0xc(%ebp)
  80222d:	ff 75 08             	pushl  0x8(%ebp)
  802230:	6a 12                	push   $0x12
  802232:	e8 9b fb ff ff       	call   801dd2 <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
	return ;
  80223a:	90                   	nop
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_rcr2>:
uint32 sys_rcr2()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 25                	push   $0x25
  80224c:	e8 81 fb ff ff       	call   801dd2 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802262:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	50                   	push   %eax
  80226f:	6a 26                	push   $0x26
  802271:	e8 5c fb ff ff       	call   801dd2 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
	return ;
  802279:	90                   	nop
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <rsttst>:
void rsttst()
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 28                	push   $0x28
  80228b:	e8 42 fb ff ff       	call   801dd2 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
	return ;
  802293:	90                   	nop
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	8b 45 14             	mov    0x14(%ebp),%eax
  80229f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022a2:	8b 55 18             	mov    0x18(%ebp),%edx
  8022a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a9:	52                   	push   %edx
  8022aa:	50                   	push   %eax
  8022ab:	ff 75 10             	pushl  0x10(%ebp)
  8022ae:	ff 75 0c             	pushl  0xc(%ebp)
  8022b1:	ff 75 08             	pushl  0x8(%ebp)
  8022b4:	6a 27                	push   $0x27
  8022b6:	e8 17 fb ff ff       	call   801dd2 <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022be:	90                   	nop
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <chktst>:
void chktst(uint32 n)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	6a 29                	push   $0x29
  8022d1:	e8 fc fa ff ff       	call   801dd2 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d9:	90                   	nop
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <inctst>:

void inctst()
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 2a                	push   $0x2a
  8022eb:	e8 e2 fa ff ff       	call   801dd2 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f3:	90                   	nop
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <gettst>:
uint32 gettst()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 2b                	push   $0x2b
  802305:	e8 c8 fa ff ff       	call   801dd2 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 2c                	push   $0x2c
  802321:	e8 ac fa ff ff       	call   801dd2 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
  802329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80232c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802330:	75 07                	jne    802339 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802332:	b8 01 00 00 00       	mov    $0x1,%eax
  802337:	eb 05                	jmp    80233e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 2c                	push   $0x2c
  802352:	e8 7b fa ff ff       	call   801dd2 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
  80235a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80235d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802361:	75 07                	jne    80236a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802363:	b8 01 00 00 00       	mov    $0x1,%eax
  802368:	eb 05                	jmp    80236f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 2c                	push   $0x2c
  802383:	e8 4a fa ff ff       	call   801dd2 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
  80238b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80238e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802392:	75 07                	jne    80239b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802394:	b8 01 00 00 00       	mov    $0x1,%eax
  802399:	eb 05                	jmp    8023a0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 2c                	push   $0x2c
  8023b4:	e8 19 fa ff ff       	call   801dd2 <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
  8023bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023bf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023c3:	75 07                	jne    8023cc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ca:	eb 05                	jmp    8023d1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	ff 75 08             	pushl  0x8(%ebp)
  8023e1:	6a 2d                	push   $0x2d
  8023e3:	e8 ea f9 ff ff       	call   801dd2 <syscall>
  8023e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023eb:	90                   	nop
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	6a 00                	push   $0x0
  802400:	53                   	push   %ebx
  802401:	51                   	push   %ecx
  802402:	52                   	push   %edx
  802403:	50                   	push   %eax
  802404:	6a 2e                	push   $0x2e
  802406:	e8 c7 f9 ff ff       	call   801dd2 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802416:	8b 55 0c             	mov    0xc(%ebp),%edx
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	52                   	push   %edx
  802423:	50                   	push   %eax
  802424:	6a 2f                	push   $0x2f
  802426:	e8 a7 f9 ff ff       	call   801dd2 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <__udivdi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80243b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80243f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802447:	89 ca                	mov    %ecx,%edx
  802449:	89 f8                	mov    %edi,%eax
  80244b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80244f:	85 f6                	test   %esi,%esi
  802451:	75 2d                	jne    802480 <__udivdi3+0x50>
  802453:	39 cf                	cmp    %ecx,%edi
  802455:	77 65                	ja     8024bc <__udivdi3+0x8c>
  802457:	89 fd                	mov    %edi,%ebp
  802459:	85 ff                	test   %edi,%edi
  80245b:	75 0b                	jne    802468 <__udivdi3+0x38>
  80245d:	b8 01 00 00 00       	mov    $0x1,%eax
  802462:	31 d2                	xor    %edx,%edx
  802464:	f7 f7                	div    %edi
  802466:	89 c5                	mov    %eax,%ebp
  802468:	31 d2                	xor    %edx,%edx
  80246a:	89 c8                	mov    %ecx,%eax
  80246c:	f7 f5                	div    %ebp
  80246e:	89 c1                	mov    %eax,%ecx
  802470:	89 d8                	mov    %ebx,%eax
  802472:	f7 f5                	div    %ebp
  802474:	89 cf                	mov    %ecx,%edi
  802476:	89 fa                	mov    %edi,%edx
  802478:	83 c4 1c             	add    $0x1c,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    
  802480:	39 ce                	cmp    %ecx,%esi
  802482:	77 28                	ja     8024ac <__udivdi3+0x7c>
  802484:	0f bd fe             	bsr    %esi,%edi
  802487:	83 f7 1f             	xor    $0x1f,%edi
  80248a:	75 40                	jne    8024cc <__udivdi3+0x9c>
  80248c:	39 ce                	cmp    %ecx,%esi
  80248e:	72 0a                	jb     80249a <__udivdi3+0x6a>
  802490:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802494:	0f 87 9e 00 00 00    	ja     802538 <__udivdi3+0x108>
  80249a:	b8 01 00 00 00       	mov    $0x1,%eax
  80249f:	89 fa                	mov    %edi,%edx
  8024a1:	83 c4 1c             	add    $0x1c,%esp
  8024a4:	5b                   	pop    %ebx
  8024a5:	5e                   	pop    %esi
  8024a6:	5f                   	pop    %edi
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    
  8024a9:	8d 76 00             	lea    0x0(%esi),%esi
  8024ac:	31 ff                	xor    %edi,%edi
  8024ae:	31 c0                	xor    %eax,%eax
  8024b0:	89 fa                	mov    %edi,%edx
  8024b2:	83 c4 1c             	add    $0x1c,%esp
  8024b5:	5b                   	pop    %ebx
  8024b6:	5e                   	pop    %esi
  8024b7:	5f                   	pop    %edi
  8024b8:	5d                   	pop    %ebp
  8024b9:	c3                   	ret    
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	89 d8                	mov    %ebx,%eax
  8024be:	f7 f7                	div    %edi
  8024c0:	31 ff                	xor    %edi,%edi
  8024c2:	89 fa                	mov    %edi,%edx
  8024c4:	83 c4 1c             	add    $0x1c,%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    
  8024cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024d1:	89 eb                	mov    %ebp,%ebx
  8024d3:	29 fb                	sub    %edi,%ebx
  8024d5:	89 f9                	mov    %edi,%ecx
  8024d7:	d3 e6                	shl    %cl,%esi
  8024d9:	89 c5                	mov    %eax,%ebp
  8024db:	88 d9                	mov    %bl,%cl
  8024dd:	d3 ed                	shr    %cl,%ebp
  8024df:	89 e9                	mov    %ebp,%ecx
  8024e1:	09 f1                	or     %esi,%ecx
  8024e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024e7:	89 f9                	mov    %edi,%ecx
  8024e9:	d3 e0                	shl    %cl,%eax
  8024eb:	89 c5                	mov    %eax,%ebp
  8024ed:	89 d6                	mov    %edx,%esi
  8024ef:	88 d9                	mov    %bl,%cl
  8024f1:	d3 ee                	shr    %cl,%esi
  8024f3:	89 f9                	mov    %edi,%ecx
  8024f5:	d3 e2                	shl    %cl,%edx
  8024f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024fb:	88 d9                	mov    %bl,%cl
  8024fd:	d3 e8                	shr    %cl,%eax
  8024ff:	09 c2                	or     %eax,%edx
  802501:	89 d0                	mov    %edx,%eax
  802503:	89 f2                	mov    %esi,%edx
  802505:	f7 74 24 0c          	divl   0xc(%esp)
  802509:	89 d6                	mov    %edx,%esi
  80250b:	89 c3                	mov    %eax,%ebx
  80250d:	f7 e5                	mul    %ebp
  80250f:	39 d6                	cmp    %edx,%esi
  802511:	72 19                	jb     80252c <__udivdi3+0xfc>
  802513:	74 0b                	je     802520 <__udivdi3+0xf0>
  802515:	89 d8                	mov    %ebx,%eax
  802517:	31 ff                	xor    %edi,%edi
  802519:	e9 58 ff ff ff       	jmp    802476 <__udivdi3+0x46>
  80251e:	66 90                	xchg   %ax,%ax
  802520:	8b 54 24 08          	mov    0x8(%esp),%edx
  802524:	89 f9                	mov    %edi,%ecx
  802526:	d3 e2                	shl    %cl,%edx
  802528:	39 c2                	cmp    %eax,%edx
  80252a:	73 e9                	jae    802515 <__udivdi3+0xe5>
  80252c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80252f:	31 ff                	xor    %edi,%edi
  802531:	e9 40 ff ff ff       	jmp    802476 <__udivdi3+0x46>
  802536:	66 90                	xchg   %ax,%ax
  802538:	31 c0                	xor    %eax,%eax
  80253a:	e9 37 ff ff ff       	jmp    802476 <__udivdi3+0x46>
  80253f:	90                   	nop

00802540 <__umoddi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 1c             	sub    $0x1c,%esp
  802547:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80254b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80254f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802553:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802557:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80255b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80255f:	89 f3                	mov    %esi,%ebx
  802561:	89 fa                	mov    %edi,%edx
  802563:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802567:	89 34 24             	mov    %esi,(%esp)
  80256a:	85 c0                	test   %eax,%eax
  80256c:	75 1a                	jne    802588 <__umoddi3+0x48>
  80256e:	39 f7                	cmp    %esi,%edi
  802570:	0f 86 a2 00 00 00    	jbe    802618 <__umoddi3+0xd8>
  802576:	89 c8                	mov    %ecx,%eax
  802578:	89 f2                	mov    %esi,%edx
  80257a:	f7 f7                	div    %edi
  80257c:	89 d0                	mov    %edx,%eax
  80257e:	31 d2                	xor    %edx,%edx
  802580:	83 c4 1c             	add    $0x1c,%esp
  802583:	5b                   	pop    %ebx
  802584:	5e                   	pop    %esi
  802585:	5f                   	pop    %edi
  802586:	5d                   	pop    %ebp
  802587:	c3                   	ret    
  802588:	39 f0                	cmp    %esi,%eax
  80258a:	0f 87 ac 00 00 00    	ja     80263c <__umoddi3+0xfc>
  802590:	0f bd e8             	bsr    %eax,%ebp
  802593:	83 f5 1f             	xor    $0x1f,%ebp
  802596:	0f 84 ac 00 00 00    	je     802648 <__umoddi3+0x108>
  80259c:	bf 20 00 00 00       	mov    $0x20,%edi
  8025a1:	29 ef                	sub    %ebp,%edi
  8025a3:	89 fe                	mov    %edi,%esi
  8025a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	d3 e0                	shl    %cl,%eax
  8025ad:	89 d7                	mov    %edx,%edi
  8025af:	89 f1                	mov    %esi,%ecx
  8025b1:	d3 ef                	shr    %cl,%edi
  8025b3:	09 c7                	or     %eax,%edi
  8025b5:	89 e9                	mov    %ebp,%ecx
  8025b7:	d3 e2                	shl    %cl,%edx
  8025b9:	89 14 24             	mov    %edx,(%esp)
  8025bc:	89 d8                	mov    %ebx,%eax
  8025be:	d3 e0                	shl    %cl,%eax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c6:	d3 e0                	shl    %cl,%eax
  8025c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025d0:	89 f1                	mov    %esi,%ecx
  8025d2:	d3 e8                	shr    %cl,%eax
  8025d4:	09 d0                	or     %edx,%eax
  8025d6:	d3 eb                	shr    %cl,%ebx
  8025d8:	89 da                	mov    %ebx,%edx
  8025da:	f7 f7                	div    %edi
  8025dc:	89 d3                	mov    %edx,%ebx
  8025de:	f7 24 24             	mull   (%esp)
  8025e1:	89 c6                	mov    %eax,%esi
  8025e3:	89 d1                	mov    %edx,%ecx
  8025e5:	39 d3                	cmp    %edx,%ebx
  8025e7:	0f 82 87 00 00 00    	jb     802674 <__umoddi3+0x134>
  8025ed:	0f 84 91 00 00 00    	je     802684 <__umoddi3+0x144>
  8025f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025f7:	29 f2                	sub    %esi,%edx
  8025f9:	19 cb                	sbb    %ecx,%ebx
  8025fb:	89 d8                	mov    %ebx,%eax
  8025fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802601:	d3 e0                	shl    %cl,%eax
  802603:	89 e9                	mov    %ebp,%ecx
  802605:	d3 ea                	shr    %cl,%edx
  802607:	09 d0                	or     %edx,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	d3 eb                	shr    %cl,%ebx
  80260d:	89 da                	mov    %ebx,%edx
  80260f:	83 c4 1c             	add    $0x1c,%esp
  802612:	5b                   	pop    %ebx
  802613:	5e                   	pop    %esi
  802614:	5f                   	pop    %edi
  802615:	5d                   	pop    %ebp
  802616:	c3                   	ret    
  802617:	90                   	nop
  802618:	89 fd                	mov    %edi,%ebp
  80261a:	85 ff                	test   %edi,%edi
  80261c:	75 0b                	jne    802629 <__umoddi3+0xe9>
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	31 d2                	xor    %edx,%edx
  802625:	f7 f7                	div    %edi
  802627:	89 c5                	mov    %eax,%ebp
  802629:	89 f0                	mov    %esi,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	f7 f5                	div    %ebp
  80262f:	89 c8                	mov    %ecx,%eax
  802631:	f7 f5                	div    %ebp
  802633:	89 d0                	mov    %edx,%eax
  802635:	e9 44 ff ff ff       	jmp    80257e <__umoddi3+0x3e>
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	89 c8                	mov    %ecx,%eax
  80263e:	89 f2                	mov    %esi,%edx
  802640:	83 c4 1c             	add    $0x1c,%esp
  802643:	5b                   	pop    %ebx
  802644:	5e                   	pop    %esi
  802645:	5f                   	pop    %edi
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    
  802648:	3b 04 24             	cmp    (%esp),%eax
  80264b:	72 06                	jb     802653 <__umoddi3+0x113>
  80264d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802651:	77 0f                	ja     802662 <__umoddi3+0x122>
  802653:	89 f2                	mov    %esi,%edx
  802655:	29 f9                	sub    %edi,%ecx
  802657:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80265b:	89 14 24             	mov    %edx,(%esp)
  80265e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802662:	8b 44 24 04          	mov    0x4(%esp),%eax
  802666:	8b 14 24             	mov    (%esp),%edx
  802669:	83 c4 1c             	add    $0x1c,%esp
  80266c:	5b                   	pop    %ebx
  80266d:	5e                   	pop    %esi
  80266e:	5f                   	pop    %edi
  80266f:	5d                   	pop    %ebp
  802670:	c3                   	ret    
  802671:	8d 76 00             	lea    0x0(%esi),%esi
  802674:	2b 04 24             	sub    (%esp),%eax
  802677:	19 fa                	sbb    %edi,%edx
  802679:	89 d1                	mov    %edx,%ecx
  80267b:	89 c6                	mov    %eax,%esi
  80267d:	e9 71 ff ff ff       	jmp    8025f3 <__umoddi3+0xb3>
  802682:	66 90                	xchg   %ax,%ax
  802684:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802688:	72 ea                	jb     802674 <__umoddi3+0x134>
  80268a:	89 d9                	mov    %ebx,%ecx
  80268c:	e9 62 ff ff ff       	jmp    8025f3 <__umoddi3+0xb3>
