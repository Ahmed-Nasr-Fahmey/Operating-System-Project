
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 80 2e 80 00       	push   $0x802e80
  80006a:	e8 81 16 00 00       	call   8016f0 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 2c 26 00 00       	call   8026a3 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 c4 26 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 03 24 00 00       	call   802494 <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 a4 2e 80 00       	push   $0x802ea4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 d4 2e 80 00       	push   $0x802ed4
  8000b6:	e8 81 13 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 e0 25 00 00       	call   8026a3 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 ec 2e 80 00       	push   $0x802eec
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 d4 2e 80 00       	push   $0x802ed4
  8000db:	e8 5c 13 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 5e 26 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 58 2f 80 00       	push   $0x802f58
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 d4 2e 80 00       	push   $0x802ed4
  8000fe:	e8 39 13 00 00       	call   80143c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 9b 25 00 00       	call   8026a3 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 33 26 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 72 23 00 00       	call   802494 <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 a4 2e 80 00       	push   $0x802ea4
  800147:	6a 1a                	push   $0x1a
  800149:	68 d4 2e 80 00       	push   $0x802ed4
  80014e:	e8 e9 12 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 4b 25 00 00       	call   8026a3 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 ec 2e 80 00       	push   $0x802eec
  800169:	6a 1c                	push   $0x1c
  80016b:	68 d4 2e 80 00       	push   $0x802ed4
  800170:	e8 c7 12 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 c9 25 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 2f 80 00       	push   $0x802f58
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 d4 2e 80 00       	push   $0x802ed4
  800193:	e8 a4 12 00 00       	call   80143c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 06 25 00 00       	call   8026a3 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 9e 25 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 dd 22 00 00       	call   802494 <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 a4 2e 80 00       	push   $0x802ea4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 d4 2e 80 00       	push   $0x802ed4
  8001df:	e8 58 12 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 ba 24 00 00       	call   8026a3 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 ec 2e 80 00       	push   $0x802eec
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 d4 2e 80 00       	push   $0x802ed4
  800201:	e8 36 12 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 38 25 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 58 2f 80 00       	push   $0x802f58
  80021d:	6a 26                	push   $0x26
  80021f:	68 d4 2e 80 00       	push   $0x802ed4
  800224:	e8 13 12 00 00       	call   80143c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 75 24 00 00       	call   8026a3 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 0d 25 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 4c 22 00 00       	call   802494 <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 a4 2e 80 00       	push   $0x802ea4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 d4 2e 80 00       	push   $0x802ed4
  800274:	e8 c3 11 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 25 24 00 00       	call   8026a3 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 2e 80 00       	push   $0x802eec
  80028f:	6a 2e                	push   $0x2e
  800291:	68 d4 2e 80 00       	push   $0x802ed4
  800296:	e8 a1 11 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 a3 24 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 58 2f 80 00       	push   $0x802f58
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 d4 2e 80 00       	push   $0x802ed4
  8002b9:	e8 7e 11 00 00       	call   80143c <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 e0 23 00 00       	call   8026a3 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 78 24 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 b5 21 00 00       	call   802494 <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 a4 2e 80 00       	push   $0x802ea4
  800301:	6a 35                	push   $0x35
  800303:	68 d4 2e 80 00       	push   $0x802ed4
  800308:	e8 2f 11 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 8e 23 00 00       	call   8026a3 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 ec 2e 80 00       	push   $0x802eec
  800326:	6a 37                	push   $0x37
  800328:	68 d4 2e 80 00       	push   $0x802ed4
  80032d:	e8 0a 11 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 0c 24 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 58 2f 80 00       	push   $0x802f58
  800349:	6a 38                	push   $0x38
  80034b:	68 d4 2e 80 00       	push   $0x802ed4
  800350:	e8 e7 10 00 00       	call   80143c <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 49 23 00 00       	call   8026a3 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 e1 23 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 1e 21 00 00       	call   802494 <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 a4 2e 80 00       	push   $0x802ea4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 d4 2e 80 00       	push   $0x802ed4
  8003a4:	e8 93 10 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 f5 22 00 00       	call   8026a3 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 ec 2e 80 00       	push   $0x802eec
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 d4 2e 80 00       	push   $0x802ed4
  8003c6:	e8 71 10 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 73 23 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 58 2f 80 00       	push   $0x802f58
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 d4 2e 80 00       	push   $0x802ed4
  8003e9:	e8 4e 10 00 00       	call   80143c <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 b0 22 00 00       	call   8026a3 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 48 23 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 81 20 00 00       	call   802494 <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 a4 2e 80 00       	push   $0x802ea4
  800435:	6a 47                	push   $0x47
  800437:	68 d4 2e 80 00       	push   $0x802ed4
  80043c:	e8 fb 0f 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 5a 22 00 00       	call   8026a3 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 ec 2e 80 00       	push   $0x802eec
  80045a:	6a 49                	push   $0x49
  80045c:	68 d4 2e 80 00       	push   $0x802ed4
  800461:	e8 d6 0f 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 d8 22 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 58 2f 80 00       	push   $0x802f58
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 d4 2e 80 00       	push   $0x802ed4
  800484:	e8 b3 0f 00 00       	call   80143c <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 15 22 00 00       	call   8026a3 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 ad 22 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 e6 1f 00 00       	call   802494 <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 a4 2e 80 00       	push   $0x802ea4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 d4 2e 80 00       	push   $0x802ed4
  8004df:	e8 58 0f 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 b7 21 00 00       	call   8026a3 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 ec 2e 80 00       	push   $0x802eec
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 d4 2e 80 00       	push   $0x802ed4
  800504:	e8 33 0f 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 35 22 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 58 2f 80 00       	push   $0x802f58
  800520:	6a 53                	push   $0x53
  800522:	68 d4 2e 80 00       	push   $0x802ed4
  800527:	e8 10 0f 00 00       	call   80143c <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 72 21 00 00       	call   8026a3 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 0a 22 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 30 1f 00 00       	call   802494 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 a4 2e 80 00       	push   $0x802ea4
  80058f:	6a 59                	push   $0x59
  800591:	68 d4 2e 80 00       	push   $0x802ed4
  800596:	e8 a1 0e 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 00 21 00 00       	call   8026a3 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 ec 2e 80 00       	push   $0x802eec
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 d4 2e 80 00       	push   $0x802ed4
  8005bb:	e8 7c 0e 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 7e 21 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 58 2f 80 00       	push   $0x802f58
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 d4 2e 80 00       	push   $0x802ed4
  8005de:	e8 59 0e 00 00       	call   80143c <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 bb 20 00 00       	call   8026a3 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 53 21 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 d3 1e 00 00       	call   8024d5 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 39 21 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 88 2f 80 00       	push   $0x802f88
  800620:	6a 67                	push   $0x67
  800622:	68 d4 2e 80 00       	push   $0x802ed4
  800627:	e8 10 0e 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 72 20 00 00       	call   8026a3 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 c4 2f 80 00       	push   $0x802fc4
  800642:	6a 68                	push   $0x68
  800644:	68 d4 2e 80 00       	push   $0x802ed4
  800649:	e8 ee 0d 00 00       	call   80143c <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 50 20 00 00       	call   8026a3 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 e8 20 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 6b 1e 00 00       	call   8024d5 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 d1 20 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 88 2f 80 00       	push   $0x802f88
  800688:	6a 6f                	push   $0x6f
  80068a:	68 d4 2e 80 00       	push   $0x802ed4
  80068f:	e8 a8 0d 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 0a 20 00 00       	call   8026a3 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c4 2f 80 00       	push   $0x802fc4
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 d4 2e 80 00       	push   $0x802ed4
  8006b1:	e8 86 0d 00 00       	call   80143c <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 e8 1f 00 00       	call   8026a3 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 80 20 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 03 1e 00 00       	call   8024d5 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 69 20 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 88 2f 80 00       	push   $0x802f88
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 d4 2e 80 00       	push   $0x802ed4
  8006f7:	e8 40 0d 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 a2 1f 00 00       	call   8026a3 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 c4 2f 80 00       	push   $0x802fc4
  800712:	6a 78                	push   $0x78
  800714:	68 d4 2e 80 00       	push   $0x802ed4
  800719:	e8 1e 0d 00 00       	call   80143c <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 0c 23 00 00       	call   802a3b <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 63 1f 00 00       	call   8026a3 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 fb 1f 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 cd 1d 00 00       	call   802529 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 10 30 80 00       	push   $0x803010
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 d4 2e 80 00       	push   $0x802ed4
  800781:	e8 b6 0c 00 00       	call   80143c <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 18 1f 00 00       	call   8026a3 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 58 30 80 00       	push   $0x803058
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 d4 2e 80 00       	push   $0x802ed4
  8007a6:	e8 91 0c 00 00       	call   80143c <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 93 1f 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 c8 30 80 00       	push   $0x8030c8
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 d4 2e 80 00       	push   $0x802ed4
  8007d0:	e8 67 0c 00 00       	call   80143c <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 42 22 00 00       	call   802a22 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 fc 30 80 00       	push   $0x8030fc
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 d4 2e 80 00       	push   $0x802ed4
  8007fb:	e8 3c 0c 00 00       	call   80143c <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 0c 22 00 00       	call   802a22 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 50 31 80 00       	push   $0x803150
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 d4 2e 80 00       	push   $0x802ed4
  80083c:	e8 fb 0b 00 00       	call   80143c <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 f0 21 00 00       	call   802a3b <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 9e 31 80 00       	push   $0x80319e
  800858:	e8 28 0e 00 00       	call   801685 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 3e 1e 00 00       	call   8026a3 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 d6 1e 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 9b 1c 00 00       	call   802529 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 a4 2e 80 00       	push   $0x802ea4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 d4 2e 80 00       	push   $0x802ed4
  8008ba:	e8 7d 0b 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 df 1d 00 00       	call   8026a3 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 58 30 80 00       	push   $0x803058
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 d4 2e 80 00       	push   $0x802ed4
  8008df:	e8 58 0b 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 5a 1e 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 c8 30 80 00       	push   $0x8030c8
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 d4 2e 80 00       	push   $0x802ed4
  800905:	e8 32 0b 00 00       	call   80143c <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 a8 31 80 00       	push   $0x8031a8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 d4 2e 80 00       	push   $0x802ed4
  8009b5:	e8 82 0a 00 00       	call   80143c <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 a8 31 80 00       	push   $0x8031a8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 d4 2e 80 00       	push   $0x802ed4
  8009f6:	e8 41 0a 00 00       	call   80143c <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 e0 31 80 00       	push   $0x8031e0
  800a13:	e8 6d 0c 00 00       	call   801685 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 83 1c 00 00       	call   8026a3 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 1b 1d 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 d5 1a 00 00       	call   802529 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 e8 31 80 00       	push   $0x8031e8
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 d4 2e 80 00       	push   $0x802ed4
  800a80:	e8 b7 09 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 19 1c 00 00       	call   8026a3 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 58 30 80 00       	push   $0x803058
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 d4 2e 80 00       	push   $0x802ed4
  800aa5:	e8 92 09 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 94 1c 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c8 30 80 00       	push   $0x8030c8
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 d4 2e 80 00       	push   $0x802ed4
  800ac6:	e8 71 09 00 00       	call   80143c <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 a8 31 80 00       	push   $0x8031a8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 d4 2e 80 00       	push   $0x802ed4
  800b75:	e8 c2 08 00 00       	call   80143c <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 a8 31 80 00       	push   $0x8031a8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 d4 2e 80 00       	push   $0x802ed4
  800bb7:	e8 80 08 00 00       	call   80143c <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 a8 31 80 00       	push   $0x8031a8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 d4 2e 80 00       	push   $0x802ed4
  800bfe:	e8 39 08 00 00       	call   80143c <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 a8 31 80 00       	push   $0x8031a8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 d4 2e 80 00       	push   $0x802ed4
  800c44:	e8 f3 07 00 00       	call   80143c <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 47 1a 00 00       	call   8026a3 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 df 1a 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 62 18 00 00       	call   8024d5 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 c8 1a 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 1c 32 80 00       	push   $0x80321c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 d4 2e 80 00       	push   $0x802ed4
  800c9b:	e8 9c 07 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 fe 19 00 00       	call   8026a3 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 70 32 80 00       	push   $0x803270
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 d4 2e 80 00       	push   $0x802ed4
  800cc5:	e8 72 07 00 00       	call   80143c <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 d4 32 80 00       	push   $0x8032d4
  800cd4:	e8 ac 09 00 00       	call   801685 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 5b 19 00 00       	call   8026a3 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 f3 19 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 ad 17 00 00       	call   802529 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 e8 31 80 00       	push   $0x8031e8
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 d4 2e 80 00       	push   $0x802ed4
  800d9b:	e8 9c 06 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 fe 18 00 00       	call   8026a3 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 58 30 80 00       	push   $0x803058
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 d4 2e 80 00       	push   $0x802ed4
  800dc0:	e8 77 06 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 79 19 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 c8 30 80 00       	push   $0x8030c8
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 d4 2e 80 00       	push   $0x802ed4
  800de1:	e8 56 06 00 00       	call   80143c <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 a8 31 80 00       	push   $0x8031a8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 d4 2e 80 00       	push   $0x802ed4
  800e1a:	e8 1d 06 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 a8 31 80 00       	push   $0x8031a8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 d4 2e 80 00       	push   $0x802ed4
  800e5b:	e8 dc 05 00 00       	call   80143c <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 30 18 00 00       	call   8026a3 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 c8 18 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 4c 16 00 00       	call   8024d5 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 b2 18 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 1c 32 80 00       	push   $0x80321c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 d4 2e 80 00       	push   $0x802ed4
  800eb1:	e8 86 05 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 e8 17 00 00       	call   8026a3 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 70 32 80 00       	push   $0x803270
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 d4 2e 80 00       	push   $0x802ed4
  800edb:	e8 5c 05 00 00       	call   80143c <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 db 32 80 00       	push   $0x8032db
  800eea:	e8 96 07 00 00       	call   801685 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 ac 17 00 00       	call   8026a3 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 44 18 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 81 15 00 00       	call   802494 <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 a4 2e 80 00       	push   $0x802ea4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 d4 2e 80 00       	push   $0x802ed4
  800f35:	e8 02 05 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 64 17 00 00       	call   8026a3 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 ec 2e 80 00       	push   $0x802eec
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 d4 2e 80 00       	push   $0x802ed4
  800f5a:	e8 dd 04 00 00       	call   80143c <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 df 17 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 58 2f 80 00       	push   $0x802f58
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 d4 2e 80 00       	push   $0x802ed4
  800f80:	e8 b7 04 00 00       	call   80143c <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 19 17 00 00       	call   8026a3 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 b1 17 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 34 15 00 00       	call   8024d5 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 9a 17 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 88 2f 80 00       	push   $0x802f88
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 d4 2e 80 00       	push   $0x802ed4
  800fc9:	e8 6e 04 00 00       	call   80143c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 d0 16 00 00       	call   8026a3 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 c4 2f 80 00       	push   $0x802fc4
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 d4 2e 80 00       	push   $0x802ed4
  800fee:	e8 49 04 00 00       	call   80143c <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 8b 14 00 00       	call   802494 <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 22 16 00 00       	call   8026a3 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 ba 16 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 85 14 00 00       	call   802529 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 e8 31 80 00       	push   $0x8031e8
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 d4 2e 80 00       	push   $0x802ed4
  8010cf:	e8 68 03 00 00       	call   80143c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 6a 16 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 c8 30 80 00       	push   $0x8030c8
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 d4 2e 80 00       	push   $0x802ed4
  8010f5:	e8 42 03 00 00       	call   80143c <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 a8 31 80 00       	push   $0x8031a8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 d4 2e 80 00       	push   $0x802ed4
  801199:	e8 9e 02 00 00       	call   80143c <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 a8 31 80 00       	push   $0x8031a8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 d4 2e 80 00       	push   $0x802ed4
  8011da:	e8 5d 02 00 00       	call   80143c <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 a8 31 80 00       	push   $0x8031a8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 d4 2e 80 00       	push   $0x802ed4
  801221:	e8 16 02 00 00       	call   80143c <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 a8 31 80 00       	push   $0x8031a8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 d4 2e 80 00       	push   $0x802ed4
  801267:	e8 d0 01 00 00       	call   80143c <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 24 14 00 00       	call   8026a3 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 bc 14 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 3f 12 00 00       	call   8024d5 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 a5 14 00 00       	call   802743 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 1c 32 80 00       	push   $0x80321c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 d4 2e 80 00       	push   $0x802ed4
  8012be:	e8 79 01 00 00       	call   80143c <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 e2 32 80 00       	push   $0x8032e2
  8012cd:	e8 b3 03 00 00       	call   801685 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 ec 32 80 00       	push   $0x8032ec
  8012dd:	e8 0e 04 00 00       	call   8016f0 <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 8b 16 00 00       	call   802983 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80130b:	01 c8                	add    %ecx,%eax
  80130d:	c1 e0 02             	shl    $0x2,%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801319:	01 c8                	add    %ecx,%eax
  80131b:	c1 e0 02             	shl    $0x2,%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	c1 e0 02             	shl    $0x2,%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	c1 e0 03             	shl    $0x3,%eax
  801328:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80132d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801332:	a1 20 40 80 00       	mov    0x804020,%eax
  801337:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 0f                	je     801350 <libmain+0x63>
		binaryname = myEnv->prog_name;
  801341:	a1 20 40 80 00       	mov    0x804020,%eax
  801346:	05 18 da 01 00       	add    $0x1da18,%eax
  80134b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801350:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801354:	7e 0a                	jle    801360 <libmain+0x73>
		binaryname = argv[0];
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	8b 00                	mov    (%eax),%eax
  80135b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	ff 75 08             	pushl  0x8(%ebp)
  801369:	e8 ca ec ff ff       	call   800038 <_main>
  80136e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  801371:	e8 1a 14 00 00       	call   802790 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801376:	83 ec 0c             	sub    $0xc,%esp
  801379:	68 40 33 80 00       	push   $0x803340
  80137e:	e8 6d 03 00 00       	call   8016f0 <cprintf>
  801383:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801386:	a1 20 40 80 00       	mov    0x804020,%eax
  80138b:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  801391:	a1 20 40 80 00       	mov    0x804020,%eax
  801396:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	52                   	push   %edx
  8013a0:	50                   	push   %eax
  8013a1:	68 68 33 80 00       	push   $0x803368
  8013a6:	e8 45 03 00 00       	call   8016f0 <cprintf>
  8013ab:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8013ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8013b3:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8013b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8013be:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8013c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8013c9:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8013cf:	51                   	push   %ecx
  8013d0:	52                   	push   %edx
  8013d1:	50                   	push   %eax
  8013d2:	68 90 33 80 00       	push   $0x803390
  8013d7:	e8 14 03 00 00       	call   8016f0 <cprintf>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013df:	a1 20 40 80 00       	mov    0x804020,%eax
  8013e4:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	50                   	push   %eax
  8013ee:	68 e8 33 80 00       	push   $0x8033e8
  8013f3:	e8 f8 02 00 00       	call   8016f0 <cprintf>
  8013f8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013fb:	83 ec 0c             	sub    $0xc,%esp
  8013fe:	68 40 33 80 00       	push   $0x803340
  801403:	e8 e8 02 00 00       	call   8016f0 <cprintf>
  801408:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80140b:	e8 9a 13 00 00       	call   8027aa <sys_enable_interrupt>

	// exit gracefully
	exit();
  801410:	e8 19 00 00 00       	call   80142e <exit>
}
  801415:	90                   	nop
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	6a 00                	push   $0x0
  801423:	e8 27 15 00 00       	call   80294f <sys_destroy_env>
  801428:	83 c4 10             	add    $0x10,%esp
}
  80142b:	90                   	nop
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <exit>:

void
exit(void)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801434:	e8 7c 15 00 00       	call   8029b5 <sys_exit_env>
}
  801439:	90                   	nop
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801442:	8d 45 10             	lea    0x10(%ebp),%eax
  801445:	83 c0 04             	add    $0x4,%eax
  801448:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80144b:	a1 58 b2 82 00       	mov    0x82b258,%eax
  801450:	85 c0                	test   %eax,%eax
  801452:	74 16                	je     80146a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801454:	a1 58 b2 82 00       	mov    0x82b258,%eax
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	50                   	push   %eax
  80145d:	68 fc 33 80 00       	push   $0x8033fc
  801462:	e8 89 02 00 00       	call   8016f0 <cprintf>
  801467:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80146a:	a1 00 40 80 00       	mov    0x804000,%eax
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	ff 75 08             	pushl  0x8(%ebp)
  801475:	50                   	push   %eax
  801476:	68 01 34 80 00       	push   $0x803401
  80147b:	e8 70 02 00 00       	call   8016f0 <cprintf>
  801480:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	ff 75 f4             	pushl  -0xc(%ebp)
  80148c:	50                   	push   %eax
  80148d:	e8 f3 01 00 00       	call   801685 <vcprintf>
  801492:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	6a 00                	push   $0x0
  80149a:	68 1d 34 80 00       	push   $0x80341d
  80149f:	e8 e1 01 00 00       	call   801685 <vcprintf>
  8014a4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8014a7:	e8 82 ff ff ff       	call   80142e <exit>

	// should not return here
	while (1) ;
  8014ac:	eb fe                	jmp    8014ac <_panic+0x70>

