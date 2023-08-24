
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 c0 09 00 00       	call   8009f6 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 30 80 00       	mov    0x803020,%eax
  800054:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 30 80 00       	mov    0x803020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 a0 25 80 00       	push   $0x8025a0
  800095:	6a 14                	push   $0x14
  800097:	68 bc 25 80 00       	push   $0x8025bc
  80009c:	e8 a4 0a 00 00       	call   800b45 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 f2 1a 00 00       	call   801b9d <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 8c 20 00 00       	call   802144 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 de 1c 00 00       	call   801dac <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 b1 1c 00 00       	call   801dac <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 49 1d 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 86 1a 00 00       	call   801b9d <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 d0 25 80 00       	push   $0x8025d0
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 bc 25 80 00       	push   $0x8025bc
  800133:	e8 0d 0a 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 0f 1d 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 38 26 80 00       	push   $0x802638
  80014f:	6a 2e                	push   $0x2e
  800151:	68 bc 25 80 00       	push   $0x8025bc
  800156:	e8 ea 09 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  80015b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800163:	48                   	dec    %eax
  800164:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  80016a:	e8 3d 1c 00 00       	call   801dac <sys_calculate_free_frames>
  80016f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800172:	e8 d5 1c 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800177:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017d:	01 c0                	add    %eax,%eax
  80017f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 12 1a 00 00       	call   801b9d <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800191:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a0:	39 c2                	cmp    %eax,%edx
  8001a2:	73 14                	jae    8001b8 <_main+0x180>
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 d0 25 80 00       	push   $0x8025d0
  8001ac:	6a 35                	push   $0x35
  8001ae:	68 bc 25 80 00       	push   $0x8025bc
  8001b3:	e8 8d 09 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001b8:	e8 8f 1c 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8001bd:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001c0:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c5:	74 14                	je     8001db <_main+0x1a3>
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	68 38 26 80 00       	push   $0x802638
  8001cf:	6a 36                	push   $0x36
  8001d1:	68 bc 25 80 00       	push   $0x8025bc
  8001d6:	e8 6a 09 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001de:	01 c0                	add    %eax,%eax
  8001e0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001e3:	48                   	dec    %eax
  8001e4:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001ea:	e8 bd 1b 00 00       	call   801dac <sys_calculate_free_frames>
  8001ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f2:	e8 55 1c 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8001f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001fd:	01 c0                	add    %eax,%eax
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	50                   	push   %eax
  800203:	e8 95 19 00 00       	call   801b9d <malloc>
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80020e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800211:	89 c2                	mov    %eax,%edx
  800213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800216:	c1 e0 02             	shl    $0x2,%eax
  800219:	05 00 00 00 80       	add    $0x80000000,%eax
  80021e:	39 c2                	cmp    %eax,%edx
  800220:	73 14                	jae    800236 <_main+0x1fe>
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	68 d0 25 80 00       	push   $0x8025d0
  80022a:	6a 3d                	push   $0x3d
  80022c:	68 bc 25 80 00       	push   $0x8025bc
  800231:	e8 0f 09 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800236:	e8 11 1c 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80023b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80023e:	83 f8 01             	cmp    $0x1,%eax
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 38 26 80 00       	push   $0x802638
  80024b:	6a 3e                	push   $0x3e
  80024d:	68 bc 25 80 00       	push   $0x8025bc
  800252:	e8 ee 08 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  800257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	48                   	dec    %eax
  80025d:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800263:	e8 44 1b 00 00       	call   801dac <sys_calculate_free_frames>
  800268:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80026b:	e8 dc 1b 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800270:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800276:	01 c0                	add    %eax,%eax
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	50                   	push   %eax
  80027c:	e8 1c 19 00 00       	call   801b9d <malloc>
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800287:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80028a:	89 c2                	mov    %eax,%edx
  80028c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80028f:	c1 e0 02             	shl    $0x2,%eax
  800292:	89 c1                	mov    %eax,%ecx
  800294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800297:	c1 e0 02             	shl    $0x2,%eax
  80029a:	01 c8                	add    %ecx,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c2                	cmp    %eax,%edx
  8002a3:	73 14                	jae    8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 d0 25 80 00       	push   $0x8025d0
  8002ad:	6a 45                	push   $0x45
  8002af:	68 bc 25 80 00       	push   $0x8025bc
  8002b4:	e8 8c 08 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  8002b9:	e8 8e 1b 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8002be:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002c1:	83 f8 01             	cmp    $0x1,%eax
  8002c4:	74 14                	je     8002da <_main+0x2a2>
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	68 38 26 80 00       	push   $0x802638
  8002ce:	6a 46                	push   $0x46
  8002d0:	68 bc 25 80 00       	push   $0x8025bc
  8002d5:	e8 6b 08 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002dd:	01 c0                	add    %eax,%eax
  8002df:	48                   	dec    %eax
  8002e0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002e6:	e8 c1 1a 00 00       	call   801dac <sys_calculate_free_frames>
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ee:	e8 59 1b 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8002f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f9:	89 d0                	mov    %edx,%eax
  8002fb:	01 c0                	add    %eax,%eax
  8002fd:	01 d0                	add    %edx,%eax
  8002ff:	01 c0                	add    %eax,%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	50                   	push   %eax
  800307:	e8 91 18 00 00       	call   801b9d <malloc>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800312:	8b 45 90             	mov    -0x70(%ebp),%eax
  800315:	89 c2                	mov    %eax,%edx
  800317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80031a:	c1 e0 02             	shl    $0x2,%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800322:	c1 e0 03             	shl    $0x3,%eax
  800325:	01 c8                	add    %ecx,%eax
  800327:	05 00 00 00 80       	add    $0x80000000,%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	73 14                	jae    800344 <_main+0x30c>
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	68 d0 25 80 00       	push   $0x8025d0
  800338:	6a 4d                	push   $0x4d
  80033a:	68 bc 25 80 00       	push   $0x8025bc
  80033f:	e8 01 08 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800344:	e8 03 1b 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800349:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 38 26 80 00       	push   $0x802638
  800359:	6a 4e                	push   $0x4e
  80035b:	68 bc 25 80 00       	push   $0x8025bc
  800360:	e8 e0 07 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	48                   	dec    %eax
  800373:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800379:	e8 2e 1a 00 00       	call   801dac <sys_calculate_free_frames>
  80037e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800381:	e8 c6 1a 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800386:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80038c:	89 c2                	mov    %eax,%edx
  80038e:	01 d2                	add    %edx,%edx
  800390:	01 d0                	add    %edx,%eax
  800392:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800395:	83 ec 0c             	sub    $0xc,%esp
  800398:	50                   	push   %eax
  800399:	e8 ff 17 00 00       	call   801b9d <malloc>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8003a4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003a7:	89 c2                	mov    %eax,%edx
  8003a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ac:	c1 e0 02             	shl    $0x2,%eax
  8003af:	89 c1                	mov    %eax,%ecx
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	c1 e0 04             	shl    $0x4,%eax
  8003b7:	01 c8                	add    %ecx,%eax
  8003b9:	05 00 00 00 80       	add    $0x80000000,%eax
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	73 14                	jae    8003d6 <_main+0x39e>
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	68 d0 25 80 00       	push   $0x8025d0
  8003ca:	6a 55                	push   $0x55
  8003cc:	68 bc 25 80 00       	push   $0x8025bc
  8003d1:	e8 6f 07 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8003d6:	e8 71 1a 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8003db:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003de:	89 c2                	mov    %eax,%edx
  8003e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e3:	89 c1                	mov    %eax,%ecx
  8003e5:	01 c9                	add    %ecx,%ecx
  8003e7:	01 c8                	add    %ecx,%eax
  8003e9:	85 c0                	test   %eax,%eax
  8003eb:	79 05                	jns    8003f2 <_main+0x3ba>
  8003ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003f2:	c1 f8 0c             	sar    $0xc,%eax
  8003f5:	39 c2                	cmp    %eax,%edx
  8003f7:	74 14                	je     80040d <_main+0x3d5>
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	68 38 26 80 00       	push   $0x802638
  800401:	6a 56                	push   $0x56
  800403:	68 bc 25 80 00       	push   $0x8025bc
  800408:	e8 38 07 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  80040d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800410:	89 c2                	mov    %eax,%edx
  800412:	01 d2                	add    %edx,%edx
  800414:	01 d0                	add    %edx,%eax
  800416:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800419:	48                   	dec    %eax
  80041a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800420:	e8 87 19 00 00       	call   801dac <sys_calculate_free_frames>
  800425:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800428:	e8 1f 1a 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80042d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800433:	01 c0                	add    %eax,%eax
  800435:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	50                   	push   %eax
  80043c:	e8 5c 17 00 00       	call   801b9d <malloc>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800447:	8b 45 98             	mov    -0x68(%ebp),%eax
  80044a:	89 c1                	mov    %eax,%ecx
  80044c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044f:	89 d0                	mov    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045e:	c1 e0 04             	shl    $0x4,%eax
  800461:	01 d0                	add    %edx,%eax
  800463:	05 00 00 00 80       	add    $0x80000000,%eax
  800468:	39 c1                	cmp    %eax,%ecx
  80046a:	73 14                	jae    800480 <_main+0x448>
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	68 d0 25 80 00       	push   $0x8025d0
  800474:	6a 5d                	push   $0x5d
  800476:	68 bc 25 80 00       	push   $0x8025bc
  80047b:	e8 c5 06 00 00       	call   800b45 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800480:	e8 c7 19 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800485:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800488:	3d 00 02 00 00       	cmp    $0x200,%eax
  80048d:	74 14                	je     8004a3 <_main+0x46b>
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	68 38 26 80 00       	push   $0x802638
  800497:	6a 5e                	push   $0x5e
  800499:	68 bc 25 80 00       	push   $0x8025bc
  80049e:	e8 a2 06 00 00       	call   800b45 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  8004a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004a6:	01 c0                	add    %eax,%eax
  8004a8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004ab:	48                   	dec    %eax
  8004ac:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 f5 18 00 00       	call   801dac <sys_calculate_free_frames>
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004ba:	e8 8d 19 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  8004c2:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 10 17 00 00       	call   801bde <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004d1:	e8 76 19 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8004d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d9:	29 c2                	sub    %eax,%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004e2:	74 14                	je     8004f8 <_main+0x4c0>
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	68 68 26 80 00       	push   $0x802668
  8004ec:	6a 6b                	push   $0x6b
  8004ee:	68 bc 25 80 00       	push   $0x8025bc
  8004f3:	e8 4d 06 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004f8:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800501:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800504:	e8 22 1c 00 00       	call   80212b <sys_rcr2>
  800509:	89 c2                	mov    %eax,%edx
  80050b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80050e:	39 c2                	cmp    %eax,%edx
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 a4 26 80 00       	push   $0x8026a4
  80051a:	6a 6f                	push   $0x6f
  80051c:	68 bc 25 80 00       	push   $0x8025bc
  800521:	e8 1f 06 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[0]] = 10;
  800526:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80052c:	89 c2                	mov    %eax,%edx
  80052e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800536:	e8 f0 1b 00 00       	call   80212b <sys_rcr2>
  80053b:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800541:	89 d1                	mov    %edx,%ecx
  800543:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800546:	01 ca                	add    %ecx,%edx
  800548:	39 d0                	cmp    %edx,%eax
  80054a:	74 14                	je     800560 <_main+0x528>
  80054c:	83 ec 04             	sub    $0x4,%esp
  80054f:	68 a4 26 80 00       	push   $0x8026a4
  800554:	6a 71                	push   $0x71
  800556:	68 bc 25 80 00       	push   $0x8025bc
  80055b:	e8 e5 05 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800560:	e8 47 18 00 00       	call   801dac <sys_calculate_free_frames>
  800565:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800568:	e8 df 18 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80056d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800570:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 62 16 00 00       	call   801bde <free>
  80057c:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80057f:	e8 c8 18 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800584:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800587:	29 c2                	sub    %eax,%edx
  800589:	89 d0                	mov    %edx,%eax
  80058b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800590:	74 14                	je     8005a6 <_main+0x56e>
  800592:	83 ec 04             	sub    $0x4,%esp
  800595:	68 68 26 80 00       	push   $0x802668
  80059a:	6a 76                	push   $0x76
  80059c:	68 bc 25 80 00       	push   $0x8025bc
  8005a1:	e8 9f 05 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  8005a6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8005ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005af:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005b2:	e8 74 1b 00 00       	call   80212b <sys_rcr2>
  8005b7:	89 c2                	mov    %eax,%edx
  8005b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	74 14                	je     8005d4 <_main+0x59c>
  8005c0:	83 ec 04             	sub    $0x4,%esp
  8005c3:	68 a4 26 80 00       	push   $0x8026a4
  8005c8:	6a 7a                	push   $0x7a
  8005ca:	68 bc 25 80 00       	push   $0x8025bc
  8005cf:	e8 71 05 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[1]] = 10;
  8005d4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  8005da:	89 c2                	mov    %eax,%edx
  8005dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005e4:	e8 42 1b 00 00       	call   80212b <sys_rcr2>
  8005e9:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ef:	89 d1                	mov    %edx,%ecx
  8005f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005f4:	01 ca                	add    %ecx,%edx
  8005f6:	39 d0                	cmp    %edx,%eax
  8005f8:	74 14                	je     80060e <_main+0x5d6>
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	68 a4 26 80 00       	push   $0x8026a4
  800602:	6a 7c                	push   $0x7c
  800604:	68 bc 25 80 00       	push   $0x8025bc
  800609:	e8 37 05 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80060e:	e8 99 17 00 00       	call   801dac <sys_calculate_free_frames>
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800616:	e8 31 18 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80061b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80061e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	50                   	push   %eax
  800625:	e8 b4 15 00 00       	call   801bde <free>
  80062a:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  80062d:	e8 1a 18 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800632:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800635:	29 c2                	sub    %eax,%edx
  800637:	89 d0                	mov    %edx,%eax
  800639:	83 f8 01             	cmp    $0x1,%eax
  80063c:	74 17                	je     800655 <_main+0x61d>
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	68 68 26 80 00       	push   $0x802668
  800646:	68 81 00 00 00       	push   $0x81
  80064b:	68 bc 25 80 00       	push   $0x8025bc
  800650:	e8 f0 04 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  800655:	8b 45 88             	mov    -0x78(%ebp),%eax
  800658:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80065b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800661:	e8 c5 1a 00 00       	call   80212b <sys_rcr2>
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066b:	39 c2                	cmp    %eax,%edx
  80066d:	74 17                	je     800686 <_main+0x64e>
  80066f:	83 ec 04             	sub    $0x4,%esp
  800672:	68 a4 26 80 00       	push   $0x8026a4
  800677:	68 85 00 00 00       	push   $0x85
  80067c:	68 bc 25 80 00       	push   $0x8025bc
  800681:	e8 bf 04 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[2]] = 10;
  800686:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  80068c:	89 c2                	mov    %eax,%edx
  80068e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800691:	01 d0                	add    %edx,%eax
  800693:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800696:	e8 90 1a 00 00       	call   80212b <sys_rcr2>
  80069b:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006a6:	01 ca                	add    %ecx,%edx
  8006a8:	39 d0                	cmp    %edx,%eax
  8006aa:	74 17                	je     8006c3 <_main+0x68b>
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	68 a4 26 80 00       	push   $0x8026a4
  8006b4:	68 87 00 00 00       	push   $0x87
  8006b9:	68 bc 25 80 00       	push   $0x8025bc
  8006be:	e8 82 04 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8006c3:	e8 e4 16 00 00       	call   801dac <sys_calculate_free_frames>
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006cb:	e8 7c 17 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8006d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  8006d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	50                   	push   %eax
  8006da:	e8 ff 14 00 00       	call   801bde <free>
  8006df:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e2:	e8 65 17 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  8006e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ea:	29 c2                	sub    %eax,%edx
  8006ec:	89 d0                	mov    %edx,%eax
  8006ee:	83 f8 01             	cmp    $0x1,%eax
  8006f1:	74 17                	je     80070a <_main+0x6d2>
  8006f3:	83 ec 04             	sub    $0x4,%esp
  8006f6:	68 68 26 80 00       	push   $0x802668
  8006fb:	68 8c 00 00 00       	push   $0x8c
  800700:	68 bc 25 80 00       	push   $0x8025bc
  800705:	e8 3b 04 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  80070a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80070d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800710:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800713:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800716:	e8 10 1a 00 00       	call   80212b <sys_rcr2>
  80071b:	89 c2                	mov    %eax,%edx
  80071d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800720:	39 c2                	cmp    %eax,%edx
  800722:	74 17                	je     80073b <_main+0x703>
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 a4 26 80 00       	push   $0x8026a4
  80072c:	68 90 00 00 00       	push   $0x90
  800731:	68 bc 25 80 00       	push   $0x8025bc
  800736:	e8 0a 04 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[3]] = 10;
  80073b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800746:	01 d0                	add    %edx,%eax
  800748:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80074b:	e8 db 19 00 00       	call   80212b <sys_rcr2>
  800750:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800756:	89 d1                	mov    %edx,%ecx
  800758:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075b:	01 ca                	add    %ecx,%edx
  80075d:	39 d0                	cmp    %edx,%eax
  80075f:	74 17                	je     800778 <_main+0x740>
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	68 a4 26 80 00       	push   $0x8026a4
  800769:	68 92 00 00 00       	push   $0x92
  80076e:	68 bc 25 80 00       	push   $0x8025bc
  800773:	e8 cd 03 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800778:	e8 2f 16 00 00       	call   801dac <sys_calculate_free_frames>
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800780:	e8 c7 16 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800788:	8b 45 90             	mov    -0x70(%ebp),%eax
  80078b:	83 ec 0c             	sub    $0xc,%esp
  80078e:	50                   	push   %eax
  80078f:	e8 4a 14 00 00       	call   801bde <free>
  800794:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  800797:	e8 b0 16 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80079c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079f:	29 c2                	sub    %eax,%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	83 f8 02             	cmp    $0x2,%eax
  8007a6:	74 17                	je     8007bf <_main+0x787>
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	68 68 26 80 00       	push   $0x802668
  8007b0:	68 97 00 00 00       	push   $0x97
  8007b5:	68 bc 25 80 00       	push   $0x8025bc
  8007ba:	e8 86 03 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  8007bf:	8b 45 90             	mov    -0x70(%ebp),%eax
  8007c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8007c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007cb:	e8 5b 19 00 00       	call   80212b <sys_rcr2>
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d5:	39 c2                	cmp    %eax,%edx
  8007d7:	74 17                	je     8007f0 <_main+0x7b8>
  8007d9:	83 ec 04             	sub    $0x4,%esp
  8007dc:	68 a4 26 80 00       	push   $0x8026a4
  8007e1:	68 9b 00 00 00       	push   $0x9b
  8007e6:	68 bc 25 80 00       	push   $0x8025bc
  8007eb:	e8 55 03 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[4]] = 10;
  8007f0:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800800:	e8 26 19 00 00       	call   80212b <sys_rcr2>
  800805:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  80080b:	89 d1                	mov    %edx,%ecx
  80080d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800810:	01 ca                	add    %ecx,%edx
  800812:	39 d0                	cmp    %edx,%eax
  800814:	74 17                	je     80082d <_main+0x7f5>
  800816:	83 ec 04             	sub    $0x4,%esp
  800819:	68 a4 26 80 00       	push   $0x8026a4
  80081e:	68 9d 00 00 00       	push   $0x9d
  800823:	68 bc 25 80 00       	push   $0x8025bc
  800828:	e8 18 03 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80082d:	e8 7a 15 00 00       	call   801dac <sys_calculate_free_frames>
  800832:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800835:	e8 12 16 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80083a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  80083d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800840:	83 ec 0c             	sub    $0xc,%esp
  800843:	50                   	push   %eax
  800844:	e8 95 13 00 00       	call   801bde <free>
  800849:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  80084c:	e8 fb 15 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800854:	89 d1                	mov    %edx,%ecx
  800856:	29 c1                	sub    %eax,%ecx
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	89 c2                	mov    %eax,%edx
  80085d:	01 d2                	add    %edx,%edx
  80085f:	01 d0                	add    %edx,%eax
  800861:	85 c0                	test   %eax,%eax
  800863:	79 05                	jns    80086a <_main+0x832>
  800865:	05 ff 0f 00 00       	add    $0xfff,%eax
  80086a:	c1 f8 0c             	sar    $0xc,%eax
  80086d:	39 c1                	cmp    %eax,%ecx
  80086f:	74 17                	je     800888 <_main+0x850>
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	68 68 26 80 00       	push   $0x802668
  800879:	68 a2 00 00 00       	push   $0xa2
  80087e:	68 bc 25 80 00       	push   $0x8025bc
  800883:	e8 bd 02 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800888:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80088b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80088e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800891:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800894:	e8 92 18 00 00       	call   80212b <sys_rcr2>
  800899:	89 c2                	mov    %eax,%edx
  80089b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	74 17                	je     8008b9 <_main+0x881>
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 a4 26 80 00       	push   $0x8026a4
  8008aa:	68 a6 00 00 00       	push   $0xa6
  8008af:	68 bc 25 80 00       	push   $0x8025bc
  8008b4:	e8 8c 02 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[5]] = 10;
  8008b9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8008bf:	89 c2                	mov    %eax,%edx
  8008c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008c9:	e8 5d 18 00 00       	call   80212b <sys_rcr2>
  8008ce:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  8008d4:	89 d1                	mov    %edx,%ecx
  8008d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008d9:	01 ca                	add    %ecx,%edx
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 17                	je     8008f6 <_main+0x8be>
  8008df:	83 ec 04             	sub    $0x4,%esp
  8008e2:	68 a4 26 80 00       	push   $0x8026a4
  8008e7:	68 a8 00 00 00       	push   $0xa8
  8008ec:	68 bc 25 80 00       	push   $0x8025bc
  8008f1:	e8 4f 02 00 00       	call   800b45 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8008f6:	e8 b1 14 00 00       	call   801dac <sys_calculate_free_frames>
  8008fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fe:	e8 49 15 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  800903:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800906:	8b 45 98             	mov    -0x68(%ebp),%eax
  800909:	83 ec 0c             	sub    $0xc,%esp
  80090c:	50                   	push   %eax
  80090d:	e8 cc 12 00 00       	call   801bde <free>
  800912:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800915:	e8 32 15 00 00       	call   801e4c <sys_pf_calculate_allocated_pages>
  80091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80091d:	29 c2                	sub    %eax,%edx
  80091f:	89 d0                	mov    %edx,%eax
  800921:	3d 00 02 00 00       	cmp    $0x200,%eax
  800926:	74 17                	je     80093f <_main+0x907>
  800928:	83 ec 04             	sub    $0x4,%esp
  80092b:	68 68 26 80 00       	push   $0x802668
  800930:	68 ad 00 00 00       	push   $0xad
  800935:	68 bc 25 80 00       	push   $0x8025bc
  80093a:	e8 06 02 00 00       	call   800b45 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  80093f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800942:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800945:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800948:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80094b:	e8 db 17 00 00       	call   80212b <sys_rcr2>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 17                	je     800970 <_main+0x938>
  800959:	83 ec 04             	sub    $0x4,%esp
  80095c:	68 a4 26 80 00       	push   $0x8026a4
  800961:	68 b1 00 00 00       	push   $0xb1
  800966:	68 bc 25 80 00       	push   $0x8025bc
  80096b:	e8 d5 01 00 00       	call   800b45 <_panic>
		byteArr[lastIndices[6]] = 10;
  800970:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80097b:	01 d0                	add    %edx,%eax
  80097d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800980:	e8 a6 17 00 00       	call   80212b <sys_rcr2>
  800985:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80098b:	89 d1                	mov    %edx,%ecx
  80098d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800990:	01 ca                	add    %ecx,%edx
  800992:	39 d0                	cmp    %edx,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 a4 26 80 00       	push   $0x8026a4
  80099e:	68 b3 00 00 00       	push   $0xb3
  8009a3:	68 bc 25 80 00       	push   $0x8025bc
  8009a8:	e8 98 01 00 00       	call   800b45 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames() + 3) ) {panic("Wrong free: not all pages removed correctly at end");}
  8009ad:	e8 fa 13 00 00       	call   801dac <sys_calculate_free_frames>
  8009b2:	8d 50 03             	lea    0x3(%eax),%edx
  8009b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009b8:	39 c2                	cmp    %eax,%edx
  8009ba:	74 17                	je     8009d3 <_main+0x99b>
  8009bc:	83 ec 04             	sub    $0x4,%esp
  8009bf:	68 e8 26 80 00       	push   $0x8026e8
  8009c4:	68 b5 00 00 00       	push   $0xb5
  8009c9:	68 bc 25 80 00       	push   $0x8025bc
  8009ce:	e8 72 01 00 00       	call   800b45 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8009d3:	83 ec 0c             	sub    $0xc,%esp
  8009d6:	6a 00                	push   $0x0
  8009d8:	e8 67 17 00 00       	call   802144 <sys_bypassPageFault>
  8009dd:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  8009e0:	83 ec 0c             	sub    $0xc,%esp
  8009e3:	68 1c 27 80 00       	push   $0x80271c
  8009e8:	e8 0c 04 00 00       	call   800df9 <cprintf>
  8009ed:	83 c4 10             	add    $0x10,%esp

	return;
  8009f0:	90                   	nop
}
  8009f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8009fc:	e8 8b 16 00 00       	call   80208c <sys_getenvindex>
  800a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a07:	89 d0                	mov    %edx,%eax
  800a09:	01 c0                	add    %eax,%eax
  800a0b:	01 d0                	add    %edx,%eax
  800a0d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a14:	01 c8                	add    %ecx,%eax
  800a16:	c1 e0 02             	shl    $0x2,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a22:	01 c8                	add    %ecx,%eax
  800a24:	c1 e0 02             	shl    $0x2,%eax
  800a27:	01 d0                	add    %edx,%eax
  800a29:	c1 e0 02             	shl    $0x2,%eax
  800a2c:	01 d0                	add    %edx,%eax
  800a2e:	c1 e0 03             	shl    $0x3,%eax
  800a31:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a36:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a3b:	a1 20 30 80 00       	mov    0x803020,%eax
  800a40:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800a46:	84 c0                	test   %al,%al
  800a48:	74 0f                	je     800a59 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800a4a:	a1 20 30 80 00       	mov    0x803020,%eax
  800a4f:	05 18 da 01 00       	add    $0x1da18,%eax
  800a54:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a5d:	7e 0a                	jle    800a69 <libmain+0x73>
		binaryname = argv[0];
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	e8 c1 f5 ff ff       	call   800038 <_main>
  800a77:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800a7a:	e8 1a 14 00 00       	call   801e99 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	68 70 27 80 00       	push   $0x802770
  800a87:	e8 6d 03 00 00       	call   800df9 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a8f:	a1 20 30 80 00       	mov    0x803020,%eax
  800a94:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800a9a:	a1 20 30 80 00       	mov    0x803020,%eax
  800a9f:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	52                   	push   %edx
  800aa9:	50                   	push   %eax
  800aaa:	68 98 27 80 00       	push   $0x802798
  800aaf:	e8 45 03 00 00       	call   800df9 <cprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ab7:	a1 20 30 80 00       	mov    0x803020,%eax
  800abc:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800ac2:	a1 20 30 80 00       	mov    0x803020,%eax
  800ac7:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800acd:	a1 20 30 80 00       	mov    0x803020,%eax
  800ad2:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800ad8:	51                   	push   %ecx
  800ad9:	52                   	push   %edx
  800ada:	50                   	push   %eax
  800adb:	68 c0 27 80 00       	push   $0x8027c0
  800ae0:	e8 14 03 00 00       	call   800df9 <cprintf>
  800ae5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ae8:	a1 20 30 80 00       	mov    0x803020,%eax
  800aed:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	50                   	push   %eax
  800af7:	68 18 28 80 00       	push   $0x802818
  800afc:	e8 f8 02 00 00       	call   800df9 <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800b04:	83 ec 0c             	sub    $0xc,%esp
  800b07:	68 70 27 80 00       	push   $0x802770
  800b0c:	e8 e8 02 00 00       	call   800df9 <cprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b14:	e8 9a 13 00 00       	call   801eb3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b19:	e8 19 00 00 00       	call   800b37 <exit>
}
  800b1e:	90                   	nop
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b27:	83 ec 0c             	sub    $0xc,%esp
  800b2a:	6a 00                	push   $0x0
  800b2c:	e8 27 15 00 00       	call   802058 <sys_destroy_env>
  800b31:	83 c4 10             	add    $0x10,%esp
}
  800b34:	90                   	nop
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <exit>:

