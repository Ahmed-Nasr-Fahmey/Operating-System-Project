
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 00 22 80 00       	push   $0x802200
  800067:	e8 f6 09 00 00       	call   800a62 <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 a1 19 00 00       	call   801a15 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 39 1a 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 6e 17 00 00       	call   801806 <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 24 22 80 00       	push   $0x802224
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 54 22 80 00       	push   $0x802254
  8000b7:	e8 f2 06 00 00       	call   8007ae <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 51 19 00 00       	call   801a15 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 6c 22 80 00       	push   $0x80226c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 54 22 80 00       	push   $0x802254
  8000dc:	e8 cd 06 00 00       	call   8007ae <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 cf 19 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 d8 22 80 00       	push   $0x8022d8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 54 22 80 00       	push   $0x802254
  8000fd:	e8 ac 06 00 00       	call   8007ae <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 0e 19 00 00       	call   801a15 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 a6 19 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 dd 16 00 00       	call   801806 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 24 22 80 00       	push   $0x802224
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 54 22 80 00       	push   $0x802254
  800162:	e8 47 06 00 00       	call   8007ae <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 a9 18 00 00       	call   801a15 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 6c 22 80 00       	push   $0x80226c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 22 80 00       	push   $0x802254
  800184:	e8 25 06 00 00       	call   8007ae <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 27 19 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 d8 22 80 00       	push   $0x8022d8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 54 22 80 00       	push   $0x802254
  8001a5:	e8 04 06 00 00       	call   8007ae <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 66 18 00 00       	call   801a15 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 fe 18 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 31 16 00 00       	call   801806 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 24 22 80 00       	push   $0x802224
  800206:	6a 23                	push   $0x23
  800208:	68 54 22 80 00       	push   $0x802254
  80020d:	e8 9c 05 00 00       	call   8007ae <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 fe 17 00 00       	call   801a15 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 6c 22 80 00       	push   $0x80226c
  800228:	6a 25                	push   $0x25
  80022a:	68 54 22 80 00       	push   $0x802254
  80022f:	e8 7a 05 00 00       	call   8007ae <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 7c 18 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 d8 22 80 00       	push   $0x8022d8
  800249:	6a 26                	push   $0x26
  80024b:	68 54 22 80 00       	push   $0x802254
  800250:	e8 59 05 00 00       	call   8007ae <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 bb 17 00 00       	call   801a15 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 53 18 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 86 15 00 00       	call   801806 <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 24 22 80 00       	push   $0x802224
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 54 22 80 00       	push   $0x802254
  8002b4:	e8 f5 04 00 00       	call   8007ae <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 57 17 00 00       	call   801a15 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 6c 22 80 00       	push   $0x80226c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 54 22 80 00       	push   $0x802254
  8002d6:	e8 d3 04 00 00       	call   8007ae <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 d5 17 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 d8 22 80 00       	push   $0x8022d8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 54 22 80 00       	push   $0x802254
  8002f7:	e8 b2 04 00 00       	call   8007ae <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 ee 15 00 00       	call   801a15 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 86 16 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 46 14 00 00       	call   80189b <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 08 23 80 00       	push   $0x802308
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 54 22 80 00       	push   $0x802254
  800484:	e8 25 03 00 00       	call   8007ae <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 27 16 00 00       	call   801ab5 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 3c 23 80 00       	push   $0x80233c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 54 22 80 00       	push   $0x802254
  8004a5:	e8 04 03 00 00       	call   8007ae <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 6d 23 80 00       	push   $0x80236d
  8004b4:	e8 3e 05 00 00       	call   8009f7 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 74 23 80 00       	push   $0x802374
  800506:	6a 7a                	push   $0x7a
  800508:	68 54 22 80 00       	push   $0x802254
  80050d:	e8 9c 02 00 00       	call   8007ae <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 74 23 80 00       	push   $0x802374
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 54 22 80 00       	push   $0x802254
  800568:	e8 41 02 00 00       	call   8007ae <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 74 23 80 00       	push   $0x802374
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 54 22 80 00       	push   $0x802254
  8005ca:	e8 df 01 00 00       	call   8007ae <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 74 23 80 00       	push   $0x802374
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 54 22 80 00       	push   $0x802254
  800625:	e8 84 01 00 00       	call   8007ae <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 ac 23 80 00       	push   $0x8023ac
  80063f:	e8 b3 03 00 00       	call   8009f7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 b8 23 80 00       	push   $0x8023b8
  80064f:	e8 0e 04 00 00       	call   800a62 <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 8b 16 00 00       	call   801cf5 <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80067d:	01 c8                	add    %ecx,%eax
  80067f:	c1 e0 02             	shl    $0x2,%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80068b:	01 c8                	add    %ecx,%eax
  80068d:	c1 e0 02             	shl    $0x2,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 02             	shl    $0x2,%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	c1 e0 03             	shl    $0x3,%eax
  80069a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80069f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a9:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8006af:	84 c0                	test   %al,%al
  8006b1:	74 0f                	je     8006c2 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8006b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b8:	05 18 da 01 00       	add    $0x1da18,%eax
  8006bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c6:	7e 0a                	jle    8006d2 <libmain+0x73>
		binaryname = argv[0];
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	ff 75 08             	pushl  0x8(%ebp)
  8006db:	e8 58 f9 ff ff       	call   800038 <_main>
  8006e0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006e3:	e8 1a 14 00 00       	call   801b02 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	68 0c 24 80 00       	push   $0x80240c
  8006f0:	e8 6d 03 00 00       	call   800a62 <cprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006fd:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800703:	a1 20 30 80 00       	mov    0x803020,%eax
  800708:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	52                   	push   %edx
  800712:	50                   	push   %eax
  800713:	68 34 24 80 00       	push   $0x802434
  800718:	e8 45 03 00 00       	call   800a62 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800720:	a1 20 30 80 00       	mov    0x803020,%eax
  800725:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80072b:	a1 20 30 80 00       	mov    0x803020,%eax
  800730:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800736:	a1 20 30 80 00       	mov    0x803020,%eax
  80073b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800741:	51                   	push   %ecx
  800742:	52                   	push   %edx
  800743:	50                   	push   %eax
  800744:	68 5c 24 80 00       	push   $0x80245c
  800749:	e8 14 03 00 00       	call   800a62 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800751:	a1 20 30 80 00       	mov    0x803020,%eax
  800756:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	50                   	push   %eax
  800760:	68 b4 24 80 00       	push   $0x8024b4
  800765:	e8 f8 02 00 00       	call   800a62 <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	68 0c 24 80 00       	push   $0x80240c
  800775:	e8 e8 02 00 00       	call   800a62 <cprintf>
  80077a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80077d:	e8 9a 13 00 00       	call   801b1c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800782:	e8 19 00 00 00       	call   8007a0 <exit>
}
  800787:	90                   	nop
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 27 15 00 00       	call   801cc1 <sys_destroy_env>
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	90                   	nop
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <exit>:

void
exit(void)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a6:	e8 7c 15 00 00       	call   801d27 <sys_exit_env>
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007bd:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 16                	je     8007dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c6:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	50                   	push   %eax
  8007cf:	68 c8 24 80 00       	push   $0x8024c8
  8007d4:	e8 89 02 00 00       	call   800a62 <cprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007dc:	a1 00 30 80 00       	mov    0x803000,%eax
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	ff 75 08             	pushl  0x8(%ebp)
  8007e7:	50                   	push   %eax
  8007e8:	68 cd 24 80 00       	push   $0x8024cd
  8007ed:	e8 70 02 00 00       	call   800a62 <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fe:	50                   	push   %eax
  8007ff:	e8 f3 01 00 00       	call   8009f7 <vcprintf>
  800804:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	6a 00                	push   $0x0
  80080c:	68 e9 24 80 00       	push   $0x8024e9
  800811:	e8 e1 01 00 00       	call   8009f7 <vcprintf>
  800816:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800819:	e8 82 ff ff ff       	call   8007a0 <exit>

	// should not return here
	while (1) ;
  80081e:	eb fe                	jmp    80081e <_panic+0x70>