008014ae <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8014b9:	8b 50 74             	mov    0x74(%eax),%edx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	39 c2                	cmp    %eax,%edx
  8014c1:	74 14                	je     8014d7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 20 34 80 00       	push   $0x803420
  8014cb:	6a 26                	push   $0x26
  8014cd:	68 6c 34 80 00       	push   $0x80346c
  8014d2:	e8 65 ff ff ff       	call   80143c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014e5:	e9 c2 00 00 00       	jmp    8015ac <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	75 08                	jne    801507 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ff:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801502:	e9 a2 00 00 00       	jmp    8015a9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801507:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80150e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801515:	eb 69                	jmp    801580 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801517:	a1 20 40 80 00       	mov    0x804020,%eax
  80151c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801522:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801525:	89 d0                	mov    %edx,%eax
  801527:	01 c0                	add    %eax,%eax
  801529:	01 d0                	add    %edx,%eax
  80152b:	c1 e0 03             	shl    $0x3,%eax
  80152e:	01 c8                	add    %ecx,%eax
  801530:	8a 40 04             	mov    0x4(%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 46                	jne    80157d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801537:	a1 20 40 80 00       	mov    0x804020,%eax
  80153c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801542:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801545:	89 d0                	mov    %edx,%eax
  801547:	01 c0                	add    %eax,%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	c1 e0 03             	shl    $0x3,%eax
  80154e:	01 c8                	add    %ecx,%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801558:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	01 c8                	add    %ecx,%eax
  80156e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801570:	39 c2                	cmp    %eax,%edx
  801572:	75 09                	jne    80157d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801574:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80157b:	eb 12                	jmp    80158f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80157d:	ff 45 e8             	incl   -0x18(%ebp)
  801580:	a1 20 40 80 00       	mov    0x804020,%eax
  801585:	8b 50 74             	mov    0x74(%eax),%edx
  801588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	77 88                	ja     801517 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80158f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801593:	75 14                	jne    8015a9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	68 78 34 80 00       	push   $0x803478
  80159d:	6a 3a                	push   $0x3a
  80159f:	68 6c 34 80 00       	push   $0x80346c
  8015a4:	e8 93 fe ff ff       	call   80143c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8015a9:	ff 45 f0             	incl   -0x10(%ebp)
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8015b2:	0f 8c 32 ff ff ff    	jl     8014ea <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015c6:	eb 26                	jmp    8015ee <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8015cd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8015d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015d6:	89 d0                	mov    %edx,%eax
  8015d8:	01 c0                	add    %eax,%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	c1 e0 03             	shl    $0x3,%eax
  8015df:	01 c8                	add    %ecx,%eax
  8015e1:	8a 40 04             	mov    0x4(%eax),%al
  8015e4:	3c 01                	cmp    $0x1,%al
  8015e6:	75 03                	jne    8015eb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015e8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015eb:	ff 45 e0             	incl   -0x20(%ebp)
  8015ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8015f3:	8b 50 74             	mov    0x74(%eax),%edx
  8015f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f9:	39 c2                	cmp    %eax,%edx
  8015fb:	77 cb                	ja     8015c8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801603:	74 14                	je     801619 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	68 cc 34 80 00       	push   $0x8034cc
  80160d:	6a 44                	push   $0x44
  80160f:	68 6c 34 80 00       	push   $0x80346c
  801614:	e8 23 fe ff ff       	call   80143c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	8b 00                	mov    (%eax),%eax
  801627:	8d 48 01             	lea    0x1(%eax),%ecx
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162d:	89 0a                	mov    %ecx,(%edx)
  80162f:	8b 55 08             	mov    0x8(%ebp),%edx
  801632:	88 d1                	mov    %dl,%cl
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	3d ff 00 00 00       	cmp    $0xff,%eax
  801645:	75 2c                	jne    801673 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801647:	a0 24 40 80 00       	mov    0x804024,%al
  80164c:	0f b6 c0             	movzbl %al,%eax
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8b 12                	mov    (%edx),%edx
  801654:	89 d1                	mov    %edx,%ecx
  801656:	8b 55 0c             	mov    0xc(%ebp),%edx
  801659:	83 c2 08             	add    $0x8,%edx
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	50                   	push   %eax
  801660:	51                   	push   %ecx
  801661:	52                   	push   %edx
  801662:	e8 7b 0f 00 00       	call   8025e2 <sys_cputs>
  801667:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	8b 40 04             	mov    0x4(%eax),%eax
  801679:	8d 50 01             	lea    0x1(%eax),%edx
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	89 50 04             	mov    %edx,0x4(%eax)
}
  801682:	90                   	nop
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80168e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801695:	00 00 00 
	b.cnt = 0;
  801698:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80169f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016ae:	50                   	push   %eax
  8016af:	68 1c 16 80 00       	push   $0x80161c
  8016b4:	e8 11 02 00 00       	call   8018ca <vprintfmt>
  8016b9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016bc:	a0 24 40 80 00       	mov    0x804024,%al
  8016c1:	0f b6 c0             	movzbl %al,%eax
  8016c4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	50                   	push   %eax
  8016ce:	52                   	push   %edx
  8016cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016d5:	83 c0 08             	add    $0x8,%eax
  8016d8:	50                   	push   %eax
  8016d9:	e8 04 0f 00 00       	call   8025e2 <sys_cputs>
  8016de:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016e1:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8016e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016f6:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8016fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  801700:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 f4             	pushl  -0xc(%ebp)
  80170c:	50                   	push   %eax
  80170d:	e8 73 ff ff ff       	call   801685 <vcprintf>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801723:	e8 68 10 00 00       	call   802790 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801728:	8d 45 0c             	lea    0xc(%ebp),%eax
  80172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	ff 75 f4             	pushl  -0xc(%ebp)
  801737:	50                   	push   %eax
  801738:	e8 48 ff ff ff       	call   801685 <vcprintf>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801743:	e8 62 10 00 00       	call   8027aa <sys_enable_interrupt>
	return cnt;
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	53                   	push   %ebx
  801751:	83 ec 14             	sub    $0x14,%esp
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175a:	8b 45 14             	mov    0x14(%ebp),%eax
  80175d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801760:	8b 45 18             	mov    0x18(%ebp),%eax
  801763:	ba 00 00 00 00       	mov    $0x0,%edx
  801768:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80176b:	77 55                	ja     8017c2 <printnum+0x75>
  80176d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801770:	72 05                	jb     801777 <printnum+0x2a>
  801772:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801775:	77 4b                	ja     8017c2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801777:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80177a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80177d:	8b 45 18             	mov    0x18(%ebp),%eax
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	52                   	push   %edx
  801786:	50                   	push   %eax
  801787:	ff 75 f4             	pushl  -0xc(%ebp)
  80178a:	ff 75 f0             	pushl  -0x10(%ebp)
  80178d:	e8 86 14 00 00       	call   802c18 <__udivdi3>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	ff 75 20             	pushl  0x20(%ebp)
  80179b:	53                   	push   %ebx
  80179c:	ff 75 18             	pushl  0x18(%ebp)
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	e8 a1 ff ff ff       	call   80174d <printnum>
  8017ac:	83 c4 20             	add    $0x20,%esp
  8017af:	eb 1a                	jmp    8017cb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 20             	pushl  0x20(%ebp)
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	ff d0                	call   *%eax
  8017bf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017c2:	ff 4d 1c             	decl   0x1c(%ebp)
  8017c5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017c9:	7f e6                	jg     8017b1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017cb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	53                   	push   %ebx
  8017da:	51                   	push   %ecx
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	e8 46 15 00 00       	call   802d28 <__umoddi3>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	05 34 37 80 00       	add    $0x803734,%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	0f be c0             	movsbl %al,%eax
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	50                   	push   %eax
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	ff d0                	call   *%eax
  8017fb:	83 c4 10             	add    $0x10,%esp
}
  8017fe:	90                   	nop
  8017ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801807:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80180b:	7e 1c                	jle    801829 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	8d 50 08             	lea    0x8(%eax),%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	89 10                	mov    %edx,(%eax)
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	83 e8 08             	sub    $0x8,%eax
  801822:	8b 50 04             	mov    0x4(%eax),%edx
  801825:	8b 00                	mov    (%eax),%eax
  801827:	eb 40                	jmp    801869 <getuint+0x65>
	else if (lflag)
  801829:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182d:	74 1e                	je     80184d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8b 00                	mov    (%eax),%eax
  801834:	8d 50 04             	lea    0x4(%eax),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	89 10                	mov    %edx,(%eax)
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8b 00                	mov    (%eax),%eax
  801841:	83 e8 04             	sub    $0x4,%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	eb 1c                	jmp    801869 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 00                	mov    (%eax),%eax
  801852:	8d 50 04             	lea    0x4(%eax),%edx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 10                	mov    %edx,(%eax)
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8b 00                	mov    (%eax),%eax
  80185f:	83 e8 04             	sub    $0x4,%eax
  801862:	8b 00                	mov    (%eax),%eax
  801864:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80186e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801872:	7e 1c                	jle    801890 <getint+0x25>
		return va_arg(*ap, long long);
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	8b 00                	mov    (%eax),%eax
  801879:	8d 50 08             	lea    0x8(%eax),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	89 10                	mov    %edx,(%eax)
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8b 00                	mov    (%eax),%eax
  801886:	83 e8 08             	sub    $0x8,%eax
  801889:	8b 50 04             	mov    0x4(%eax),%edx
  80188c:	8b 00                	mov    (%eax),%eax
  80188e:	eb 38                	jmp    8018c8 <getint+0x5d>
	else if (lflag)
  801890:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801894:	74 1a                	je     8018b0 <getint+0x45>
		return va_arg(*ap, long);
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8b 00                	mov    (%eax),%eax
  80189b:	8d 50 04             	lea    0x4(%eax),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 10                	mov    %edx,(%eax)
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	8b 00                	mov    (%eax),%eax
  8018a8:	83 e8 04             	sub    $0x4,%eax
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	99                   	cltd   
  8018ae:	eb 18                	jmp    8018c8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	8d 50 04             	lea    0x4(%eax),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	89 10                	mov    %edx,(%eax)
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	8b 00                	mov    (%eax),%eax
  8018c2:	83 e8 04             	sub    $0x4,%eax
  8018c5:	8b 00                	mov    (%eax),%eax
  8018c7:	99                   	cltd   
}
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    