void
exit(void)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b3d:	e8 7c 15 00 00       	call   8020be <sys_exit_env>
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800b4b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800b54:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800b59:	85 c0                	test   %eax,%eax
  800b5b:	74 16                	je     800b73 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b5d:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	50                   	push   %eax
  800b66:	68 2c 28 80 00       	push   $0x80282c
  800b6b:	e8 89 02 00 00       	call   800df9 <cprintf>
  800b70:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b73:	a1 00 30 80 00       	mov    0x803000,%eax
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	ff 75 08             	pushl  0x8(%ebp)
  800b7e:	50                   	push   %eax
  800b7f:	68 31 28 80 00       	push   $0x802831
  800b84:	e8 70 02 00 00       	call   800df9 <cprintf>
  800b89:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 f4             	pushl  -0xc(%ebp)
  800b95:	50                   	push   %eax
  800b96:	e8 f3 01 00 00       	call   800d8e <vcprintf>
  800b9b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	6a 00                	push   $0x0
  800ba3:	68 4d 28 80 00       	push   $0x80284d
  800ba8:	e8 e1 01 00 00       	call   800d8e <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800bb0:	e8 82 ff ff ff       	call   800b37 <exit>

	// should not return here
	while (1) ;
  800bb5:	eb fe                	jmp    800bb5 <_panic+0x70>