00800820 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800826:	a1 20 30 80 00       	mov    0x803020,%eax
  80082b:	8b 50 74             	mov    0x74(%eax),%edx
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	39 c2                	cmp    %eax,%edx
  800833:	74 14                	je     800849 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	68 ec 24 80 00       	push   $0x8024ec
  80083d:	6a 26                	push   $0x26
  80083f:	68 38 25 80 00       	push   $0x802538
  800844:	e8 65 ff ff ff       	call   8007ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800850:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800857:	e9 c2 00 00 00       	jmp    80091e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80085c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	01 d0                	add    %edx,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	85 c0                	test   %eax,%eax
  80086f:	75 08                	jne    800879 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800871:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800874:	e9 a2 00 00 00       	jmp    80091b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800880:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800887:	eb 69                	jmp    8008f2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800889:	a1 20 30 80 00       	mov    0x803020,%eax
  80088e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800894:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800897:	89 d0                	mov    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	c1 e0 03             	shl    $0x3,%eax
  8008a0:	01 c8                	add    %ecx,%eax
  8008a2:	8a 40 04             	mov    0x4(%eax),%al
  8008a5:	84 c0                	test   %al,%al
  8008a7:	75 46                	jne    8008ef <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8008ae:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b7:	89 d0                	mov    %edx,%eax
  8008b9:	01 c0                	add    %eax,%eax
  8008bb:	01 d0                	add    %edx,%eax
  8008bd:	c1 e0 03             	shl    $0x3,%eax
  8008c0:	01 c8                	add    %ecx,%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	01 c8                	add    %ecx,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008e2:	39 c2                	cmp    %eax,%edx
  8008e4:	75 09                	jne    8008ef <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008ed:	eb 12                	jmp    800901 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ef:	ff 45 e8             	incl   -0x18(%ebp)
  8008f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8008f7:	8b 50 74             	mov    0x74(%eax),%edx
  8008fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008fd:	39 c2                	cmp    %eax,%edx
  8008ff:	77 88                	ja     800889 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800901:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800905:	75 14                	jne    80091b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800907:	83 ec 04             	sub    $0x4,%esp
  80090a:	68 44 25 80 00       	push   $0x802544
  80090f:	6a 3a                	push   $0x3a
  800911:	68 38 25 80 00       	push   $0x802538
  800916:	e8 93 fe ff ff       	call   8007ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80091b:	ff 45 f0             	incl   -0x10(%ebp)
  80091e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800921:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800924:	0f 8c 32 ff ff ff    	jl     80085c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80092a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800931:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800938:	eb 26                	jmp    800960 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80093a:	a1 20 30 80 00       	mov    0x803020,%eax
  80093f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800948:	89 d0                	mov    %edx,%eax
  80094a:	01 c0                	add    %eax,%eax
  80094c:	01 d0                	add    %edx,%eax
  80094e:	c1 e0 03             	shl    $0x3,%eax
  800951:	01 c8                	add    %ecx,%eax
  800953:	8a 40 04             	mov    0x4(%eax),%al
  800956:	3c 01                	cmp    $0x1,%al
  800958:	75 03                	jne    80095d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80095a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095d:	ff 45 e0             	incl   -0x20(%ebp)
  800960:	a1 20 30 80 00       	mov    0x803020,%eax
  800965:	8b 50 74             	mov    0x74(%eax),%edx
  800968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	77 cb                	ja     80093a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80096f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800972:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800975:	74 14                	je     80098b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800977:	83 ec 04             	sub    $0x4,%esp
  80097a:	68 98 25 80 00       	push   $0x802598
  80097f:	6a 44                	push   $0x44
  800981:	68 38 25 80 00       	push   $0x802538
  800986:	e8 23 fe ff ff       	call   8007ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80098b:	90                   	nop
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8d 48 01             	lea    0x1(%eax),%ecx
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	89 0a                	mov    %ecx,(%edx)
  8009a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a4:	88 d1                	mov    %dl,%cl
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009b7:	75 2c                	jne    8009e5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009b9:	a0 24 30 80 00       	mov    0x803024,%al
  8009be:	0f b6 c0             	movzbl %al,%eax
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	8b 12                	mov    (%edx),%edx
  8009c6:	89 d1                	mov    %edx,%ecx
  8009c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cb:	83 c2 08             	add    $0x8,%edx
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	50                   	push   %eax
  8009d2:	51                   	push   %ecx
  8009d3:	52                   	push   %edx
  8009d4:	e8 7b 0f 00 00       	call   801954 <sys_cputs>
  8009d9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e8:	8b 40 04             	mov    0x4(%eax),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009f4:	90                   	nop
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a00:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a07:	00 00 00 
	b.cnt = 0;
  800a0a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a11:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a20:	50                   	push   %eax
  800a21:	68 8e 09 80 00       	push   $0x80098e
  800a26:	e8 11 02 00 00       	call   800c3c <vprintfmt>
  800a2b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a2e:	a0 24 30 80 00       	mov    0x803024,%al
  800a33:	0f b6 c0             	movzbl %al,%eax
  800a36:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a3c:	83 ec 04             	sub    $0x4,%esp
  800a3f:	50                   	push   %eax
  800a40:	52                   	push   %edx
  800a41:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a47:	83 c0 08             	add    $0x8,%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 04 0f 00 00       	call   801954 <sys_cputs>
  800a50:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a53:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800a5a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a68:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800a6f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	e8 73 ff ff ff       	call   8009f7 <vcprintf>
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a95:	e8 68 10 00 00       	call   801b02 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a9a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	e8 48 ff ff ff       	call   8009f7 <vcprintf>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ab5:	e8 62 10 00 00       	call   801b1c <sys_enable_interrupt>
	return cnt;
  800aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	53                   	push   %ebx
  800ac3:	83 ec 14             	sub    $0x14,%esp
  800ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800add:	77 55                	ja     800b34 <printnum+0x75>
  800adf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ae2:	72 05                	jb     800ae9 <printnum+0x2a>
  800ae4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ae7:	77 4b                	ja     800b34 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ae9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800aec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800aef:	8b 45 18             	mov    0x18(%ebp),%eax
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	52                   	push   %edx
  800af8:	50                   	push   %eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	ff 75 f0             	pushl  -0x10(%ebp)
  800aff:	e8 84 14 00 00       	call   801f88 <__udivdi3>
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	83 ec 04             	sub    $0x4,%esp
  800b0a:	ff 75 20             	pushl  0x20(%ebp)
  800b0d:	53                   	push   %ebx
  800b0e:	ff 75 18             	pushl  0x18(%ebp)
  800b11:	52                   	push   %edx
  800b12:	50                   	push   %eax
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 08             	pushl  0x8(%ebp)
  800b19:	e8 a1 ff ff ff       	call   800abf <printnum>
  800b1e:	83 c4 20             	add    $0x20,%esp
  800b21:	eb 1a                	jmp    800b3d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	ff 75 20             	pushl  0x20(%ebp)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b34:	ff 4d 1c             	decl   0x1c(%ebp)
  800b37:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b3b:	7f e6                	jg     800b23 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b3d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4b:	53                   	push   %ebx
  800b4c:	51                   	push   %ecx
  800b4d:	52                   	push   %edx
  800b4e:	50                   	push   %eax
  800b4f:	e8 44 15 00 00       	call   802098 <__umoddi3>
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	05 14 28 80 00       	add    $0x802814,%eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	0f be c0             	movsbl %al,%eax
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	50                   	push   %eax
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
}
  800b70:	90                   	nop
  800b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b79:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b7d:	7e 1c                	jle    800b9b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8b 00                	mov    (%eax),%eax
  800b84:	8d 50 08             	lea    0x8(%eax),%edx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	89 10                	mov    %edx,(%eax)
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	83 e8 08             	sub    $0x8,%eax
  800b94:	8b 50 04             	mov    0x4(%eax),%edx
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	eb 40                	jmp    800bdb <getuint+0x65>
	else if (lflag)
  800b9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9f:	74 1e                	je     800bbf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	8d 50 04             	lea    0x4(%eax),%edx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	89 10                	mov    %edx,(%eax)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	83 e8 04             	sub    $0x4,%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbd:	eb 1c                	jmp    800bdb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	8d 50 04             	lea    0x4(%eax),%edx
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 10                	mov    %edx,(%eax)
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	83 e8 04             	sub    $0x4,%eax
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800be4:	7e 1c                	jle    800c02 <getint+0x25>
		return va_arg(*ap, long long);
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	8d 50 08             	lea    0x8(%eax),%edx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	89 10                	mov    %edx,(%eax)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	83 e8 08             	sub    $0x8,%eax
  800bfb:	8b 50 04             	mov    0x4(%eax),%edx
  800bfe:	8b 00                	mov    (%eax),%eax
  800c00:	eb 38                	jmp    800c3a <getint+0x5d>
	else if (lflag)
  800c02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c06:	74 1a                	je     800c22 <getint+0x45>
		return va_arg(*ap, long);
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	8d 50 04             	lea    0x4(%eax),%edx
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 10                	mov    %edx,(%eax)
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	83 e8 04             	sub    $0x4,%eax
  800c1d:	8b 00                	mov    (%eax),%eax
  800c1f:	99                   	cltd   
  800c20:	eb 18                	jmp    800c3a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	8d 50 04             	lea    0x4(%eax),%edx
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 10                	mov    %edx,(%eax)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 e8 04             	sub    $0x4,%eax
  800c37:	8b 00                	mov    (%eax),%eax
  800c39:	99                   	cltd   
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c44:	eb 17                	jmp    800c5d <vprintfmt+0x21>
			if (ch == '\0')
  800c46:	85 db                	test   %ebx,%ebx
  800c48:	0f 84 af 03 00 00    	je     800ffd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	53                   	push   %ebx
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c60:	8d 50 01             	lea    0x1(%eax),%edx
  800c63:	89 55 10             	mov    %edx,0x10(%ebp)
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f b6 d8             	movzbl %al,%ebx
  800c6b:	83 fb 25             	cmp    $0x25,%ebx
  800c6e:	75 d6                	jne    800c46 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c70:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c74:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c90:	8b 45 10             	mov    0x10(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 10             	mov    %edx,0x10(%ebp)
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	0f b6 d8             	movzbl %al,%ebx
  800c9e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ca1:	83 f8 55             	cmp    $0x55,%eax
  800ca4:	0f 87 2b 03 00 00    	ja     800fd5 <vprintfmt+0x399>
  800caa:	8b 04 85 38 28 80 00 	mov    0x802838(,%eax,4),%eax
  800cb1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cb3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cb7:	eb d7                	jmp    800c90 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cb9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cbd:	eb d1                	jmp    800c90 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc9:	89 d0                	mov    %edx,%eax
  800ccb:	c1 e0 02             	shl    $0x2,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	01 d8                	add    %ebx,%eax
  800cd4:	83 e8 30             	sub    $0x30,%eax
  800cd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cda:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ce2:	83 fb 2f             	cmp    $0x2f,%ebx
  800ce5:	7e 3e                	jle    800d25 <vprintfmt+0xe9>
  800ce7:	83 fb 39             	cmp    $0x39,%ebx
  800cea:	7f 39                	jg     800d25 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cec:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cef:	eb d5                	jmp    800cc6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf4:	83 c0 04             	add    $0x4,%eax
  800cf7:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	83 e8 04             	sub    $0x4,%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d05:	eb 1f                	jmp    800d26 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0b:	79 83                	jns    800c90 <vprintfmt+0x54>
				width = 0;
  800d0d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d14:	e9 77 ff ff ff       	jmp    800c90 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d19:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d20:	e9 6b ff ff ff       	jmp    800c90 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d25:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2a:	0f 89 60 ff ff ff    	jns    800c90 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d36:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d3d:	e9 4e ff ff ff       	jmp    800c90 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d42:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d45:	e9 46 ff ff ff       	jmp    800c90 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 c0 04             	add    $0x4,%eax
  800d50:	89 45 14             	mov    %eax,0x14(%ebp)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	83 e8 04             	sub    $0x4,%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	50                   	push   %eax
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	ff d0                	call   *%eax
  800d67:	83 c4 10             	add    $0x10,%esp
			break;
  800d6a:	e9 89 02 00 00       	jmp    800ff8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 c0 04             	add    $0x4,%eax
  800d75:	89 45 14             	mov    %eax,0x14(%ebp)
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	83 e8 04             	sub    $0x4,%eax
  800d7e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	79 02                	jns    800d86 <vprintfmt+0x14a>
				err = -err;
  800d84:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d86:	83 fb 64             	cmp    $0x64,%ebx
  800d89:	7f 0b                	jg     800d96 <vprintfmt+0x15a>
  800d8b:	8b 34 9d 80 26 80 00 	mov    0x802680(,%ebx,4),%esi
  800d92:	85 f6                	test   %esi,%esi
  800d94:	75 19                	jne    800daf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d96:	53                   	push   %ebx
  800d97:	68 25 28 80 00       	push   $0x802825
  800d9c:	ff 75 0c             	pushl  0xc(%ebp)
  800d9f:	ff 75 08             	pushl  0x8(%ebp)
  800da2:	e8 5e 02 00 00       	call   801005 <printfmt>
  800da7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800daa:	e9 49 02 00 00       	jmp    800ff8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800daf:	56                   	push   %esi
  800db0:	68 2e 28 80 00       	push   $0x80282e
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 45 02 00 00       	call   801005 <printfmt>
  800dc0:	83 c4 10             	add    $0x10,%esp
			break;
  800dc3:	e9 30 02 00 00       	jmp    800ff8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 c0 04             	add    $0x4,%eax
  800dce:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 e8 04             	sub    $0x4,%eax
  800dd7:	8b 30                	mov    (%eax),%esi
  800dd9:	85 f6                	test   %esi,%esi
  800ddb:	75 05                	jne    800de2 <vprintfmt+0x1a6>
				p = "(null)";
  800ddd:	be 31 28 80 00       	mov    $0x802831,%esi
			if (width > 0 && padc != '-')
  800de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de6:	7e 6d                	jle    800e55 <vprintfmt+0x219>
  800de8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dec:	74 67                	je     800e55 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	50                   	push   %eax
  800df5:	56                   	push   %esi
  800df6:	e8 0c 03 00 00       	call   801107 <strnlen>
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e01:	eb 16                	jmp    800e19 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e03:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e07:	83 ec 08             	sub    $0x8,%esp
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	50                   	push   %eax
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	ff d0                	call   *%eax
  800e13:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e16:	ff 4d e4             	decl   -0x1c(%ebp)
  800e19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1d:	7f e4                	jg     800e03 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1f:	eb 34                	jmp    800e55 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e21:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e25:	74 1c                	je     800e43 <vprintfmt+0x207>
  800e27:	83 fb 1f             	cmp    $0x1f,%ebx
  800e2a:	7e 05                	jle    800e31 <vprintfmt+0x1f5>
  800e2c:	83 fb 7e             	cmp    $0x7e,%ebx
  800e2f:	7e 12                	jle    800e43 <vprintfmt+0x207>
					putch('?', putdat);
  800e31:	83 ec 08             	sub    $0x8,%esp
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	6a 3f                	push   $0x3f
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	eb 0f                	jmp    800e52 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e43:	83 ec 08             	sub    $0x8,%esp
  800e46:	ff 75 0c             	pushl  0xc(%ebp)
  800e49:	53                   	push   %ebx
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	ff d0                	call   *%eax
  800e4f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e52:	ff 4d e4             	decl   -0x1c(%ebp)
  800e55:	89 f0                	mov    %esi,%eax
  800e57:	8d 70 01             	lea    0x1(%eax),%esi
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f be d8             	movsbl %al,%ebx
  800e5f:	85 db                	test   %ebx,%ebx
  800e61:	74 24                	je     800e87 <vprintfmt+0x24b>
  800e63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e67:	78 b8                	js     800e21 <vprintfmt+0x1e5>
  800e69:	ff 4d e0             	decl   -0x20(%ebp)
  800e6c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e70:	79 af                	jns    800e21 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e72:	eb 13                	jmp    800e87 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	6a 20                	push   $0x20
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	ff d0                	call   *%eax
  800e81:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e84:	ff 4d e4             	decl   -0x1c(%ebp)
  800e87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8b:	7f e7                	jg     800e74 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e8d:	e9 66 01 00 00       	jmp    800ff8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 e8             	pushl  -0x18(%ebp)
  800e98:	8d 45 14             	lea    0x14(%ebp),%eax
  800e9b:	50                   	push   %eax
  800e9c:	e8 3c fd ff ff       	call   800bdd <getint>
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb0:	85 d2                	test   %edx,%edx
  800eb2:	79 23                	jns    800ed7 <vprintfmt+0x29b>
				putch('-', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 2d                	push   $0x2d
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eca:	f7 d8                	neg    %eax
  800ecc:	83 d2 00             	adc    $0x0,%edx
  800ecf:	f7 da                	neg    %edx
  800ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ed7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ede:	e9 bc 00 00 00       	jmp    800f9f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee9:	8d 45 14             	lea    0x14(%ebp),%eax
  800eec:	50                   	push   %eax
  800eed:	e8 84 fc ff ff       	call   800b76 <getuint>
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800efb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f02:	e9 98 00 00 00       	jmp    800f9f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	ff 75 0c             	pushl  0xc(%ebp)
  800f0d:	6a 58                	push   $0x58
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	ff d0                	call   *%eax
  800f14:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	ff 75 0c             	pushl  0xc(%ebp)
  800f1d:	6a 58                	push   $0x58
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	ff d0                	call   *%eax
  800f24:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f27:	83 ec 08             	sub    $0x8,%esp
  800f2a:	ff 75 0c             	pushl  0xc(%ebp)
  800f2d:	6a 58                	push   $0x58
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	ff d0                	call   *%eax
  800f34:	83 c4 10             	add    $0x10,%esp
			break;
  800f37:	e9 bc 00 00 00       	jmp    800ff8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	6a 30                	push   $0x30
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	ff d0                	call   *%eax
  800f49:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	6a 78                	push   $0x78
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5f:	83 c0 04             	add    $0x4,%eax
  800f62:	89 45 14             	mov    %eax,0x14(%ebp)
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	83 e8 04             	sub    $0x4,%eax
  800f6b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f77:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 e8             	pushl  -0x18(%ebp)
  800f86:	8d 45 14             	lea    0x14(%ebp),%eax
  800f89:	50                   	push   %eax
  800f8a:	e8 e7 fb ff ff       	call   800b76 <getuint>
  800f8f:	83 c4 10             	add    $0x10,%esp
  800f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f95:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f9f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	52                   	push   %edx
  800faa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fad:	50                   	push   %eax
  800fae:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb1:	ff 75 f0             	pushl  -0x10(%ebp)
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	ff 75 08             	pushl  0x8(%ebp)
  800fba:	e8 00 fb ff ff       	call   800abf <printnum>
  800fbf:	83 c4 20             	add    $0x20,%esp
			break;
  800fc2:	eb 34                	jmp    800ff8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	53                   	push   %ebx
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	ff d0                	call   *%eax
  800fd0:	83 c4 10             	add    $0x10,%esp
			break;
  800fd3:	eb 23                	jmp    800ff8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	ff 75 0c             	pushl  0xc(%ebp)
  800fdb:	6a 25                	push   $0x25
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	ff d0                	call   *%eax
  800fe2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe5:	ff 4d 10             	decl   0x10(%ebp)
  800fe8:	eb 03                	jmp    800fed <vprintfmt+0x3b1>
  800fea:	ff 4d 10             	decl   0x10(%ebp)
  800fed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff0:	48                   	dec    %eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 25                	cmp    $0x25,%al
  800ff5:	75 f3                	jne    800fea <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ff7:	90                   	nop
		}
	}
  800ff8:	e9 47 fc ff ff       	jmp    800c44 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ffd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80100b:	8d 45 10             	lea    0x10(%ebp),%eax
  80100e:	83 c0 04             	add    $0x4,%eax
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	ff 75 f4             	pushl  -0xc(%ebp)
  80101a:	50                   	push   %eax
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	ff 75 08             	pushl  0x8(%ebp)
  801021:	e8 16 fc ff ff       	call   800c3c <vprintfmt>
  801026:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801029:	90                   	nop
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	8b 40 08             	mov    0x8(%eax),%eax
  801035:	8d 50 01             	lea    0x1(%eax),%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	8b 10                	mov    (%eax),%edx
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8b 40 04             	mov    0x4(%eax),%eax
  801049:	39 c2                	cmp    %eax,%edx
  80104b:	73 12                	jae    80105f <sprintputch+0x33>
		*b->buf++ = ch;
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	8b 00                	mov    (%eax),%eax
  801052:	8d 48 01             	lea    0x1(%eax),%ecx
  801055:	8b 55 0c             	mov    0xc(%ebp),%edx
  801058:	89 0a                	mov    %ecx,(%edx)
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	88 10                	mov    %dl,(%eax)
}
  80105f:	90                   	nop
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801087:	74 06                	je     80108f <vsnprintf+0x2d>
  801089:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108d:	7f 07                	jg     801096 <vsnprintf+0x34>
		return -E_INVAL;
  80108f:	b8 03 00 00 00       	mov    $0x3,%eax
  801094:	eb 20                	jmp    8010b6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801096:	ff 75 14             	pushl  0x14(%ebp)
  801099:	ff 75 10             	pushl  0x10(%ebp)
  80109c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80109f:	50                   	push   %eax
  8010a0:	68 2c 10 80 00       	push   $0x80102c
  8010a5:	e8 92 fb ff ff       	call   800c3c <vprintfmt>
  8010aa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010be:	8d 45 10             	lea    0x10(%ebp),%eax
  8010c1:	83 c0 04             	add    $0x4,%eax
  8010c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cd:	50                   	push   %eax
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	ff 75 08             	pushl  0x8(%ebp)
  8010d4:	e8 89 ff ff ff       	call   801062 <vsnprintf>
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f1:	eb 06                	jmp    8010f9 <strlen+0x15>
		n++;
  8010f3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f6:	ff 45 08             	incl   0x8(%ebp)
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	84 c0                	test   %al,%al
  801100:	75 f1                	jne    8010f3 <strlen+0xf>
		n++;
	return n;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801114:	eb 09                	jmp    80111f <strnlen+0x18>
		n++;
  801116:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	ff 4d 0c             	decl   0xc(%ebp)
  80111f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801123:	74 09                	je     80112e <strnlen+0x27>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	84 c0                	test   %al,%al
  80112c:	75 e8                	jne    801116 <strnlen+0xf>
		n++;
	return n;
  80112e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80113f:	90                   	nop
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8d 50 01             	lea    0x1(%eax),%edx
  801146:	89 55 08             	mov    %edx,0x8(%ebp)
  801149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801152:	8a 12                	mov    (%edx),%dl
  801154:	88 10                	mov    %dl,(%eax)
  801156:	8a 00                	mov    (%eax),%al
  801158:	84 c0                	test   %al,%al
  80115a:	75 e4                	jne    801140 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801174:	eb 1f                	jmp    801195 <strncpy+0x34>
		*dst++ = *src;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8d 50 01             	lea    0x1(%eax),%edx
  80117c:	89 55 08             	mov    %edx,0x8(%ebp)
  80117f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801182:	8a 12                	mov    (%edx),%dl
  801184:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	84 c0                	test   %al,%al
  80118d:	74 03                	je     801192 <strncpy+0x31>
			src++;
  80118f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801192:	ff 45 fc             	incl   -0x4(%ebp)
  801195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801198:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119b:	72 d9                	jb     801176 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b2:	74 30                	je     8011e4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011b4:	eb 16                	jmp    8011cc <strlcpy+0x2a>
			*dst++ = *src++;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8d 50 01             	lea    0x1(%eax),%edx
  8011bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011c8:	8a 12                	mov    (%edx),%dl
  8011ca:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011cc:	ff 4d 10             	decl   0x10(%ebp)
  8011cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d3:	74 09                	je     8011de <strlcpy+0x3c>
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	84 c0                	test   %al,%al
  8011dc:	75 d8                	jne    8011b6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011f3:	eb 06                	jmp    8011fb <strcmp+0xb>
		p++, q++;
  8011f5:	ff 45 08             	incl   0x8(%ebp)
  8011f8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	84 c0                	test   %al,%al
  801202:	74 0e                	je     801212 <strcmp+0x22>
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 10                	mov    (%eax),%dl
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	38 c2                	cmp    %al,%dl
  801210:	74 e3                	je     8011f5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f b6 d0             	movzbl %al,%edx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f b6 c0             	movzbl %al,%eax
  801222:	29 c2                	sub    %eax,%edx
  801224:	89 d0                	mov    %edx,%eax
}
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80122b:	eb 09                	jmp    801236 <strncmp+0xe>
		n--, p++, q++;
  80122d:	ff 4d 10             	decl   0x10(%ebp)
  801230:	ff 45 08             	incl   0x8(%ebp)
  801233:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801236:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123a:	74 17                	je     801253 <strncmp+0x2b>
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 0e                	je     801253 <strncmp+0x2b>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 10                	mov    (%eax),%dl
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	38 c2                	cmp    %al,%dl
  801251:	74 da                	je     80122d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801253:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801257:	75 07                	jne    801260 <strncmp+0x38>
		return 0;
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
  80125e:	eb 14                	jmp    801274 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f b6 d0             	movzbl %al,%edx
  801268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	0f b6 c0             	movzbl %al,%eax
  801270:	29 c2                	sub    %eax,%edx
  801272:	89 d0                	mov    %edx,%eax
}
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    

