
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 a7 0d 00 00       	call   800ddd <libmain>
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
  800045:	e8 5e 26 00 00       	call   8026a8 <sys_set_uheap_strategy>
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
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800083:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80009b:	68 80 29 80 00       	push   $0x802980
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 9c 29 80 00       	push   $0x80299c
  8000a7:	e8 80 0e 00 00       	call   800f2c <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 a9 23 00 00       	call   80245a <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 c6 1e 00 00       	call   801f84 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 ae 20 00 00       	call   802193 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 46 21 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 b3 29 80 00       	push   $0x8029b3
  8000fe:	e8 dc 1e 00 00       	call   801fdf <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 b8 29 80 00       	push   $0x8029b8
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 9c 29 80 00       	push   $0x80299c
  800122:	e8 05 0e 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 64 20 00 00       	call   802193 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 24 2a 80 00       	push   $0x802a24
  800142:	6a 2b                	push   $0x2b
  800144:	68 9c 29 80 00       	push   $0x80299c
  800149:	e8 de 0d 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 e0 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 a2 2a 80 00       	push   $0x802aa2
  800160:	6a 2c                	push   $0x2c
  800162:	68 9c 29 80 00       	push   $0x80299c
  800167:	e8 c0 0d 00 00       	call   800f2c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 22 20 00 00       	call   802193 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 ba 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 f9 1d 00 00       	call   801f84 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 c0 2a 80 00       	push   $0x802ac0
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 9c 29 80 00       	push   $0x80299c
  8001b1:	e8 76 0d 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8001b6:	e8 78 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8001bb:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001be:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 a2 2a 80 00       	push   $0x802aa2
  8001cd:	6a 34                	push   $0x34
  8001cf:	68 9c 29 80 00       	push   $0x80299c
  8001d4:	e8 53 0d 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001dc:	e8 b2 1f 00 00       	call   802193 <sys_calculate_free_frames>
  8001e1:	29 c3                	sub    %eax,%ebx
  8001e3:	89 d8                	mov    %ebx,%eax
  8001e5:	83 f8 01             	cmp    $0x1,%eax
  8001e8:	74 14                	je     8001fe <_main+0x1c6>
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	68 f0 2a 80 00       	push   $0x802af0
  8001f2:	6a 35                	push   $0x35
  8001f4:	68 9c 29 80 00       	push   $0x80299c
  8001f9:	e8 2e 0d 00 00       	call   800f2c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 90 1f 00 00       	call   802193 <sys_calculate_free_frames>
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 28 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  80020e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800211:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	50                   	push   %eax
  800218:	e8 67 1d 00 00       	call   801f84 <malloc>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800223:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800226:	89 c2                	mov    %eax,%edx
  800228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	05 00 00 00 80       	add    $0x80000000,%eax
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 c0 2a 80 00       	push   $0x802ac0
  80023e:	6a 3b                	push   $0x3b
  800240:	68 9c 29 80 00       	push   $0x80299c
  800245:	e8 e2 0c 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80024a:	e8 e4 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80024f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800252:	3d 00 01 00 00       	cmp    $0x100,%eax
  800257:	74 14                	je     80026d <_main+0x235>
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	68 a2 2a 80 00       	push   $0x802aa2
  800261:	6a 3d                	push   $0x3d
  800263:	68 9c 29 80 00       	push   $0x80299c
  800268:	e8 bf 0c 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80026d:	e8 21 1f 00 00       	call   802193 <sys_calculate_free_frames>
  800272:	89 c2                	mov    %eax,%edx
  800274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800277:	39 c2                	cmp    %eax,%edx
  800279:	74 14                	je     80028f <_main+0x257>
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	68 f0 2a 80 00       	push   $0x802af0
  800283:	6a 3e                	push   $0x3e
  800285:	68 9c 29 80 00       	push   $0x80299c
  80028a:	e8 9d 0c 00 00       	call   800f2c <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80028f:	e8 ff 1e 00 00       	call   802193 <sys_calculate_free_frames>
  800294:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800297:	e8 97 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80029c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80029f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	50                   	push   %eax
  8002a9:	e8 d6 1c 00 00       	call   801f84 <malloc>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002b4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002bc:	89 c2                	mov    %eax,%edx
  8002be:	01 d2                	add    %edx,%edx
  8002c0:	01 d0                	add    %edx,%eax
  8002c2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002c7:	39 c1                	cmp    %eax,%ecx
  8002c9:	74 14                	je     8002df <_main+0x2a7>
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	68 c0 2a 80 00       	push   $0x802ac0
  8002d3:	6a 44                	push   $0x44
  8002d5:	68 9c 29 80 00       	push   $0x80299c
  8002da:	e8 4d 0c 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8002df:	e8 4f 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8002e4:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002e7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 a2 2a 80 00       	push   $0x802aa2
  8002f6:	6a 46                	push   $0x46
  8002f8:	68 9c 29 80 00       	push   $0x80299c
  8002fd:	e8 2a 0c 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800302:	e8 8c 1e 00 00       	call   802193 <sys_calculate_free_frames>
  800307:	89 c2                	mov    %eax,%edx
  800309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030c:	39 c2                	cmp    %eax,%edx
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 f0 2a 80 00       	push   $0x802af0
  800318:	6a 47                	push   $0x47
  80031a:	68 9c 29 80 00       	push   $0x80299c
  80031f:	e8 08 0c 00 00       	call   800f2c <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800324:	e8 6a 1e 00 00       	call   802193 <sys_calculate_free_frames>
  800329:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032c:	e8 02 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800331:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800337:	01 c0                	add    %eax,%eax
  800339:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 3f 1c 00 00       	call   801f84 <malloc>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80034b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80034e:	89 c2                	mov    %eax,%edx
  800350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800353:	c1 e0 02             	shl    $0x2,%eax
  800356:	05 00 00 00 80       	add    $0x80000000,%eax
  80035b:	39 c2                	cmp    %eax,%edx
  80035d:	74 14                	je     800373 <_main+0x33b>
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	68 c0 2a 80 00       	push   $0x802ac0
  800367:	6a 4d                	push   $0x4d
  800369:	68 9c 29 80 00       	push   $0x80299c
  80036e:	e8 b9 0b 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800373:	e8 bb 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800378:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80037b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800380:	74 14                	je     800396 <_main+0x35e>
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 a2 2a 80 00       	push   $0x802aa2
  80038a:	6a 4f                	push   $0x4f
  80038c:	68 9c 29 80 00       	push   $0x80299c
  800391:	e8 96 0b 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800396:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800399:	e8 f5 1d 00 00       	call   802193 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 01             	cmp    $0x1,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 f0 2a 80 00       	push   $0x802af0
  8003af:	6a 50                	push   $0x50
  8003b1:	68 9c 29 80 00       	push   $0x80299c
  8003b6:	e8 71 0b 00 00       	call   800f2c <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003bb:	e8 d3 1d 00 00       	call   802193 <sys_calculate_free_frames>
  8003c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c3:	e8 6b 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8003c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	50                   	push   %eax
  8003d6:	68 03 2b 80 00       	push   $0x802b03
  8003db:	e8 ff 1b 00 00       	call   801fdf <smalloc>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003e6:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	01 c0                	add    %eax,%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	01 c0                	add    %eax,%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 b8 29 80 00       	push   $0x8029b8
  800405:	6a 56                	push   $0x56
  800407:	68 9c 29 80 00       	push   $0x80299c
  80040c:	e8 1b 0b 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800411:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800414:	e8 7a 1d 00 00       	call   802193 <sys_calculate_free_frames>
  800419:	29 c3                	sub    %eax,%ebx
  80041b:	89 d8                	mov    %ebx,%eax
  80041d:	3d 03 02 00 00       	cmp    $0x203,%eax
  800422:	74 14                	je     800438 <_main+0x400>
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 24 2a 80 00       	push   $0x802a24
  80042c:	6a 57                	push   $0x57
  80042e:	68 9c 29 80 00       	push   $0x80299c
  800433:	e8 f4 0a 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800438:	e8 f6 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80043d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800440:	74 14                	je     800456 <_main+0x41e>
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 a2 2a 80 00       	push   $0x802aa2
  80044a:	6a 58                	push   $0x58
  80044c:	68 9c 29 80 00       	push   $0x80299c
  800451:	e8 d6 0a 00 00       	call   800f2c <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800456:	e8 38 1d 00 00       	call   802193 <sys_calculate_free_frames>
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045e:	e8 d0 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800463:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800469:	89 c2                	mov    %eax,%edx
  80046b:	01 d2                	add    %edx,%edx
  80046d:	01 d0                	add    %edx,%eax
  80046f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	50                   	push   %eax
  800476:	e8 09 1b 00 00       	call   801f84 <malloc>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800481:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800484:	89 c2                	mov    %eax,%edx
  800486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	05 00 00 00 80       	add    $0x80000000,%eax
  800491:	39 c2                	cmp    %eax,%edx
  800493:	74 14                	je     8004a9 <_main+0x471>
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	68 c0 2a 80 00       	push   $0x802ac0
  80049d:	6a 5e                	push   $0x5e
  80049f:	68 9c 29 80 00       	push   $0x80299c
  8004a4:	e8 83 0a 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  8004a9:	e8 85 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8004ae:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8004b1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8004b6:	74 14                	je     8004cc <_main+0x494>
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	68 a2 2a 80 00       	push   $0x802aa2
  8004c0:	6a 60                	push   $0x60
  8004c2:	68 9c 29 80 00       	push   $0x80299c
  8004c7:	e8 60 0a 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004cf:	e8 bf 1c 00 00       	call   802193 <sys_calculate_free_frames>
  8004d4:	29 c3                	sub    %eax,%ebx
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	83 f8 01             	cmp    $0x1,%eax
  8004db:	74 14                	je     8004f1 <_main+0x4b9>
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 f0 2a 80 00       	push   $0x802af0
  8004e5:	6a 61                	push   $0x61
  8004e7:	68 9c 29 80 00       	push   $0x80299c
  8004ec:	e8 3b 0a 00 00       	call   800f2c <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004f1:	e8 9d 1c 00 00       	call   802193 <sys_calculate_free_frames>
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f9:	e8 35 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8004fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  800501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800504:	89 c2                	mov    %eax,%edx
  800506:	01 d2                	add    %edx,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	6a 00                	push   $0x0
  80050f:	50                   	push   %eax
  800510:	68 05 2b 80 00       	push   $0x802b05
  800515:	e8 c5 1a 00 00       	call   801fdf <smalloc>
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800520:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800523:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	05 00 00 00 80       	add    $0x80000000,%eax
  800536:	39 c1                	cmp    %eax,%ecx
  800538:	74 14                	je     80054e <_main+0x516>
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 b8 29 80 00       	push   $0x8029b8
  800542:	6a 67                	push   $0x67
  800544:	68 9c 29 80 00       	push   $0x80299c
  800549:	e8 de 09 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80054e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800551:	e8 3d 1c 00 00       	call   802193 <sys_calculate_free_frames>
  800556:	29 c3                	sub    %eax,%ebx
  800558:	89 d8                	mov    %ebx,%eax
  80055a:	3d 04 03 00 00       	cmp    $0x304,%eax
  80055f:	74 14                	je     800575 <_main+0x53d>
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	68 24 2a 80 00       	push   $0x802a24
  800569:	6a 68                	push   $0x68
  80056b:	68 9c 29 80 00       	push   $0x80299c
  800570:	e8 b7 09 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800575:	e8 b9 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80057a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80057d:	74 14                	je     800593 <_main+0x55b>
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	68 a2 2a 80 00       	push   $0x802aa2
  800587:	6a 69                	push   $0x69
  800589:	68 9c 29 80 00       	push   $0x80299c
  80058e:	e8 99 09 00 00       	call   800f2c <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800593:	e8 fb 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80059b:	e8 93 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8005a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005a3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	50                   	push   %eax
  8005aa:	e8 16 1a 00 00       	call   801fc5 <free>
  8005af:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8005b2:	e8 7c 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8005b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ba:	29 c2                	sub    %eax,%edx
  8005bc:	89 d0                	mov    %edx,%eax
  8005be:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005c3:	74 14                	je     8005d9 <_main+0x5a1>
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 07 2b 80 00       	push   $0x802b07
  8005cd:	6a 73                	push   $0x73
  8005cf:	68 9c 29 80 00       	push   $0x80299c
  8005d4:	e8 53 09 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005d9:	e8 b5 1b 00 00       	call   802193 <sys_calculate_free_frames>
  8005de:	89 c2                	mov    %eax,%edx
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	74 14                	je     8005fb <_main+0x5c3>
  8005e7:	83 ec 04             	sub    $0x4,%esp
  8005ea:	68 1e 2b 80 00       	push   $0x802b1e
  8005ef:	6a 74                	push   $0x74
  8005f1:	68 9c 29 80 00       	push   $0x80299c
  8005f6:	e8 31 09 00 00       	call   800f2c <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005fb:	e8 93 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800600:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800603:	e8 2b 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80060b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80060e:	83 ec 0c             	sub    $0xc,%esp
  800611:	50                   	push   %eax
  800612:	e8 ae 19 00 00       	call   801fc5 <free>
  800617:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  80061a:	e8 14 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80061f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800622:	29 c2                	sub    %eax,%edx
  800624:	89 d0                	mov    %edx,%eax
  800626:	3d 00 02 00 00       	cmp    $0x200,%eax
  80062b:	74 14                	je     800641 <_main+0x609>
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 07 2b 80 00       	push   $0x802b07
  800635:	6a 7b                	push   $0x7b
  800637:	68 9c 29 80 00       	push   $0x80299c
  80063c:	e8 eb 08 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800641:	e8 4d 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800646:	89 c2                	mov    %eax,%edx
  800648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	74 14                	je     800663 <_main+0x62b>
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	68 1e 2b 80 00       	push   $0x802b1e
  800657:	6a 7c                	push   $0x7c
  800659:	68 9c 29 80 00       	push   $0x80299c
  80065e:	e8 c9 08 00 00       	call   800f2c <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800663:	e8 2b 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80066b:	e8 c3 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800670:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  800673:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	50                   	push   %eax
  80067a:	e8 46 19 00 00       	call   801fc5 <free>
  80067f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800682:	e8 ac 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800687:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068a:	29 c2                	sub    %eax,%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800693:	74 17                	je     8006ac <_main+0x674>
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 07 2b 80 00       	push   $0x802b07
  80069d:	68 83 00 00 00       	push   $0x83
  8006a2:	68 9c 29 80 00       	push   $0x80299c
  8006a7:	e8 80 08 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006ac:	e8 e2 1a 00 00       	call   802193 <sys_calculate_free_frames>
  8006b1:	89 c2                	mov    %eax,%edx
  8006b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	74 17                	je     8006d1 <_main+0x699>
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	68 1e 2b 80 00       	push   $0x802b1e
  8006c2:	68 84 00 00 00       	push   $0x84
  8006c7:	68 9c 29 80 00       	push   $0x80299c
  8006cc:	e8 5b 08 00 00       	call   800f2c <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006d1:	e8 bd 1a 00 00       	call   802193 <sys_calculate_free_frames>
  8006d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d9:	e8 55 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8006de:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	c1 e0 09             	shl    $0x9,%eax
  8006e9:	29 d0                	sub    %edx,%eax
  8006eb:	83 ec 0c             	sub    $0xc,%esp
  8006ee:	50                   	push   %eax
  8006ef:	e8 90 18 00 00       	call   801f84 <malloc>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006fd:	89 c2                	mov    %eax,%edx
  8006ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800702:	05 00 00 00 80       	add    $0x80000000,%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	74 17                	je     800722 <_main+0x6ea>
  80070b:	83 ec 04             	sub    $0x4,%esp
  80070e:	68 c0 2a 80 00       	push   $0x802ac0
  800713:	68 8d 00 00 00       	push   $0x8d
  800718:	68 9c 29 80 00       	push   $0x80299c
  80071d:	e8 0a 08 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800722:	e8 0c 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800727:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80072a:	3d 80 00 00 00       	cmp    $0x80,%eax
  80072f:	74 17                	je     800748 <_main+0x710>
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	68 a2 2a 80 00       	push   $0x802aa2
  800739:	68 8f 00 00 00       	push   $0x8f
  80073e:	68 9c 29 80 00       	push   $0x80299c
  800743:	e8 e4 07 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800748:	e8 46 1a 00 00       	call   802193 <sys_calculate_free_frames>
  80074d:	89 c2                	mov    %eax,%edx
  80074f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 17                	je     80076d <_main+0x735>
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 f0 2a 80 00       	push   $0x802af0
  80075e:	68 90 00 00 00       	push   $0x90
  800763:	68 9c 29 80 00       	push   $0x80299c
  800768:	e8 bf 07 00 00       	call   800f2c <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80076d:	e8 21 1a 00 00       	call   802193 <sys_calculate_free_frames>
  800772:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800775:	e8 b9 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80077a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80077d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800780:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800783:	83 ec 0c             	sub    $0xc,%esp
  800786:	50                   	push   %eax
  800787:	e8 f8 17 00 00       	call   801f84 <malloc>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800792:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800795:	89 c2                	mov    %eax,%edx
  800797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80079a:	c1 e0 02             	shl    $0x2,%eax
  80079d:	05 00 00 00 80       	add    $0x80000000,%eax
  8007a2:	39 c2                	cmp    %eax,%edx
  8007a4:	74 17                	je     8007bd <_main+0x785>
  8007a6:	83 ec 04             	sub    $0x4,%esp
  8007a9:	68 c0 2a 80 00       	push   $0x802ac0
  8007ae:	68 96 00 00 00       	push   $0x96
  8007b3:	68 9c 29 80 00       	push   $0x80299c
  8007b8:	e8 6f 07 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007bd:	e8 71 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8007c2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8007c5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007ca:	74 17                	je     8007e3 <_main+0x7ab>
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	68 a2 2a 80 00       	push   $0x802aa2
  8007d4:	68 98 00 00 00       	push   $0x98
  8007d9:	68 9c 29 80 00       	push   $0x80299c
  8007de:	e8 49 07 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007e3:	e8 ab 19 00 00       	call   802193 <sys_calculate_free_frames>
  8007e8:	89 c2                	mov    %eax,%edx
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	39 c2                	cmp    %eax,%edx
  8007ef:	74 17                	je     800808 <_main+0x7d0>
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	68 f0 2a 80 00       	push   $0x802af0
  8007f9:	68 99 00 00 00       	push   $0x99
  8007fe:	68 9c 29 80 00       	push   $0x80299c
  800803:	e8 24 07 00 00       	call   800f2c <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800808:	e8 86 19 00 00       	call   802193 <sys_calculate_free_frames>
  80080d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800810:	e8 1e 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800815:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800818:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80081b:	89 d0                	mov    %edx,%eax
  80081d:	c1 e0 08             	shl    $0x8,%eax
  800820:	29 d0                	sub    %edx,%eax
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	50                   	push   %eax
  800826:	e8 59 17 00 00       	call   801f84 <malloc>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800831:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800834:	89 c2                	mov    %eax,%edx
  800836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800839:	c1 e0 09             	shl    $0x9,%eax
  80083c:	89 c1                	mov    %eax,%ecx
  80083e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800841:	01 c8                	add    %ecx,%eax
  800843:	05 00 00 00 80       	add    $0x80000000,%eax
  800848:	39 c2                	cmp    %eax,%edx
  80084a:	74 17                	je     800863 <_main+0x82b>
  80084c:	83 ec 04             	sub    $0x4,%esp
  80084f:	68 c0 2a 80 00       	push   $0x802ac0
  800854:	68 9f 00 00 00       	push   $0x9f
  800859:	68 9c 29 80 00       	push   $0x80299c
  80085e:	e8 c9 06 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800863:	e8 cb 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800868:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80086b:	83 f8 40             	cmp    $0x40,%eax
  80086e:	74 17                	je     800887 <_main+0x84f>
  800870:	83 ec 04             	sub    $0x4,%esp
  800873:	68 a2 2a 80 00       	push   $0x802aa2
  800878:	68 a1 00 00 00       	push   $0xa1
  80087d:	68 9c 29 80 00       	push   $0x80299c
  800882:	e8 a5 06 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800887:	e8 07 19 00 00       	call   802193 <sys_calculate_free_frames>
  80088c:	89 c2                	mov    %eax,%edx
  80088e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	74 17                	je     8008ac <_main+0x874>
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	68 f0 2a 80 00       	push   $0x802af0
  80089d:	68 a2 00 00 00       	push   $0xa2
  8008a2:	68 9c 29 80 00       	push   $0x80299c
  8008a7:	e8 80 06 00 00       	call   800f2c <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8008ac:	e8 e2 18 00 00       	call   802193 <sys_calculate_free_frames>
  8008b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008b4:	e8 7a 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8008b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8008bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	50                   	push   %eax
  8008c5:	e8 ba 16 00 00       	call   801f84 <malloc>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8008d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8008d3:	89 c2                	mov    %eax,%edx
  8008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008d8:	c1 e0 03             	shl    $0x3,%eax
  8008db:	05 00 00 00 80       	add    $0x80000000,%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	74 17                	je     8008fb <_main+0x8c3>
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	68 c0 2a 80 00       	push   $0x802ac0
  8008ec:	68 a8 00 00 00       	push   $0xa8
  8008f1:	68 9c 29 80 00       	push   $0x80299c
  8008f6:	e8 31 06 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8008fb:	e8 33 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800900:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800903:	3d 00 02 00 00       	cmp    $0x200,%eax
  800908:	74 17                	je     800921 <_main+0x8e9>
  80090a:	83 ec 04             	sub    $0x4,%esp
  80090d:	68 a2 2a 80 00       	push   $0x802aa2
  800912:	68 aa 00 00 00       	push   $0xaa
  800917:	68 9c 29 80 00       	push   $0x80299c
  80091c:	e8 0b 06 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800921:	e8 6d 18 00 00       	call   802193 <sys_calculate_free_frames>
  800926:	89 c2                	mov    %eax,%edx
  800928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	74 17                	je     800946 <_main+0x90e>
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	68 f0 2a 80 00       	push   $0x802af0
  800937:	68 ab 00 00 00       	push   $0xab
  80093c:	68 9c 29 80 00       	push   $0x80299c
  800941:	e8 e6 05 00 00       	call   800f2c <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800946:	e8 48 18 00 00       	call   802193 <sys_calculate_free_frames>
  80094b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094e:	e8 e0 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800953:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800959:	c1 e0 02             	shl    $0x2,%eax
  80095c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80095f:	83 ec 0c             	sub    $0xc,%esp
  800962:	50                   	push   %eax
  800963:	e8 1c 16 00 00       	call   801f84 <malloc>
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80096e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800971:	89 c1                	mov    %eax,%ecx
  800973:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800976:	89 d0                	mov    %edx,%eax
  800978:	01 c0                	add    %eax,%eax
  80097a:	01 d0                	add    %edx,%eax
  80097c:	01 c0                	add    %eax,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	05 00 00 00 80       	add    $0x80000000,%eax
  800987:	39 c1                	cmp    %eax,%ecx
  800989:	74 17                	je     8009a2 <_main+0x96a>
  80098b:	83 ec 04             	sub    $0x4,%esp
  80098e:	68 c0 2a 80 00       	push   $0x802ac0
  800993:	68 b1 00 00 00       	push   $0xb1
  800998:	68 9c 29 80 00       	push   $0x80299c
  80099d:	e8 8a 05 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  8009a2:	e8 8c 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8009a7:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8009aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8009af:	74 17                	je     8009c8 <_main+0x990>
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	68 a2 2a 80 00       	push   $0x802aa2
  8009b9:	68 b3 00 00 00       	push   $0xb3
  8009be:	68 9c 29 80 00       	push   $0x80299c
  8009c3:	e8 64 05 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: ");
  8009c8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8009cb:	e8 c3 17 00 00       	call   802193 <sys_calculate_free_frames>
  8009d0:	29 c3                	sub    %eax,%ebx
  8009d2:	89 d8                	mov    %ebx,%eax
  8009d4:	83 f8 02             	cmp    $0x2,%eax
  8009d7:	74 17                	je     8009f0 <_main+0x9b8>
  8009d9:	83 ec 04             	sub    $0x4,%esp
  8009dc:	68 f0 2a 80 00       	push   $0x802af0
  8009e1:	68 b4 00 00 00       	push   $0xb4
  8009e6:	68 9c 29 80 00       	push   $0x80299c
  8009eb:	e8 3c 05 00 00       	call   800f2c <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009f0:	e8 9e 17 00 00       	call   802193 <sys_calculate_free_frames>
  8009f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009f8:	e8 36 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8009fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  800a00:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800a03:	83 ec 0c             	sub    $0xc,%esp
  800a06:	50                   	push   %eax
  800a07:	e8 b9 15 00 00       	call   801fc5 <free>
  800a0c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a0f:	e8 1f 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a17:	29 c2                	sub    %eax,%edx
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a20:	74 17                	je     800a39 <_main+0xa01>
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	68 07 2b 80 00       	push   $0x802b07
  800a2a:	68 be 00 00 00       	push   $0xbe
  800a2f:	68 9c 29 80 00       	push   $0x80299c
  800a34:	e8 f3 04 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a39:	e8 55 17 00 00       	call   802193 <sys_calculate_free_frames>
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a43:	39 c2                	cmp    %eax,%edx
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 1e 2b 80 00       	push   $0x802b1e
  800a4f:	68 bf 00 00 00       	push   $0xbf
  800a54:	68 9c 29 80 00       	push   $0x80299c
  800a59:	e8 ce 04 00 00       	call   800f2c <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a5e:	e8 30 17 00 00       	call   802193 <sys_calculate_free_frames>
  800a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a66:	e8 c8 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a71:	83 ec 0c             	sub    $0xc,%esp
  800a74:	50                   	push   %eax
  800a75:	e8 4b 15 00 00       	call   801fc5 <free>
  800a7a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a7d:	e8 b1 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a85:	29 c2                	sub    %eax,%edx
  800a87:	89 d0                	mov    %edx,%eax
  800a89:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a8e:	74 17                	je     800aa7 <_main+0xa6f>
  800a90:	83 ec 04             	sub    $0x4,%esp
  800a93:	68 07 2b 80 00       	push   $0x802b07
  800a98:	68 c6 00 00 00       	push   $0xc6
  800a9d:	68 9c 29 80 00       	push   $0x80299c
  800aa2:	e8 85 04 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800aa7:	e8 e7 16 00 00       	call   802193 <sys_calculate_free_frames>
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	74 17                	je     800acc <_main+0xa94>
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	68 1e 2b 80 00       	push   $0x802b1e
  800abd:	68 c7 00 00 00       	push   $0xc7
  800ac2:	68 9c 29 80 00       	push   $0x80299c
  800ac7:	e8 60 04 00 00       	call   800f2c <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800acc:	e8 c2 16 00 00       	call   802193 <sys_calculate_free_frames>
  800ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ad4:	e8 5a 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800ad9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800adc:	8b 45 98             	mov    -0x68(%ebp),%eax
  800adf:	83 ec 0c             	sub    $0xc,%esp
  800ae2:	50                   	push   %eax
  800ae3:	e8 dd 14 00 00       	call   801fc5 <free>
  800ae8:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800aeb:	e8 43 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	3d 00 01 00 00       	cmp    $0x100,%eax
  800afc:	74 17                	je     800b15 <_main+0xadd>
  800afe:	83 ec 04             	sub    $0x4,%esp
  800b01:	68 07 2b 80 00       	push   $0x802b07
  800b06:	68 ce 00 00 00       	push   $0xce
  800b0b:	68 9c 29 80 00       	push   $0x80299c
  800b10:	e8 17 04 00 00       	call   800f2c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b15:	e8 79 16 00 00       	call   802193 <sys_calculate_free_frames>
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1f:	39 c2                	cmp    %eax,%edx
  800b21:	74 17                	je     800b3a <_main+0xb02>
  800b23:	83 ec 04             	sub    $0x4,%esp
  800b26:	68 1e 2b 80 00       	push   $0x802b1e
  800b2b:	68 cf 00 00 00       	push   $0xcf
  800b30:	68 9c 29 80 00       	push   $0x80299c
  800b35:	e8 f2 03 00 00       	call   800f2c <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800b3a:	e8 54 16 00 00       	call   802193 <sys_calculate_free_frames>
  800b3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b42:	e8 ec 16 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800b47:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800b4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b4d:	c1 e0 08             	shl    $0x8,%eax
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b55:	01 d0                	add    %edx,%eax
  800b57:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b5a:	83 ec 0c             	sub    $0xc,%esp
  800b5d:	50                   	push   %eax
  800b5e:	e8 21 14 00 00       	call   801f84 <malloc>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b69:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b6c:	89 c1                	mov    %eax,%ecx
  800b6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b71:	89 d0                	mov    %edx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	c1 e0 08             	shl    $0x8,%eax
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	05 00 00 00 80       	add    $0x80000000,%eax
  800b86:	39 c1                	cmp    %eax,%ecx
  800b88:	74 17                	je     800ba1 <_main+0xb69>
  800b8a:	83 ec 04             	sub    $0x4,%esp
  800b8d:	68 c0 2a 80 00       	push   $0x802ac0
  800b92:	68 d9 00 00 00       	push   $0xd9
  800b97:	68 9c 29 80 00       	push   $0x80299c
  800b9c:	e8 8b 03 00 00       	call   800f2c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256+64) panic("Wrong page file allocation: ");
  800ba1:	e8 8d 16 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800ba6:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800ba9:	3d 40 01 00 00       	cmp    $0x140,%eax
  800bae:	74 17                	je     800bc7 <_main+0xb8f>
  800bb0:	83 ec 04             	sub    $0x4,%esp
  800bb3:	68 a2 2a 80 00       	push   $0x802aa2
  800bb8:	68 db 00 00 00       	push   $0xdb
  800bbd:	68 9c 29 80 00       	push   $0x80299c
  800bc2:	e8 65 03 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800bc7:	e8 c7 15 00 00       	call   802193 <sys_calculate_free_frames>
  800bcc:	89 c2                	mov    %eax,%edx
  800bce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	74 17                	je     800bec <_main+0xbb4>
  800bd5:	83 ec 04             	sub    $0x4,%esp
  800bd8:	68 f0 2a 80 00       	push   $0x802af0
  800bdd:	68 dc 00 00 00       	push   $0xdc
  800be2:	68 9c 29 80 00       	push   $0x80299c
  800be7:	e8 40 03 00 00       	call   800f2c <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800bec:	e8 a2 15 00 00       	call   802193 <sys_calculate_free_frames>
  800bf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bf4:	e8 3a 16 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800bf9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bff:	c1 e0 02             	shl    $0x2,%eax
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	6a 00                	push   $0x0
  800c07:	50                   	push   %eax
  800c08:	68 2b 2b 80 00       	push   $0x802b2b
  800c0d:	e8 cd 13 00 00       	call   801fdf <smalloc>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800c1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	c1 e0 03             	shl    $0x3,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	05 00 00 00 80       	add    $0x80000000,%eax
  800c2c:	39 c1                	cmp    %eax,%ecx
  800c2e:	74 17                	je     800c47 <_main+0xc0f>
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	68 b8 29 80 00       	push   $0x8029b8
  800c38:	68 e2 00 00 00       	push   $0xe2
  800c3d:	68 9c 29 80 00       	push   $0x80299c
  800c42:	e8 e5 02 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c47:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800c4a:	e8 44 15 00 00       	call   802193 <sys_calculate_free_frames>
  800c4f:	29 c3                	sub    %eax,%ebx
  800c51:	89 d8                	mov    %ebx,%eax
  800c53:	3d 04 04 00 00       	cmp    $0x404,%eax
  800c58:	74 17                	je     800c71 <_main+0xc39>
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	68 24 2a 80 00       	push   $0x802a24
  800c62:	68 e3 00 00 00       	push   $0xe3
  800c67:	68 9c 29 80 00       	push   $0x80299c
  800c6c:	e8 bb 02 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c71:	e8 bd 15 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800c76:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c79:	74 17                	je     800c92 <_main+0xc5a>
  800c7b:	83 ec 04             	sub    $0x4,%esp
  800c7e:	68 a2 2a 80 00       	push   $0x802aa2
  800c83:	68 e4 00 00 00       	push   $0xe4
  800c88:	68 9c 29 80 00       	push   $0x80299c
  800c8d:	e8 9a 02 00 00       	call   800f2c <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c92:	e8 fc 14 00 00       	call   802193 <sys_calculate_free_frames>
  800c97:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c9a:	e8 94 15 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800c9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	68 05 2b 80 00       	push   $0x802b05
  800caa:	ff 75 ec             	pushl  -0x14(%ebp)
  800cad:	e8 4d 13 00 00       	call   801fff <sget>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cb8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cbe:	89 c1                	mov    %eax,%ecx
  800cc0:	01 c9                	add    %ecx,%ecx
  800cc2:	01 c8                	add    %ecx,%eax
  800cc4:	05 00 00 00 80       	add    $0x80000000,%eax
  800cc9:	39 c2                	cmp    %eax,%edx
  800ccb:	74 17                	je     800ce4 <_main+0xcac>
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	68 b8 29 80 00       	push   $0x8029b8
  800cd5:	68 ea 00 00 00       	push   $0xea
  800cda:	68 9c 29 80 00       	push   $0x80299c
  800cdf:	e8 48 02 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800ce4:	e8 aa 14 00 00       	call   802193 <sys_calculate_free_frames>
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cee:	39 c2                	cmp    %eax,%edx
  800cf0:	74 17                	je     800d09 <_main+0xcd1>
  800cf2:	83 ec 04             	sub    $0x4,%esp
  800cf5:	68 24 2a 80 00       	push   $0x802a24
  800cfa:	68 eb 00 00 00       	push   $0xeb
  800cff:	68 9c 29 80 00       	push   $0x80299c
  800d04:	e8 23 02 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d09:	e8 25 15 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800d0e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 a2 2a 80 00       	push   $0x802aa2
  800d1b:	68 ec 00 00 00       	push   $0xec
  800d20:	68 9c 29 80 00       	push   $0x80299c
  800d25:	e8 02 02 00 00       	call   800f2c <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800d2a:	e8 64 14 00 00       	call   802193 <sys_calculate_free_frames>
  800d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d32:	e8 fc 14 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800d37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	68 b3 29 80 00       	push   $0x8029b3
  800d42:	ff 75 ec             	pushl  -0x14(%ebp)
  800d45:	e8 b5 12 00 00       	call   801fff <sget>
  800d4a:	83 c4 10             	add    $0x10,%esp
  800d4d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800d50:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800d53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d56:	89 d0                	mov    %edx,%eax
  800d58:	c1 e0 02             	shl    $0x2,%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	01 c0                	add    %eax,%eax
  800d5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800d64:	39 c1                	cmp    %eax,%ecx
  800d66:	74 17                	je     800d7f <_main+0xd47>
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	68 b8 29 80 00       	push   $0x8029b8
  800d70:	68 f2 00 00 00       	push   $0xf2
  800d75:	68 9c 29 80 00       	push   $0x80299c
  800d7a:	e8 ad 01 00 00       	call   800f2c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d7f:	e8 0f 14 00 00       	call   802193 <sys_calculate_free_frames>
  800d84:	89 c2                	mov    %eax,%edx
  800d86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d89:	39 c2                	cmp    %eax,%edx
  800d8b:	74 17                	je     800da4 <_main+0xd6c>
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	68 24 2a 80 00       	push   $0x802a24
  800d95:	68 f3 00 00 00       	push   $0xf3
  800d9a:	68 9c 29 80 00       	push   $0x80299c
  800d9f:	e8 88 01 00 00       	call   800f2c <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800da4:	e8 8a 14 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800da9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 a2 2a 80 00       	push   $0x802aa2
  800db6:	68 f4 00 00 00       	push   $0xf4
  800dbb:	68 9c 29 80 00       	push   $0x80299c
  800dc0:	e8 67 01 00 00       	call   800f2c <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	68 30 2b 80 00       	push   $0x802b30
  800dcd:	e8 0e 04 00 00       	call   8011e0 <cprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp

	return;
  800dd5:	90                   	nop
}
  800dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800de3:	e8 8b 16 00 00       	call   802473 <sys_getenvindex>
  800de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dee:	89 d0                	mov    %edx,%eax
  800df0:	01 c0                	add    %eax,%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800dfb:	01 c8                	add    %ecx,%eax
  800dfd:	c1 e0 02             	shl    $0x2,%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800e09:	01 c8                	add    %ecx,%eax
  800e0b:	c1 e0 02             	shl    $0x2,%eax
  800e0e:	01 d0                	add    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	c1 e0 03             	shl    $0x3,%eax
  800e18:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e1d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e22:	a1 20 40 80 00       	mov    0x804020,%eax
  800e27:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	74 0f                	je     800e40 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800e31:	a1 20 40 80 00       	mov    0x804020,%eax
  800e36:	05 18 da 01 00       	add    $0x1da18,%eax
  800e3b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e44:	7e 0a                	jle    800e50 <libmain+0x73>
		binaryname = argv[0];
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 0c             	pushl  0xc(%ebp)
  800e56:	ff 75 08             	pushl  0x8(%ebp)
  800e59:	e8 da f1 ff ff       	call   800038 <_main>
  800e5e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e61:	e8 1a 14 00 00       	call   802280 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	68 94 2b 80 00       	push   $0x802b94
  800e6e:	e8 6d 03 00 00       	call   8011e0 <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e76:	a1 20 40 80 00       	mov    0x804020,%eax
  800e7b:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800e81:	a1 20 40 80 00       	mov    0x804020,%eax
  800e86:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800e8c:	83 ec 04             	sub    $0x4,%esp
  800e8f:	52                   	push   %edx
  800e90:	50                   	push   %eax
  800e91:	68 bc 2b 80 00       	push   $0x802bbc
  800e96:	e8 45 03 00 00       	call   8011e0 <cprintf>
  800e9b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e9e:	a1 20 40 80 00       	mov    0x804020,%eax
  800ea3:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800ea9:	a1 20 40 80 00       	mov    0x804020,%eax
  800eae:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800eb4:	a1 20 40 80 00       	mov    0x804020,%eax
  800eb9:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800ebf:	51                   	push   %ecx
  800ec0:	52                   	push   %edx
  800ec1:	50                   	push   %eax
  800ec2:	68 e4 2b 80 00       	push   $0x802be4
  800ec7:	e8 14 03 00 00       	call   8011e0 <cprintf>
  800ecc:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ecf:	a1 20 40 80 00       	mov    0x804020,%eax
  800ed4:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	50                   	push   %eax
  800ede:	68 3c 2c 80 00       	push   $0x802c3c
  800ee3:	e8 f8 02 00 00       	call   8011e0 <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	68 94 2b 80 00       	push   $0x802b94
  800ef3:	e8 e8 02 00 00       	call   8011e0 <cprintf>
  800ef8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800efb:	e8 9a 13 00 00       	call   80229a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f00:	e8 19 00 00 00       	call   800f1e <exit>
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	6a 00                	push   $0x0
  800f13:	e8 27 15 00 00       	call   80243f <sys_destroy_env>
  800f18:	83 c4 10             	add    $0x10,%esp
}
  800f1b:	90                   	nop
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <exit>:

void
exit(void)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f24:	e8 7c 15 00 00       	call   8024a5 <sys_exit_env>
}
  800f29:	90                   	nop
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f32:	8d 45 10             	lea    0x10(%ebp),%eax
  800f35:	83 c0 04             	add    $0x4,%eax
  800f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f3b:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800f40:	85 c0                	test   %eax,%eax
  800f42:	74 16                	je     800f5a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f44:	a1 58 b2 82 00       	mov    0x82b258,%eax
  800f49:	83 ec 08             	sub    $0x8,%esp
  800f4c:	50                   	push   %eax
  800f4d:	68 50 2c 80 00       	push   $0x802c50
  800f52:	e8 89 02 00 00       	call   8011e0 <cprintf>
  800f57:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f5a:	a1 00 40 80 00       	mov    0x804000,%eax
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	50                   	push   %eax
  800f66:	68 55 2c 80 00       	push   $0x802c55
  800f6b:	e8 70 02 00 00       	call   8011e0 <cprintf>
  800f70:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7c:	50                   	push   %eax
  800f7d:	e8 f3 01 00 00       	call   801175 <vcprintf>
  800f82:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	6a 00                	push   $0x0
  800f8a:	68 71 2c 80 00       	push   $0x802c71
  800f8f:	e8 e1 01 00 00       	call   801175 <vcprintf>
  800f94:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f97:	e8 82 ff ff ff       	call   800f1e <exit>

	// should not return here
	while (1) ;
  800f9c:	eb fe                	jmp    800f9c <_panic+0x70>