00800bb7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800bbd:	a1 20 30 80 00       	mov    0x803020,%eax
  800bc2:	8b 50 74             	mov    0x74(%eax),%edx
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	39 c2                	cmp    %eax,%edx
  800bca:	74 14                	je     800be0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800bcc:	83 ec 04             	sub    $0x4,%esp
  800bcf:	68 50 28 80 00       	push   $0x802850
  800bd4:	6a 26                	push   $0x26
  800bd6:	68 9c 28 80 00       	push   $0x80289c
  800bdb:	e8 65 ff ff ff       	call   800b45 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800be0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800be7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bee:	e9 c2 00 00 00       	jmp    800cb5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	01 d0                	add    %edx,%eax
  800c02:	8b 00                	mov    (%eax),%eax
  800c04:	85 c0                	test   %eax,%eax
  800c06:	75 08                	jne    800c10 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800c0b:	e9 a2 00 00 00       	jmp    800cb2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800c10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c17:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c1e:	eb 69                	jmp    800c89 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800c20:	a1 20 30 80 00       	mov    0x803020,%eax
  800c25:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800c2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c2e:	89 d0                	mov    %edx,%eax
  800c30:	01 c0                	add    %eax,%eax
  800c32:	01 d0                	add    %edx,%eax
  800c34:	c1 e0 03             	shl    $0x3,%eax
  800c37:	01 c8                	add    %ecx,%eax
  800c39:	8a 40 04             	mov    0x4(%eax),%al
  800c3c:	84 c0                	test   %al,%al
  800c3e:	75 46                	jne    800c86 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c40:	a1 20 30 80 00       	mov    0x803020,%eax
  800c45:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800c4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	c1 e0 03             	shl    $0x3,%eax
  800c57:	01 c8                	add    %ecx,%eax
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c66:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	01 c8                	add    %ecx,%eax
  800c77:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c79:	39 c2                	cmp    %eax,%edx
  800c7b:	75 09                	jne    800c86 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800c7d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800c84:	eb 12                	jmp    800c98 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c86:	ff 45 e8             	incl   -0x18(%ebp)
  800c89:	a1 20 30 80 00       	mov    0x803020,%eax
  800c8e:	8b 50 74             	mov    0x74(%eax),%edx
  800c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c94:	39 c2                	cmp    %eax,%edx
  800c96:	77 88                	ja     800c20 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c9c:	75 14                	jne    800cb2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c9e:	83 ec 04             	sub    $0x4,%esp
  800ca1:	68 a8 28 80 00       	push   $0x8028a8
  800ca6:	6a 3a                	push   $0x3a
  800ca8:	68 9c 28 80 00       	push   $0x80289c
  800cad:	e8 93 fe ff ff       	call   800b45 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800cb2:	ff 45 f0             	incl   -0x10(%ebp)
  800cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800cbb:	0f 8c 32 ff ff ff    	jl     800bf3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800cc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ccf:	eb 26                	jmp    800cf7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800cd1:	a1 20 30 80 00       	mov    0x803020,%eax
  800cd6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800cdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cdf:	89 d0                	mov    %edx,%eax
  800ce1:	01 c0                	add    %eax,%eax
  800ce3:	01 d0                	add    %edx,%eax
  800ce5:	c1 e0 03             	shl    $0x3,%eax
  800ce8:	01 c8                	add    %ecx,%eax
  800cea:	8a 40 04             	mov    0x4(%eax),%al
  800ced:	3c 01                	cmp    $0x1,%al
  800cef:	75 03                	jne    800cf4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800cf1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cf4:	ff 45 e0             	incl   -0x20(%ebp)
  800cf7:	a1 20 30 80 00       	mov    0x803020,%eax
  800cfc:	8b 50 74             	mov    0x74(%eax),%edx
  800cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d02:	39 c2                	cmp    %eax,%edx
  800d04:	77 cb                	ja     800cd1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d09:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 fc 28 80 00       	push   $0x8028fc
  800d16:	6a 44                	push   $0x44
  800d18:	68 9c 28 80 00       	push   $0x80289c
  800d1d:	e8 23 fe ff ff       	call   800b45 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 48 01             	lea    0x1(%eax),%ecx
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	89 0a                	mov    %ecx,(%edx)
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	88 d1                	mov    %dl,%cl
  800d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d40:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d4e:	75 2c                	jne    800d7c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800d50:	a0 24 30 80 00       	mov    0x803024,%al
  800d55:	0f b6 c0             	movzbl %al,%eax
  800d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5b:	8b 12                	mov    (%edx),%edx
  800d5d:	89 d1                	mov    %edx,%ecx
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	83 c2 08             	add    $0x8,%edx
  800d65:	83 ec 04             	sub    $0x4,%esp
  800d68:	50                   	push   %eax
  800d69:	51                   	push   %ecx
  800d6a:	52                   	push   %edx
  800d6b:	e8 7b 0f 00 00       	call   801ceb <sys_cputs>
  800d70:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8b 40 04             	mov    0x4(%eax),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d8b:	90                   	nop
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d97:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d9e:	00 00 00 
	b.cnt = 0;
  800da1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800da8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	ff 75 08             	pushl  0x8(%ebp)
  800db1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800db7:	50                   	push   %eax
  800db8:	68 25 0d 80 00       	push   $0x800d25
  800dbd:	e8 11 02 00 00       	call   800fd3 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800dc5:	a0 24 30 80 00       	mov    0x803024,%al
  800dca:	0f b6 c0             	movzbl %al,%eax
  800dcd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800dd3:	83 ec 04             	sub    $0x4,%esp
  800dd6:	50                   	push   %eax
  800dd7:	52                   	push   %edx
  800dd8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800dde:	83 c0 08             	add    $0x8,%eax
  800de1:	50                   	push   %eax
  800de2:	e8 04 0f 00 00       	call   801ceb <sys_cputs>
  800de7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800dea:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800df1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <cprintf>:

int cprintf(const char *fmt, ...) {
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800dff:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800e06:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 f4             	pushl  -0xc(%ebp)
  800e15:	50                   	push   %eax
  800e16:	e8 73 ff ff ff       	call   800d8e <vcprintf>
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800e2c:	e8 68 10 00 00       	call   801e99 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e31:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e40:	50                   	push   %eax
  800e41:	e8 48 ff ff ff       	call   800d8e <vcprintf>
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e4c:	e8 62 10 00 00       	call   801eb3 <sys_enable_interrupt>
	return cnt;
  800e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 14             	sub    $0x14,%esp
  800e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e63:	8b 45 14             	mov    0x14(%ebp),%eax
  800e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e69:	8b 45 18             	mov    0x18(%ebp),%eax
  800e6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e71:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e74:	77 55                	ja     800ecb <printnum+0x75>
  800e76:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e79:	72 05                	jb     800e80 <printnum+0x2a>
  800e7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e7e:	77 4b                	ja     800ecb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e80:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e83:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e86:	8b 45 18             	mov    0x18(%ebp),%eax
  800e89:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8e:	52                   	push   %edx
  800e8f:	50                   	push   %eax
  800e90:	ff 75 f4             	pushl  -0xc(%ebp)
  800e93:	ff 75 f0             	pushl  -0x10(%ebp)
  800e96:	e8 85 14 00 00       	call   802320 <__udivdi3>
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	ff 75 20             	pushl  0x20(%ebp)
  800ea4:	53                   	push   %ebx
  800ea5:	ff 75 18             	pushl  0x18(%ebp)
  800ea8:	52                   	push   %edx
  800ea9:	50                   	push   %eax
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	e8 a1 ff ff ff       	call   800e56 <printnum>
  800eb5:	83 c4 20             	add    $0x20,%esp
  800eb8:	eb 1a                	jmp    800ed4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	ff 75 0c             	pushl  0xc(%ebp)
  800ec0:	ff 75 20             	pushl  0x20(%ebp)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	ff d0                	call   *%eax
  800ec8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ecb:	ff 4d 1c             	decl   0x1c(%ebp)
  800ece:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ed2:	7f e6                	jg     800eba <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ed4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee2:	53                   	push   %ebx
  800ee3:	51                   	push   %ecx
  800ee4:	52                   	push   %edx
  800ee5:	50                   	push   %eax
  800ee6:	e8 45 15 00 00       	call   802430 <__umoddi3>
  800eeb:	83 c4 10             	add    $0x10,%esp
  800eee:	05 74 2b 80 00       	add    $0x802b74,%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f be c0             	movsbl %al,%eax
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	50                   	push   %eax
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
}
  800f07:	90                   	nop
  800f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f10:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f14:	7e 1c                	jle    800f32 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8b 00                	mov    (%eax),%eax
  800f1b:	8d 50 08             	lea    0x8(%eax),%edx
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 10                	mov    %edx,(%eax)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	83 e8 08             	sub    $0x8,%eax
  800f2b:	8b 50 04             	mov    0x4(%eax),%edx
  800f2e:	8b 00                	mov    (%eax),%eax
  800f30:	eb 40                	jmp    800f72 <getuint+0x65>
	else if (lflag)
  800f32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f36:	74 1e                	je     800f56 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8b 00                	mov    (%eax),%eax
  800f3d:	8d 50 04             	lea    0x4(%eax),%edx
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	89 10                	mov    %edx,(%eax)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8b 00                	mov    (%eax),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f54:	eb 1c                	jmp    800f72 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	8d 50 04             	lea    0x4(%eax),%edx
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 10                	mov    %edx,(%eax)
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	83 e8 04             	sub    $0x4,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f77:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f7b:	7e 1c                	jle    800f99 <getint+0x25>
		return va_arg(*ap, long long);
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	8d 50 08             	lea    0x8(%eax),%edx
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 10                	mov    %edx,(%eax)
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8b 00                	mov    (%eax),%eax
  800f8f:	83 e8 08             	sub    $0x8,%eax
  800f92:	8b 50 04             	mov    0x4(%eax),%edx
  800f95:	8b 00                	mov    (%eax),%eax
  800f97:	eb 38                	jmp    800fd1 <getint+0x5d>
	else if (lflag)
  800f99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f9d:	74 1a                	je     800fb9 <getint+0x45>
		return va_arg(*ap, long);
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8b 00                	mov    (%eax),%eax
  800fa4:	8d 50 04             	lea    0x4(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	89 10                	mov    %edx,(%eax)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8b 00                	mov    (%eax),%eax
  800fb1:	83 e8 04             	sub    $0x4,%eax
  800fb4:	8b 00                	mov    (%eax),%eax
  800fb6:	99                   	cltd   
  800fb7:	eb 18                	jmp    800fd1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8b 00                	mov    (%eax),%eax
  800fbe:	8d 50 04             	lea    0x4(%eax),%edx
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	89 10                	mov    %edx,(%eax)
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8b 00                	mov    (%eax),%eax
  800fcb:	83 e8 04             	sub    $0x4,%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	99                   	cltd   
}
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fdb:	eb 17                	jmp    800ff4 <vprintfmt+0x21>
			if (ch == '\0')
  800fdd:	85 db                	test   %ebx,%ebx
  800fdf:	0f 84 af 03 00 00    	je     801394 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 0c             	pushl  0xc(%ebp)
  800feb:	53                   	push   %ebx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	ff d0                	call   *%eax
  800ff1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 01             	lea    0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f b6 d8             	movzbl %al,%ebx
  801002:	83 fb 25             	cmp    $0x25,%ebx
  801005:	75 d6                	jne    800fdd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801007:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80100b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801012:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801019:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801020:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	8d 50 01             	lea    0x1(%eax),%edx
  80102d:	89 55 10             	mov    %edx,0x10(%ebp)
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f b6 d8             	movzbl %al,%ebx
  801035:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801038:	83 f8 55             	cmp    $0x55,%eax
  80103b:	0f 87 2b 03 00 00    	ja     80136c <vprintfmt+0x399>
  801041:	8b 04 85 98 2b 80 00 	mov    0x802b98(,%eax,4),%eax
  801048:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80104a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80104e:	eb d7                	jmp    801027 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801050:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801054:	eb d1                	jmp    801027 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801056:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80105d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801060:	89 d0                	mov    %edx,%eax
  801062:	c1 e0 02             	shl    $0x2,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	01 d8                	add    %ebx,%eax
  80106b:	83 e8 30             	sub    $0x30,%eax
  80106e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801079:	83 fb 2f             	cmp    $0x2f,%ebx
  80107c:	7e 3e                	jle    8010bc <vprintfmt+0xe9>
  80107e:	83 fb 39             	cmp    $0x39,%ebx
  801081:	7f 39                	jg     8010bc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801083:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801086:	eb d5                	jmp    80105d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801088:	8b 45 14             	mov    0x14(%ebp),%eax
  80108b:	83 c0 04             	add    $0x4,%eax
  80108e:	89 45 14             	mov    %eax,0x14(%ebp)
  801091:	8b 45 14             	mov    0x14(%ebp),%eax
  801094:	83 e8 04             	sub    $0x4,%eax
  801097:	8b 00                	mov    (%eax),%eax
  801099:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80109c:	eb 1f                	jmp    8010bd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80109e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a2:	79 83                	jns    801027 <vprintfmt+0x54>
				width = 0;
  8010a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8010ab:	e9 77 ff ff ff       	jmp    801027 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8010b0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8010b7:	e9 6b ff ff ff       	jmp    801027 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8010bc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010c1:	0f 89 60 ff ff ff    	jns    801027 <vprintfmt+0x54>
				width = precision, precision = -1;
  8010c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8010d4:	e9 4e ff ff ff       	jmp    801027 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010d9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8010dc:	e9 46 ff ff ff       	jmp    801027 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8010e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e4:	83 c0 04             	add    $0x4,%eax
  8010e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ed:	83 e8 04             	sub    $0x4,%eax
  8010f0:	8b 00                	mov    (%eax),%eax
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	50                   	push   %eax
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	ff d0                	call   *%eax
  8010fe:	83 c4 10             	add    $0x10,%esp
			break;
  801101:	e9 89 02 00 00       	jmp    80138f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	83 c0 04             	add    $0x4,%eax
  80110c:	89 45 14             	mov    %eax,0x14(%ebp)
  80110f:	8b 45 14             	mov    0x14(%ebp),%eax
  801112:	83 e8 04             	sub    $0x4,%eax
  801115:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801117:	85 db                	test   %ebx,%ebx
  801119:	79 02                	jns    80111d <vprintfmt+0x14a>
				err = -err;
  80111b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80111d:	83 fb 64             	cmp    $0x64,%ebx
  801120:	7f 0b                	jg     80112d <vprintfmt+0x15a>
  801122:	8b 34 9d e0 29 80 00 	mov    0x8029e0(,%ebx,4),%esi
  801129:	85 f6                	test   %esi,%esi
  80112b:	75 19                	jne    801146 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80112d:	53                   	push   %ebx
  80112e:	68 85 2b 80 00       	push   $0x802b85
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	ff 75 08             	pushl  0x8(%ebp)
  801139:	e8 5e 02 00 00       	call   80139c <printfmt>
  80113e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801141:	e9 49 02 00 00       	jmp    80138f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801146:	56                   	push   %esi
  801147:	68 8e 2b 80 00       	push   $0x802b8e
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	e8 45 02 00 00       	call   80139c <printfmt>
  801157:	83 c4 10             	add    $0x10,%esp
			break;
  80115a:	e9 30 02 00 00       	jmp    80138f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80115f:	8b 45 14             	mov    0x14(%ebp),%eax
  801162:	83 c0 04             	add    $0x4,%eax
  801165:	89 45 14             	mov    %eax,0x14(%ebp)
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	83 e8 04             	sub    $0x4,%eax
  80116e:	8b 30                	mov    (%eax),%esi
  801170:	85 f6                	test   %esi,%esi
  801172:	75 05                	jne    801179 <vprintfmt+0x1a6>
				p = "(null)";
  801174:	be 91 2b 80 00       	mov    $0x802b91,%esi
			if (width > 0 && padc != '-')
  801179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80117d:	7e 6d                	jle    8011ec <vprintfmt+0x219>
  80117f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801183:	74 67                	je     8011ec <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	50                   	push   %eax
  80118c:	56                   	push   %esi
  80118d:	e8 0c 03 00 00       	call   80149e <strnlen>
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801198:	eb 16                	jmp    8011b0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80119a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	50                   	push   %eax
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	ff d0                	call   *%eax
  8011aa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011ad:	ff 4d e4             	decl   -0x1c(%ebp)
  8011b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011b4:	7f e4                	jg     80119a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8011b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011bc:	74 1c                	je     8011da <vprintfmt+0x207>
  8011be:	83 fb 1f             	cmp    $0x1f,%ebx
  8011c1:	7e 05                	jle    8011c8 <vprintfmt+0x1f5>
  8011c3:	83 fb 7e             	cmp    $0x7e,%ebx
  8011c6:	7e 12                	jle    8011da <vprintfmt+0x207>
					putch('?', putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	6a 3f                	push   $0x3f
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	ff d0                	call   *%eax
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	eb 0f                	jmp    8011e9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	ff 75 0c             	pushl  0xc(%ebp)
  8011e0:	53                   	push   %ebx
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	ff d0                	call   *%eax
  8011e6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8011ec:	89 f0                	mov    %esi,%eax
  8011ee:	8d 70 01             	lea    0x1(%eax),%esi
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	0f be d8             	movsbl %al,%ebx
  8011f6:	85 db                	test   %ebx,%ebx
  8011f8:	74 24                	je     80121e <vprintfmt+0x24b>
  8011fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011fe:	78 b8                	js     8011b8 <vprintfmt+0x1e5>
  801200:	ff 4d e0             	decl   -0x20(%ebp)
  801203:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801207:	79 af                	jns    8011b8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801209:	eb 13                	jmp    80121e <vprintfmt+0x24b>
				putch(' ', putdat);
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	6a 20                	push   $0x20
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	ff d0                	call   *%eax
  801218:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80121b:	ff 4d e4             	decl   -0x1c(%ebp)
  80121e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801222:	7f e7                	jg     80120b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801224:	e9 66 01 00 00       	jmp    80138f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801229:	83 ec 08             	sub    $0x8,%esp
  80122c:	ff 75 e8             	pushl  -0x18(%ebp)
  80122f:	8d 45 14             	lea    0x14(%ebp),%eax
  801232:	50                   	push   %eax
  801233:	e8 3c fd ff ff       	call   800f74 <getint>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801247:	85 d2                	test   %edx,%edx
  801249:	79 23                	jns    80126e <vprintfmt+0x29b>
				putch('-', putdat);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	6a 2d                	push   $0x2d
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	ff d0                	call   *%eax
  801258:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80125b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801261:	f7 d8                	neg    %eax
  801263:	83 d2 00             	adc    $0x0,%edx
  801266:	f7 da                	neg    %edx
  801268:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80126e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801275:	e9 bc 00 00 00       	jmp    801336 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	ff 75 e8             	pushl  -0x18(%ebp)
  801280:	8d 45 14             	lea    0x14(%ebp),%eax
  801283:	50                   	push   %eax
  801284:	e8 84 fc ff ff       	call   800f0d <getuint>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80128f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801292:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801299:	e9 98 00 00 00       	jmp    801336 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80129e:	83 ec 08             	sub    $0x8,%esp
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	6a 58                	push   $0x58
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	ff d0                	call   *%eax
  8012ab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012ae:	83 ec 08             	sub    $0x8,%esp
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	6a 58                	push   $0x58
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	ff d0                	call   *%eax
  8012bb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	6a 58                	push   $0x58
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	ff d0                	call   *%eax
  8012cb:	83 c4 10             	add    $0x10,%esp
			break;
  8012ce:	e9 bc 00 00 00       	jmp    80138f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8012d3:	83 ec 08             	sub    $0x8,%esp
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	6a 30                	push   $0x30
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	ff d0                	call   *%eax
  8012e0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	6a 78                	push   $0x78
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	ff d0                	call   *%eax
  8012f0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f6:	83 c0 04             	add    $0x4,%eax
  8012f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	83 e8 04             	sub    $0x4,%eax
  801302:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801304:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80130e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801315:	eb 1f                	jmp    801336 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	ff 75 e8             	pushl  -0x18(%ebp)
  80131d:	8d 45 14             	lea    0x14(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	e8 e7 fb ff ff       	call   800f0d <getuint>
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80132c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80132f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801336:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80133a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	52                   	push   %edx
  801341:	ff 75 e4             	pushl  -0x1c(%ebp)
  801344:	50                   	push   %eax
  801345:	ff 75 f4             	pushl  -0xc(%ebp)
  801348:	ff 75 f0             	pushl  -0x10(%ebp)
  80134b:	ff 75 0c             	pushl  0xc(%ebp)
  80134e:	ff 75 08             	pushl  0x8(%ebp)
  801351:	e8 00 fb ff ff       	call   800e56 <printnum>
  801356:	83 c4 20             	add    $0x20,%esp
			break;
  801359:	eb 34                	jmp    80138f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	ff 75 0c             	pushl  0xc(%ebp)
  801361:	53                   	push   %ebx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	ff d0                	call   *%eax
  801367:	83 c4 10             	add    $0x10,%esp
			break;
  80136a:	eb 23                	jmp    80138f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80136c:	83 ec 08             	sub    $0x8,%esp
  80136f:	ff 75 0c             	pushl  0xc(%ebp)
  801372:	6a 25                	push   $0x25
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	ff d0                	call   *%eax
  801379:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80137c:	ff 4d 10             	decl   0x10(%ebp)
  80137f:	eb 03                	jmp    801384 <vprintfmt+0x3b1>
  801381:	ff 4d 10             	decl   0x10(%ebp)
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	48                   	dec    %eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	3c 25                	cmp    $0x25,%al
  80138c:	75 f3                	jne    801381 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80138e:	90                   	nop
		}
	}
  80138f:	e9 47 fc ff ff       	jmp    800fdb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801394:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801395:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8013a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8013a5:	83 c0 04             	add    $0x4,%eax
  8013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8013ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 0c             	pushl  0xc(%ebp)
  8013b5:	ff 75 08             	pushl  0x8(%ebp)
  8013b8:	e8 16 fc ff ff       	call   800fd3 <vprintfmt>
  8013bd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8013c0:	90                   	nop
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8b 40 08             	mov    0x8(%eax),%eax
  8013cc:	8d 50 01             	lea    0x1(%eax),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	8b 10                	mov    (%eax),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	8b 40 04             	mov    0x4(%eax),%eax
  8013e0:	39 c2                	cmp    %eax,%edx
  8013e2:	73 12                	jae    8013f6 <sprintputch+0x33>
		*b->buf++ = ch;
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	89 0a                	mov    %ecx,(%edx)
  8013f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f4:	88 10                	mov    %dl,(%eax)
}
  8013f6:	90                   	nop
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    

