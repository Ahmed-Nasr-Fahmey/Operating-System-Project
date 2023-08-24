
obj/user/tst_page_replacement_FIFO_2:     file format elf32-i386


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
  800031:	e8 33 07 00 00       	call   800769 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp

//	cprintf("envID = %d\n",envID);



	char* tempArr = (char*)0x80000000;
  800044:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
	//sys_allocateMem(0x80000000, 15*1024);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800056:	8b 00                	mov    (%eax),%eax
  800058:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80005b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80005e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800063:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800068:	74 14                	je     80007e <_main+0x46>
  80006a:	83 ec 04             	sub    $0x4,%esp
  80006d:	68 c0 21 80 00       	push   $0x8021c0
  800072:	6a 17                	push   $0x17
  800074:	68 04 22 80 00       	push   $0x802204
  800079:	e8 3a 08 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80007e:	a1 20 30 80 00       	mov    0x803020,%eax
  800083:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800089:	83 c0 18             	add    $0x18,%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800091:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 10 20 00       	cmp    $0x201000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c0 21 80 00       	push   $0x8021c0
  8000a8:	6a 18                	push   $0x18
  8000aa:	68 04 22 80 00       	push   $0x802204
  8000af:	e8 04 08 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000bf:	83 c0 30             	add    $0x30,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8000c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 c0 21 80 00       	push   $0x8021c0
  8000de:	6a 19                	push   $0x19
  8000e0:	68 04 22 80 00       	push   $0x802204
  8000e5:	e8 ce 07 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000f5:	83 c0 48             	add    $0x48,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8000fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 30 20 00       	cmp    $0x203000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 c0 21 80 00       	push   $0x8021c0
  800114:	6a 1a                	push   $0x1a
  800116:	68 04 22 80 00       	push   $0x802204
  80011b:	e8 98 07 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 30 80 00       	mov    0x803020,%eax
  800125:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80012b:	83 c0 60             	add    $0x60,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800133:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 c0 21 80 00       	push   $0x8021c0
  80014a:	6a 1b                	push   $0x1b
  80014c:	68 04 22 80 00       	push   $0x802204
  800151:	e8 62 07 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 30 80 00       	mov    0x803020,%eax
  80015b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800161:	83 c0 78             	add    $0x78,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 c0 21 80 00       	push   $0x8021c0
  800180:	6a 1c                	push   $0x1c
  800182:	68 04 22 80 00       	push   $0x802204
  800187:	e8 2c 07 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800197:	05 90 00 00 00       	add    $0x90,%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a9:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 c0 21 80 00       	push   $0x8021c0
  8001b8:	6a 1d                	push   $0x1d
  8001ba:	68 04 22 80 00       	push   $0x802204
  8001bf:	e8 f4 06 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001cf:	05 a8 00 00 00       	add    $0xa8,%eax
  8001d4:	8b 00                	mov    (%eax),%eax
  8001d6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001d9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001e1:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001e6:	74 14                	je     8001fc <_main+0x1c4>
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	68 c0 21 80 00       	push   $0x8021c0
  8001f0:	6a 1e                	push   $0x1e
  8001f2:	68 04 22 80 00       	push   $0x802204
  8001f7:	e8 bc 06 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800207:	05 c0 00 00 00       	add    $0xc0,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800211:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800214:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800219:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 c0 21 80 00       	push   $0x8021c0
  800228:	6a 1f                	push   $0x1f
  80022a:	68 04 22 80 00       	push   $0x802204
  80022f:	e8 84 06 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800234:	a1 20 30 80 00       	mov    0x803020,%eax
  800239:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80023f:	05 d8 00 00 00       	add    $0xd8,%eax
  800244:	8b 00                	mov    (%eax),%eax
  800246:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800249:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80024c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800251:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800256:	74 14                	je     80026c <_main+0x234>
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	68 c0 21 80 00       	push   $0x8021c0
  800260:	6a 20                	push   $0x20
  800262:	68 04 22 80 00       	push   $0x802204
  800267:	e8 4c 06 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800277:	05 f0 00 00 00       	add    $0xf0,%eax
  80027c:	8b 00                	mov    (%eax),%eax
  80027e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800281:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800284:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800289:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028e:	74 14                	je     8002a4 <_main+0x26c>
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	68 c0 21 80 00       	push   $0x8021c0
  800298:	6a 21                	push   $0x21
  80029a:	68 04 22 80 00       	push   $0x802204
  80029f:	e8 14 06 00 00       	call   8008b8 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a9:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 14                	je     8002c7 <_main+0x28f>
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	68 28 22 80 00       	push   $0x802228
  8002bb:	6a 22                	push   $0x22
  8002bd:	68 04 22 80 00       	push   $0x802204
  8002c2:	e8 f1 05 00 00       	call   8008b8 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8002c7:	e8 16 17 00 00       	call   8019e2 <sys_calculate_free_frames>
  8002cc:	89 45 9c             	mov    %eax,-0x64(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cf:	e8 ae 17 00 00       	call   801a82 <sys_pf_calculate_allocated_pages>
  8002d4:	89 45 98             	mov    %eax,-0x68(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  8002d7:	a0 5f 51 83 00       	mov    0x83515f,%al
  8002dc:	88 45 97             	mov    %al,-0x69(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  8002df:	a0 5f 61 83 00       	mov    0x83615f,%al
  8002e4:	88 45 96             	mov    %al,-0x6a(%ebp)
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  8002e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8002ee:	eb 26                	jmp    800316 <_main+0x2de>
	{
		arr[i] = -1 ;
  8002f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f3:	05 60 a1 82 00       	add    $0x82a160,%eax
  8002f8:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8002fb:	a1 00 30 80 00       	mov    0x803000,%eax
  800300:	8a 00                	mov    (%eax),%al
  800302:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  800305:	a1 04 30 80 00       	mov    0x803004,%eax
  80030a:	8a 00                	mov    (%eax),%al
  80030c:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  80030f:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800316:	81 7d e0 ff 4f 00 00 	cmpl   $0x4fff,-0x20(%ebp)
  80031d:	7e d1                	jle    8002f0 <_main+0x2b8>
		garbage5 = *ptr2 ;
	}

	//Check FIFO 1
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x80e000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80031f:	a1 20 30 80 00       	mov    0x803020,%eax
  800324:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 90             	mov    %eax,-0x70(%ebp)
  80032f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 70 22 80 00       	push   $0x802270
  800346:	6a 3d                	push   $0x3d
  800348:	68 04 22 80 00       	push   $0x802204
  80034d:	e8 66 05 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80f000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80035d:	83 c0 18             	add    $0x18,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800365:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036d:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  800372:	74 14                	je     800388 <_main+0x350>
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 70 22 80 00       	push   $0x802270
  80037c:	6a 3e                	push   $0x3e
  80037e:	68 04 22 80 00       	push   $0x802204
  800383:	e8 30 05 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800393:	83 c0 30             	add    $0x30,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 88             	mov    %eax,-0x78(%ebp)
  80039b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8003a8:	74 14                	je     8003be <_main+0x386>
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	68 70 22 80 00       	push   $0x802270
  8003b2:	6a 3f                	push   $0x3f
  8003b4:	68 04 22 80 00       	push   $0x802204
  8003b9:	e8 fa 04 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x805000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003c9:	83 c0 48             	add    $0x48,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8003d1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d9:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 70 22 80 00       	push   $0x802270
  8003e8:	6a 40                	push   $0x40
  8003ea:	68 04 22 80 00       	push   $0x802204
  8003ef:	e8 c4 04 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x806000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003ff:	83 c0 60             	add    $0x60,%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	89 45 80             	mov    %eax,-0x80(%ebp)
  800407:	8b 45 80             	mov    -0x80(%ebp),%eax
  80040a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040f:	3d 00 60 80 00       	cmp    $0x806000,%eax
  800414:	74 14                	je     80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 70 22 80 00       	push   $0x802270
  80041e:	6a 41                	push   $0x41
  800420:	68 04 22 80 00       	push   $0x802204
  800425:	e8 8e 04 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80042a:	a1 20 30 80 00       	mov    0x803020,%eax
  80042f:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800435:	83 c0 78             	add    $0x78,%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800440:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800446:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80044b:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 70 22 80 00       	push   $0x802270
  80045a:	6a 42                	push   $0x42
  80045c:	68 04 22 80 00       	push   $0x802204
  800461:	e8 52 04 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800471:	05 90 00 00 00       	add    $0x90,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80047e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800489:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 70 22 80 00       	push   $0x802270
  800498:	6a 43                	push   $0x43
  80049a:	68 04 22 80 00       	push   $0x802204
  80049f:	e8 14 04 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a9:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8004af:	05 a8 00 00 00       	add    $0xa8,%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8004bc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8004cc:	74 14                	je     8004e2 <_main+0x4aa>
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	68 70 22 80 00       	push   $0x802270
  8004d6:	6a 44                	push   $0x44
  8004d8:	68 04 22 80 00       	push   $0x802204
  8004dd:	e8 d6 03 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x802000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8004e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8004ed:	05 c0 00 00 00       	add    $0xc0,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8004fa:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800505:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80050a:	74 14                	je     800520 <_main+0x4e8>
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	68 70 22 80 00       	push   $0x802270
  800514:	6a 45                	push   $0x45
  800516:	68 04 22 80 00       	push   $0x802204
  80051b:	e8 98 03 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800520:	a1 20 30 80 00       	mov    0x803020,%eax
  800525:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80052b:	05 d8 00 00 00       	add    $0xd8,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800538:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80053e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800543:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800548:	74 14                	je     80055e <_main+0x526>
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 70 22 80 00       	push   $0x802270
  800552:	6a 46                	push   $0x46
  800554:	68 04 22 80 00       	push   $0x802204
  800559:	e8 5a 03 00 00       	call   8008b8 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80055e:	a1 20 30 80 00       	mov    0x803020,%eax
  800563:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800569:	05 f0 00 00 00       	add    $0xf0,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800576:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80057c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800581:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800586:	74 14                	je     80059c <_main+0x564>
  800588:	83 ec 04             	sub    $0x4,%esp
  80058b:	68 70 22 80 00       	push   $0x802270
  800590:	6a 47                	push   $0x47
  800592:	68 04 22 80 00       	push   $0x802204
  800597:	e8 1c 03 00 00       	call   8008b8 <_panic>

		if(myEnv->page_last_WS_index != 6) panic("wrong PAGE WS pointer location");
  80059c:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a1:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8005a7:	83 f8 06             	cmp    $0x6,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 bc 22 80 00       	push   $0x8022bc
  8005b4:	6a 49                	push   $0x49
  8005b6:	68 04 22 80 00       	push   $0x802204
  8005bb:	e8 f8 02 00 00       	call   8008b8 <_panic>
	}

	sys_allocate_user_mem(0x80000000, 4*PAGE_SIZE);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	68 00 40 00 00       	push   $0x4000
  8005c8:	68 00 00 00 80       	push   $0x80000000
  8005cd:	e8 77 14 00 00       	call   801a49 <sys_allocate_user_mem>
  8005d2:	83 c4 10             	add    $0x10,%esp
	//cprintf("1\n");

	int c;
	for(c = 0;c< 15*1024;c++)
  8005d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005dc:	eb 0e                	jmp    8005ec <_main+0x5b4>
	{
		tempArr[c] = 'a';
  8005de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	c6 00 61             	movb   $0x61,(%eax)

	sys_allocate_user_mem(0x80000000, 4*PAGE_SIZE);
	//cprintf("1\n");

	int c;
	for(c = 0;c< 15*1024;c++)
  8005e9:	ff 45 dc             	incl   -0x24(%ebp)
  8005ec:	81 7d dc ff 3b 00 00 	cmpl   $0x3bff,-0x24(%ebp)
  8005f3:	7e e9                	jle    8005de <_main+0x5a6>
		tempArr[c] = 'a';
	}

	//cprintf("2\n");

	sys_free_user_mem(0x80000000, 4*PAGE_SIZE);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	68 00 40 00 00       	push   $0x4000
  8005fd:	68 00 00 00 80       	push   $0x80000000
  800602:	e8 26 14 00 00       	call   801a2d <sys_free_user_mem>
  800607:	83 c4 10             	add    $0x10,%esp
	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80060a:	c7 45 e0 00 50 00 00 	movl   $0x5000,-0x20(%ebp)
  800611:	eb 26                	jmp    800639 <_main+0x601>
	{
		arr[i] = -1 ;
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	05 60 a1 82 00       	add    $0x82a160,%eax
  80061b:	c6 00 ff             	movb   $0xff,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  80061e:	a1 00 30 80 00       	mov    0x803000,%eax
  800623:	8a 00                	mov    (%eax),%al
  800625:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  800628:	a1 04 30 80 00       	mov    0x803004,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	88 45 e6             	mov    %al,-0x1a(%ebp)

	sys_free_user_mem(0x80000000, 4*PAGE_SIZE);
	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800632:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800639:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800640:	7e d1                	jle    800613 <_main+0x5db>
		garbage5 = *ptr2 ;
	}
	//cprintf("4\n");

	//===================
	uint32 finalPageNums[11] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0xeebfd000};
  800642:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  800648:	bb 60 23 80 00       	mov    $0x802360,%ebx
  80064d:	ba 0b 00 00 00       	mov    $0xb,%edx
  800652:	89 c7                	mov    %eax,%edi
  800654:	89 de                	mov    %ebx,%esi
  800656:	89 d1                	mov    %edx,%ecx
  800658:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80065a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800661:	e9 97 00 00 00       	jmp    8006fd <_main+0x6c5>
		{
			uint8 found = 0;
  800666:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
			for (int j = 0; j < myEnv->page_WS_max_size; ++j)
  80066a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800671:	eb 43                	jmp    8006b6 <_main+0x67e>
			{
				if(finalPageNums[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE))
  800673:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800676:	8b 8c 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%ecx
  80067d:	a1 20 30 80 00       	mov    0x803020,%eax
  800682:	8b 98 58 da 01 00    	mov    0x1da58(%eax),%ebx
  800688:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	01 c0                	add    %eax,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	c1 e0 03             	shl    $0x3,%eax
  800694:	01 d8                	add    %ebx,%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80069e:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a9:	39 c1                	cmp    %eax,%ecx
  8006ab:	75 06                	jne    8006b3 <_main+0x67b>
				{
					found = 1;
  8006ad:	c6 45 d7 01          	movb   $0x1,-0x29(%ebp)
					break;
  8006b1:	eb 12                	jmp    8006c5 <_main+0x68d>
	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
		{
			uint8 found = 0;
			for (int j = 0; j < myEnv->page_WS_max_size; ++j)
  8006b3:	ff 45 d0             	incl   -0x30(%ebp)
  8006b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bb:	8b 50 74             	mov    0x74(%eax),%edx
  8006be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	77 ae                	ja     800673 <_main+0x63b>
				{
					found = 1;
					break;
				}
			}
			if (found == 0)
  8006c5:	80 7d d7 00          	cmpb   $0x0,-0x29(%ebp)
  8006c9:	75 2f                	jne    8006fa <_main+0x6c2>
			{
				cprintf("%x NOT FOUND\n", finalPageNums[i]);
  8006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ce:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	50                   	push   %eax
  8006d9:	68 db 22 80 00       	push   $0x8022db
  8006de:	e8 89 04 00 00       	call   800b6c <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
				panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	68 70 22 80 00       	push   $0x802270
  8006ee:	6a 77                	push   $0x77
  8006f0:	68 04 22 80 00       	push   $0x802204
  8006f5:	e8 be 01 00 00       	call   8008b8 <_panic>
	//===================
	uint32 finalPageNums[11] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0xeebfd000};

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  8006fa:	ff 45 d8             	incl   -0x28(%ebp)
  8006fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800702:	8b 50 74             	mov    0x74(%eax),%edx
  800705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800708:	39 c2                	cmp    %eax,%edx
  80070a:	0f 87 56 ff ff ff    	ja     800666 <_main+0x62e>
			}
		}
	}

	{
		if (garbage4 != *ptr) panic("test failed!");
  800710:	a1 00 30 80 00       	mov    0x803000,%eax
  800715:	8a 00                	mov    (%eax),%al
  800717:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80071a:	74 14                	je     800730 <_main+0x6f8>
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	68 e9 22 80 00       	push   $0x8022e9
  800724:	6a 7d                	push   $0x7d
  800726:	68 04 22 80 00       	push   $0x802204
  80072b:	e8 88 01 00 00       	call   8008b8 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  800730:	a1 04 30 80 00       	mov    0x803004,%eax
  800735:	8a 00                	mov    (%eax),%al
  800737:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80073a:	74 14                	je     800750 <_main+0x718>
  80073c:	83 ec 04             	sub    $0x4,%esp
  80073f:	68 e9 22 80 00       	push   $0x8022e9
  800744:	6a 7e                	push   $0x7e
  800746:	68 04 22 80 00       	push   $0x802204
  80074b:	e8 68 01 00 00       	call   8008b8 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [FIFO 2] is completed successfully.\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 f8 22 80 00       	push   $0x8022f8
  800758:	e8 0f 04 00 00       	call   800b6c <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	return;
  800760:	90                   	nop
}
  800761:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800764:	5b                   	pop    %ebx
  800765:	5e                   	pop    %esi
  800766:	5f                   	pop    %edi
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80076f:	e8 4e 15 00 00       	call   801cc2 <sys_getenvindex>
  800774:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077a:	89 d0                	mov    %edx,%eax
  80077c:	01 c0                	add    %eax,%eax
  80077e:	01 d0                	add    %edx,%eax
  800780:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800787:	01 c8                	add    %ecx,%eax
  800789:	c1 e0 02             	shl    $0x2,%eax
  80078c:	01 d0                	add    %edx,%eax
  80078e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800795:	01 c8                	add    %ecx,%eax
  800797:	c1 e0 02             	shl    $0x2,%eax
  80079a:	01 d0                	add    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	c1 e0 03             	shl    $0x3,%eax
  8007a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007a9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b3:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8007b9:	84 c0                	test   %al,%al
  8007bb:	74 0f                	je     8007cc <libmain+0x63>
		binaryname = myEnv->prog_name;
  8007bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c2:	05 18 da 01 00       	add    $0x1da18,%eax
  8007c7:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007d0:	7e 0a                	jle    8007dc <libmain+0x73>
		binaryname = argv[0];
  8007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	ff 75 08             	pushl  0x8(%ebp)
  8007e5:	e8 4e f8 ff ff       	call   800038 <_main>
  8007ea:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007ed:	e8 dd 12 00 00       	call   801acf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	68 a4 23 80 00       	push   $0x8023a4
  8007fa:	e8 6d 03 00 00       	call   800b6c <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800802:	a1 20 30 80 00       	mov    0x803020,%eax
  800807:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80080d:	a1 20 30 80 00       	mov    0x803020,%eax
  800812:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	52                   	push   %edx
  80081c:	50                   	push   %eax
  80081d:	68 cc 23 80 00       	push   $0x8023cc
  800822:	e8 45 03 00 00       	call   800b6c <cprintf>
  800827:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80082a:	a1 20 30 80 00       	mov    0x803020,%eax
  80082f:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800835:	a1 20 30 80 00       	mov    0x803020,%eax
  80083a:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800840:	a1 20 30 80 00       	mov    0x803020,%eax
  800845:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80084b:	51                   	push   %ecx
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	68 f4 23 80 00       	push   $0x8023f4
  800853:	e8 14 03 00 00       	call   800b6c <cprintf>
  800858:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80085b:	a1 20 30 80 00       	mov    0x803020,%eax
  800860:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	50                   	push   %eax
  80086a:	68 4c 24 80 00       	push   $0x80244c
  80086f:	e8 f8 02 00 00       	call   800b6c <cprintf>
  800874:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800877:	83 ec 0c             	sub    $0xc,%esp
  80087a:	68 a4 23 80 00       	push   $0x8023a4
  80087f:	e8 e8 02 00 00       	call   800b6c <cprintf>
  800884:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800887:	e8 5d 12 00 00       	call   801ae9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80088c:	e8 19 00 00 00       	call   8008aa <exit>
}
  800891:	90                   	nop
  800892:	c9                   	leave  
  800893:	c3                   	ret    