008018ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d2:	eb 17                	jmp    8018eb <vprintfmt+0x21>
			if (ch == '\0')
  8018d4:	85 db                	test   %ebx,%ebx
  8018d6:	0f 84 af 03 00 00    	je     801c8b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	53                   	push   %ebx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	ff d0                	call   *%eax
  8018e8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ee:	8d 50 01             	lea    0x1(%eax),%edx
  8018f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	0f b6 d8             	movzbl %al,%ebx
  8018f9:	83 fb 25             	cmp    $0x25,%ebx
  8018fc:	75 d6                	jne    8018d4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018fe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801902:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801909:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801910:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801917:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80191e:	8b 45 10             	mov    0x10(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 10             	mov    %edx,0x10(%ebp)
  801927:	8a 00                	mov    (%eax),%al
  801929:	0f b6 d8             	movzbl %al,%ebx
  80192c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80192f:	83 f8 55             	cmp    $0x55,%eax
  801932:	0f 87 2b 03 00 00    	ja     801c63 <vprintfmt+0x399>
  801938:	8b 04 85 58 37 80 00 	mov    0x803758(,%eax,4),%eax
  80193f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801941:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801945:	eb d7                	jmp    80191e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801947:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80194b:	eb d1                	jmp    80191e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80194d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801954:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801957:	89 d0                	mov    %edx,%eax
  801959:	c1 e0 02             	shl    $0x2,%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	01 c0                	add    %eax,%eax
  801960:	01 d8                	add    %ebx,%eax
  801962:	83 e8 30             	sub    $0x30,%eax
  801965:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801968:	8b 45 10             	mov    0x10(%ebp),%eax
  80196b:	8a 00                	mov    (%eax),%al
  80196d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801970:	83 fb 2f             	cmp    $0x2f,%ebx
  801973:	7e 3e                	jle    8019b3 <vprintfmt+0xe9>
  801975:	83 fb 39             	cmp    $0x39,%ebx
  801978:	7f 39                	jg     8019b3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80197a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80197d:	eb d5                	jmp    801954 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80197f:	8b 45 14             	mov    0x14(%ebp),%eax
  801982:	83 c0 04             	add    $0x4,%eax
  801985:	89 45 14             	mov    %eax,0x14(%ebp)
  801988:	8b 45 14             	mov    0x14(%ebp),%eax
  80198b:	83 e8 04             	sub    $0x4,%eax
  80198e:	8b 00                	mov    (%eax),%eax
  801990:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801993:	eb 1f                	jmp    8019b4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801995:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801999:	79 83                	jns    80191e <vprintfmt+0x54>
				width = 0;
  80199b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8019a2:	e9 77 ff ff ff       	jmp    80191e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8019a7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8019ae:	e9 6b ff ff ff       	jmp    80191e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019b3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019b8:	0f 89 60 ff ff ff    	jns    80191e <vprintfmt+0x54>
				width = precision, precision = -1;
  8019be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019cb:	e9 4e ff ff ff       	jmp    80191e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019d0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019d3:	e9 46 ff ff ff       	jmp    80191e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019db:	83 c0 04             	add    $0x4,%eax
  8019de:	89 45 14             	mov    %eax,0x14(%ebp)
  8019e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e4:	83 e8 04             	sub    $0x4,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	83 ec 08             	sub    $0x8,%esp
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	ff d0                	call   *%eax
  8019f5:	83 c4 10             	add    $0x10,%esp
			break;
  8019f8:	e9 89 02 00 00       	jmp    801c86 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	83 c0 04             	add    $0x4,%eax
  801a03:	89 45 14             	mov    %eax,0x14(%ebp)
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	83 e8 04             	sub    $0x4,%eax
  801a0c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801a0e:	85 db                	test   %ebx,%ebx
  801a10:	79 02                	jns    801a14 <vprintfmt+0x14a>
				err = -err;
  801a12:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a14:	83 fb 64             	cmp    $0x64,%ebx
  801a17:	7f 0b                	jg     801a24 <vprintfmt+0x15a>
  801a19:	8b 34 9d a0 35 80 00 	mov    0x8035a0(,%ebx,4),%esi
  801a20:	85 f6                	test   %esi,%esi
  801a22:	75 19                	jne    801a3d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a24:	53                   	push   %ebx
  801a25:	68 45 37 80 00       	push   $0x803745
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	e8 5e 02 00 00       	call   801c93 <printfmt>
  801a35:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a38:	e9 49 02 00 00       	jmp    801c86 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a3d:	56                   	push   %esi
  801a3e:	68 4e 37 80 00       	push   $0x80374e
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	e8 45 02 00 00       	call   801c93 <printfmt>
  801a4e:	83 c4 10             	add    $0x10,%esp
			break;
  801a51:	e9 30 02 00 00       	jmp    801c86 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	83 c0 04             	add    $0x4,%eax
  801a5c:	89 45 14             	mov    %eax,0x14(%ebp)
  801a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a62:	83 e8 04             	sub    $0x4,%eax
  801a65:	8b 30                	mov    (%eax),%esi
  801a67:	85 f6                	test   %esi,%esi
  801a69:	75 05                	jne    801a70 <vprintfmt+0x1a6>
				p = "(null)";
  801a6b:	be 51 37 80 00       	mov    $0x803751,%esi
			if (width > 0 && padc != '-')
  801a70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a74:	7e 6d                	jle    801ae3 <vprintfmt+0x219>
  801a76:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a7a:	74 67                	je     801ae3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	50                   	push   %eax
  801a83:	56                   	push   %esi
  801a84:	e8 0c 03 00 00       	call   801d95 <strnlen>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a8f:	eb 16                	jmp    801aa7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a91:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	50                   	push   %eax
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	ff d0                	call   *%eax
  801aa1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  801aa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aab:	7f e4                	jg     801a91 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801aad:	eb 34                	jmp    801ae3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801aaf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ab3:	74 1c                	je     801ad1 <vprintfmt+0x207>
  801ab5:	83 fb 1f             	cmp    $0x1f,%ebx
  801ab8:	7e 05                	jle    801abf <vprintfmt+0x1f5>
  801aba:	83 fb 7e             	cmp    $0x7e,%ebx
  801abd:	7e 12                	jle    801ad1 <vprintfmt+0x207>
					putch('?', putdat);
  801abf:	83 ec 08             	sub    $0x8,%esp
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	6a 3f                	push   $0x3f
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	eb 0f                	jmp    801ae0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	53                   	push   %ebx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	ff d0                	call   *%eax
  801add:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ae0:	ff 4d e4             	decl   -0x1c(%ebp)
  801ae3:	89 f0                	mov    %esi,%eax
  801ae5:	8d 70 01             	lea    0x1(%eax),%esi
  801ae8:	8a 00                	mov    (%eax),%al
  801aea:	0f be d8             	movsbl %al,%ebx
  801aed:	85 db                	test   %ebx,%ebx
  801aef:	74 24                	je     801b15 <vprintfmt+0x24b>
  801af1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801af5:	78 b8                	js     801aaf <vprintfmt+0x1e5>
  801af7:	ff 4d e0             	decl   -0x20(%ebp)
  801afa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801afe:	79 af                	jns    801aaf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b00:	eb 13                	jmp    801b15 <vprintfmt+0x24b>
				putch(' ', putdat);
  801b02:	83 ec 08             	sub    $0x8,%esp
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	6a 20                	push   $0x20
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	ff d0                	call   *%eax
  801b0f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b12:	ff 4d e4             	decl   -0x1c(%ebp)
  801b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b19:	7f e7                	jg     801b02 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b1b:	e9 66 01 00 00       	jmp    801c86 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	ff 75 e8             	pushl  -0x18(%ebp)
  801b26:	8d 45 14             	lea    0x14(%ebp),%eax
  801b29:	50                   	push   %eax
  801b2a:	e8 3c fd ff ff       	call   80186b <getint>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3e:	85 d2                	test   %edx,%edx
  801b40:	79 23                	jns    801b65 <vprintfmt+0x29b>
				putch('-', putdat);
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	6a 2d                	push   $0x2d
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	ff d0                	call   *%eax
  801b4f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b58:	f7 d8                	neg    %eax
  801b5a:	83 d2 00             	adc    $0x0,%edx
  801b5d:	f7 da                	neg    %edx
  801b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b65:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b6c:	e9 bc 00 00 00       	jmp    801c2d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b71:	83 ec 08             	sub    $0x8,%esp
  801b74:	ff 75 e8             	pushl  -0x18(%ebp)
  801b77:	8d 45 14             	lea    0x14(%ebp),%eax
  801b7a:	50                   	push   %eax
  801b7b:	e8 84 fc ff ff       	call   801804 <getuint>
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b90:	e9 98 00 00 00       	jmp    801c2d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	6a 58                	push   $0x58
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	ff d0                	call   *%eax
  801ba2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba5:	83 ec 08             	sub    $0x8,%esp
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	6a 58                	push   $0x58
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	ff d0                	call   *%eax
  801bb2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	6a 58                	push   $0x58
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	ff d0                	call   *%eax
  801bc2:	83 c4 10             	add    $0x10,%esp
			break;
  801bc5:	e9 bc 00 00 00       	jmp    801c86 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	6a 30                	push   $0x30
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	ff d0                	call   *%eax
  801bd7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bda:	83 ec 08             	sub    $0x8,%esp
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	6a 78                	push   $0x78
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	ff d0                	call   *%eax
  801be7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	83 c0 04             	add    $0x4,%eax
  801bf0:	89 45 14             	mov    %eax,0x14(%ebp)
  801bf3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf6:	83 e8 04             	sub    $0x4,%eax
  801bf9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801c05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801c0c:	eb 1f                	jmp    801c2d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	ff 75 e8             	pushl  -0x18(%ebp)
  801c14:	8d 45 14             	lea    0x14(%ebp),%eax
  801c17:	50                   	push   %eax
  801c18:	e8 e7 fb ff ff       	call   801804 <getuint>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c26:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c2d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	52                   	push   %edx
  801c38:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	ff 75 08             	pushl  0x8(%ebp)
  801c48:	e8 00 fb ff ff       	call   80174d <printnum>
  801c4d:	83 c4 20             	add    $0x20,%esp
			break;
  801c50:	eb 34                	jmp    801c86 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	53                   	push   %ebx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	ff d0                	call   *%eax
  801c5e:	83 c4 10             	add    $0x10,%esp
			break;
  801c61:	eb 23                	jmp    801c86 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	6a 25                	push   $0x25
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	ff d0                	call   *%eax
  801c70:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c73:	ff 4d 10             	decl   0x10(%ebp)
  801c76:	eb 03                	jmp    801c7b <vprintfmt+0x3b1>
  801c78:	ff 4d 10             	decl   0x10(%ebp)
  801c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7e:	48                   	dec    %eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 25                	cmp    $0x25,%al
  801c83:	75 f3                	jne    801c78 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c85:	90                   	nop
		}
	}
  801c86:	e9 47 fc ff ff       	jmp    8018d2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c8b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    

