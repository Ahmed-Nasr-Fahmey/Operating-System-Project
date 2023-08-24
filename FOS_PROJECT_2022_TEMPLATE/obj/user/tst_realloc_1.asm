
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 00 2d 80 00       	push   $0x802d00
  800067:	e8 05 15 00 00       	call   801571 <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 b0 24 00 00       	call   802524 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 48 25 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 87 22 00 00       	call   802315 <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 24 2d 80 00       	push   $0x802d24
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 54 2d 80 00       	push   $0x802d54
  8000ad:	e8 0b 12 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 6a 24 00 00       	call   802524 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 6c 2d 80 00       	push   $0x802d6c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 54 2d 80 00       	push   $0x802d54
  8000d2:	e8 e6 11 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 e8 24 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 d8 2d 80 00       	push   $0x802dd8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 54 2d 80 00       	push   $0x802d54
  8000f5:	e8 c3 11 00 00       	call   8012bd <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 25 24 00 00       	call   802524 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 bd 24 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 fc 21 00 00       	call   802315 <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 24 2d 80 00       	push   $0x802d24
  800138:	6a 19                	push   $0x19
  80013a:	68 54 2d 80 00       	push   $0x802d54
  80013f:	e8 79 11 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 db 23 00 00       	call   802524 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 6c 2d 80 00       	push   $0x802d6c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 54 2d 80 00       	push   $0x802d54
  800161:	e8 57 11 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 59 24 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 d8 2d 80 00       	push   $0x802dd8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 2d 80 00       	push   $0x802d54
  800184:	e8 34 11 00 00       	call   8012bd <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 96 23 00 00       	call   802524 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 2e 24 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 6d 21 00 00       	call   802315 <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 24 2d 80 00       	push   $0x802d24
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 54 2d 80 00       	push   $0x802d54
  8001d0:	e8 e8 10 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 4a 23 00 00       	call   802524 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 6c 2d 80 00       	push   $0x802d6c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 54 2d 80 00       	push   $0x802d54
  8001f2:	e8 c6 10 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 c8 23 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d8 2d 80 00       	push   $0x802dd8
  80020e:	6a 24                	push   $0x24
  800210:	68 54 2d 80 00       	push   $0x802d54
  800215:	e8 a3 10 00 00       	call   8012bd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 05 23 00 00       	call   802524 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 9d 23 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 dc 20 00 00       	call   802315 <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 24 2d 80 00       	push   $0x802d24
  80025e:	6a 2a                	push   $0x2a
  800260:	68 54 2d 80 00       	push   $0x802d54
  800265:	e8 53 10 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 b5 22 00 00       	call   802524 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 6c 2d 80 00       	push   $0x802d6c
  800280:	6a 2c                	push   $0x2c
  800282:	68 54 2d 80 00       	push   $0x802d54
  800287:	e8 31 10 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 33 23 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 d8 2d 80 00       	push   $0x802dd8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 54 2d 80 00       	push   $0x802d54
  8002aa:	e8 0e 10 00 00       	call   8012bd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 70 22 00 00       	call   802524 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 08 23 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 45 20 00 00       	call   802315 <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 24 2d 80 00       	push   $0x802d24
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 54 2d 80 00       	push   $0x802d54
  8002f9:	e8 bf 0f 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 1e 22 00 00       	call   802524 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 6c 2d 80 00       	push   $0x802d6c
  800317:	6a 35                	push   $0x35
  800319:	68 54 2d 80 00       	push   $0x802d54
  80031e:	e8 9a 0f 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 9c 22 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 d8 2d 80 00       	push   $0x802dd8
  80033a:	6a 36                	push   $0x36
  80033c:	68 54 2d 80 00       	push   $0x802d54
  800341:	e8 77 0f 00 00       	call   8012bd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 d9 21 00 00       	call   802524 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 71 22 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 ae 1f 00 00       	call   802315 <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 24 2d 80 00       	push   $0x802d24
  80038e:	6a 3c                	push   $0x3c
  800390:	68 54 2d 80 00       	push   $0x802d54
  800395:	e8 23 0f 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 85 21 00 00       	call   802524 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 6c 2d 80 00       	push   $0x802d6c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 54 2d 80 00       	push   $0x802d54
  8003b7:	e8 01 0f 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 03 22 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 d8 2d 80 00       	push   $0x802dd8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 54 2d 80 00       	push   $0x802d54
  8003da:	e8 de 0e 00 00       	call   8012bd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 40 21 00 00       	call   802524 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 d8 21 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 11 1f 00 00       	call   802315 <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 24 2d 80 00       	push   $0x802d24
  800426:	6a 45                	push   $0x45
  800428:	68 54 2d 80 00       	push   $0x802d54
  80042d:	e8 8b 0e 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 ea 20 00 00       	call   802524 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 6c 2d 80 00       	push   $0x802d6c
  80044b:	6a 47                	push   $0x47
  80044d:	68 54 2d 80 00       	push   $0x802d54
  800452:	e8 66 0e 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 68 21 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 d8 2d 80 00       	push   $0x802dd8
  80046e:	6a 48                	push   $0x48
  800470:	68 54 2d 80 00       	push   $0x802d54
  800475:	e8 43 0e 00 00       	call   8012bd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 a5 20 00 00       	call   802524 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 3d 21 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 76 1e 00 00       	call   802315 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 24 2d 80 00       	push   $0x802d24
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 54 2d 80 00       	push   $0x802d54
  8004d0:	e8 e8 0d 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 47 20 00 00       	call   802524 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 6c 2d 80 00       	push   $0x802d6c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 54 2d 80 00       	push   $0x802d54
  8004f5:	e8 c3 0d 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 c5 20 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 d8 2d 80 00       	push   $0x802dd8
  800511:	6a 51                	push   $0x51
  800513:	68 54 2d 80 00       	push   $0x802d54
  800518:	e8 a0 0d 00 00       	call   8012bd <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 02 20 00 00       	call   802524 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 9a 20 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 bc 1d 00 00       	call   802315 <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 24 2d 80 00       	push   $0x802d24
  800584:	6a 5a                	push   $0x5a
  800586:	68 54 2d 80 00       	push   $0x802d54
  80058b:	e8 2d 0d 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 8c 1f 00 00       	call   802524 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 6c 2d 80 00       	push   $0x802d6c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 54 2d 80 00       	push   $0x802d54
  8005b0:	e8 08 0d 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 0a 20 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 d8 2d 80 00       	push   $0x802dd8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 54 2d 80 00       	push   $0x802d54
  8005d3:	e8 e5 0c 00 00       	call   8012bd <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 47 1f 00 00       	call   802524 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 df 1f 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 62 1d 00 00       	call   802356 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 c8 1f 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 08 2e 80 00       	push   $0x802e08
  800612:	6a 68                	push   $0x68
  800614:	68 54 2d 80 00       	push   $0x802d54
  800619:	e8 9f 0c 00 00       	call   8012bd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 01 1f 00 00       	call   802524 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 44 2e 80 00       	push   $0x802e44
  800634:	6a 69                	push   $0x69
  800636:	68 54 2d 80 00       	push   $0x802d54
  80063b:	e8 7d 0c 00 00       	call   8012bd <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 df 1e 00 00       	call   802524 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 77 1f 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 fa 1c 00 00       	call   802356 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 60 1f 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 08 2e 80 00       	push   $0x802e08
  80067a:	6a 70                	push   $0x70
  80067c:	68 54 2d 80 00       	push   $0x802d54
  800681:	e8 37 0c 00 00       	call   8012bd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 99 1e 00 00       	call   802524 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 44 2e 80 00       	push   $0x802e44
  80069c:	6a 71                	push   $0x71
  80069e:	68 54 2d 80 00       	push   $0x802d54
  8006a3:	e8 15 0c 00 00       	call   8012bd <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 77 1e 00 00       	call   802524 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 0f 1f 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 92 1c 00 00       	call   802356 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 f8 1e 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 08 2e 80 00       	push   $0x802e08
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 54 2d 80 00       	push   $0x802d54
  8006e9:	e8 cf 0b 00 00       	call   8012bd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 31 1e 00 00       	call   802524 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 44 2e 80 00       	push   $0x802e44
  800704:	6a 79                	push   $0x79
  800706:	68 54 2d 80 00       	push   $0x802d54
  80070b:	e8 ad 0b 00 00       	call   8012bd <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 0f 1e 00 00       	call   802524 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 a7 1e 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 2a 1c 00 00       	call   802356 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 90 1e 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 08 2e 80 00       	push   $0x802e08
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 54 2d 80 00       	push   $0x802d54
  800754:	e8 64 0b 00 00       	call   8012bd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 c6 1d 00 00       	call   802524 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 44 2e 80 00       	push   $0x802e44
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 54 2d 80 00       	push   $0x802d54
  800779:	e8 3f 0b 00 00       	call   8012bd <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 9a 1d 00 00       	call   802524 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 32 1e 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 6d 1b 00 00       	call   802315 <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 24 2d 80 00       	push   $0x802d24
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 54 2d 80 00       	push   $0x802d54
  8007d1:	e8 e7 0a 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 49 1d 00 00       	call   802524 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 6c 2d 80 00       	push   $0x802d6c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 54 2d 80 00       	push   $0x802d54
  8007f6:	e8 c2 0a 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 c4 1d 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 d8 2d 80 00       	push   $0x802dd8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 54 2d 80 00       	push   $0x802d54
  80081c:	e8 9c 0a 00 00       	call   8012bd <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 94 1c 00 00       	call   802524 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 2c 1d 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 f2 1a 00 00       	call   8023aa <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 90 2e 80 00       	push   $0x802e90
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 54 2d 80 00       	push   $0x802d54
  8008e1:	e8 d7 09 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 39 1c 00 00       	call   802524 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 c4 2e 80 00       	push   $0x802ec4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 54 2d 80 00       	push   $0x802d54
  800906:	e8 b2 09 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 b4 1c 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 34 2f 80 00       	push   $0x802f34
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 54 2d 80 00       	push   $0x802d54
  80092a:	e8 8e 09 00 00       	call   8012bd <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 68 2f 80 00       	push   $0x802f68
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 54 2d 80 00       	push   $0x802d54
  8009c8:	e8 f0 08 00 00       	call   8012bd <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 68 2f 80 00       	push   $0x802f68
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 54 2d 80 00       	push   $0x802d54
  800a06:	e8 b2 08 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 68 2f 80 00       	push   $0x802f68
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 54 2d 80 00       	push   $0x802d54
  800a4a:	e8 6e 08 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 68 2f 80 00       	push   $0x802f68
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 54 2d 80 00       	push   $0x802d54
  800a8d:	e8 2b 08 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 7f 1a 00 00       	call   802524 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 17 1b 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 9a 18 00 00       	call   802356 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 00 1b 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 a0 2f 80 00       	push   $0x802fa0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 54 2d 80 00       	push   $0x802d54
  800ae4:	e8 d4 07 00 00       	call   8012bd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 36 1a 00 00       	call   802524 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 44 2e 80 00       	push   $0x802e44
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 54 2d 80 00       	push   $0x802d54
  800b0e:	e8 aa 07 00 00       	call   8012bd <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 f4 2f 80 00       	push   $0x802ff4
  800b1d:	e8 e4 09 00 00       	call   801506 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 fa 19 00 00       	call   802524 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 92 1a 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 c7 17 00 00       	call   802315 <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 24 2d 80 00       	push   $0x802d24
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 54 2d 80 00       	push   $0x802d54
  800b7a:	e8 3e 07 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 a0 19 00 00       	call   802524 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 6c 2d 80 00       	push   $0x802d6c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 54 2d 80 00       	push   $0x802d54
  800b9f:	e8 19 07 00 00       	call   8012bd <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 1b 1a 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 d8 2d 80 00       	push   $0x802dd8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 54 2d 80 00       	push   $0x802d54
  800bc5:	e8 f3 06 00 00       	call   8012bd <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 e4 18 00 00       	call   802524 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 7c 19 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 3b 17 00 00       	call   8023aa <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 90 2e 80 00       	push   $0x802e90
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 54 2d 80 00       	push   $0x802d54
  800c9b:	e8 1d 06 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 1f 19 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 34 2f 80 00       	push   $0x802f34
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 54 2d 80 00       	push   $0x802d54
  800cc1:	e8 f7 05 00 00       	call   8012bd <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 68 2f 80 00       	push   $0x802f68
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 54 2d 80 00       	push   $0x802d54
  800d68:	e8 50 05 00 00       	call   8012bd <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 68 2f 80 00       	push   $0x802f68
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 54 2d 80 00       	push   $0x802d54
  800da6:	e8 12 05 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 68 2f 80 00       	push   $0x802f68
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 54 2d 80 00       	push   $0x802d54
  800dea:	e8 ce 04 00 00       	call   8012bd <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 68 2f 80 00       	push   $0x802f68
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 54 2d 80 00       	push   $0x802d54
  800e2d:	e8 8b 04 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 df 16 00 00       	call   802524 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 77 17 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 fa 14 00 00       	call   802356 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 60 17 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 a0 2f 80 00       	push   $0x802fa0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 54 2d 80 00       	push   $0x802d54
  800e84:	e8 34 04 00 00       	call   8012bd <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 fb 2f 80 00       	push   $0x802ffb
  800e93:	e8 6e 06 00 00       	call   801506 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 1d 16 00 00       	call   802524 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 b5 16 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 80 14 00 00       	call   8023aa <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 90 2e 80 00       	push   $0x802e90
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 54 2d 80 00       	push   $0x802d54
  800f5f:	e8 59 03 00 00       	call   8012bd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 5b 16 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 34 2f 80 00       	push   $0x802f34
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 54 2d 80 00       	push   $0x802d54
  800f85:	e8 33 03 00 00       	call   8012bd <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 68 2f 80 00       	push   $0x802f68
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 54 2d 80 00       	push   $0x802d54
  801023:	e8 95 02 00 00       	call   8012bd <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 68 2f 80 00       	push   $0x802f68
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 54 2d 80 00       	push   $0x802d54
  801061:	e8 57 02 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 68 2f 80 00       	push   $0x802f68
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 54 2d 80 00       	push   $0x802d54
  8010a5:	e8 13 02 00 00       	call   8012bd <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 68 2f 80 00       	push   $0x802f68
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 54 2d 80 00       	push   $0x802d54
  8010e8:	e8 d0 01 00 00       	call   8012bd <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 24 14 00 00       	call   802524 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 bc 14 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 3f 12 00 00       	call   802356 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 a5 14 00 00       	call   8025c4 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 a0 2f 80 00       	push   $0x802fa0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 54 2d 80 00       	push   $0x802d54
  80113f:	e8 79 01 00 00       	call   8012bd <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 02 30 80 00       	push   $0x803002
  80114e:	e8 b3 03 00 00       	call   801506 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 0c 30 80 00       	push   $0x80300c
  80115e:	e8 0e 04 00 00       	call   801571 <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 8b 16 00 00       	call   802804 <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	01 c0                	add    %eax,%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80118c:	01 c8                	add    %ecx,%eax
  80118e:	c1 e0 02             	shl    $0x2,%eax
  801191:	01 d0                	add    %edx,%eax
  801193:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80119a:	01 c8                	add    %ecx,%eax
  80119c:	c1 e0 02             	shl    $0x2,%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	c1 e0 02             	shl    $0x2,%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	c1 e0 03             	shl    $0x3,%eax
  8011a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8011b8:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	74 0f                	je     8011d1 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8011c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8011c7:	05 18 da 01 00       	add    $0x1da18,%eax
  8011cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d5:	7e 0a                	jle    8011e1 <libmain+0x73>
		binaryname = argv[0];
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	8b 00                	mov    (%eax),%eax
  8011dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	e8 49 ee ff ff       	call   800038 <_main>
  8011ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011f2:	e8 1a 14 00 00       	call   802611 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	68 60 30 80 00       	push   $0x803060
  8011ff:	e8 6d 03 00 00       	call   801571 <cprintf>
  801204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801207:	a1 20 40 80 00       	mov    0x804020,%eax
  80120c:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  801212:	a1 20 40 80 00       	mov    0x804020,%eax
  801217:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	52                   	push   %edx
  801221:	50                   	push   %eax
  801222:	68 88 30 80 00       	push   $0x803088
  801227:	e8 45 03 00 00       	call   801571 <cprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80122f:	a1 20 40 80 00       	mov    0x804020,%eax
  801234:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80123a:	a1 20 40 80 00       	mov    0x804020,%eax
  80123f:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  801245:	a1 20 40 80 00       	mov    0x804020,%eax
  80124a:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  801250:	51                   	push   %ecx
  801251:	52                   	push   %edx
  801252:	50                   	push   %eax
  801253:	68 b0 30 80 00       	push   $0x8030b0
  801258:	e8 14 03 00 00       	call   801571 <cprintf>
  80125d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801260:	a1 20 40 80 00       	mov    0x804020,%eax
  801265:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	50                   	push   %eax
  80126f:	68 08 31 80 00       	push   $0x803108
  801274:	e8 f8 02 00 00       	call   801571 <cprintf>
  801279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	68 60 30 80 00       	push   $0x803060
  801284:	e8 e8 02 00 00       	call   801571 <cprintf>
  801289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80128c:	e8 9a 13 00 00       	call   80262b <sys_enable_interrupt>

	// exit gracefully
	exit();
  801291:	e8 19 00 00 00       	call   8012af <exit>
}
  801296:	90                   	nop
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	6a 00                	push   $0x0
  8012a4:	e8 27 15 00 00       	call   8027d0 <sys_destroy_env>
  8012a9:	83 c4 10             	add    $0x10,%esp
}
  8012ac:	90                   	nop
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <exit>:

void
exit(void)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012b5:	e8 7c 15 00 00       	call   802836 <sys_exit_env>
}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c6:	83 c0 04             	add    $0x4,%eax
  8012c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012cc:	a1 58 b2 82 00       	mov    0x82b258,%eax
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	74 16                	je     8012eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012d5:	a1 58 b2 82 00       	mov    0x82b258,%eax
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	50                   	push   %eax
  8012de:	68 1c 31 80 00       	push   $0x80311c
  8012e3:	e8 89 02 00 00       	call   801571 <cprintf>
  8012e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	ff 75 08             	pushl  0x8(%ebp)
  8012f6:	50                   	push   %eax
  8012f7:	68 21 31 80 00       	push   $0x803121
  8012fc:	e8 70 02 00 00       	call   801571 <cprintf>
  801301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	ff 75 f4             	pushl  -0xc(%ebp)
  80130d:	50                   	push   %eax
  80130e:	e8 f3 01 00 00       	call   801506 <vcprintf>
  801313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	6a 00                	push   $0x0
  80131b:	68 3d 31 80 00       	push   $0x80313d
  801320:	e8 e1 01 00 00       	call   801506 <vcprintf>
  801325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801328:	e8 82 ff ff ff       	call   8012af <exit>

	// should not return here
	while (1) ;
  80132d:	eb fe                	jmp    80132d <_panic+0x70>