00801276 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801282:	eb 12                	jmp    801296 <strchr+0x20>
		if (*s == c)
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80128c:	75 05                	jne    801293 <strchr+0x1d>
			return (char *) s;
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	eb 11                	jmp    8012a4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801293:	ff 45 08             	incl   0x8(%ebp)
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	75 e5                	jne    801284 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80129f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012b2:	eb 0d                	jmp    8012c1 <strfind+0x1b>
		if (*s == c)
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012bc:	74 0e                	je     8012cc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012be:	ff 45 08             	incl   0x8(%ebp)
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	75 ea                	jne    8012b4 <strfind+0xe>
  8012ca:	eb 01                	jmp    8012cd <strfind+0x27>
		if (*s == c)
			break;
  8012cc:	90                   	nop
	return (char *) s;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012e4:	eb 0e                	jmp    8012f4 <memset+0x22>
		*p++ = c;
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012f4:	ff 4d f8             	decl   -0x8(%ebp)
  8012f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012fb:	79 e9                	jns    8012e6 <memset+0x14>
		*p++ = c;

	return v;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801314:	eb 16                	jmp    80132c <memcpy+0x2a>
		*d++ = *s++;
  801316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801319:	8d 50 01             	lea    0x1(%eax),%edx
  80131c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801322:	8d 4a 01             	lea    0x1(%edx),%ecx
  801325:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801328:	8a 12                	mov    (%edx),%dl
  80132a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801332:	89 55 10             	mov    %edx,0x10(%ebp)
  801335:	85 c0                	test   %eax,%eax
  801337:	75 dd                	jne    801316 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801350:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801353:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801356:	73 50                	jae    8013a8 <memmove+0x6a>
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801363:	76 43                	jbe    8013a8 <memmove+0x6a>
		s += n;
  801365:	8b 45 10             	mov    0x10(%ebp),%eax
  801368:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801371:	eb 10                	jmp    801383 <memmove+0x45>
			*--d = *--s;
  801373:	ff 4d f8             	decl   -0x8(%ebp)
  801376:	ff 4d fc             	decl   -0x4(%ebp)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	8d 50 ff             	lea    -0x1(%eax),%edx
  801389:	89 55 10             	mov    %edx,0x10(%ebp)
  80138c:	85 c0                	test   %eax,%eax
  80138e:	75 e3                	jne    801373 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801390:	eb 23                	jmp    8013b5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801392:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801395:	8d 50 01             	lea    0x1(%eax),%edx
  801398:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80139b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013a4:	8a 12                	mov    (%edx),%dl
  8013a6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	75 dd                	jne    801392 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013cc:	eb 2a                	jmp    8013f8 <memcmp+0x3e>
		if (*s1 != *s2)
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8a 10                	mov    (%eax),%dl
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	38 c2                	cmp    %al,%dl
  8013da:	74 16                	je     8013f2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	0f b6 d0             	movzbl %al,%edx
  8013e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	0f b6 c0             	movzbl %al,%eax
  8013ec:	29 c2                	sub    %eax,%edx
  8013ee:	89 d0                	mov    %edx,%eax
  8013f0:	eb 18                	jmp    80140a <memcmp+0x50>
		s1++, s2++;
  8013f2:	ff 45 fc             	incl   -0x4(%ebp)
  8013f5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801401:	85 c0                	test   %eax,%eax
  801403:	75 c9                	jne    8013ce <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801412:	8b 55 08             	mov    0x8(%ebp),%edx
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80141d:	eb 15                	jmp    801434 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	0f b6 d0             	movzbl %al,%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	0f b6 c0             	movzbl %al,%eax
  80142d:	39 c2                	cmp    %eax,%edx
  80142f:	74 0d                	je     80143e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80143a:	72 e3                	jb     80141f <memfind+0x13>
  80143c:	eb 01                	jmp    80143f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80143e:	90                   	nop
	return (void *) s;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80144a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801451:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801458:	eb 03                	jmp    80145d <strtol+0x19>
		s++;
  80145a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 20                	cmp    $0x20,%al
  801464:	74 f4                	je     80145a <strtol+0x16>
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 09                	cmp    $0x9,%al
  80146d:	74 eb                	je     80145a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 2b                	cmp    $0x2b,%al
  801476:	75 05                	jne    80147d <strtol+0x39>
		s++;
  801478:	ff 45 08             	incl   0x8(%ebp)
  80147b:	eb 13                	jmp    801490 <strtol+0x4c>
	else if (*s == '-')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2d                	cmp    $0x2d,%al
  801484:	75 0a                	jne    801490 <strtol+0x4c>
		s++, neg = 1;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801494:	74 06                	je     80149c <strtol+0x58>
  801496:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80149a:	75 20                	jne    8014bc <strtol+0x78>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	3c 30                	cmp    $0x30,%al
  8014a3:	75 17                	jne    8014bc <strtol+0x78>
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	40                   	inc    %eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 78                	cmp    $0x78,%al
  8014ad:	75 0d                	jne    8014bc <strtol+0x78>
		s += 2, base = 16;
  8014af:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014b3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014ba:	eb 28                	jmp    8014e4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c0:	75 15                	jne    8014d7 <strtol+0x93>
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	3c 30                	cmp    $0x30,%al
  8014c9:	75 0c                	jne    8014d7 <strtol+0x93>
		s++, base = 8;
  8014cb:	ff 45 08             	incl   0x8(%ebp)
  8014ce:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014d5:	eb 0d                	jmp    8014e4 <strtol+0xa0>
	else if (base == 0)
  8014d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014db:	75 07                	jne    8014e4 <strtol+0xa0>
		base = 10;
  8014dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	3c 2f                	cmp    $0x2f,%al
  8014eb:	7e 19                	jle    801506 <strtol+0xc2>
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	3c 39                	cmp    $0x39,%al
  8014f4:	7f 10                	jg     801506 <strtol+0xc2>
			dig = *s - '0';
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	0f be c0             	movsbl %al,%eax
  8014fe:	83 e8 30             	sub    $0x30,%eax
  801501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801504:	eb 42                	jmp    801548 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	3c 60                	cmp    $0x60,%al
  80150d:	7e 19                	jle    801528 <strtol+0xe4>
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	3c 7a                	cmp    $0x7a,%al
  801516:	7f 10                	jg     801528 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	0f be c0             	movsbl %al,%eax
  801520:	83 e8 57             	sub    $0x57,%eax
  801523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801526:	eb 20                	jmp    801548 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	3c 40                	cmp    $0x40,%al
  80152f:	7e 39                	jle    80156a <strtol+0x126>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	3c 5a                	cmp    $0x5a,%al
  801538:	7f 30                	jg     80156a <strtol+0x126>
			dig = *s - 'A' + 10;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f be c0             	movsbl %al,%eax
  801542:	83 e8 37             	sub    $0x37,%eax
  801545:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80154e:	7d 19                	jge    801569 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801550:	ff 45 08             	incl   0x8(%ebp)
  801553:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801556:	0f af 45 10          	imul   0x10(%ebp),%eax
  80155a:	89 c2                	mov    %eax,%edx
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801564:	e9 7b ff ff ff       	jmp    8014e4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801569:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80156a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80156e:	74 08                	je     801578 <strtol+0x134>
		*endptr = (char *) s;
  801570:	8b 45 0c             	mov    0xc(%ebp),%eax
  801573:	8b 55 08             	mov    0x8(%ebp),%edx
  801576:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801578:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80157c:	74 07                	je     801585 <strtol+0x141>
  80157e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801581:	f7 d8                	neg    %eax
  801583:	eb 03                	jmp    801588 <strtol+0x144>
  801585:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <ltostr>:

void
ltostr(long value, char *str)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801597:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80159e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015a2:	79 13                	jns    8015b7 <ltostr+0x2d>
	{
		neg = 1;
  8015a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015b1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015b4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015bf:	99                   	cltd   
  8015c0:	f7 f9                	idiv   %ecx
  8015c2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c8:	8d 50 01             	lea    0x1(%eax),%edx
  8015cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ce:	89 c2                	mov    %eax,%edx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	01 d0                	add    %edx,%eax
  8015d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015d8:	83 c2 30             	add    $0x30,%edx
  8015db:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015e5:	f7 e9                	imul   %ecx
  8015e7:	c1 fa 02             	sar    $0x2,%edx
  8015ea:	89 c8                	mov    %ecx,%eax
  8015ec:	c1 f8 1f             	sar    $0x1f,%eax
  8015ef:	29 c2                	sub    %eax,%edx
  8015f1:	89 d0                	mov    %edx,%eax
  8015f3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015fe:	f7 e9                	imul   %ecx
  801600:	c1 fa 02             	sar    $0x2,%edx
  801603:	89 c8                	mov    %ecx,%eax
  801605:	c1 f8 1f             	sar    $0x1f,%eax
  801608:	29 c2                	sub    %eax,%edx
  80160a:	89 d0                	mov    %edx,%eax
  80160c:	c1 e0 02             	shl    $0x2,%eax
  80160f:	01 d0                	add    %edx,%eax
  801611:	01 c0                	add    %eax,%eax
  801613:	29 c1                	sub    %eax,%ecx
  801615:	89 ca                	mov    %ecx,%edx
  801617:	85 d2                	test   %edx,%edx
  801619:	75 9c                	jne    8015b7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80161b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801622:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801625:	48                   	dec    %eax
  801626:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801629:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80162d:	74 3d                	je     80166c <ltostr+0xe2>
		start = 1 ;
  80162f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801636:	eb 34                	jmp    80166c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 c2                	add    %eax,%edx
  80164d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801650:	8b 45 0c             	mov    0xc(%ebp),%eax
  801653:	01 c8                	add    %ecx,%eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801659:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165f:	01 c2                	add    %eax,%edx
  801661:	8a 45 eb             	mov    -0x15(%ebp),%al
  801664:	88 02                	mov    %al,(%edx)
		start++ ;
  801666:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801669:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80166c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801672:	7c c4                	jl     801638 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801674:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167a:	01 d0                	add    %edx,%eax
  80167c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	e8 54 fa ff ff       	call   8010e4 <strlen>
  801690:	83 c4 04             	add    $0x4,%esp
  801693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	e8 46 fa ff ff       	call   8010e4 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016b2:	eb 17                	jmp    8016cb <strcconcat+0x49>
		final[s] = str1[s] ;
  8016b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	01 c2                	add    %eax,%edx
  8016bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	01 c8                	add    %ecx,%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016c8:	ff 45 fc             	incl   -0x4(%ebp)
  8016cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016d1:	7c e1                	jl     8016b4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016e1:	eb 1f                	jmp    801702 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8d 50 01             	lea    0x1(%eax),%edx
  8016e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	01 c2                	add    %eax,%edx
  8016f3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	01 c8                	add    %ecx,%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ff:	ff 45 f8             	incl   -0x8(%ebp)
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801708:	7c d9                	jl     8016e3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80170a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c6 00 00             	movb   $0x0,(%eax)
}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80171b:	8b 45 14             	mov    0x14(%ebp),%eax
  80171e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801724:	8b 45 14             	mov    0x14(%ebp),%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801730:	8b 45 10             	mov    0x10(%ebp),%eax
  801733:	01 d0                	add    %edx,%eax
  801735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80173b:	eb 0c                	jmp    801749 <strsplit+0x31>
			*string++ = 0;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8d 50 01             	lea    0x1(%eax),%edx
  801743:	89 55 08             	mov    %edx,0x8(%ebp)
  801746:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	84 c0                	test   %al,%al
  801750:	74 18                	je     80176a <strsplit+0x52>
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	0f be c0             	movsbl %al,%eax
  80175a:	50                   	push   %eax
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	e8 13 fb ff ff       	call   801276 <strchr>
  801763:	83 c4 08             	add    $0x8,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	75 d3                	jne    80173d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	74 5a                	je     8017cd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801773:	8b 45 14             	mov    0x14(%ebp),%eax
  801776:	8b 00                	mov    (%eax),%eax
  801778:	83 f8 0f             	cmp    $0xf,%eax
  80177b:	75 07                	jne    801784 <strsplit+0x6c>
		{
			return 0;
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
  801782:	eb 66                	jmp    8017ea <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801784:	8b 45 14             	mov    0x14(%ebp),%eax
  801787:	8b 00                	mov    (%eax),%eax
  801789:	8d 48 01             	lea    0x1(%eax),%ecx
  80178c:	8b 55 14             	mov    0x14(%ebp),%edx
  80178f:	89 0a                	mov    %ecx,(%edx)
  801791:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801798:	8b 45 10             	mov    0x10(%ebp),%eax
  80179b:	01 c2                	add    %eax,%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017a2:	eb 03                	jmp    8017a7 <strsplit+0x8f>
			string++;
  8017a4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	84 c0                	test   %al,%al
  8017ae:	74 8b                	je     80173b <strsplit+0x23>
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	0f be c0             	movsbl %al,%eax
  8017b8:	50                   	push   %eax
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	e8 b5 fa ff ff       	call   801276 <strchr>
  8017c1:	83 c4 08             	add    $0x8,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	74 dc                	je     8017a4 <strsplit+0x8c>
			string++;
	}
  8017c8:	e9 6e ff ff ff       	jmp    80173b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017cd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d1:	8b 00                	mov    (%eax),%eax
  8017d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 90 29 80 00       	push   $0x802990
  8017fa:	6a 0e                	push   $0xe
  8017fc:	68 ca 29 80 00       	push   $0x8029ca
  801801:	e8 a8 ef ff ff       	call   8007ae <_panic>