00800f9e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fa4:	a1 20 40 80 00       	mov    0x804020,%eax
  800fa9:	8b 50 74             	mov    0x74(%eax),%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	39 c2                	cmp    %eax,%edx
  800fb1:	74 14                	je     800fc7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	68 74 2c 80 00       	push   $0x802c74
  800fbb:	6a 26                	push   $0x26
  800fbd:	68 c0 2c 80 00       	push   $0x802cc0
  800fc2:	e8 65 ff ff ff       	call   800f2c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800fc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800fce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fd5:	e9 c2 00 00 00       	jmp    80109c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fdd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	8b 00                	mov    (%eax),%eax
  800feb:	85 c0                	test   %eax,%eax
  800fed:	75 08                	jne    800ff7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800fef:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800ff2:	e9 a2 00 00 00       	jmp    801099 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ff7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ffe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801005:	eb 69                	jmp    801070 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801007:	a1 20 40 80 00       	mov    0x804020,%eax
  80100c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801012:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801015:	89 d0                	mov    %edx,%eax
  801017:	01 c0                	add    %eax,%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c1 e0 03             	shl    $0x3,%eax
  80101e:	01 c8                	add    %ecx,%eax
  801020:	8a 40 04             	mov    0x4(%eax),%al
  801023:	84 c0                	test   %al,%al
  801025:	75 46                	jne    80106d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801027:	a1 20 40 80 00       	mov    0x804020,%eax
  80102c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801032:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801035:	89 d0                	mov    %edx,%eax
  801037:	01 c0                	add    %eax,%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	c1 e0 03             	shl    $0x3,%eax
  80103e:	01 c8                	add    %ecx,%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801048:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801052:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	01 c8                	add    %ecx,%eax
  80105e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801060:	39 c2                	cmp    %eax,%edx
  801062:	75 09                	jne    80106d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801064:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80106b:	eb 12                	jmp    80107f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80106d:	ff 45 e8             	incl   -0x18(%ebp)
  801070:	a1 20 40 80 00       	mov    0x804020,%eax
  801075:	8b 50 74             	mov    0x74(%eax),%edx
  801078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	77 88                	ja     801007 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80107f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801083:	75 14                	jne    801099 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	68 cc 2c 80 00       	push   $0x802ccc
  80108d:	6a 3a                	push   $0x3a
  80108f:	68 c0 2c 80 00       	push   $0x802cc0
  801094:	e8 93 fe ff ff       	call   800f2c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801099:	ff 45 f0             	incl   -0x10(%ebp)
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010a2:	0f 8c 32 ff ff ff    	jl     800fda <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010b6:	eb 26                	jmp    8010de <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8010bd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8010c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8010c6:	89 d0                	mov    %edx,%eax
  8010c8:	01 c0                	add    %eax,%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	c1 e0 03             	shl    $0x3,%eax
  8010cf:	01 c8                	add    %ecx,%eax
  8010d1:	8a 40 04             	mov    0x4(%eax),%al
  8010d4:	3c 01                	cmp    $0x1,%al
  8010d6:	75 03                	jne    8010db <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8010d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010db:	ff 45 e0             	incl   -0x20(%ebp)
  8010de:	a1 20 40 80 00       	mov    0x804020,%eax
  8010e3:	8b 50 74             	mov    0x74(%eax),%edx
  8010e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010e9:	39 c2                	cmp    %eax,%edx
  8010eb:	77 cb                	ja     8010b8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8010ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8010f3:	74 14                	je     801109 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	68 20 2d 80 00       	push   $0x802d20
  8010fd:	6a 44                	push   $0x44
  8010ff:	68 c0 2c 80 00       	push   $0x802cc0
  801104:	e8 23 fe ff ff       	call   800f2c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801109:	90                   	nop
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	8b 00                	mov    (%eax),%eax
  801117:	8d 48 01             	lea    0x1(%eax),%ecx
  80111a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111d:	89 0a                	mov    %ecx,(%edx)
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	88 d1                	mov    %dl,%cl
  801124:	8b 55 0c             	mov    0xc(%ebp),%edx
  801127:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	3d ff 00 00 00       	cmp    $0xff,%eax
  801135:	75 2c                	jne    801163 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801137:	a0 24 40 80 00       	mov    0x804024,%al
  80113c:	0f b6 c0             	movzbl %al,%eax
  80113f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801142:	8b 12                	mov    (%edx),%edx
  801144:	89 d1                	mov    %edx,%ecx
  801146:	8b 55 0c             	mov    0xc(%ebp),%edx
  801149:	83 c2 08             	add    $0x8,%edx
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	50                   	push   %eax
  801150:	51                   	push   %ecx
  801151:	52                   	push   %edx
  801152:	e8 7b 0f 00 00       	call   8020d2 <sys_cputs>
  801157:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80115a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	8b 40 04             	mov    0x4(%eax),%eax
  801169:	8d 50 01             	lea    0x1(%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	89 50 04             	mov    %edx,0x4(%eax)
}
  801172:	90                   	nop
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80117e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801185:	00 00 00 
	b.cnt = 0;
  801188:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80118f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801192:	ff 75 0c             	pushl  0xc(%ebp)
  801195:	ff 75 08             	pushl  0x8(%ebp)
  801198:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80119e:	50                   	push   %eax
  80119f:	68 0c 11 80 00       	push   $0x80110c
  8011a4:	e8 11 02 00 00       	call   8013ba <vprintfmt>
  8011a9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011ac:	a0 24 40 80 00       	mov    0x804024,%al
  8011b1:	0f b6 c0             	movzbl %al,%eax
  8011b4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	50                   	push   %eax
  8011be:	52                   	push   %edx
  8011bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011c5:	83 c0 08             	add    $0x8,%eax
  8011c8:	50                   	push   %eax
  8011c9:	e8 04 0f 00 00       	call   8020d2 <sys_cputs>
  8011ce:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8011d1:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8011d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8011e6:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8011ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fc:	50                   	push   %eax
  8011fd:	e8 73 ff ff ff       	call   801175 <vcprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801213:	e8 68 10 00 00       	call   802280 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801218:	8d 45 0c             	lea    0xc(%ebp),%eax
  80121b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 f4             	pushl  -0xc(%ebp)
  801227:	50                   	push   %eax
  801228:	e8 48 ff ff ff       	call   801175 <vcprintf>
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801233:	e8 62 10 00 00       	call   80229a <sys_enable_interrupt>
	return cnt;
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	53                   	push   %ebx
  801241:	83 ec 14             	sub    $0x14,%esp
  801244:	8b 45 10             	mov    0x10(%ebp),%eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80124a:	8b 45 14             	mov    0x14(%ebp),%eax
  80124d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801250:	8b 45 18             	mov    0x18(%ebp),%eax
  801253:	ba 00 00 00 00       	mov    $0x0,%edx
  801258:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80125b:	77 55                	ja     8012b2 <printnum+0x75>
  80125d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801260:	72 05                	jb     801267 <printnum+0x2a>
  801262:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801265:	77 4b                	ja     8012b2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801267:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80126a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80126d:	8b 45 18             	mov    0x18(%ebp),%eax
  801270:	ba 00 00 00 00       	mov    $0x0,%edx
  801275:	52                   	push   %edx
  801276:	50                   	push   %eax
  801277:	ff 75 f4             	pushl  -0xc(%ebp)
  80127a:	ff 75 f0             	pushl  -0x10(%ebp)
  80127d:	e8 86 14 00 00       	call   802708 <__udivdi3>
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	ff 75 20             	pushl  0x20(%ebp)
  80128b:	53                   	push   %ebx
  80128c:	ff 75 18             	pushl  0x18(%ebp)
  80128f:	52                   	push   %edx
  801290:	50                   	push   %eax
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	ff 75 08             	pushl  0x8(%ebp)
  801297:	e8 a1 ff ff ff       	call   80123d <printnum>
  80129c:	83 c4 20             	add    $0x20,%esp
  80129f:	eb 1a                	jmp    8012bb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	ff 75 20             	pushl  0x20(%ebp)
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	ff d0                	call   *%eax
  8012af:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012b2:	ff 4d 1c             	decl   0x1c(%ebp)
  8012b5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012b9:	7f e6                	jg     8012a1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012bb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c9:	53                   	push   %ebx
  8012ca:	51                   	push   %ecx
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	e8 46 15 00 00       	call   802818 <__umoddi3>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	05 94 2f 80 00       	add    $0x802f94,%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f be c0             	movsbl %al,%eax
  8012df:	83 ec 08             	sub    $0x8,%esp
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
}
  8012ee:	90                   	nop
  8012ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012fb:	7e 1c                	jle    801319 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8b 00                	mov    (%eax),%eax
  801302:	8d 50 08             	lea    0x8(%eax),%edx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	89 10                	mov    %edx,(%eax)
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8b 00                	mov    (%eax),%eax
  80130f:	83 e8 08             	sub    $0x8,%eax
  801312:	8b 50 04             	mov    0x4(%eax),%edx
  801315:	8b 00                	mov    (%eax),%eax
  801317:	eb 40                	jmp    801359 <getuint+0x65>
	else if (lflag)
  801319:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131d:	74 1e                	je     80133d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8b 00                	mov    (%eax),%eax
  801324:	8d 50 04             	lea    0x4(%eax),%edx
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	89 10                	mov    %edx,(%eax)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	83 e8 04             	sub    $0x4,%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	ba 00 00 00 00       	mov    $0x0,%edx
  80133b:	eb 1c                	jmp    801359 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 50 04             	lea    0x4(%eax),%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 10                	mov    %edx,(%eax)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8b 00                	mov    (%eax),%eax
  80134f:	83 e8 04             	sub    $0x4,%eax
  801352:	8b 00                	mov    (%eax),%eax
  801354:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80135e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801362:	7e 1c                	jle    801380 <getint+0x25>
		return va_arg(*ap, long long);
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	8d 50 08             	lea    0x8(%eax),%edx
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	89 10                	mov    %edx,(%eax)
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8b 00                	mov    (%eax),%eax
  801376:	83 e8 08             	sub    $0x8,%eax
  801379:	8b 50 04             	mov    0x4(%eax),%edx
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	eb 38                	jmp    8013b8 <getint+0x5d>
	else if (lflag)
  801380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801384:	74 1a                	je     8013a0 <getint+0x45>
		return va_arg(*ap, long);
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	8d 50 04             	lea    0x4(%eax),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	89 10                	mov    %edx,(%eax)
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	83 e8 04             	sub    $0x4,%eax
  80139b:	8b 00                	mov    (%eax),%eax
  80139d:	99                   	cltd   
  80139e:	eb 18                	jmp    8013b8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 04             	lea    0x4(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 04             	sub    $0x4,%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	99                   	cltd   
}
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	56                   	push   %esi
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013c2:	eb 17                	jmp    8013db <vprintfmt+0x21>
			if (ch == '\0')
  8013c4:	85 db                	test   %ebx,%ebx
  8013c6:	0f 84 af 03 00 00    	je     80177b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	ff 75 0c             	pushl  0xc(%ebp)
  8013d2:	53                   	push   %ebx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	ff d0                	call   *%eax
  8013d8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	8d 50 01             	lea    0x1(%eax),%edx
  8013e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	0f b6 d8             	movzbl %al,%ebx
  8013e9:	83 fb 25             	cmp    $0x25,%ebx
  8013ec:	75 d6                	jne    8013c4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8013ee:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8013f2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8013f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801400:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801407:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	8d 50 01             	lea    0x1(%eax),%edx
  801414:	89 55 10             	mov    %edx,0x10(%ebp)
  801417:	8a 00                	mov    (%eax),%al
  801419:	0f b6 d8             	movzbl %al,%ebx
  80141c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80141f:	83 f8 55             	cmp    $0x55,%eax
  801422:	0f 87 2b 03 00 00    	ja     801753 <vprintfmt+0x399>
  801428:	8b 04 85 b8 2f 80 00 	mov    0x802fb8(,%eax,4),%eax
  80142f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801431:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801435:	eb d7                	jmp    80140e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801437:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80143b:	eb d1                	jmp    80140e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80143d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801444:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801447:	89 d0                	mov    %edx,%eax
  801449:	c1 e0 02             	shl    $0x2,%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	01 c0                	add    %eax,%eax
  801450:	01 d8                	add    %ebx,%eax
  801452:	83 e8 30             	sub    $0x30,%eax
  801455:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801460:	83 fb 2f             	cmp    $0x2f,%ebx
  801463:	7e 3e                	jle    8014a3 <vprintfmt+0xe9>
  801465:	83 fb 39             	cmp    $0x39,%ebx
  801468:	7f 39                	jg     8014a3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80146a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80146d:	eb d5                	jmp    801444 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	83 c0 04             	add    $0x4,%eax
  801475:	89 45 14             	mov    %eax,0x14(%ebp)
  801478:	8b 45 14             	mov    0x14(%ebp),%eax
  80147b:	83 e8 04             	sub    $0x4,%eax
  80147e:	8b 00                	mov    (%eax),%eax
  801480:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801483:	eb 1f                	jmp    8014a4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801485:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801489:	79 83                	jns    80140e <vprintfmt+0x54>
				width = 0;
  80148b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801492:	e9 77 ff ff ff       	jmp    80140e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801497:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80149e:	e9 6b ff ff ff       	jmp    80140e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014a3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014a8:	0f 89 60 ff ff ff    	jns    80140e <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014bb:	e9 4e ff ff ff       	jmp    80140e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014c0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014c3:	e9 46 ff ff ff       	jmp    80140e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	83 c0 04             	add    $0x4,%eax
  8014ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8014d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d4:	83 e8 04             	sub    $0x4,%eax
  8014d7:	8b 00                	mov    (%eax),%eax
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	50                   	push   %eax
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	ff d0                	call   *%eax
  8014e5:	83 c4 10             	add    $0x10,%esp
			break;
  8014e8:	e9 89 02 00 00       	jmp    801776 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8014ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f0:	83 c0 04             	add    $0x4,%eax
  8014f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	83 e8 04             	sub    $0x4,%eax
  8014fc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8014fe:	85 db                	test   %ebx,%ebx
  801500:	79 02                	jns    801504 <vprintfmt+0x14a>
				err = -err;
  801502:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801504:	83 fb 64             	cmp    $0x64,%ebx
  801507:	7f 0b                	jg     801514 <vprintfmt+0x15a>
  801509:	8b 34 9d 00 2e 80 00 	mov    0x802e00(,%ebx,4),%esi
  801510:	85 f6                	test   %esi,%esi
  801512:	75 19                	jne    80152d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801514:	53                   	push   %ebx
  801515:	68 a5 2f 80 00       	push   $0x802fa5
  80151a:	ff 75 0c             	pushl  0xc(%ebp)
  80151d:	ff 75 08             	pushl  0x8(%ebp)
  801520:	e8 5e 02 00 00       	call   801783 <printfmt>
  801525:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801528:	e9 49 02 00 00       	jmp    801776 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80152d:	56                   	push   %esi
  80152e:	68 ae 2f 80 00       	push   $0x802fae
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	e8 45 02 00 00       	call   801783 <printfmt>
  80153e:	83 c4 10             	add    $0x10,%esp
			break;
  801541:	e9 30 02 00 00       	jmp    801776 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801546:	8b 45 14             	mov    0x14(%ebp),%eax
  801549:	83 c0 04             	add    $0x4,%eax
  80154c:	89 45 14             	mov    %eax,0x14(%ebp)
  80154f:	8b 45 14             	mov    0x14(%ebp),%eax
  801552:	83 e8 04             	sub    $0x4,%eax
  801555:	8b 30                	mov    (%eax),%esi
  801557:	85 f6                	test   %esi,%esi
  801559:	75 05                	jne    801560 <vprintfmt+0x1a6>
				p = "(null)";
  80155b:	be b1 2f 80 00       	mov    $0x802fb1,%esi
			if (width > 0 && padc != '-')
  801560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801564:	7e 6d                	jle    8015d3 <vprintfmt+0x219>
  801566:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80156a:	74 67                	je     8015d3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80156c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	50                   	push   %eax
  801573:	56                   	push   %esi
  801574:	e8 0c 03 00 00       	call   801885 <strnlen>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80157f:	eb 16                	jmp    801597 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801581:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	50                   	push   %eax
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	ff d0                	call   *%eax
  801591:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801594:	ff 4d e4             	decl   -0x1c(%ebp)
  801597:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159b:	7f e4                	jg     801581 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80159d:	eb 34                	jmp    8015d3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80159f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a3:	74 1c                	je     8015c1 <vprintfmt+0x207>
  8015a5:	83 fb 1f             	cmp    $0x1f,%ebx
  8015a8:	7e 05                	jle    8015af <vprintfmt+0x1f5>
  8015aa:	83 fb 7e             	cmp    $0x7e,%ebx
  8015ad:	7e 12                	jle    8015c1 <vprintfmt+0x207>
					putch('?', putdat);
  8015af:	83 ec 08             	sub    $0x8,%esp
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	6a 3f                	push   $0x3f
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	ff d0                	call   *%eax
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	eb 0f                	jmp    8015d0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	53                   	push   %ebx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	89 f0                	mov    %esi,%eax
  8015d5:	8d 70 01             	lea    0x1(%eax),%esi
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f be d8             	movsbl %al,%ebx
  8015dd:	85 db                	test   %ebx,%ebx
  8015df:	74 24                	je     801605 <vprintfmt+0x24b>
  8015e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015e5:	78 b8                	js     80159f <vprintfmt+0x1e5>
  8015e7:	ff 4d e0             	decl   -0x20(%ebp)
  8015ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015ee:	79 af                	jns    80159f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8015f0:	eb 13                	jmp    801605 <vprintfmt+0x24b>
				putch(' ', putdat);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	6a 20                	push   $0x20
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	ff d0                	call   *%eax
  8015ff:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801602:	ff 4d e4             	decl   -0x1c(%ebp)
  801605:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801609:	7f e7                	jg     8015f2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80160b:	e9 66 01 00 00       	jmp    801776 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	ff 75 e8             	pushl  -0x18(%ebp)
  801616:	8d 45 14             	lea    0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	e8 3c fd ff ff       	call   80135b <getint>
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801625:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162e:	85 d2                	test   %edx,%edx
  801630:	79 23                	jns    801655 <vprintfmt+0x29b>
				putch('-', putdat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	6a 2d                	push   $0x2d
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	ff d0                	call   *%eax
  80163f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801648:	f7 d8                	neg    %eax
  80164a:	83 d2 00             	adc    $0x0,%edx
  80164d:	f7 da                	neg    %edx
  80164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801652:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801655:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80165c:	e9 bc 00 00 00       	jmp    80171d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	ff 75 e8             	pushl  -0x18(%ebp)
  801667:	8d 45 14             	lea    0x14(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	e8 84 fc ff ff       	call   8012f4 <getuint>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801676:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801679:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801680:	e9 98 00 00 00       	jmp    80171d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	6a 58                	push   $0x58
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	ff d0                	call   *%eax
  801692:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	6a 58                	push   $0x58
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	ff d0                	call   *%eax
  8016a2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	6a 58                	push   $0x58
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	ff d0                	call   *%eax
  8016b2:	83 c4 10             	add    $0x10,%esp
			break;
  8016b5:	e9 bc 00 00 00       	jmp    801776 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	6a 30                	push   $0x30
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	ff d0                	call   *%eax
  8016c7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	6a 78                	push   $0x78
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	ff d0                	call   *%eax
  8016d7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	83 c0 04             	add    $0x4,%eax
  8016e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	83 e8 04             	sub    $0x4,%eax
  8016e9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8016eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8016f5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8016fc:	eb 1f                	jmp    80171d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	ff 75 e8             	pushl  -0x18(%ebp)
  801704:	8d 45 14             	lea    0x14(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	e8 e7 fb ff ff       	call   8012f4 <getuint>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801713:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801716:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80171d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	52                   	push   %edx
  801728:	ff 75 e4             	pushl  -0x1c(%ebp)
  80172b:	50                   	push   %eax
  80172c:	ff 75 f4             	pushl  -0xc(%ebp)
  80172f:	ff 75 f0             	pushl  -0x10(%ebp)
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	e8 00 fb ff ff       	call   80123d <printnum>
  80173d:	83 c4 20             	add    $0x20,%esp
			break;
  801740:	eb 34                	jmp    801776 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801742:	83 ec 08             	sub    $0x8,%esp
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	53                   	push   %ebx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	ff d0                	call   *%eax
  80174e:	83 c4 10             	add    $0x10,%esp
			break;
  801751:	eb 23                	jmp    801776 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	6a 25                	push   $0x25
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	ff d0                	call   *%eax
  801760:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801763:	ff 4d 10             	decl   0x10(%ebp)
  801766:	eb 03                	jmp    80176b <vprintfmt+0x3b1>
  801768:	ff 4d 10             	decl   0x10(%ebp)
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	48                   	dec    %eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 25                	cmp    $0x25,%al
  801773:	75 f3                	jne    801768 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801775:	90                   	nop
		}
	}
  801776:	e9 47 fc ff ff       	jmp    8013c2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80177b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    

00801783 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801789:	8d 45 10             	lea    0x10(%ebp),%eax
  80178c:	83 c0 04             	add    $0x4,%eax
  80178f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	50                   	push   %eax
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	e8 16 fc ff ff       	call   8013ba <vprintfmt>
  8017a4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b0:	8b 40 08             	mov    0x8(%eax),%eax
  8017b3:	8d 50 01             	lea    0x1(%eax),%edx
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	8b 10                	mov    (%eax),%edx
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	8b 40 04             	mov    0x4(%eax),%eax
  8017c7:	39 c2                	cmp    %eax,%edx
  8017c9:	73 12                	jae    8017dd <sprintputch+0x33>
		*b->buf++ = ch;
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8b 00                	mov    (%eax),%eax
  8017d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8017d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d6:	89 0a                	mov    %ecx,(%edx)
  8017d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017db:	88 10                	mov    %dl,(%eax)
}
  8017dd:	90                   	nop
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801801:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801805:	74 06                	je     80180d <vsnprintf+0x2d>
  801807:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80180b:	7f 07                	jg     801814 <vsnprintf+0x34>
		return -E_INVAL;
  80180d:	b8 03 00 00 00       	mov    $0x3,%eax
  801812:	eb 20                	jmp    801834 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801814:	ff 75 14             	pushl  0x14(%ebp)
  801817:	ff 75 10             	pushl  0x10(%ebp)
  80181a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	68 aa 17 80 00       	push   $0x8017aa
  801823:	e8 92 fb ff ff       	call   8013ba <vprintfmt>
  801828:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80182b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80183c:	8d 45 10             	lea    0x10(%ebp),%eax
  80183f:	83 c0 04             	add    $0x4,%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801845:	8b 45 10             	mov    0x10(%ebp),%eax
  801848:	ff 75 f4             	pushl  -0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	e8 89 ff ff ff       	call   8017e0 <vsnprintf>
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80186f:	eb 06                	jmp    801877 <strlen+0x15>
		n++;
  801871:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801874:	ff 45 08             	incl   0x8(%ebp)
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	84 c0                	test   %al,%al
  80187e:	75 f1                	jne    801871 <strlen+0xf>
		n++;
	return n;
  801880:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80188b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801892:	eb 09                	jmp    80189d <strnlen+0x18>
		n++;
  801894:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801897:	ff 45 08             	incl   0x8(%ebp)
  80189a:	ff 4d 0c             	decl   0xc(%ebp)
  80189d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a1:	74 09                	je     8018ac <strnlen+0x27>
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	8a 00                	mov    (%eax),%al
  8018a8:	84 c0                	test   %al,%al
  8018aa:	75 e8                	jne    801894 <strnlen+0xf>
		n++;
	return n;
  8018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018bd:	90                   	nop
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8d 50 01             	lea    0x1(%eax),%edx
  8018c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018d0:	8a 12                	mov    (%edx),%dl
  8018d2:	88 10                	mov    %dl,(%eax)
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	84 c0                	test   %al,%al
  8018d8:	75 e4                	jne    8018be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8018eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018f2:	eb 1f                	jmp    801913 <strncpy+0x34>
		*dst++ = *src;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8a 12                	mov    (%edx),%dl
  801902:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	8a 00                	mov    (%eax),%al
  801909:	84 c0                	test   %al,%al
  80190b:	74 03                	je     801910 <strncpy+0x31>
			src++;
  80190d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801910:	ff 45 fc             	incl   -0x4(%ebp)
  801913:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801916:	3b 45 10             	cmp    0x10(%ebp),%eax
  801919:	72 d9                	jb     8018f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80191b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80192c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801930:	74 30                	je     801962 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801932:	eb 16                	jmp    80194a <strlcpy+0x2a>
			*dst++ = *src++;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8d 50 01             	lea    0x1(%eax),%edx
  80193a:	89 55 08             	mov    %edx,0x8(%ebp)
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8d 4a 01             	lea    0x1(%edx),%ecx
  801943:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801946:	8a 12                	mov    (%edx),%dl
  801948:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80194a:	ff 4d 10             	decl   0x10(%ebp)
  80194d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801951:	74 09                	je     80195c <strlcpy+0x3c>
  801953:	8b 45 0c             	mov    0xc(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	75 d8                	jne    801934 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801962:	8b 55 08             	mov    0x8(%ebp),%edx
  801965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801968:	29 c2                	sub    %eax,%edx
  80196a:	89 d0                	mov    %edx,%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801971:	eb 06                	jmp    801979 <strcmp+0xb>
		p++, q++;
  801973:	ff 45 08             	incl   0x8(%ebp)
  801976:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	84 c0                	test   %al,%al
  801980:	74 0e                	je     801990 <strcmp+0x22>
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8a 10                	mov    (%eax),%dl
  801987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198a:	8a 00                	mov    (%eax),%al
  80198c:	38 c2                	cmp    %al,%dl
  80198e:	74 e3                	je     801973 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	0f b6 d0             	movzbl %al,%edx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	0f b6 c0             	movzbl %al,%eax
  8019a0:	29 c2                	sub    %eax,%edx
  8019a2:	89 d0                	mov    %edx,%eax
}
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    