0080132f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801335:	a1 20 40 80 00       	mov    0x804020,%eax
  80133a:	8b 50 74             	mov    0x74(%eax),%edx
  80133d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801340:	39 c2                	cmp    %eax,%edx
  801342:	74 14                	je     801358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 40 31 80 00       	push   $0x803140
  80134c:	6a 26                	push   $0x26
  80134e:	68 8c 31 80 00       	push   $0x80318c
  801353:	e8 65 ff ff ff       	call   8012bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80135f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801366:	e9 c2 00 00 00       	jmp    80142d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	85 c0                	test   %eax,%eax
  80137e:	75 08                	jne    801388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801383:	e9 a2 00 00 00       	jmp    80142a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80138f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801396:	eb 69                	jmp    801401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801398:	a1 20 40 80 00       	mov    0x804020,%eax
  80139d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8013a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	01 c0                	add    %eax,%eax
  8013aa:	01 d0                	add    %edx,%eax
  8013ac:	c1 e0 03             	shl    $0x3,%eax
  8013af:	01 c8                	add    %ecx,%eax
  8013b1:	8a 40 04             	mov    0x4(%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	75 46                	jne    8013fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8013bd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8013c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013c6:	89 d0                	mov    %edx,%eax
  8013c8:	01 c0                	add    %eax,%eax
  8013ca:	01 d0                	add    %edx,%eax
  8013cc:	c1 e0 03             	shl    $0x3,%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	01 c8                	add    %ecx,%eax
  8013ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013f1:	39 c2                	cmp    %eax,%edx
  8013f3:	75 09                	jne    8013fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013fc:	eb 12                	jmp    801410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013fe:	ff 45 e8             	incl   -0x18(%ebp)
  801401:	a1 20 40 80 00       	mov    0x804020,%eax
  801406:	8b 50 74             	mov    0x74(%eax),%edx
  801409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140c:	39 c2                	cmp    %eax,%edx
  80140e:	77 88                	ja     801398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801414:	75 14                	jne    80142a <CheckWSWithoutLastIndex+0xfb>
			panic(
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	68 98 31 80 00       	push   $0x803198
  80141e:	6a 3a                	push   $0x3a
  801420:	68 8c 31 80 00       	push   $0x80318c
  801425:	e8 93 fe ff ff       	call   8012bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80142a:	ff 45 f0             	incl   -0x10(%ebp)
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801433:	0f 8c 32 ff ff ff    	jl     80136b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801447:	eb 26                	jmp    80146f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801449:	a1 20 40 80 00       	mov    0x804020,%eax
  80144e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801457:	89 d0                	mov    %edx,%eax
  801459:	01 c0                	add    %eax,%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c1 e0 03             	shl    $0x3,%eax
  801460:	01 c8                	add    %ecx,%eax
  801462:	8a 40 04             	mov    0x4(%eax),%al
  801465:	3c 01                	cmp    $0x1,%al
  801467:	75 03                	jne    80146c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80146c:	ff 45 e0             	incl   -0x20(%ebp)
  80146f:	a1 20 40 80 00       	mov    0x804020,%eax
  801474:	8b 50 74             	mov    0x74(%eax),%edx
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	39 c2                	cmp    %eax,%edx
  80147c:	77 cb                	ja     801449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801484:	74 14                	je     80149a <CheckWSWithoutLastIndex+0x16b>
		panic(
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	68 ec 31 80 00       	push   $0x8031ec
  80148e:	6a 44                	push   $0x44
  801490:	68 8c 31 80 00       	push   $0x80318c
  801495:	e8 23 fe ff ff       	call   8012bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	89 0a                	mov    %ecx,(%edx)
  8014b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b3:	88 d1                	mov    %dl,%cl
  8014b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	8b 00                	mov    (%eax),%eax
  8014c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014c6:	75 2c                	jne    8014f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014c8:	a0 24 40 80 00       	mov    0x804024,%al
  8014cd:	0f b6 c0             	movzbl %al,%eax
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	8b 12                	mov    (%edx),%edx
  8014d5:	89 d1                	mov    %edx,%ecx
  8014d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014da:	83 c2 08             	add    $0x8,%edx
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	50                   	push   %eax
  8014e1:	51                   	push   %ecx
  8014e2:	52                   	push   %edx
  8014e3:	e8 7b 0f 00 00       	call   802463 <sys_cputs>
  8014e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	8b 40 04             	mov    0x4(%eax),%eax
  8014fa:	8d 50 01             	lea    0x1(%eax),%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	89 50 04             	mov    %edx,0x4(%eax)
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80150f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801516:	00 00 00 
	b.cnt = 0;
  801519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801523:	ff 75 0c             	pushl  0xc(%ebp)
  801526:	ff 75 08             	pushl  0x8(%ebp)
  801529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	68 9d 14 80 00       	push   $0x80149d
  801535:	e8 11 02 00 00       	call   80174b <vprintfmt>
  80153a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80153d:	a0 24 40 80 00       	mov    0x804024,%al
  801542:	0f b6 c0             	movzbl %al,%eax
  801545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	50                   	push   %eax
  80154f:	52                   	push   %edx
  801550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801556:	83 c0 08             	add    $0x8,%eax
  801559:	50                   	push   %eax
  80155a:	e8 04 0f 00 00       	call   802463 <sys_cputs>
  80155f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  801569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <cprintf>:

int cprintf(const char *fmt, ...) {
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80157e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	ff 75 f4             	pushl  -0xc(%ebp)
  80158d:	50                   	push   %eax
  80158e:	e8 73 ff ff ff       	call   801506 <vcprintf>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8015a4:	e8 68 10 00 00       	call   802611 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b8:	50                   	push   %eax
  8015b9:	e8 48 ff ff ff       	call   801506 <vcprintf>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015c4:	e8 62 10 00 00       	call   80262b <sys_enable_interrupt>
	return cnt;
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 14             	sub    $0x14,%esp
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015db:	8b 45 14             	mov    0x14(%ebp),%eax
  8015de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8015e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015ec:	77 55                	ja     801643 <printnum+0x75>
  8015ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015f1:	72 05                	jb     8015f8 <printnum+0x2a>
  8015f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f6:	77 4b                	ja     801643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015fe:	8b 45 18             	mov    0x18(%ebp),%eax
  801601:	ba 00 00 00 00       	mov    $0x0,%edx
  801606:	52                   	push   %edx
  801607:	50                   	push   %eax
  801608:	ff 75 f4             	pushl  -0xc(%ebp)
  80160b:	ff 75 f0             	pushl  -0x10(%ebp)
  80160e:	e8 85 14 00 00       	call   802a98 <__udivdi3>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	ff 75 20             	pushl  0x20(%ebp)
  80161c:	53                   	push   %ebx
  80161d:	ff 75 18             	pushl  0x18(%ebp)
  801620:	52                   	push   %edx
  801621:	50                   	push   %eax
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 08             	pushl  0x8(%ebp)
  801628:	e8 a1 ff ff ff       	call   8015ce <printnum>
  80162d:	83 c4 20             	add    $0x20,%esp
  801630:	eb 1a                	jmp    80164c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	ff 75 20             	pushl  0x20(%ebp)
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	ff d0                	call   *%eax
  801640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801643:	ff 4d 1c             	decl   0x1c(%ebp)
  801646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80164a:	7f e6                	jg     801632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80164c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80164f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165a:	53                   	push   %ebx
  80165b:	51                   	push   %ecx
  80165c:	52                   	push   %edx
  80165d:	50                   	push   %eax
  80165e:	e8 45 15 00 00       	call   802ba8 <__umoddi3>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	05 54 34 80 00       	add    $0x803454,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	0f be c0             	movsbl %al,%eax
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	ff d0                	call   *%eax
  80167c:	83 c4 10             	add    $0x10,%esp
}
  80167f:	90                   	nop
  801680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80168c:	7e 1c                	jle    8016aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8b 00                	mov    (%eax),%eax
  801693:	8d 50 08             	lea    0x8(%eax),%edx
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	89 10                	mov    %edx,(%eax)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8b 00                	mov    (%eax),%eax
  8016a0:	83 e8 08             	sub    $0x8,%eax
  8016a3:	8b 50 04             	mov    0x4(%eax),%edx
  8016a6:	8b 00                	mov    (%eax),%eax
  8016a8:	eb 40                	jmp    8016ea <getuint+0x65>
	else if (lflag)
  8016aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ae:	74 1e                	je     8016ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8b 00                	mov    (%eax),%eax
  8016b5:	8d 50 04             	lea    0x4(%eax),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	89 10                	mov    %edx,(%eax)
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8b 00                	mov    (%eax),%eax
  8016c2:	83 e8 04             	sub    $0x4,%eax
  8016c5:	8b 00                	mov    (%eax),%eax
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	eb 1c                	jmp    8016ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8b 00                	mov    (%eax),%eax
  8016d3:	8d 50 04             	lea    0x4(%eax),%edx
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	89 10                	mov    %edx,(%eax)
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8b 00                	mov    (%eax),%eax
  8016e0:	83 e8 04             	sub    $0x4,%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016f3:	7e 1c                	jle    801711 <getint+0x25>
		return va_arg(*ap, long long);
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8b 00                	mov    (%eax),%eax
  8016fa:	8d 50 08             	lea    0x8(%eax),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	89 10                	mov    %edx,(%eax)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	83 e8 08             	sub    $0x8,%eax
  80170a:	8b 50 04             	mov    0x4(%eax),%edx
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	eb 38                	jmp    801749 <getint+0x5d>
	else if (lflag)
  801711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801715:	74 1a                	je     801731 <getint+0x45>
		return va_arg(*ap, long);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8b 00                	mov    (%eax),%eax
  80171c:	8d 50 04             	lea    0x4(%eax),%edx
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	89 10                	mov    %edx,(%eax)
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	83 e8 04             	sub    $0x4,%eax
  80172c:	8b 00                	mov    (%eax),%eax
  80172e:	99                   	cltd   
  80172f:	eb 18                	jmp    801749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 00                	mov    (%eax),%eax
  801736:	8d 50 04             	lea    0x4(%eax),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	89 10                	mov    %edx,(%eax)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	83 e8 04             	sub    $0x4,%eax
  801746:	8b 00                	mov    (%eax),%eax
  801748:	99                   	cltd   
}
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    

0080174b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	56                   	push   %esi
  80174f:	53                   	push   %ebx
  801750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801753:	eb 17                	jmp    80176c <vprintfmt+0x21>
			if (ch == '\0')
  801755:	85 db                	test   %ebx,%ebx
  801757:	0f 84 af 03 00 00    	je     801b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	53                   	push   %ebx
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	ff d0                	call   *%eax
  801769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80176c:	8b 45 10             	mov    0x10(%ebp),%eax
  80176f:	8d 50 01             	lea    0x1(%eax),%edx
  801772:	89 55 10             	mov    %edx,0x10(%ebp)
  801775:	8a 00                	mov    (%eax),%al
  801777:	0f b6 d8             	movzbl %al,%ebx
  80177a:	83 fb 25             	cmp    $0x25,%ebx
  80177d:	75 d6                	jne    801755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80177f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80178a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80179f:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a2:	8d 50 01             	lea    0x1(%eax),%edx
  8017a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	0f b6 d8             	movzbl %al,%ebx
  8017ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8017b0:	83 f8 55             	cmp    $0x55,%eax
  8017b3:	0f 87 2b 03 00 00    	ja     801ae4 <vprintfmt+0x399>
  8017b9:	8b 04 85 78 34 80 00 	mov    0x803478(,%eax,4),%eax
  8017c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017c6:	eb d7                	jmp    80179f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017cc:	eb d1                	jmp    80179f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017d8:	89 d0                	mov    %edx,%eax
  8017da:	c1 e0 02             	shl    $0x2,%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	01 c0                	add    %eax,%eax
  8017e1:	01 d8                	add    %ebx,%eax
  8017e3:	83 e8 30             	sub    $0x30,%eax
  8017e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8017f4:	7e 3e                	jle    801834 <vprintfmt+0xe9>
  8017f6:	83 fb 39             	cmp    $0x39,%ebx
  8017f9:	7f 39                	jg     801834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017fe:	eb d5                	jmp    8017d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801800:	8b 45 14             	mov    0x14(%ebp),%eax
  801803:	83 c0 04             	add    $0x4,%eax
  801806:	89 45 14             	mov    %eax,0x14(%ebp)
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	83 e8 04             	sub    $0x4,%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801814:	eb 1f                	jmp    801835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80181a:	79 83                	jns    80179f <vprintfmt+0x54>
				width = 0;
  80181c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801823:	e9 77 ff ff ff       	jmp    80179f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80182f:	e9 6b ff ff ff       	jmp    80179f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801839:	0f 89 60 ff ff ff    	jns    80179f <vprintfmt+0x54>
				width = precision, precision = -1;
  80183f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80184c:	e9 4e ff ff ff       	jmp    80179f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801854:	e9 46 ff ff ff       	jmp    80179f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801859:	8b 45 14             	mov    0x14(%ebp),%eax
  80185c:	83 c0 04             	add    $0x4,%eax
  80185f:	89 45 14             	mov    %eax,0x14(%ebp)
  801862:	8b 45 14             	mov    0x14(%ebp),%eax
  801865:	83 e8 04             	sub    $0x4,%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	50                   	push   %eax
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	ff d0                	call   *%eax
  801876:	83 c4 10             	add    $0x10,%esp
			break;
  801879:	e9 89 02 00 00       	jmp    801b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80187e:	8b 45 14             	mov    0x14(%ebp),%eax
  801881:	83 c0 04             	add    $0x4,%eax
  801884:	89 45 14             	mov    %eax,0x14(%ebp)
  801887:	8b 45 14             	mov    0x14(%ebp),%eax
  80188a:	83 e8 04             	sub    $0x4,%eax
  80188d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80188f:	85 db                	test   %ebx,%ebx
  801891:	79 02                	jns    801895 <vprintfmt+0x14a>
				err = -err;
  801893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801895:	83 fb 64             	cmp    $0x64,%ebx
  801898:	7f 0b                	jg     8018a5 <vprintfmt+0x15a>
  80189a:	8b 34 9d c0 32 80 00 	mov    0x8032c0(,%ebx,4),%esi
  8018a1:	85 f6                	test   %esi,%esi
  8018a3:	75 19                	jne    8018be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8018a5:	53                   	push   %ebx
  8018a6:	68 65 34 80 00       	push   $0x803465
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 5e 02 00 00       	call   801b14 <printfmt>
  8018b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018b9:	e9 49 02 00 00       	jmp    801b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018be:	56                   	push   %esi
  8018bf:	68 6e 34 80 00       	push   $0x80346e
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	e8 45 02 00 00       	call   801b14 <printfmt>
  8018cf:	83 c4 10             	add    $0x10,%esp
			break;
  8018d2:	e9 30 02 00 00       	jmp    801b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018da:	83 c0 04             	add    $0x4,%eax
  8018dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e3:	83 e8 04             	sub    $0x4,%eax
  8018e6:	8b 30                	mov    (%eax),%esi
  8018e8:	85 f6                	test   %esi,%esi
  8018ea:	75 05                	jne    8018f1 <vprintfmt+0x1a6>
				p = "(null)";
  8018ec:	be 71 34 80 00       	mov    $0x803471,%esi
			if (width > 0 && padc != '-')
  8018f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018f5:	7e 6d                	jle    801964 <vprintfmt+0x219>
  8018f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018fb:	74 67                	je     801964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	50                   	push   %eax
  801904:	56                   	push   %esi
  801905:	e8 0c 03 00 00       	call   801c16 <strnlen>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801910:	eb 16                	jmp    801928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	50                   	push   %eax
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	ff d0                	call   *%eax
  801922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801925:	ff 4d e4             	decl   -0x1c(%ebp)
  801928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192c:	7f e4                	jg     801912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80192e:	eb 34                	jmp    801964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801934:	74 1c                	je     801952 <vprintfmt+0x207>
  801936:	83 fb 1f             	cmp    $0x1f,%ebx
  801939:	7e 05                	jle    801940 <vprintfmt+0x1f5>
  80193b:	83 fb 7e             	cmp    $0x7e,%ebx
  80193e:	7e 12                	jle    801952 <vprintfmt+0x207>
					putch('?', putdat);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	6a 3f                	push   $0x3f
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	ff d0                	call   *%eax
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb 0f                	jmp    801961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	53                   	push   %ebx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	ff d0                	call   *%eax
  80195e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801961:	ff 4d e4             	decl   -0x1c(%ebp)
  801964:	89 f0                	mov    %esi,%eax
  801966:	8d 70 01             	lea    0x1(%eax),%esi
  801969:	8a 00                	mov    (%eax),%al
  80196b:	0f be d8             	movsbl %al,%ebx
  80196e:	85 db                	test   %ebx,%ebx
  801970:	74 24                	je     801996 <vprintfmt+0x24b>
  801972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801976:	78 b8                	js     801930 <vprintfmt+0x1e5>
  801978:	ff 4d e0             	decl   -0x20(%ebp)
  80197b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80197f:	79 af                	jns    801930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801981:	eb 13                	jmp    801996 <vprintfmt+0x24b>
				putch(' ', putdat);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	6a 20                	push   $0x20
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	ff d0                	call   *%eax
  801990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801993:	ff 4d e4             	decl   -0x1c(%ebp)
  801996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80199a:	7f e7                	jg     801983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80199c:	e9 66 01 00 00       	jmp    801b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8019aa:	50                   	push   %eax
  8019ab:	e8 3c fd ff ff       	call   8016ec <getint>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019bf:	85 d2                	test   %edx,%edx
  8019c1:	79 23                	jns    8019e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	6a 2d                	push   $0x2d
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	ff d0                	call   *%eax
  8019d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d9:	f7 d8                	neg    %eax
  8019db:	83 d2 00             	adc    $0x0,%edx
  8019de:	f7 da                	neg    %edx
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019ed:	e9 bc 00 00 00       	jmp    801aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8019f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8019fb:	50                   	push   %eax
  8019fc:	e8 84 fc ff ff       	call   801685 <getuint>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a11:	e9 98 00 00 00       	jmp    801aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	6a 58                	push   $0x58
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	ff d0                	call   *%eax
  801a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	6a 58                	push   $0x58
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	ff d0                	call   *%eax
  801a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	6a 58                	push   $0x58
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	ff d0                	call   *%eax
  801a43:	83 c4 10             	add    $0x10,%esp
			break;
  801a46:	e9 bc 00 00 00       	jmp    801b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	6a 30                	push   $0x30
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	ff d0                	call   *%eax
  801a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	6a 78                	push   $0x78
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	ff d0                	call   *%eax
  801a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6e:	83 c0 04             	add    $0x4,%eax
  801a71:	89 45 14             	mov    %eax,0x14(%ebp)
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	83 e8 04             	sub    $0x4,%eax
  801a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a8d:	eb 1f                	jmp    801aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 e8             	pushl  -0x18(%ebp)
  801a95:	8d 45 14             	lea    0x14(%ebp),%eax
  801a98:	50                   	push   %eax
  801a99:	e8 e7 fb ff ff       	call   801685 <getuint>
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	52                   	push   %edx
  801ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801abc:	50                   	push   %eax
  801abd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	e8 00 fb ff ff       	call   8015ce <printnum>
  801ace:	83 c4 20             	add    $0x20,%esp
			break;
  801ad1:	eb 34                	jmp    801b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ad3:	83 ec 08             	sub    $0x8,%esp
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	53                   	push   %ebx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	ff d0                	call   *%eax
  801adf:	83 c4 10             	add    $0x10,%esp
			break;
  801ae2:	eb 23                	jmp    801b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	6a 25                	push   $0x25
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	ff d0                	call   *%eax
  801af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801af4:	ff 4d 10             	decl   0x10(%ebp)
  801af7:	eb 03                	jmp    801afc <vprintfmt+0x3b1>
  801af9:	ff 4d 10             	decl   0x10(%ebp)
  801afc:	8b 45 10             	mov    0x10(%ebp),%eax
  801aff:	48                   	dec    %eax
  801b00:	8a 00                	mov    (%eax),%al
  801b02:	3c 25                	cmp    $0x25,%al
  801b04:	75 f3                	jne    801af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801b06:	90                   	nop
		}
	}
  801b07:	e9 47 fc ff ff       	jmp    801753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b10:	5b                   	pop    %ebx
  801b11:	5e                   	pop    %esi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    