00801c93 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c99:	8d 45 10             	lea    0x10(%ebp),%eax
  801c9c:	83 c0 04             	add    $0x4,%eax
  801c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca8:	50                   	push   %eax
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	e8 16 fc ff ff       	call   8018ca <vprintfmt>
  801cb4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc0:	8b 40 08             	mov    0x8(%eax),%eax
  801cc3:	8d 50 01             	lea    0x1(%eax),%edx
  801cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	8b 10                	mov    (%eax),%edx
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8b 40 04             	mov    0x4(%eax),%eax
  801cd7:	39 c2                	cmp    %eax,%edx
  801cd9:	73 12                	jae    801ced <sprintputch+0x33>
		*b->buf++ = ch;
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	8b 00                	mov    (%eax),%eax
  801ce0:	8d 48 01             	lea    0x1(%eax),%ecx
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	89 0a                	mov    %ecx,(%edx)
  801ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ceb:	88 10                	mov    %dl,(%eax)
}
  801ced:	90                   	nop
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	01 d0                	add    %edx,%eax
  801d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d15:	74 06                	je     801d1d <vsnprintf+0x2d>
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	7f 07                	jg     801d24 <vsnprintf+0x34>
		return -E_INVAL;
  801d1d:	b8 03 00 00 00       	mov    $0x3,%eax
  801d22:	eb 20                	jmp    801d44 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d24:	ff 75 14             	pushl  0x14(%ebp)
  801d27:	ff 75 10             	pushl  0x10(%ebp)
  801d2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d2d:	50                   	push   %eax
  801d2e:	68 ba 1c 80 00       	push   $0x801cba
  801d33:	e8 92 fb ff ff       	call   8018ca <vprintfmt>
  801d38:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d4c:	8d 45 10             	lea    0x10(%ebp),%eax
  801d4f:	83 c0 04             	add    $0x4,%eax
  801d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d55:	8b 45 10             	mov    0x10(%ebp),%eax
  801d58:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5b:	50                   	push   %eax
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	e8 89 ff ff ff       	call   801cf0 <vsnprintf>
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d7f:	eb 06                	jmp    801d87 <strlen+0x15>
		n++;
  801d81:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d84:	ff 45 08             	incl   0x8(%ebp)
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	8a 00                	mov    (%eax),%al
  801d8c:	84 c0                	test   %al,%al
  801d8e:	75 f1                	jne    801d81 <strlen+0xf>
		n++;
	return n;
  801d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801da2:	eb 09                	jmp    801dad <strnlen+0x18>
		n++;
  801da4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801da7:	ff 45 08             	incl   0x8(%ebp)
  801daa:	ff 4d 0c             	decl   0xc(%ebp)
  801dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801db1:	74 09                	je     801dbc <strnlen+0x27>
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	8a 00                	mov    (%eax),%al
  801db8:	84 c0                	test   %al,%al
  801dba:	75 e8                	jne    801da4 <strnlen+0xf>
		n++;
	return n;
  801dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dcd:	90                   	nop
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8d 50 01             	lea    0x1(%eax),%edx
  801dd4:	89 55 08             	mov    %edx,0x8(%ebp)
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ddd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801de0:	8a 12                	mov    (%edx),%dl
  801de2:	88 10                	mov    %dl,(%eax)
  801de4:	8a 00                	mov    (%eax),%al
  801de6:	84 c0                	test   %al,%al
  801de8:	75 e4                	jne    801dce <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801dfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e02:	eb 1f                	jmp    801e23 <strncpy+0x34>
		*dst++ = *src;
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	8d 50 01             	lea    0x1(%eax),%edx
  801e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	8a 12                	mov    (%edx),%dl
  801e12:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e17:	8a 00                	mov    (%eax),%al
  801e19:	84 c0                	test   %al,%al
  801e1b:	74 03                	je     801e20 <strncpy+0x31>
			src++;
  801e1d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e20:	ff 45 fc             	incl   -0x4(%ebp)
  801e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e26:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e29:	72 d9                	jb     801e04 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e40:	74 30                	je     801e72 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e42:	eb 16                	jmp    801e5a <strlcpy+0x2a>
			*dst++ = *src++;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8d 50 01             	lea    0x1(%eax),%edx
  801e4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e50:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e56:	8a 12                	mov    (%edx),%dl
  801e58:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e5a:	ff 4d 10             	decl   0x10(%ebp)
  801e5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e61:	74 09                	je     801e6c <strlcpy+0x3c>
  801e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e66:	8a 00                	mov    (%eax),%al
  801e68:	84 c0                	test   %al,%al
  801e6a:	75 d8                	jne    801e44 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e72:	8b 55 08             	mov    0x8(%ebp),%edx
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	29 c2                	sub    %eax,%edx
  801e7a:	89 d0                	mov    %edx,%eax
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e81:	eb 06                	jmp    801e89 <strcmp+0xb>
		p++, q++;
  801e83:	ff 45 08             	incl   0x8(%ebp)
  801e86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	8a 00                	mov    (%eax),%al
  801e8e:	84 c0                	test   %al,%al
  801e90:	74 0e                	je     801ea0 <strcmp+0x22>
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	8a 10                	mov    (%eax),%dl
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	8a 00                	mov    (%eax),%al
  801e9c:	38 c2                	cmp    %al,%dl
  801e9e:	74 e3                	je     801e83 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	8a 00                	mov    (%eax),%al
  801ea5:	0f b6 d0             	movzbl %al,%edx
  801ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eab:	8a 00                	mov    (%eax),%al
  801ead:	0f b6 c0             	movzbl %al,%eax
  801eb0:	29 c2                	sub    %eax,%edx
  801eb2:	89 d0                	mov    %edx,%eax
}
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801eb9:	eb 09                	jmp    801ec4 <strncmp+0xe>
		n--, p++, q++;
  801ebb:	ff 4d 10             	decl   0x10(%ebp)
  801ebe:	ff 45 08             	incl   0x8(%ebp)
  801ec1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801ec4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec8:	74 17                	je     801ee1 <strncmp+0x2b>
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	8a 00                	mov    (%eax),%al
  801ecf:	84 c0                	test   %al,%al
  801ed1:	74 0e                	je     801ee1 <strncmp+0x2b>
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	8a 10                	mov    (%eax),%dl
  801ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	38 c2                	cmp    %al,%dl
  801edf:	74 da                	je     801ebb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee5:	75 07                	jne    801eee <strncmp+0x38>
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	eb 14                	jmp    801f02 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	8a 00                	mov    (%eax),%al
  801ef3:	0f b6 d0             	movzbl %al,%edx
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	8a 00                	mov    (%eax),%al
  801efb:	0f b6 c0             	movzbl %al,%eax
  801efe:	29 c2                	sub    %eax,%edx
  801f00:	89 d0                	mov    %edx,%eax
}
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f10:	eb 12                	jmp    801f24 <strchr+0x20>
		if (*s == c)
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	8a 00                	mov    (%eax),%al
  801f17:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f1a:	75 05                	jne    801f21 <strchr+0x1d>
			return (char *) s;
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	eb 11                	jmp    801f32 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f21:	ff 45 08             	incl   0x8(%ebp)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	75 e5                	jne    801f12 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 04             	sub    $0x4,%esp
  801f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f40:	eb 0d                	jmp    801f4f <strfind+0x1b>
		if (*s == c)
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	8a 00                	mov    (%eax),%al
  801f47:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f4a:	74 0e                	je     801f5a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f4c:	ff 45 08             	incl   0x8(%ebp)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	8a 00                	mov    (%eax),%al
  801f54:	84 c0                	test   %al,%al
  801f56:	75 ea                	jne    801f42 <strfind+0xe>
  801f58:	eb 01                	jmp    801f5b <strfind+0x27>
		if (*s == c)
			break;
  801f5a:	90                   	nop
	return (char *) s;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f72:	eb 0e                	jmp    801f82 <memset+0x22>
		*p++ = c;
  801f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f77:	8d 50 01             	lea    0x1(%eax),%edx
  801f7a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f80:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f82:	ff 4d f8             	decl   -0x8(%ebp)
  801f85:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f89:	79 e9                	jns    801f74 <memset+0x14>
		*p++ = c;

	return v;
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801fa2:	eb 16                	jmp    801fba <memcpy+0x2a>
		*d++ = *s++;
  801fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa7:	8d 50 01             	lea    0x1(%eax),%edx
  801faa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fb3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fb6:	8a 12                	mov    (%edx),%dl
  801fb8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fba:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fc0:	89 55 10             	mov    %edx,0x10(%ebp)
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	75 dd                	jne    801fa4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fe4:	73 50                	jae    802036 <memmove+0x6a>
  801fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fec:	01 d0                	add    %edx,%eax
  801fee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ff1:	76 43                	jbe    802036 <memmove+0x6a>
		s += n;
  801ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fff:	eb 10                	jmp    802011 <memmove+0x45>
			*--d = *--s;
  802001:	ff 4d f8             	decl   -0x8(%ebp)
  802004:	ff 4d fc             	decl   -0x4(%ebp)
  802007:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200a:	8a 10                	mov    (%eax),%dl
  80200c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80200f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802011:	8b 45 10             	mov    0x10(%ebp),%eax
  802014:	8d 50 ff             	lea    -0x1(%eax),%edx
  802017:	89 55 10             	mov    %edx,0x10(%ebp)
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 e3                	jne    802001 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80201e:	eb 23                	jmp    802043 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802023:	8d 50 01             	lea    0x1(%eax),%edx
  802026:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802029:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80202c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80202f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802032:	8a 12                	mov    (%edx),%dl
  802034:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802036:	8b 45 10             	mov    0x10(%ebp),%eax
  802039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80203c:	89 55 10             	mov    %edx,0x10(%ebp)
  80203f:	85 c0                	test   %eax,%eax
  802041:	75 dd                	jne    802020 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802054:	8b 45 0c             	mov    0xc(%ebp),%eax
  802057:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80205a:	eb 2a                	jmp    802086 <memcmp+0x3e>
		if (*s1 != *s2)
  80205c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205f:	8a 10                	mov    (%eax),%dl
  802061:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802064:	8a 00                	mov    (%eax),%al
  802066:	38 c2                	cmp    %al,%dl
  802068:	74 16                	je     802080 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	8a 00                	mov    (%eax),%al
  80206f:	0f b6 d0             	movzbl %al,%edx
  802072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802075:	8a 00                	mov    (%eax),%al
  802077:	0f b6 c0             	movzbl %al,%eax
  80207a:	29 c2                	sub    %eax,%edx
  80207c:	89 d0                	mov    %edx,%eax
  80207e:	eb 18                	jmp    802098 <memcmp+0x50>
		s1++, s2++;
  802080:	ff 45 fc             	incl   -0x4(%ebp)
  802083:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802086:	8b 45 10             	mov    0x10(%ebp),%eax
  802089:	8d 50 ff             	lea    -0x1(%eax),%edx
  80208c:	89 55 10             	mov    %edx,0x10(%ebp)
  80208f:	85 c0                	test   %eax,%eax
  802091:	75 c9                	jne    80205c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8020a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8020ab:	eb 15                	jmp    8020c2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8a 00                	mov    (%eax),%al
  8020b2:	0f b6 d0             	movzbl %al,%edx
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	0f b6 c0             	movzbl %al,%eax
  8020bb:	39 c2                	cmp    %eax,%edx
  8020bd:	74 0d                	je     8020cc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020bf:	ff 45 08             	incl   0x8(%ebp)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020c8:	72 e3                	jb     8020ad <memfind+0x13>
  8020ca:	eb 01                	jmp    8020cd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020cc:	90                   	nop
	return (void *) s;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020e6:	eb 03                	jmp    8020eb <strtol+0x19>
		s++;
  8020e8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8a 00                	mov    (%eax),%al
  8020f0:	3c 20                	cmp    $0x20,%al
  8020f2:	74 f4                	je     8020e8 <strtol+0x16>
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	8a 00                	mov    (%eax),%al
  8020f9:	3c 09                	cmp    $0x9,%al
  8020fb:	74 eb                	je     8020e8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8a 00                	mov    (%eax),%al
  802102:	3c 2b                	cmp    $0x2b,%al
  802104:	75 05                	jne    80210b <strtol+0x39>
		s++;
  802106:	ff 45 08             	incl   0x8(%ebp)
  802109:	eb 13                	jmp    80211e <strtol+0x4c>
	else if (*s == '-')
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	8a 00                	mov    (%eax),%al
  802110:	3c 2d                	cmp    $0x2d,%al
  802112:	75 0a                	jne    80211e <strtol+0x4c>
		s++, neg = 1;
  802114:	ff 45 08             	incl   0x8(%ebp)
  802117:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80211e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802122:	74 06                	je     80212a <strtol+0x58>
  802124:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802128:	75 20                	jne    80214a <strtol+0x78>
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8a 00                	mov    (%eax),%al
  80212f:	3c 30                	cmp    $0x30,%al
  802131:	75 17                	jne    80214a <strtol+0x78>
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	40                   	inc    %eax
  802137:	8a 00                	mov    (%eax),%al
  802139:	3c 78                	cmp    $0x78,%al
  80213b:	75 0d                	jne    80214a <strtol+0x78>
		s += 2, base = 16;
  80213d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802141:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802148:	eb 28                	jmp    802172 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80214a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80214e:	75 15                	jne    802165 <strtol+0x93>
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8a 00                	mov    (%eax),%al
  802155:	3c 30                	cmp    $0x30,%al
  802157:	75 0c                	jne    802165 <strtol+0x93>
		s++, base = 8;
  802159:	ff 45 08             	incl   0x8(%ebp)
  80215c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802163:	eb 0d                	jmp    802172 <strtol+0xa0>
	else if (base == 0)
  802165:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802169:	75 07                	jne    802172 <strtol+0xa0>
		base = 10;
  80216b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	8a 00                	mov    (%eax),%al
  802177:	3c 2f                	cmp    $0x2f,%al
  802179:	7e 19                	jle    802194 <strtol+0xc2>
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8a 00                	mov    (%eax),%al
  802180:	3c 39                	cmp    $0x39,%al
  802182:	7f 10                	jg     802194 <strtol+0xc2>
			dig = *s - '0';
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8a 00                	mov    (%eax),%al
  802189:	0f be c0             	movsbl %al,%eax
  80218c:	83 e8 30             	sub    $0x30,%eax
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802192:	eb 42                	jmp    8021d6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8a 00                	mov    (%eax),%al
  802199:	3c 60                	cmp    $0x60,%al
  80219b:	7e 19                	jle    8021b6 <strtol+0xe4>
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8a 00                	mov    (%eax),%al
  8021a2:	3c 7a                	cmp    $0x7a,%al
  8021a4:	7f 10                	jg     8021b6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8a 00                	mov    (%eax),%al
  8021ab:	0f be c0             	movsbl %al,%eax
  8021ae:	83 e8 57             	sub    $0x57,%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b4:	eb 20                	jmp    8021d6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8a 00                	mov    (%eax),%al
  8021bb:	3c 40                	cmp    $0x40,%al
  8021bd:	7e 39                	jle    8021f8 <strtol+0x126>
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	8a 00                	mov    (%eax),%al
  8021c4:	3c 5a                	cmp    $0x5a,%al
  8021c6:	7f 30                	jg     8021f8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8a 00                	mov    (%eax),%al
  8021cd:	0f be c0             	movsbl %al,%eax
  8021d0:	83 e8 37             	sub    $0x37,%eax
  8021d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021dc:	7d 19                	jge    8021f7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021de:	ff 45 08             	incl   0x8(%ebp)
  8021e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021f2:	e9 7b ff ff ff       	jmp    802172 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021f7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021fc:	74 08                	je     802206 <strtol+0x134>
		*endptr = (char *) s;
  8021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802201:	8b 55 08             	mov    0x8(%ebp),%edx
  802204:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802206:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220a:	74 07                	je     802213 <strtol+0x141>
  80220c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80220f:	f7 d8                	neg    %eax
  802211:	eb 03                	jmp    802216 <strtol+0x144>
  802213:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <ltostr>:

void
ltostr(long value, char *str)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80221e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802225:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80222c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802230:	79 13                	jns    802245 <ltostr+0x2d>
	{
		neg = 1;
  802232:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80223f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802242:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80224d:	99                   	cltd   
  80224e:	f7 f9                	idiv   %ecx
  802250:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802253:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802256:	8d 50 01             	lea    0x1(%eax),%edx
  802259:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802261:	01 d0                	add    %edx,%eax
  802263:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802266:	83 c2 30             	add    $0x30,%edx
  802269:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80226b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802273:	f7 e9                	imul   %ecx
  802275:	c1 fa 02             	sar    $0x2,%edx
  802278:	89 c8                	mov    %ecx,%eax
  80227a:	c1 f8 1f             	sar    $0x1f,%eax
  80227d:	29 c2                	sub    %eax,%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802287:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80228c:	f7 e9                	imul   %ecx
  80228e:	c1 fa 02             	sar    $0x2,%edx
  802291:	89 c8                	mov    %ecx,%eax
  802293:	c1 f8 1f             	sar    $0x1f,%eax
  802296:	29 c2                	sub    %eax,%edx
  802298:	89 d0                	mov    %edx,%eax
  80229a:	c1 e0 02             	shl    $0x2,%eax
  80229d:	01 d0                	add    %edx,%eax
  80229f:	01 c0                	add    %eax,%eax
  8022a1:	29 c1                	sub    %eax,%ecx
  8022a3:	89 ca                	mov    %ecx,%edx
  8022a5:	85 d2                	test   %edx,%edx
  8022a7:	75 9c                	jne    802245 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8022a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8022b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b3:	48                   	dec    %eax
  8022b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022bb:	74 3d                	je     8022fa <ltostr+0xe2>
		start = 1 ;
  8022bd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022c4:	eb 34                	jmp    8022fa <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	8a 00                	mov    (%eax),%al
  8022d0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d9:	01 c2                	add    %eax,%edx
  8022db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	01 c8                	add    %ecx,%eax
  8022e3:	8a 00                	mov    (%eax),%al
  8022e5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ed:	01 c2                	add    %eax,%edx
  8022ef:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022f2:	88 02                	mov    %al,(%edx)
		start++ ;
  8022f4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022f7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802300:	7c c4                	jl     8022c6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802302:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802305:	8b 45 0c             	mov    0xc(%ebp),%eax
  802308:	01 d0                	add    %edx,%eax
  80230a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80230d:	90                   	nop
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802316:	ff 75 08             	pushl  0x8(%ebp)
  802319:	e8 54 fa ff ff       	call   801d72 <strlen>
  80231e:	83 c4 04             	add    $0x4,%esp
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802324:	ff 75 0c             	pushl  0xc(%ebp)
  802327:	e8 46 fa ff ff       	call   801d72 <strlen>
  80232c:	83 c4 04             	add    $0x4,%esp
  80232f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802339:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802340:	eb 17                	jmp    802359 <strcconcat+0x49>
		final[s] = str1[s] ;
  802342:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802345:	8b 45 10             	mov    0x10(%ebp),%eax
  802348:	01 c2                	add    %eax,%edx
  80234a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	01 c8                	add    %ecx,%eax
  802352:	8a 00                	mov    (%eax),%al
  802354:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802356:	ff 45 fc             	incl   -0x4(%ebp)
  802359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80235f:	7c e1                	jl     802342 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802361:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802368:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80236f:	eb 1f                	jmp    802390 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802374:	8d 50 01             	lea    0x1(%eax),%edx
  802377:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80237a:	89 c2                	mov    %eax,%edx
  80237c:	8b 45 10             	mov    0x10(%ebp),%eax
  80237f:	01 c2                	add    %eax,%edx
  802381:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802384:	8b 45 0c             	mov    0xc(%ebp),%eax
  802387:	01 c8                	add    %ecx,%eax
  802389:	8a 00                	mov    (%eax),%al
  80238b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80238d:	ff 45 f8             	incl   -0x8(%ebp)
  802390:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802393:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802396:	7c d9                	jl     802371 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802398:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80239b:	8b 45 10             	mov    0x10(%ebp),%eax
  80239e:	01 d0                	add    %edx,%eax
  8023a0:	c6 00 00             	movb   $0x0,(%eax)
}
  8023a3:	90                   	nop
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8023a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8023b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023be:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c1:	01 d0                	add    %edx,%eax
  8023c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c9:	eb 0c                	jmp    8023d7 <strsplit+0x31>
			*string++ = 0;
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8d 50 01             	lea    0x1(%eax),%edx
  8023d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8023d4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	8a 00                	mov    (%eax),%al
  8023dc:	84 c0                	test   %al,%al
  8023de:	74 18                	je     8023f8 <strsplit+0x52>
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	8a 00                	mov    (%eax),%al
  8023e5:	0f be c0             	movsbl %al,%eax
  8023e8:	50                   	push   %eax
  8023e9:	ff 75 0c             	pushl  0xc(%ebp)
  8023ec:	e8 13 fb ff ff       	call   801f04 <strchr>
  8023f1:	83 c4 08             	add    $0x8,%esp
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	75 d3                	jne    8023cb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8a 00                	mov    (%eax),%al
  8023fd:	84 c0                	test   %al,%al
  8023ff:	74 5a                	je     80245b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802401:	8b 45 14             	mov    0x14(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	83 f8 0f             	cmp    $0xf,%eax
  802409:	75 07                	jne    802412 <strsplit+0x6c>
		{
			return 0;
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
  802410:	eb 66                	jmp    802478 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802412:	8b 45 14             	mov    0x14(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	8d 48 01             	lea    0x1(%eax),%ecx
  80241a:	8b 55 14             	mov    0x14(%ebp),%edx
  80241d:	89 0a                	mov    %ecx,(%edx)
  80241f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802426:	8b 45 10             	mov    0x10(%ebp),%eax
  802429:	01 c2                	add    %eax,%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802430:	eb 03                	jmp    802435 <strsplit+0x8f>
			string++;
  802432:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8a 00                	mov    (%eax),%al
  80243a:	84 c0                	test   %al,%al
  80243c:	74 8b                	je     8023c9 <strsplit+0x23>
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8a 00                	mov    (%eax),%al
  802443:	0f be c0             	movsbl %al,%eax
  802446:	50                   	push   %eax
  802447:	ff 75 0c             	pushl  0xc(%ebp)
  80244a:	e8 b5 fa ff ff       	call   801f04 <strchr>
  80244f:	83 c4 08             	add    $0x8,%esp
  802452:	85 c0                	test   %eax,%eax
  802454:	74 dc                	je     802432 <strsplit+0x8c>
			string++;
	}
  802456:	e9 6e ff ff ff       	jmp    8023c9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80245b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80245c:	8b 45 14             	mov    0x14(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802468:	8b 45 10             	mov    0x10(%ebp),%eax
  80246b:	01 d0                	add    %edx,%eax
  80246d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802473:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  802480:	83 ec 04             	sub    $0x4,%esp
  802483:	68 b0 38 80 00       	push   $0x8038b0
  802488:	6a 0e                	push   $0xe
  80248a:	68 ea 38 80 00       	push   $0x8038ea
  80248f:	e8 a8 ef ff ff       	call   80143c <_panic>

00802494 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80249a:	a1 04 40 80 00       	mov    0x804004,%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0f                	je     8024b2 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8024a3:	e8 d2 ff ff ff       	call   80247a <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8024a8:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8024af:	00 00 00 
	}
	if (size == 0) return NULL ;
  8024b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b6:	75 07                	jne    8024bf <malloc+0x2b>
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	eb 14                	jmp    8024d3 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 f8 38 80 00       	push   $0x8038f8
  8024c7:	6a 2e                	push   $0x2e
  8024c9:	68 ea 38 80 00       	push   $0x8038ea
  8024ce:	e8 69 ef ff ff       	call   80143c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 20 39 80 00       	push   $0x803920
  8024e3:	6a 49                	push   $0x49
  8024e5:	68 ea 38 80 00       	push   $0x8038ea
  8024ea:	e8 4d ef ff ff       	call   80143c <_panic>

008024ef <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 18             	sub    $0x18,%esp
  8024f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 44 39 80 00       	push   $0x803944
  802503:	6a 57                	push   $0x57
  802505:	68 ea 38 80 00       	push   $0x8038ea
  80250a:	e8 2d ef ff ff       	call   80143c <_panic>

0080250f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	68 6c 39 80 00       	push   $0x80396c
  80251d:	6a 60                	push   $0x60
  80251f:	68 ea 38 80 00       	push   $0x8038ea
  802524:	e8 13 ef ff ff       	call   80143c <_panic>

00802529 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 90 39 80 00       	push   $0x803990
  802537:	6a 7c                	push   $0x7c
  802539:	68 ea 38 80 00       	push   $0x8038ea
  80253e:	e8 f9 ee ff ff       	call   80143c <_panic>

00802543 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
  802546:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 b8 39 80 00       	push   $0x8039b8
  802551:	68 86 00 00 00       	push   $0x86
  802556:	68 ea 38 80 00       	push   $0x8038ea
  80255b:	e8 dc ee ff ff       	call   80143c <_panic>

00802560 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	68 dc 39 80 00       	push   $0x8039dc
  80256e:	68 91 00 00 00       	push   $0x91
  802573:	68 ea 38 80 00       	push   $0x8038ea
  802578:	e8 bf ee ff ff       	call   80143c <_panic>

0080257d <shrink>:

}
void shrink(uint32 newSize)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	68 dc 39 80 00       	push   $0x8039dc
  80258b:	68 96 00 00 00       	push   $0x96
  802590:	68 ea 38 80 00       	push   $0x8038ea
  802595:	e8 a2 ee ff ff       	call   80143c <_panic>

0080259a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 dc 39 80 00       	push   $0x8039dc
  8025a8:	68 9b 00 00 00       	push   $0x9b
  8025ad:	68 ea 38 80 00       	push   $0x8038ea
  8025b2:	e8 85 ee ff ff       	call   80143c <_panic>

008025b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	57                   	push   %edi
  8025bb:	56                   	push   %esi
  8025bc:	53                   	push   %ebx
  8025bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025d2:	cd 30                	int    $0x30
  8025d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5f                   	pop    %edi
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    

008025e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8025eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8025ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	52                   	push   %edx
  8025fa:	ff 75 0c             	pushl  0xc(%ebp)
  8025fd:	50                   	push   %eax
  8025fe:	6a 00                	push   $0x0
  802600:	e8 b2 ff ff ff       	call   8025b7 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
}
  802608:	90                   	nop
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <sys_cgetc>:

int
sys_cgetc(void)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 01                	push   $0x1
  80261a:	e8 98 ff ff ff       	call   8025b7 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	52                   	push   %edx
  802634:	50                   	push   %eax
  802635:	6a 05                	push   $0x5
  802637:	e8 7b ff ff ff       	call   8025b7 <syscall>
  80263c:	83 c4 18             	add    $0x18,%esp
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	56                   	push   %esi
  802645:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802646:	8b 75 18             	mov    0x18(%ebp),%esi
  802649:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	56                   	push   %esi
  802656:	53                   	push   %ebx
  802657:	51                   	push   %ecx
  802658:	52                   	push   %edx
  802659:	50                   	push   %eax
  80265a:	6a 06                	push   $0x6
  80265c:	e8 56 ff ff ff       	call   8025b7 <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    

0080266b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80266e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	52                   	push   %edx
  80267b:	50                   	push   %eax
  80267c:	6a 07                	push   $0x7
  80267e:	e8 34 ff ff ff       	call   8025b7 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	ff 75 0c             	pushl  0xc(%ebp)
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	6a 08                	push   $0x8
  802699:	e8 19 ff ff ff       	call   8025b7 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 09                	push   $0x9
  8026b2:	e8 00 ff ff ff       	call   8025b7 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 0a                	push   $0xa
  8026cb:	e8 e7 fe ff ff       	call   8025b7 <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 0b                	push   $0xb
  8026e4:	e8 ce fe ff ff       	call   8025b7 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	ff 75 0c             	pushl  0xc(%ebp)
  8026fa:	ff 75 08             	pushl  0x8(%ebp)
  8026fd:	6a 0f                	push   $0xf
  8026ff:	e8 b3 fe ff ff       	call   8025b7 <syscall>
  802704:	83 c4 18             	add    $0x18,%esp
	return;
  802707:	90                   	nop
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	ff 75 0c             	pushl  0xc(%ebp)
  802716:	ff 75 08             	pushl  0x8(%ebp)
  802719:	6a 10                	push   $0x10
  80271b:	e8 97 fe ff ff       	call   8025b7 <syscall>
  802720:	83 c4 18             	add    $0x18,%esp
	return ;
  802723:	90                   	nop
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	ff 75 10             	pushl  0x10(%ebp)
  802730:	ff 75 0c             	pushl  0xc(%ebp)
  802733:	ff 75 08             	pushl  0x8(%ebp)
  802736:	6a 11                	push   $0x11
  802738:	e8 7a fe ff ff       	call   8025b7 <syscall>
  80273d:	83 c4 18             	add    $0x18,%esp
	return ;
  802740:	90                   	nop
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 0c                	push   $0xc
  802752:	e8 60 fe ff ff       	call   8025b7 <syscall>
  802757:	83 c4 18             	add    $0x18,%esp
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	6a 0d                	push   $0xd
  80276c:	e8 46 fe ff ff       	call   8025b7 <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 0e                	push   $0xe
  802785:	e8 2d fe ff ff       	call   8025b7 <syscall>
  80278a:	83 c4 18             	add    $0x18,%esp
}
  80278d:	90                   	nop
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 13                	push   $0x13
  80279f:	e8 13 fe ff ff       	call   8025b7 <syscall>
  8027a4:	83 c4 18             	add    $0x18,%esp
}
  8027a7:	90                   	nop
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 14                	push   $0x14
  8027b9:	e8 f9 fd ff ff       	call   8025b7 <syscall>
  8027be:	83 c4 18             	add    $0x18,%esp
}
  8027c1:	90                   	nop
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	50                   	push   %eax
  8027dd:	6a 15                	push   $0x15
  8027df:	e8 d3 fd ff ff       	call   8025b7 <syscall>
  8027e4:	83 c4 18             	add    $0x18,%esp
}
  8027e7:	90                   	nop
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 16                	push   $0x16
  8027f9:	e8 b9 fd ff ff       	call   8025b7 <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
}
  802801:	90                   	nop
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	ff 75 0c             	pushl  0xc(%ebp)
  802813:	50                   	push   %eax
  802814:	6a 17                	push   $0x17
  802816:	e8 9c fd ff ff       	call   8025b7 <syscall>
  80281b:	83 c4 18             	add    $0x18,%esp
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802823:	8b 55 0c             	mov    0xc(%ebp),%edx
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	52                   	push   %edx
  802830:	50                   	push   %eax
  802831:	6a 1a                	push   $0x1a
  802833:	e8 7f fd ff ff       	call   8025b7 <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802840:	8b 55 0c             	mov    0xc(%ebp),%edx
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	52                   	push   %edx
  80284d:	50                   	push   %eax
  80284e:	6a 18                	push   $0x18
  802850:	e8 62 fd ff ff       	call   8025b7 <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	90                   	nop
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80285e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	52                   	push   %edx
  80286b:	50                   	push   %eax
  80286c:	6a 19                	push   $0x19
  80286e:	e8 44 fd ff ff       	call   8025b7 <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
}
  802876:	90                   	nop
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	8b 45 10             	mov    0x10(%ebp),%eax
  802882:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802885:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802888:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	6a 00                	push   $0x0
  802891:	51                   	push   %ecx
  802892:	52                   	push   %edx
  802893:	ff 75 0c             	pushl  0xc(%ebp)
  802896:	50                   	push   %eax
  802897:	6a 1b                	push   $0x1b
  802899:	e8 19 fd ff ff       	call   8025b7 <syscall>
  80289e:	83 c4 18             	add    $0x18,%esp
}
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8028a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	52                   	push   %edx
  8028b3:	50                   	push   %eax
  8028b4:	6a 1c                	push   $0x1c
  8028b6:	e8 fc fc ff ff       	call   8025b7 <syscall>
  8028bb:	83 c4 18             	add    $0x18,%esp
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8028c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	51                   	push   %ecx
  8028d1:	52                   	push   %edx
  8028d2:	50                   	push   %eax
  8028d3:	6a 1d                	push   $0x1d
  8028d5:	e8 dd fc ff ff       	call   8025b7 <syscall>
  8028da:	83 c4 18             	add    $0x18,%esp
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    