00800894 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80089a:	83 ec 0c             	sub    $0xc,%esp
  80089d:	6a 00                	push   $0x0
  80089f:	e8 ea 13 00 00       	call   801c8e <sys_destroy_env>
  8008a4:	83 c4 10             	add    $0x10,%esp
}
  8008a7:	90                   	nop
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <exit>:

void
exit(void)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008b0:	e8 3f 14 00 00       	call   801cf4 <sys_exit_env>
}
  8008b5:	90                   	nop
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008be:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c1:	83 c0 04             	add    $0x4,%eax
  8008c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008c7:	a1 58 62 83 00       	mov    0x836258,%eax
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	74 16                	je     8008e6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008d0:	a1 58 62 83 00       	mov    0x836258,%eax
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	50                   	push   %eax
  8008d9:	68 60 24 80 00       	push   $0x802460
  8008de:	e8 89 02 00 00       	call   800b6c <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008e6:	a1 08 30 80 00       	mov    0x803008,%eax
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	50                   	push   %eax
  8008f2:	68 65 24 80 00       	push   $0x802465
  8008f7:	e8 70 02 00 00       	call   800b6c <cprintf>
  8008fc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 f4             	pushl  -0xc(%ebp)
  800908:	50                   	push   %eax
  800909:	e8 f3 01 00 00       	call   800b01 <vcprintf>
  80090e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	6a 00                	push   $0x0
  800916:	68 81 24 80 00       	push   $0x802481
  80091b:	e8 e1 01 00 00       	call   800b01 <vcprintf>
  800920:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800923:	e8 82 ff ff ff       	call   8008aa <exit>

	// should not return here
	while (1) ;
  800928:	eb fe                	jmp    800928 <_panic+0x70>