00801b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  801b1d:	83 c0 04             	add    $0x4,%eax
  801b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b23:	8b 45 10             	mov    0x10(%ebp),%eax
  801b26:	ff 75 f4             	pushl  -0xc(%ebp)
  801b29:	50                   	push   %eax
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	e8 16 fc ff ff       	call   80174b <vprintfmt>
  801b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b41:	8b 40 08             	mov    0x8(%eax),%eax
  801b44:	8d 50 01             	lea    0x1(%eax),%edx
  801b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b50:	8b 10                	mov    (%eax),%edx
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	8b 40 04             	mov    0x4(%eax),%eax
  801b58:	39 c2                	cmp    %eax,%edx
  801b5a:	73 12                	jae    801b6e <sprintputch+0x33>
		*b->buf++ = ch;
  801b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5f:	8b 00                	mov    (%eax),%eax
  801b61:	8d 48 01             	lea    0x1(%eax),%ecx
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	89 0a                	mov    %ecx,(%edx)
  801b69:	8b 55 08             	mov    0x8(%ebp),%edx
  801b6c:	88 10                	mov    %dl,(%eax)
}
  801b6e:	90                   	nop
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	01 d0                	add    %edx,%eax
  801b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b96:	74 06                	je     801b9e <vsnprintf+0x2d>
  801b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b9c:	7f 07                	jg     801ba5 <vsnprintf+0x34>
		return -E_INVAL;
  801b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba3:	eb 20                	jmp    801bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ba5:	ff 75 14             	pushl  0x14(%ebp)
  801ba8:	ff 75 10             	pushl  0x10(%ebp)
  801bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bae:	50                   	push   %eax
  801baf:	68 3b 1b 80 00       	push   $0x801b3b
  801bb4:	e8 92 fb ff ff       	call   80174b <vprintfmt>
  801bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  801bd0:	83 c0 04             	add    $0x4,%eax
  801bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bdc:	50                   	push   %eax
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	e8 89 ff ff ff       	call   801b71 <vsnprintf>
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c00:	eb 06                	jmp    801c08 <strlen+0x15>
		n++;
  801c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801c05:	ff 45 08             	incl   0x8(%ebp)
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	84 c0                	test   %al,%al
  801c0f:	75 f1                	jne    801c02 <strlen+0xf>
		n++;
	return n;
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c23:	eb 09                	jmp    801c2e <strnlen+0x18>
		n++;
  801c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c28:	ff 45 08             	incl   0x8(%ebp)
  801c2b:	ff 4d 0c             	decl   0xc(%ebp)
  801c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c32:	74 09                	je     801c3d <strnlen+0x27>
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	8a 00                	mov    (%eax),%al
  801c39:	84 c0                	test   %al,%al
  801c3b:	75 e8                	jne    801c25 <strnlen+0xf>
		n++;
	return n;
  801c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c4e:	90                   	nop
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8d 50 01             	lea    0x1(%eax),%edx
  801c55:	89 55 08             	mov    %edx,0x8(%ebp)
  801c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c61:	8a 12                	mov    (%edx),%dl
  801c63:	88 10                	mov    %dl,(%eax)
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	84 c0                	test   %al,%al
  801c69:	75 e4                	jne    801c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c83:	eb 1f                	jmp    801ca4 <strncpy+0x34>
		*dst++ = *src;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	8d 50 01             	lea    0x1(%eax),%edx
  801c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8a 12                	mov    (%edx),%dl
  801c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	8a 00                	mov    (%eax),%al
  801c9a:	84 c0                	test   %al,%al
  801c9c:	74 03                	je     801ca1 <strncpy+0x31>
			src++;
  801c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ca1:	ff 45 fc             	incl   -0x4(%ebp)
  801ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  801caa:	72 d9                	jb     801c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc1:	74 30                	je     801cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cc3:	eb 16                	jmp    801cdb <strlcpy+0x2a>
			*dst++ = *src++;
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8d 50 01             	lea    0x1(%eax),%edx
  801ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cd7:	8a 12                	mov    (%edx),%dl
  801cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cdb:	ff 4d 10             	decl   0x10(%ebp)
  801cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ce2:	74 09                	je     801ced <strlcpy+0x3c>
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	75 d8                	jne    801cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cf9:	29 c2                	sub    %eax,%edx
  801cfb:	89 d0                	mov    %edx,%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801d02:	eb 06                	jmp    801d0a <strcmp+0xb>
		p++, q++;
  801d04:	ff 45 08             	incl   0x8(%ebp)
  801d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8a 00                	mov    (%eax),%al
  801d0f:	84 c0                	test   %al,%al
  801d11:	74 0e                	je     801d21 <strcmp+0x22>
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8a 10                	mov    (%eax),%dl
  801d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1b:	8a 00                	mov    (%eax),%al
  801d1d:	38 c2                	cmp    %al,%dl
  801d1f:	74 e3                	je     801d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	0f b6 d0             	movzbl %al,%edx
  801d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2c:	8a 00                	mov    (%eax),%al
  801d2e:	0f b6 c0             	movzbl %al,%eax
  801d31:	29 c2                	sub    %eax,%edx
  801d33:	89 d0                	mov    %edx,%eax
}
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    

