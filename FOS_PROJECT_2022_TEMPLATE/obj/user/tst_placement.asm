
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 01    	sub    $0x10000bc,%esp

	//	cprintf("envID = %d\n",envID);
	char arr[PAGE_SIZE*1024*4];

	uint32 actual_active_list[2] = {0x1,0x2};
  800044:	c7 85 9c ff ff fe 01 	movl   $0x1,-0x1000064(%ebp)
  80004b:	00 00 00 
  80004e:	c7 85 a0 ff ff fe 02 	movl   $0x2,-0x1000060(%ebp)
  800055:	00 00 00 
	uint32 actual_second_list[3] = {0x3,0x4, 0x5};
  800058:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  80005e:	bb e0 22 80 00       	mov    $0x8022e0,%ebx
  800063:	ba 03 00 00 00       	mov    $0x3,%edx
  800068:	89 c7                	mov    %eax,%edi
  80006a:	89 de                	mov    %ebx,%esi
  80006c:	89 d1                	mov    %edx,%ecx
  80006e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 2, 3);
  800070:	6a 03                	push   $0x3
  800072:	6a 02                	push   $0x2
  800074:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  80007a:	50                   	push   %eax
  80007b:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3f 1d 00 00       	call   801dc6 <sys_check_LRU_lists>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(check == 0)
  80008d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800091:	75 14                	jne    8000a7 <_main+0x6f>
		panic("LRU lists entries are not correct, check your logic again!!");
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 80 20 80 00       	push   $0x802080
  80009b:	6a 11                	push   $0x11
  80009d:	68 bc 20 80 00       	push   $0x8020bc
  8000a2:	e8 c5 06 00 00       	call   80076c <_panic>
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b2:	8b 00                	mov    (%eax),%eax
  8000b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000bf:	3d 00 00 20 00       	cmp    $0x200000,%eax
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 d4 20 80 00       	push   $0x8020d4
  8000ce:	6a 14                	push   $0x14
  8000d0:	68 bc 20 80 00       	push   $0x8020bc
  8000d5:	e8 92 06 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000da:	a1 20 30 80 00       	mov    0x803020,%eax
  8000df:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e5:	83 c0 18             	add    $0x18,%eax
  8000e8:	8b 00                	mov    (%eax),%eax
  8000ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f5:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000fa:	74 14                	je     800110 <_main+0xd8>
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	68 d4 20 80 00       	push   $0x8020d4
  800104:	6a 15                	push   $0x15
  800106:	68 bc 20 80 00       	push   $0x8020bc
  80010b:	e8 5c 06 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011b:	83 c0 30             	add    $0x30,%eax
  80011e:	8b 00                	mov    (%eax),%eax
  800120:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800123:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012b:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800130:	74 14                	je     800146 <_main+0x10e>
  800132:	83 ec 04             	sub    $0x4,%esp
  800135:	68 d4 20 80 00       	push   $0x8020d4
  80013a:	6a 16                	push   $0x16
  80013c:	68 bc 20 80 00       	push   $0x8020bc
  800141:	e8 26 06 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800151:	83 c0 48             	add    $0x48,%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800159:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80015c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800161:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800166:	74 14                	je     80017c <_main+0x144>
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	68 d4 20 80 00       	push   $0x8020d4
  800170:	6a 17                	push   $0x17
  800172:	68 bc 20 80 00       	push   $0x8020bc
  800177:	e8 f0 05 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80017c:	a1 20 30 80 00       	mov    0x803020,%eax
  800181:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800187:	83 c0 60             	add    $0x60,%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80018f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800197:	3d 00 40 20 00       	cmp    $0x204000,%eax
  80019c:	74 14                	je     8001b2 <_main+0x17a>
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	68 d4 20 80 00       	push   $0x8020d4
  8001a6:	6a 18                	push   $0x18
  8001a8:	68 bc 20 80 00       	push   $0x8020bc
  8001ad:	e8 ba 05 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001bd:	83 c0 78             	add    $0x78,%eax
  8001c0:	8b 00                	mov    (%eax),%eax
  8001c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001cd:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001d2:	74 14                	je     8001e8 <_main+0x1b0>
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	68 d4 20 80 00       	push   $0x8020d4
  8001dc:	6a 19                	push   $0x19
  8001de:	68 bc 20 80 00       	push   $0x8020bc
  8001e3:	e8 84 05 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ed:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001f3:	05 90 00 00 00       	add    $0x90,%eax
  8001f8:	8b 00                	mov    (%eax),%eax
  8001fa:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001fd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800200:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800205:	3d 00 60 20 00       	cmp    $0x206000,%eax
  80020a:	74 14                	je     800220 <_main+0x1e8>
  80020c:	83 ec 04             	sub    $0x4,%esp
  80020f:	68 d4 20 80 00       	push   $0x8020d4
  800214:	6a 1a                	push   $0x1a
  800216:	68 bc 20 80 00       	push   $0x8020bc
  80021b:	e8 4c 05 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800220:	a1 20 30 80 00       	mov    0x803020,%eax
  800225:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80022b:	05 a8 00 00 00       	add    $0xa8,%eax
  800230:	8b 00                	mov    (%eax),%eax
  800232:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800235:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80023d:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800242:	74 14                	je     800258 <_main+0x220>
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	68 d4 20 80 00       	push   $0x8020d4
  80024c:	6a 1b                	push   $0x1b
  80024e:	68 bc 20 80 00       	push   $0x8020bc
  800253:	e8 14 05 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800263:	05 c0 00 00 00       	add    $0xc0,%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80026d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800270:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800275:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80027a:	74 14                	je     800290 <_main+0x258>
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	68 d4 20 80 00       	push   $0x8020d4
  800284:	6a 1c                	push   $0x1c
  800286:	68 bc 20 80 00       	push   $0x8020bc
  80028b:	e8 dc 04 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800290:	a1 20 30 80 00       	mov    0x803020,%eax
  800295:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80029b:	05 d8 00 00 00       	add    $0xd8,%eax
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8002a5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ad:	3d 00 20 80 00       	cmp    $0x802000,%eax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 d4 20 80 00       	push   $0x8020d4
  8002bc:	6a 1d                	push   $0x1d
  8002be:	68 bc 20 80 00       	push   $0x8020bc
  8002c3:	e8 a4 04 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cd:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8002d3:	05 f0 00 00 00       	add    $0xf0,%eax
  8002d8:	8b 00                	mov    (%eax),%eax
  8002da:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e5:	3d 00 30 80 00       	cmp    $0x803000,%eax
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 d4 20 80 00       	push   $0x8020d4
  8002f4:	6a 1e                	push   $0x1e
  8002f6:	68 bc 20 80 00       	push   $0x8020bc
  8002fb:	e8 6c 04 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800300:	a1 20 30 80 00       	mov    0x803020,%eax
  800305:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80030b:	05 08 01 00 00       	add    $0x108,%eax
  800310:	8b 00                	mov    (%eax),%eax
  800312:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800315:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800318:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80031d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800322:	74 14                	je     800338 <_main+0x300>
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	68 d4 20 80 00       	push   $0x8020d4
  80032c:	6a 1f                	push   $0x1f
  80032e:	68 bc 20 80 00       	push   $0x8020bc
  800333:	e8 34 04 00 00       	call   80076c <_panic>

		for (int k = 12; k < 20; k++)
  800338:	c7 45 e4 0c 00 00 00 	movl   $0xc,-0x1c(%ebp)
  80033f:	eb 37                	jmp    800378 <_main+0x340>
			if( myEnv->__uptr_pws[k].empty !=  1)
  800341:	a1 20 30 80 00       	mov    0x803020,%eax
  800346:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80034c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80034f:	89 d0                	mov    %edx,%eax
  800351:	01 c0                	add    %eax,%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	c1 e0 03             	shl    $0x3,%eax
  800358:	01 c8                	add    %ecx,%eax
  80035a:	8a 40 04             	mov    0x4(%eax),%al
  80035d:	3c 01                	cmp    $0x1,%al
  80035f:	74 14                	je     800375 <_main+0x33d>
				panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 d4 20 80 00       	push   $0x8020d4
  800369:	6a 23                	push   $0x23
  80036b:	68 bc 20 80 00       	push   $0x8020bc
  800370:	e8 f7 03 00 00       	call   80076c <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");

		for (int k = 12; k < 20; k++)
  800375:	ff 45 e4             	incl   -0x1c(%ebp)
  800378:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  80037c:	7e c3                	jle    800341 <_main+0x309>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  12)  											panic("INITIAL PAGE last index checking failed! Review size of the WS..!!");
		/*====================================*/
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80037e:	e8 b3 15 00 00       	call   801936 <sys_pf_calculate_allocated_pages>
  800383:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  800386:	e8 0b 15 00 00       	call   801896 <sys_calculate_free_frames>
  80038b:	89 45 a4             	mov    %eax,-0x5c(%ebp)

	int i=0;
  80038e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800395:	eb 11                	jmp    8003a8 <_main+0x370>
	{
		arr[i] = -1;
  800397:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  80039d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8003a5:	ff 45 e0             	incl   -0x20(%ebp)
  8003a8:	81 7d e0 00 10 00 00 	cmpl   $0x1000,-0x20(%ebp)
  8003af:	7e e6                	jle    800397 <_main+0x35f>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  8003b1:	c7 45 e0 00 00 40 00 	movl   $0x400000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8003b8:	eb 11                	jmp    8003cb <_main+0x393>
	{
		arr[i] = -1;
  8003ba:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  8003c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8003c8:	ff 45 e0             	incl   -0x20(%ebp)
  8003cb:	81 7d e0 00 10 40 00 	cmpl   $0x401000,-0x20(%ebp)
  8003d2:	7e e6                	jle    8003ba <_main+0x382>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  8003d4:	c7 45 e0 00 00 80 00 	movl   $0x800000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003db:	eb 11                	jmp    8003ee <_main+0x3b6>
	{
		arr[i] = -1;
  8003dd:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  8003e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003eb:	ff 45 e0             	incl   -0x20(%ebp)
  8003ee:	81 7d e0 00 10 80 00 	cmpl   $0x801000,-0x20(%ebp)
  8003f5:	7e e6                	jle    8003dd <_main+0x3a5>
		arr[i] = -1;
	}



	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 18 21 80 00       	push   $0x802118
  8003ff:	e8 1c 06 00 00       	call   800a20 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  800407:	8a 85 a4 ff ff fe    	mov    -0x100005c(%ebp),%al
  80040d:	3c ff                	cmp    $0xff,%al
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 48 21 80 00       	push   $0x802148
  800419:	6a 43                	push   $0x43
  80041b:	68 bc 20 80 00       	push   $0x8020bc
  800420:	e8 47 03 00 00       	call   80076c <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800425:	8a 85 a4 0f 00 ff    	mov    -0xfff05c(%ebp),%al
  80042b:	3c ff                	cmp    $0xff,%al
  80042d:	74 14                	je     800443 <_main+0x40b>
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	68 48 21 80 00       	push   $0x802148
  800437:	6a 44                	push   $0x44
  800439:	68 bc 20 80 00       	push   $0x8020bc
  80043e:	e8 29 03 00 00       	call   80076c <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  800443:	8a 85 a4 ff 3f ff    	mov    -0xc0005c(%ebp),%al
  800449:	3c ff                	cmp    $0xff,%al
  80044b:	74 14                	je     800461 <_main+0x429>
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	68 48 21 80 00       	push   $0x802148
  800455:	6a 46                	push   $0x46
  800457:	68 bc 20 80 00       	push   $0x8020bc
  80045c:	e8 0b 03 00 00       	call   80076c <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  800461:	8a 85 a4 0f 40 ff    	mov    -0xbff05c(%ebp),%al
  800467:	3c ff                	cmp    $0xff,%al
  800469:	74 14                	je     80047f <_main+0x447>
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	68 48 21 80 00       	push   $0x802148
  800473:	6a 47                	push   $0x47
  800475:	68 bc 20 80 00       	push   $0x8020bc
  80047a:	e8 ed 02 00 00       	call   80076c <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80047f:	8a 85 a4 ff 7f ff    	mov    -0x80005c(%ebp),%al
  800485:	3c ff                	cmp    $0xff,%al
  800487:	74 14                	je     80049d <_main+0x465>
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	68 48 21 80 00       	push   $0x802148
  800491:	6a 49                	push   $0x49
  800493:	68 bc 20 80 00       	push   $0x8020bc
  800498:	e8 cf 02 00 00       	call   80076c <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  80049d:	8a 85 a4 0f 80 ff    	mov    -0x7ff05c(%ebp),%al
  8004a3:	3c ff                	cmp    $0xff,%al
  8004a5:	74 14                	je     8004bb <_main+0x483>
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	68 48 21 80 00       	push   $0x802148
  8004af:	6a 4a                	push   $0x4a
  8004b1:	68 bc 20 80 00       	push   $0x8020bc
  8004b6:	e8 b1 02 00 00       	call   80076c <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  8004bb:	e8 76 14 00 00       	call   801936 <sys_pf_calculate_allocated_pages>
  8004c0:	2b 45 a8             	sub    -0x58(%ebp),%eax
  8004c3:	83 f8 05             	cmp    $0x5,%eax
  8004c6:	74 14                	je     8004dc <_main+0x4a4>
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	68 68 21 80 00       	push   $0x802168
  8004d0:	6a 4d                	push   $0x4d
  8004d2:	68 bc 20 80 00       	push   $0x8020bc
  8004d7:	e8 90 02 00 00       	call   80076c <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  8004dc:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
  8004df:	e8 b2 13 00 00       	call   801896 <sys_calculate_free_frames>
  8004e4:	29 c3                	sub    %eax,%ebx
  8004e6:	89 d8                	mov    %ebx,%eax
  8004e8:	83 f8 09             	cmp    $0x9,%eax
  8004eb:	74 14                	je     800501 <_main+0x4c9>
  8004ed:	83 ec 04             	sub    $0x4,%esp
  8004f0:	68 98 21 80 00       	push   $0x802198
  8004f5:	6a 4f                	push   $0x4f
  8004f7:	68 bc 20 80 00       	push   $0x8020bc
  8004fc:	e8 6b 02 00 00       	call   80076c <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800501:	83 ec 0c             	sub    $0xc,%esp
  800504:	68 b8 21 80 00       	push   $0x8021b8
  800509:	e8 12 05 00 00       	call   800a20 <cprintf>
  80050e:	83 c4 10             	add    $0x10,%esp


	uint32 expectedPages[20] = {0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x800000,0x801000,0x802000,0x803000,0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000, 0, 0};
  800511:	8d 85 40 ff ff fe    	lea    -0x10000c0(%ebp),%eax
  800517:	bb 00 23 80 00       	mov    $0x802300,%ebx
  80051c:	ba 14 00 00 00       	mov    $0x14,%edx
  800521:	89 c7                	mov    %eax,%edi
  800523:	89 de                	mov    %ebx,%esi
  800525:	89 d1                	mov    %edx,%ecx
  800527:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	cprintf("STEP B: checking WS entries ...\n");
  800529:	83 ec 0c             	sub    $0xc,%esp
  80052c:	68 ec 21 80 00       	push   $0x8021ec
  800531:	e8 ea 04 00 00       	call   800a20 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	{
		CheckWSWithoutLastIndex(expectedPages, 20);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	6a 14                	push   $0x14
  80053e:	8d 85 40 ff ff fe    	lea    -0x10000c0(%ebp),%eax
  800544:	50                   	push   %eax
  800545:	e8 94 02 00 00       	call   8007de <CheckWSWithoutLastIndex>
  80054a:	83 c4 10             	add    $0x10,%esp
	//		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=  0xedffd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=  0xedffe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=  0xee3fd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=  0xee3fe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
}
cprintf("STEP B passed: WS entries test are correct\n\n\n");
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	68 10 22 80 00       	push   $0x802210
  800555:	e8 c6 04 00 00       	call   800a20 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  80055d:	83 ec 0c             	sub    $0xc,%esp
  800560:	68 40 22 80 00       	push   $0x802240
  800565:	e8 b6 04 00 00       	call   800a20 <cprintf>
  80056a:	83 c4 10             	add    $0x10,%esp
{
	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	i=PAGE_SIZE*1024*3;
  80056d:	c7 45 e0 00 00 c0 00 	movl   $0xc00000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800574:	eb 11                	jmp    800587 <_main+0x54f>
	{
		arr[i] = -1;
  800576:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  80057c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	c6 00 ff             	movb   $0xff,(%eax)
{
	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	i=PAGE_SIZE*1024*3;
	for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800584:	ff 45 e0             	incl   -0x20(%ebp)
  800587:	81 7d e0 00 10 c0 00 	cmpl   $0xc01000,-0x20(%ebp)
  80058e:	7e e6                	jle    800576 <_main+0x53e>
	{
		arr[i] = -1;
	}

	if( arr[PAGE_SIZE*1024*3] !=  -1)  panic("PLACEMENT of stack page failed");
  800590:	8a 85 a4 ff bf ff    	mov    -0x40005c(%ebp),%al
  800596:	3c ff                	cmp    $0xff,%al
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 48 21 80 00       	push   $0x802148
  8005a2:	6a 78                	push   $0x78
  8005a4:	68 bc 20 80 00       	push   $0x8020bc
  8005a9:	e8 be 01 00 00       	call   80076c <_panic>
	if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8005ae:	8a 85 a4 0f c0 ff    	mov    -0x3ff05c(%ebp),%al
  8005b4:	3c ff                	cmp    $0xff,%al
  8005b6:	74 14                	je     8005cc <_main+0x594>
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 48 21 80 00       	push   $0x802148
  8005c0:	6a 79                	push   $0x79
  8005c2:	68 bc 20 80 00       	push   $0x8020bc
  8005c7:	e8 a0 01 00 00       	call   80076c <_panic>

	expectedPages[18] = 0xee7fd000;
  8005cc:	c7 85 88 ff ff fe 00 	movl   $0xee7fd000,-0x1000078(%ebp)
  8005d3:	d0 7f ee 
	expectedPages[19] = 0xee7fe000;
  8005d6:	c7 85 8c ff ff fe 00 	movl   $0xee7fe000,-0x1000074(%ebp)
  8005dd:	e0 7f ee 

	CheckWSWithoutLastIndex(expectedPages, 20);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	6a 14                	push   $0x14
  8005e5:	8d 85 40 ff ff fe    	lea    -0x10000c0(%ebp),%eax
  8005eb:	50                   	push   %eax
  8005ec:	e8 ed 01 00 00       	call   8007de <CheckWSWithoutLastIndex>
  8005f1:	83 c4 10             	add    $0x10,%esp

	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

}
cprintf("STEP C passed: WS is FULL now\n\n\n");
  8005f4:	83 ec 0c             	sub    $0xc,%esp
  8005f7:	68 74 22 80 00       	push   $0x802274
  8005fc:	e8 1f 04 00 00       	call   800a20 <cprintf>
  800601:	83 c4 10             	add    $0x10,%esp

cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  800604:	83 ec 0c             	sub    $0xc,%esp
  800607:	68 98 22 80 00       	push   $0x802298
  80060c:	e8 0f 04 00 00       	call   800a20 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
return;
  800614:	90                   	nop
}
  800615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800618:	5b                   	pop    %ebx
  800619:	5e                   	pop    %esi
  80061a:	5f                   	pop    %edi
  80061b:	5d                   	pop    %ebp
  80061c:	c3                   	ret    

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 4e 15 00 00       	call   801b76 <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	01 d0                	add    %edx,%eax
  800634:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80063b:	01 c8                	add    %ecx,%eax
  80063d:	c1 e0 02             	shl    $0x2,%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800649:	01 c8                	add    %ecx,%eax
  80064b:	c1 e0 02             	shl    $0x2,%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	c1 e0 02             	shl    $0x2,%eax
  800653:	01 d0                	add    %edx,%eax
  800655:	c1 e0 03             	shl    $0x3,%eax
  800658:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80065d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800662:	a1 20 30 80 00       	mov    0x803020,%eax
  800667:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80066d:	84 c0                	test   %al,%al
  80066f:	74 0f                	je     800680 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800671:	a1 20 30 80 00       	mov    0x803020,%eax
  800676:	05 18 da 01 00       	add    $0x1da18,%eax
  80067b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800680:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800684:	7e 0a                	jle    800690 <libmain+0x73>
		binaryname = argv[0];
  800686:	8b 45 0c             	mov    0xc(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	ff 75 08             	pushl  0x8(%ebp)
  800699:	e8 9a f9 ff ff       	call   800038 <_main>
  80069e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006a1:	e8 dd 12 00 00       	call   801983 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	68 68 23 80 00       	push   $0x802368
  8006ae:	e8 6d 03 00 00       	call   800a20 <cprintf>
  8006b3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bb:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8006c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c6:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	52                   	push   %edx
  8006d0:	50                   	push   %eax
  8006d1:	68 90 23 80 00       	push   $0x802390
  8006d6:	e8 45 03 00 00       	call   800a20 <cprintf>
  8006db:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006de:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e3:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8006e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ee:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8006f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8006f9:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8006ff:	51                   	push   %ecx
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	68 b8 23 80 00       	push   $0x8023b8
  800707:	e8 14 03 00 00       	call   800a20 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80070f:	a1 20 30 80 00       	mov    0x803020,%eax
  800714:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	50                   	push   %eax
  80071e:	68 10 24 80 00       	push   $0x802410
  800723:	e8 f8 02 00 00       	call   800a20 <cprintf>
  800728:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	68 68 23 80 00       	push   $0x802368
  800733:	e8 e8 02 00 00       	call   800a20 <cprintf>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 5d 12 00 00       	call   80199d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800740:	e8 19 00 00 00       	call   80075e <exit>
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	6a 00                	push   $0x0
  800753:	e8 ea 13 00 00       	call   801b42 <sys_destroy_env>
  800758:	83 c4 10             	add    $0x10,%esp
}
  80075b:	90                   	nop
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    

0080075e <exit>:

void
exit(void)
{
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800764:	e8 3f 14 00 00       	call   801ba8 <sys_exit_env>
}
  800769:	90                   	nop
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800772:	8d 45 10             	lea    0x10(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80077b:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800780:	85 c0                	test   %eax,%eax
  800782:	74 16                	je     80079a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800784:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	50                   	push   %eax
  80078d:	68 24 24 80 00       	push   $0x802424
  800792:	e8 89 02 00 00       	call   800a20 <cprintf>
  800797:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80079a:	a1 00 30 80 00       	mov    0x803000,%eax
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	50                   	push   %eax
  8007a6:	68 29 24 80 00       	push   $0x802429
  8007ab:	e8 70 02 00 00       	call   800a20 <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 f3 01 00 00       	call   8009b5 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	6a 00                	push   $0x0
  8007ca:	68 45 24 80 00       	push   $0x802445
  8007cf:	e8 e1 01 00 00       	call   8009b5 <vcprintf>
  8007d4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007d7:	e8 82 ff ff ff       	call   80075e <exit>

	// should not return here
	while (1) ;
  8007dc:	eb fe                	jmp    8007dc <_panic+0x70>

008007de <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e9:	8b 50 74             	mov    0x74(%eax),%edx
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ef:	39 c2                	cmp    %eax,%edx
  8007f1:	74 14                	je     800807 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	68 48 24 80 00       	push   $0x802448
  8007fb:	6a 26                	push   $0x26
  8007fd:	68 94 24 80 00       	push   $0x802494
  800802:	e8 65 ff ff ff       	call   80076c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80080e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800815:	e9 c2 00 00 00       	jmp    8008dc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	01 d0                	add    %edx,%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	85 c0                	test   %eax,%eax
  80082d:	75 08                	jne    800837 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80082f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800832:	e9 a2 00 00 00       	jmp    8008d9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800837:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800845:	eb 69                	jmp    8008b0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800847:	a1 20 30 80 00       	mov    0x803020,%eax
  80084c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800852:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800855:	89 d0                	mov    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d0                	add    %edx,%eax
  80085b:	c1 e0 03             	shl    $0x3,%eax
  80085e:	01 c8                	add    %ecx,%eax
  800860:	8a 40 04             	mov    0x4(%eax),%al
  800863:	84 c0                	test   %al,%al
  800865:	75 46                	jne    8008ad <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800867:	a1 20 30 80 00       	mov    0x803020,%eax
  80086c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800872:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800875:	89 d0                	mov    %edx,%eax
  800877:	01 c0                	add    %eax,%eax
  800879:	01 d0                	add    %edx,%eax
  80087b:	c1 e0 03             	shl    $0x3,%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800885:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80088f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800892:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	01 c8                	add    %ecx,%eax
  80089e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008a0:	39 c2                	cmp    %eax,%edx
  8008a2:	75 09                	jne    8008ad <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008a4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008ab:	eb 12                	jmp    8008bf <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ad:	ff 45 e8             	incl   -0x18(%ebp)
  8008b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 88                	ja     800847 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008c3:	75 14                	jne    8008d9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 a0 24 80 00       	push   $0x8024a0
  8008cd:	6a 3a                	push   $0x3a
  8008cf:	68 94 24 80 00       	push   $0x802494
  8008d4:	e8 93 fe ff ff       	call   80076c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008d9:	ff 45 f0             	incl   -0x10(%ebp)
  8008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e2:	0f 8c 32 ff ff ff    	jl     80081a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008f6:	eb 26                	jmp    80091e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8008fd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800903:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800906:	89 d0                	mov    %edx,%eax
  800908:	01 c0                	add    %eax,%eax
  80090a:	01 d0                	add    %edx,%eax
  80090c:	c1 e0 03             	shl    $0x3,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	8a 40 04             	mov    0x4(%eax),%al
  800914:	3c 01                	cmp    $0x1,%al
  800916:	75 03                	jne    80091b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800918:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091b:	ff 45 e0             	incl   -0x20(%ebp)
  80091e:	a1 20 30 80 00       	mov    0x803020,%eax
  800923:	8b 50 74             	mov    0x74(%eax),%edx
  800926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	77 cb                	ja     8008f8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80092d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800930:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800933:	74 14                	je     800949 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800935:	83 ec 04             	sub    $0x4,%esp
  800938:	68 f4 24 80 00       	push   $0x8024f4
  80093d:	6a 44                	push   $0x44
  80093f:	68 94 24 80 00       	push   $0x802494
  800944:	e8 23 fe ff ff       	call   80076c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800949:	90                   	nop
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	8d 48 01             	lea    0x1(%eax),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095d:	89 0a                	mov    %ecx,(%edx)
  80095f:	8b 55 08             	mov    0x8(%ebp),%edx
  800962:	88 d1                	mov    %dl,%cl
  800964:	8b 55 0c             	mov    0xc(%ebp),%edx
  800967:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80096b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	3d ff 00 00 00       	cmp    $0xff,%eax
  800975:	75 2c                	jne    8009a3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800977:	a0 24 30 80 00       	mov    0x803024,%al
  80097c:	0f b6 c0             	movzbl %al,%eax
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	8b 12                	mov    (%edx),%edx
  800984:	89 d1                	mov    %edx,%ecx
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	83 c2 08             	add    $0x8,%edx
  80098c:	83 ec 04             	sub    $0x4,%esp
  80098f:	50                   	push   %eax
  800990:	51                   	push   %ecx
  800991:	52                   	push   %edx
  800992:	e8 3e 0e 00 00       	call   8017d5 <sys_cputs>
  800997:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 40 04             	mov    0x4(%eax),%eax
  8009a9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009b2:	90                   	nop
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009c5:	00 00 00 
	b.cnt = 0;
  8009c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	ff 75 08             	pushl  0x8(%ebp)
  8009d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009de:	50                   	push   %eax
  8009df:	68 4c 09 80 00       	push   $0x80094c
  8009e4:	e8 11 02 00 00       	call   800bfa <vprintfmt>
  8009e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009ec:	a0 24 30 80 00       	mov    0x803024,%al
  8009f1:	0f b6 c0             	movzbl %al,%eax
  8009f4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	50                   	push   %eax
  8009fe:	52                   	push   %edx
  8009ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a05:	83 c0 08             	add    $0x8,%eax
  800a08:	50                   	push   %eax
  800a09:	e8 c7 0d 00 00       	call   8017d5 <sys_cputs>
  800a0e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a11:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800a18:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a26:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800a2d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	e8 73 ff ff ff       	call   8009b5 <vcprintf>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a53:	e8 2b 0f 00 00       	call   801983 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a58:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 f4             	pushl  -0xc(%ebp)
  800a67:	50                   	push   %eax
  800a68:	e8 48 ff ff ff       	call   8009b5 <vcprintf>
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a73:	e8 25 0f 00 00       	call   80199d <sys_enable_interrupt>
	return cnt;
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	53                   	push   %ebx
  800a81:	83 ec 14             	sub    $0x14,%esp
  800a84:	8b 45 10             	mov    0x10(%ebp),%eax
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a90:	8b 45 18             	mov    0x18(%ebp),%eax
  800a93:	ba 00 00 00 00       	mov    $0x0,%edx
  800a98:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a9b:	77 55                	ja     800af2 <printnum+0x75>
  800a9d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aa0:	72 05                	jb     800aa7 <printnum+0x2a>
  800aa2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aa5:	77 4b                	ja     800af2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800aa7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800aaa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800aad:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	52                   	push   %edx
  800ab6:	50                   	push   %eax
  800ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  800aba:	ff 75 f0             	pushl  -0x10(%ebp)
  800abd:	e8 46 13 00 00       	call   801e08 <__udivdi3>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	ff 75 20             	pushl  0x20(%ebp)
  800acb:	53                   	push   %ebx
  800acc:	ff 75 18             	pushl  0x18(%ebp)
  800acf:	52                   	push   %edx
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 08             	pushl  0x8(%ebp)
  800ad7:	e8 a1 ff ff ff       	call   800a7d <printnum>
  800adc:	83 c4 20             	add    $0x20,%esp
  800adf:	eb 1a                	jmp    800afb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 20             	pushl  0x20(%ebp)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800af2:	ff 4d 1c             	decl   0x1c(%ebp)
  800af5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800af9:	7f e6                	jg     800ae1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800afb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800afe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b09:	53                   	push   %ebx
  800b0a:	51                   	push   %ecx
  800b0b:	52                   	push   %edx
  800b0c:	50                   	push   %eax
  800b0d:	e8 06 14 00 00       	call   801f18 <__umoddi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	05 54 27 80 00       	add    $0x802754,%eax
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	0f be c0             	movsbl %al,%eax
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	50                   	push   %eax
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
}
  800b2e:	90                   	nop
  800b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b37:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b3b:	7e 1c                	jle    800b59 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	8d 50 08             	lea    0x8(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	89 10                	mov    %edx,(%eax)
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8b 00                	mov    (%eax),%eax
  800b4f:	83 e8 08             	sub    $0x8,%eax
  800b52:	8b 50 04             	mov    0x4(%eax),%edx
  800b55:	8b 00                	mov    (%eax),%eax
  800b57:	eb 40                	jmp    800b99 <getuint+0x65>
	else if (lflag)
  800b59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5d:	74 1e                	je     800b7d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	8d 50 04             	lea    0x4(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	89 10                	mov    %edx,(%eax)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	83 e8 04             	sub    $0x4,%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	eb 1c                	jmp    800b99 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	8d 50 04             	lea    0x4(%eax),%edx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	89 10                	mov    %edx,(%eax)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	83 e8 04             	sub    $0x4,%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b9e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ba2:	7e 1c                	jle    800bc0 <getint+0x25>
		return va_arg(*ap, long long);
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	8d 50 08             	lea    0x8(%eax),%edx
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 10                	mov    %edx,(%eax)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	83 e8 08             	sub    $0x8,%eax
  800bb9:	8b 50 04             	mov    0x4(%eax),%edx
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	eb 38                	jmp    800bf8 <getint+0x5d>
	else if (lflag)
  800bc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc4:	74 1a                	je     800be0 <getint+0x45>
		return va_arg(*ap, long);
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	8d 50 04             	lea    0x4(%eax),%edx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	89 10                	mov    %edx,(%eax)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	83 e8 04             	sub    $0x4,%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	99                   	cltd   
  800bde:	eb 18                	jmp    800bf8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	8d 50 04             	lea    0x4(%eax),%edx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	89 10                	mov    %edx,(%eax)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	83 e8 04             	sub    $0x4,%eax
  800bf5:	8b 00                	mov    (%eax),%eax
  800bf7:	99                   	cltd   
}
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c02:	eb 17                	jmp    800c1b <vprintfmt+0x21>
			if (ch == '\0')
  800c04:	85 db                	test   %ebx,%ebx
  800c06:	0f 84 af 03 00 00    	je     800fbb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	53                   	push   %ebx
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	8d 50 01             	lea    0x1(%eax),%edx
  800c21:	89 55 10             	mov    %edx,0x10(%ebp)
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d8             	movzbl %al,%ebx
  800c29:	83 fb 25             	cmp    $0x25,%ebx
  800c2c:	75 d6                	jne    800c04 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c2e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c32:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c39:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 10             	mov    %edx,0x10(%ebp)
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f b6 d8             	movzbl %al,%ebx
  800c5c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c5f:	83 f8 55             	cmp    $0x55,%eax
  800c62:	0f 87 2b 03 00 00    	ja     800f93 <vprintfmt+0x399>
  800c68:	8b 04 85 78 27 80 00 	mov    0x802778(,%eax,4),%eax
  800c6f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c71:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c75:	eb d7                	jmp    800c4e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c77:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c7b:	eb d1                	jmp    800c4e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c7d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c87:	89 d0                	mov    %edx,%eax
  800c89:	c1 e0 02             	shl    $0x2,%eax
  800c8c:	01 d0                	add    %edx,%eax
  800c8e:	01 c0                	add    %eax,%eax
  800c90:	01 d8                	add    %ebx,%eax
  800c92:	83 e8 30             	sub    $0x30,%eax
  800c95:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c98:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ca0:	83 fb 2f             	cmp    $0x2f,%ebx
  800ca3:	7e 3e                	jle    800ce3 <vprintfmt+0xe9>
  800ca5:	83 fb 39             	cmp    $0x39,%ebx
  800ca8:	7f 39                	jg     800ce3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800caa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cad:	eb d5                	jmp    800c84 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800caf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb2:	83 c0 04             	add    $0x4,%eax
  800cb5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbb:	83 e8 04             	sub    $0x4,%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cc3:	eb 1f                	jmp    800ce4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc9:	79 83                	jns    800c4e <vprintfmt+0x54>
				width = 0;
  800ccb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cd2:	e9 77 ff ff ff       	jmp    800c4e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cd7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cde:	e9 6b ff ff ff       	jmp    800c4e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ce3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ce4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ce8:	0f 89 60 ff ff ff    	jns    800c4e <vprintfmt+0x54>
				width = precision, precision = -1;
  800cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cf4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cfb:	e9 4e ff ff ff       	jmp    800c4e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d00:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d03:	e9 46 ff ff ff       	jmp    800c4e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 c0 04             	add    $0x4,%eax
  800d0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d11:	8b 45 14             	mov    0x14(%ebp),%eax
  800d14:	83 e8 04             	sub    $0x4,%eax
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			break;
  800d28:	e9 89 02 00 00       	jmp    800fb6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d3e:	85 db                	test   %ebx,%ebx
  800d40:	79 02                	jns    800d44 <vprintfmt+0x14a>
				err = -err;
  800d42:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d44:	83 fb 64             	cmp    $0x64,%ebx
  800d47:	7f 0b                	jg     800d54 <vprintfmt+0x15a>
  800d49:	8b 34 9d c0 25 80 00 	mov    0x8025c0(,%ebx,4),%esi
  800d50:	85 f6                	test   %esi,%esi
  800d52:	75 19                	jne    800d6d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d54:	53                   	push   %ebx
  800d55:	68 65 27 80 00       	push   $0x802765
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	ff 75 08             	pushl  0x8(%ebp)
  800d60:	e8 5e 02 00 00       	call   800fc3 <printfmt>
  800d65:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d68:	e9 49 02 00 00       	jmp    800fb6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d6d:	56                   	push   %esi
  800d6e:	68 6e 27 80 00       	push   $0x80276e
  800d73:	ff 75 0c             	pushl  0xc(%ebp)
  800d76:	ff 75 08             	pushl  0x8(%ebp)
  800d79:	e8 45 02 00 00       	call   800fc3 <printfmt>
  800d7e:	83 c4 10             	add    $0x10,%esp
			break;
  800d81:	e9 30 02 00 00       	jmp    800fb6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 c0 04             	add    $0x4,%eax
  800d8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 30                	mov    (%eax),%esi
  800d97:	85 f6                	test   %esi,%esi
  800d99:	75 05                	jne    800da0 <vprintfmt+0x1a6>
				p = "(null)";
  800d9b:	be 71 27 80 00       	mov    $0x802771,%esi
			if (width > 0 && padc != '-')
  800da0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da4:	7e 6d                	jle    800e13 <vprintfmt+0x219>
  800da6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800daa:	74 67                	je     800e13 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daf:	83 ec 08             	sub    $0x8,%esp
  800db2:	50                   	push   %eax
  800db3:	56                   	push   %esi
  800db4:	e8 0c 03 00 00       	call   8010c5 <strnlen>
  800db9:	83 c4 10             	add    $0x10,%esp
  800dbc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dbf:	eb 16                	jmp    800dd7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dc1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	50                   	push   %eax
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd4:	ff 4d e4             	decl   -0x1c(%ebp)
  800dd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddb:	7f e4                	jg     800dc1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddd:	eb 34                	jmp    800e13 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ddf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800de3:	74 1c                	je     800e01 <vprintfmt+0x207>
  800de5:	83 fb 1f             	cmp    $0x1f,%ebx
  800de8:	7e 05                	jle    800def <vprintfmt+0x1f5>
  800dea:	83 fb 7e             	cmp    $0x7e,%ebx
  800ded:	7e 12                	jle    800e01 <vprintfmt+0x207>
					putch('?', putdat);
  800def:	83 ec 08             	sub    $0x8,%esp
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	6a 3f                	push   $0x3f
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	ff d0                	call   *%eax
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	eb 0f                	jmp    800e10 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	53                   	push   %ebx
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	ff d0                	call   *%eax
  800e0d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e10:	ff 4d e4             	decl   -0x1c(%ebp)
  800e13:	89 f0                	mov    %esi,%eax
  800e15:	8d 70 01             	lea    0x1(%eax),%esi
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	0f be d8             	movsbl %al,%ebx
  800e1d:	85 db                	test   %ebx,%ebx
  800e1f:	74 24                	je     800e45 <vprintfmt+0x24b>
  800e21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e25:	78 b8                	js     800ddf <vprintfmt+0x1e5>
  800e27:	ff 4d e0             	decl   -0x20(%ebp)
  800e2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e2e:	79 af                	jns    800ddf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e30:	eb 13                	jmp    800e45 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	6a 20                	push   $0x20
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	ff d0                	call   *%eax
  800e3f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e42:	ff 4d e4             	decl   -0x1c(%ebp)
  800e45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e49:	7f e7                	jg     800e32 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e4b:	e9 66 01 00 00       	jmp    800fb6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 e8             	pushl  -0x18(%ebp)
  800e56:	8d 45 14             	lea    0x14(%ebp),%eax
  800e59:	50                   	push   %eax
  800e5a:	e8 3c fd ff ff       	call   800b9b <getint>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6e:	85 d2                	test   %edx,%edx
  800e70:	79 23                	jns    800e95 <vprintfmt+0x29b>
				putch('-', putdat);
  800e72:	83 ec 08             	sub    $0x8,%esp
  800e75:	ff 75 0c             	pushl  0xc(%ebp)
  800e78:	6a 2d                	push   $0x2d
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	ff d0                	call   *%eax
  800e7f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e88:	f7 d8                	neg    %eax
  800e8a:	83 d2 00             	adc    $0x0,%edx
  800e8d:	f7 da                	neg    %edx
  800e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e9c:	e9 bc 00 00 00       	jmp    800f5d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 84 fc ff ff       	call   800b34 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800eb9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec0:	e9 98 00 00 00       	jmp    800f5d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	6a 58                	push   $0x58
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	ff d0                	call   *%eax
  800ed2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	6a 58                	push   $0x58
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	ff d0                	call   *%eax
  800ee2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	6a 58                	push   $0x58
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	ff d0                	call   *%eax
  800ef2:	83 c4 10             	add    $0x10,%esp
			break;
  800ef5:	e9 bc 00 00 00       	jmp    800fb6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 30                	push   $0x30
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 78                	push   $0x78
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1d:	83 c0 04             	add    $0x4,%eax
  800f20:	89 45 14             	mov    %eax,0x14(%ebp)
  800f23:	8b 45 14             	mov    0x14(%ebp),%eax
  800f26:	83 e8 04             	sub    $0x4,%eax
  800f29:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f3c:	eb 1f                	jmp    800f5d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f3e:	83 ec 08             	sub    $0x8,%esp
  800f41:	ff 75 e8             	pushl  -0x18(%ebp)
  800f44:	8d 45 14             	lea    0x14(%ebp),%eax
  800f47:	50                   	push   %eax
  800f48:	e8 e7 fb ff ff       	call   800b34 <getuint>
  800f4d:	83 c4 10             	add    $0x10,%esp
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f5d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	52                   	push   %edx
  800f68:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	ff 75 08             	pushl  0x8(%ebp)
  800f78:	e8 00 fb ff ff       	call   800a7d <printnum>
  800f7d:	83 c4 20             	add    $0x20,%esp
			break;
  800f80:	eb 34                	jmp    800fb6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f82:	83 ec 08             	sub    $0x8,%esp
  800f85:	ff 75 0c             	pushl  0xc(%ebp)
  800f88:	53                   	push   %ebx
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	ff d0                	call   *%eax
  800f8e:	83 c4 10             	add    $0x10,%esp
			break;
  800f91:	eb 23                	jmp    800fb6 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	6a 25                	push   $0x25
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	ff d0                	call   *%eax
  800fa0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fa3:	ff 4d 10             	decl   0x10(%ebp)
  800fa6:	eb 03                	jmp    800fab <vprintfmt+0x3b1>
  800fa8:	ff 4d 10             	decl   0x10(%ebp)
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	48                   	dec    %eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 25                	cmp    $0x25,%al
  800fb3:	75 f3                	jne    800fa8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fb5:	90                   	nop
		}
	}
  800fb6:	e9 47 fc ff ff       	jmp    800c02 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fbb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	ff 75 08             	pushl  0x8(%ebp)
  800fdf:	e8 16 fc ff ff       	call   800bfa <vprintfmt>
  800fe4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fe7:	90                   	nop
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	8b 40 08             	mov    0x8(%eax),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	8b 10                	mov    (%eax),%edx
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 04             	mov    0x4(%eax),%eax
  801007:	39 c2                	cmp    %eax,%edx
  801009:	73 12                	jae    80101d <sprintputch+0x33>
		*b->buf++ = ch;
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	8b 00                	mov    (%eax),%eax
  801010:	8d 48 01             	lea    0x1(%eax),%ecx
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	89 0a                	mov    %ecx,(%edx)
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	88 10                	mov    %dl,(%eax)
}
  80101d:	90                   	nop
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	01 d0                	add    %edx,%eax
  801037:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801041:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801045:	74 06                	je     80104d <vsnprintf+0x2d>
  801047:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104b:	7f 07                	jg     801054 <vsnprintf+0x34>
		return -E_INVAL;
  80104d:	b8 03 00 00 00       	mov    $0x3,%eax
  801052:	eb 20                	jmp    801074 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801054:	ff 75 14             	pushl  0x14(%ebp)
  801057:	ff 75 10             	pushl  0x10(%ebp)
  80105a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80105d:	50                   	push   %eax
  80105e:	68 ea 0f 80 00       	push   $0x800fea
  801063:	e8 92 fb ff ff       	call   800bfa <vprintfmt>
  801068:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80106b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80106e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801071:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80107c:	8d 45 10             	lea    0x10(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	50                   	push   %eax
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 89 ff ff ff       	call   801020 <vsnprintf>
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80109d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010af:	eb 06                	jmp    8010b7 <strlen+0x15>
		n++;
  8010b1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b4:	ff 45 08             	incl   0x8(%ebp)
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 f1                	jne    8010b1 <strlen+0xf>
		n++;
	return n;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d2:	eb 09                	jmp    8010dd <strnlen+0x18>
		n++;
  8010d4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	ff 4d 0c             	decl   0xc(%ebp)
  8010dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e1:	74 09                	je     8010ec <strnlen+0x27>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	84 c0                	test   %al,%al
  8010ea:	75 e8                	jne    8010d4 <strnlen+0xf>
		n++;
	return n;
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010fd:	90                   	nop
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 08             	mov    %edx,0x8(%ebp)
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801110:	8a 12                	mov    (%edx),%dl
  801112:	88 10                	mov    %dl,(%eax)
  801114:	8a 00                	mov    (%eax),%al
  801116:	84 c0                	test   %al,%al
  801118:	75 e4                	jne    8010fe <strcpy+0xd>
		/* do nothing */;
	return ret;
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80112b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801132:	eb 1f                	jmp    801153 <strncpy+0x34>
		*dst++ = *src;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 08             	mov    %edx,0x8(%ebp)
  80113d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	74 03                	je     801150 <strncpy+0x31>
			src++;
  80114d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801150:	ff 45 fc             	incl   -0x4(%ebp)
  801153:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801156:	3b 45 10             	cmp    0x10(%ebp),%eax
  801159:	72 d9                	jb     801134 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80116c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801170:	74 30                	je     8011a2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801172:	eb 16                	jmp    80118a <strlcpy+0x2a>
			*dst++ = *src++;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8d 50 01             	lea    0x1(%eax),%edx
  80117a:	89 55 08             	mov    %edx,0x8(%ebp)
  80117d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801180:	8d 4a 01             	lea    0x1(%edx),%ecx
  801183:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801186:	8a 12                	mov    (%edx),%dl
  801188:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80118a:	ff 4d 10             	decl   0x10(%ebp)
  80118d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801191:	74 09                	je     80119c <strlcpy+0x3c>
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	84 c0                	test   %al,%al
  80119a:	75 d8                	jne    801174 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a8:	29 c2                	sub    %eax,%edx
  8011aa:	89 d0                	mov    %edx,%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011b1:	eb 06                	jmp    8011b9 <strcmp+0xb>
		p++, q++;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	74 0e                	je     8011d0 <strcmp+0x22>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 10                	mov    (%eax),%dl
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	38 c2                	cmp    %al,%dl
  8011ce:	74 e3                	je     8011b3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011e9:	eb 09                	jmp    8011f4 <strncmp+0xe>
		n--, p++, q++;
  8011eb:	ff 4d 10             	decl   0x10(%ebp)
  8011ee:	ff 45 08             	incl   0x8(%ebp)
  8011f1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f8:	74 17                	je     801211 <strncmp+0x2b>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	74 0e                	je     801211 <strncmp+0x2b>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 10                	mov    (%eax),%dl
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	38 c2                	cmp    %al,%dl
  80120f:	74 da                	je     8011eb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801211:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801215:	75 07                	jne    80121e <strncmp+0x38>
		return 0;
  801217:	b8 00 00 00 00       	mov    $0x0,%eax
  80121c:	eb 14                	jmp    801232 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f b6 d0             	movzbl %al,%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	29 c2                	sub    %eax,%edx
  801230:	89 d0                	mov    %edx,%eax
}
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    

00801234 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801240:	eb 12                	jmp    801254 <strchr+0x20>
		if (*s == c)
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80124a:	75 05                	jne    801251 <strchr+0x1d>
			return (char *) s;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	eb 11                	jmp    801262 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801251:	ff 45 08             	incl   0x8(%ebp)
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	75 e5                	jne    801242 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801270:	eb 0d                	jmp    80127f <strfind+0x1b>
		if (*s == c)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80127a:	74 0e                	je     80128a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	75 ea                	jne    801272 <strfind+0xe>
  801288:	eb 01                	jmp    80128b <strfind+0x27>
		if (*s == c)
			break;
  80128a:	90                   	nop
	return (char *) s;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012a2:	eb 0e                	jmp    8012b2 <memset+0x22>
		*p++ = c;
  8012a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012b2:	ff 4d f8             	decl   -0x8(%ebp)
  8012b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012b9:	79 e9                	jns    8012a4 <memset+0x14>
		*p++ = c;

	return v;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012d2:	eb 16                	jmp    8012ea <memcpy+0x2a>
		*d++ = *s++;
  8012d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e6:	8a 12                	mov    (%edx),%dl
  8012e8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	75 dd                	jne    8012d4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801302:	8b 45 0c             	mov    0xc(%ebp),%eax
  801305:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801314:	73 50                	jae    801366 <memmove+0x6a>
  801316:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801321:	76 43                	jbe    801366 <memmove+0x6a>
		s += n;
  801323:	8b 45 10             	mov    0x10(%ebp),%eax
  801326:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80132f:	eb 10                	jmp    801341 <memmove+0x45>
			*--d = *--s;
  801331:	ff 4d f8             	decl   -0x8(%ebp)
  801334:	ff 4d fc             	decl   -0x4(%ebp)
  801337:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133a:	8a 10                	mov    (%eax),%dl
  80133c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	8d 50 ff             	lea    -0x1(%eax),%edx
  801347:	89 55 10             	mov    %edx,0x10(%ebp)
  80134a:	85 c0                	test   %eax,%eax
  80134c:	75 e3                	jne    801331 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80134e:	eb 23                	jmp    801373 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	8d 50 01             	lea    0x1(%eax),%edx
  801356:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801359:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801362:	8a 12                	mov    (%edx),%dl
  801364:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136c:	89 55 10             	mov    %edx,0x10(%ebp)
  80136f:	85 c0                	test   %eax,%eax
  801371:	75 dd                	jne    801350 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80138a:	eb 2a                	jmp    8013b6 <memcmp+0x3e>
		if (*s1 != *s2)
  80138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138f:	8a 10                	mov    (%eax),%dl
  801391:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	38 c2                	cmp    %al,%dl
  801398:	74 16                	je     8013b0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80139a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	0f b6 d0             	movzbl %al,%edx
  8013a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f b6 c0             	movzbl %al,%eax
  8013aa:	29 c2                	sub    %eax,%edx
  8013ac:	89 d0                	mov    %edx,%eax
  8013ae:	eb 18                	jmp    8013c8 <memcmp+0x50>
		s1++, s2++;
  8013b0:	ff 45 fc             	incl   -0x4(%ebp)
  8013b3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 c9                	jne    80138c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013db:	eb 15                	jmp    8013f2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	0f b6 d0             	movzbl %al,%edx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	0f b6 c0             	movzbl %al,%eax
  8013eb:	39 c2                	cmp    %eax,%edx
  8013ed:	74 0d                	je     8013fc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ef:	ff 45 08             	incl   0x8(%ebp)
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013f8:	72 e3                	jb     8013dd <memfind+0x13>
  8013fa:	eb 01                	jmp    8013fd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013fc:	90                   	nop
	return (void *) s;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80140f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801416:	eb 03                	jmp    80141b <strtol+0x19>
		s++;
  801418:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	3c 20                	cmp    $0x20,%al
  801422:	74 f4                	je     801418 <strtol+0x16>
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	3c 09                	cmp    $0x9,%al
  80142b:	74 eb                	je     801418 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 2b                	cmp    $0x2b,%al
  801434:	75 05                	jne    80143b <strtol+0x39>
		s++;
  801436:	ff 45 08             	incl   0x8(%ebp)
  801439:	eb 13                	jmp    80144e <strtol+0x4c>
	else if (*s == '-')
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	3c 2d                	cmp    $0x2d,%al
  801442:	75 0a                	jne    80144e <strtol+0x4c>
		s++, neg = 1;
  801444:	ff 45 08             	incl   0x8(%ebp)
  801447:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80144e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801452:	74 06                	je     80145a <strtol+0x58>
  801454:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801458:	75 20                	jne    80147a <strtol+0x78>
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	3c 30                	cmp    $0x30,%al
  801461:	75 17                	jne    80147a <strtol+0x78>
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	40                   	inc    %eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 78                	cmp    $0x78,%al
  80146b:	75 0d                	jne    80147a <strtol+0x78>
		s += 2, base = 16;
  80146d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801471:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801478:	eb 28                	jmp    8014a2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80147a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147e:	75 15                	jne    801495 <strtol+0x93>
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3c 30                	cmp    $0x30,%al
  801487:	75 0c                	jne    801495 <strtol+0x93>
		s++, base = 8;
  801489:	ff 45 08             	incl   0x8(%ebp)
  80148c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801493:	eb 0d                	jmp    8014a2 <strtol+0xa0>
	else if (base == 0)
  801495:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801499:	75 07                	jne    8014a2 <strtol+0xa0>
		base = 10;
  80149b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	3c 2f                	cmp    $0x2f,%al
  8014a9:	7e 19                	jle    8014c4 <strtol+0xc2>
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 39                	cmp    $0x39,%al
  8014b2:	7f 10                	jg     8014c4 <strtol+0xc2>
			dig = *s - '0';
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	0f be c0             	movsbl %al,%eax
  8014bc:	83 e8 30             	sub    $0x30,%eax
  8014bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c2:	eb 42                	jmp    801506 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3c 60                	cmp    $0x60,%al
  8014cb:	7e 19                	jle    8014e6 <strtol+0xe4>
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	3c 7a                	cmp    $0x7a,%al
  8014d4:	7f 10                	jg     8014e6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	0f be c0             	movsbl %al,%eax
  8014de:	83 e8 57             	sub    $0x57,%eax
  8014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e4:	eb 20                	jmp    801506 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	3c 40                	cmp    $0x40,%al
  8014ed:	7e 39                	jle    801528 <strtol+0x126>
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	3c 5a                	cmp    $0x5a,%al
  8014f6:	7f 30                	jg     801528 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	0f be c0             	movsbl %al,%eax
  801500:	83 e8 37             	sub    $0x37,%eax
  801503:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801509:	3b 45 10             	cmp    0x10(%ebp),%eax
  80150c:	7d 19                	jge    801527 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801514:	0f af 45 10          	imul   0x10(%ebp),%eax
  801518:	89 c2                	mov    %eax,%edx
  80151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801522:	e9 7b ff ff ff       	jmp    8014a2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801527:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80152c:	74 08                	je     801536 <strtol+0x134>
		*endptr = (char *) s;
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801536:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153a:	74 07                	je     801543 <strtol+0x141>
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	f7 d8                	neg    %eax
  801541:	eb 03                	jmp    801546 <strtol+0x144>
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <ltostr>:

void
ltostr(long value, char *str)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80154e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801555:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	79 13                	jns    801575 <ltostr+0x2d>
	{
		neg = 1;
  801562:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80156f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801572:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80157d:	99                   	cltd   
  80157e:	f7 f9                	idiv   %ecx
  801580:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801583:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801586:	8d 50 01             	lea    0x1(%eax),%edx
  801589:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801596:	83 c2 30             	add    $0x30,%edx
  801599:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80159b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a3:	f7 e9                	imul   %ecx
  8015a5:	c1 fa 02             	sar    $0x2,%edx
  8015a8:	89 c8                	mov    %ecx,%eax
  8015aa:	c1 f8 1f             	sar    $0x1f,%eax
  8015ad:	29 c2                	sub    %eax,%edx
  8015af:	89 d0                	mov    %edx,%eax
  8015b1:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015bc:	f7 e9                	imul   %ecx
  8015be:	c1 fa 02             	sar    $0x2,%edx
  8015c1:	89 c8                	mov    %ecx,%eax
  8015c3:	c1 f8 1f             	sar    $0x1f,%eax
  8015c6:	29 c2                	sub    %eax,%edx
  8015c8:	89 d0                	mov    %edx,%eax
  8015ca:	c1 e0 02             	shl    $0x2,%eax
  8015cd:	01 d0                	add    %edx,%eax
  8015cf:	01 c0                	add    %eax,%eax
  8015d1:	29 c1                	sub    %eax,%ecx
  8015d3:	89 ca                	mov    %ecx,%edx
  8015d5:	85 d2                	test   %edx,%edx
  8015d7:	75 9c                	jne    801575 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e3:	48                   	dec    %eax
  8015e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015eb:	74 3d                	je     80162a <ltostr+0xe2>
		start = 1 ;
  8015ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015f4:	eb 34                	jmp    80162a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	01 c2                	add    %eax,%edx
  80160b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80160e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801611:	01 c8                	add    %ecx,%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801617:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	01 c2                	add    %eax,%edx
  80161f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801622:	88 02                	mov    %al,(%edx)
		start++ ;
  801624:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801627:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801630:	7c c4                	jl     8015f6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801632:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 54 fa ff ff       	call   8010a2 <strlen>
  80164e:	83 c4 04             	add    $0x4,%esp
  801651:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	e8 46 fa ff ff       	call   8010a2 <strlen>
  80165c:	83 c4 04             	add    $0x4,%esp
  80165f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801662:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 17                	jmp    801689 <strcconcat+0x49>
		final[s] = str1[s] ;
  801672:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801675:	8b 45 10             	mov    0x10(%ebp),%eax
  801678:	01 c2                	add    %eax,%edx
  80167a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	01 c8                	add    %ecx,%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801686:	ff 45 fc             	incl   -0x4(%ebp)
  801689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80168f:	7c e1                	jl     801672 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801691:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801698:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80169f:	eb 1f                	jmp    8016c0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	8d 50 01             	lea    0x1(%eax),%edx
  8016a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016aa:	89 c2                	mov    %eax,%edx
  8016ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8016af:	01 c2                	add    %eax,%edx
  8016b1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b7:	01 c8                	add    %ecx,%eax
  8016b9:	8a 00                	mov    (%eax),%al
  8016bb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016bd:	ff 45 f8             	incl   -0x8(%ebp)
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c6:	7c d9                	jl     8016a1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	c6 00 00             	movb   $0x0,(%eax)
}
  8016d3:	90                   	nop
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f9:	eb 0c                	jmp    801707 <strsplit+0x31>
			*string++ = 0;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8d 50 01             	lea    0x1(%eax),%edx
  801701:	89 55 08             	mov    %edx,0x8(%ebp)
  801704:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	84 c0                	test   %al,%al
  80170e:	74 18                	je     801728 <strsplit+0x52>
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f be c0             	movsbl %al,%eax
  801718:	50                   	push   %eax
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	e8 13 fb ff ff       	call   801234 <strchr>
  801721:	83 c4 08             	add    $0x8,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	75 d3                	jne    8016fb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8a 00                	mov    (%eax),%al
  80172d:	84 c0                	test   %al,%al
  80172f:	74 5a                	je     80178b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801731:	8b 45 14             	mov    0x14(%ebp),%eax
  801734:	8b 00                	mov    (%eax),%eax
  801736:	83 f8 0f             	cmp    $0xf,%eax
  801739:	75 07                	jne    801742 <strsplit+0x6c>
		{
			return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	eb 66                	jmp    8017a8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801742:	8b 45 14             	mov    0x14(%ebp),%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	8d 48 01             	lea    0x1(%eax),%ecx
  80174a:	8b 55 14             	mov    0x14(%ebp),%edx
  80174d:	89 0a                	mov    %ecx,(%edx)
  80174f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801756:	8b 45 10             	mov    0x10(%ebp),%eax
  801759:	01 c2                	add    %eax,%edx
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801760:	eb 03                	jmp    801765 <strsplit+0x8f>
			string++;
  801762:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8a 00                	mov    (%eax),%al
  80176a:	84 c0                	test   %al,%al
  80176c:	74 8b                	je     8016f9 <strsplit+0x23>
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	0f be c0             	movsbl %al,%eax
  801776:	50                   	push   %eax
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	e8 b5 fa ff ff       	call   801234 <strchr>
  80177f:	83 c4 08             	add    $0x8,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	74 dc                	je     801762 <strsplit+0x8c>
			string++;
	}
  801786:	e9 6e ff ff ff       	jmp    8016f9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80178b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80178c:	8b 45 14             	mov    0x14(%ebp),%eax
  80178f:	8b 00                	mov    (%eax),%eax
  801791:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801798:	8b 45 10             	mov    0x10(%ebp),%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	57                   	push   %edi
  8017ae:	56                   	push   %esi
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017bf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017c2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017c5:	cd 30                	int    $0x30
  8017c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	5b                   	pop    %ebx
  8017d1:	5e                   	pop    %esi
  8017d2:	5f                   	pop    %edi
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    

008017d5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	50                   	push   %eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	e8 b2 ff ff ff       	call   8017aa <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	90                   	nop
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 01                	push   $0x1
  80180d:	e8 98 ff ff ff       	call   8017aa <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80181a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	52                   	push   %edx
  801827:	50                   	push   %eax
  801828:	6a 05                	push   $0x5
  80182a:	e8 7b ff ff ff       	call   8017aa <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801839:	8b 75 18             	mov    0x18(%ebp),%esi
  80183c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	51                   	push   %ecx
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	6a 06                	push   $0x6
  80184f:	e8 56 ff ff ff       	call   8017aa <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 07                	push   $0x7
  801871:	e8 34 ff ff ff       	call   8017aa <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 08                	push   $0x8
  80188c:	e8 19 ff ff ff       	call   8017aa <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 09                	push   $0x9
  8018a5:	e8 00 ff ff ff       	call   8017aa <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 0a                	push   $0xa
  8018be:	e8 e7 fe ff ff       	call   8017aa <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 0b                	push   $0xb
  8018d7:	e8 ce fe ff ff       	call   8017aa <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 0f                	push   $0xf
  8018f2:	e8 b3 fe ff ff       	call   8017aa <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
	return;
  8018fa:	90                   	nop
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 10                	push   $0x10
  80190e:	e8 97 fe ff ff       	call   8017aa <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return ;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	ff 75 10             	pushl  0x10(%ebp)
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	6a 11                	push   $0x11
  80192b:	e8 7a fe ff ff       	call   8017aa <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
	return ;
  801933:	90                   	nop
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 0c                	push   $0xc
  801945:	e8 60 fe ff ff       	call   8017aa <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 0d                	push   $0xd
  80195f:	e8 46 fe ff ff       	call   8017aa <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 0e                	push   $0xe
  801978:	e8 2d fe ff ff       	call   8017aa <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 13                	push   $0x13
  801992:	e8 13 fe ff ff       	call   8017aa <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	90                   	nop
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 14                	push   $0x14
  8019ac:	e8 f9 fd ff ff       	call   8017aa <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	90                   	nop
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	50                   	push   %eax
  8019d0:	6a 15                	push   $0x15
  8019d2:	e8 d3 fd ff ff       	call   8017aa <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 16                	push   $0x16
  8019ec:	e8 b9 fd ff ff       	call   8017aa <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	90                   	nop
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	6a 17                	push   $0x17
  801a09:	e8 9c fd ff ff       	call   8017aa <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	52                   	push   %edx
  801a23:	50                   	push   %eax
  801a24:	6a 1a                	push   $0x1a
  801a26:	e8 7f fd ff ff       	call   8017aa <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 18                	push   $0x18
  801a43:	e8 62 fd ff ff       	call   8017aa <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	90                   	nop
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	52                   	push   %edx
  801a5e:	50                   	push   %eax
  801a5f:	6a 19                	push   $0x19
  801a61:	e8 44 fd ff ff       	call   8017aa <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a78:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a7b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	51                   	push   %ecx
  801a85:	52                   	push   %edx
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	50                   	push   %eax
  801a8a:	6a 1b                	push   $0x1b
  801a8c:	e8 19 fd ff ff       	call   8017aa <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	52                   	push   %edx
  801aa6:	50                   	push   %eax
  801aa7:	6a 1c                	push   $0x1c
  801aa9:	e8 fc fc ff ff       	call   8017aa <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	51                   	push   %ecx
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 1d                	push   $0x1d
  801ac8:	e8 dd fc ff ff       	call   8017aa <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 1e                	push   $0x1e
  801ae5:	e8 c0 fc ff ff       	call   8017aa <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 1f                	push   $0x1f
  801afe:	e8 a7 fc ff ff       	call   8017aa <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 14             	pushl  0x14(%ebp)
  801b13:	ff 75 10             	pushl  0x10(%ebp)
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	50                   	push   %eax
  801b1a:	6a 20                	push   $0x20
  801b1c:	e8 89 fc ff ff       	call   8017aa <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	50                   	push   %eax
  801b35:	6a 21                	push   $0x21
  801b37:	e8 6e fc ff ff       	call   8017aa <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	50                   	push   %eax
  801b51:	6a 22                	push   $0x22
  801b53:	e8 52 fc ff ff       	call   8017aa <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 02                	push   $0x2
  801b6c:	e8 39 fc ff ff       	call   8017aa <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 03                	push   $0x3
  801b85:	e8 20 fc ff ff       	call   8017aa <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 04                	push   $0x4
  801b9e:	e8 07 fc ff ff       	call   8017aa <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 23                	push   $0x23
  801bb7:	e8 ee fb ff ff       	call   8017aa <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	90                   	nop
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bcb:	8d 50 04             	lea    0x4(%eax),%edx
  801bce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 24                	push   $0x24
  801bdb:	e8 ca fb ff ff       	call   8017aa <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return result;
  801be3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bec:	89 01                	mov    %eax,(%ecx)
  801bee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	c9                   	leave  
  801bf5:	c2 04 00             	ret    $0x4

00801bf8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	6a 12                	push   $0x12
  801c0a:	e8 9b fb ff ff       	call   8017aa <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 25                	push   $0x25
  801c24:	e8 81 fb ff ff       	call   8017aa <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c3a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	50                   	push   %eax
  801c47:	6a 26                	push   $0x26
  801c49:	e8 5c fb ff ff       	call   8017aa <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c51:	90                   	nop
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <rsttst>:
void rsttst()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 28                	push   $0x28
  801c63:	e8 42 fb ff ff       	call   8017aa <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6b:	90                   	nop
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	8b 45 14             	mov    0x14(%ebp),%eax
  801c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c7a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c81:	52                   	push   %edx
  801c82:	50                   	push   %eax
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 27                	push   $0x27
  801c8e:	e8 17 fb ff ff       	call   8017aa <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <chktst>:
void chktst(uint32 n)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	ff 75 08             	pushl  0x8(%ebp)
  801ca7:	6a 29                	push   $0x29
  801ca9:	e8 fc fa ff ff       	call   8017aa <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb1:	90                   	nop
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <inctst>:

void inctst()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 2a                	push   $0x2a
  801cc3:	e8 e2 fa ff ff       	call   8017aa <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccb:	90                   	nop
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <gettst>:
uint32 gettst()
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 2b                	push   $0x2b
  801cdd:	e8 c8 fa ff ff       	call   8017aa <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 2c                	push   $0x2c
  801cf9:	e8 ac fa ff ff       	call   8017aa <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
  801d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d04:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d08:	75 07                	jne    801d11 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0f:	eb 05                	jmp    801d16 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 2c                	push   $0x2c
  801d2a:	e8 7b fa ff ff       	call   8017aa <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
  801d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d35:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d39:	75 07                	jne    801d42 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d40:	eb 05                	jmp    801d47 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 2c                	push   $0x2c
  801d5b:	e8 4a fa ff ff       	call   8017aa <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d66:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d6a:	75 07                	jne    801d73 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d71:	eb 05                	jmp    801d78 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 2c                	push   $0x2c
  801d8c:	e8 19 fa ff ff       	call   8017aa <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d97:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 2d                	push   $0x2d
  801dbb:	e8 ea f9 ff ff       	call   8017aa <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	53                   	push   %ebx
  801dd9:	51                   	push   %ecx
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 2e                	push   $0x2e
  801dde:	e8 c7 f9 ff ff       	call   8017aa <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	52                   	push   %edx
  801dfb:	50                   	push   %eax
  801dfc:	6a 2f                	push   $0x2f
  801dfe:	e8 a7 f9 ff ff       	call   8017aa <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <__udivdi3>:
  801e08:	55                   	push   %ebp
  801e09:	57                   	push   %edi
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	83 ec 1c             	sub    $0x1c,%esp
  801e0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1f:	89 ca                	mov    %ecx,%edx
  801e21:	89 f8                	mov    %edi,%eax
  801e23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e27:	85 f6                	test   %esi,%esi
  801e29:	75 2d                	jne    801e58 <__udivdi3+0x50>
  801e2b:	39 cf                	cmp    %ecx,%edi
  801e2d:	77 65                	ja     801e94 <__udivdi3+0x8c>
  801e2f:	89 fd                	mov    %edi,%ebp
  801e31:	85 ff                	test   %edi,%edi
  801e33:	75 0b                	jne    801e40 <__udivdi3+0x38>
  801e35:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3a:	31 d2                	xor    %edx,%edx
  801e3c:	f7 f7                	div    %edi
  801e3e:	89 c5                	mov    %eax,%ebp
  801e40:	31 d2                	xor    %edx,%edx
  801e42:	89 c8                	mov    %ecx,%eax
  801e44:	f7 f5                	div    %ebp
  801e46:	89 c1                	mov    %eax,%ecx
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	f7 f5                	div    %ebp
  801e4c:	89 cf                	mov    %ecx,%edi
  801e4e:	89 fa                	mov    %edi,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	39 ce                	cmp    %ecx,%esi
  801e5a:	77 28                	ja     801e84 <__udivdi3+0x7c>
  801e5c:	0f bd fe             	bsr    %esi,%edi
  801e5f:	83 f7 1f             	xor    $0x1f,%edi
  801e62:	75 40                	jne    801ea4 <__udivdi3+0x9c>
  801e64:	39 ce                	cmp    %ecx,%esi
  801e66:	72 0a                	jb     801e72 <__udivdi3+0x6a>
  801e68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e6c:	0f 87 9e 00 00 00    	ja     801f10 <__udivdi3+0x108>
  801e72:	b8 01 00 00 00       	mov    $0x1,%eax
  801e77:	89 fa                	mov    %edi,%edx
  801e79:	83 c4 1c             	add    $0x1c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
  801e81:	8d 76 00             	lea    0x0(%esi),%esi
  801e84:	31 ff                	xor    %edi,%edi
  801e86:	31 c0                	xor    %eax,%eax
  801e88:	89 fa                	mov    %edi,%edx
  801e8a:	83 c4 1c             	add    $0x1c,%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5e                   	pop    %esi
  801e8f:	5f                   	pop    %edi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	89 d8                	mov    %ebx,%eax
  801e96:	f7 f7                	div    %edi
  801e98:	31 ff                	xor    %edi,%edi
  801e9a:	89 fa                	mov    %edi,%edx
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
  801ea4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ea9:	89 eb                	mov    %ebp,%ebx
  801eab:	29 fb                	sub    %edi,%ebx
  801ead:	89 f9                	mov    %edi,%ecx
  801eaf:	d3 e6                	shl    %cl,%esi
  801eb1:	89 c5                	mov    %eax,%ebp
  801eb3:	88 d9                	mov    %bl,%cl
  801eb5:	d3 ed                	shr    %cl,%ebp
  801eb7:	89 e9                	mov    %ebp,%ecx
  801eb9:	09 f1                	or     %esi,%ecx
  801ebb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ebf:	89 f9                	mov    %edi,%ecx
  801ec1:	d3 e0                	shl    %cl,%eax
  801ec3:	89 c5                	mov    %eax,%ebp
  801ec5:	89 d6                	mov    %edx,%esi
  801ec7:	88 d9                	mov    %bl,%cl
  801ec9:	d3 ee                	shr    %cl,%esi
  801ecb:	89 f9                	mov    %edi,%ecx
  801ecd:	d3 e2                	shl    %cl,%edx
  801ecf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed3:	88 d9                	mov    %bl,%cl
  801ed5:	d3 e8                	shr    %cl,%eax
  801ed7:	09 c2                	or     %eax,%edx
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	89 f2                	mov    %esi,%edx
  801edd:	f7 74 24 0c          	divl   0xc(%esp)
  801ee1:	89 d6                	mov    %edx,%esi
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	f7 e5                	mul    %ebp
  801ee7:	39 d6                	cmp    %edx,%esi
  801ee9:	72 19                	jb     801f04 <__udivdi3+0xfc>
  801eeb:	74 0b                	je     801ef8 <__udivdi3+0xf0>
  801eed:	89 d8                	mov    %ebx,%eax
  801eef:	31 ff                	xor    %edi,%edi
  801ef1:	e9 58 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801efc:	89 f9                	mov    %edi,%ecx
  801efe:	d3 e2                	shl    %cl,%edx
  801f00:	39 c2                	cmp    %eax,%edx
  801f02:	73 e9                	jae    801eed <__udivdi3+0xe5>
  801f04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f07:	31 ff                	xor    %edi,%edi
  801f09:	e9 40 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801f0e:	66 90                	xchg   %ax,%ax
  801f10:	31 c0                	xor    %eax,%eax
  801f12:	e9 37 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801f17:	90                   	nop

00801f18 <__umoddi3>:
  801f18:	55                   	push   %ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 1c             	sub    $0x1c,%esp
  801f1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f37:	89 f3                	mov    %esi,%ebx
  801f39:	89 fa                	mov    %edi,%edx
  801f3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f3f:	89 34 24             	mov    %esi,(%esp)
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 1a                	jne    801f60 <__umoddi3+0x48>
  801f46:	39 f7                	cmp    %esi,%edi
  801f48:	0f 86 a2 00 00 00    	jbe    801ff0 <__umoddi3+0xd8>
  801f4e:	89 c8                	mov    %ecx,%eax
  801f50:	89 f2                	mov    %esi,%edx
  801f52:	f7 f7                	div    %edi
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	31 d2                	xor    %edx,%edx
  801f58:	83 c4 1c             	add    $0x1c,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5f                   	pop    %edi
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    
  801f60:	39 f0                	cmp    %esi,%eax
  801f62:	0f 87 ac 00 00 00    	ja     802014 <__umoddi3+0xfc>
  801f68:	0f bd e8             	bsr    %eax,%ebp
  801f6b:	83 f5 1f             	xor    $0x1f,%ebp
  801f6e:	0f 84 ac 00 00 00    	je     802020 <__umoddi3+0x108>
  801f74:	bf 20 00 00 00       	mov    $0x20,%edi
  801f79:	29 ef                	sub    %ebp,%edi
  801f7b:	89 fe                	mov    %edi,%esi
  801f7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f81:	89 e9                	mov    %ebp,%ecx
  801f83:	d3 e0                	shl    %cl,%eax
  801f85:	89 d7                	mov    %edx,%edi
  801f87:	89 f1                	mov    %esi,%ecx
  801f89:	d3 ef                	shr    %cl,%edi
  801f8b:	09 c7                	or     %eax,%edi
  801f8d:	89 e9                	mov    %ebp,%ecx
  801f8f:	d3 e2                	shl    %cl,%edx
  801f91:	89 14 24             	mov    %edx,(%esp)
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	d3 e0                	shl    %cl,%eax
  801f98:	89 c2                	mov    %eax,%edx
  801f9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f9e:	d3 e0                	shl    %cl,%eax
  801fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa8:	89 f1                	mov    %esi,%ecx
  801faa:	d3 e8                	shr    %cl,%eax
  801fac:	09 d0                	or     %edx,%eax
  801fae:	d3 eb                	shr    %cl,%ebx
  801fb0:	89 da                	mov    %ebx,%edx
  801fb2:	f7 f7                	div    %edi
  801fb4:	89 d3                	mov    %edx,%ebx
  801fb6:	f7 24 24             	mull   (%esp)
  801fb9:	89 c6                	mov    %eax,%esi
  801fbb:	89 d1                	mov    %edx,%ecx
  801fbd:	39 d3                	cmp    %edx,%ebx
  801fbf:	0f 82 87 00 00 00    	jb     80204c <__umoddi3+0x134>
  801fc5:	0f 84 91 00 00 00    	je     80205c <__umoddi3+0x144>
  801fcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fcf:	29 f2                	sub    %esi,%edx
  801fd1:	19 cb                	sbb    %ecx,%ebx
  801fd3:	89 d8                	mov    %ebx,%eax
  801fd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fd9:	d3 e0                	shl    %cl,%eax
  801fdb:	89 e9                	mov    %ebp,%ecx
  801fdd:	d3 ea                	shr    %cl,%edx
  801fdf:	09 d0                	or     %edx,%eax
  801fe1:	89 e9                	mov    %ebp,%ecx
  801fe3:	d3 eb                	shr    %cl,%ebx
  801fe5:	89 da                	mov    %ebx,%edx
  801fe7:	83 c4 1c             	add    $0x1c,%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5f                   	pop    %edi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    
  801fef:	90                   	nop
  801ff0:	89 fd                	mov    %edi,%ebp
  801ff2:	85 ff                	test   %edi,%edi
  801ff4:	75 0b                	jne    802001 <__umoddi3+0xe9>
  801ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	f7 f7                	div    %edi
  801fff:	89 c5                	mov    %eax,%ebp
  802001:	89 f0                	mov    %esi,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	f7 f5                	div    %ebp
  802007:	89 c8                	mov    %ecx,%eax
  802009:	f7 f5                	div    %ebp
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	e9 44 ff ff ff       	jmp    801f56 <__umoddi3+0x3e>
  802012:	66 90                	xchg   %ax,%ax
  802014:	89 c8                	mov    %ecx,%eax
  802016:	89 f2                	mov    %esi,%edx
  802018:	83 c4 1c             	add    $0x1c,%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5f                   	pop    %edi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    
  802020:	3b 04 24             	cmp    (%esp),%eax
  802023:	72 06                	jb     80202b <__umoddi3+0x113>
  802025:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802029:	77 0f                	ja     80203a <__umoddi3+0x122>
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	29 f9                	sub    %edi,%ecx
  80202f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802033:	89 14 24             	mov    %edx,(%esp)
  802036:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80203a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80203e:	8b 14 24             	mov    (%esp),%edx
  802041:	83 c4 1c             	add    $0x1c,%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    
  802049:	8d 76 00             	lea    0x0(%esi),%esi
  80204c:	2b 04 24             	sub    (%esp),%eax
  80204f:	19 fa                	sbb    %edi,%edx
  802051:	89 d1                	mov    %edx,%ecx
  802053:	89 c6                	mov    %eax,%esi
  802055:	e9 71 ff ff ff       	jmp    801fcb <__umoddi3+0xb3>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802060:	72 ea                	jb     80204c <__umoddi3+0x134>
  802062:	89 d9                	mov    %ebx,%ecx
  802064:	e9 62 ff ff ff       	jmp    801fcb <__umoddi3+0xb3>
