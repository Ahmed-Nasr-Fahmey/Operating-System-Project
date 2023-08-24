
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 4f 03 00 00       	call   800385 <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp

//	cprintf("envID = %d\n",envID);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003f:	a1 20 30 80 00       	mov    0x803020,%eax
  800044:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80004a:	8b 00                	mov    (%eax),%eax
  80004c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80004f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800052:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800057:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 e0 1d 80 00       	push   $0x801de0
  800066:	6a 12                	push   $0x12
  800068:	68 24 1e 80 00       	push   $0x801e24
  80006d:	e8 62 04 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007d:	83 c0 18             	add    $0x18,%eax
  800080:	8b 00                	mov    (%eax),%eax
  800082:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008d:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800092:	74 14                	je     8000a8 <_main+0x70>
  800094:	83 ec 04             	sub    $0x4,%esp
  800097:	68 e0 1d 80 00       	push   $0x801de0
  80009c:	6a 13                	push   $0x13
  80009e:	68 24 1e 80 00       	push   $0x801e24
  8000a3:	e8 2c 04 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ad:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b3:	83 c0 30             	add    $0x30,%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c3:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c8:	74 14                	je     8000de <_main+0xa6>
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	68 e0 1d 80 00       	push   $0x801de0
  8000d2:	6a 14                	push   $0x14
  8000d4:	68 24 1e 80 00       	push   $0x801e24
  8000d9:	e8 f6 03 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000de:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e3:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000e9:	83 c0 48             	add    $0x48,%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f9:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fe:	74 14                	je     800114 <_main+0xdc>
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	68 e0 1d 80 00       	push   $0x801de0
  800108:	6a 15                	push   $0x15
  80010a:	68 24 1e 80 00       	push   $0x801e24
  80010f:	e8 c0 03 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800114:	a1 20 30 80 00       	mov    0x803020,%eax
  800119:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80011f:	83 c0 60             	add    $0x60,%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012f:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 e0 1d 80 00       	push   $0x801de0
  80013e:	6a 16                	push   $0x16
  800140:	68 24 1e 80 00       	push   $0x801e24
  800145:	e8 8a 03 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014a:	a1 20 30 80 00       	mov    0x803020,%eax
  80014f:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800155:	83 c0 78             	add    $0x78,%eax
  800158:	8b 00                	mov    (%eax),%eax
  80015a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80015d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800165:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016a:	74 14                	je     800180 <_main+0x148>
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	68 e0 1d 80 00       	push   $0x801de0
  800174:	6a 17                	push   $0x17
  800176:	68 24 1e 80 00       	push   $0x801e24
  80017b:	e8 54 03 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800180:	a1 20 30 80 00       	mov    0x803020,%eax
  800185:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018b:	05 90 00 00 00       	add    $0x90,%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800195:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019d:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a2:	74 14                	je     8001b8 <_main+0x180>
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 e0 1d 80 00       	push   $0x801de0
  8001ac:	6a 18                	push   $0x18
  8001ae:	68 24 1e 80 00       	push   $0x801e24
  8001b3:	e8 1c 03 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bd:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c3:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c8:	8b 00                	mov    (%eax),%eax
  8001ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d5:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001da:	74 14                	je     8001f0 <_main+0x1b8>
  8001dc:	83 ec 04             	sub    $0x4,%esp
  8001df:	68 e0 1d 80 00       	push   $0x801de0
  8001e4:	6a 19                	push   $0x19
  8001e6:	68 24 1e 80 00       	push   $0x801e24
  8001eb:	e8 e4 02 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f5:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fb:	05 c0 00 00 00       	add    $0xc0,%eax
  800200:	8b 00                	mov    (%eax),%eax
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800205:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020d:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800212:	74 14                	je     800228 <_main+0x1f0>
  800214:	83 ec 04             	sub    $0x4,%esp
  800217:	68 e0 1d 80 00       	push   $0x801de0
  80021c:	6a 1a                	push   $0x1a
  80021e:	68 24 1e 80 00       	push   $0x801e24
  800223:	e8 ac 02 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800233:	05 d8 00 00 00       	add    $0xd8,%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80023d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800240:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800245:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 e0 1d 80 00       	push   $0x801de0
  800254:	6a 1b                	push   $0x1b
  800256:	68 24 1e 80 00       	push   $0x801e24
  80025b:	e8 74 02 00 00       	call   8004d4 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026b:	05 f0 00 00 00       	add    $0xf0,%eax
  800270:	8b 00                	mov    (%eax),%eax
  800272:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800275:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800278:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800282:	74 14                	je     800298 <_main+0x260>
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 e0 1d 80 00       	push   $0x801de0
  80028c:	6a 1c                	push   $0x1c
  80028e:	68 24 1e 80 00       	push   $0x801e24
  800293:	e8 3c 02 00 00       	call   8004d4 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800298:	a1 20 30 80 00       	mov    0x803020,%eax
  80029d:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a3:	85 c0                	test   %eax,%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 48 1e 80 00       	push   $0x801e48
  8002af:	6a 1d                	push   $0x1d
  8002b1:	68 24 1e 80 00       	push   $0x801e24
  8002b6:	e8 19 02 00 00       	call   8004d4 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8002bb:	e8 3e 13 00 00       	call   8015fe <sys_calculate_free_frames>
  8002c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 d6 13 00 00       	call   80169e <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8002cb:	a0 5f 51 83 00       	mov    0x83515f,%al
  8002d0:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002d3:	a0 5f 61 83 00       	mov    0x83615f,%al
  8002d8:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e2:	eb 37                	jmp    80031b <_main+0x2e3>
	{
		arr[i] = -1 ;
  8002e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e7:	05 60 a1 82 00       	add    $0x82a160,%eax
  8002ec:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f4:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002fa:	8a 12                	mov    (%edx),%dl
  8002fc:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800303:	40                   	inc    %eax
  800304:	a3 00 30 80 00       	mov    %eax,0x803000
  800309:	a1 04 30 80 00       	mov    0x803004,%eax
  80030e:	40                   	inc    %eax
  80030f:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800314:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80031b:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800322:	7e c0                	jle    8002e4 <_main+0x2ac>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800324:	e8 75 13 00 00       	call   80169e <sys_pf_calculate_allocated_pages>
  800329:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80032c:	74 14                	je     800342 <_main+0x30a>
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	68 90 1e 80 00       	push   $0x801e90
  800336:	6a 38                	push   $0x38
  800338:	68 24 1e 80 00       	push   $0x801e24
  80033d:	e8 92 01 00 00       	call   8004d4 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800342:	e8 b7 12 00 00       	call   8015fe <sys_calculate_free_frames>
  800347:	89 c3                	mov    %eax,%ebx
  800349:	e8 c9 12 00 00       	call   801617 <sys_calculate_modified_frames>
  80034e:	01 d8                	add    %ebx,%eax
  800350:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800353:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800356:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800359:	74 14                	je     80036f <_main+0x337>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	68 fc 1e 80 00       	push   $0x801efc
  800363:	6a 3c                	push   $0x3c
  800365:	68 24 1e 80 00       	push   $0x801e24
  80036a:	e8 65 01 00 00       	call   8004d4 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] by REMOVING ONLY ONE PAGE is completed successfully.\n");
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 60 1f 80 00       	push   $0x801f60
  800377:	e8 0c 04 00 00       	call   800788 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	return;
  80037f:	90                   	nop
}
  800380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80038b:	e8 4e 15 00 00       	call   8018de <sys_getenvindex>
  800390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800396:	89 d0                	mov    %edx,%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	01 d0                	add    %edx,%eax
  80039c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003a3:	01 c8                	add    %ecx,%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	01 d0                	add    %edx,%eax
  8003aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003b1:	01 c8                	add    %ecx,%eax
  8003b3:	c1 e0 02             	shl    $0x2,%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c1 e0 02             	shl    $0x2,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c5:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cf:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003d5:	84 c0                	test   %al,%al
  8003d7:	74 0f                	je     8003e8 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	05 18 da 01 00       	add    $0x1da18,%eax
  8003e3:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ec:	7e 0a                	jle    8003f8 <libmain+0x73>
		binaryname = argv[0];
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	ff 75 0c             	pushl  0xc(%ebp)
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	e8 32 fc ff ff       	call   800038 <_main>
  800406:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800409:	e8 dd 12 00 00       	call   8016eb <sys_disable_interrupt>
	cprintf("**************************************\n");
  80040e:	83 ec 0c             	sub    $0xc,%esp
  800411:	68 e4 1f 80 00       	push   $0x801fe4
  800416:	e8 6d 03 00 00       	call   800788 <cprintf>
  80041b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800429:	a1 20 30 80 00       	mov    0x803020,%eax
  80042e:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	68 0c 20 80 00       	push   $0x80200c
  80043e:	e8 45 03 00 00       	call   800788 <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800451:	a1 20 30 80 00       	mov    0x803020,%eax
  800456:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80045c:	a1 20 30 80 00       	mov    0x803020,%eax
  800461:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800467:	51                   	push   %ecx
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	68 34 20 80 00       	push   $0x802034
  80046f:	e8 14 03 00 00       	call   800788 <cprintf>
  800474:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800477:	a1 20 30 80 00       	mov    0x803020,%eax
  80047c:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	50                   	push   %eax
  800486:	68 8c 20 80 00       	push   $0x80208c
  80048b:	e8 f8 02 00 00       	call   800788 <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 e4 1f 80 00       	push   $0x801fe4
  80049b:	e8 e8 02 00 00       	call   800788 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a3:	e8 5d 12 00 00       	call   801705 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004a8:	e8 19 00 00 00       	call   8004c6 <exit>
}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b6:	83 ec 0c             	sub    $0xc,%esp
  8004b9:	6a 00                	push   $0x0
  8004bb:	e8 ea 13 00 00       	call   8018aa <sys_destroy_env>
  8004c0:	83 c4 10             	add    $0x10,%esp
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <exit>:

void
exit(void)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004cc:	e8 3f 14 00 00       	call   801910 <sys_exit_env>
}
  8004d1:	90                   	nop
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004da:	8d 45 10             	lea    0x10(%ebp),%eax
  8004dd:	83 c0 04             	add    $0x4,%eax
  8004e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e3:	a1 58 62 83 00       	mov    0x836258,%eax
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	74 16                	je     800502 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ec:	a1 58 62 83 00       	mov    0x836258,%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	50                   	push   %eax
  8004f5:	68 a0 20 80 00       	push   $0x8020a0
  8004fa:	e8 89 02 00 00       	call   800788 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800502:	a1 08 30 80 00       	mov    0x803008,%eax
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	ff 75 08             	pushl  0x8(%ebp)
  80050d:	50                   	push   %eax
  80050e:	68 a5 20 80 00       	push   $0x8020a5
  800513:	e8 70 02 00 00       	call   800788 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051b:	8b 45 10             	mov    0x10(%ebp),%eax
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 f4             	pushl  -0xc(%ebp)
  800524:	50                   	push   %eax
  800525:	e8 f3 01 00 00       	call   80071d <vcprintf>
  80052a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	6a 00                	push   $0x0
  800532:	68 c1 20 80 00       	push   $0x8020c1
  800537:	e8 e1 01 00 00       	call   80071d <vcprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80053f:	e8 82 ff ff ff       	call   8004c6 <exit>

	// should not return here
	while (1) ;
  800544:	eb fe                	jmp    800544 <_panic+0x70>

00800546 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054c:	a1 20 30 80 00       	mov    0x803020,%eax
  800551:	8b 50 74             	mov    0x74(%eax),%edx
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	39 c2                	cmp    %eax,%edx
  800559:	74 14                	je     80056f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 c4 20 80 00       	push   $0x8020c4
  800563:	6a 26                	push   $0x26
  800565:	68 10 21 80 00       	push   $0x802110
  80056a:	e8 65 ff ff ff       	call   8004d4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80056f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800576:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057d:	e9 c2 00 00 00       	jmp    800644 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800585:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	85 c0                	test   %eax,%eax
  800595:	75 08                	jne    80059f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800597:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059a:	e9 a2 00 00 00       	jmp    800641 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80059f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ad:	eb 69                	jmp    800618 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005af:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bd:	89 d0                	mov    %edx,%eax
  8005bf:	01 c0                	add    %eax,%eax
  8005c1:	01 d0                	add    %edx,%eax
  8005c3:	c1 e0 03             	shl    $0x3,%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8a 40 04             	mov    0x4(%eax),%al
  8005cb:	84 c0                	test   %al,%al
  8005cd:	75 46                	jne    800615 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005dd:	89 d0                	mov    %edx,%eax
  8005df:	01 c0                	add    %eax,%eax
  8005e1:	01 d0                	add    %edx,%eax
  8005e3:	c1 e0 03             	shl    $0x3,%eax
  8005e6:	01 c8                	add    %ecx,%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800608:	39 c2                	cmp    %eax,%edx
  80060a:	75 09                	jne    800615 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800613:	eb 12                	jmp    800627 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800615:	ff 45 e8             	incl   -0x18(%ebp)
  800618:	a1 20 30 80 00       	mov    0x803020,%eax
  80061d:	8b 50 74             	mov    0x74(%eax),%edx
  800620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800623:	39 c2                	cmp    %eax,%edx
  800625:	77 88                	ja     8005af <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062b:	75 14                	jne    800641 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 1c 21 80 00       	push   $0x80211c
  800635:	6a 3a                	push   $0x3a
  800637:	68 10 21 80 00       	push   $0x802110
  80063c:	e8 93 fe ff ff       	call   8004d4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800641:	ff 45 f0             	incl   -0x10(%ebp)
  800644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800647:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064a:	0f 8c 32 ff ff ff    	jl     800582 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800657:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80065e:	eb 26                	jmp    800686 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800660:	a1 20 30 80 00       	mov    0x803020,%eax
  800665:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80066b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066e:	89 d0                	mov    %edx,%eax
  800670:	01 c0                	add    %eax,%eax
  800672:	01 d0                	add    %edx,%eax
  800674:	c1 e0 03             	shl    $0x3,%eax
  800677:	01 c8                	add    %ecx,%eax
  800679:	8a 40 04             	mov    0x4(%eax),%al
  80067c:	3c 01                	cmp    $0x1,%al
  80067e:	75 03                	jne    800683 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800680:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800683:	ff 45 e0             	incl   -0x20(%ebp)
  800686:	a1 20 30 80 00       	mov    0x803020,%eax
  80068b:	8b 50 74             	mov    0x74(%eax),%edx
  80068e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800691:	39 c2                	cmp    %eax,%edx
  800693:	77 cb                	ja     800660 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069b:	74 14                	je     8006b1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	68 70 21 80 00       	push   $0x802170
  8006a5:	6a 44                	push   $0x44
  8006a7:	68 10 21 80 00       	push   $0x802110
  8006ac:	e8 23 fe ff ff       	call   8004d4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b1:	90                   	nop
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c5:	89 0a                	mov    %ecx,(%edx)
  8006c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ca:	88 d1                	mov    %dl,%cl
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006dd:	75 2c                	jne    80070b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006df:	a0 24 30 80 00       	mov    0x803024,%al
  8006e4:	0f b6 c0             	movzbl %al,%eax
  8006e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ea:	8b 12                	mov    (%edx),%edx
  8006ec:	89 d1                	mov    %edx,%ecx
  8006ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f1:	83 c2 08             	add    $0x8,%edx
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	50                   	push   %eax
  8006f8:	51                   	push   %ecx
  8006f9:	52                   	push   %edx
  8006fa:	e8 3e 0e 00 00       	call   80153d <sys_cputs>
  8006ff:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	8b 40 04             	mov    0x4(%eax),%eax
  800711:	8d 50 01             	lea    0x1(%eax),%edx
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071a:	90                   	nop
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    