00801806 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80180c:	a1 04 30 80 00       	mov    0x803004,%eax
  801811:	85 c0                	test   %eax,%eax
  801813:	74 0f                	je     801824 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801815:	e8 d2 ff ff ff       	call   8017ec <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181a:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801821:	00 00 00 
	}
	if (size == 0) return NULL ;
  801824:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801828:	75 07                	jne    801831 <malloc+0x2b>
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
  80182f:	eb 14                	jmp    801845 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 d8 29 80 00       	push   $0x8029d8
  801839:	6a 2e                	push   $0x2e
  80183b:	68 ca 29 80 00       	push   $0x8029ca
  801840:	e8 69 ef ff ff       	call   8007ae <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 00 2a 80 00       	push   $0x802a00
  801855:	6a 49                	push   $0x49
  801857:	68 ca 29 80 00       	push   $0x8029ca
  80185c:	e8 4d ef ff ff       	call   8007ae <_panic>

00801861 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 18             	sub    $0x18,%esp
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 24 2a 80 00       	push   $0x802a24
  801875:	6a 57                	push   $0x57
  801877:	68 ca 29 80 00       	push   $0x8029ca
  80187c:	e8 2d ef ff ff       	call   8007ae <_panic>

00801881 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 4c 2a 80 00       	push   $0x802a4c
  80188f:	6a 60                	push   $0x60
  801891:	68 ca 29 80 00       	push   $0x8029ca
  801896:	e8 13 ef ff ff       	call   8007ae <_panic>