008019a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019a9:	eb 09                	jmp    8019b4 <strncmp+0xe>
		n--, p++, q++;
  8019ab:	ff 4d 10             	decl   0x10(%ebp)
  8019ae:	ff 45 08             	incl   0x8(%ebp)
  8019b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b8:	74 17                	je     8019d1 <strncmp+0x2b>
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	84 c0                	test   %al,%al
  8019c1:	74 0e                	je     8019d1 <strncmp+0x2b>
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8a 10                	mov    (%eax),%dl
  8019c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	38 c2                	cmp    %al,%dl
  8019cf:	74 da                	je     8019ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8019d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d5:	75 07                	jne    8019de <strncmp+0x38>
		return 0;
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	eb 14                	jmp    8019f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8a 00                	mov    (%eax),%al
  8019e3:	0f b6 d0             	movzbl %al,%edx
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	0f b6 c0             	movzbl %al,%eax
  8019ee:	29 c2                	sub    %eax,%edx
  8019f0:	89 d0                	mov    %edx,%eax
}
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a00:	eb 12                	jmp    801a14 <strchr+0x20>
		if (*s == c)
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a0a:	75 05                	jne    801a11 <strchr+0x1d>
			return (char *) s;
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	eb 11                	jmp    801a22 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a11:	ff 45 08             	incl   0x8(%ebp)
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	84 c0                	test   %al,%al
  801a1b:	75 e5                	jne    801a02 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a30:	eb 0d                	jmp    801a3f <strfind+0x1b>
		if (*s == c)
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8a 00                	mov    (%eax),%al
  801a37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a3a:	74 0e                	je     801a4a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a3c:	ff 45 08             	incl   0x8(%ebp)
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8a 00                	mov    (%eax),%al
  801a44:	84 c0                	test   %al,%al
  801a46:	75 ea                	jne    801a32 <strfind+0xe>
  801a48:	eb 01                	jmp    801a4b <strfind+0x27>
		if (*s == c)
			break;
  801a4a:	90                   	nop
	return (char *) s;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a62:	eb 0e                	jmp    801a72 <memset+0x22>
		*p++ = c;
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	8d 50 01             	lea    0x1(%eax),%edx
  801a6a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a72:	ff 4d f8             	decl   -0x8(%ebp)
  801a75:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a79:	79 e9                	jns    801a64 <memset+0x14>
		*p++ = c;

	return v;
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a92:	eb 16                	jmp    801aaa <memcpy+0x2a>
		*d++ = *s++;
  801a94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a97:	8d 50 01             	lea    0x1(%eax),%edx
  801a9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801aa3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801aa6:	8a 12                	mov    (%edx),%dl
  801aa8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ab0:	89 55 10             	mov    %edx,0x10(%ebp)
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	75 dd                	jne    801a94 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ad1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ad4:	73 50                	jae    801b26 <memmove+0x6a>
  801ad6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ae1:	76 43                	jbe    801b26 <memmove+0x6a>
		s += n;
  801ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801aef:	eb 10                	jmp    801b01 <memmove+0x45>
			*--d = *--s;
  801af1:	ff 4d f8             	decl   -0x8(%ebp)
  801af4:	ff 4d fc             	decl   -0x4(%ebp)
  801af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801afa:	8a 10                	mov    (%eax),%dl
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b01:	8b 45 10             	mov    0x10(%ebp),%eax
  801b04:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b07:	89 55 10             	mov    %edx,0x10(%ebp)
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	75 e3                	jne    801af1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b0e:	eb 23                	jmp    801b33 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b13:	8d 50 01             	lea    0x1(%eax),%edx
  801b16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b22:	8a 12                	mov    (%edx),%dl
  801b24:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b26:	8b 45 10             	mov    0x10(%ebp),%eax
  801b29:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b2c:	89 55 10             	mov    %edx,0x10(%ebp)
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	75 dd                	jne    801b10 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b4a:	eb 2a                	jmp    801b76 <memcmp+0x3e>
		if (*s1 != *s2)
  801b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4f:	8a 10                	mov    (%eax),%dl
  801b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b54:	8a 00                	mov    (%eax),%al
  801b56:	38 c2                	cmp    %al,%dl
  801b58:	74 16                	je     801b70 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5d:	8a 00                	mov    (%eax),%al
  801b5f:	0f b6 d0             	movzbl %al,%edx
  801b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	0f b6 c0             	movzbl %al,%eax
  801b6a:	29 c2                	sub    %eax,%edx
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	eb 18                	jmp    801b88 <memcmp+0x50>
		s1++, s2++;
  801b70:	ff 45 fc             	incl   -0x4(%ebp)
  801b73:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b7c:	89 55 10             	mov    %edx,0x10(%ebp)
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	75 c9                	jne    801b4c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b90:	8b 55 08             	mov    0x8(%ebp),%edx
  801b93:	8b 45 10             	mov    0x10(%ebp),%eax
  801b96:	01 d0                	add    %edx,%eax
  801b98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b9b:	eb 15                	jmp    801bb2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8a 00                	mov    (%eax),%al
  801ba2:	0f b6 d0             	movzbl %al,%edx
  801ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba8:	0f b6 c0             	movzbl %al,%eax
  801bab:	39 c2                	cmp    %eax,%edx
  801bad:	74 0d                	je     801bbc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801baf:	ff 45 08             	incl   0x8(%ebp)
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bb8:	72 e3                	jb     801b9d <memfind+0x13>
  801bba:	eb 01                	jmp    801bbd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bbc:	90                   	nop
	return (void *) s;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801bc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bd6:	eb 03                	jmp    801bdb <strtol+0x19>
		s++;
  801bd8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	8a 00                	mov    (%eax),%al
  801be0:	3c 20                	cmp    $0x20,%al
  801be2:	74 f4                	je     801bd8 <strtol+0x16>
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	8a 00                	mov    (%eax),%al
  801be9:	3c 09                	cmp    $0x9,%al
  801beb:	74 eb                	je     801bd8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	8a 00                	mov    (%eax),%al
  801bf2:	3c 2b                	cmp    $0x2b,%al
  801bf4:	75 05                	jne    801bfb <strtol+0x39>
		s++;
  801bf6:	ff 45 08             	incl   0x8(%ebp)
  801bf9:	eb 13                	jmp    801c0e <strtol+0x4c>
	else if (*s == '-')
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	8a 00                	mov    (%eax),%al
  801c00:	3c 2d                	cmp    $0x2d,%al
  801c02:	75 0a                	jne    801c0e <strtol+0x4c>
		s++, neg = 1;
  801c04:	ff 45 08             	incl   0x8(%ebp)
  801c07:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c12:	74 06                	je     801c1a <strtol+0x58>
  801c14:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c18:	75 20                	jne    801c3a <strtol+0x78>
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 30                	cmp    $0x30,%al
  801c21:	75 17                	jne    801c3a <strtol+0x78>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	40                   	inc    %eax
  801c27:	8a 00                	mov    (%eax),%al
  801c29:	3c 78                	cmp    $0x78,%al
  801c2b:	75 0d                	jne    801c3a <strtol+0x78>
		s += 2, base = 16;
  801c2d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c31:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c38:	eb 28                	jmp    801c62 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c3e:	75 15                	jne    801c55 <strtol+0x93>
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8a 00                	mov    (%eax),%al
  801c45:	3c 30                	cmp    $0x30,%al
  801c47:	75 0c                	jne    801c55 <strtol+0x93>
		s++, base = 8;
  801c49:	ff 45 08             	incl   0x8(%ebp)
  801c4c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c53:	eb 0d                	jmp    801c62 <strtol+0xa0>
	else if (base == 0)
  801c55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c59:	75 07                	jne    801c62 <strtol+0xa0>
		base = 10;
  801c5b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	3c 2f                	cmp    $0x2f,%al
  801c69:	7e 19                	jle    801c84 <strtol+0xc2>
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	8a 00                	mov    (%eax),%al
  801c70:	3c 39                	cmp    $0x39,%al
  801c72:	7f 10                	jg     801c84 <strtol+0xc2>
			dig = *s - '0';
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8a 00                	mov    (%eax),%al
  801c79:	0f be c0             	movsbl %al,%eax
  801c7c:	83 e8 30             	sub    $0x30,%eax
  801c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c82:	eb 42                	jmp    801cc6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	8a 00                	mov    (%eax),%al
  801c89:	3c 60                	cmp    $0x60,%al
  801c8b:	7e 19                	jle    801ca6 <strtol+0xe4>
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	8a 00                	mov    (%eax),%al
  801c92:	3c 7a                	cmp    $0x7a,%al
  801c94:	7f 10                	jg     801ca6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	8a 00                	mov    (%eax),%al
  801c9b:	0f be c0             	movsbl %al,%eax
  801c9e:	83 e8 57             	sub    $0x57,%eax
  801ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca4:	eb 20                	jmp    801cc6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8a 00                	mov    (%eax),%al
  801cab:	3c 40                	cmp    $0x40,%al
  801cad:	7e 39                	jle    801ce8 <strtol+0x126>
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8a 00                	mov    (%eax),%al
  801cb4:	3c 5a                	cmp    $0x5a,%al
  801cb6:	7f 30                	jg     801ce8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	8a 00                	mov    (%eax),%al
  801cbd:	0f be c0             	movsbl %al,%eax
  801cc0:	83 e8 37             	sub    $0x37,%eax
  801cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ccc:	7d 19                	jge    801ce7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801cce:	ff 45 08             	incl   0x8(%ebp)
  801cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  801cd8:	89 c2                	mov    %eax,%edx
  801cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdd:	01 d0                	add    %edx,%eax
  801cdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ce2:	e9 7b ff ff ff       	jmp    801c62 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ce7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ce8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cec:	74 08                	je     801cf6 <strtol+0x134>
		*endptr = (char *) s;
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801cf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801cfa:	74 07                	je     801d03 <strtol+0x141>
  801cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cff:	f7 d8                	neg    %eax
  801d01:	eb 03                	jmp    801d06 <strtol+0x144>
  801d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <ltostr>:

void
ltostr(long value, char *str)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d20:	79 13                	jns    801d35 <ltostr+0x2d>
	{
		neg = 1;
  801d22:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d2f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d32:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d3d:	99                   	cltd   
  801d3e:	f7 f9                	idiv   %ecx
  801d40:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d46:	8d 50 01             	lea    0x1(%eax),%edx
  801d49:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d51:	01 d0                	add    %edx,%eax
  801d53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d56:	83 c2 30             	add    $0x30,%edx
  801d59:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d63:	f7 e9                	imul   %ecx
  801d65:	c1 fa 02             	sar    $0x2,%edx
  801d68:	89 c8                	mov    %ecx,%eax
  801d6a:	c1 f8 1f             	sar    $0x1f,%eax
  801d6d:	29 c2                	sub    %eax,%edx
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d77:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d7c:	f7 e9                	imul   %ecx
  801d7e:	c1 fa 02             	sar    $0x2,%edx
  801d81:	89 c8                	mov    %ecx,%eax
  801d83:	c1 f8 1f             	sar    $0x1f,%eax
  801d86:	29 c2                	sub    %eax,%edx
  801d88:	89 d0                	mov    %edx,%eax
  801d8a:	c1 e0 02             	shl    $0x2,%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	01 c0                	add    %eax,%eax
  801d91:	29 c1                	sub    %eax,%ecx
  801d93:	89 ca                	mov    %ecx,%edx
  801d95:	85 d2                	test   %edx,%edx
  801d97:	75 9c                	jne    801d35 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da3:	48                   	dec    %eax
  801da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dab:	74 3d                	je     801dea <ltostr+0xe2>
		start = 1 ;
  801dad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801db4:	eb 34                	jmp    801dea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbc:	01 d0                	add    %edx,%eax
  801dbe:	8a 00                	mov    (%eax),%al
  801dc0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc9:	01 c2                	add    %eax,%edx
  801dcb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd1:	01 c8                	add    %ecx,%eax
  801dd3:	8a 00                	mov    (%eax),%al
  801dd5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801dd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	01 c2                	add    %eax,%edx
  801ddf:	8a 45 eb             	mov    -0x15(%ebp),%al
  801de2:	88 02                	mov    %al,(%edx)
		start++ ;
  801de4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801de7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801df0:	7c c4                	jl     801db6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801df2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801dfd:	90                   	nop
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	e8 54 fa ff ff       	call   801862 <strlen>
  801e0e:	83 c4 04             	add    $0x4,%esp
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	e8 46 fa ff ff       	call   801862 <strlen>
  801e1c:	83 c4 04             	add    $0x4,%esp
  801e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e30:	eb 17                	jmp    801e49 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e35:	8b 45 10             	mov    0x10(%ebp),%eax
  801e38:	01 c2                	add    %eax,%edx
  801e3a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	01 c8                	add    %ecx,%eax
  801e42:	8a 00                	mov    (%eax),%al
  801e44:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e46:	ff 45 fc             	incl   -0x4(%ebp)
  801e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e4f:	7c e1                	jl     801e32 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e5f:	eb 1f                	jmp    801e80 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e64:	8d 50 01             	lea    0x1(%eax),%edx
  801e67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e6a:	89 c2                	mov    %eax,%edx
  801e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6f:	01 c2                	add    %eax,%edx
  801e71:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	01 c8                	add    %ecx,%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e7d:	ff 45 f8             	incl   -0x8(%ebp)
  801e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e86:	7c d9                	jl     801e61 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8e:	01 d0                	add    %edx,%eax
  801e90:	c6 00 00             	movb   $0x0,(%eax)
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e99:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ea2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea5:	8b 00                	mov    (%eax),%eax
  801ea7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	01 d0                	add    %edx,%eax
  801eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801eb9:	eb 0c                	jmp    801ec7 <strsplit+0x31>
			*string++ = 0;
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8d 50 01             	lea    0x1(%eax),%edx
  801ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  801ec4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8a 00                	mov    (%eax),%al
  801ecc:	84 c0                	test   %al,%al
  801ece:	74 18                	je     801ee8 <strsplit+0x52>
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	8a 00                	mov    (%eax),%al
  801ed5:	0f be c0             	movsbl %al,%eax
  801ed8:	50                   	push   %eax
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	e8 13 fb ff ff       	call   8019f4 <strchr>
  801ee1:	83 c4 08             	add    $0x8,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	75 d3                	jne    801ebb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8a 00                	mov    (%eax),%al
  801eed:	84 c0                	test   %al,%al
  801eef:	74 5a                	je     801f4b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef4:	8b 00                	mov    (%eax),%eax
  801ef6:	83 f8 0f             	cmp    $0xf,%eax
  801ef9:	75 07                	jne    801f02 <strsplit+0x6c>
		{
			return 0;
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	eb 66                	jmp    801f68 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f02:	8b 45 14             	mov    0x14(%ebp),%eax
  801f05:	8b 00                	mov    (%eax),%eax
  801f07:	8d 48 01             	lea    0x1(%eax),%ecx
  801f0a:	8b 55 14             	mov    0x14(%ebp),%edx
  801f0d:	89 0a                	mov    %ecx,(%edx)
  801f0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f16:	8b 45 10             	mov    0x10(%ebp),%eax
  801f19:	01 c2                	add    %eax,%edx
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f20:	eb 03                	jmp    801f25 <strsplit+0x8f>
			string++;
  801f22:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	8a 00                	mov    (%eax),%al
  801f2a:	84 c0                	test   %al,%al
  801f2c:	74 8b                	je     801eb9 <strsplit+0x23>
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8a 00                	mov    (%eax),%al
  801f33:	0f be c0             	movsbl %al,%eax
  801f36:	50                   	push   %eax
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	e8 b5 fa ff ff       	call   8019f4 <strchr>
  801f3f:	83 c4 08             	add    $0x8,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	74 dc                	je     801f22 <strsplit+0x8c>
			string++;
	}
  801f46:	e9 6e ff ff ff       	jmp    801eb9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f4b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f58:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f63:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	68 10 31 80 00       	push   $0x803110
  801f78:	6a 0e                	push   $0xe
  801f7a:	68 4a 31 80 00       	push   $0x80314a
  801f7f:	e8 a8 ef ff ff       	call   800f2c <_panic>

00801f84 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801f8a:	a1 04 40 80 00       	mov    0x804004,%eax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	74 0f                	je     801fa2 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801f93:	e8 d2 ff ff ff       	call   801f6a <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f98:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801f9f:	00 00 00 
	}
	if (size == 0) return NULL ;
  801fa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fa6:	75 07                	jne    801faf <malloc+0x2b>
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fad:	eb 14                	jmp    801fc3 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	68 58 31 80 00       	push   $0x803158
  801fb7:	6a 2e                	push   $0x2e
  801fb9:	68 4a 31 80 00       	push   $0x80314a
  801fbe:	e8 69 ef ff ff       	call   800f2c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	68 80 31 80 00       	push   $0x803180
  801fd3:	6a 49                	push   $0x49
  801fd5:	68 4a 31 80 00       	push   $0x80314a
  801fda:	e8 4d ef ff ff       	call   800f2c <_panic>