008013f9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801413:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80141a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80141e:	74 06                	je     801426 <vsnprintf+0x2d>
  801420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801424:	7f 07                	jg     80142d <vsnprintf+0x34>
		return -E_INVAL;
  801426:	b8 03 00 00 00       	mov    $0x3,%eax
  80142b:	eb 20                	jmp    80144d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80142d:	ff 75 14             	pushl  0x14(%ebp)
  801430:	ff 75 10             	pushl  0x10(%ebp)
  801433:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	68 c3 13 80 00       	push   $0x8013c3
  80143c:	e8 92 fb ff ff       	call   800fd3 <vprintfmt>
  801441:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801447:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80144a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801455:	8d 45 10             	lea    0x10(%ebp),%eax
  801458:	83 c0 04             	add    $0x4,%eax
  80145b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80145e:	8b 45 10             	mov    0x10(%ebp),%eax
  801461:	ff 75 f4             	pushl  -0xc(%ebp)
  801464:	50                   	push   %eax
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	e8 89 ff ff ff       	call   8013f9 <vsnprintf>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801476:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801488:	eb 06                	jmp    801490 <strlen+0x15>
		n++;
  80148a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80148d:	ff 45 08             	incl   0x8(%ebp)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	84 c0                	test   %al,%al
  801497:	75 f1                	jne    80148a <strlen+0xf>
		n++;
	return n;
  801499:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ab:	eb 09                	jmp    8014b6 <strnlen+0x18>
		n++;
  8014ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014b0:	ff 45 08             	incl   0x8(%ebp)
  8014b3:	ff 4d 0c             	decl   0xc(%ebp)
  8014b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ba:	74 09                	je     8014c5 <strnlen+0x27>
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	84 c0                	test   %al,%al
  8014c3:	75 e8                	jne    8014ad <strnlen+0xf>
		n++;
	return n;
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014d6:	90                   	nop
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	84 c0                	test   %al,%al
  8014f1:	75 e4                	jne    8014d7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801504:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150b:	eb 1f                	jmp    80152c <strncpy+0x34>
		*dst++ = *src;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8d 50 01             	lea    0x1(%eax),%edx
  801513:	89 55 08             	mov    %edx,0x8(%ebp)
  801516:	8b 55 0c             	mov    0xc(%ebp),%edx
  801519:	8a 12                	mov    (%edx),%dl
  80151b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	84 c0                	test   %al,%al
  801524:	74 03                	je     801529 <strncpy+0x31>
			src++;
  801526:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801529:	ff 45 fc             	incl   -0x4(%ebp)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801532:	72 d9                	jb     80150d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801534:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801545:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801549:	74 30                	je     80157b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80154b:	eb 16                	jmp    801563 <strlcpy+0x2a>
			*dst++ = *src++;
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8d 50 01             	lea    0x1(%eax),%edx
  801553:	89 55 08             	mov    %edx,0x8(%ebp)
  801556:	8b 55 0c             	mov    0xc(%ebp),%edx
  801559:	8d 4a 01             	lea    0x1(%edx),%ecx
  80155c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80155f:	8a 12                	mov    (%edx),%dl
  801561:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801563:	ff 4d 10             	decl   0x10(%ebp)
  801566:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156a:	74 09                	je     801575 <strlcpy+0x3c>
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	84 c0                	test   %al,%al
  801573:	75 d8                	jne    80154d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80157b:	8b 55 08             	mov    0x8(%ebp),%edx
  80157e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801581:	29 c2                	sub    %eax,%edx
  801583:	89 d0                	mov    %edx,%eax
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80158a:	eb 06                	jmp    801592 <strcmp+0xb>
		p++, q++;
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	8a 00                	mov    (%eax),%al
  801597:	84 c0                	test   %al,%al
  801599:	74 0e                	je     8015a9 <strcmp+0x22>
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	8a 10                	mov    (%eax),%dl
  8015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	38 c2                	cmp    %al,%dl
  8015a7:	74 e3                	je     80158c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	0f b6 d0             	movzbl %al,%edx
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	29 c2                	sub    %eax,%edx
  8015bb:	89 d0                	mov    %edx,%eax
}
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    