0080189b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	68 70 2a 80 00       	push   $0x802a70
  8018a9:	6a 7c                	push   $0x7c
  8018ab:	68 ca 29 80 00       	push   $0x8029ca
  8018b0:	e8 f9 ee ff ff       	call   8007ae <_panic>

008018b5 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	68 98 2a 80 00       	push   $0x802a98
  8018c3:	68 86 00 00 00       	push   $0x86
  8018c8:	68 ca 29 80 00       	push   $0x8029ca
  8018cd:	e8 dc ee ff ff       	call   8007ae <_panic>

008018d2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 bc 2a 80 00       	push   $0x802abc
  8018e0:	68 91 00 00 00       	push   $0x91
  8018e5:	68 ca 29 80 00       	push   $0x8029ca
  8018ea:	e8 bf ee ff ff       	call   8007ae <_panic>

008018ef <shrink>:

}
void shrink(uint32 newSize)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	68 bc 2a 80 00       	push   $0x802abc
  8018fd:	68 96 00 00 00       	push   $0x96
  801902:	68 ca 29 80 00       	push   $0x8029ca
  801907:	e8 a2 ee ff ff       	call   8007ae <_panic>

0080190c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 bc 2a 80 00       	push   $0x802abc
  80191a:	68 9b 00 00 00       	push   $0x9b
  80191f:	68 ca 29 80 00       	push   $0x8029ca
  801924:	e8 85 ee ff ff       	call   8007ae <_panic>

00801929 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	57                   	push   %edi
  80192d:	56                   	push   %esi
  80192e:	53                   	push   %ebx
  80192f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801941:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801944:	cd 30                	int    $0x30
  801946:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5f                   	pop    %edi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 45 10             	mov    0x10(%ebp),%eax
  80195d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801960:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	52                   	push   %edx
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	6a 00                	push   $0x0
  801972:	e8 b2 ff ff ff       	call   801929 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_cgetc>:

int
sys_cgetc(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 01                	push   $0x1
  80198c:	e8 98 ff ff ff       	call   801929 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 05                	push   $0x5
  8019a9:	e8 7b ff ff ff       	call   801929 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8019bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
  8019c9:	51                   	push   %ecx
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	6a 06                	push   $0x6
  8019ce:	e8 56 ff ff ff       	call   801929 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d9:	5b                   	pop    %ebx
  8019da:	5e                   	pop    %esi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 07                	push   $0x7
  8019f0:	e8 34 ff ff ff       	call   801929 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	6a 08                	push   $0x8
  801a0b:	e8 19 ff ff ff       	call   801929 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 09                	push   $0x9
  801a24:	e8 00 ff ff ff       	call   801929 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 0a                	push   $0xa
  801a3d:	e8 e7 fe ff ff       	call   801929 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 0b                	push   $0xb
  801a56:	e8 ce fe ff ff       	call   801929 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	6a 0f                	push   $0xf
  801a71:	e8 b3 fe ff ff       	call   801929 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
	return;
  801a79:	90                   	nop
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 10                	push   $0x10
  801a8d:	e8 97 fe ff ff       	call   801929 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
	return ;
  801a95:	90                   	nop
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	6a 11                	push   $0x11
  801aaa:	e8 7a fe ff ff       	call   801929 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab2:	90                   	nop
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 0c                	push   $0xc
  801ac4:	e8 60 fe ff ff       	call   801929 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	6a 0d                	push   $0xd
  801ade:	e8 46 fe ff ff       	call   801929 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 0e                	push   $0xe
  801af7:	e8 2d fe ff ff       	call   801929 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 13                	push   $0x13
  801b11:	e8 13 fe ff ff       	call   801929 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	90                   	nop
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 14                	push   $0x14
  801b2b:	e8 f9 fd ff ff       	call   801929 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	90                   	nop
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	50                   	push   %eax
  801b4f:	6a 15                	push   $0x15
  801b51:	e8 d3 fd ff ff       	call   801929 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 16                	push   $0x16
  801b6b:	e8 b9 fd ff ff       	call   801929 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	50                   	push   %eax
  801b86:	6a 17                	push   $0x17
  801b88:	e8 9c fd ff ff       	call   801929 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 1a                	push   $0x1a
  801ba5:	e8 7f fd ff ff       	call   801929 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 18                	push   $0x18
  801bc2:	e8 62 fd ff ff       	call   801929 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 19                	push   $0x19
  801be0:	e8 44 fd ff ff       	call   801929 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bf7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bfa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	51                   	push   %ecx
  801c04:	52                   	push   %edx
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	50                   	push   %eax
  801c09:	6a 1b                	push   $0x1b
  801c0b:	e8 19 fd ff ff       	call   801929 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	52                   	push   %edx
  801c25:	50                   	push   %eax
  801c26:	6a 1c                	push   $0x1c
  801c28:	e8 fc fc ff ff       	call   801929 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	51                   	push   %ecx
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	6a 1d                	push   $0x1d
  801c47:	e8 dd fc ff ff       	call   801929 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	52                   	push   %edx
  801c61:	50                   	push   %eax
  801c62:	6a 1e                	push   $0x1e
  801c64:	e8 c0 fc ff ff       	call   801929 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 1f                	push   $0x1f
  801c7d:	e8 a7 fc ff ff       	call   801929 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	ff 75 14             	pushl  0x14(%ebp)
  801c92:	ff 75 10             	pushl  0x10(%ebp)
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	50                   	push   %eax
  801c99:	6a 20                	push   $0x20
  801c9b:	e8 89 fc ff ff       	call   801929 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 21                	push   $0x21
  801cb6:	e8 6e fc ff ff       	call   801929 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	50                   	push   %eax
  801cd0:	6a 22                	push   $0x22
  801cd2:	e8 52 fc ff ff       	call   801929 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 02                	push   $0x2
  801ceb:	e8 39 fc ff ff       	call   801929 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 03                	push   $0x3
  801d04:	e8 20 fc ff ff       	call   801929 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 04                	push   $0x4
  801d1d:	e8 07 fc ff ff       	call   801929 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_exit_env>:


void sys_exit_env(void)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 23                	push   $0x23
  801d36:	e8 ee fb ff ff       	call   801929 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	90                   	nop
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d4a:	8d 50 04             	lea    0x4(%eax),%edx
  801d4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 24                	push   $0x24
  801d5a:	e8 ca fb ff ff       	call   801929 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return result;
  801d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6b:	89 01                	mov    %eax,(%ecx)
  801d6d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	c9                   	leave  
  801d74:	c2 04 00             	ret    $0x4

00801d77 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	ff 75 10             	pushl  0x10(%ebp)
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	6a 12                	push   $0x12
  801d89:	e8 9b fb ff ff       	call   801929 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 25                	push   $0x25
  801da3:	e8 81 fb ff ff       	call   801929 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801db9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	50                   	push   %eax
  801dc6:	6a 26                	push   $0x26
  801dc8:	e8 5c fb ff ff       	call   801929 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <rsttst>:
void rsttst()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 28                	push   $0x28
  801de2:	e8 42 fb ff ff       	call   801929 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	8b 45 14             	mov    0x14(%ebp),%eax
  801df6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801df9:	8b 55 18             	mov    0x18(%ebp),%edx
  801dfc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e00:	52                   	push   %edx
  801e01:	50                   	push   %eax
  801e02:	ff 75 10             	pushl  0x10(%ebp)
  801e05:	ff 75 0c             	pushl  0xc(%ebp)
  801e08:	ff 75 08             	pushl  0x8(%ebp)
  801e0b:	6a 27                	push   $0x27
  801e0d:	e8 17 fb ff ff       	call   801929 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
	return ;
  801e15:	90                   	nop
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <chktst>:
void chktst(uint32 n)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 08             	pushl  0x8(%ebp)
  801e26:	6a 29                	push   $0x29
  801e28:	e8 fc fa ff ff       	call   801929 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e30:	90                   	nop
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <inctst>:

void inctst()
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 2a                	push   $0x2a
  801e42:	e8 e2 fa ff ff       	call   801929 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4a:	90                   	nop
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <gettst>:
uint32 gettst()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 2b                	push   $0x2b
  801e5c:	e8 c8 fa ff ff       	call   801929 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 2c                	push   $0x2c
  801e78:	e8 ac fa ff ff       	call   801929 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e83:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e87:	75 07                	jne    801e90 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e89:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8e:	eb 05                	jmp    801e95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 2c                	push   $0x2c
  801ea9:	e8 7b fa ff ff       	call   801929 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
  801eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eb4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eb8:	75 07                	jne    801ec1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	eb 05                	jmp    801ec6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 2c                	push   $0x2c
  801eda:	e8 4a fa ff ff       	call   801929 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
  801ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ee5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ee9:	75 07                	jne    801ef2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eeb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef0:	eb 05                	jmp    801ef7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 2c                	push   $0x2c
  801f0b:	e8 19 fa ff ff       	call   801929 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
  801f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f16:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f1a:	75 07                	jne    801f23 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f21:	eb 05                	jmp    801f28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 2d                	push   $0x2d
  801f3a:	e8 ea f9 ff ff       	call   801929 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f49:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	53                   	push   %ebx
  801f58:	51                   	push   %ecx
  801f59:	52                   	push   %edx
  801f5a:	50                   	push   %eax
  801f5b:	6a 2e                	push   $0x2e
  801f5d:	e8 c7 f9 ff ff       	call   801929 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 2f                	push   $0x2f
  801f7d:	e8 a7 f9 ff ff       	call   801929 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    
  801f87:	90                   	nop

00801f88 <__udivdi3>:
  801f88:	55                   	push   %ebp
  801f89:	57                   	push   %edi
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 1c             	sub    $0x1c,%esp
  801f8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f9f:	89 ca                	mov    %ecx,%edx
  801fa1:	89 f8                	mov    %edi,%eax
  801fa3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fa7:	85 f6                	test   %esi,%esi
  801fa9:	75 2d                	jne    801fd8 <__udivdi3+0x50>
  801fab:	39 cf                	cmp    %ecx,%edi
  801fad:	77 65                	ja     802014 <__udivdi3+0x8c>
  801faf:	89 fd                	mov    %edi,%ebp
  801fb1:	85 ff                	test   %edi,%edi
  801fb3:	75 0b                	jne    801fc0 <__udivdi3+0x38>
  801fb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fba:	31 d2                	xor    %edx,%edx
  801fbc:	f7 f7                	div    %edi
  801fbe:	89 c5                	mov    %eax,%ebp
  801fc0:	31 d2                	xor    %edx,%edx
  801fc2:	89 c8                	mov    %ecx,%eax
  801fc4:	f7 f5                	div    %ebp
  801fc6:	89 c1                	mov    %eax,%ecx
  801fc8:	89 d8                	mov    %ebx,%eax
  801fca:	f7 f5                	div    %ebp
  801fcc:	89 cf                	mov    %ecx,%edi
  801fce:	89 fa                	mov    %edi,%edx
  801fd0:	83 c4 1c             	add    $0x1c,%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    
  801fd8:	39 ce                	cmp    %ecx,%esi
  801fda:	77 28                	ja     802004 <__udivdi3+0x7c>
  801fdc:	0f bd fe             	bsr    %esi,%edi
  801fdf:	83 f7 1f             	xor    $0x1f,%edi
  801fe2:	75 40                	jne    802024 <__udivdi3+0x9c>
  801fe4:	39 ce                	cmp    %ecx,%esi
  801fe6:	72 0a                	jb     801ff2 <__udivdi3+0x6a>
  801fe8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fec:	0f 87 9e 00 00 00    	ja     802090 <__udivdi3+0x108>
  801ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff7:	89 fa                	mov    %edi,%edx
  801ff9:	83 c4 1c             	add    $0x1c,%esp
  801ffc:	5b                   	pop    %ebx
  801ffd:	5e                   	pop    %esi
  801ffe:	5f                   	pop    %edi
  801fff:	5d                   	pop    %ebp
  802000:	c3                   	ret    
  802001:	8d 76 00             	lea    0x0(%esi),%esi
  802004:	31 ff                	xor    %edi,%edi
  802006:	31 c0                	xor    %eax,%eax
  802008:	89 fa                	mov    %edi,%edx
  80200a:	83 c4 1c             	add    $0x1c,%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5f                   	pop    %edi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    
  802012:	66 90                	xchg   %ax,%ax
  802014:	89 d8                	mov    %ebx,%eax
  802016:	f7 f7                	div    %edi
  802018:	31 ff                	xor    %edi,%edi
  80201a:	89 fa                	mov    %edi,%edx
  80201c:	83 c4 1c             	add    $0x1c,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    
  802024:	bd 20 00 00 00       	mov    $0x20,%ebp
  802029:	89 eb                	mov    %ebp,%ebx
  80202b:	29 fb                	sub    %edi,%ebx
  80202d:	89 f9                	mov    %edi,%ecx
  80202f:	d3 e6                	shl    %cl,%esi
  802031:	89 c5                	mov    %eax,%ebp
  802033:	88 d9                	mov    %bl,%cl
  802035:	d3 ed                	shr    %cl,%ebp
  802037:	89 e9                	mov    %ebp,%ecx
  802039:	09 f1                	or     %esi,%ecx
  80203b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80203f:	89 f9                	mov    %edi,%ecx
  802041:	d3 e0                	shl    %cl,%eax
  802043:	89 c5                	mov    %eax,%ebp
  802045:	89 d6                	mov    %edx,%esi
  802047:	88 d9                	mov    %bl,%cl
  802049:	d3 ee                	shr    %cl,%esi
  80204b:	89 f9                	mov    %edi,%ecx
  80204d:	d3 e2                	shl    %cl,%edx
  80204f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802053:	88 d9                	mov    %bl,%cl
  802055:	d3 e8                	shr    %cl,%eax
  802057:	09 c2                	or     %eax,%edx
  802059:	89 d0                	mov    %edx,%eax
  80205b:	89 f2                	mov    %esi,%edx
  80205d:	f7 74 24 0c          	divl   0xc(%esp)
  802061:	89 d6                	mov    %edx,%esi
  802063:	89 c3                	mov    %eax,%ebx
  802065:	f7 e5                	mul    %ebp
  802067:	39 d6                	cmp    %edx,%esi
  802069:	72 19                	jb     802084 <__udivdi3+0xfc>
  80206b:	74 0b                	je     802078 <__udivdi3+0xf0>
  80206d:	89 d8                	mov    %ebx,%eax
  80206f:	31 ff                	xor    %edi,%edi
  802071:	e9 58 ff ff ff       	jmp    801fce <__udivdi3+0x46>
  802076:	66 90                	xchg   %ax,%ax
  802078:	8b 54 24 08          	mov    0x8(%esp),%edx
  80207c:	89 f9                	mov    %edi,%ecx
  80207e:	d3 e2                	shl    %cl,%edx
  802080:	39 c2                	cmp    %eax,%edx
  802082:	73 e9                	jae    80206d <__udivdi3+0xe5>
  802084:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802087:	31 ff                	xor    %edi,%edi
  802089:	e9 40 ff ff ff       	jmp    801fce <__udivdi3+0x46>
  80208e:	66 90                	xchg   %ax,%ax
  802090:	31 c0                	xor    %eax,%eax
  802092:	e9 37 ff ff ff       	jmp    801fce <__udivdi3+0x46>
  802097:	90                   	nop

00802098 <__umoddi3>:
  802098:	55                   	push   %ebp
  802099:	57                   	push   %edi
  80209a:	56                   	push   %esi
  80209b:	53                   	push   %ebx
  80209c:	83 ec 1c             	sub    $0x1c,%esp
  80209f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020b7:	89 f3                	mov    %esi,%ebx
  8020b9:	89 fa                	mov    %edi,%edx
  8020bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020bf:	89 34 24             	mov    %esi,(%esp)
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 1a                	jne    8020e0 <__umoddi3+0x48>
  8020c6:	39 f7                	cmp    %esi,%edi
  8020c8:	0f 86 a2 00 00 00    	jbe    802170 <__umoddi3+0xd8>
  8020ce:	89 c8                	mov    %ecx,%eax
  8020d0:	89 f2                	mov    %esi,%edx
  8020d2:	f7 f7                	div    %edi
  8020d4:	89 d0                	mov    %edx,%eax
  8020d6:	31 d2                	xor    %edx,%edx
  8020d8:	83 c4 1c             	add    $0x1c,%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5e                   	pop    %esi
  8020dd:	5f                   	pop    %edi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    
  8020e0:	39 f0                	cmp    %esi,%eax
  8020e2:	0f 87 ac 00 00 00    	ja     802194 <__umoddi3+0xfc>
  8020e8:	0f bd e8             	bsr    %eax,%ebp
  8020eb:	83 f5 1f             	xor    $0x1f,%ebp
  8020ee:	0f 84 ac 00 00 00    	je     8021a0 <__umoddi3+0x108>
  8020f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8020f9:	29 ef                	sub    %ebp,%edi
  8020fb:	89 fe                	mov    %edi,%esi
  8020fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802101:	89 e9                	mov    %ebp,%ecx
  802103:	d3 e0                	shl    %cl,%eax
  802105:	89 d7                	mov    %edx,%edi
  802107:	89 f1                	mov    %esi,%ecx
  802109:	d3 ef                	shr    %cl,%edi
  80210b:	09 c7                	or     %eax,%edi
  80210d:	89 e9                	mov    %ebp,%ecx
  80210f:	d3 e2                	shl    %cl,%edx
  802111:	89 14 24             	mov    %edx,(%esp)
  802114:	89 d8                	mov    %ebx,%eax
  802116:	d3 e0                	shl    %cl,%eax
  802118:	89 c2                	mov    %eax,%edx
  80211a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80211e:	d3 e0                	shl    %cl,%eax
  802120:	89 44 24 04          	mov    %eax,0x4(%esp)
  802124:	8b 44 24 08          	mov    0x8(%esp),%eax
  802128:	89 f1                	mov    %esi,%ecx
  80212a:	d3 e8                	shr    %cl,%eax
  80212c:	09 d0                	or     %edx,%eax
  80212e:	d3 eb                	shr    %cl,%ebx
  802130:	89 da                	mov    %ebx,%edx
  802132:	f7 f7                	div    %edi
  802134:	89 d3                	mov    %edx,%ebx
  802136:	f7 24 24             	mull   (%esp)
  802139:	89 c6                	mov    %eax,%esi
  80213b:	89 d1                	mov    %edx,%ecx
  80213d:	39 d3                	cmp    %edx,%ebx
  80213f:	0f 82 87 00 00 00    	jb     8021cc <__umoddi3+0x134>
  802145:	0f 84 91 00 00 00    	je     8021dc <__umoddi3+0x144>
  80214b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80214f:	29 f2                	sub    %esi,%edx
  802151:	19 cb                	sbb    %ecx,%ebx
  802153:	89 d8                	mov    %ebx,%eax
  802155:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802159:	d3 e0                	shl    %cl,%eax
  80215b:	89 e9                	mov    %ebp,%ecx
  80215d:	d3 ea                	shr    %cl,%edx
  80215f:	09 d0                	or     %edx,%eax
  802161:	89 e9                	mov    %ebp,%ecx
  802163:	d3 eb                	shr    %cl,%ebx
  802165:	89 da                	mov    %ebx,%edx
  802167:	83 c4 1c             	add    $0x1c,%esp
  80216a:	5b                   	pop    %ebx
  80216b:	5e                   	pop    %esi
  80216c:	5f                   	pop    %edi
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    
  80216f:	90                   	nop
  802170:	89 fd                	mov    %edi,%ebp
  802172:	85 ff                	test   %edi,%edi
  802174:	75 0b                	jne    802181 <__umoddi3+0xe9>
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f7                	div    %edi
  80217f:	89 c5                	mov    %eax,%ebp
  802181:	89 f0                	mov    %esi,%eax
  802183:	31 d2                	xor    %edx,%edx
  802185:	f7 f5                	div    %ebp
  802187:	89 c8                	mov    %ecx,%eax
  802189:	f7 f5                	div    %ebp
  80218b:	89 d0                	mov    %edx,%eax
  80218d:	e9 44 ff ff ff       	jmp    8020d6 <__umoddi3+0x3e>
  802192:	66 90                	xchg   %ax,%ax
  802194:	89 c8                	mov    %ecx,%eax
  802196:	89 f2                	mov    %esi,%edx
  802198:	83 c4 1c             	add    $0x1c,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5f                   	pop    %edi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
  8021a0:	3b 04 24             	cmp    (%esp),%eax
  8021a3:	72 06                	jb     8021ab <__umoddi3+0x113>
  8021a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021a9:	77 0f                	ja     8021ba <__umoddi3+0x122>
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	29 f9                	sub    %edi,%ecx
  8021af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021b3:	89 14 24             	mov    %edx,(%esp)
  8021b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021be:	8b 14 24             	mov    (%esp),%edx
  8021c1:	83 c4 1c             	add    $0x1c,%esp
  8021c4:	5b                   	pop    %ebx
  8021c5:	5e                   	pop    %esi
  8021c6:	5f                   	pop    %edi
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    
  8021c9:	8d 76 00             	lea    0x0(%esi),%esi
  8021cc:	2b 04 24             	sub    (%esp),%eax
  8021cf:	19 fa                	sbb    %edi,%edx
  8021d1:	89 d1                	mov    %edx,%ecx
  8021d3:	89 c6                	mov    %eax,%esi
  8021d5:	e9 71 ff ff ff       	jmp    80214b <__umoddi3+0xb3>
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021e0:	72 ea                	jb     8021cc <__umoddi3+0x134>
  8021e2:	89 d9                	mov    %ebx,%ecx
  8021e4:	e9 62 ff ff ff       	jmp    80214b <__umoddi3+0xb3>