0080071d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800726:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072d:	00 00 00 
	b.cnt = 0;
  800730:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800737:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	ff 75 08             	pushl  0x8(%ebp)
  800740:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800746:	50                   	push   %eax
  800747:	68 b4 06 80 00       	push   $0x8006b4
  80074c:	e8 11 02 00 00       	call   800962 <vprintfmt>
  800751:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800754:	a0 24 30 80 00       	mov    0x803024,%al
  800759:	0f b6 c0             	movzbl %al,%eax
  80075c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800762:	83 ec 04             	sub    $0x4,%esp
  800765:	50                   	push   %eax
  800766:	52                   	push   %edx
  800767:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076d:	83 c0 08             	add    $0x8,%eax
  800770:	50                   	push   %eax
  800771:	e8 c7 0d 00 00       	call   80153d <sys_cputs>
  800776:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800779:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800780:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <cprintf>:

int cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800795:	8d 45 0c             	lea    0xc(%ebp),%eax
  800798:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a4:	50                   	push   %eax
  8007a5:	e8 73 ff ff ff       	call   80071d <vcprintf>
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bb:	e8 2b 0f 00 00       	call   8016eb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	50                   	push   %eax
  8007d0:	e8 48 ff ff ff       	call   80071d <vcprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007db:	e8 25 0f 00 00       	call   801705 <sys_enable_interrupt>
	return cnt;
  8007e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 14             	sub    $0x14,%esp
  8007ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800803:	77 55                	ja     80085a <printnum+0x75>
  800805:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800808:	72 05                	jb     80080f <printnum+0x2a>
  80080a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080d:	77 4b                	ja     80085a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80080f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800812:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800815:	8b 45 18             	mov    0x18(%ebp),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	52                   	push   %edx
  80081e:	50                   	push   %eax
  80081f:	ff 75 f4             	pushl  -0xc(%ebp)
  800822:	ff 75 f0             	pushl  -0x10(%ebp)
  800825:	e8 46 13 00 00       	call   801b70 <__udivdi3>
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	ff 75 20             	pushl  0x20(%ebp)
  800833:	53                   	push   %ebx
  800834:	ff 75 18             	pushl  0x18(%ebp)
  800837:	52                   	push   %edx
  800838:	50                   	push   %eax
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 a1 ff ff ff       	call   8007e5 <printnum>
  800844:	83 c4 20             	add    $0x20,%esp
  800847:	eb 1a                	jmp    800863 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 20             	pushl  0x20(%ebp)
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	ff d0                	call   *%eax
  800857:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085a:	ff 4d 1c             	decl   0x1c(%ebp)
  80085d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800861:	7f e6                	jg     800849 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800863:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800866:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800871:	53                   	push   %ebx
  800872:	51                   	push   %ecx
  800873:	52                   	push   %edx
  800874:	50                   	push   %eax
  800875:	e8 06 14 00 00       	call   801c80 <__umoddi3>
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be c0             	movsbl %al,%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
}
  800896:	90                   	nop
  800897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a3:	7e 1c                	jle    8008c1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	8d 50 08             	lea    0x8(%eax),%edx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	89 10                	mov    %edx,(%eax)
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	83 e8 08             	sub    $0x8,%eax
  8008ba:	8b 50 04             	mov    0x4(%eax),%edx
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	eb 40                	jmp    800901 <getuint+0x65>
	else if (lflag)
  8008c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c5:	74 1e                	je     8008e5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 50 04             	lea    0x4(%eax),%edx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	89 10                	mov    %edx,(%eax)
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	eb 1c                	jmp    800901 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800906:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090a:	7e 1c                	jle    800928 <getint+0x25>
		return va_arg(*ap, long long);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 08             	lea    0x8(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 08             	sub    $0x8,%eax
  800921:	8b 50 04             	mov    0x4(%eax),%edx
  800924:	8b 00                	mov    (%eax),%eax
  800926:	eb 38                	jmp    800960 <getint+0x5d>
	else if (lflag)
  800928:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092c:	74 1a                	je     800948 <getint+0x45>
		return va_arg(*ap, long);
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	8d 50 04             	lea    0x4(%eax),%edx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	89 10                	mov    %edx,(%eax)
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	83 e8 04             	sub    $0x4,%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	99                   	cltd   
  800946:	eb 18                	jmp    800960 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 50 04             	lea    0x4(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 10                	mov    %edx,(%eax)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	99                   	cltd   
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	eb 17                	jmp    800983 <vprintfmt+0x21>
			if (ch == '\0')
  80096c:	85 db                	test   %ebx,%ebx
  80096e:	0f 84 af 03 00 00    	je     800d23 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	8d 50 01             	lea    0x1(%eax),%edx
  800989:	89 55 10             	mov    %edx,0x10(%ebp)
  80098c:	8a 00                	mov    (%eax),%al
  80098e:	0f b6 d8             	movzbl %al,%ebx
  800991:	83 fb 25             	cmp    $0x25,%ebx
  800994:	75 d6                	jne    80096c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800996:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	8d 50 01             	lea    0x1(%eax),%edx
  8009bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bf:	8a 00                	mov    (%eax),%al
  8009c1:	0f b6 d8             	movzbl %al,%ebx
  8009c4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c7:	83 f8 55             	cmp    $0x55,%eax
  8009ca:	0f 87 2b 03 00 00    	ja     800cfb <vprintfmt+0x399>
  8009d0:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8009d7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009dd:	eb d7                	jmp    8009b6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009df:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e3:	eb d1                	jmp    8009b6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	c1 e0 02             	shl    $0x2,%eax
  8009f4:	01 d0                	add    %edx,%eax
  8009f6:	01 c0                	add    %eax,%eax
  8009f8:	01 d8                	add    %ebx,%eax
  8009fa:	83 e8 30             	sub    $0x30,%eax
  8009fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	8a 00                	mov    (%eax),%al
  800a05:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a08:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0b:	7e 3e                	jle    800a4b <vprintfmt+0xe9>
  800a0d:	83 fb 39             	cmp    $0x39,%ebx
  800a10:	7f 39                	jg     800a4b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a12:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a15:	eb d5                	jmp    8009ec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 e8 04             	sub    $0x4,%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a31:	79 83                	jns    8009b6 <vprintfmt+0x54>
				width = 0;
  800a33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3a:	e9 77 ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a3f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a46:	e9 6b ff ff ff       	jmp    8009b6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a50:	0f 89 60 ff ff ff    	jns    8009b6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a63:	e9 4e ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a68:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6b:	e9 46 ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	83 c0 04             	add    $0x4,%eax
  800a76:	89 45 14             	mov    %eax,0x14(%ebp)
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 e8 04             	sub    $0x4,%eax
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	50                   	push   %eax
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			break;
  800a90:	e9 89 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	83 c0 04             	add    $0x4,%eax
  800a9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 e8 04             	sub    $0x4,%eax
  800aa4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	79 02                	jns    800aac <vprintfmt+0x14a>
				err = -err;
  800aaa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aac:	83 fb 64             	cmp    $0x64,%ebx
  800aaf:	7f 0b                	jg     800abc <vprintfmt+0x15a>
  800ab1:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800ab8:	85 f6                	test   %esi,%esi
  800aba:	75 19                	jne    800ad5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abc:	53                   	push   %ebx
  800abd:	68 e5 23 80 00       	push   $0x8023e5
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 5e 02 00 00       	call   800d2b <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad0:	e9 49 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad5:	56                   	push   %esi
  800ad6:	68 ee 23 80 00       	push   $0x8023ee
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 45 02 00 00       	call   800d2b <printfmt>
  800ae6:	83 c4 10             	add    $0x10,%esp
			break;
  800ae9:	e9 30 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	83 c0 04             	add    $0x4,%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	83 e8 04             	sub    $0x4,%eax
  800afd:	8b 30                	mov    (%eax),%esi
  800aff:	85 f6                	test   %esi,%esi
  800b01:	75 05                	jne    800b08 <vprintfmt+0x1a6>
				p = "(null)";
  800b03:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	7e 6d                	jle    800b7b <vprintfmt+0x219>
  800b0e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b12:	74 67                	je     800b7b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	50                   	push   %eax
  800b1b:	56                   	push   %esi
  800b1c:	e8 0c 03 00 00       	call   800e2d <strnlen>
  800b21:	83 c4 10             	add    $0x10,%esp
  800b24:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b27:	eb 16                	jmp    800b3f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b29:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2d:	83 ec 08             	sub    $0x8,%esp
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	ff d0                	call   *%eax
  800b39:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b43:	7f e4                	jg     800b29 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b45:	eb 34                	jmp    800b7b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4b:	74 1c                	je     800b69 <vprintfmt+0x207>
  800b4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b50:	7e 05                	jle    800b57 <vprintfmt+0x1f5>
  800b52:	83 fb 7e             	cmp    $0x7e,%ebx
  800b55:	7e 12                	jle    800b69 <vprintfmt+0x207>
					putch('?', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	6a 3f                	push   $0x3f
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	53                   	push   %ebx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b78:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7b:	89 f0                	mov    %esi,%eax
  800b7d:	8d 70 01             	lea    0x1(%eax),%esi
  800b80:	8a 00                	mov    (%eax),%al
  800b82:	0f be d8             	movsbl %al,%ebx
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	74 24                	je     800bad <vprintfmt+0x24b>
  800b89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8d:	78 b8                	js     800b47 <vprintfmt+0x1e5>
  800b8f:	ff 4d e0             	decl   -0x20(%ebp)
  800b92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b96:	79 af                	jns    800b47 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b98:	eb 13                	jmp    800bad <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 20                	push   $0x20
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baa:	ff 4d e4             	decl   -0x1c(%ebp)
  800bad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb1:	7f e7                	jg     800b9a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb3:	e9 66 01 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	e8 3c fd ff ff       	call   800903 <getint>
  800bc7:	83 c4 10             	add    $0x10,%esp
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd6:	85 d2                	test   %edx,%edx
  800bd8:	79 23                	jns    800bfd <vprintfmt+0x29b>
				putch('-', putdat);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	6a 2d                	push   $0x2d
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf0:	f7 d8                	neg    %eax
  800bf2:	83 d2 00             	adc    $0x0,%edx
  800bf5:	f7 da                	neg    %edx
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bfd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c04:	e9 bc 00 00 00       	jmp    800cc5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c12:	50                   	push   %eax
  800c13:	e8 84 fc ff ff       	call   80089c <getuint>
  800c18:	83 c4 10             	add    $0x10,%esp
  800c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c28:	e9 98 00 00 00       	jmp    800cc5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	6a 58                	push   $0x58
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	ff d0                	call   *%eax
  800c3a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	6a 58                	push   $0x58
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	6a 58                	push   $0x58
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
			break;
  800c5d:	e9 bc 00 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 30                	push   $0x30
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 78                	push   $0x78
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	83 c0 04             	add    $0x4,%eax
  800c88:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8e:	83 e8 04             	sub    $0x4,%eax
  800c91:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca4:	eb 1f                	jmp    800cc5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 e8             	pushl  -0x18(%ebp)
  800cac:	8d 45 14             	lea    0x14(%ebp),%eax
  800caf:	50                   	push   %eax
  800cb0:	e8 e7 fb ff ff       	call   80089c <getuint>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccc:	83 ec 04             	sub    $0x4,%esp
  800ccf:	52                   	push   %edx
  800cd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	ff 75 08             	pushl  0x8(%ebp)
  800ce0:	e8 00 fb ff ff       	call   8007e5 <printnum>
  800ce5:	83 c4 20             	add    $0x20,%esp
			break;
  800ce8:	eb 34                	jmp    800d1e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	53                   	push   %ebx
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			break;
  800cf9:	eb 23                	jmp    800d1e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	6a 25                	push   $0x25
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0b:	ff 4d 10             	decl   0x10(%ebp)
  800d0e:	eb 03                	jmp    800d13 <vprintfmt+0x3b1>
  800d10:	ff 4d 10             	decl   0x10(%ebp)
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	48                   	dec    %eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3c 25                	cmp    $0x25,%al
  800d1b:	75 f3                	jne    800d10 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1d:	90                   	nop
		}
	}
  800d1e:	e9 47 fc ff ff       	jmp    80096a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d23:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d31:	8d 45 10             	lea    0x10(%ebp),%eax
  800d34:	83 c0 04             	add    $0x4,%eax
  800d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	ff 75 08             	pushl  0x8(%ebp)
  800d47:	e8 16 fc ff ff       	call   800962 <vprintfmt>
  800d4c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4f:	90                   	nop
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8b 40 08             	mov    0x8(%eax),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8b 10                	mov    (%eax),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 40 04             	mov    0x4(%eax),%eax
  800d6f:	39 c2                	cmp    %eax,%edx
  800d71:	73 12                	jae    800d85 <sprintputch+0x33>
		*b->buf++ = ch;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	89 0a                	mov    %ecx,(%edx)
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	88 10                	mov    %dl,(%eax)
}
  800d85:	90                   	nop
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	01 d0                	add    %edx,%eax
  800d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dad:	74 06                	je     800db5 <vsnprintf+0x2d>
  800daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db3:	7f 07                	jg     800dbc <vsnprintf+0x34>
		return -E_INVAL;
  800db5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dba:	eb 20                	jmp    800ddc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbc:	ff 75 14             	pushl  0x14(%ebp)
  800dbf:	ff 75 10             	pushl  0x10(%ebp)
  800dc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc5:	50                   	push   %eax
  800dc6:	68 52 0d 80 00       	push   $0x800d52
  800dcb:	e8 92 fb ff ff       	call   800962 <vprintfmt>
  800dd0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de4:	8d 45 10             	lea    0x10(%ebp),%eax
  800de7:	83 c0 04             	add    $0x4,%eax
  800dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	50                   	push   %eax
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	ff 75 08             	pushl  0x8(%ebp)
  800dfa:	e8 89 ff ff ff       	call   800d88 <vsnprintf>
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e17:	eb 06                	jmp    800e1f <strlen+0x15>
		n++;
  800e19:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 f1                	jne    800e19 <strlen+0xf>
		n++;
	return n;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3a:	eb 09                	jmp    800e45 <strnlen+0x18>
		n++;
  800e3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	ff 4d 0c             	decl   0xc(%ebp)
  800e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e49:	74 09                	je     800e54 <strnlen+0x27>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	84 c0                	test   %al,%al
  800e52:	75 e8                	jne    800e3c <strnlen+0xf>
		n++;
	return n;
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e65:	90                   	nop
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	84 c0                	test   %al,%al
  800e80:	75 e4                	jne    800e66 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9a:	eb 1f                	jmp    800ebb <strncpy+0x34>
		*dst++ = *src;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ea2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	84 c0                	test   %al,%al
  800eb3:	74 03                	je     800eb8 <strncpy+0x31>
			src++;
  800eb5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec1:	72 d9                	jb     800e9c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	74 30                	je     800f0a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eda:	eb 16                	jmp    800ef2 <strlcpy+0x2a>
			*dst++ = *src++;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef2:	ff 4d 10             	decl   0x10(%ebp)
  800ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef9:	74 09                	je     800f04 <strlcpy+0x3c>
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	84 c0                	test   %al,%al
  800f02:	75 d8                	jne    800edc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	29 c2                	sub    %eax,%edx
  800f12:	89 d0                	mov    %edx,%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f19:	eb 06                	jmp    800f21 <strcmp+0xb>
		p++, q++;
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	74 0e                	je     800f38 <strcmp+0x22>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 10                	mov    (%eax),%dl
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	38 c2                	cmp    %al,%dl
  800f36:	74 e3                	je     800f1b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f b6 d0             	movzbl %al,%edx
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f b6 c0             	movzbl %al,%eax
  800f48:	29 c2                	sub    %eax,%edx
  800f4a:	89 d0                	mov    %edx,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f51:	eb 09                	jmp    800f5c <strncmp+0xe>
		n--, p++, q++;
  800f53:	ff 4d 10             	decl   0x10(%ebp)
  800f56:	ff 45 08             	incl   0x8(%ebp)
  800f59:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 17                	je     800f79 <strncmp+0x2b>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	74 0e                	je     800f79 <strncmp+0x2b>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 10                	mov    (%eax),%dl
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	38 c2                	cmp    %al,%dl
  800f77:	74 da                	je     800f53 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 07                	jne    800f86 <strncmp+0x38>
		return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	eb 14                	jmp    800f9a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	0f b6 c0             	movzbl %al,%eax
  800f96:	29 c2                	sub    %eax,%edx
  800f98:	89 d0                	mov    %edx,%eax
}
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 04             	sub    $0x4,%esp
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa8:	eb 12                	jmp    800fbc <strchr+0x20>
		if (*s == c)
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb2:	75 05                	jne    800fb9 <strchr+0x1d>
			return (char *) s;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	eb 11                	jmp    800fca <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb9:	ff 45 08             	incl   0x8(%ebp)
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	84 c0                	test   %al,%al
  800fc3:	75 e5                	jne    800faa <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd8:	eb 0d                	jmp    800fe7 <strfind+0x1b>
		if (*s == c)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe2:	74 0e                	je     800ff2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	84 c0                	test   %al,%al
  800fee:	75 ea                	jne    800fda <strfind+0xe>
  800ff0:	eb 01                	jmp    800ff3 <strfind+0x27>
		if (*s == c)
			break;
  800ff2:	90                   	nop
	return (char *) s;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100a:	eb 0e                	jmp    80101a <memset+0x22>
		*p++ = c;
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801015:	8b 55 0c             	mov    0xc(%ebp),%edx
  801018:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101a:	ff 4d f8             	decl   -0x8(%ebp)
  80101d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801021:	79 e9                	jns    80100c <memset+0x14>
		*p++ = c;

	return v;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103a:	eb 16                	jmp    801052 <memcpy+0x2a>
		*d++ = *s++;
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	8d 50 01             	lea    0x1(%eax),%edx
  801042:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801045:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801048:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80104e:	8a 12                	mov    (%edx),%dl
  801050:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 dd                	jne    80103c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801076:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801079:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107c:	73 50                	jae    8010ce <memmove+0x6a>
  80107e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	01 d0                	add    %edx,%eax
  801086:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801089:	76 43                	jbe    8010ce <memmove+0x6a>
		s += n;
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801091:	8b 45 10             	mov    0x10(%ebp),%eax
  801094:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801097:	eb 10                	jmp    8010a9 <memmove+0x45>
			*--d = *--s;
  801099:	ff 4d f8             	decl   -0x8(%ebp)
  80109c:	ff 4d fc             	decl   -0x4(%ebp)
  80109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a2:	8a 10                	mov    (%eax),%dl
  8010a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010af:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	75 e3                	jne    801099 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b6:	eb 23                	jmp    8010db <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ca:	8a 12                	mov    (%edx),%dl
  8010cc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	75 dd                	jne    8010b8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f2:	eb 2a                	jmp    80111e <memcmp+0x3e>
		if (*s1 != *s2)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 10                	mov    (%eax),%dl
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	38 c2                	cmp    %al,%dl
  801100:	74 16                	je     801118 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f b6 d0             	movzbl %al,%edx
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 c0             	movzbl %al,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	eb 18                	jmp    801130 <memcmp+0x50>
		s1++, s2++;
  801118:	ff 45 fc             	incl   -0x4(%ebp)
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	8d 50 ff             	lea    -0x1(%eax),%edx
  801124:	89 55 10             	mov    %edx,0x10(%ebp)
  801127:	85 c0                	test   %eax,%eax
  801129:	75 c9                	jne    8010f4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801143:	eb 15                	jmp    80115a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	0f b6 c0             	movzbl %al,%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	74 0d                	je     801164 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801157:	ff 45 08             	incl   0x8(%ebp)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801160:	72 e3                	jb     801145 <memfind+0x13>
  801162:	eb 01                	jmp    801165 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801164:	90                   	nop
	return (void *) s;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801170:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801177:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80117e:	eb 03                	jmp    801183 <strtol+0x19>
		s++;
  801180:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 20                	cmp    $0x20,%al
  80118a:	74 f4                	je     801180 <strtol+0x16>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 09                	cmp    $0x9,%al
  801193:	74 eb                	je     801180 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 2b                	cmp    $0x2b,%al
  80119c:	75 05                	jne    8011a3 <strtol+0x39>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	eb 13                	jmp    8011b6 <strtol+0x4c>
	else if (*s == '-')
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	3c 2d                	cmp    $0x2d,%al
  8011aa:	75 0a                	jne    8011b6 <strtol+0x4c>
		s++, neg = 1;
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ba:	74 06                	je     8011c2 <strtol+0x58>
  8011bc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c0:	75 20                	jne    8011e2 <strtol+0x78>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 30                	cmp    $0x30,%al
  8011c9:	75 17                	jne    8011e2 <strtol+0x78>
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	40                   	inc    %eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3c 78                	cmp    $0x78,%al
  8011d3:	75 0d                	jne    8011e2 <strtol+0x78>
		s += 2, base = 16;
  8011d5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011d9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e0:	eb 28                	jmp    80120a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e6:	75 15                	jne    8011fd <strtol+0x93>
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 30                	cmp    $0x30,%al
  8011ef:	75 0c                	jne    8011fd <strtol+0x93>
		s++, base = 8;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fb:	eb 0d                	jmp    80120a <strtol+0xa0>
	else if (base == 0)
  8011fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801201:	75 07                	jne    80120a <strtol+0xa0>
		base = 10;
  801203:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	3c 2f                	cmp    $0x2f,%al
  801211:	7e 19                	jle    80122c <strtol+0xc2>
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 39                	cmp    $0x39,%al
  80121a:	7f 10                	jg     80122c <strtol+0xc2>
			dig = *s - '0';
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	0f be c0             	movsbl %al,%eax
  801224:	83 e8 30             	sub    $0x30,%eax
  801227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122a:	eb 42                	jmp    80126e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	3c 60                	cmp    $0x60,%al
  801233:	7e 19                	jle    80124e <strtol+0xe4>
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 7a                	cmp    $0x7a,%al
  80123c:	7f 10                	jg     80124e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	0f be c0             	movsbl %al,%eax
  801246:	83 e8 57             	sub    $0x57,%eax
  801249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124c:	eb 20                	jmp    80126e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 40                	cmp    $0x40,%al
  801255:	7e 39                	jle    801290 <strtol+0x126>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 5a                	cmp    $0x5a,%al
  80125e:	7f 30                	jg     801290 <strtol+0x126>
			dig = *s - 'A' + 10;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f be c0             	movsbl %al,%eax
  801268:	83 e8 37             	sub    $0x37,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	3b 45 10             	cmp    0x10(%ebp),%eax
  801274:	7d 19                	jge    80128f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801276:	ff 45 08             	incl   0x8(%ebp)
  801279:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801280:	89 c2                	mov    %eax,%edx
  801282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128a:	e9 7b ff ff ff       	jmp    80120a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80128f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801290:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801294:	74 08                	je     80129e <strtol+0x134>
		*endptr = (char *) s;
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80129e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a2:	74 07                	je     8012ab <strtol+0x141>
  8012a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a7:	f7 d8                	neg    %eax
  8012a9:	eb 03                	jmp    8012ae <strtol+0x144>
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c8:	79 13                	jns    8012dd <ltostr+0x2d>
	{
		neg = 1;
  8012ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012da:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e5:	99                   	cltd   
  8012e6:	f7 f9                	idiv   %ecx
  8012e8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ee:	8d 50 01             	lea    0x1(%eax),%edx
  8012f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f4:	89 c2                	mov    %eax,%edx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012fe:	83 c2 30             	add    $0x30,%edx
  801301:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801324:	f7 e9                	imul   %ecx
  801326:	c1 fa 02             	sar    $0x2,%edx
  801329:	89 c8                	mov    %ecx,%eax
  80132b:	c1 f8 1f             	sar    $0x1f,%eax
  80132e:	29 c2                	sub    %eax,%edx
  801330:	89 d0                	mov    %edx,%eax
  801332:	c1 e0 02             	shl    $0x2,%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	01 c0                	add    %eax,%eax
  801339:	29 c1                	sub    %eax,%ecx
  80133b:	89 ca                	mov    %ecx,%edx
  80133d:	85 d2                	test   %edx,%edx
  80133f:	75 9c                	jne    8012dd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	48                   	dec    %eax
  80134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80134f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801353:	74 3d                	je     801392 <ltostr+0xe2>
		start = 1 ;
  801355:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135c:	eb 34                	jmp    801392 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	01 c2                	add    %eax,%edx
  801373:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 c8                	add    %ecx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80137f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138a:	88 02                	mov    %al,(%edx)
		start++ ;
  80138c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80138f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801398:	7c c4                	jl     80135e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a5:	90                   	nop
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ae:	ff 75 08             	pushl  0x8(%ebp)
  8013b1:	e8 54 fa ff ff       	call   800e0a <strlen>
  8013b6:	83 c4 04             	add    $0x4,%esp
  8013b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	e8 46 fa ff ff       	call   800e0a <strlen>
  8013c4:	83 c4 04             	add    $0x4,%esp
  8013c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d8:	eb 17                	jmp    8013f1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	01 c8                	add    %ecx,%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ee:	ff 45 fc             	incl   -0x4(%ebp)
  8013f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f7:	7c e1                	jl     8013da <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801400:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801407:	eb 1f                	jmp    801428 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140c:	8d 50 01             	lea    0x1(%eax),%edx
  80140f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801412:	89 c2                	mov    %eax,%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 c2                	add    %eax,%edx
  801419:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141f:	01 c8                	add    %ecx,%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801425:	ff 45 f8             	incl   -0x8(%ebp)
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142e:	7c d9                	jl     801409 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801430:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	01 d0                	add    %edx,%eax
  801438:	c6 00 00             	movb   $0x0,(%eax)
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801441:	8b 45 14             	mov    0x14(%ebp),%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801461:	eb 0c                	jmp    80146f <strsplit+0x31>
			*string++ = 0;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8d 50 01             	lea    0x1(%eax),%edx
  801469:	89 55 08             	mov    %edx,0x8(%ebp)
  80146c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	84 c0                	test   %al,%al
  801476:	74 18                	je     801490 <strsplit+0x52>
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	0f be c0             	movsbl %al,%eax
  801480:	50                   	push   %eax
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	e8 13 fb ff ff       	call   800f9c <strchr>
  801489:	83 c4 08             	add    $0x8,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	75 d3                	jne    801463 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	84 c0                	test   %al,%al
  801497:	74 5a                	je     8014f3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801499:	8b 45 14             	mov    0x14(%ebp),%eax
  80149c:	8b 00                	mov    (%eax),%eax
  80149e:	83 f8 0f             	cmp    $0xf,%eax
  8014a1:	75 07                	jne    8014aa <strsplit+0x6c>
		{
			return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a8:	eb 66                	jmp    801510 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ad:	8b 00                	mov    (%eax),%eax
  8014af:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b2:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b5:	89 0a                	mov    %ecx,(%edx)
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 c2                	add    %eax,%edx
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c8:	eb 03                	jmp    8014cd <strsplit+0x8f>
			string++;
  8014ca:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	84 c0                	test   %al,%al
  8014d4:	74 8b                	je     801461 <strsplit+0x23>
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	0f be c0             	movsbl %al,%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 b5 fa ff ff       	call   800f9c <strchr>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 dc                	je     8014ca <strsplit+0x8c>
			string++;
	}
  8014ee:	e9 6e ff ff ff       	jmp    801461 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	57                   	push   %edi
  801516:	56                   	push   %esi
  801517:	53                   	push   %ebx
  801518:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801524:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801527:	8b 7d 18             	mov    0x18(%ebp),%edi
  80152a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80152d:	cd 30                	int    $0x30
  80152f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    

0080153d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801549:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	52                   	push   %edx
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	50                   	push   %eax
  801559:	6a 00                	push   $0x0
  80155b:	e8 b2 ff ff ff       	call   801512 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	90                   	nop
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_cgetc>:

int
sys_cgetc(void)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 01                	push   $0x1
  801575:	e8 98 ff ff ff       	call   801512 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	52                   	push   %edx
  80158f:	50                   	push   %eax
  801590:	6a 05                	push   $0x5
  801592:	e8 7b ff ff ff       	call   801512 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	51                   	push   %ecx
  8015b3:	52                   	push   %edx
  8015b4:	50                   	push   %eax
  8015b5:	6a 06                	push   $0x6
  8015b7:	e8 56 ff ff ff       	call   801512 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5e                   	pop    %esi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	52                   	push   %edx
  8015d6:	50                   	push   %eax
  8015d7:	6a 07                	push   $0x7
  8015d9:	e8 34 ff ff ff       	call   801512 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	6a 08                	push   $0x8
  8015f4:	e8 19 ff ff ff       	call   801512 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 09                	push   $0x9
  80160d:	e8 00 ff ff ff       	call   801512 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 0a                	push   $0xa
  801626:	e8 e7 fe ff ff       	call   801512 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 0b                	push   $0xb
  80163f:	e8 ce fe ff ff       	call   801512 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	6a 0f                	push   $0xf
  80165a:	e8 b3 fe ff ff       	call   801512 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
	return;
  801662:	90                   	nop
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	6a 10                	push   $0x10
  801676:	e8 97 fe ff ff       	call   801512 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
	return ;
  80167e:	90                   	nop
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	6a 11                	push   $0x11
  801693:	e8 7a fe ff ff       	call   801512 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
	return ;
  80169b:	90                   	nop
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 0c                	push   $0xc
  8016ad:	e8 60 fe ff ff       	call   801512 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	6a 0d                	push   $0xd
  8016c7:	e8 46 fe ff ff       	call   801512 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 0e                	push   $0xe
  8016e0:	e8 2d fe ff ff       	call   801512 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 13                	push   $0x13
  8016fa:	e8 13 fe ff ff       	call   801512 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 14                	push   $0x14
  801714:	e8 f9 fd ff ff       	call   801512 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	90                   	nop
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_cputc>:


void
sys_cputc(const char c)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80172b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	50                   	push   %eax
  801738:	6a 15                	push   $0x15
  80173a:	e8 d3 fd ff ff       	call   801512 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 16                	push   $0x16
  801754:	e8 b9 fd ff ff       	call   801512 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	90                   	nop
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	50                   	push   %eax
  80176f:	6a 17                	push   $0x17
  801771:	e8 9c fd ff ff       	call   801512 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	52                   	push   %edx
  80178b:	50                   	push   %eax
  80178c:	6a 1a                	push   $0x1a
  80178e:	e8 7f fd ff ff       	call   801512 <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	52                   	push   %edx
  8017a8:	50                   	push   %eax
  8017a9:	6a 18                	push   $0x18
  8017ab:	e8 62 fd ff ff       	call   801512 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 19                	push   $0x19
  8017c9:	e8 44 fd ff ff       	call   801512 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	90                   	nop
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	51                   	push   %ecx
  8017ed:	52                   	push   %edx
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	50                   	push   %eax
  8017f2:	6a 1b                	push   $0x1b
  8017f4:	e8 19 fd ff ff       	call   801512 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801801:	8b 55 0c             	mov    0xc(%ebp),%edx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	52                   	push   %edx
  80180e:	50                   	push   %eax
  80180f:	6a 1c                	push   $0x1c
  801811:	e8 fc fc ff ff       	call   801512 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80181e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801821:	8b 55 0c             	mov    0xc(%ebp),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	51                   	push   %ecx
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 1d                	push   $0x1d
  801830:	e8 dd fc ff ff       	call   801512 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80183d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	6a 1e                	push   $0x1e
  80184d:	e8 c0 fc ff ff       	call   801512 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 1f                	push   $0x1f
  801866:	e8 a7 fc ff ff       	call   801512 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	ff 75 14             	pushl  0x14(%ebp)
  80187b:	ff 75 10             	pushl  0x10(%ebp)
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	50                   	push   %eax
  801882:	6a 20                	push   $0x20
  801884:	e8 89 fc ff ff       	call   801512 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	50                   	push   %eax
  80189d:	6a 21                	push   $0x21
  80189f:	e8 6e fc ff ff       	call   801512 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	50                   	push   %eax
  8018b9:	6a 22                	push   $0x22
  8018bb:	e8 52 fc ff ff       	call   801512 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 02                	push   $0x2
  8018d4:	e8 39 fc ff ff       	call   801512 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 03                	push   $0x3
  8018ed:	e8 20 fc ff ff       	call   801512 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 04                	push   $0x4
  801906:	e8 07 fc ff ff       	call   801512 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_exit_env>:


void sys_exit_env(void)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 23                	push   $0x23
  80191f:	e8 ee fb ff ff       	call   801512 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801930:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801933:	8d 50 04             	lea    0x4(%eax),%edx
  801936:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	50                   	push   %eax
  801941:	6a 24                	push   $0x24
  801943:	e8 ca fb ff ff       	call   801512 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return result;
  80194b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801951:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801954:	89 01                	mov    %eax,(%ecx)
  801956:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	c9                   	leave  
  80195d:	c2 04 00             	ret    $0x4

00801960 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 10             	pushl  0x10(%ebp)
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 12                	push   $0x12
  801972:	e8 9b fb ff ff       	call   801512 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return ;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_rcr2>:
uint32 sys_rcr2()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 25                	push   $0x25
  80198c:	e8 81 fb ff ff       	call   801512 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	50                   	push   %eax
  8019af:	6a 26                	push   $0x26
  8019b1:	e8 5c fb ff ff       	call   801512 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b9:	90                   	nop
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <rsttst>:
void rsttst()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 28                	push   $0x28
  8019cb:	e8 42 fb ff ff       	call   801512 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d3:	90                   	nop
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8019e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e9:	52                   	push   %edx
  8019ea:	50                   	push   %eax
  8019eb:	ff 75 10             	pushl  0x10(%ebp)
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 27                	push   $0x27
  8019f6:	e8 17 fb ff ff       	call   801512 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <chktst>:
void chktst(uint32 n)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	6a 29                	push   $0x29
  801a11:	e8 fc fa ff ff       	call   801512 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return ;
  801a19:	90                   	nop
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <inctst>:

void inctst()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 2a                	push   $0x2a
  801a2b:	e8 e2 fa ff ff       	call   801512 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return ;
  801a33:	90                   	nop
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <gettst>:
uint32 gettst()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 2b                	push   $0x2b
  801a45:	e8 c8 fa ff ff       	call   801512 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 2c                	push   $0x2c
  801a61:	e8 ac fa ff ff       	call   801512 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
  801a69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a6c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a70:	75 07                	jne    801a79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a72:	b8 01 00 00 00       	mov    $0x1,%eax
  801a77:	eb 05                	jmp    801a7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 2c                	push   $0x2c
  801a92:	e8 7b fa ff ff       	call   801512 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
  801a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a9d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aa1:	75 07                	jne    801aaa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa8:	eb 05                	jmp    801aaf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 2c                	push   $0x2c
  801ac3:	e8 4a fa ff ff       	call   801512 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
  801acb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ace:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ad2:	75 07                	jne    801adb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ad4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad9:	eb 05                	jmp    801ae0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 2c                	push   $0x2c
  801af4:	e8 19 fa ff ff       	call   801512 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
  801afc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b03:	75 07                	jne    801b0c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b05:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0a:	eb 05                	jmp    801b11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	6a 2d                	push   $0x2d
  801b23:	e8 ea f9 ff ff       	call   801512 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2b:	90                   	nop
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	53                   	push   %ebx
  801b41:	51                   	push   %ecx
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 2e                	push   $0x2e
  801b46:	e8 c7 f9 ff ff       	call   801512 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 2f                	push   $0x2f
  801b66:	e8 a7 f9 ff ff       	call   801512 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <__udivdi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b87:	89 ca                	mov    %ecx,%edx
  801b89:	89 f8                	mov    %edi,%eax
  801b8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	75 2d                	jne    801bc0 <__udivdi3+0x50>
  801b93:	39 cf                	cmp    %ecx,%edi
  801b95:	77 65                	ja     801bfc <__udivdi3+0x8c>
  801b97:	89 fd                	mov    %edi,%ebp
  801b99:	85 ff                	test   %edi,%edi
  801b9b:	75 0b                	jne    801ba8 <__udivdi3+0x38>
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	31 d2                	xor    %edx,%edx
  801ba4:	f7 f7                	div    %edi
  801ba6:	89 c5                	mov    %eax,%ebp
  801ba8:	31 d2                	xor    %edx,%edx
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	f7 f5                	div    %ebp
  801bae:	89 c1                	mov    %eax,%ecx
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f5                	div    %ebp
  801bb4:	89 cf                	mov    %ecx,%edi
  801bb6:	89 fa                	mov    %edi,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 ce                	cmp    %ecx,%esi
  801bc2:	77 28                	ja     801bec <__udivdi3+0x7c>
  801bc4:	0f bd fe             	bsr    %esi,%edi
  801bc7:	83 f7 1f             	xor    $0x1f,%edi
  801bca:	75 40                	jne    801c0c <__udivdi3+0x9c>
  801bcc:	39 ce                	cmp    %ecx,%esi
  801bce:	72 0a                	jb     801bda <__udivdi3+0x6a>
  801bd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd4:	0f 87 9e 00 00 00    	ja     801c78 <__udivdi3+0x108>
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	89 fa                	mov    %edi,%edx
  801be1:	83 c4 1c             	add    $0x1c,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
  801be9:	8d 76 00             	lea    0x0(%esi),%esi
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	31 c0                	xor    %eax,%eax
  801bf0:	89 fa                	mov    %edi,%edx
  801bf2:	83 c4 1c             	add    $0x1c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f7                	div    %edi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c11:	89 eb                	mov    %ebp,%ebx
  801c13:	29 fb                	sub    %edi,%ebx
  801c15:	89 f9                	mov    %edi,%ecx
  801c17:	d3 e6                	shl    %cl,%esi
  801c19:	89 c5                	mov    %eax,%ebp
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 ed                	shr    %cl,%ebp
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	09 f1                	or     %esi,%ecx
  801c23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c27:	89 f9                	mov    %edi,%ecx
  801c29:	d3 e0                	shl    %cl,%eax
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ee                	shr    %cl,%esi
  801c33:	89 f9                	mov    %edi,%ecx
  801c35:	d3 e2                	shl    %cl,%edx
  801c37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 e8                	shr    %cl,%eax
  801c3f:	09 c2                	or     %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	f7 74 24 0c          	divl   0xc(%esp)
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	f7 e5                	mul    %ebp
  801c4f:	39 d6                	cmp    %edx,%esi
  801c51:	72 19                	jb     801c6c <__udivdi3+0xfc>
  801c53:	74 0b                	je     801c60 <__udivdi3+0xf0>
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	31 ff                	xor    %edi,%edi
  801c59:	e9 58 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c64:	89 f9                	mov    %edi,%ecx
  801c66:	d3 e2                	shl    %cl,%edx
  801c68:	39 c2                	cmp    %eax,%edx
  801c6a:	73 e9                	jae    801c55 <__udivdi3+0xe5>
  801c6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 40 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	31 c0                	xor    %eax,%eax
  801c7a:	e9 37 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c7f:	90                   	nop

00801c80 <__umoddi3>:
  801c80:	55                   	push   %ebp
  801c81:	57                   	push   %edi
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9f:	89 f3                	mov    %esi,%ebx
  801ca1:	89 fa                	mov    %edi,%edx
  801ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca7:	89 34 24             	mov    %esi,(%esp)
  801caa:	85 c0                	test   %eax,%eax
  801cac:	75 1a                	jne    801cc8 <__umoddi3+0x48>
  801cae:	39 f7                	cmp    %esi,%edi
  801cb0:	0f 86 a2 00 00 00    	jbe    801d58 <__umoddi3+0xd8>
  801cb6:	89 c8                	mov    %ecx,%eax
  801cb8:	89 f2                	mov    %esi,%edx
  801cba:	f7 f7                	div    %edi
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	31 d2                	xor    %edx,%edx
  801cc0:	83 c4 1c             	add    $0x1c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
  801cc8:	39 f0                	cmp    %esi,%eax
  801cca:	0f 87 ac 00 00 00    	ja     801d7c <__umoddi3+0xfc>
  801cd0:	0f bd e8             	bsr    %eax,%ebp
  801cd3:	83 f5 1f             	xor    $0x1f,%ebp
  801cd6:	0f 84 ac 00 00 00    	je     801d88 <__umoddi3+0x108>
  801cdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce1:	29 ef                	sub    %ebp,%edi
  801ce3:	89 fe                	mov    %edi,%esi
  801ce5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 e0                	shl    %cl,%eax
  801ced:	89 d7                	mov    %edx,%edi
  801cef:	89 f1                	mov    %esi,%ecx
  801cf1:	d3 ef                	shr    %cl,%edi
  801cf3:	09 c7                	or     %eax,%edi
  801cf5:	89 e9                	mov    %ebp,%ecx
  801cf7:	d3 e2                	shl    %cl,%edx
  801cf9:	89 14 24             	mov    %edx,(%esp)
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	d3 e0                	shl    %cl,%eax
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d10:	89 f1                	mov    %esi,%ecx
  801d12:	d3 e8                	shr    %cl,%eax
  801d14:	09 d0                	or     %edx,%eax
  801d16:	d3 eb                	shr    %cl,%ebx
  801d18:	89 da                	mov    %ebx,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d3                	mov    %edx,%ebx
  801d1e:	f7 24 24             	mull   (%esp)
  801d21:	89 c6                	mov    %eax,%esi
  801d23:	89 d1                	mov    %edx,%ecx
  801d25:	39 d3                	cmp    %edx,%ebx
  801d27:	0f 82 87 00 00 00    	jb     801db4 <__umoddi3+0x134>
  801d2d:	0f 84 91 00 00 00    	je     801dc4 <__umoddi3+0x144>
  801d33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d37:	29 f2                	sub    %esi,%edx
  801d39:	19 cb                	sbb    %ecx,%ebx
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 e9                	mov    %ebp,%ecx
  801d45:	d3 ea                	shr    %cl,%edx
  801d47:	09 d0                	or     %edx,%eax
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 eb                	shr    %cl,%ebx
  801d4d:	89 da                	mov    %ebx,%edx
  801d4f:	83 c4 1c             	add    $0x1c,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
  801d57:	90                   	nop
  801d58:	89 fd                	mov    %edi,%ebp
  801d5a:	85 ff                	test   %edi,%edi
  801d5c:	75 0b                	jne    801d69 <__umoddi3+0xe9>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f7                	div    %edi
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 c8                	mov    %ecx,%eax
  801d71:	f7 f5                	div    %ebp
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	e9 44 ff ff ff       	jmp    801cbe <__umoddi3+0x3e>
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	89 c8                	mov    %ecx,%eax
  801d7e:	89 f2                	mov    %esi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	3b 04 24             	cmp    (%esp),%eax
  801d8b:	72 06                	jb     801d93 <__umoddi3+0x113>
  801d8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d91:	77 0f                	ja     801da2 <__umoddi3+0x122>
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	29 f9                	sub    %edi,%ecx
  801d97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9b:	89 14 24             	mov    %edx,(%esp)
  801d9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da6:	8b 14 24             	mov    (%esp),%edx
  801da9:	83 c4 1c             	add    $0x1c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    
  801db1:	8d 76 00             	lea    0x0(%esi),%esi
  801db4:	2b 04 24             	sub    (%esp),%eax
  801db7:	19 fa                	sbb    %edi,%edx
  801db9:	89 d1                	mov    %edx,%ecx
  801dbb:	89 c6                	mov    %eax,%esi
  801dbd:	e9 71 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc8:	72 ea                	jb     801db4 <__umoddi3+0x134>
  801dca:	89 d9                	mov    %ebx,%ecx
  801dcc:	e9 62 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