008015bf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015c2:	eb 09                	jmp    8015cd <strncmp+0xe>
		n--, p++, q++;
  8015c4:	ff 4d 10             	decl   0x10(%ebp)
  8015c7:	ff 45 08             	incl   0x8(%ebp)
  8015ca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d1:	74 17                	je     8015ea <strncmp+0x2b>
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	84 c0                	test   %al,%al
  8015da:	74 0e                	je     8015ea <strncmp+0x2b>
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8a 10                	mov    (%eax),%dl
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	38 c2                	cmp    %al,%dl
  8015e8:	74 da                	je     8015c4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ee:	75 07                	jne    8015f7 <strncmp+0x38>
		return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f5:	eb 14                	jmp    80160b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	0f b6 c0             	movzbl %al,%eax
  801607:	29 c2                	sub    %eax,%edx
  801609:	89 d0                	mov    %edx,%eax
}
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801619:	eb 12                	jmp    80162d <strchr+0x20>
		if (*s == c)
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801623:	75 05                	jne    80162a <strchr+0x1d>
			return (char *) s;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	eb 11                	jmp    80163b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8a 00                	mov    (%eax),%al
  801632:	84 c0                	test   %al,%al
  801634:	75 e5                	jne    80161b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801649:	eb 0d                	jmp    801658 <strfind+0x1b>
		if (*s == c)
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801653:	74 0e                	je     801663 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801655:	ff 45 08             	incl   0x8(%ebp)
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	84 c0                	test   %al,%al
  80165f:	75 ea                	jne    80164b <strfind+0xe>
  801661:	eb 01                	jmp    801664 <strfind+0x27>
		if (*s == c)
			break;
  801663:	90                   	nop
	return (char *) s;
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801675:	8b 45 10             	mov    0x10(%ebp),%eax
  801678:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80167b:	eb 0e                	jmp    80168b <memset+0x22>
		*p++ = c;
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	8d 50 01             	lea    0x1(%eax),%edx
  801683:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80168b:	ff 4d f8             	decl   -0x8(%ebp)
  80168e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801692:	79 e9                	jns    80167d <memset+0x14>
		*p++ = c;

	return v;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016ab:	eb 16                	jmp    8016c3 <memcpy+0x2a>
		*d++ = *s++;
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016bf:	8a 12                	mov    (%edx),%dl
  8016c1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	75 dd                	jne    8016ad <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016ed:	73 50                	jae    80173f <memmove+0x6a>
  8016ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016fa:	76 43                	jbe    80173f <memmove+0x6a>
		s += n;
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801702:	8b 45 10             	mov    0x10(%ebp),%eax
  801705:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801708:	eb 10                	jmp    80171a <memmove+0x45>
			*--d = *--s;
  80170a:	ff 4d f8             	decl   -0x8(%ebp)
  80170d:	ff 4d fc             	decl   -0x4(%ebp)
  801710:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801713:	8a 10                	mov    (%eax),%dl
  801715:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801718:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80171a:	8b 45 10             	mov    0x10(%ebp),%eax
  80171d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801720:	89 55 10             	mov    %edx,0x10(%ebp)
  801723:	85 c0                	test   %eax,%eax
  801725:	75 e3                	jne    80170a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801727:	eb 23                	jmp    80174c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	8d 50 01             	lea    0x1(%eax),%edx
  80172f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801732:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801735:	8d 4a 01             	lea    0x1(%edx),%ecx
  801738:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80173b:	8a 12                	mov    (%edx),%dl
  80173d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	8d 50 ff             	lea    -0x1(%eax),%edx
  801745:	89 55 10             	mov    %edx,0x10(%ebp)
  801748:	85 c0                	test   %eax,%eax
  80174a:	75 dd                	jne    801729 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801763:	eb 2a                	jmp    80178f <memcmp+0x3e>
		if (*s1 != *s2)
  801765:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801768:	8a 10                	mov    (%eax),%dl
  80176a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	38 c2                	cmp    %al,%dl
  801771:	74 16                	je     801789 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	0f b6 d0             	movzbl %al,%edx
  80177b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177e:	8a 00                	mov    (%eax),%al
  801780:	0f b6 c0             	movzbl %al,%eax
  801783:	29 c2                	sub    %eax,%edx
  801785:	89 d0                	mov    %edx,%eax
  801787:	eb 18                	jmp    8017a1 <memcmp+0x50>
		s1++, s2++;
  801789:	ff 45 fc             	incl   -0x4(%ebp)
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80178f:	8b 45 10             	mov    0x10(%ebp),%eax
  801792:	8d 50 ff             	lea    -0x1(%eax),%edx
  801795:	89 55 10             	mov    %edx,0x10(%ebp)
  801798:	85 c0                	test   %eax,%eax
  80179a:	75 c9                	jne    801765 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017b4:	eb 15                	jmp    8017cb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	0f b6 d0             	movzbl %al,%edx
  8017be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c1:	0f b6 c0             	movzbl %al,%eax
  8017c4:	39 c2                	cmp    %eax,%edx
  8017c6:	74 0d                	je     8017d5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017c8:	ff 45 08             	incl   0x8(%ebp)
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017d1:	72 e3                	jb     8017b6 <memfind+0x13>
  8017d3:	eb 01                	jmp    8017d6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017d5:	90                   	nop
	return (void *) s;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ef:	eb 03                	jmp    8017f4 <strtol+0x19>
		s++;
  8017f1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 20                	cmp    $0x20,%al
  8017fb:	74 f4                	je     8017f1 <strtol+0x16>
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	3c 09                	cmp    $0x9,%al
  801804:	74 eb                	je     8017f1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	3c 2b                	cmp    $0x2b,%al
  80180d:	75 05                	jne    801814 <strtol+0x39>
		s++;
  80180f:	ff 45 08             	incl   0x8(%ebp)
  801812:	eb 13                	jmp    801827 <strtol+0x4c>
	else if (*s == '-')
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	8a 00                	mov    (%eax),%al
  801819:	3c 2d                	cmp    $0x2d,%al
  80181b:	75 0a                	jne    801827 <strtol+0x4c>
		s++, neg = 1;
  80181d:	ff 45 08             	incl   0x8(%ebp)
  801820:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182b:	74 06                	je     801833 <strtol+0x58>
  80182d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801831:	75 20                	jne    801853 <strtol+0x78>
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8a 00                	mov    (%eax),%al
  801838:	3c 30                	cmp    $0x30,%al
  80183a:	75 17                	jne    801853 <strtol+0x78>
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	40                   	inc    %eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 78                	cmp    $0x78,%al
  801844:	75 0d                	jne    801853 <strtol+0x78>
		s += 2, base = 16;
  801846:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80184a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801851:	eb 28                	jmp    80187b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801853:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801857:	75 15                	jne    80186e <strtol+0x93>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 30                	cmp    $0x30,%al
  801860:	75 0c                	jne    80186e <strtol+0x93>
		s++, base = 8;
  801862:	ff 45 08             	incl   0x8(%ebp)
  801865:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80186c:	eb 0d                	jmp    80187b <strtol+0xa0>
	else if (base == 0)
  80186e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801872:	75 07                	jne    80187b <strtol+0xa0>
		base = 10;
  801874:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8a 00                	mov    (%eax),%al
  801880:	3c 2f                	cmp    $0x2f,%al
  801882:	7e 19                	jle    80189d <strtol+0xc2>
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	8a 00                	mov    (%eax),%al
  801889:	3c 39                	cmp    $0x39,%al
  80188b:	7f 10                	jg     80189d <strtol+0xc2>
			dig = *s - '0';
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	8a 00                	mov    (%eax),%al
  801892:	0f be c0             	movsbl %al,%eax
  801895:	83 e8 30             	sub    $0x30,%eax
  801898:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80189b:	eb 42                	jmp    8018df <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8a 00                	mov    (%eax),%al
  8018a2:	3c 60                	cmp    $0x60,%al
  8018a4:	7e 19                	jle    8018bf <strtol+0xe4>
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8a 00                	mov    (%eax),%al
  8018ab:	3c 7a                	cmp    $0x7a,%al
  8018ad:	7f 10                	jg     8018bf <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	0f be c0             	movsbl %al,%eax
  8018b7:	83 e8 57             	sub    $0x57,%eax
  8018ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018bd:	eb 20                	jmp    8018df <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	3c 40                	cmp    $0x40,%al
  8018c6:	7e 39                	jle    801901 <strtol+0x126>
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	3c 5a                	cmp    $0x5a,%al
  8018cf:	7f 30                	jg     801901 <strtol+0x126>
			dig = *s - 'A' + 10;
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	0f be c0             	movsbl %al,%eax
  8018d9:	83 e8 37             	sub    $0x37,%eax
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018e5:	7d 19                	jge    801900 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018e7:	ff 45 08             	incl   0x8(%ebp)
  8018ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ed:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018f1:	89 c2                	mov    %eax,%edx
  8018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018fb:	e9 7b ff ff ff       	jmp    80187b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801900:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801901:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801905:	74 08                	je     80190f <strtol+0x134>
		*endptr = (char *) s;
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	8b 55 08             	mov    0x8(%ebp),%edx
  80190d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80190f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801913:	74 07                	je     80191c <strtol+0x141>
  801915:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801918:	f7 d8                	neg    %eax
  80191a:	eb 03                	jmp    80191f <strtol+0x144>
  80191c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <ltostr>:

void
ltostr(long value, char *str)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80192e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801935:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801939:	79 13                	jns    80194e <ltostr+0x2d>
	{
		neg = 1;
  80193b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801948:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80194b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801956:	99                   	cltd   
  801957:	f7 f9                	idiv   %ecx
  801959:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80195c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80196f:	83 c2 30             	add    $0x30,%edx
  801972:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801974:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801977:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80197c:	f7 e9                	imul   %ecx
  80197e:	c1 fa 02             	sar    $0x2,%edx
  801981:	89 c8                	mov    %ecx,%eax
  801983:	c1 f8 1f             	sar    $0x1f,%eax
  801986:	29 c2                	sub    %eax,%edx
  801988:	89 d0                	mov    %edx,%eax
  80198a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80198d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801990:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801995:	f7 e9                	imul   %ecx
  801997:	c1 fa 02             	sar    $0x2,%edx
  80199a:	89 c8                	mov    %ecx,%eax
  80199c:	c1 f8 1f             	sar    $0x1f,%eax
  80199f:	29 c2                	sub    %eax,%edx
  8019a1:	89 d0                	mov    %edx,%eax
  8019a3:	c1 e0 02             	shl    $0x2,%eax
  8019a6:	01 d0                	add    %edx,%eax
  8019a8:	01 c0                	add    %eax,%eax
  8019aa:	29 c1                	sub    %eax,%ecx
  8019ac:	89 ca                	mov    %ecx,%edx
  8019ae:	85 d2                	test   %edx,%edx
  8019b0:	75 9c                	jne    80194e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019bc:	48                   	dec    %eax
  8019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019c4:	74 3d                	je     801a03 <ltostr+0xe2>
		start = 1 ;
  8019c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019cd:	eb 34                	jmp    801a03 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	01 d0                	add    %edx,%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e2:	01 c2                	add    %eax,%edx
  8019e4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ea:	01 c8                	add    %ecx,%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	01 c2                	add    %eax,%edx
  8019f8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019fb:	88 02                	mov    %al,(%edx)
		start++ ;
  8019fd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a00:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a09:	7c c4                	jl     8019cf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a0b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	01 d0                	add    %edx,%eax
  801a13:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a1f:	ff 75 08             	pushl  0x8(%ebp)
  801a22:	e8 54 fa ff ff       	call   80147b <strlen>
  801a27:	83 c4 04             	add    $0x4,%esp
  801a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	e8 46 fa ff ff       	call   80147b <strlen>
  801a35:	83 c4 04             	add    $0x4,%esp
  801a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a49:	eb 17                	jmp    801a62 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	01 c2                	add    %eax,%edx
  801a53:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	01 c8                	add    %ecx,%eax
  801a5b:	8a 00                	mov    (%eax),%al
  801a5d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a5f:	ff 45 fc             	incl   -0x4(%ebp)
  801a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a68:	7c e1                	jl     801a4b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a78:	eb 1f                	jmp    801a99 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a7d:	8d 50 01             	lea    0x1(%eax),%edx
  801a80:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a83:	89 c2                	mov    %eax,%edx
  801a85:	8b 45 10             	mov    0x10(%ebp),%eax
  801a88:	01 c2                	add    %eax,%edx
  801a8a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a90:	01 c8                	add    %ecx,%eax
  801a92:	8a 00                	mov    (%eax),%al
  801a94:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a96:	ff 45 f8             	incl   -0x8(%ebp)
  801a99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a9f:	7c d9                	jl     801a7a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801aa1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa7:	01 d0                	add    %edx,%eax
  801aa9:	c6 00 00             	movb   $0x0,(%eax)
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801abb:	8b 45 14             	mov    0x14(%ebp),%eax
  801abe:	8b 00                	mov    (%eax),%eax
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 d0                	add    %edx,%eax
  801acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ad2:	eb 0c                	jmp    801ae0 <strsplit+0x31>
			*string++ = 0;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	8d 50 01             	lea    0x1(%eax),%edx
  801ada:	89 55 08             	mov    %edx,0x8(%ebp)
  801add:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	8a 00                	mov    (%eax),%al
  801ae5:	84 c0                	test   %al,%al
  801ae7:	74 18                	je     801b01 <strsplit+0x52>
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	8a 00                	mov    (%eax),%al
  801aee:	0f be c0             	movsbl %al,%eax
  801af1:	50                   	push   %eax
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	e8 13 fb ff ff       	call   80160d <strchr>
  801afa:	83 c4 08             	add    $0x8,%esp
  801afd:	85 c0                	test   %eax,%eax
  801aff:	75 d3                	jne    801ad4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	8a 00                	mov    (%eax),%al
  801b06:	84 c0                	test   %al,%al
  801b08:	74 5a                	je     801b64 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0d:	8b 00                	mov    (%eax),%eax
  801b0f:	83 f8 0f             	cmp    $0xf,%eax
  801b12:	75 07                	jne    801b1b <strsplit+0x6c>
		{
			return 0;
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
  801b19:	eb 66                	jmp    801b81 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1e:	8b 00                	mov    (%eax),%eax
  801b20:	8d 48 01             	lea    0x1(%eax),%ecx
  801b23:	8b 55 14             	mov    0x14(%ebp),%edx
  801b26:	89 0a                	mov    %ecx,(%edx)
  801b28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	01 c2                	add    %eax,%edx
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b39:	eb 03                	jmp    801b3e <strsplit+0x8f>
			string++;
  801b3b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	8a 00                	mov    (%eax),%al
  801b43:	84 c0                	test   %al,%al
  801b45:	74 8b                	je     801ad2 <strsplit+0x23>
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	8a 00                	mov    (%eax),%al
  801b4c:	0f be c0             	movsbl %al,%eax
  801b4f:	50                   	push   %eax
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	e8 b5 fa ff ff       	call   80160d <strchr>
  801b58:	83 c4 08             	add    $0x8,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	74 dc                	je     801b3b <strsplit+0x8c>
			string++;
	}
  801b5f:	e9 6e ff ff ff       	jmp    801ad2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b64:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b65:	8b 45 14             	mov    0x14(%ebp),%eax
  801b68:	8b 00                	mov    (%eax),%eax
  801b6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b71:	8b 45 10             	mov    0x10(%ebp),%eax
  801b74:	01 d0                	add    %edx,%eax
  801b76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b7c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	68 f0 2c 80 00       	push   $0x802cf0
  801b91:	6a 0e                	push   $0xe
  801b93:	68 2a 2d 80 00       	push   $0x802d2a
  801b98:	e8 a8 ef ff ff       	call   800b45 <_panic>

00801b9d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801ba3:	a1 04 30 80 00       	mov    0x803004,%eax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	74 0f                	je     801bbb <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801bac:	e8 d2 ff ff ff       	call   801b83 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801bb1:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801bb8:	00 00 00 
	}
	if (size == 0) return NULL ;
  801bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bbf:	75 07                	jne    801bc8 <malloc+0x2b>
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc6:	eb 14                	jmp    801bdc <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	68 38 2d 80 00       	push   $0x802d38
  801bd0:	6a 2e                	push   $0x2e
  801bd2:	68 2a 2d 80 00       	push   $0x802d2a
  801bd7:	e8 69 ef ff ff       	call   800b45 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	68 60 2d 80 00       	push   $0x802d60
  801bec:	6a 49                	push   $0x49
  801bee:	68 2a 2d 80 00       	push   $0x802d2a
  801bf3:	e8 4d ef ff ff       	call   800b45 <_panic>