008028df <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	52                   	push   %edx
  8028ef:	50                   	push   %eax
  8028f0:	6a 1e                	push   $0x1e
  8028f2:	e8 c0 fc ff ff       	call   8025b7 <syscall>
  8028f7:	83 c4 18             	add    $0x18,%esp
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 1f                	push   $0x1f
  80290b:	e8 a7 fc ff ff       	call   8025b7 <syscall>
  802910:	83 c4 18             	add    $0x18,%esp
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	6a 00                	push   $0x0
  80291d:	ff 75 14             	pushl  0x14(%ebp)
  802920:	ff 75 10             	pushl  0x10(%ebp)
  802923:	ff 75 0c             	pushl  0xc(%ebp)
  802926:	50                   	push   %eax
  802927:	6a 20                	push   $0x20
  802929:	e8 89 fc ff ff       	call   8025b7 <syscall>
  80292e:	83 c4 18             	add    $0x18,%esp
}
  802931:	c9                   	leave  
  802932:	c3                   	ret    

00802933 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802933:	55                   	push   %ebp
  802934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	50                   	push   %eax
  802942:	6a 21                	push   $0x21
  802944:	e8 6e fc ff ff       	call   8025b7 <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
}
  80294c:	90                   	nop
  80294d:	c9                   	leave  
  80294e:	c3                   	ret    

0080294f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	50                   	push   %eax
  80295e:	6a 22                	push   $0x22
  802960:	e8 52 fc ff ff       	call   8025b7 <syscall>
  802965:	83 c4 18             	add    $0x18,%esp
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 02                	push   $0x2
  802979:	e8 39 fc ff ff       	call   8025b7 <syscall>
  80297e:	83 c4 18             	add    $0x18,%esp
}
  802981:	c9                   	leave  
  802982:	c3                   	ret    

00802983 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802983:	55                   	push   %ebp
  802984:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802986:	6a 00                	push   $0x0
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 03                	push   $0x3
  802992:	e8 20 fc ff ff       	call   8025b7 <syscall>
  802997:	83 c4 18             	add    $0x18,%esp
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 04                	push   $0x4
  8029ab:	e8 07 fc ff ff       	call   8025b7 <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 23                	push   $0x23
  8029c4:	e8 ee fb ff ff       	call   8025b7 <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
}
  8029cc:	90                   	nop
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029d8:	8d 50 04             	lea    0x4(%eax),%edx
  8029db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	52                   	push   %edx
  8029e5:	50                   	push   %eax
  8029e6:	6a 24                	push   $0x24
  8029e8:	e8 ca fb ff ff       	call   8025b7 <syscall>
  8029ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8029f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029f9:	89 01                	mov    %eax,(%ecx)
  8029fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	c9                   	leave  
  802a02:	c2 04 00             	ret    $0x4

00802a05 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	ff 75 10             	pushl  0x10(%ebp)
  802a0f:	ff 75 0c             	pushl  0xc(%ebp)
  802a12:	ff 75 08             	pushl  0x8(%ebp)
  802a15:	6a 12                	push   $0x12
  802a17:	e8 9b fb ff ff       	call   8025b7 <syscall>
  802a1c:	83 c4 18             	add    $0x18,%esp
	return ;
  802a1f:	90                   	nop
}
  802a20:	c9                   	leave  
  802a21:	c3                   	ret    

00802a22 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a22:	55                   	push   %ebp
  802a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 25                	push   $0x25
  802a31:	e8 81 fb ff ff       	call   8025b7 <syscall>
  802a36:	83 c4 18             	add    $0x18,%esp
}
  802a39:	c9                   	leave  
  802a3a:	c3                   	ret    

00802a3b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a47:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	50                   	push   %eax
  802a54:	6a 26                	push   $0x26
  802a56:	e8 5c fb ff ff       	call   8025b7 <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5e:	90                   	nop
}
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <rsttst>:
void rsttst()
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 28                	push   $0x28
  802a70:	e8 42 fb ff ff       	call   8025b7 <syscall>
  802a75:	83 c4 18             	add    $0x18,%esp
	return ;
  802a78:	90                   	nop
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	8b 45 14             	mov    0x14(%ebp),%eax
  802a84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a87:	8b 55 18             	mov    0x18(%ebp),%edx
  802a8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a8e:	52                   	push   %edx
  802a8f:	50                   	push   %eax
  802a90:	ff 75 10             	pushl  0x10(%ebp)
  802a93:	ff 75 0c             	pushl  0xc(%ebp)
  802a96:	ff 75 08             	pushl  0x8(%ebp)
  802a99:	6a 27                	push   $0x27
  802a9b:	e8 17 fb ff ff       	call   8025b7 <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa3:	90                   	nop
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <chktst>:
void chktst(uint32 n)
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	ff 75 08             	pushl  0x8(%ebp)
  802ab4:	6a 29                	push   $0x29
  802ab6:	e8 fc fa ff ff       	call   8025b7 <syscall>
  802abb:	83 c4 18             	add    $0x18,%esp
	return ;
  802abe:	90                   	nop
}
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <inctst>:

void inctst()
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 00                	push   $0x0
  802ace:	6a 2a                	push   $0x2a
  802ad0:	e8 e2 fa ff ff       	call   8025b7 <syscall>
  802ad5:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad8:	90                   	nop
}
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <gettst>:
uint32 gettst()
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 2b                	push   $0x2b
  802aea:	e8 c8 fa ff ff       	call   8025b7 <syscall>
  802aef:	83 c4 18             	add    $0x18,%esp
}
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 00                	push   $0x0
  802b00:	6a 00                	push   $0x0
  802b02:	6a 00                	push   $0x0
  802b04:	6a 2c                	push   $0x2c
  802b06:	e8 ac fa ff ff       	call   8025b7 <syscall>
  802b0b:	83 c4 18             	add    $0x18,%esp
  802b0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b11:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b15:	75 07                	jne    802b1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b17:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1c:	eb 05                	jmp    802b23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b23:	c9                   	leave  
  802b24:	c3                   	ret    

00802b25 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b25:	55                   	push   %ebp
  802b26:	89 e5                	mov    %esp,%ebp
  802b28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 00                	push   $0x0
  802b35:	6a 2c                	push   $0x2c
  802b37:	e8 7b fa ff ff       	call   8025b7 <syscall>
  802b3c:	83 c4 18             	add    $0x18,%esp
  802b3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802b42:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802b46:	75 07                	jne    802b4f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802b48:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4d:	eb 05                	jmp    802b54 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 2c                	push   $0x2c
  802b68:	e8 4a fa ff ff       	call   8025b7 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
  802b70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b73:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b77:	75 07                	jne    802b80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b79:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7e:	eb 05                	jmp    802b85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
  802b8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 2c                	push   $0x2c
  802b99:	e8 19 fa ff ff       	call   8025b7 <syscall>
  802b9e:	83 c4 18             	add    $0x18,%esp
  802ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ba4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ba8:	75 07                	jne    802bb1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802baa:	b8 01 00 00 00       	mov    $0x1,%eax
  802baf:	eb 05                	jmp    802bb6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	ff 75 08             	pushl  0x8(%ebp)
  802bc6:	6a 2d                	push   $0x2d
  802bc8:	e8 ea f9 ff ff       	call   8025b7 <syscall>
  802bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd0:	90                   	nop
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802bd7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	6a 00                	push   $0x0
  802be5:	53                   	push   %ebx
  802be6:	51                   	push   %ecx
  802be7:	52                   	push   %edx
  802be8:	50                   	push   %eax
  802be9:	6a 2e                	push   $0x2e
  802beb:	e8 c7 f9 ff ff       	call   8025b7 <syscall>
  802bf0:	83 c4 18             	add    $0x18,%esp
}
  802bf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	52                   	push   %edx
  802c08:	50                   	push   %eax
  802c09:	6a 2f                	push   $0x2f
  802c0b:	e8 a7 f9 ff ff       	call   8025b7 <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    
  802c15:	66 90                	xchg   %ax,%ax
  802c17:	90                   	nop