0080092a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800930:	a1 20 30 80 00       	mov    0x803020,%eax
  800935:	8b 50 74             	mov    0x74(%eax),%edx
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 14                	je     800953 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 84 24 80 00       	push   $0x802484
  800947:	6a 26                	push   $0x26
  800949:	68 d0 24 80 00       	push   $0x8024d0
  80094e:	e8 65 ff ff ff       	call   8008b8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80095a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800961:	e9 c2 00 00 00       	jmp    800a28 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	01 d0                	add    %edx,%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	85 c0                	test   %eax,%eax
  800979:	75 08                	jne    800983 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80097b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80097e:	e9 a2 00 00 00       	jmp    800a25 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800983:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80098a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800991:	eb 69                	jmp    8009fc <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800993:	a1 20 30 80 00       	mov    0x803020,%eax
  800998:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80099e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a1:	89 d0                	mov    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	01 d0                	add    %edx,%eax
  8009a7:	c1 e0 03             	shl    $0x3,%eax
  8009aa:	01 c8                	add    %ecx,%eax
  8009ac:	8a 40 04             	mov    0x4(%eax),%al
  8009af:	84 c0                	test   %al,%al
  8009b1:	75 46                	jne    8009f9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8009b8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c1:	89 d0                	mov    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	c1 e0 03             	shl    $0x3,%eax
  8009ca:	01 c8                	add    %ecx,%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009d9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	01 c8                	add    %ecx,%eax
  8009ea:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	75 09                	jne    8009f9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009f7:	eb 12                	jmp    800a0b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f9:	ff 45 e8             	incl   -0x18(%ebp)
  8009fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800a01:	8b 50 74             	mov    0x74(%eax),%edx
  800a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	77 88                	ja     800993 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a0f:	75 14                	jne    800a25 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a11:	83 ec 04             	sub    $0x4,%esp
  800a14:	68 dc 24 80 00       	push   $0x8024dc
  800a19:	6a 3a                	push   $0x3a
  800a1b:	68 d0 24 80 00       	push   $0x8024d0
  800a20:	e8 93 fe ff ff       	call   8008b8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a25:	ff 45 f0             	incl   -0x10(%ebp)
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a2e:	0f 8c 32 ff ff ff    	jl     800966 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a42:	eb 26                	jmp    800a6a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a44:	a1 20 30 80 00       	mov    0x803020,%eax
  800a49:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	01 c0                	add    %eax,%eax
  800a56:	01 d0                	add    %edx,%eax
  800a58:	c1 e0 03             	shl    $0x3,%eax
  800a5b:	01 c8                	add    %ecx,%eax
  800a5d:	8a 40 04             	mov    0x4(%eax),%al
  800a60:	3c 01                	cmp    $0x1,%al
  800a62:	75 03                	jne    800a67 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a64:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a67:	ff 45 e0             	incl   -0x20(%ebp)
  800a6a:	a1 20 30 80 00       	mov    0x803020,%eax
  800a6f:	8b 50 74             	mov    0x74(%eax),%edx
  800a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a75:	39 c2                	cmp    %eax,%edx
  800a77:	77 cb                	ja     800a44 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a7f:	74 14                	je     800a95 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a81:	83 ec 04             	sub    $0x4,%esp
  800a84:	68 30 25 80 00       	push   $0x802530
  800a89:	6a 44                	push   $0x44
  800a8b:	68 d0 24 80 00       	push   $0x8024d0
  800a90:	e8 23 fe ff ff       	call   8008b8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a95:	90                   	nop
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa9:	89 0a                	mov    %ecx,(%edx)
  800aab:	8b 55 08             	mov    0x8(%ebp),%edx
  800aae:	88 d1                	mov    %dl,%cl
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ac1:	75 2c                	jne    800aef <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ac3:	a0 24 30 80 00       	mov    0x803024,%al
  800ac8:	0f b6 c0             	movzbl %al,%eax
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ace:	8b 12                	mov    (%edx),%edx
  800ad0:	89 d1                	mov    %edx,%ecx
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad5:	83 c2 08             	add    $0x8,%edx
  800ad8:	83 ec 04             	sub    $0x4,%esp
  800adb:	50                   	push   %eax
  800adc:	51                   	push   %ecx
  800add:	52                   	push   %edx
  800ade:	e8 3e 0e 00 00       	call   801921 <sys_cputs>
  800ae3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8b 40 04             	mov    0x4(%eax),%eax
  800af5:	8d 50 01             	lea    0x1(%eax),%edx
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	89 50 04             	mov    %edx,0x4(%eax)
}
  800afe:	90                   	nop
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b0a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b11:	00 00 00 
	b.cnt = 0;
  800b14:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b1b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b2a:	50                   	push   %eax
  800b2b:	68 98 0a 80 00       	push   $0x800a98
  800b30:	e8 11 02 00 00       	call   800d46 <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b38:	a0 24 30 80 00       	mov    0x803024,%al
  800b3d:	0f b6 c0             	movzbl %al,%eax
  800b40:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b46:	83 ec 04             	sub    $0x4,%esp
  800b49:	50                   	push   %eax
  800b4a:	52                   	push   %edx
  800b4b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b51:	83 c0 08             	add    $0x8,%eax
  800b54:	50                   	push   %eax
  800b55:	e8 c7 0d 00 00       	call   801921 <sys_cputs>
  800b5a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b5d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800b64:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <cprintf>:

int cprintf(const char *fmt, ...) {
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b72:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b79:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 f4             	pushl  -0xc(%ebp)
  800b88:	50                   	push   %eax
  800b89:	e8 73 ff ff ff       	call   800b01 <vcprintf>
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b9f:	e8 2b 0f 00 00       	call   801acf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ba4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb3:	50                   	push   %eax
  800bb4:	e8 48 ff ff ff       	call   800b01 <vcprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bbf:	e8 25 0f 00 00       	call   801ae9 <sys_enable_interrupt>
	return cnt;
  800bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 14             	sub    $0x14,%esp
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bdc:	8b 45 18             	mov    0x18(%ebp),%eax
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800be7:	77 55                	ja     800c3e <printnum+0x75>
  800be9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bec:	72 05                	jb     800bf3 <printnum+0x2a>
  800bee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bf1:	77 4b                	ja     800c3e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bf3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bf6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bf9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	52                   	push   %edx
  800c02:	50                   	push   %eax
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	ff 75 f0             	pushl  -0x10(%ebp)
  800c09:	e8 46 13 00 00       	call   801f54 <__udivdi3>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	83 ec 04             	sub    $0x4,%esp
  800c14:	ff 75 20             	pushl  0x20(%ebp)
  800c17:	53                   	push   %ebx
  800c18:	ff 75 18             	pushl  0x18(%ebp)
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 08             	pushl  0x8(%ebp)
  800c23:	e8 a1 ff ff ff       	call   800bc9 <printnum>
  800c28:	83 c4 20             	add    $0x20,%esp
  800c2b:	eb 1a                	jmp    800c47 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c3e:	ff 4d 1c             	decl   0x1c(%ebp)
  800c41:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c45:	7f e6                	jg     800c2d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c47:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c55:	53                   	push   %ebx
  800c56:	51                   	push   %ecx
  800c57:	52                   	push   %edx
  800c58:	50                   	push   %eax
  800c59:	e8 06 14 00 00       	call   802064 <__umoddi3>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	05 94 27 80 00       	add    $0x802794,%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f be c0             	movsbl %al,%eax
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	50                   	push   %eax
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
}
  800c7a:	90                   	nop
  800c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c83:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c87:	7e 1c                	jle    800ca5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	8d 50 08             	lea    0x8(%eax),%edx
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 10                	mov    %edx,(%eax)
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 00                	mov    (%eax),%eax
  800c9b:	83 e8 08             	sub    $0x8,%eax
  800c9e:	8b 50 04             	mov    0x4(%eax),%edx
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	eb 40                	jmp    800ce5 <getuint+0x65>
	else if (lflag)
  800ca5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca9:	74 1e                	je     800cc9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	8d 50 04             	lea    0x4(%eax),%edx
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 10                	mov    %edx,(%eax)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	83 e8 04             	sub    $0x4,%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	eb 1c                	jmp    800ce5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8b 00                	mov    (%eax),%eax
  800cce:	8d 50 04             	lea    0x4(%eax),%edx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 10                	mov    %edx,(%eax)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	83 e8 04             	sub    $0x4,%eax
  800cde:	8b 00                	mov    (%eax),%eax
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cee:	7e 1c                	jle    800d0c <getint+0x25>
		return va_arg(*ap, long long);
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8b 00                	mov    (%eax),%eax
  800cf5:	8d 50 08             	lea    0x8(%eax),%edx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 10                	mov    %edx,(%eax)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	83 e8 08             	sub    $0x8,%eax
  800d05:	8b 50 04             	mov    0x4(%eax),%edx
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	eb 38                	jmp    800d44 <getint+0x5d>
	else if (lflag)
  800d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d10:	74 1a                	je     800d2c <getint+0x45>
		return va_arg(*ap, long);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	99                   	cltd   
  800d2a:	eb 18                	jmp    800d44 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	8d 50 04             	lea    0x4(%eax),%edx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 10                	mov    %edx,(%eax)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 e8 04             	sub    $0x4,%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	99                   	cltd   
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4e:	eb 17                	jmp    800d67 <vprintfmt+0x21>
			if (ch == '\0')
  800d50:	85 db                	test   %ebx,%ebx
  800d52:	0f 84 af 03 00 00    	je     801107 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	53                   	push   %ebx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d8             	movzbl %al,%ebx
  800d75:	83 fb 25             	cmp    $0x25,%ebx
  800d78:	75 d6                	jne    800d50 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d7a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	8d 50 01             	lea    0x1(%eax),%edx
  800da0:	89 55 10             	mov    %edx,0x10(%ebp)
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	0f b6 d8             	movzbl %al,%ebx
  800da8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dab:	83 f8 55             	cmp    $0x55,%eax
  800dae:	0f 87 2b 03 00 00    	ja     8010df <vprintfmt+0x399>
  800db4:	8b 04 85 b8 27 80 00 	mov    0x8027b8(,%eax,4),%eax
  800dbb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dbd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dc1:	eb d7                	jmp    800d9a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dc3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dc7:	eb d1                	jmp    800d9a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dd3:	89 d0                	mov    %edx,%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	01 c0                	add    %eax,%eax
  800ddc:	01 d8                	add    %ebx,%eax
  800dde:	83 e8 30             	sub    $0x30,%eax
  800de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dec:	83 fb 2f             	cmp    $0x2f,%ebx
  800def:	7e 3e                	jle    800e2f <vprintfmt+0xe9>
  800df1:	83 fb 39             	cmp    $0x39,%ebx
  800df4:	7f 39                	jg     800e2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800df6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800df9:	eb d5                	jmp    800dd0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	83 c0 04             	add    $0x4,%eax
  800e01:	89 45 14             	mov    %eax,0x14(%ebp)
  800e04:	8b 45 14             	mov    0x14(%ebp),%eax
  800e07:	83 e8 04             	sub    $0x4,%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e0f:	eb 1f                	jmp    800e30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e15:	79 83                	jns    800d9a <vprintfmt+0x54>
				width = 0;
  800e17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e1e:	e9 77 ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e2a:	e9 6b ff ff ff       	jmp    800d9a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	0f 89 60 ff ff ff    	jns    800d9a <vprintfmt+0x54>
				width = precision, precision = -1;
  800e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e47:	e9 4e ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e4f:	e9 46 ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 c0 04             	add    $0x4,%eax
  800e5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 e8 04             	sub    $0x4,%eax
  800e63:	8b 00                	mov    (%eax),%eax
  800e65:	83 ec 08             	sub    $0x8,%esp
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	50                   	push   %eax
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	ff d0                	call   *%eax
  800e71:	83 c4 10             	add    $0x10,%esp
			break;
  800e74:	e9 89 02 00 00       	jmp    801102 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e79:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7c:	83 c0 04             	add    $0x4,%eax
  800e7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e82:	8b 45 14             	mov    0x14(%ebp),%eax
  800e85:	83 e8 04             	sub    $0x4,%eax
  800e88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e8a:	85 db                	test   %ebx,%ebx
  800e8c:	79 02                	jns    800e90 <vprintfmt+0x14a>
				err = -err;
  800e8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e90:	83 fb 64             	cmp    $0x64,%ebx
  800e93:	7f 0b                	jg     800ea0 <vprintfmt+0x15a>
  800e95:	8b 34 9d 00 26 80 00 	mov    0x802600(,%ebx,4),%esi
  800e9c:	85 f6                	test   %esi,%esi
  800e9e:	75 19                	jne    800eb9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ea0:	53                   	push   %ebx
  800ea1:	68 a5 27 80 00       	push   $0x8027a5
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	ff 75 08             	pushl  0x8(%ebp)
  800eac:	e8 5e 02 00 00       	call   80110f <printfmt>
  800eb1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eb4:	e9 49 02 00 00       	jmp    801102 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eb9:	56                   	push   %esi
  800eba:	68 ae 27 80 00       	push   $0x8027ae
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 45 02 00 00       	call   80110f <printfmt>
  800eca:	83 c4 10             	add    $0x10,%esp
			break;
  800ecd:	e9 30 02 00 00       	jmp    801102 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 c0 04             	add    $0x4,%eax
  800ed8:	89 45 14             	mov    %eax,0x14(%ebp)
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	83 e8 04             	sub    $0x4,%eax
  800ee1:	8b 30                	mov    (%eax),%esi
  800ee3:	85 f6                	test   %esi,%esi
  800ee5:	75 05                	jne    800eec <vprintfmt+0x1a6>
				p = "(null)";
  800ee7:	be b1 27 80 00       	mov    $0x8027b1,%esi
			if (width > 0 && padc != '-')
  800eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef0:	7e 6d                	jle    800f5f <vprintfmt+0x219>
  800ef2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ef6:	74 67                	je     800f5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	50                   	push   %eax
  800eff:	56                   	push   %esi
  800f00:	e8 0c 03 00 00       	call   801211 <strnlen>
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f0b:	eb 16                	jmp    800f23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	50                   	push   %eax
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f20:	ff 4d e4             	decl   -0x1c(%ebp)
  800f23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f27:	7f e4                	jg     800f0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f29:	eb 34                	jmp    800f5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f2f:	74 1c                	je     800f4d <vprintfmt+0x207>
  800f31:	83 fb 1f             	cmp    $0x1f,%ebx
  800f34:	7e 05                	jle    800f3b <vprintfmt+0x1f5>
  800f36:	83 fb 7e             	cmp    $0x7e,%ebx
  800f39:	7e 12                	jle    800f4d <vprintfmt+0x207>
					putch('?', putdat);
  800f3b:	83 ec 08             	sub    $0x8,%esp
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	6a 3f                	push   $0x3f
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	eb 0f                	jmp    800f5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	53                   	push   %ebx
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5f:	89 f0                	mov    %esi,%eax
  800f61:	8d 70 01             	lea    0x1(%eax),%esi
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be d8             	movsbl %al,%ebx
  800f69:	85 db                	test   %ebx,%ebx
  800f6b:	74 24                	je     800f91 <vprintfmt+0x24b>
  800f6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f71:	78 b8                	js     800f2b <vprintfmt+0x1e5>
  800f73:	ff 4d e0             	decl   -0x20(%ebp)
  800f76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f7a:	79 af                	jns    800f2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f7c:	eb 13                	jmp    800f91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	6a 20                	push   $0x20
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	ff d0                	call   *%eax
  800f8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f95:	7f e7                	jg     800f7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f97:	e9 66 01 00 00       	jmp    801102 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800fa2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	e8 3c fd ff ff       	call   800ce7 <getint>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fba:	85 d2                	test   %edx,%edx
  800fbc:	79 23                	jns    800fe1 <vprintfmt+0x29b>
				putch('-', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 2d                	push   $0x2d
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	f7 d8                	neg    %eax
  800fd6:	83 d2 00             	adc    $0x0,%edx
  800fd9:	f7 da                	neg    %edx
  800fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fe1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe8:	e9 bc 00 00 00       	jmp    8010a9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	e8 84 fc ff ff       	call   800c80 <getuint>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801002:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801005:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80100c:	e9 98 00 00 00       	jmp    8010a9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	6a 58                	push   $0x58
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	6a 58                	push   $0x58
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	6a 58                	push   $0x58
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	ff d0                	call   *%eax
  80103e:	83 c4 10             	add    $0x10,%esp
			break;
  801041:	e9 bc 00 00 00       	jmp    801102 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	6a 30                	push   $0x30
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	ff d0                	call   *%eax
  801053:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	6a 78                	push   $0x78
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	ff d0                	call   *%eax
  801063:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	83 c0 04             	add    $0x4,%eax
  80106c:	89 45 14             	mov    %eax,0x14(%ebp)
  80106f:	8b 45 14             	mov    0x14(%ebp),%eax
  801072:	83 e8 04             	sub    $0x4,%eax
  801075:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801081:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801088:	eb 1f                	jmp    8010a9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80108a:	83 ec 08             	sub    $0x8,%esp
  80108d:	ff 75 e8             	pushl  -0x18(%ebp)
  801090:	8d 45 14             	lea    0x14(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	e8 e7 fb ff ff       	call   800c80 <getuint>
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010a2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010a9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b0:	83 ec 04             	sub    $0x4,%esp
  8010b3:	52                   	push   %edx
  8010b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010b7:	50                   	push   %eax
  8010b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	ff 75 08             	pushl  0x8(%ebp)
  8010c4:	e8 00 fb ff ff       	call   800bc9 <printnum>
  8010c9:	83 c4 20             	add    $0x20,%esp
			break;
  8010cc:	eb 34                	jmp    801102 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	53                   	push   %ebx
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
			break;
  8010dd:	eb 23                	jmp    801102 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	6a 25                	push   $0x25
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ef:	ff 4d 10             	decl   0x10(%ebp)
  8010f2:	eb 03                	jmp    8010f7 <vprintfmt+0x3b1>
  8010f4:	ff 4d 10             	decl   0x10(%ebp)
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	48                   	dec    %eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 25                	cmp    $0x25,%al
  8010ff:	75 f3                	jne    8010f4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801101:	90                   	nop
		}
	}
  801102:	e9 47 fc ff ff       	jmp    800d4e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801107:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801108:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801115:	8d 45 10             	lea    0x10(%ebp),%eax
  801118:	83 c0 04             	add    $0x4,%eax
  80111b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	ff 75 f4             	pushl  -0xc(%ebp)
  801124:	50                   	push   %eax
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	ff 75 08             	pushl  0x8(%ebp)
  80112b:	e8 16 fc ff ff       	call   800d46 <vprintfmt>
  801130:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	8b 40 08             	mov    0x8(%eax),%eax
  80113f:	8d 50 01             	lea    0x1(%eax),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	8b 10                	mov    (%eax),%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8b 40 04             	mov    0x4(%eax),%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	73 12                	jae    801169 <sprintputch+0x33>
		*b->buf++ = ch;
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	8b 00                	mov    (%eax),%eax
  80115c:	8d 48 01             	lea    0x1(%eax),%ecx
  80115f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801162:	89 0a                	mov    %ecx,(%edx)
  801164:	8b 55 08             	mov    0x8(%ebp),%edx
  801167:	88 10                	mov    %dl,(%eax)
}
  801169:	90                   	nop
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	74 06                	je     801199 <vsnprintf+0x2d>
  801193:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801197:	7f 07                	jg     8011a0 <vsnprintf+0x34>
		return -E_INVAL;
  801199:	b8 03 00 00 00       	mov    $0x3,%eax
  80119e:	eb 20                	jmp    8011c0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011a0:	ff 75 14             	pushl  0x14(%ebp)
  8011a3:	ff 75 10             	pushl  0x10(%ebp)
  8011a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a9:	50                   	push   %eax
  8011aa:	68 36 11 80 00       	push   $0x801136
  8011af:	e8 92 fb ff ff       	call   800d46 <vprintfmt>
  8011b4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    