00801bf8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 18             	sub    $0x18,%esp
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	68 84 2d 80 00       	push   $0x802d84
  801c0c:	6a 57                	push   $0x57
  801c0e:	68 2a 2d 80 00       	push   $0x802d2a
  801c13:	e8 2d ef ff ff       	call   800b45 <_panic>

00801c18 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 ac 2d 80 00       	push   $0x802dac
  801c26:	6a 60                	push   $0x60
  801c28:	68 2a 2d 80 00       	push   $0x802d2a
  801c2d:	e8 13 ef ff ff       	call   800b45 <_panic>

00801c32 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	68 d0 2d 80 00       	push   $0x802dd0
  801c40:	6a 7c                	push   $0x7c
  801c42:	68 2a 2d 80 00       	push   $0x802d2a
  801c47:	e8 f9 ee ff ff       	call   800b45 <_panic>

00801c4c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	68 f8 2d 80 00       	push   $0x802df8
  801c5a:	68 86 00 00 00       	push   $0x86
  801c5f:	68 2a 2d 80 00       	push   $0x802d2a
  801c64:	e8 dc ee ff ff       	call   800b45 <_panic>

00801c69 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	68 1c 2e 80 00       	push   $0x802e1c
  801c77:	68 91 00 00 00       	push   $0x91
  801c7c:	68 2a 2d 80 00       	push   $0x802d2a
  801c81:	e8 bf ee ff ff       	call   800b45 <_panic>

00801c86 <shrink>:

}
void shrink(uint32 newSize)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	68 1c 2e 80 00       	push   $0x802e1c
  801c94:	68 96 00 00 00       	push   $0x96
  801c99:	68 2a 2d 80 00       	push   $0x802d2a
  801c9e:	e8 a2 ee ff ff       	call   800b45 <_panic>

00801ca3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	68 1c 2e 80 00       	push   $0x802e1c
  801cb1:	68 9b 00 00 00       	push   $0x9b
  801cb6:	68 2a 2d 80 00       	push   $0x802d2a
  801cbb:	e8 85 ee ff ff       	call   800b45 <_panic>

00801cc0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	57                   	push   %edi
  801cc4:	56                   	push   %esi
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cdb:	cd 30                	int    $0x30
  801cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	52                   	push   %edx
  801d03:	ff 75 0c             	pushl  0xc(%ebp)
  801d06:	50                   	push   %eax
  801d07:	6a 00                	push   $0x0
  801d09:	e8 b2 ff ff ff       	call   801cc0 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	90                   	nop
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 01                	push   $0x1
  801d23:	e8 98 ff ff ff       	call   801cc0 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 05                	push   $0x5
  801d40:	e8 7b ff ff ff       	call   801cc0 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	56                   	push   %esi
  801d4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	51                   	push   %ecx
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 06                	push   $0x6
  801d65:	e8 56 ff ff ff       	call   801cc0 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	52                   	push   %edx
  801d84:	50                   	push   %eax
  801d85:	6a 07                	push   $0x7
  801d87:	e8 34 ff ff ff       	call   801cc0 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	ff 75 08             	pushl  0x8(%ebp)
  801da0:	6a 08                	push   $0x8
  801da2:	e8 19 ff ff ff       	call   801cc0 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 09                	push   $0x9
  801dbb:	e8 00 ff ff ff       	call   801cc0 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 0a                	push   $0xa
  801dd4:	e8 e7 fe ff ff       	call   801cc0 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 0b                	push   $0xb
  801ded:	e8 ce fe ff ff       	call   801cc0 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	6a 0f                	push   $0xf
  801e08:	e8 b3 fe ff ff       	call   801cc0 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	ff 75 08             	pushl  0x8(%ebp)
  801e22:	6a 10                	push   $0x10
  801e24:	e8 97 fe ff ff       	call   801cc0 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2c:	90                   	nop
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	6a 11                	push   $0x11
  801e41:	e8 7a fe ff ff       	call   801cc0 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
	return ;
  801e49:	90                   	nop
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 0c                	push   $0xc
  801e5b:	e8 60 fe ff ff       	call   801cc0 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	ff 75 08             	pushl  0x8(%ebp)
  801e73:	6a 0d                	push   $0xd
  801e75:	e8 46 fe ff ff       	call   801cc0 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 0e                	push   $0xe
  801e8e:	e8 2d fe ff ff       	call   801cc0 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	90                   	nop
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 13                	push   $0x13
  801ea8:	e8 13 fe ff ff       	call   801cc0 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 14                	push   $0x14
  801ec2:	e8 f9 fd ff ff       	call   801cc0 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	90                   	nop
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_cputc>:


void
sys_cputc(const char c)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	50                   	push   %eax
  801ee6:	6a 15                	push   $0x15
  801ee8:	e8 d3 fd ff ff       	call   801cc0 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 16                	push   $0x16
  801f02:	e8 b9 fd ff ff       	call   801cc0 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	90                   	nop
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	ff 75 0c             	pushl  0xc(%ebp)
  801f1c:	50                   	push   %eax
  801f1d:	6a 17                	push   $0x17
  801f1f:	e8 9c fd ff ff       	call   801cc0 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	52                   	push   %edx
  801f39:	50                   	push   %eax
  801f3a:	6a 1a                	push   $0x1a
  801f3c:	e8 7f fd ff ff       	call   801cc0 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	52                   	push   %edx
  801f56:	50                   	push   %eax
  801f57:	6a 18                	push   $0x18
  801f59:	e8 62 fd ff ff       	call   801cc0 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 19                	push   $0x19
  801f77:	e8 44 fd ff ff       	call   801cc0 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	6a 00                	push   $0x0
  801f9a:	51                   	push   %ecx
  801f9b:	52                   	push   %edx
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	50                   	push   %eax
  801fa0:	6a 1b                	push   $0x1b
  801fa2:	e8 19 fd ff ff       	call   801cc0 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 1c                	push   $0x1c
  801fbf:	e8 fc fc ff ff       	call   801cc0 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	51                   	push   %ecx
  801fda:	52                   	push   %edx
  801fdb:	50                   	push   %eax
  801fdc:	6a 1d                	push   $0x1d
  801fde:	e8 dd fc ff ff       	call   801cc0 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	52                   	push   %edx
  801ff8:	50                   	push   %eax
  801ff9:	6a 1e                	push   $0x1e
  801ffb:	e8 c0 fc ff ff       	call   801cc0 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 1f                	push   $0x1f
  802014:	e8 a7 fc ff ff       	call   801cc0 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	6a 00                	push   $0x0
  802026:	ff 75 14             	pushl  0x14(%ebp)
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	6a 20                	push   $0x20
  802032:	e8 89 fc ff ff       	call   801cc0 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	50                   	push   %eax
  80204b:	6a 21                	push   $0x21
  80204d:	e8 6e fc ff ff       	call   801cc0 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	90                   	nop
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	50                   	push   %eax
  802067:	6a 22                	push   $0x22
  802069:	e8 52 fc ff ff       	call   801cc0 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 02                	push   $0x2
  802082:	e8 39 fc ff ff       	call   801cc0 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 03                	push   $0x3
  80209b:	e8 20 fc ff ff       	call   801cc0 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 04                	push   $0x4
  8020b4:	e8 07 fc ff ff       	call   801cc0 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_exit_env>:


void sys_exit_env(void)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 23                	push   $0x23
  8020cd:	e8 ee fb ff ff       	call   801cc0 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	90                   	nop
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e1:	8d 50 04             	lea    0x4(%eax),%edx
  8020e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	52                   	push   %edx
  8020ee:	50                   	push   %eax
  8020ef:	6a 24                	push   $0x24
  8020f1:	e8 ca fb ff ff       	call   801cc0 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802102:	89 01                	mov    %eax,(%ecx)
  802104:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	c9                   	leave  
  80210b:	c2 04 00             	ret    $0x4

0080210e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	ff 75 10             	pushl  0x10(%ebp)
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	6a 12                	push   $0x12
  802120:	e8 9b fb ff ff       	call   801cc0 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
	return ;
  802128:	90                   	nop
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_rcr2>:
uint32 sys_rcr2()
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 25                	push   $0x25
  80213a:	e8 81 fb ff ff       	call   801cc0 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802150:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	50                   	push   %eax
  80215d:	6a 26                	push   $0x26
  80215f:	e8 5c fb ff ff       	call   801cc0 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
	return ;
  802167:	90                   	nop
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <rsttst>:
void rsttst()
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 28                	push   $0x28
  802179:	e8 42 fb ff ff       	call   801cc0 <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
	return ;
  802181:	90                   	nop
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	8b 45 14             	mov    0x14(%ebp),%eax
  80218d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802190:	8b 55 18             	mov    0x18(%ebp),%edx
  802193:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802197:	52                   	push   %edx
  802198:	50                   	push   %eax
  802199:	ff 75 10             	pushl  0x10(%ebp)
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	ff 75 08             	pushl  0x8(%ebp)
  8021a2:	6a 27                	push   $0x27
  8021a4:	e8 17 fb ff ff       	call   801cc0 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ac:	90                   	nop
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <chktst>:
void chktst(uint32 n)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	ff 75 08             	pushl  0x8(%ebp)
  8021bd:	6a 29                	push   $0x29
  8021bf:	e8 fc fa ff ff       	call   801cc0 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c7:	90                   	nop
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <inctst>:

void inctst()
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 2a                	push   $0x2a
  8021d9:	e8 e2 fa ff ff       	call   801cc0 <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e1:	90                   	nop
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <gettst>:
uint32 gettst()
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 2b                	push   $0x2b
  8021f3:	e8 c8 fa ff ff       	call   801cc0 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 2c                	push   $0x2c
  80220f:	e8 ac fa ff ff       	call   801cc0 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
  802217:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80221a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221e:	75 07                	jne    802227 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802220:	b8 01 00 00 00       	mov    $0x1,%eax
  802225:	eb 05                	jmp    80222c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 2c                	push   $0x2c
  802240:	e8 7b fa ff ff       	call   801cc0 <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
  802248:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80224b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224f:	75 07                	jne    802258 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802251:	b8 01 00 00 00       	mov    $0x1,%eax
  802256:	eb 05                	jmp    80225d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 2c                	push   $0x2c
  802271:	e8 4a fa ff ff       	call   801cc0 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
  802279:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80227c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802280:	75 07                	jne    802289 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb 05                	jmp    80228e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 2c                	push   $0x2c
  8022a2:	e8 19 fa ff ff       	call   801cc0 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
  8022aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022b1:	75 07                	jne    8022ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b8:	eb 05                	jmp    8022bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	6a 2d                	push   $0x2d
  8022d1:	e8 ea f9 ff ff       	call   801cc0 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d9:	90                   	nop
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	53                   	push   %ebx
  8022ef:	51                   	push   %ecx
  8022f0:	52                   	push   %edx
  8022f1:	50                   	push   %eax
  8022f2:	6a 2e                	push   $0x2e
  8022f4:	e8 c7 f9 ff ff       	call   801cc0 <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802304:	8b 55 0c             	mov    0xc(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	52                   	push   %edx
  802311:	50                   	push   %eax
  802312:	6a 2f                	push   $0x2f
  802314:	e8 a7 f9 ff ff       	call   801cc0 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__udivdi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80232b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80232f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802333:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802337:	89 ca                	mov    %ecx,%edx
  802339:	89 f8                	mov    %edi,%eax
  80233b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80233f:	85 f6                	test   %esi,%esi
  802341:	75 2d                	jne    802370 <__udivdi3+0x50>
  802343:	39 cf                	cmp    %ecx,%edi
  802345:	77 65                	ja     8023ac <__udivdi3+0x8c>
  802347:	89 fd                	mov    %edi,%ebp
  802349:	85 ff                	test   %edi,%edi
  80234b:	75 0b                	jne    802358 <__udivdi3+0x38>
  80234d:	b8 01 00 00 00       	mov    $0x1,%eax
  802352:	31 d2                	xor    %edx,%edx
  802354:	f7 f7                	div    %edi
  802356:	89 c5                	mov    %eax,%ebp
  802358:	31 d2                	xor    %edx,%edx
  80235a:	89 c8                	mov    %ecx,%eax
  80235c:	f7 f5                	div    %ebp
  80235e:	89 c1                	mov    %eax,%ecx
  802360:	89 d8                	mov    %ebx,%eax
  802362:	f7 f5                	div    %ebp
  802364:	89 cf                	mov    %ecx,%edi
  802366:	89 fa                	mov    %edi,%edx
  802368:	83 c4 1c             	add    $0x1c,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5e                   	pop    %esi
  80236d:	5f                   	pop    %edi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    
  802370:	39 ce                	cmp    %ecx,%esi
  802372:	77 28                	ja     80239c <__udivdi3+0x7c>
  802374:	0f bd fe             	bsr    %esi,%edi
  802377:	83 f7 1f             	xor    $0x1f,%edi
  80237a:	75 40                	jne    8023bc <__udivdi3+0x9c>
  80237c:	39 ce                	cmp    %ecx,%esi
  80237e:	72 0a                	jb     80238a <__udivdi3+0x6a>
  802380:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802384:	0f 87 9e 00 00 00    	ja     802428 <__udivdi3+0x108>
  80238a:	b8 01 00 00 00       	mov    $0x1,%eax
  80238f:	89 fa                	mov    %edi,%edx
  802391:	83 c4 1c             	add    $0x1c,%esp
  802394:	5b                   	pop    %ebx
  802395:	5e                   	pop    %esi
  802396:	5f                   	pop    %edi
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    
  802399:	8d 76 00             	lea    0x0(%esi),%esi
  80239c:	31 ff                	xor    %edi,%edi
  80239e:	31 c0                	xor    %eax,%eax
  8023a0:	89 fa                	mov    %edi,%edx
  8023a2:	83 c4 1c             	add    $0x1c,%esp
  8023a5:	5b                   	pop    %ebx
  8023a6:	5e                   	pop    %esi
  8023a7:	5f                   	pop    %edi
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	89 d8                	mov    %ebx,%eax
  8023ae:	f7 f7                	div    %edi
  8023b0:	31 ff                	xor    %edi,%edi
  8023b2:	89 fa                	mov    %edi,%edx
  8023b4:	83 c4 1c             	add    $0x1c,%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5f                   	pop    %edi
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    
  8023bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023c1:	89 eb                	mov    %ebp,%ebx
  8023c3:	29 fb                	sub    %edi,%ebx
  8023c5:	89 f9                	mov    %edi,%ecx
  8023c7:	d3 e6                	shl    %cl,%esi
  8023c9:	89 c5                	mov    %eax,%ebp
  8023cb:	88 d9                	mov    %bl,%cl
  8023cd:	d3 ed                	shr    %cl,%ebp
  8023cf:	89 e9                	mov    %ebp,%ecx
  8023d1:	09 f1                	or     %esi,%ecx
  8023d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023d7:	89 f9                	mov    %edi,%ecx
  8023d9:	d3 e0                	shl    %cl,%eax
  8023db:	89 c5                	mov    %eax,%ebp
  8023dd:	89 d6                	mov    %edx,%esi
  8023df:	88 d9                	mov    %bl,%cl
  8023e1:	d3 ee                	shr    %cl,%esi
  8023e3:	89 f9                	mov    %edi,%ecx
  8023e5:	d3 e2                	shl    %cl,%edx
  8023e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023eb:	88 d9                	mov    %bl,%cl
  8023ed:	d3 e8                	shr    %cl,%eax
  8023ef:	09 c2                	or     %eax,%edx
  8023f1:	89 d0                	mov    %edx,%eax
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	f7 74 24 0c          	divl   0xc(%esp)
  8023f9:	89 d6                	mov    %edx,%esi
  8023fb:	89 c3                	mov    %eax,%ebx
  8023fd:	f7 e5                	mul    %ebp
  8023ff:	39 d6                	cmp    %edx,%esi
  802401:	72 19                	jb     80241c <__udivdi3+0xfc>
  802403:	74 0b                	je     802410 <__udivdi3+0xf0>
  802405:	89 d8                	mov    %ebx,%eax
  802407:	31 ff                	xor    %edi,%edi
  802409:	e9 58 ff ff ff       	jmp    802366 <__udivdi3+0x46>
  80240e:	66 90                	xchg   %ax,%ax
  802410:	8b 54 24 08          	mov    0x8(%esp),%edx
  802414:	89 f9                	mov    %edi,%ecx
  802416:	d3 e2                	shl    %cl,%edx
  802418:	39 c2                	cmp    %eax,%edx
  80241a:	73 e9                	jae    802405 <__udivdi3+0xe5>
  80241c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80241f:	31 ff                	xor    %edi,%edi
  802421:	e9 40 ff ff ff       	jmp    802366 <__udivdi3+0x46>
  802426:	66 90                	xchg   %ax,%ax
  802428:	31 c0                	xor    %eax,%eax
  80242a:	e9 37 ff ff ff       	jmp    802366 <__udivdi3+0x46>
  80242f:	90                   	nop

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80243b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80243f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802443:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80244f:	89 f3                	mov    %esi,%ebx
  802451:	89 fa                	mov    %edi,%edx
  802453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802457:	89 34 24             	mov    %esi,(%esp)
  80245a:	85 c0                	test   %eax,%eax
  80245c:	75 1a                	jne    802478 <__umoddi3+0x48>
  80245e:	39 f7                	cmp    %esi,%edi
  802460:	0f 86 a2 00 00 00    	jbe    802508 <__umoddi3+0xd8>
  802466:	89 c8                	mov    %ecx,%eax
  802468:	89 f2                	mov    %esi,%edx
  80246a:	f7 f7                	div    %edi
  80246c:	89 d0                	mov    %edx,%eax
  80246e:	31 d2                	xor    %edx,%edx
  802470:	83 c4 1c             	add    $0x1c,%esp
  802473:	5b                   	pop    %ebx
  802474:	5e                   	pop    %esi
  802475:	5f                   	pop    %edi
  802476:	5d                   	pop    %ebp
  802477:	c3                   	ret    
  802478:	39 f0                	cmp    %esi,%eax
  80247a:	0f 87 ac 00 00 00    	ja     80252c <__umoddi3+0xfc>
  802480:	0f bd e8             	bsr    %eax,%ebp
  802483:	83 f5 1f             	xor    $0x1f,%ebp
  802486:	0f 84 ac 00 00 00    	je     802538 <__umoddi3+0x108>
  80248c:	bf 20 00 00 00       	mov    $0x20,%edi
  802491:	29 ef                	sub    %ebp,%edi
  802493:	89 fe                	mov    %edi,%esi
  802495:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	d3 e0                	shl    %cl,%eax
  80249d:	89 d7                	mov    %edx,%edi
  80249f:	89 f1                	mov    %esi,%ecx
  8024a1:	d3 ef                	shr    %cl,%edi
  8024a3:	09 c7                	or     %eax,%edi
  8024a5:	89 e9                	mov    %ebp,%ecx
  8024a7:	d3 e2                	shl    %cl,%edx
  8024a9:	89 14 24             	mov    %edx,(%esp)
  8024ac:	89 d8                	mov    %ebx,%eax
  8024ae:	d3 e0                	shl    %cl,%eax
  8024b0:	89 c2                	mov    %eax,%edx
  8024b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024b6:	d3 e0                	shl    %cl,%eax
  8024b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	d3 e8                	shr    %cl,%eax
  8024c4:	09 d0                	or     %edx,%eax
  8024c6:	d3 eb                	shr    %cl,%ebx
  8024c8:	89 da                	mov    %ebx,%edx
  8024ca:	f7 f7                	div    %edi
  8024cc:	89 d3                	mov    %edx,%ebx
  8024ce:	f7 24 24             	mull   (%esp)
  8024d1:	89 c6                	mov    %eax,%esi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	39 d3                	cmp    %edx,%ebx
  8024d7:	0f 82 87 00 00 00    	jb     802564 <__umoddi3+0x134>
  8024dd:	0f 84 91 00 00 00    	je     802574 <__umoddi3+0x144>
  8024e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e7:	29 f2                	sub    %esi,%edx
  8024e9:	19 cb                	sbb    %ecx,%ebx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 e9                	mov    %ebp,%ecx
  8024f5:	d3 ea                	shr    %cl,%edx
  8024f7:	09 d0                	or     %edx,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	d3 eb                	shr    %cl,%ebx
  8024fd:	89 da                	mov    %ebx,%edx
  8024ff:	83 c4 1c             	add    $0x1c,%esp
  802502:	5b                   	pop    %ebx
  802503:	5e                   	pop    %esi
  802504:	5f                   	pop    %edi
  802505:	5d                   	pop    %ebp
  802506:	c3                   	ret    
  802507:	90                   	nop
  802508:	89 fd                	mov    %edi,%ebp
  80250a:	85 ff                	test   %edi,%edi
  80250c:	75 0b                	jne    802519 <__umoddi3+0xe9>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f7                	div    %edi
  802517:	89 c5                	mov    %eax,%ebp
  802519:	89 f0                	mov    %esi,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f5                	div    %ebp
  80251f:	89 c8                	mov    %ecx,%eax
  802521:	f7 f5                	div    %ebp
  802523:	89 d0                	mov    %edx,%eax
  802525:	e9 44 ff ff ff       	jmp    80246e <__umoddi3+0x3e>
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	89 c8                	mov    %ecx,%eax
  80252e:	89 f2                	mov    %esi,%edx
  802530:	83 c4 1c             	add    $0x1c,%esp
  802533:	5b                   	pop    %ebx
  802534:	5e                   	pop    %esi
  802535:	5f                   	pop    %edi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    
  802538:	3b 04 24             	cmp    (%esp),%eax
  80253b:	72 06                	jb     802543 <__umoddi3+0x113>
  80253d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802541:	77 0f                	ja     802552 <__umoddi3+0x122>
  802543:	89 f2                	mov    %esi,%edx
  802545:	29 f9                	sub    %edi,%ecx
  802547:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80254b:	89 14 24             	mov    %edx,(%esp)
  80254e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802552:	8b 44 24 04          	mov    0x4(%esp),%eax
  802556:	8b 14 24             	mov    (%esp),%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d 76 00             	lea    0x0(%esi),%esi
  802564:	2b 04 24             	sub    (%esp),%eax
  802567:	19 fa                	sbb    %edi,%edx
  802569:	89 d1                	mov    %edx,%ecx
  80256b:	89 c6                	mov    %eax,%esi
  80256d:	e9 71 ff ff ff       	jmp    8024e3 <__umoddi3+0xb3>
  802572:	66 90                	xchg   %ax,%ax
  802574:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802578:	72 ea                	jb     802564 <__umoddi3+0x134>
  80257a:	89 d9                	mov    %ebx,%ecx
  80257c:	e9 62 ff ff ff       	jmp    8024e3 <__umoddi3+0xb3>