00801d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d3a:	eb 09                	jmp    801d45 <strncmp+0xe>
		n--, p++, q++;
  801d3c:	ff 4d 10             	decl   0x10(%ebp)
  801d3f:	ff 45 08             	incl   0x8(%ebp)
  801d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d49:	74 17                	je     801d62 <strncmp+0x2b>
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	84 c0                	test   %al,%al
  801d52:	74 0e                	je     801d62 <strncmp+0x2b>
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	8a 10                	mov    (%eax),%dl
  801d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5c:	8a 00                	mov    (%eax),%al
  801d5e:	38 c2                	cmp    %al,%dl
  801d60:	74 da                	je     801d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d66:	75 07                	jne    801d6f <strncmp+0x38>
		return 0;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6d:	eb 14                	jmp    801d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	8a 00                	mov    (%eax),%al
  801d74:	0f b6 d0             	movzbl %al,%edx
  801d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7a:	8a 00                	mov    (%eax),%al
  801d7c:	0f b6 c0             	movzbl %al,%eax
  801d7f:	29 c2                	sub    %eax,%edx
  801d81:	89 d0                	mov    %edx,%eax
}
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d91:	eb 12                	jmp    801da5 <strchr+0x20>
		if (*s == c)
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	8a 00                	mov    (%eax),%al
  801d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d9b:	75 05                	jne    801da2 <strchr+0x1d>
			return (char *) s;
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	eb 11                	jmp    801db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801da2:	ff 45 08             	incl   0x8(%ebp)
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	8a 00                	mov    (%eax),%al
  801daa:	84 c0                	test   %al,%al
  801dac:	75 e5                	jne    801d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dc1:	eb 0d                	jmp    801dd0 <strfind+0x1b>
		if (*s == c)
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	8a 00                	mov    (%eax),%al
  801dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801dcb:	74 0e                	je     801ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dcd:	ff 45 08             	incl   0x8(%ebp)
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	8a 00                	mov    (%eax),%al
  801dd5:	84 c0                	test   %al,%al
  801dd7:	75 ea                	jne    801dc3 <strfind+0xe>
  801dd9:	eb 01                	jmp    801ddc <strfind+0x27>
		if (*s == c)
			break;
  801ddb:	90                   	nop
	return (char *) s;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801df3:	eb 0e                	jmp    801e03 <memset+0x22>
		*p++ = c;
  801df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df8:	8d 50 01             	lea    0x1(%eax),%edx
  801dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801e03:	ff 4d f8             	decl   -0x8(%ebp)
  801e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801e0a:	79 e9                	jns    801df5 <memset+0x14>
		*p++ = c;

	return v;
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e23:	eb 16                	jmp    801e3b <memcpy+0x2a>
		*d++ = *s++;
  801e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e28:	8d 50 01             	lea    0x1(%eax),%edx
  801e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e37:	8a 12                	mov    (%edx),%dl
  801e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e41:	89 55 10             	mov    %edx,0x10(%ebp)
  801e44:	85 c0                	test   %eax,%eax
  801e46:	75 dd                	jne    801e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e65:	73 50                	jae    801eb7 <memmove+0x6a>
  801e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6d:	01 d0                	add    %edx,%eax
  801e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e72:	76 43                	jbe    801eb7 <memmove+0x6a>
		s += n;
  801e74:	8b 45 10             	mov    0x10(%ebp),%eax
  801e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e80:	eb 10                	jmp    801e92 <memmove+0x45>
			*--d = *--s;
  801e82:	ff 4d f8             	decl   -0x8(%ebp)
  801e85:	ff 4d fc             	decl   -0x4(%ebp)
  801e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8b:	8a 10                	mov    (%eax),%dl
  801e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e92:	8b 45 10             	mov    0x10(%ebp),%eax
  801e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e98:	89 55 10             	mov    %edx,0x10(%ebp)
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	75 e3                	jne    801e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e9f:	eb 23                	jmp    801ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea4:	8d 50 01             	lea    0x1(%eax),%edx
  801ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  801eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801eb3:	8a 12                	mov    (%edx),%dl
  801eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	75 dd                	jne    801ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801edb:	eb 2a                	jmp    801f07 <memcmp+0x3e>
		if (*s1 != *s2)
  801edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee0:	8a 10                	mov    (%eax),%dl
  801ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee5:	8a 00                	mov    (%eax),%al
  801ee7:	38 c2                	cmp    %al,%dl
  801ee9:	74 16                	je     801f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eee:	8a 00                	mov    (%eax),%al
  801ef0:	0f b6 d0             	movzbl %al,%edx
  801ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef6:	8a 00                	mov    (%eax),%al
  801ef8:	0f b6 c0             	movzbl %al,%eax
  801efb:	29 c2                	sub    %eax,%edx
  801efd:	89 d0                	mov    %edx,%eax
  801eff:	eb 18                	jmp    801f19 <memcmp+0x50>
		s1++, s2++;
  801f01:	ff 45 fc             	incl   -0x4(%ebp)
  801f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  801f10:	85 c0                	test   %eax,%eax
  801f12:	75 c9                	jne    801edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f21:	8b 55 08             	mov    0x8(%ebp),%edx
  801f24:	8b 45 10             	mov    0x10(%ebp),%eax
  801f27:	01 d0                	add    %edx,%eax
  801f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f2c:	eb 15                	jmp    801f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8a 00                	mov    (%eax),%al
  801f33:	0f b6 d0             	movzbl %al,%edx
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	0f b6 c0             	movzbl %al,%eax
  801f3c:	39 c2                	cmp    %eax,%edx
  801f3e:	74 0d                	je     801f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f40:	ff 45 08             	incl   0x8(%ebp)
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f49:	72 e3                	jb     801f2e <memfind+0x13>
  801f4b:	eb 01                	jmp    801f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f4d:	90                   	nop
	return (void *) s;
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f67:	eb 03                	jmp    801f6c <strtol+0x19>
		s++;
  801f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	8a 00                	mov    (%eax),%al
  801f71:	3c 20                	cmp    $0x20,%al
  801f73:	74 f4                	je     801f69 <strtol+0x16>
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8a 00                	mov    (%eax),%al
  801f7a:	3c 09                	cmp    $0x9,%al
  801f7c:	74 eb                	je     801f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8a 00                	mov    (%eax),%al
  801f83:	3c 2b                	cmp    $0x2b,%al
  801f85:	75 05                	jne    801f8c <strtol+0x39>
		s++;
  801f87:	ff 45 08             	incl   0x8(%ebp)
  801f8a:	eb 13                	jmp    801f9f <strtol+0x4c>
	else if (*s == '-')
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	8a 00                	mov    (%eax),%al
  801f91:	3c 2d                	cmp    $0x2d,%al
  801f93:	75 0a                	jne    801f9f <strtol+0x4c>
		s++, neg = 1;
  801f95:	ff 45 08             	incl   0x8(%ebp)
  801f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa3:	74 06                	je     801fab <strtol+0x58>
  801fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801fa9:	75 20                	jne    801fcb <strtol+0x78>
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	8a 00                	mov    (%eax),%al
  801fb0:	3c 30                	cmp    $0x30,%al
  801fb2:	75 17                	jne    801fcb <strtol+0x78>
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	40                   	inc    %eax
  801fb8:	8a 00                	mov    (%eax),%al
  801fba:	3c 78                	cmp    $0x78,%al
  801fbc:	75 0d                	jne    801fcb <strtol+0x78>
		s += 2, base = 16;
  801fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fc9:	eb 28                	jmp    801ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fcf:	75 15                	jne    801fe6 <strtol+0x93>
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	8a 00                	mov    (%eax),%al
  801fd6:	3c 30                	cmp    $0x30,%al
  801fd8:	75 0c                	jne    801fe6 <strtol+0x93>
		s++, base = 8;
  801fda:	ff 45 08             	incl   0x8(%ebp)
  801fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fe4:	eb 0d                	jmp    801ff3 <strtol+0xa0>
	else if (base == 0)
  801fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fea:	75 07                	jne    801ff3 <strtol+0xa0>
		base = 10;
  801fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	3c 2f                	cmp    $0x2f,%al
  801ffa:	7e 19                	jle    802015 <strtol+0xc2>
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	3c 39                	cmp    $0x39,%al
  802003:	7f 10                	jg     802015 <strtol+0xc2>
			dig = *s - '0';
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	8a 00                	mov    (%eax),%al
  80200a:	0f be c0             	movsbl %al,%eax
  80200d:	83 e8 30             	sub    $0x30,%eax
  802010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802013:	eb 42                	jmp    802057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8a 00                	mov    (%eax),%al
  80201a:	3c 60                	cmp    $0x60,%al
  80201c:	7e 19                	jle    802037 <strtol+0xe4>
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	8a 00                	mov    (%eax),%al
  802023:	3c 7a                	cmp    $0x7a,%al
  802025:	7f 10                	jg     802037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	8a 00                	mov    (%eax),%al
  80202c:	0f be c0             	movsbl %al,%eax
  80202f:	83 e8 57             	sub    $0x57,%eax
  802032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802035:	eb 20                	jmp    802057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8a 00                	mov    (%eax),%al
  80203c:	3c 40                	cmp    $0x40,%al
  80203e:	7e 39                	jle    802079 <strtol+0x126>
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8a 00                	mov    (%eax),%al
  802045:	3c 5a                	cmp    $0x5a,%al
  802047:	7f 30                	jg     802079 <strtol+0x126>
			dig = *s - 'A' + 10;
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	0f be c0             	movsbl %al,%eax
  802051:	83 e8 37             	sub    $0x37,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80205d:	7d 19                	jge    802078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80205f:	ff 45 08             	incl   0x8(%ebp)
  802062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802065:	0f af 45 10          	imul   0x10(%ebp),%eax
  802069:	89 c2                	mov    %eax,%edx
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	01 d0                	add    %edx,%eax
  802070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802073:	e9 7b ff ff ff       	jmp    801ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80207d:	74 08                	je     802087 <strtol+0x134>
		*endptr = (char *) s;
  80207f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802082:	8b 55 08             	mov    0x8(%ebp),%edx
  802085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208b:	74 07                	je     802094 <strtol+0x141>
  80208d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802090:	f7 d8                	neg    %eax
  802092:	eb 03                	jmp    802097 <strtol+0x144>
  802094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <ltostr>:

void
ltostr(long value, char *str)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80209f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8020a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8020ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b1:	79 13                	jns    8020c6 <ltostr+0x2d>
	{
		neg = 1;
  8020b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020ce:	99                   	cltd   
  8020cf:	f7 f9                	idiv   %ecx
  8020d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d7:	8d 50 01             	lea    0x1(%eax),%edx
  8020da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020dd:	89 c2                	mov    %eax,%edx
  8020df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e7:	83 c2 30             	add    $0x30,%edx
  8020ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020f4:	f7 e9                	imul   %ecx
  8020f6:	c1 fa 02             	sar    $0x2,%edx
  8020f9:	89 c8                	mov    %ecx,%eax
  8020fb:	c1 f8 1f             	sar    $0x1f,%eax
  8020fe:	29 c2                	sub    %eax,%edx
  802100:	89 d0                	mov    %edx,%eax
  802102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80210d:	f7 e9                	imul   %ecx
  80210f:	c1 fa 02             	sar    $0x2,%edx
  802112:	89 c8                	mov    %ecx,%eax
  802114:	c1 f8 1f             	sar    $0x1f,%eax
  802117:	29 c2                	sub    %eax,%edx
  802119:	89 d0                	mov    %edx,%eax
  80211b:	c1 e0 02             	shl    $0x2,%eax
  80211e:	01 d0                	add    %edx,%eax
  802120:	01 c0                	add    %eax,%eax
  802122:	29 c1                	sub    %eax,%ecx
  802124:	89 ca                	mov    %ecx,%edx
  802126:	85 d2                	test   %edx,%edx
  802128:	75 9c                	jne    8020c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80212a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802134:	48                   	dec    %eax
  802135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213c:	74 3d                	je     80217b <ltostr+0xe2>
		start = 1 ;
  80213e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802145:	eb 34                	jmp    80217b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214d:	01 d0                	add    %edx,%eax
  80214f:	8a 00                	mov    (%eax),%al
  802151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	01 c2                	add    %eax,%edx
  80215c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80215f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802162:	01 c8                	add    %ecx,%eax
  802164:	8a 00                	mov    (%eax),%al
  802166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216e:	01 c2                	add    %eax,%edx
  802170:	8a 45 eb             	mov    -0x15(%ebp),%al
  802173:	88 02                	mov    %al,(%edx)
		start++ ;
  802175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802181:	7c c4                	jl     802147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802186:	8b 45 0c             	mov    0xc(%ebp),%eax
  802189:	01 d0                	add    %edx,%eax
  80218b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80218e:	90                   	nop
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	e8 54 fa ff ff       	call   801bf3 <strlen>
  80219f:	83 c4 04             	add    $0x4,%esp
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	e8 46 fa ff ff       	call   801bf3 <strlen>
  8021ad:	83 c4 04             	add    $0x4,%esp
  8021b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021c1:	eb 17                	jmp    8021da <strcconcat+0x49>
		final[s] = str1[s] ;
  8021c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c9:	01 c2                	add    %eax,%edx
  8021cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	01 c8                	add    %ecx,%eax
  8021d3:	8a 00                	mov    (%eax),%al
  8021d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021d7:	ff 45 fc             	incl   -0x4(%ebp)
  8021da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021e0:	7c e1                	jl     8021c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021f0:	eb 1f                	jmp    802211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f5:	8d 50 01             	lea    0x1(%eax),%edx
  8021f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021fb:	89 c2                	mov    %eax,%edx
  8021fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802200:	01 c2                	add    %eax,%edx
  802202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802205:	8b 45 0c             	mov    0xc(%ebp),%eax
  802208:	01 c8                	add    %ecx,%eax
  80220a:	8a 00                	mov    (%eax),%al
  80220c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80220e:	ff 45 f8             	incl   -0x8(%ebp)
  802211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802217:	7c d9                	jl     8021f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80221c:	8b 45 10             	mov    0x10(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	c6 00 00             	movb   $0x0,(%eax)
}
  802224:	90                   	nop
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80222a:	8b 45 14             	mov    0x14(%ebp),%eax
  80222d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802233:	8b 45 14             	mov    0x14(%ebp),%eax
  802236:	8b 00                	mov    (%eax),%eax
  802238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80223f:	8b 45 10             	mov    0x10(%ebp),%eax
  802242:	01 d0                	add    %edx,%eax
  802244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80224a:	eb 0c                	jmp    802258 <strsplit+0x31>
			*string++ = 0;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8d 50 01             	lea    0x1(%eax),%edx
  802252:	89 55 08             	mov    %edx,0x8(%ebp)
  802255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	8a 00                	mov    (%eax),%al
  80225d:	84 c0                	test   %al,%al
  80225f:	74 18                	je     802279 <strsplit+0x52>
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8a 00                	mov    (%eax),%al
  802266:	0f be c0             	movsbl %al,%eax
  802269:	50                   	push   %eax
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	e8 13 fb ff ff       	call   801d85 <strchr>
  802272:	83 c4 08             	add    $0x8,%esp
  802275:	85 c0                	test   %eax,%eax
  802277:	75 d3                	jne    80224c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8a 00                	mov    (%eax),%al
  80227e:	84 c0                	test   %al,%al
  802280:	74 5a                	je     8022dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802282:	8b 45 14             	mov    0x14(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	83 f8 0f             	cmp    $0xf,%eax
  80228a:	75 07                	jne    802293 <strsplit+0x6c>
		{
			return 0;
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
  802291:	eb 66                	jmp    8022f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802293:	8b 45 14             	mov    0x14(%ebp),%eax
  802296:	8b 00                	mov    (%eax),%eax
  802298:	8d 48 01             	lea    0x1(%eax),%ecx
  80229b:	8b 55 14             	mov    0x14(%ebp),%edx
  80229e:	89 0a                	mov    %ecx,(%edx)
  8022a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022aa:	01 c2                	add    %eax,%edx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022b1:	eb 03                	jmp    8022b6 <strsplit+0x8f>
			string++;
  8022b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8a 00                	mov    (%eax),%al
  8022bb:	84 c0                	test   %al,%al
  8022bd:	74 8b                	je     80224a <strsplit+0x23>
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8a 00                	mov    (%eax),%al
  8022c4:	0f be c0             	movsbl %al,%eax
  8022c7:	50                   	push   %eax
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	e8 b5 fa ff ff       	call   801d85 <strchr>
  8022d0:	83 c4 08             	add    $0x8,%esp
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 dc                	je     8022b3 <strsplit+0x8c>
			string++;
	}
  8022d7:	e9 6e ff ff ff       	jmp    80224a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 d0 35 80 00       	push   $0x8035d0
  802309:	6a 0e                	push   $0xe
  80230b:	68 0a 36 80 00       	push   $0x80360a
  802310:	e8 a8 ef ff ff       	call   8012bd <_panic>

00802315 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80231b:	a1 04 40 80 00       	mov    0x804004,%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	74 0f                	je     802333 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  802324:	e8 d2 ff ff ff       	call   8022fb <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802329:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802330:	00 00 00 
	}
	if (size == 0) return NULL ;
  802333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802337:	75 07                	jne    802340 <malloc+0x2b>
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	eb 14                	jmp    802354 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 18 36 80 00       	push   $0x803618
  802348:	6a 2e                	push   $0x2e
  80234a:	68 0a 36 80 00       	push   $0x80360a
  80234f:	e8 69 ef ff ff       	call   8012bd <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 40 36 80 00       	push   $0x803640
  802364:	6a 49                	push   $0x49
  802366:	68 0a 36 80 00       	push   $0x80360a
  80236b:	e8 4d ef ff ff       	call   8012bd <_panic>

00802370 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 18             	sub    $0x18,%esp
  802376:	8b 45 10             	mov    0x10(%ebp),%eax
  802379:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 64 36 80 00       	push   $0x803664
  802384:	6a 57                	push   $0x57
  802386:	68 0a 36 80 00       	push   $0x80360a
  80238b:	e8 2d ef ff ff       	call   8012bd <_panic>

00802390 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 8c 36 80 00       	push   $0x80368c
  80239e:	6a 60                	push   $0x60
  8023a0:	68 0a 36 80 00       	push   $0x80360a
  8023a5:	e8 13 ef ff ff       	call   8012bd <_panic>

008023aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	68 b0 36 80 00       	push   $0x8036b0
  8023b8:	6a 7c                	push   $0x7c
  8023ba:	68 0a 36 80 00       	push   $0x80360a
  8023bf:	e8 f9 ee ff ff       	call   8012bd <_panic>

008023c4 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 d8 36 80 00       	push   $0x8036d8
  8023d2:	68 86 00 00 00       	push   $0x86
  8023d7:	68 0a 36 80 00       	push   $0x80360a
  8023dc:	e8 dc ee ff ff       	call   8012bd <_panic>

008023e1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 fc 36 80 00       	push   $0x8036fc
  8023ef:	68 91 00 00 00       	push   $0x91
  8023f4:	68 0a 36 80 00       	push   $0x80360a
  8023f9:	e8 bf ee ff ff       	call   8012bd <_panic>

008023fe <shrink>:

}
void shrink(uint32 newSize)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802404:	83 ec 04             	sub    $0x4,%esp
  802407:	68 fc 36 80 00       	push   $0x8036fc
  80240c:	68 96 00 00 00       	push   $0x96
  802411:	68 0a 36 80 00       	push   $0x80360a
  802416:	e8 a2 ee ff ff       	call   8012bd <_panic>

0080241b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 fc 36 80 00       	push   $0x8036fc
  802429:	68 9b 00 00 00       	push   $0x9b
  80242e:	68 0a 36 80 00       	push   $0x80360a
  802433:	e8 85 ee ff ff       	call   8012bd <_panic>

00802438 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	57                   	push   %edi
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	8b 55 0c             	mov    0xc(%ebp),%edx
  802447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80244d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802450:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802453:	cd 30                	int    $0x30
  802455:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80245b:	83 c4 10             	add    $0x10,%esp
  80245e:	5b                   	pop    %ebx
  80245f:	5e                   	pop    %esi
  802460:	5f                   	pop    %edi
  802461:	5d                   	pop    %ebp
  802462:	c3                   	ret    

00802463 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	8b 45 10             	mov    0x10(%ebp),%eax
  80246c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80246f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	52                   	push   %edx
  80247b:	ff 75 0c             	pushl  0xc(%ebp)
  80247e:	50                   	push   %eax
  80247f:	6a 00                	push   $0x0
  802481:	e8 b2 ff ff ff       	call   802438 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_cgetc>:

int
sys_cgetc(void)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 01                	push   $0x1
  80249b:	e8 98 ff ff ff       	call   802438 <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	52                   	push   %edx
  8024b5:	50                   	push   %eax
  8024b6:	6a 05                	push   $0x5
  8024b8:	e8 7b ff ff ff       	call   802438 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	56                   	push   %esi
  8024c6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8024ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	51                   	push   %ecx
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	6a 06                	push   $0x6
  8024dd:	e8 56 ff ff ff       	call   802438 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024e8:	5b                   	pop    %ebx
  8024e9:	5e                   	pop    %esi
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    

008024ec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	52                   	push   %edx
  8024fc:	50                   	push   %eax
  8024fd:	6a 07                	push   $0x7
  8024ff:	e8 34 ff ff ff       	call   802438 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	ff 75 0c             	pushl  0xc(%ebp)
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	6a 08                	push   $0x8
  80251a:	e8 19 ff ff ff       	call   802438 <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 09                	push   $0x9
  802533:	e8 00 ff ff ff       	call   802438 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 0a                	push   $0xa
  80254c:	e8 e7 fe ff ff       	call   802438 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 0b                	push   $0xb
  802565:	e8 ce fe ff ff       	call   802438 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	ff 75 0c             	pushl  0xc(%ebp)
  80257b:	ff 75 08             	pushl  0x8(%ebp)
  80257e:	6a 0f                	push   $0xf
  802580:	e8 b3 fe ff ff       	call   802438 <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
	return;
  802588:	90                   	nop
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	ff 75 0c             	pushl  0xc(%ebp)
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	6a 10                	push   $0x10
  80259c:	e8 97 fe ff ff       	call   802438 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a4:	90                   	nop
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	ff 75 10             	pushl  0x10(%ebp)
  8025b1:	ff 75 0c             	pushl  0xc(%ebp)
  8025b4:	ff 75 08             	pushl  0x8(%ebp)
  8025b7:	6a 11                	push   $0x11
  8025b9:	e8 7a fe ff ff       	call   802438 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 0c                	push   $0xc
  8025d3:	e8 60 fe ff ff       	call   802438 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	ff 75 08             	pushl  0x8(%ebp)
  8025eb:	6a 0d                	push   $0xd
  8025ed:	e8 46 fe ff ff       	call   802438 <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 0e                	push   $0xe
  802606:	e8 2d fe ff ff       	call   802438 <syscall>
  80260b:	83 c4 18             	add    $0x18,%esp
}
  80260e:	90                   	nop
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 13                	push   $0x13
  802620:	e8 13 fe ff ff       	call   802438 <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
}
  802628:	90                   	nop
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 14                	push   $0x14
  80263a:	e8 f9 fd ff ff       	call   802438 <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
}
  802642:	90                   	nop
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_cputc>:


void
sys_cputc(const char c)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802651:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	50                   	push   %eax
  80265e:	6a 15                	push   $0x15
  802660:	e8 d3 fd ff ff       	call   802438 <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
}
  802668:	90                   	nop
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 16                	push   $0x16
  80267a:	e8 b9 fd ff ff       	call   802438 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
}
  802682:	90                   	nop
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	ff 75 0c             	pushl  0xc(%ebp)
  802694:	50                   	push   %eax
  802695:	6a 17                	push   $0x17
  802697:	e8 9c fd ff ff       	call   802438 <syscall>
  80269c:	83 c4 18             	add    $0x18,%esp
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	52                   	push   %edx
  8026b1:	50                   	push   %eax
  8026b2:	6a 1a                	push   $0x1a
  8026b4:	e8 7f fd ff ff       	call   802438 <syscall>
  8026b9:	83 c4 18             	add    $0x18,%esp
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	52                   	push   %edx
  8026ce:	50                   	push   %eax
  8026cf:	6a 18                	push   $0x18
  8026d1:	e8 62 fd ff ff       	call   802438 <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
}
  8026d9:	90                   	nop
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	52                   	push   %edx
  8026ec:	50                   	push   %eax
  8026ed:	6a 19                	push   $0x19
  8026ef:	e8 44 fd ff ff       	call   802438 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	90                   	nop
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	8b 45 10             	mov    0x10(%ebp),%eax
  802703:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802706:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802709:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	6a 00                	push   $0x0
  802712:	51                   	push   %ecx
  802713:	52                   	push   %edx
  802714:	ff 75 0c             	pushl  0xc(%ebp)
  802717:	50                   	push   %eax
  802718:	6a 1b                	push   $0x1b
  80271a:	e8 19 fd ff ff       	call   802438 <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	52                   	push   %edx
  802734:	50                   	push   %eax
  802735:	6a 1c                	push   $0x1c
  802737:	e8 fc fc ff ff       	call   802438 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802744:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	51                   	push   %ecx
  802752:	52                   	push   %edx
  802753:	50                   	push   %eax
  802754:	6a 1d                	push   $0x1d
  802756:	e8 dd fc ff ff       	call   802438 <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802763:	8b 55 0c             	mov    0xc(%ebp),%edx
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	52                   	push   %edx
  802770:	50                   	push   %eax
  802771:	6a 1e                	push   $0x1e
  802773:	e8 c0 fc ff ff       	call   802438 <syscall>
  802778:	83 c4 18             	add    $0x18,%esp
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 1f                	push   $0x1f
  80278c:	e8 a7 fc ff ff       	call   802438 <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	6a 00                	push   $0x0
  80279e:	ff 75 14             	pushl  0x14(%ebp)
  8027a1:	ff 75 10             	pushl  0x10(%ebp)
  8027a4:	ff 75 0c             	pushl  0xc(%ebp)
  8027a7:	50                   	push   %eax
  8027a8:	6a 20                	push   $0x20
  8027aa:	e8 89 fc ff ff       	call   802438 <syscall>
  8027af:	83 c4 18             	add    $0x18,%esp
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    

008027b4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	50                   	push   %eax
  8027c3:	6a 21                	push   $0x21
  8027c5:	e8 6e fc ff ff       	call   802438 <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
}
  8027cd:	90                   	nop
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	50                   	push   %eax
  8027df:	6a 22                	push   $0x22
  8027e1:	e8 52 fc ff ff       	call   802438 <syscall>
  8027e6:	83 c4 18             	add    $0x18,%esp
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 02                	push   $0x2
  8027fa:	e8 39 fc ff ff       	call   802438 <syscall>
  8027ff:	83 c4 18             	add    $0x18,%esp
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 03                	push   $0x3
  802813:	e8 20 fc ff ff       	call   802438 <syscall>
  802818:	83 c4 18             	add    $0x18,%esp
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 04                	push   $0x4
  80282c:	e8 07 fc ff ff       	call   802438 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_exit_env>:


void sys_exit_env(void)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 23                	push   $0x23
  802845:	e8 ee fb ff ff       	call   802438 <syscall>
  80284a:	83 c4 18             	add    $0x18,%esp
}
  80284d:	90                   	nop
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    

00802850 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802856:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802859:	8d 50 04             	lea    0x4(%eax),%edx
  80285c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	52                   	push   %edx
  802866:	50                   	push   %eax
  802867:	6a 24                	push   $0x24
  802869:	e8 ca fb ff ff       	call   802438 <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
	return result;
  802871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802877:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80287a:	89 01                	mov    %eax,(%ecx)
  80287c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	c9                   	leave  
  802883:	c2 04 00             	ret    $0x4

00802886 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	ff 75 10             	pushl  0x10(%ebp)
  802890:	ff 75 0c             	pushl  0xc(%ebp)
  802893:	ff 75 08             	pushl  0x8(%ebp)
  802896:	6a 12                	push   $0x12
  802898:	e8 9b fb ff ff       	call   802438 <syscall>
  80289d:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a0:	90                   	nop
}
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 25                	push   $0x25
  8028b2:	e8 81 fb ff ff       	call   802438 <syscall>
  8028b7:	83 c4 18             	add    $0x18,%esp
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	50                   	push   %eax
  8028d5:	6a 26                	push   $0x26
  8028d7:	e8 5c fb ff ff       	call   802438 <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8028df:	90                   	nop
}
  8028e0:	c9                   	leave  
  8028e1:	c3                   	ret    

008028e2 <rsttst>:
void rsttst()
{
  8028e2:	55                   	push   %ebp
  8028e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 28                	push   $0x28
  8028f1:	e8 42 fb ff ff       	call   802438 <syscall>
  8028f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f9:	90                   	nop
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	8b 45 14             	mov    0x14(%ebp),%eax
  802905:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802908:	8b 55 18             	mov    0x18(%ebp),%edx
  80290b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80290f:	52                   	push   %edx
  802910:	50                   	push   %eax
  802911:	ff 75 10             	pushl  0x10(%ebp)
  802914:	ff 75 0c             	pushl  0xc(%ebp)
  802917:	ff 75 08             	pushl  0x8(%ebp)
  80291a:	6a 27                	push   $0x27
  80291c:	e8 17 fb ff ff       	call   802438 <syscall>
  802921:	83 c4 18             	add    $0x18,%esp
	return ;
  802924:	90                   	nop
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <chktst>:
void chktst(uint32 n)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	ff 75 08             	pushl  0x8(%ebp)
  802935:	6a 29                	push   $0x29
  802937:	e8 fc fa ff ff       	call   802438 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
	return ;
  80293f:	90                   	nop
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <inctst>:

void inctst()
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 2a                	push   $0x2a
  802951:	e8 e2 fa ff ff       	call   802438 <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
	return ;
  802959:	90                   	nop
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <gettst>:
uint32 gettst()
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 2b                	push   $0x2b
  80296b:	e8 c8 fa ff ff       	call   802438 <syscall>
  802970:	83 c4 18             	add    $0x18,%esp
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 2c                	push   $0x2c
  802987:	e8 ac fa ff ff       	call   802438 <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
  80298f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802992:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802996:	75 07                	jne    80299f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802998:	b8 01 00 00 00       	mov    $0x1,%eax
  80299d:	eb 05                	jmp    8029a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
  8029a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 2c                	push   $0x2c
  8029b8:	e8 7b fa ff ff       	call   802438 <syscall>
  8029bd:	83 c4 18             	add    $0x18,%esp
  8029c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029c3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029c7:	75 07                	jne    8029d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ce:	eb 05                	jmp    8029d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 2c                	push   $0x2c
  8029e9:	e8 4a fa ff ff       	call   802438 <syscall>
  8029ee:	83 c4 18             	add    $0x18,%esp
  8029f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029f4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029f8:	75 07                	jne    802a01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ff:	eb 05                	jmp    802a06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
  802a0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 2c                	push   $0x2c
  802a1a:	e8 19 fa ff ff       	call   802438 <syscall>
  802a1f:	83 c4 18             	add    $0x18,%esp
  802a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a25:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a29:	75 07                	jne    802a32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  802a30:	eb 05                	jmp    802a37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	ff 75 08             	pushl  0x8(%ebp)
  802a47:	6a 2d                	push   $0x2d
  802a49:	e8 ea f9 ff ff       	call   802438 <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a51:	90                   	nop
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	6a 00                	push   $0x0
  802a66:	53                   	push   %ebx
  802a67:	51                   	push   %ecx
  802a68:	52                   	push   %edx
  802a69:	50                   	push   %eax
  802a6a:	6a 2e                	push   $0x2e
  802a6c:	e8 c7 f9 ff ff       	call   802438 <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
}
  802a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	52                   	push   %edx
  802a89:	50                   	push   %eax
  802a8a:	6a 2f                	push   $0x2f
  802a8c:	e8 a7 f9 ff ff       	call   802438 <syscall>
  802a91:	83 c4 18             	add    $0x18,%esp
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    
  802a96:	66 90                	xchg   %ax,%ax