00801fdf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 18             	sub    $0x18,%esp
  801fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe8:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 a4 31 80 00       	push   $0x8031a4
  801ff3:	6a 57                	push   $0x57
  801ff5:	68 4a 31 80 00       	push   $0x80314a
  801ffa:	e8 2d ef ff ff       	call   800f2c <_panic>

00801fff <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	68 cc 31 80 00       	push   $0x8031cc
  80200d:	6a 60                	push   $0x60
  80200f:	68 4a 31 80 00       	push   $0x80314a
  802014:	e8 13 ef ff ff       	call   800f2c <_panic>

00802019 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	68 f0 31 80 00       	push   $0x8031f0
  802027:	6a 7c                	push   $0x7c
  802029:	68 4a 31 80 00       	push   $0x80314a
  80202e:	e8 f9 ee ff ff       	call   800f2c <_panic>

00802033 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 18 32 80 00       	push   $0x803218
  802041:	68 86 00 00 00       	push   $0x86
  802046:	68 4a 31 80 00       	push   $0x80314a
  80204b:	e8 dc ee ff ff       	call   800f2c <_panic>

00802050 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 3c 32 80 00       	push   $0x80323c
  80205e:	68 91 00 00 00       	push   $0x91
  802063:	68 4a 31 80 00       	push   $0x80314a
  802068:	e8 bf ee ff ff       	call   800f2c <_panic>