008011c2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8011cb:	83 c0 04             	add    $0x4,%eax
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d7:	50                   	push   %eax
  8011d8:	ff 75 0c             	pushl  0xc(%ebp)
  8011db:	ff 75 08             	pushl  0x8(%ebp)
  8011de:	e8 89 ff ff ff       	call   80116c <vsnprintf>
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011fb:	eb 06                	jmp    801203 <strlen+0x15>
		n++;
  8011fd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801200:	ff 45 08             	incl   0x8(%ebp)
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	84 c0                	test   %al,%al
  80120a:	75 f1                	jne    8011fd <strlen+0xf>
		n++;
	return n;
  80120c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121e:	eb 09                	jmp    801229 <strnlen+0x18>
		n++;
  801220:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	ff 4d 0c             	decl   0xc(%ebp)
  801229:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80122d:	74 09                	je     801238 <strnlen+0x27>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	84 c0                	test   %al,%al
  801236:	75 e8                	jne    801220 <strnlen+0xf>
		n++;
	return n;
  801238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801249:	90                   	nop
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 08             	mov    %edx,0x8(%ebp)
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	8d 4a 01             	lea    0x1(%edx),%ecx
  801259:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80125c:	8a 12                	mov    (%edx),%dl
  80125e:	88 10                	mov    %dl,(%eax)
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	75 e4                	jne    80124a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801266:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80127e:	eb 1f                	jmp    80129f <strncpy+0x34>
		*dst++ = *src;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8d 50 01             	lea    0x1(%eax),%edx
  801286:	89 55 08             	mov    %edx,0x8(%ebp)
  801289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128c:	8a 12                	mov    (%edx),%dl
  80128e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	84 c0                	test   %al,%al
  801297:	74 03                	je     80129c <strncpy+0x31>
			src++;
  801299:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80129c:	ff 45 fc             	incl   -0x4(%ebp)
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a5:	72 d9                	jb     801280 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bc:	74 30                	je     8012ee <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012be:	eb 16                	jmp    8012d6 <strlcpy+0x2a>
			*dst++ = *src++;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d2:	8a 12                	mov    (%edx),%dl
  8012d4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012d6:	ff 4d 10             	decl   0x10(%ebp)
  8012d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dd:	74 09                	je     8012e8 <strlcpy+0x3c>
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	84 c0                	test   %al,%al
  8012e6:	75 d8                	jne    8012c0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	29 c2                	sub    %eax,%edx
  8012f6:	89 d0                	mov    %edx,%eax
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012fd:	eb 06                	jmp    801305 <strcmp+0xb>
		p++, q++;
  8012ff:	ff 45 08             	incl   0x8(%ebp)
  801302:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 0e                	je     80131c <strcmp+0x22>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 10                	mov    (%eax),%dl
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	38 c2                	cmp    %al,%dl
  80131a:	74 e3                	je     8012ff <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	0f b6 d0             	movzbl %al,%edx
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 c0             	movzbl %al,%eax
  80132c:	29 c2                	sub    %eax,%edx
  80132e:	89 d0                	mov    %edx,%eax
}
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801335:	eb 09                	jmp    801340 <strncmp+0xe>
		n--, p++, q++;
  801337:	ff 4d 10             	decl   0x10(%ebp)
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801344:	74 17                	je     80135d <strncmp+0x2b>
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	84 c0                	test   %al,%al
  80134d:	74 0e                	je     80135d <strncmp+0x2b>
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 10                	mov    (%eax),%dl
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	38 c2                	cmp    %al,%dl
  80135b:	74 da                	je     801337 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80135d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801361:	75 07                	jne    80136a <strncmp+0x38>
		return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 14                	jmp    80137e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	0f b6 d0             	movzbl %al,%edx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	0f b6 c0             	movzbl %al,%eax
  80137a:	29 c2                	sub    %eax,%edx
  80137c:	89 d0                	mov    %edx,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80138c:	eb 12                	jmp    8013a0 <strchr+0x20>
		if (*s == c)
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801396:	75 05                	jne    80139d <strchr+0x1d>
			return (char *) s;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	eb 11                	jmp    8013ae <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80139d:	ff 45 08             	incl   0x8(%ebp)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	84 c0                	test   %al,%al
  8013a7:	75 e5                	jne    80138e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013bc:	eb 0d                	jmp    8013cb <strfind+0x1b>
		if (*s == c)
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013c6:	74 0e                	je     8013d6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c8:	ff 45 08             	incl   0x8(%ebp)
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	84 c0                	test   %al,%al
  8013d2:	75 ea                	jne    8013be <strfind+0xe>
  8013d4:	eb 01                	jmp    8013d7 <strfind+0x27>
		if (*s == c)
			break;
  8013d6:	90                   	nop
	return (char *) s;
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8013ee:	eb 0e                	jmp    8013fe <memset+0x22>
		*p++ = c;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8013fe:	ff 4d f8             	decl   -0x8(%ebp)
  801401:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801405:	79 e9                	jns    8013f0 <memset+0x14>
		*p++ = c;

	return v;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801412:	8b 45 0c             	mov    0xc(%ebp),%eax
  801415:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80141e:	eb 16                	jmp    801436 <memcpy+0x2a>
		*d++ = *s++;
  801420:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801423:	8d 50 01             	lea    0x1(%eax),%edx
  801426:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801429:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80142f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801432:	8a 12                	mov    (%edx),%dl
  801434:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	8d 50 ff             	lea    -0x1(%eax),%edx
  80143c:	89 55 10             	mov    %edx,0x10(%ebp)
  80143f:	85 c0                	test   %eax,%eax
  801441:	75 dd                	jne    801420 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80145a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801460:	73 50                	jae    8014b2 <memmove+0x6a>
  801462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801465:	8b 45 10             	mov    0x10(%ebp),%eax
  801468:	01 d0                	add    %edx,%eax
  80146a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80146d:	76 43                	jbe    8014b2 <memmove+0x6a>
		s += n;
  80146f:	8b 45 10             	mov    0x10(%ebp),%eax
  801472:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801475:	8b 45 10             	mov    0x10(%ebp),%eax
  801478:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80147b:	eb 10                	jmp    80148d <memmove+0x45>
			*--d = *--s;
  80147d:	ff 4d f8             	decl   -0x8(%ebp)
  801480:	ff 4d fc             	decl   -0x4(%ebp)
  801483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801486:	8a 10                	mov    (%eax),%dl
  801488:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	8d 50 ff             	lea    -0x1(%eax),%edx
  801493:	89 55 10             	mov    %edx,0x10(%ebp)
  801496:	85 c0                	test   %eax,%eax
  801498:	75 e3                	jne    80147d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80149a:	eb 23                	jmp    8014bf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80149c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149f:	8d 50 01             	lea    0x1(%eax),%edx
  8014a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014ae:	8a 12                	mov    (%edx),%dl
  8014b0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	75 dd                	jne    80149c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014d6:	eb 2a                	jmp    801502 <memcmp+0x3e>
		if (*s1 != *s2)
  8014d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014db:	8a 10                	mov    (%eax),%dl
  8014dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	38 c2                	cmp    %al,%dl
  8014e4:	74 16                	je     8014fc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	0f b6 d0             	movzbl %al,%edx
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f b6 c0             	movzbl %al,%eax
  8014f6:	29 c2                	sub    %eax,%edx
  8014f8:	89 d0                	mov    %edx,%eax
  8014fa:	eb 18                	jmp    801514 <memcmp+0x50>
		s1++, s2++;
  8014fc:	ff 45 fc             	incl   -0x4(%ebp)
  8014ff:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	8d 50 ff             	lea    -0x1(%eax),%edx
  801508:	89 55 10             	mov    %edx,0x10(%ebp)
  80150b:	85 c0                	test   %eax,%eax
  80150d:	75 c9                	jne    8014d8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80150f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80151c:	8b 55 08             	mov    0x8(%ebp),%edx
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	01 d0                	add    %edx,%eax
  801524:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801527:	eb 15                	jmp    80153e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 d0             	movzbl %al,%edx
  801531:	8b 45 0c             	mov    0xc(%ebp),%eax
  801534:	0f b6 c0             	movzbl %al,%eax
  801537:	39 c2                	cmp    %eax,%edx
  801539:	74 0d                	je     801548 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80153b:	ff 45 08             	incl   0x8(%ebp)
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801544:	72 e3                	jb     801529 <memfind+0x13>
  801546:	eb 01                	jmp    801549 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801548:	90                   	nop
	return (void *) s;
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80155b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801562:	eb 03                	jmp    801567 <strtol+0x19>
		s++;
  801564:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	3c 20                	cmp    $0x20,%al
  80156e:	74 f4                	je     801564 <strtol+0x16>
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	3c 09                	cmp    $0x9,%al
  801577:	74 eb                	je     801564 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3c 2b                	cmp    $0x2b,%al
  801580:	75 05                	jne    801587 <strtol+0x39>
		s++;
  801582:	ff 45 08             	incl   0x8(%ebp)
  801585:	eb 13                	jmp    80159a <strtol+0x4c>
	else if (*s == '-')
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3c 2d                	cmp    $0x2d,%al
  80158e:	75 0a                	jne    80159a <strtol+0x4c>
		s++, neg = 1;
  801590:	ff 45 08             	incl   0x8(%ebp)
  801593:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80159a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80159e:	74 06                	je     8015a6 <strtol+0x58>
  8015a0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015a4:	75 20                	jne    8015c6 <strtol+0x78>
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	3c 30                	cmp    $0x30,%al
  8015ad:	75 17                	jne    8015c6 <strtol+0x78>
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	40                   	inc    %eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	3c 78                	cmp    $0x78,%al
  8015b7:	75 0d                	jne    8015c6 <strtol+0x78>
		s += 2, base = 16;
  8015b9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015bd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015c4:	eb 28                	jmp    8015ee <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ca:	75 15                	jne    8015e1 <strtol+0x93>
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	3c 30                	cmp    $0x30,%al
  8015d3:	75 0c                	jne    8015e1 <strtol+0x93>
		s++, base = 8;
  8015d5:	ff 45 08             	incl   0x8(%ebp)
  8015d8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015df:	eb 0d                	jmp    8015ee <strtol+0xa0>
	else if (base == 0)
  8015e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e5:	75 07                	jne    8015ee <strtol+0xa0>
		base = 10;
  8015e7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 2f                	cmp    $0x2f,%al
  8015f5:	7e 19                	jle    801610 <strtol+0xc2>
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	3c 39                	cmp    $0x39,%al
  8015fe:	7f 10                	jg     801610 <strtol+0xc2>
			dig = *s - '0';
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	0f be c0             	movsbl %al,%eax
  801608:	83 e8 30             	sub    $0x30,%eax
  80160b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80160e:	eb 42                	jmp    801652 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	3c 60                	cmp    $0x60,%al
  801617:	7e 19                	jle    801632 <strtol+0xe4>
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	3c 7a                	cmp    $0x7a,%al
  801620:	7f 10                	jg     801632 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	0f be c0             	movsbl %al,%eax
  80162a:	83 e8 57             	sub    $0x57,%eax
  80162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801630:	eb 20                	jmp    801652 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 40                	cmp    $0x40,%al
  801639:	7e 39                	jle    801674 <strtol+0x126>
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	3c 5a                	cmp    $0x5a,%al
  801642:	7f 30                	jg     801674 <strtol+0x126>
			dig = *s - 'A' + 10;
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	0f be c0             	movsbl %al,%eax
  80164c:	83 e8 37             	sub    $0x37,%eax
  80164f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801655:	3b 45 10             	cmp    0x10(%ebp),%eax
  801658:	7d 19                	jge    801673 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80165a:	ff 45 08             	incl   0x8(%ebp)
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	0f af 45 10          	imul   0x10(%ebp),%eax
  801664:	89 c2                	mov    %eax,%edx
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80166e:	e9 7b ff ff ff       	jmp    8015ee <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801673:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801674:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801678:	74 08                	je     801682 <strtol+0x134>
		*endptr = (char *) s;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	8b 55 08             	mov    0x8(%ebp),%edx
  801680:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801682:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801686:	74 07                	je     80168f <strtol+0x141>
  801688:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168b:	f7 d8                	neg    %eax
  80168d:	eb 03                	jmp    801692 <strtol+0x144>
  80168f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <ltostr>:

void
ltostr(long value, char *str)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80169a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ac:	79 13                	jns    8016c1 <ltostr+0x2d>
	{
		neg = 1;
  8016ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016bb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016be:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016c9:	99                   	cltd   
  8016ca:	f7 f9                	idiv   %ecx
  8016cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d2:	8d 50 01             	lea    0x1(%eax),%edx
  8016d5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016e2:	83 c2 30             	add    $0x30,%edx
  8016e5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ea:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016ef:	f7 e9                	imul   %ecx
  8016f1:	c1 fa 02             	sar    $0x2,%edx
  8016f4:	89 c8                	mov    %ecx,%eax
  8016f6:	c1 f8 1f             	sar    $0x1f,%eax
  8016f9:	29 c2                	sub    %eax,%edx
  8016fb:	89 d0                	mov    %edx,%eax
  8016fd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801700:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801703:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801708:	f7 e9                	imul   %ecx
  80170a:	c1 fa 02             	sar    $0x2,%edx
  80170d:	89 c8                	mov    %ecx,%eax
  80170f:	c1 f8 1f             	sar    $0x1f,%eax
  801712:	29 c2                	sub    %eax,%edx
  801714:	89 d0                	mov    %edx,%eax
  801716:	c1 e0 02             	shl    $0x2,%eax
  801719:	01 d0                	add    %edx,%eax
  80171b:	01 c0                	add    %eax,%eax
  80171d:	29 c1                	sub    %eax,%ecx
  80171f:	89 ca                	mov    %ecx,%edx
  801721:	85 d2                	test   %edx,%edx
  801723:	75 9c                	jne    8016c1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	48                   	dec    %eax
  801730:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801733:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801737:	74 3d                	je     801776 <ltostr+0xe2>
		start = 1 ;
  801739:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801740:	eb 34                	jmp    801776 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801745:	8b 45 0c             	mov    0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80174f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	01 c2                	add    %eax,%edx
  801757:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	01 c8                	add    %ecx,%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801763:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	01 c2                	add    %eax,%edx
  80176b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80176e:	88 02                	mov    %al,(%edx)
		start++ ;
  801770:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801773:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80177c:	7c c4                	jl     801742 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80177e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801781:	8b 45 0c             	mov    0xc(%ebp),%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	e8 54 fa ff ff       	call   8011ee <strlen>
  80179a:	83 c4 04             	add    $0x4,%esp
  80179d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	e8 46 fa ff ff       	call   8011ee <strlen>
  8017a8:	83 c4 04             	add    $0x4,%esp
  8017ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017bc:	eb 17                	jmp    8017d5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c4:	01 c2                	add    %eax,%edx
  8017c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	01 c8                	add    %ecx,%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017d2:	ff 45 fc             	incl   -0x4(%ebp)
  8017d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017db:	7c e1                	jl     8017be <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017eb:	eb 1f                	jmp    80180c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f0:	8d 50 01             	lea    0x1(%eax),%edx
  8017f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017f6:	89 c2                	mov    %eax,%edx
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	01 c2                	add    %eax,%edx
  8017fd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801800:	8b 45 0c             	mov    0xc(%ebp),%eax
  801803:	01 c8                	add    %ecx,%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801809:	ff 45 f8             	incl   -0x8(%ebp)
  80180c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801812:	7c d9                	jl     8017ed <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801814:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801817:	8b 45 10             	mov    0x10(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	c6 00 00             	movb   $0x0,(%eax)
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801825:	8b 45 14             	mov    0x14(%ebp),%eax
  801828:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80182e:	8b 45 14             	mov    0x14(%ebp),%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183a:	8b 45 10             	mov    0x10(%ebp),%eax
  80183d:	01 d0                	add    %edx,%eax
  80183f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801845:	eb 0c                	jmp    801853 <strsplit+0x31>
			*string++ = 0;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8d 50 01             	lea    0x1(%eax),%edx
  80184d:	89 55 08             	mov    %edx,0x8(%ebp)
  801850:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	84 c0                	test   %al,%al
  80185a:	74 18                	je     801874 <strsplit+0x52>
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8a 00                	mov    (%eax),%al
  801861:	0f be c0             	movsbl %al,%eax
  801864:	50                   	push   %eax
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	e8 13 fb ff ff       	call   801380 <strchr>
  80186d:	83 c4 08             	add    $0x8,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	75 d3                	jne    801847 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	8a 00                	mov    (%eax),%al
  801879:	84 c0                	test   %al,%al
  80187b:	74 5a                	je     8018d7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80187d:	8b 45 14             	mov    0x14(%ebp),%eax
  801880:	8b 00                	mov    (%eax),%eax
  801882:	83 f8 0f             	cmp    $0xf,%eax
  801885:	75 07                	jne    80188e <strsplit+0x6c>
		{
			return 0;
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	eb 66                	jmp    8018f4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80188e:	8b 45 14             	mov    0x14(%ebp),%eax
  801891:	8b 00                	mov    (%eax),%eax
  801893:	8d 48 01             	lea    0x1(%eax),%ecx
  801896:	8b 55 14             	mov    0x14(%ebp),%edx
  801899:	89 0a                	mov    %ecx,(%edx)
  80189b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	01 c2                	add    %eax,%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ac:	eb 03                	jmp    8018b1 <strsplit+0x8f>
			string++;
  8018ae:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	8a 00                	mov    (%eax),%al
  8018b6:	84 c0                	test   %al,%al
  8018b8:	74 8b                	je     801845 <strsplit+0x23>
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	0f be c0             	movsbl %al,%eax
  8018c2:	50                   	push   %eax
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	e8 b5 fa ff ff       	call   801380 <strchr>
  8018cb:	83 c4 08             	add    $0x8,%esp
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	74 dc                	je     8018ae <strsplit+0x8c>
			string++;
	}
  8018d2:	e9 6e ff ff ff       	jmp    801845 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018d7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018db:	8b 00                	mov    (%eax),%eax
  8018dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	57                   	push   %edi
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801908:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80190e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801911:	cd 30                	int    $0x30
  801913:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	8b 45 10             	mov    0x10(%ebp),%eax
  80192a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	52                   	push   %edx
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	50                   	push   %eax
  80193d:	6a 00                	push   $0x0
  80193f:	e8 b2 ff ff ff       	call   8018f6 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_cgetc>:

int
sys_cgetc(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 01                	push   $0x1
  801959:	e8 98 ff ff ff       	call   8018f6 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 05                	push   $0x5
  801976:	e8 7b ff ff ff       	call   8018f6 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801985:	8b 75 18             	mov    0x18(%ebp),%esi
  801988:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	56                   	push   %esi
  801995:	53                   	push   %ebx
  801996:	51                   	push   %ecx
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 06                	push   $0x6
  80199b:	e8 56 ff ff ff       	call   8018f6 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	52                   	push   %edx
  8019ba:	50                   	push   %eax
  8019bb:	6a 07                	push   $0x7
  8019bd:	e8 34 ff ff ff       	call   8018f6 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 08                	push   $0x8
  8019d8:	e8 19 ff ff ff       	call   8018f6 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 09                	push   $0x9
  8019f1:	e8 00 ff ff ff       	call   8018f6 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 0a                	push   $0xa
  801a0a:	e8 e7 fe ff ff       	call   8018f6 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 0b                	push   $0xb
  801a23:	e8 ce fe ff ff       	call   8018f6 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	6a 0f                	push   $0xf
  801a3e:	e8 b3 fe ff ff       	call   8018f6 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
	return;
  801a46:	90                   	nop
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 10                	push   $0x10
  801a5a:	e8 97 fe ff ff       	call   8018f6 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a62:	90                   	nop
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	ff 75 10             	pushl  0x10(%ebp)
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 11                	push   $0x11
  801a77:	e8 7a fe ff ff       	call   8018f6 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7f:	90                   	nop
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 0c                	push   $0xc
  801a91:	e8 60 fe ff ff       	call   8018f6 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 0d                	push   $0xd
  801aab:	e8 46 fe ff ff       	call   8018f6 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 0e                	push   $0xe
  801ac4:	e8 2d fe ff ff       	call   8018f6 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 13                	push   $0x13
  801ade:	e8 13 fe ff ff       	call   8018f6 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	90                   	nop
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 14                	push   $0x14
  801af8:	e8 f9 fd ff ff       	call   8018f6 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	50                   	push   %eax
  801b1c:	6a 15                	push   $0x15
  801b1e:	e8 d3 fd ff ff       	call   8018f6 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 16                	push   $0x16
  801b38:	e8 b9 fd ff ff       	call   8018f6 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	50                   	push   %eax
  801b53:	6a 17                	push   $0x17
  801b55:	e8 9c fd ff ff       	call   8018f6 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1a                	push   $0x1a
  801b72:	e8 7f fd ff ff       	call   8018f6 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 18                	push   $0x18
  801b8f:	e8 62 fd ff ff       	call   8018f6 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	90                   	nop
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 19                	push   $0x19
  801bad:	e8 44 fd ff ff       	call   8018f6 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	51                   	push   %ecx
  801bd1:	52                   	push   %edx
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	6a 1b                	push   $0x1b
  801bd8:	e8 19 fd ff ff       	call   8018f6 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 1c                	push   $0x1c
  801bf5:	e8 fc fc ff ff       	call   8018f6 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	51                   	push   %ecx
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	6a 1d                	push   $0x1d
  801c14:	e8 dd fc ff ff       	call   8018f6 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 1e                	push   $0x1e
  801c31:	e8 c0 fc ff ff       	call   8018f6 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 1f                	push   $0x1f
  801c4a:	e8 a7 fc ff ff       	call   8018f6 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	ff 75 14             	pushl  0x14(%ebp)
  801c5f:	ff 75 10             	pushl  0x10(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	6a 20                	push   $0x20
  801c68:	e8 89 fc ff ff       	call   8018f6 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	50                   	push   %eax
  801c81:	6a 21                	push   $0x21
  801c83:	e8 6e fc ff ff       	call   8018f6 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	90                   	nop
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	50                   	push   %eax
  801c9d:	6a 22                	push   $0x22
  801c9f:	e8 52 fc ff ff       	call   8018f6 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 02                	push   $0x2
  801cb8:	e8 39 fc ff ff       	call   8018f6 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 03                	push   $0x3
  801cd1:	e8 20 fc ff ff       	call   8018f6 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 04                	push   $0x4
  801cea:	e8 07 fc ff ff       	call   8018f6 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 23                	push   $0x23
  801d03:	e8 ee fb ff ff       	call   8018f6 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d17:	8d 50 04             	lea    0x4(%eax),%edx
  801d1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 24                	push   $0x24
  801d27:	e8 ca fb ff ff       	call   8018f6 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d38:	89 01                	mov    %eax,(%ecx)
  801d3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	c9                   	leave  
  801d41:	c2 04 00             	ret    $0x4

00801d44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 10             	pushl  0x10(%ebp)
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 12                	push   $0x12
  801d56:	e8 9b fb ff ff       	call   8018f6 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 25                	push   $0x25
  801d70:	e8 81 fb ff ff       	call   8018f6 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	50                   	push   %eax
  801d93:	6a 26                	push   $0x26
  801d95:	e8 5c fb ff ff       	call   8018f6 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <rsttst>:
void rsttst()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 28                	push   $0x28
  801daf:	e8 42 fb ff ff       	call   8018f6 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 04             	sub    $0x4,%esp
  801dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	ff 75 10             	pushl  0x10(%ebp)
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	6a 27                	push   $0x27
  801dda:	e8 17 fb ff ff       	call   8018f6 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <chktst>:
void chktst(uint32 n)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 29                	push   $0x29
  801df5:	e8 fc fa ff ff       	call   8018f6 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <inctst>:

void inctst()
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 2a                	push   $0x2a
  801e0f:	e8 e2 fa ff ff       	call   8018f6 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <gettst>:
uint32 gettst()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 2b                	push   $0x2b
  801e29:	e8 c8 fa ff ff       	call   8018f6 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 2c                	push   $0x2c
  801e45:	e8 ac fa ff ff       	call   8018f6 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
  801e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e54:	75 07                	jne    801e5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	eb 05                	jmp    801e62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 2c                	push   $0x2c
  801e76:	e8 7b fa ff ff       	call   8018f6 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
  801e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e85:	75 07                	jne    801e8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e87:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8c:	eb 05                	jmp    801e93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 2c                	push   $0x2c
  801ea7:	e8 4a fa ff ff       	call   8018f6 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb6:	75 07                	jne    801ebf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebd:	eb 05                	jmp    801ec4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 2c                	push   $0x2c
  801ed8:	e8 19 fa ff ff       	call   8018f6 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee7:	75 07                	jne    801ef0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	eb 05                	jmp    801ef5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 2d                	push   $0x2d
  801f07:	e8 ea f9 ff ff       	call   8018f6 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	53                   	push   %ebx
  801f25:	51                   	push   %ecx
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 2e                	push   $0x2e
  801f2a:	e8 c7 f9 ff ff       	call   8018f6 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	6a 2f                	push   $0x2f
  801f4a:	e8 a7 f9 ff ff       	call   8018f6 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <__udivdi3>:
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f6b:	89 ca                	mov    %ecx,%edx
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f73:	85 f6                	test   %esi,%esi
  801f75:	75 2d                	jne    801fa4 <__udivdi3+0x50>
  801f77:	39 cf                	cmp    %ecx,%edi
  801f79:	77 65                	ja     801fe0 <__udivdi3+0x8c>
  801f7b:	89 fd                	mov    %edi,%ebp
  801f7d:	85 ff                	test   %edi,%edi
  801f7f:	75 0b                	jne    801f8c <__udivdi3+0x38>
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
  801f86:	31 d2                	xor    %edx,%edx
  801f88:	f7 f7                	div    %edi
  801f8a:	89 c5                	mov    %eax,%ebp
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	89 c8                	mov    %ecx,%eax
  801f90:	f7 f5                	div    %ebp
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	f7 f5                	div    %ebp
  801f98:	89 cf                	mov    %ecx,%edi
  801f9a:	89 fa                	mov    %edi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	39 ce                	cmp    %ecx,%esi
  801fa6:	77 28                	ja     801fd0 <__udivdi3+0x7c>
  801fa8:	0f bd fe             	bsr    %esi,%edi
  801fab:	83 f7 1f             	xor    $0x1f,%edi
  801fae:	75 40                	jne    801ff0 <__udivdi3+0x9c>
  801fb0:	39 ce                	cmp    %ecx,%esi
  801fb2:	72 0a                	jb     801fbe <__udivdi3+0x6a>
  801fb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fb8:	0f 87 9e 00 00 00    	ja     80205c <__udivdi3+0x108>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	89 fa                	mov    %edi,%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	31 c0                	xor    %eax,%eax
  801fd4:	89 fa                	mov    %edi,%edx
  801fd6:	83 c4 1c             	add    $0x1c,%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5f                   	pop    %edi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	f7 f7                	div    %edi
  801fe4:	31 ff                	xor    %edi,%edi
  801fe6:	89 fa                	mov    %edi,%edx
  801fe8:	83 c4 1c             	add    $0x1c,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
  801ff0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ff5:	89 eb                	mov    %ebp,%ebx
  801ff7:	29 fb                	sub    %edi,%ebx
  801ff9:	89 f9                	mov    %edi,%ecx
  801ffb:	d3 e6                	shl    %cl,%esi
  801ffd:	89 c5                	mov    %eax,%ebp
  801fff:	88 d9                	mov    %bl,%cl
  802001:	d3 ed                	shr    %cl,%ebp
  802003:	89 e9                	mov    %ebp,%ecx
  802005:	09 f1                	or     %esi,%ecx
  802007:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e0                	shl    %cl,%eax
  80200f:	89 c5                	mov    %eax,%ebp
  802011:	89 d6                	mov    %edx,%esi
  802013:	88 d9                	mov    %bl,%cl
  802015:	d3 ee                	shr    %cl,%esi
  802017:	89 f9                	mov    %edi,%ecx
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80201f:	88 d9                	mov    %bl,%cl
  802021:	d3 e8                	shr    %cl,%eax
  802023:	09 c2                	or     %eax,%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	89 f2                	mov    %esi,%edx
  802029:	f7 74 24 0c          	divl   0xc(%esp)
  80202d:	89 d6                	mov    %edx,%esi
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	f7 e5                	mul    %ebp
  802033:	39 d6                	cmp    %edx,%esi
  802035:	72 19                	jb     802050 <__udivdi3+0xfc>
  802037:	74 0b                	je     802044 <__udivdi3+0xf0>
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	31 ff                	xor    %edi,%edi
  80203d:	e9 58 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802042:	66 90                	xchg   %ax,%ax
  802044:	8b 54 24 08          	mov    0x8(%esp),%edx
  802048:	89 f9                	mov    %edi,%ecx
  80204a:	d3 e2                	shl    %cl,%edx
  80204c:	39 c2                	cmp    %eax,%edx
  80204e:	73 e9                	jae    802039 <__udivdi3+0xe5>
  802050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802053:	31 ff                	xor    %edi,%edi
  802055:	e9 40 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	31 c0                	xor    %eax,%eax
  80205e:	e9 37 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802063:	90                   	nop

00802064 <__umoddi3>:
  802064:	55                   	push   %ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80206f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802083:	89 f3                	mov    %esi,%ebx
  802085:	89 fa                	mov    %edi,%edx
  802087:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80208b:	89 34 24             	mov    %esi,(%esp)
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 1a                	jne    8020ac <__umoddi3+0x48>
  802092:	39 f7                	cmp    %esi,%edi
  802094:	0f 86 a2 00 00 00    	jbe    80213c <__umoddi3+0xd8>
  80209a:	89 c8                	mov    %ecx,%eax
  80209c:	89 f2                	mov    %esi,%edx
  80209e:	f7 f7                	div    %edi
  8020a0:	89 d0                	mov    %edx,%eax
  8020a2:	31 d2                	xor    %edx,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	39 f0                	cmp    %esi,%eax
  8020ae:	0f 87 ac 00 00 00    	ja     802160 <__umoddi3+0xfc>
  8020b4:	0f bd e8             	bsr    %eax,%ebp
  8020b7:	83 f5 1f             	xor    $0x1f,%ebp
  8020ba:	0f 84 ac 00 00 00    	je     80216c <__umoddi3+0x108>
  8020c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020c5:	29 ef                	sub    %ebp,%edi
  8020c7:	89 fe                	mov    %edi,%esi
  8020c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020cd:	89 e9                	mov    %ebp,%ecx
  8020cf:	d3 e0                	shl    %cl,%eax
  8020d1:	89 d7                	mov    %edx,%edi
  8020d3:	89 f1                	mov    %esi,%ecx
  8020d5:	d3 ef                	shr    %cl,%edi
  8020d7:	09 c7                	or     %eax,%edi
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	d3 e2                	shl    %cl,%edx
  8020dd:	89 14 24             	mov    %edx,(%esp)
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	d3 e0                	shl    %cl,%eax
  8020e4:	89 c2                	mov    %eax,%edx
  8020e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ea:	d3 e0                	shl    %cl,%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f4:	89 f1                	mov    %esi,%ecx
  8020f6:	d3 e8                	shr    %cl,%eax
  8020f8:	09 d0                	or     %edx,%eax
  8020fa:	d3 eb                	shr    %cl,%ebx
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	f7 f7                	div    %edi
  802100:	89 d3                	mov    %edx,%ebx
  802102:	f7 24 24             	mull   (%esp)
  802105:	89 c6                	mov    %eax,%esi
  802107:	89 d1                	mov    %edx,%ecx
  802109:	39 d3                	cmp    %edx,%ebx
  80210b:	0f 82 87 00 00 00    	jb     802198 <__umoddi3+0x134>
  802111:	0f 84 91 00 00 00    	je     8021a8 <__umoddi3+0x144>
  802117:	8b 54 24 04          	mov    0x4(%esp),%edx
  80211b:	29 f2                	sub    %esi,%edx
  80211d:	19 cb                	sbb    %ecx,%ebx
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802125:	d3 e0                	shl    %cl,%eax
  802127:	89 e9                	mov    %ebp,%ecx
  802129:	d3 ea                	shr    %cl,%edx
  80212b:	09 d0                	or     %edx,%eax
  80212d:	89 e9                	mov    %ebp,%ecx
  80212f:	d3 eb                	shr    %cl,%ebx
  802131:	89 da                	mov    %ebx,%edx
  802133:	83 c4 1c             	add    $0x1c,%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5f                   	pop    %edi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    
  80213b:	90                   	nop
  80213c:	89 fd                	mov    %edi,%ebp
  80213e:	85 ff                	test   %edi,%edi
  802140:	75 0b                	jne    80214d <__umoddi3+0xe9>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	31 d2                	xor    %edx,%edx
  802149:	f7 f7                	div    %edi
  80214b:	89 c5                	mov    %eax,%ebp
  80214d:	89 f0                	mov    %esi,%eax
  80214f:	31 d2                	xor    %edx,%edx
  802151:	f7 f5                	div    %ebp
  802153:	89 c8                	mov    %ecx,%eax
  802155:	f7 f5                	div    %ebp
  802157:	89 d0                	mov    %edx,%eax
  802159:	e9 44 ff ff ff       	jmp    8020a2 <__umoddi3+0x3e>
  80215e:	66 90                	xchg   %ax,%ax
  802160:	89 c8                	mov    %ecx,%eax
  802162:	89 f2                	mov    %esi,%edx
  802164:	83 c4 1c             	add    $0x1c,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	3b 04 24             	cmp    (%esp),%eax
  80216f:	72 06                	jb     802177 <__umoddi3+0x113>
  802171:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802175:	77 0f                	ja     802186 <__umoddi3+0x122>
  802177:	89 f2                	mov    %esi,%edx
  802179:	29 f9                	sub    %edi,%ecx
  80217b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80217f:	89 14 24             	mov    %edx,(%esp)
  802182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802186:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218a:	8b 14 24             	mov    (%esp),%edx
  80218d:	83 c4 1c             	add    $0x1c,%esp
  802190:	5b                   	pop    %ebx
  802191:	5e                   	pop    %esi
  802192:	5f                   	pop    %edi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
  802195:	8d 76 00             	lea    0x0(%esi),%esi
  802198:	2b 04 24             	sub    (%esp),%eax
  80219b:	19 fa                	sbb    %edi,%edx
  80219d:	89 d1                	mov    %edx,%ecx
  80219f:	89 c6                	mov    %eax,%esi
  8021a1:	e9 71 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021ac:	72 ea                	jb     802198 <__umoddi3+0x134>
  8021ae:	89 d9                	mov    %ebx,%ecx
  8021b0:	e9 62 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