00802a98 <__udivdi3>:
  802a98:	55                   	push   %ebp
  802a99:	57                   	push   %edi
  802a9a:	56                   	push   %esi
  802a9b:	53                   	push   %ebx
  802a9c:	83 ec 1c             	sub    $0x1c,%esp
  802a9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802aa3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802aa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aaf:	89 ca                	mov    %ecx,%edx
  802ab1:	89 f8                	mov    %edi,%eax
  802ab3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ab7:	85 f6                	test   %esi,%esi
  802ab9:	75 2d                	jne    802ae8 <__udivdi3+0x50>
  802abb:	39 cf                	cmp    %ecx,%edi
  802abd:	77 65                	ja     802b24 <__udivdi3+0x8c>
  802abf:	89 fd                	mov    %edi,%ebp
  802ac1:	85 ff                	test   %edi,%edi
  802ac3:	75 0b                	jne    802ad0 <__udivdi3+0x38>
  802ac5:	b8 01 00 00 00       	mov    $0x1,%eax
  802aca:	31 d2                	xor    %edx,%edx
  802acc:	f7 f7                	div    %edi
  802ace:	89 c5                	mov    %eax,%ebp
  802ad0:	31 d2                	xor    %edx,%edx
  802ad2:	89 c8                	mov    %ecx,%eax
  802ad4:	f7 f5                	div    %ebp
  802ad6:	89 c1                	mov    %eax,%ecx
  802ad8:	89 d8                	mov    %ebx,%eax
  802ada:	f7 f5                	div    %ebp
  802adc:	89 cf                	mov    %ecx,%edi
  802ade:	89 fa                	mov    %edi,%edx
  802ae0:	83 c4 1c             	add    $0x1c,%esp
  802ae3:	5b                   	pop    %ebx
  802ae4:	5e                   	pop    %esi
  802ae5:	5f                   	pop    %edi
  802ae6:	5d                   	pop    %ebp
  802ae7:	c3                   	ret    
  802ae8:	39 ce                	cmp    %ecx,%esi
  802aea:	77 28                	ja     802b14 <__udivdi3+0x7c>
  802aec:	0f bd fe             	bsr    %esi,%edi
  802aef:	83 f7 1f             	xor    $0x1f,%edi
  802af2:	75 40                	jne    802b34 <__udivdi3+0x9c>
  802af4:	39 ce                	cmp    %ecx,%esi
  802af6:	72 0a                	jb     802b02 <__udivdi3+0x6a>
  802af8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802afc:	0f 87 9e 00 00 00    	ja     802ba0 <__udivdi3+0x108>
  802b02:	b8 01 00 00 00       	mov    $0x1,%eax
  802b07:	89 fa                	mov    %edi,%edx
  802b09:	83 c4 1c             	add    $0x1c,%esp
  802b0c:	5b                   	pop    %ebx
  802b0d:	5e                   	pop    %esi
  802b0e:	5f                   	pop    %edi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    
  802b11:	8d 76 00             	lea    0x0(%esi),%esi
  802b14:	31 ff                	xor    %edi,%edi
  802b16:	31 c0                	xor    %eax,%eax
  802b18:	89 fa                	mov    %edi,%edx
  802b1a:	83 c4 1c             	add    $0x1c,%esp
  802b1d:	5b                   	pop    %ebx
  802b1e:	5e                   	pop    %esi
  802b1f:	5f                   	pop    %edi
  802b20:	5d                   	pop    %ebp
  802b21:	c3                   	ret    
  802b22:	66 90                	xchg   %ax,%ax
  802b24:	89 d8                	mov    %ebx,%eax
  802b26:	f7 f7                	div    %edi
  802b28:	31 ff                	xor    %edi,%edi
  802b2a:	89 fa                	mov    %edi,%edx
  802b2c:	83 c4 1c             	add    $0x1c,%esp
  802b2f:	5b                   	pop    %ebx
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    
  802b34:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b39:	89 eb                	mov    %ebp,%ebx
  802b3b:	29 fb                	sub    %edi,%ebx
  802b3d:	89 f9                	mov    %edi,%ecx
  802b3f:	d3 e6                	shl    %cl,%esi
  802b41:	89 c5                	mov    %eax,%ebp
  802b43:	88 d9                	mov    %bl,%cl
  802b45:	d3 ed                	shr    %cl,%ebp
  802b47:	89 e9                	mov    %ebp,%ecx
  802b49:	09 f1                	or     %esi,%ecx
  802b4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b4f:	89 f9                	mov    %edi,%ecx
  802b51:	d3 e0                	shl    %cl,%eax
  802b53:	89 c5                	mov    %eax,%ebp
  802b55:	89 d6                	mov    %edx,%esi
  802b57:	88 d9                	mov    %bl,%cl
  802b59:	d3 ee                	shr    %cl,%esi
  802b5b:	89 f9                	mov    %edi,%ecx
  802b5d:	d3 e2                	shl    %cl,%edx
  802b5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b63:	88 d9                	mov    %bl,%cl
  802b65:	d3 e8                	shr    %cl,%eax
  802b67:	09 c2                	or     %eax,%edx
  802b69:	89 d0                	mov    %edx,%eax
  802b6b:	89 f2                	mov    %esi,%edx
  802b6d:	f7 74 24 0c          	divl   0xc(%esp)
  802b71:	89 d6                	mov    %edx,%esi
  802b73:	89 c3                	mov    %eax,%ebx
  802b75:	f7 e5                	mul    %ebp
  802b77:	39 d6                	cmp    %edx,%esi
  802b79:	72 19                	jb     802b94 <__udivdi3+0xfc>
  802b7b:	74 0b                	je     802b88 <__udivdi3+0xf0>
  802b7d:	89 d8                	mov    %ebx,%eax
  802b7f:	31 ff                	xor    %edi,%edi
  802b81:	e9 58 ff ff ff       	jmp    802ade <__udivdi3+0x46>
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b8c:	89 f9                	mov    %edi,%ecx
  802b8e:	d3 e2                	shl    %cl,%edx
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	73 e9                	jae    802b7d <__udivdi3+0xe5>
  802b94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b97:	31 ff                	xor    %edi,%edi
  802b99:	e9 40 ff ff ff       	jmp    802ade <__udivdi3+0x46>
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	31 c0                	xor    %eax,%eax
  802ba2:	e9 37 ff ff ff       	jmp    802ade <__udivdi3+0x46>
  802ba7:	90                   	nop

00802ba8 <__umoddi3>:
  802ba8:	55                   	push   %ebp
  802ba9:	57                   	push   %edi
  802baa:	56                   	push   %esi
  802bab:	53                   	push   %ebx
  802bac:	83 ec 1c             	sub    $0x1c,%esp
  802baf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802bb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802bb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802bbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc7:	89 f3                	mov    %esi,%ebx
  802bc9:	89 fa                	mov    %edi,%edx
  802bcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bcf:	89 34 24             	mov    %esi,(%esp)
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 1a                	jne    802bf0 <__umoddi3+0x48>
  802bd6:	39 f7                	cmp    %esi,%edi
  802bd8:	0f 86 a2 00 00 00    	jbe    802c80 <__umoddi3+0xd8>
  802bde:	89 c8                	mov    %ecx,%eax
  802be0:	89 f2                	mov    %esi,%edx
  802be2:	f7 f7                	div    %edi
  802be4:	89 d0                	mov    %edx,%eax
  802be6:	31 d2                	xor    %edx,%edx
  802be8:	83 c4 1c             	add    $0x1c,%esp
  802beb:	5b                   	pop    %ebx
  802bec:	5e                   	pop    %esi
  802bed:	5f                   	pop    %edi
  802bee:	5d                   	pop    %ebp
  802bef:	c3                   	ret    
  802bf0:	39 f0                	cmp    %esi,%eax
  802bf2:	0f 87 ac 00 00 00    	ja     802ca4 <__umoddi3+0xfc>
  802bf8:	0f bd e8             	bsr    %eax,%ebp
  802bfb:	83 f5 1f             	xor    $0x1f,%ebp
  802bfe:	0f 84 ac 00 00 00    	je     802cb0 <__umoddi3+0x108>
  802c04:	bf 20 00 00 00       	mov    $0x20,%edi
  802c09:	29 ef                	sub    %ebp,%edi
  802c0b:	89 fe                	mov    %edi,%esi
  802c0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c11:	89 e9                	mov    %ebp,%ecx
  802c13:	d3 e0                	shl    %cl,%eax
  802c15:	89 d7                	mov    %edx,%edi
  802c17:	89 f1                	mov    %esi,%ecx
  802c19:	d3 ef                	shr    %cl,%edi
  802c1b:	09 c7                	or     %eax,%edi
  802c1d:	89 e9                	mov    %ebp,%ecx
  802c1f:	d3 e2                	shl    %cl,%edx
  802c21:	89 14 24             	mov    %edx,(%esp)
  802c24:	89 d8                	mov    %ebx,%eax
  802c26:	d3 e0                	shl    %cl,%eax
  802c28:	89 c2                	mov    %eax,%edx
  802c2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c2e:	d3 e0                	shl    %cl,%eax
  802c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c34:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c38:	89 f1                	mov    %esi,%ecx
  802c3a:	d3 e8                	shr    %cl,%eax
  802c3c:	09 d0                	or     %edx,%eax
  802c3e:	d3 eb                	shr    %cl,%ebx
  802c40:	89 da                	mov    %ebx,%edx
  802c42:	f7 f7                	div    %edi
  802c44:	89 d3                	mov    %edx,%ebx
  802c46:	f7 24 24             	mull   (%esp)
  802c49:	89 c6                	mov    %eax,%esi
  802c4b:	89 d1                	mov    %edx,%ecx
  802c4d:	39 d3                	cmp    %edx,%ebx
  802c4f:	0f 82 87 00 00 00    	jb     802cdc <__umoddi3+0x134>
  802c55:	0f 84 91 00 00 00    	je     802cec <__umoddi3+0x144>
  802c5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c5f:	29 f2                	sub    %esi,%edx
  802c61:	19 cb                	sbb    %ecx,%ebx
  802c63:	89 d8                	mov    %ebx,%eax
  802c65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c69:	d3 e0                	shl    %cl,%eax
  802c6b:	89 e9                	mov    %ebp,%ecx
  802c6d:	d3 ea                	shr    %cl,%edx
  802c6f:	09 d0                	or     %edx,%eax
  802c71:	89 e9                	mov    %ebp,%ecx
  802c73:	d3 eb                	shr    %cl,%ebx
  802c75:	89 da                	mov    %ebx,%edx
  802c77:	83 c4 1c             	add    $0x1c,%esp
  802c7a:	5b                   	pop    %ebx
  802c7b:	5e                   	pop    %esi
  802c7c:	5f                   	pop    %edi
  802c7d:	5d                   	pop    %ebp
  802c7e:	c3                   	ret    
  802c7f:	90                   	nop
  802c80:	89 fd                	mov    %edi,%ebp
  802c82:	85 ff                	test   %edi,%edi
  802c84:	75 0b                	jne    802c91 <__umoddi3+0xe9>
  802c86:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8b:	31 d2                	xor    %edx,%edx
  802c8d:	f7 f7                	div    %edi
  802c8f:	89 c5                	mov    %eax,%ebp
  802c91:	89 f0                	mov    %esi,%eax
  802c93:	31 d2                	xor    %edx,%edx
  802c95:	f7 f5                	div    %ebp
  802c97:	89 c8                	mov    %ecx,%eax
  802c99:	f7 f5                	div    %ebp
  802c9b:	89 d0                	mov    %edx,%eax
  802c9d:	e9 44 ff ff ff       	jmp    802be6 <__umoddi3+0x3e>
  802ca2:	66 90                	xchg   %ax,%ax
  802ca4:	89 c8                	mov    %ecx,%eax
  802ca6:	89 f2                	mov    %esi,%edx
  802ca8:	83 c4 1c             	add    $0x1c,%esp
  802cab:	5b                   	pop    %ebx
  802cac:	5e                   	pop    %esi
  802cad:	5f                   	pop    %edi
  802cae:	5d                   	pop    %ebp
  802caf:	c3                   	ret    
  802cb0:	3b 04 24             	cmp    (%esp),%eax
  802cb3:	72 06                	jb     802cbb <__umoddi3+0x113>
  802cb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802cb9:	77 0f                	ja     802cca <__umoddi3+0x122>
  802cbb:	89 f2                	mov    %esi,%edx
  802cbd:	29 f9                	sub    %edi,%ecx
  802cbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802cc3:	89 14 24             	mov    %edx,(%esp)
  802cc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802cca:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cce:	8b 14 24             	mov    (%esp),%edx
  802cd1:	83 c4 1c             	add    $0x1c,%esp
  802cd4:	5b                   	pop    %ebx
  802cd5:	5e                   	pop    %esi
  802cd6:	5f                   	pop    %edi
  802cd7:	5d                   	pop    %ebp
  802cd8:	c3                   	ret    
  802cd9:	8d 76 00             	lea    0x0(%esi),%esi
  802cdc:	2b 04 24             	sub    (%esp),%eax
  802cdf:	19 fa                	sbb    %edi,%edx
  802ce1:	89 d1                	mov    %edx,%ecx
  802ce3:	89 c6                	mov    %eax,%esi
  802ce5:	e9 71 ff ff ff       	jmp    802c5b <__umoddi3+0xb3>
  802cea:	66 90                	xchg   %ax,%ax
  802cec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802cf0:	72 ea                	jb     802cdc <__umoddi3+0x134>
  802cf2:	89 d9                	mov    %ebx,%ecx
  802cf4:	e9 62 ff ff ff       	jmp    802c5b <__umoddi3+0xb3>