0080206d <shrink>:

}
void shrink(uint32 newSize)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 3c 32 80 00       	push   $0x80323c
  80207b:	68 96 00 00 00       	push   $0x96
  802080:	68 4a 31 80 00       	push   $0x80314a
  802085:	e8 a2 ee ff ff       	call   800f2c <_panic>

0080208a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	68 3c 32 80 00       	push   $0x80323c
  802098:	68 9b 00 00 00       	push   $0x9b
  80209d:	68 4a 31 80 00       	push   $0x80314a
  8020a2:	e8 85 ee ff ff       	call   800f2c <_panic>

008020a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	57                   	push   %edi
  8020ab:	56                   	push   %esi
  8020ac:	53                   	push   %ebx
  8020ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020c2:	cd 30                	int    $0x30
  8020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5f                   	pop    %edi
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    

008020d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	52                   	push   %edx
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	50                   	push   %eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	e8 b2 ff ff ff       	call   8020a7 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 01                	push   $0x1
  80210a:	e8 98 ff ff ff       	call   8020a7 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	6a 05                	push   $0x5
  802127:	e8 7b ff ff ff       	call   8020a7 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	56                   	push   %esi
  802135:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802136:	8b 75 18             	mov    0x18(%ebp),%esi
  802139:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	51                   	push   %ecx
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 06                	push   $0x6
  80214c:	e8 56 ff ff ff       	call   8020a7 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5d                   	pop    %ebp
  80215a:	c3                   	ret    

0080215b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80215e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	52                   	push   %edx
  80216b:	50                   	push   %eax
  80216c:	6a 07                	push   $0x7
  80216e:	e8 34 ff ff ff       	call   8020a7 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 08                	push   $0x8
  802189:	e8 19 ff ff ff       	call   8020a7 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 09                	push   $0x9
  8021a2:	e8 00 ff ff ff       	call   8020a7 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 0a                	push   $0xa
  8021bb:	e8 e7 fe ff ff       	call   8020a7 <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 0b                	push   $0xb
  8021d4:	e8 ce fe ff ff       	call   8020a7 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	6a 0f                	push   $0xf
  8021ef:	e8 b3 fe ff ff       	call   8020a7 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
	return;
  8021f7:	90                   	nop
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 10                	push   $0x10
  80220b:	e8 97 fe ff ff       	call   8020a7 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
	return ;
  802213:	90                   	nop
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 10             	pushl  0x10(%ebp)
  802220:	ff 75 0c             	pushl  0xc(%ebp)
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 11                	push   $0x11
  802228:	e8 7a fe ff ff       	call   8020a7 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 0c                	push   $0xc
  802242:	e8 60 fe ff ff       	call   8020a7 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	ff 75 08             	pushl  0x8(%ebp)
  80225a:	6a 0d                	push   $0xd
  80225c:	e8 46 fe ff ff       	call   8020a7 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 0e                	push   $0xe
  802275:	e8 2d fe ff ff       	call   8020a7 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	90                   	nop
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 13                	push   $0x13
  80228f:	e8 13 fe ff ff       	call   8020a7 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 14                	push   $0x14
  8022a9:	e8 f9 fd ff ff       	call   8020a7 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	90                   	nop
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	50                   	push   %eax
  8022cd:	6a 15                	push   $0x15
  8022cf:	e8 d3 fd ff ff       	call   8020a7 <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	90                   	nop
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 16                	push   $0x16
  8022e9:	e8 b9 fd ff ff       	call   8020a7 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	90                   	nop
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	50                   	push   %eax
  802304:	6a 17                	push   $0x17
  802306:	e8 9c fd ff ff       	call   8020a7 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802313:	8b 55 0c             	mov    0xc(%ebp),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	52                   	push   %edx
  802320:	50                   	push   %eax
  802321:	6a 1a                	push   $0x1a
  802323:	e8 7f fd ff ff       	call   8020a7 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 18                	push   $0x18
  802340:	e8 62 fd ff ff       	call   8020a7 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 19                	push   $0x19
  80235e:	e8 44 fd ff ff       	call   8020a7 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	90                   	nop
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	8b 45 10             	mov    0x10(%ebp),%eax
  802372:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802375:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802378:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	51                   	push   %ecx
  802382:	52                   	push   %edx
  802383:	ff 75 0c             	pushl  0xc(%ebp)
  802386:	50                   	push   %eax
  802387:	6a 1b                	push   $0x1b
  802389:	e8 19 fd ff ff       	call   8020a7 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802396:	8b 55 0c             	mov    0xc(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	52                   	push   %edx
  8023a3:	50                   	push   %eax
  8023a4:	6a 1c                	push   $0x1c
  8023a6:	e8 fc fc ff ff       	call   8020a7 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	51                   	push   %ecx
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	6a 1d                	push   $0x1d
  8023c5:	e8 dd fc ff ff       	call   8020a7 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	52                   	push   %edx
  8023df:	50                   	push   %eax
  8023e0:	6a 1e                	push   $0x1e
  8023e2:	e8 c0 fc ff ff       	call   8020a7 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 1f                	push   $0x1f
  8023fb:	e8 a7 fc ff ff       	call   8020a7 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	ff 75 14             	pushl  0x14(%ebp)
  802410:	ff 75 10             	pushl  0x10(%ebp)
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	50                   	push   %eax
  802417:	6a 20                	push   $0x20
  802419:	e8 89 fc ff ff       	call   8020a7 <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	50                   	push   %eax
  802432:	6a 21                	push   $0x21
  802434:	e8 6e fc ff ff       	call   8020a7 <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
}
  80243c:	90                   	nop
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	50                   	push   %eax
  80244e:	6a 22                	push   $0x22
  802450:	e8 52 fc ff ff       	call   8020a7 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 02                	push   $0x2
  802469:	e8 39 fc ff ff       	call   8020a7 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 03                	push   $0x3
  802482:	e8 20 fc ff ff       	call   8020a7 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 04                	push   $0x4
  80249b:	e8 07 fc ff ff       	call   8020a7 <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_exit_env>:


void sys_exit_env(void)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 23                	push   $0x23
  8024b4:	e8 ee fb ff ff       	call   8020a7 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024c8:	8d 50 04             	lea    0x4(%eax),%edx
  8024cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	52                   	push   %edx
  8024d5:	50                   	push   %eax
  8024d6:	6a 24                	push   $0x24
  8024d8:	e8 ca fb ff ff       	call   8020a7 <syscall>
  8024dd:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e9:	89 01                	mov    %eax,(%ecx)
  8024eb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	c9                   	leave  
  8024f2:	c2 04 00             	ret    $0x4

008024f5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	ff 75 10             	pushl  0x10(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	6a 12                	push   $0x12
  802507:	e8 9b fb ff ff       	call   8020a7 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
	return ;
  80250f:	90                   	nop
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_rcr2>:
uint32 sys_rcr2()
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 25                	push   $0x25
  802521:	e8 81 fb ff ff       	call   8020a7 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802537:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	50                   	push   %eax
  802544:	6a 26                	push   $0x26
  802546:	e8 5c fb ff ff       	call   8020a7 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
	return ;
  80254e:	90                   	nop
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <rsttst>:
void rsttst()
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 28                	push   $0x28
  802560:	e8 42 fb ff ff       	call   8020a7 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return ;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	8b 45 14             	mov    0x14(%ebp),%eax
  802574:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802577:	8b 55 18             	mov    0x18(%ebp),%edx
  80257a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257e:	52                   	push   %edx
  80257f:	50                   	push   %eax
  802580:	ff 75 10             	pushl  0x10(%ebp)
  802583:	ff 75 0c             	pushl  0xc(%ebp)
  802586:	ff 75 08             	pushl  0x8(%ebp)
  802589:	6a 27                	push   $0x27
  80258b:	e8 17 fb ff ff       	call   8020a7 <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
	return ;
  802593:	90                   	nop
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <chktst>:
void chktst(uint32 n)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	6a 29                	push   $0x29
  8025a6:	e8 fc fa ff ff       	call   8020a7 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ae:	90                   	nop
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <inctst>:

void inctst()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 2a                	push   $0x2a
  8025c0:	e8 e2 fa ff ff       	call   8020a7 <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c8:	90                   	nop
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <gettst>:
uint32 gettst()
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 2b                	push   $0x2b
  8025da:	e8 c8 fa ff ff       	call   8020a7 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 2c                	push   $0x2c
  8025f6:	e8 ac fa ff ff       	call   8020a7 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
  8025fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802601:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802605:	75 07                	jne    80260e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802607:	b8 01 00 00 00       	mov    $0x1,%eax
  80260c:	eb 05                	jmp    802613 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 2c                	push   $0x2c
  802627:	e8 7b fa ff ff       	call   8020a7 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
  80262f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802632:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802636:	75 07                	jne    80263f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802638:	b8 01 00 00 00       	mov    $0x1,%eax
  80263d:	eb 05                	jmp    802644 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 2c                	push   $0x2c
  802658:	e8 4a fa ff ff       	call   8020a7 <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
  802660:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802663:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802667:	75 07                	jne    802670 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802669:	b8 01 00 00 00       	mov    $0x1,%eax
  80266e:	eb 05                	jmp    802675 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 2c                	push   $0x2c
  802689:	e8 19 fa ff ff       	call   8020a7 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
  802691:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802694:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802698:	75 07                	jne    8026a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80269a:	b8 01 00 00 00       	mov    $0x1,%eax
  80269f:	eb 05                	jmp    8026a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	ff 75 08             	pushl  0x8(%ebp)
  8026b6:	6a 2d                	push   $0x2d
  8026b8:	e8 ea f9 ff ff       	call   8020a7 <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c0:	90                   	nop
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	53                   	push   %ebx
  8026d6:	51                   	push   %ecx
  8026d7:	52                   	push   %edx
  8026d8:	50                   	push   %eax
  8026d9:	6a 2e                	push   $0x2e
  8026db:	e8 c7 f9 ff ff       	call   8020a7 <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
}
  8026e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	52                   	push   %edx
  8026f8:	50                   	push   %eax
  8026f9:	6a 2f                	push   $0x2f
  8026fb:	e8 a7 f9 ff ff       	call   8020a7 <syscall>
  802700:	83 c4 18             	add    $0x18,%esp
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    
  802705:	66 90                	xchg   %ax,%ax
  802707:	90                   	nop