00802c18 <__udivdi3>:
  802c18:	55                   	push   %ebp
  802c19:	57                   	push   %edi
  802c1a:	56                   	push   %esi
  802c1b:	53                   	push   %ebx
  802c1c:	83 ec 1c             	sub    $0x1c,%esp
  802c1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802c23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c2f:	89 ca                	mov    %ecx,%edx
  802c31:	89 f8                	mov    %edi,%eax
  802c33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802c37:	85 f6                	test   %esi,%esi
  802c39:	75 2d                	jne    802c68 <__udivdi3+0x50>
  802c3b:	39 cf                	cmp    %ecx,%edi
  802c3d:	77 65                	ja     802ca4 <__udivdi3+0x8c>
  802c3f:	89 fd                	mov    %edi,%ebp
  802c41:	85 ff                	test   %edi,%edi
  802c43:	75 0b                	jne    802c50 <__udivdi3+0x38>
  802c45:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4a:	31 d2                	xor    %edx,%edx
  802c4c:	f7 f7                	div    %edi
  802c4e:	89 c5                	mov    %eax,%ebp
  802c50:	31 d2                	xor    %edx,%edx
  802c52:	89 c8                	mov    %ecx,%eax
  802c54:	f7 f5                	div    %ebp
  802c56:	89 c1                	mov    %eax,%ecx
  802c58:	89 d8                	mov    %ebx,%eax
  802c5a:	f7 f5                	div    %ebp
  802c5c:	89 cf                	mov    %ecx,%edi
  802c5e:	89 fa                	mov    %edi,%edx
  802c60:	83 c4 1c             	add    $0x1c,%esp
  802c63:	5b                   	pop    %ebx
  802c64:	5e                   	pop    %esi
  802c65:	5f                   	pop    %edi
  802c66:	5d                   	pop    %ebp
  802c67:	c3                   	ret    
  802c68:	39 ce                	cmp    %ecx,%esi
  802c6a:	77 28                	ja     802c94 <__udivdi3+0x7c>
  802c6c:	0f bd fe             	bsr    %esi,%edi
  802c6f:	83 f7 1f             	xor    $0x1f,%edi
  802c72:	75 40                	jne    802cb4 <__udivdi3+0x9c>
  802c74:	39 ce                	cmp    %ecx,%esi
  802c76:	72 0a                	jb     802c82 <__udivdi3+0x6a>
  802c78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802c7c:	0f 87 9e 00 00 00    	ja     802d20 <__udivdi3+0x108>
  802c82:	b8 01 00 00 00       	mov    $0x1,%eax
  802c87:	89 fa                	mov    %edi,%edx
  802c89:	83 c4 1c             	add    $0x1c,%esp
  802c8c:	5b                   	pop    %ebx
  802c8d:	5e                   	pop    %esi
  802c8e:	5f                   	pop    %edi
  802c8f:	5d                   	pop    %ebp
  802c90:	c3                   	ret    
  802c91:	8d 76 00             	lea    0x0(%esi),%esi
  802c94:	31 ff                	xor    %edi,%edi
  802c96:	31 c0                	xor    %eax,%eax
  802c98:	89 fa                	mov    %edi,%edx
  802c9a:	83 c4 1c             	add    $0x1c,%esp
  802c9d:	5b                   	pop    %ebx
  802c9e:	5e                   	pop    %esi
  802c9f:	5f                   	pop    %edi
  802ca0:	5d                   	pop    %ebp
  802ca1:	c3                   	ret    
  802ca2:	66 90                	xchg   %ax,%ax
  802ca4:	89 d8                	mov    %ebx,%eax
  802ca6:	f7 f7                	div    %edi
  802ca8:	31 ff                	xor    %edi,%edi
  802caa:	89 fa                	mov    %edi,%edx
  802cac:	83 c4 1c             	add    $0x1c,%esp
  802caf:	5b                   	pop    %ebx
  802cb0:	5e                   	pop    %esi
  802cb1:	5f                   	pop    %edi
  802cb2:	5d                   	pop    %ebp
  802cb3:	c3                   	ret    
  802cb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802cb9:	89 eb                	mov    %ebp,%ebx
  802cbb:	29 fb                	sub    %edi,%ebx
  802cbd:	89 f9                	mov    %edi,%ecx
  802cbf:	d3 e6                	shl    %cl,%esi
  802cc1:	89 c5                	mov    %eax,%ebp
  802cc3:	88 d9                	mov    %bl,%cl
  802cc5:	d3 ed                	shr    %cl,%ebp
  802cc7:	89 e9                	mov    %ebp,%ecx
  802cc9:	09 f1                	or     %esi,%ecx
  802ccb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ccf:	89 f9                	mov    %edi,%ecx
  802cd1:	d3 e0                	shl    %cl,%eax
  802cd3:	89 c5                	mov    %eax,%ebp
  802cd5:	89 d6                	mov    %edx,%esi
  802cd7:	88 d9                	mov    %bl,%cl
  802cd9:	d3 ee                	shr    %cl,%esi
  802cdb:	89 f9                	mov    %edi,%ecx
  802cdd:	d3 e2                	shl    %cl,%edx
  802cdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ce3:	88 d9                	mov    %bl,%cl
  802ce5:	d3 e8                	shr    %cl,%eax
  802ce7:	09 c2                	or     %eax,%edx
  802ce9:	89 d0                	mov    %edx,%eax
  802ceb:	89 f2                	mov    %esi,%edx
  802ced:	f7 74 24 0c          	divl   0xc(%esp)
  802cf1:	89 d6                	mov    %edx,%esi
  802cf3:	89 c3                	mov    %eax,%ebx
  802cf5:	f7 e5                	mul    %ebp
  802cf7:	39 d6                	cmp    %edx,%esi
  802cf9:	72 19                	jb     802d14 <__udivdi3+0xfc>
  802cfb:	74 0b                	je     802d08 <__udivdi3+0xf0>
  802cfd:	89 d8                	mov    %ebx,%eax
  802cff:	31 ff                	xor    %edi,%edi
  802d01:	e9 58 ff ff ff       	jmp    802c5e <__udivdi3+0x46>
  802d06:	66 90                	xchg   %ax,%ax
  802d08:	8b 54 24 08          	mov    0x8(%esp),%edx
  802d0c:	89 f9                	mov    %edi,%ecx
  802d0e:	d3 e2                	shl    %cl,%edx
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	73 e9                	jae    802cfd <__udivdi3+0xe5>
  802d14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d17:	31 ff                	xor    %edi,%edi
  802d19:	e9 40 ff ff ff       	jmp    802c5e <__udivdi3+0x46>
  802d1e:	66 90                	xchg   %ax,%ax
  802d20:	31 c0                	xor    %eax,%eax
  802d22:	e9 37 ff ff ff       	jmp    802c5e <__udivdi3+0x46>
  802d27:	90                   	nop

00802d28 <__umoddi3>:
  802d28:	55                   	push   %ebp
  802d29:	57                   	push   %edi
  802d2a:	56                   	push   %esi
  802d2b:	53                   	push   %ebx
  802d2c:	83 ec 1c             	sub    $0x1c,%esp
  802d2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802d33:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d47:	89 f3                	mov    %esi,%ebx
  802d49:	89 fa                	mov    %edi,%edx
  802d4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d4f:	89 34 24             	mov    %esi,(%esp)
  802d52:	85 c0                	test   %eax,%eax
  802d54:	75 1a                	jne    802d70 <__umoddi3+0x48>
  802d56:	39 f7                	cmp    %esi,%edi
  802d58:	0f 86 a2 00 00 00    	jbe    802e00 <__umoddi3+0xd8>
  802d5e:	89 c8                	mov    %ecx,%eax
  802d60:	89 f2                	mov    %esi,%edx
  802d62:	f7 f7                	div    %edi
  802d64:	89 d0                	mov    %edx,%eax
  802d66:	31 d2                	xor    %edx,%edx
  802d68:	83 c4 1c             	add    $0x1c,%esp
  802d6b:	5b                   	pop    %ebx
  802d6c:	5e                   	pop    %esi
  802d6d:	5f                   	pop    %edi
  802d6e:	5d                   	pop    %ebp
  802d6f:	c3                   	ret    
  802d70:	39 f0                	cmp    %esi,%eax
  802d72:	0f 87 ac 00 00 00    	ja     802e24 <__umoddi3+0xfc>
  802d78:	0f bd e8             	bsr    %eax,%ebp
  802d7b:	83 f5 1f             	xor    $0x1f,%ebp
  802d7e:	0f 84 ac 00 00 00    	je     802e30 <__umoddi3+0x108>
  802d84:	bf 20 00 00 00       	mov    $0x20,%edi
  802d89:	29 ef                	sub    %ebp,%edi
  802d8b:	89 fe                	mov    %edi,%esi
  802d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d91:	89 e9                	mov    %ebp,%ecx
  802d93:	d3 e0                	shl    %cl,%eax
  802d95:	89 d7                	mov    %edx,%edi
  802d97:	89 f1                	mov    %esi,%ecx
  802d99:	d3 ef                	shr    %cl,%edi
  802d9b:	09 c7                	or     %eax,%edi
  802d9d:	89 e9                	mov    %ebp,%ecx
  802d9f:	d3 e2                	shl    %cl,%edx
  802da1:	89 14 24             	mov    %edx,(%esp)
  802da4:	89 d8                	mov    %ebx,%eax
  802da6:	d3 e0                	shl    %cl,%eax
  802da8:	89 c2                	mov    %eax,%edx
  802daa:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dae:	d3 e0                	shl    %cl,%eax
  802db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802db4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802db8:	89 f1                	mov    %esi,%ecx
  802dba:	d3 e8                	shr    %cl,%eax
  802dbc:	09 d0                	or     %edx,%eax
  802dbe:	d3 eb                	shr    %cl,%ebx
  802dc0:	89 da                	mov    %ebx,%edx
  802dc2:	f7 f7                	div    %edi
  802dc4:	89 d3                	mov    %edx,%ebx
  802dc6:	f7 24 24             	mull   (%esp)
  802dc9:	89 c6                	mov    %eax,%esi
  802dcb:	89 d1                	mov    %edx,%ecx
  802dcd:	39 d3                	cmp    %edx,%ebx
  802dcf:	0f 82 87 00 00 00    	jb     802e5c <__umoddi3+0x134>
  802dd5:	0f 84 91 00 00 00    	je     802e6c <__umoddi3+0x144>
  802ddb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ddf:	29 f2                	sub    %esi,%edx
  802de1:	19 cb                	sbb    %ecx,%ebx
  802de3:	89 d8                	mov    %ebx,%eax
  802de5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802de9:	d3 e0                	shl    %cl,%eax
  802deb:	89 e9                	mov    %ebp,%ecx
  802ded:	d3 ea                	shr    %cl,%edx
  802def:	09 d0                	or     %edx,%eax
  802df1:	89 e9                	mov    %ebp,%ecx
  802df3:	d3 eb                	shr    %cl,%ebx
  802df5:	89 da                	mov    %ebx,%edx
  802df7:	83 c4 1c             	add    $0x1c,%esp
  802dfa:	5b                   	pop    %ebx
  802dfb:	5e                   	pop    %esi
  802dfc:	5f                   	pop    %edi
  802dfd:	5d                   	pop    %ebp
  802dfe:	c3                   	ret    
  802dff:	90                   	nop
  802e00:	89 fd                	mov    %edi,%ebp
  802e02:	85 ff                	test   %edi,%edi
  802e04:	75 0b                	jne    802e11 <__umoddi3+0xe9>
  802e06:	b8 01 00 00 00       	mov    $0x1,%eax
  802e0b:	31 d2                	xor    %edx,%edx
  802e0d:	f7 f7                	div    %edi
  802e0f:	89 c5                	mov    %eax,%ebp
  802e11:	89 f0                	mov    %esi,%eax
  802e13:	31 d2                	xor    %edx,%edx
  802e15:	f7 f5                	div    %ebp
  802e17:	89 c8                	mov    %ecx,%eax
  802e19:	f7 f5                	div    %ebp
  802e1b:	89 d0                	mov    %edx,%eax
  802e1d:	e9 44 ff ff ff       	jmp    802d66 <__umoddi3+0x3e>
  802e22:	66 90                	xchg   %ax,%ax
  802e24:	89 c8                	mov    %ecx,%eax
  802e26:	89 f2                	mov    %esi,%edx
  802e28:	83 c4 1c             	add    $0x1c,%esp
  802e2b:	5b                   	pop    %ebx
  802e2c:	5e                   	pop    %esi
  802e2d:	5f                   	pop    %edi
  802e2e:	5d                   	pop    %ebp
  802e2f:	c3                   	ret    
  802e30:	3b 04 24             	cmp    (%esp),%eax
  802e33:	72 06                	jb     802e3b <__umoddi3+0x113>
  802e35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802e39:	77 0f                	ja     802e4a <__umoddi3+0x122>
  802e3b:	89 f2                	mov    %esi,%edx
  802e3d:	29 f9                	sub    %edi,%ecx
  802e3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802e43:	89 14 24             	mov    %edx,(%esp)
  802e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e4e:	8b 14 24             	mov    (%esp),%edx
  802e51:	83 c4 1c             	add    $0x1c,%esp
  802e54:	5b                   	pop    %ebx
  802e55:	5e                   	pop    %esi
  802e56:	5f                   	pop    %edi
  802e57:	5d                   	pop    %ebp
  802e58:	c3                   	ret    
  802e59:	8d 76 00             	lea    0x0(%esi),%esi
  802e5c:	2b 04 24             	sub    (%esp),%eax
  802e5f:	19 fa                	sbb    %edi,%edx
  802e61:	89 d1                	mov    %edx,%ecx
  802e63:	89 c6                	mov    %eax,%esi
  802e65:	e9 71 ff ff ff       	jmp    802ddb <__umoddi3+0xb3>
  802e6a:	66 90                	xchg   %ax,%ax
  802e6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802e70:	72 ea                	jb     802e5c <__umoddi3+0x134>
  802e72:	89 d9                	mov    %ebx,%ecx
  802e74:	e9 62 ff ff ff       	jmp    802ddb <__umoddi3+0xb3>