00802708 <__udivdi3>:
  802708:	55                   	push   %ebp
  802709:	57                   	push   %edi
  80270a:	56                   	push   %esi
  80270b:	53                   	push   %ebx
  80270c:	83 ec 1c             	sub    $0x1c,%esp
  80270f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802713:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80271b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80271f:	89 ca                	mov    %ecx,%edx
  802721:	89 f8                	mov    %edi,%eax
  802723:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802727:	85 f6                	test   %esi,%esi
  802729:	75 2d                	jne    802758 <__udivdi3+0x50>
  80272b:	39 cf                	cmp    %ecx,%edi
  80272d:	77 65                	ja     802794 <__udivdi3+0x8c>
  80272f:	89 fd                	mov    %edi,%ebp
  802731:	85 ff                	test   %edi,%edi
  802733:	75 0b                	jne    802740 <__udivdi3+0x38>
  802735:	b8 01 00 00 00       	mov    $0x1,%eax
  80273a:	31 d2                	xor    %edx,%edx
  80273c:	f7 f7                	div    %edi
  80273e:	89 c5                	mov    %eax,%ebp
  802740:	31 d2                	xor    %edx,%edx
  802742:	89 c8                	mov    %ecx,%eax
  802744:	f7 f5                	div    %ebp
  802746:	89 c1                	mov    %eax,%ecx
  802748:	89 d8                	mov    %ebx,%eax
  80274a:	f7 f5                	div    %ebp
  80274c:	89 cf                	mov    %ecx,%edi
  80274e:	89 fa                	mov    %edi,%edx
  802750:	83 c4 1c             	add    $0x1c,%esp
  802753:	5b                   	pop    %ebx
  802754:	5e                   	pop    %esi
  802755:	5f                   	pop    %edi
  802756:	5d                   	pop    %ebp
  802757:	c3                   	ret    
  802758:	39 ce                	cmp    %ecx,%esi
  80275a:	77 28                	ja     802784 <__udivdi3+0x7c>
  80275c:	0f bd fe             	bsr    %esi,%edi
  80275f:	83 f7 1f             	xor    $0x1f,%edi
  802762:	75 40                	jne    8027a4 <__udivdi3+0x9c>
  802764:	39 ce                	cmp    %ecx,%esi
  802766:	72 0a                	jb     802772 <__udivdi3+0x6a>
  802768:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80276c:	0f 87 9e 00 00 00    	ja     802810 <__udivdi3+0x108>
  802772:	b8 01 00 00 00       	mov    $0x1,%eax
  802777:	89 fa                	mov    %edi,%edx
  802779:	83 c4 1c             	add    $0x1c,%esp
  80277c:	5b                   	pop    %ebx
  80277d:	5e                   	pop    %esi
  80277e:	5f                   	pop    %edi
  80277f:	5d                   	pop    %ebp
  802780:	c3                   	ret    
  802781:	8d 76 00             	lea    0x0(%esi),%esi
  802784:	31 ff                	xor    %edi,%edi
  802786:	31 c0                	xor    %eax,%eax
  802788:	89 fa                	mov    %edi,%edx
  80278a:	83 c4 1c             	add    $0x1c,%esp
  80278d:	5b                   	pop    %ebx
  80278e:	5e                   	pop    %esi
  80278f:	5f                   	pop    %edi
  802790:	5d                   	pop    %ebp
  802791:	c3                   	ret    
  802792:	66 90                	xchg   %ax,%ax
  802794:	89 d8                	mov    %ebx,%eax
  802796:	f7 f7                	div    %edi
  802798:	31 ff                	xor    %edi,%edi
  80279a:	89 fa                	mov    %edi,%edx
  80279c:	83 c4 1c             	add    $0x1c,%esp
  80279f:	5b                   	pop    %ebx
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    
  8027a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027a9:	89 eb                	mov    %ebp,%ebx
  8027ab:	29 fb                	sub    %edi,%ebx
  8027ad:	89 f9                	mov    %edi,%ecx
  8027af:	d3 e6                	shl    %cl,%esi
  8027b1:	89 c5                	mov    %eax,%ebp
  8027b3:	88 d9                	mov    %bl,%cl
  8027b5:	d3 ed                	shr    %cl,%ebp
  8027b7:	89 e9                	mov    %ebp,%ecx
  8027b9:	09 f1                	or     %esi,%ecx
  8027bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027bf:	89 f9                	mov    %edi,%ecx
  8027c1:	d3 e0                	shl    %cl,%eax
  8027c3:	89 c5                	mov    %eax,%ebp
  8027c5:	89 d6                	mov    %edx,%esi
  8027c7:	88 d9                	mov    %bl,%cl
  8027c9:	d3 ee                	shr    %cl,%esi
  8027cb:	89 f9                	mov    %edi,%ecx
  8027cd:	d3 e2                	shl    %cl,%edx
  8027cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027d3:	88 d9                	mov    %bl,%cl
  8027d5:	d3 e8                	shr    %cl,%eax
  8027d7:	09 c2                	or     %eax,%edx
  8027d9:	89 d0                	mov    %edx,%eax
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	f7 74 24 0c          	divl   0xc(%esp)
  8027e1:	89 d6                	mov    %edx,%esi
  8027e3:	89 c3                	mov    %eax,%ebx
  8027e5:	f7 e5                	mul    %ebp
  8027e7:	39 d6                	cmp    %edx,%esi
  8027e9:	72 19                	jb     802804 <__udivdi3+0xfc>
  8027eb:	74 0b                	je     8027f8 <__udivdi3+0xf0>
  8027ed:	89 d8                	mov    %ebx,%eax
  8027ef:	31 ff                	xor    %edi,%edi
  8027f1:	e9 58 ff ff ff       	jmp    80274e <__udivdi3+0x46>
  8027f6:	66 90                	xchg   %ax,%ax
  8027f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027fc:	89 f9                	mov    %edi,%ecx
  8027fe:	d3 e2                	shl    %cl,%edx
  802800:	39 c2                	cmp    %eax,%edx
  802802:	73 e9                	jae    8027ed <__udivdi3+0xe5>
  802804:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802807:	31 ff                	xor    %edi,%edi
  802809:	e9 40 ff ff ff       	jmp    80274e <__udivdi3+0x46>
  80280e:	66 90                	xchg   %ax,%ax
  802810:	31 c0                	xor    %eax,%eax
  802812:	e9 37 ff ff ff       	jmp    80274e <__udivdi3+0x46>
  802817:	90                   	nop

00802818 <__umoddi3>:
  802818:	55                   	push   %ebp
  802819:	57                   	push   %edi
  80281a:	56                   	push   %esi
  80281b:	53                   	push   %ebx
  80281c:	83 ec 1c             	sub    $0x1c,%esp
  80281f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802823:	8b 74 24 34          	mov    0x34(%esp),%esi
  802827:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80282b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80282f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802833:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802837:	89 f3                	mov    %esi,%ebx
  802839:	89 fa                	mov    %edi,%edx
  80283b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80283f:	89 34 24             	mov    %esi,(%esp)
  802842:	85 c0                	test   %eax,%eax
  802844:	75 1a                	jne    802860 <__umoddi3+0x48>
  802846:	39 f7                	cmp    %esi,%edi
  802848:	0f 86 a2 00 00 00    	jbe    8028f0 <__umoddi3+0xd8>
  80284e:	89 c8                	mov    %ecx,%eax
  802850:	89 f2                	mov    %esi,%edx
  802852:	f7 f7                	div    %edi
  802854:	89 d0                	mov    %edx,%eax
  802856:	31 d2                	xor    %edx,%edx
  802858:	83 c4 1c             	add    $0x1c,%esp
  80285b:	5b                   	pop    %ebx
  80285c:	5e                   	pop    %esi
  80285d:	5f                   	pop    %edi
  80285e:	5d                   	pop    %ebp
  80285f:	c3                   	ret    
  802860:	39 f0                	cmp    %esi,%eax
  802862:	0f 87 ac 00 00 00    	ja     802914 <__umoddi3+0xfc>
  802868:	0f bd e8             	bsr    %eax,%ebp
  80286b:	83 f5 1f             	xor    $0x1f,%ebp
  80286e:	0f 84 ac 00 00 00    	je     802920 <__umoddi3+0x108>
  802874:	bf 20 00 00 00       	mov    $0x20,%edi
  802879:	29 ef                	sub    %ebp,%edi
  80287b:	89 fe                	mov    %edi,%esi
  80287d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802881:	89 e9                	mov    %ebp,%ecx
  802883:	d3 e0                	shl    %cl,%eax
  802885:	89 d7                	mov    %edx,%edi
  802887:	89 f1                	mov    %esi,%ecx
  802889:	d3 ef                	shr    %cl,%edi
  80288b:	09 c7                	or     %eax,%edi
  80288d:	89 e9                	mov    %ebp,%ecx
  80288f:	d3 e2                	shl    %cl,%edx
  802891:	89 14 24             	mov    %edx,(%esp)
  802894:	89 d8                	mov    %ebx,%eax
  802896:	d3 e0                	shl    %cl,%eax
  802898:	89 c2                	mov    %eax,%edx
  80289a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80289e:	d3 e0                	shl    %cl,%eax
  8028a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028a8:	89 f1                	mov    %esi,%ecx
  8028aa:	d3 e8                	shr    %cl,%eax
  8028ac:	09 d0                	or     %edx,%eax
  8028ae:	d3 eb                	shr    %cl,%ebx
  8028b0:	89 da                	mov    %ebx,%edx
  8028b2:	f7 f7                	div    %edi
  8028b4:	89 d3                	mov    %edx,%ebx
  8028b6:	f7 24 24             	mull   (%esp)
  8028b9:	89 c6                	mov    %eax,%esi
  8028bb:	89 d1                	mov    %edx,%ecx
  8028bd:	39 d3                	cmp    %edx,%ebx
  8028bf:	0f 82 87 00 00 00    	jb     80294c <__umoddi3+0x134>
  8028c5:	0f 84 91 00 00 00    	je     80295c <__umoddi3+0x144>
  8028cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028cf:	29 f2                	sub    %esi,%edx
  8028d1:	19 cb                	sbb    %ecx,%ebx
  8028d3:	89 d8                	mov    %ebx,%eax
  8028d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028d9:	d3 e0                	shl    %cl,%eax
  8028db:	89 e9                	mov    %ebp,%ecx
  8028dd:	d3 ea                	shr    %cl,%edx
  8028df:	09 d0                	or     %edx,%eax
  8028e1:	89 e9                	mov    %ebp,%ecx
  8028e3:	d3 eb                	shr    %cl,%ebx
  8028e5:	89 da                	mov    %ebx,%edx
  8028e7:	83 c4 1c             	add    $0x1c,%esp
  8028ea:	5b                   	pop    %ebx
  8028eb:	5e                   	pop    %esi
  8028ec:	5f                   	pop    %edi
  8028ed:	5d                   	pop    %ebp
  8028ee:	c3                   	ret    
  8028ef:	90                   	nop
  8028f0:	89 fd                	mov    %edi,%ebp
  8028f2:	85 ff                	test   %edi,%edi
  8028f4:	75 0b                	jne    802901 <__umoddi3+0xe9>
  8028f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	f7 f7                	div    %edi
  8028ff:	89 c5                	mov    %eax,%ebp
  802901:	89 f0                	mov    %esi,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f5                	div    %ebp
  802907:	89 c8                	mov    %ecx,%eax
  802909:	f7 f5                	div    %ebp
  80290b:	89 d0                	mov    %edx,%eax
  80290d:	e9 44 ff ff ff       	jmp    802856 <__umoddi3+0x3e>
  802912:	66 90                	xchg   %ax,%ax
  802914:	89 c8                	mov    %ecx,%eax
  802916:	89 f2                	mov    %esi,%edx
  802918:	83 c4 1c             	add    $0x1c,%esp
  80291b:	5b                   	pop    %ebx
  80291c:	5e                   	pop    %esi
  80291d:	5f                   	pop    %edi
  80291e:	5d                   	pop    %ebp
  80291f:	c3                   	ret    
  802920:	3b 04 24             	cmp    (%esp),%eax
  802923:	72 06                	jb     80292b <__umoddi3+0x113>
  802925:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802929:	77 0f                	ja     80293a <__umoddi3+0x122>
  80292b:	89 f2                	mov    %esi,%edx
  80292d:	29 f9                	sub    %edi,%ecx
  80292f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802933:	89 14 24             	mov    %edx,(%esp)
  802936:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80293a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80293e:	8b 14 24             	mov    (%esp),%edx
  802941:	83 c4 1c             	add    $0x1c,%esp
  802944:	5b                   	pop    %ebx
  802945:	5e                   	pop    %esi
  802946:	5f                   	pop    %edi
  802947:	5d                   	pop    %ebp
  802948:	c3                   	ret    
  802949:	8d 76 00             	lea    0x0(%esi),%esi
  80294c:	2b 04 24             	sub    (%esp),%eax
  80294f:	19 fa                	sbb    %edi,%edx
  802951:	89 d1                	mov    %edx,%ecx
  802953:	89 c6                	mov    %eax,%esi
  802955:	e9 71 ff ff ff       	jmp    8028cb <__umoddi3+0xb3>
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802960:	72 ea                	jb     80294c <__umoddi3+0x134>
  802962:	89 d9                	mov    %ebx,%ecx
  802964:	e9 62 ff ff ff       	jmp    8028cb <__umoddi3+0xb3>
